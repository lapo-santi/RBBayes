#' Convert a preference fit to a matrix of saved posterior draws
#'
#' Columns q[i] are item strengths divided by their sum in each saved draw.
#' With normalise = FALSE, theta[i] are the stored, unnormalised strengths.
#' The index i follows fit$data$item_labels. K_item and K_ranking contain
#' occupied-group counts when available. Only retained draws are returned.
#'
#' Variable-length block-strength vectors and arbitrary allocation labels are
#' deliberately excluded. Mixture and LBM fits currently expose group counts
#' only, because a single profile-independent item-strength vector is absent.
#' @param x A btsbm_fit object.
#' @param ... Reserved for generic compatibility.
#' @param normalise Logical; report sum-to-one item strengths by default.
#' @param pars Optional character vector selecting and ordering columns.
#' @return A numeric matrix with saved draws in rows and quantities in columns.
#' @export
as.matrix.btsbm_fit <- function(x, ..., normalise = TRUE, pars = NULL) {
  if (!is.logical(normalise) || length(normalise) != 1L || is.na(normalise)) {
    stop("`normalise` must be TRUE or FALSE.", call. = FALSE)
  }
  n_draws <- .fit_n_draws(x)
  result <- matrix(numeric(), nrow = n_draws, ncol = 0L)
  strength <- x$draws$item_strength
  if (!is.null(strength)) {
    strength <- as.matrix(strength)
    if (nrow(strength) != n_draws || any(!is.finite(strength)) || any(strength <= 0)) {
      stop("Item-strength draws must be finite, positive and match the saved draws.", call. = FALSE)
    }
    if (normalise) strength <- strength / rowSums(strength)
    colnames(strength) <- paste0(if (normalise) "q[" else "theta[",
                                seq_len(ncol(strength)), "]")
    result <- cbind(result, strength)
  }
  for (count in c("n_item_clusters", "n_ranking_clusters")) {
    values <- x$draws[[count]]
    if (!is.null(values)) {
      if (length(values) != n_draws || any(!is.finite(values))) {
        stop("Group-count draws must be finite and match the saved draws.", call. = FALSE)
      }
      column <- matrix(values, ncol = 1L)
      colnames(column) <- if (count == "n_item_clusters") "K_item" else "K_ranking"
      result <- cbind(result, column)
    }
  }
  if (ncol(result) == 0L) stop("No fixed-dimensional posterior quantities are available.", call. = FALSE)
  if (!is.null(pars)) {
    if (!is.character(pars) || !length(pars) || anyNA(pars) || anyDuplicated(pars) ||
        any(!pars %in% colnames(result))) {
      stop("`pars` must select distinct available parameter names: ",
           paste(colnames(result), collapse = ", "), call. = FALSE)
    }
    result <- result[, pars, drop = FALSE]
  }
  result
}

#' Convert one fit to a bayesplot-compatible array
#' @inheritParams as.matrix.btsbm_fit
#' @return An array with dimensions iteration, chain, parameter. A single fit
#'   contains one chain. Warm-up is already excluded.
#' @export
as.array.btsbm_fit <- function(x, ..., normalise = TRUE, pars = NULL) {
  as_draws_array(x, normalise = normalise, pars = pars)
}

#' Combine preference-model draws without merging chains
#'
#' All fits must use identical data (including item order) and model
#' specification, and have the same number of retained draws. The caller must
#' supply independently run chains, preferably with different seeds and
#' initialisations; these converters cannot establish independence.
#' @param x One btsbm_fit, or a non-empty list of fits from independent runs.
#' @param normalise Logical; report sum-to-one item strengths by default.
#' @param pars Optional parameter names, as in as.matrix.btsbm_fit().
#' @return as_draws_array returns an iteration by chain by parameter array.
#'   as_mcmc_chains returns a coda mcmc.list, retaining original iteration
#'   numbering. Its chains must also have equal warm-up lengths.
#' @export
as_draws_array <- function(x, normalise = TRUE, pars = NULL) {
  fits <- .compatible_mcmc_fits(x)
  matrices <- lapply(fits, as.matrix, normalise = normalise, pars = pars)
  reference <- matrices[[1L]]
  if (!all(vapply(matrices, function(m) identical(dim(m), dim(reference)) &&
                  identical(colnames(m), colnames(reference)), logical(1)))) {
    stop("Chains must have equal retained lengths and matching parameters.", call. = FALSE)
  }
  result <- array(NA_real_, dim = c(nrow(reference), length(fits), ncol(reference)),
                  dimnames = list(iteration = NULL,
                    chain = paste0("chain", seq_along(fits)),
                    parameter = colnames(reference)))
  for (chain in seq_along(fits)) result[, chain, ] <- matrices[[chain]]
  result
}

.compatible_mcmc_fits <- function(x) {
  fits <- if (inherits(x, "btsbm_fit")) list(x) else x
  if (!is.list(fits) || !length(fits) ||
      !all(vapply(fits, inherits, logical(1), "btsbm_fit"))) {
    stop("`x` must be a fit or a non-empty list of fits.", call. = FALSE)
  }
  reference <- fits[[1L]]
  same <- vapply(fits, function(fit) identical(fit$data, reference$data) &&
                   identical(fit$model, reference$model), logical(1))
  if (!all(same)) stop("Chains must have identical data, item order and model specification.", call. = FALSE)
  fits
}

#' Convert a preference fit for coda diagnostics
#' @inheritParams as.matrix.btsbm_fit
#' @return A coda mcmc object. Its first iteration is warmup + 1 and thin is 1.
#' @exportS3Method coda::as.mcmc
as.mcmc.btsbm_fit <- function(x, ..., normalise = TRUE, pars = NULL) {
  if (!requireNamespace("coda", quietly = TRUE)) {
    stop("Install 'coda' to convert a fit to an mcmc object.", call. = FALSE)
  }
  coda::mcmc(as.matrix(x, normalise = normalise, pars = pars),
             start = x$control$warmup + 1L, thin = 1L)
}

#' @rdname as.mcmc.btsbm_fit
#' @exportS3Method coda::as.mcmc.list
as.mcmc.list.btsbm_fit <- function(x, ..., normalise = TRUE, pars = NULL) {
  as_mcmc_chains(x, normalise = normalise, pars = pars)
}

#' @rdname as_draws_array
#' @export
as_mcmc_chains <- function(x, normalise = TRUE, pars = NULL) {
  if (!requireNamespace("coda", quietly = TRUE)) {
    stop("Install 'coda' to combine mcmc chains.", call. = FALSE)
  }
  fits <- .compatible_mcmc_fits(x)
  # Validate length and parameter compatibility before constructing mcmc.list.
  as_draws_array(fits, normalise = normalise, pars = pars)
  warmup <- vapply(fits, function(fit) fit$control$warmup, numeric(1))
  if (length(unique(warmup)) != 1L) {
    stop("coda chains must have equal warm-up lengths to preserve iteration numbering.", call. = FALSE)
  }
  chains <- lapply(fits, as.mcmc.btsbm_fit, normalise = normalise, pars = pars)
  do.call(coda::mcmc.list, chains)
}
