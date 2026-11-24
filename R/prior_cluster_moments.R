#' Prior expected number of occupied groups
#'
#' Compute the expected number of occupied groups among `n` items under a
#' Gnedin, Dirichlet-process, Pitman--Yor or Dirichlet--multinomial prior.
#' For the Dirichlet--multinomial, the constructor's concentration is per group;
#' the moment calculation uses total concentration internally.
#' @param n Positive integer number of items.
#' @param prior A partition prior returned by a clustering-prior constructor.
#' @return A numeric scalar.
#' @references Legramanti, S., Rigon, T., Durante, D. and Dunson, D. B. (2022).
#'   Extended stochastic block models with application to criminal networks.
#'   The Annals of Applied Statistics, 16. The DP/PY/DM mean calculation follows
#'   the accompanying ESBM expected_cl_py helper.
#'   <https://github.com/danieledurante/ESBM/blob/master/Source/esbm.R>
#' @export
#' @examples
#' prior_mean_K(n = 10, prior = gnedin_prior(0.5))
prior_mean_K <- function(n, prior) {
  .check_prior_moment_inputs(n, prior)
  switch(prior$type,
    gnedin = gnedin_K_mean(n, prior$gamma),
    dp = expected_cl_py(n, sigma = 0, theta = prior$alpha, K_DM = Inf),
    py = expected_cl_py(n, sigma = prior$sigma, theta = prior$alpha, K_DM = Inf),
    dm = if (prior$K == 1) 1 else expected_cl_py(
      n, sigma = 0, theta = prior$K * prior$beta, K_DM = prior$K)
  )
}

#' Prior variance of the number of occupied groups
#'
#' Compute the variance for Gnedin and Dirichlet-process priors. Variances for
#' Pitman--Yor and Dirichlet--multinomial priors are not implemented here.
#' @inheritParams prior_mean_K
#' @return A numeric scalar, or `NA_real_` for Pitman--Yor and
#'   Dirichlet--multinomial priors.
#' @export
#' @examples
#' prior_variance_K(n = 10, prior = gnedin_prior(0.5))
prior_variance_K <- function(n, prior) {
  .check_prior_moment_inputs(n, prior)
  if (prior$type == "gnedin") return(gnedin_K_var(n, prior$gamma))
  if (prior$type == "dp") return(dirichlet_process_K_var(n, prior$alpha))
  NA_real_
}

#' Simulate the prior number of occupied groups
#'
#' Generate independent draws of `K_n` before observing outcomes. Starting
#' with one occupied group, each further item either joins an existing group
#' or creates a new one, using the specified partition prior's predictive
#' probability. Only the count is simulated, not the complete partition.
#' Every draw lies between 1 and `n`; a Dirichlet--multinomial prior also
#' respects its maximum number of groups.
#'
#' @inheritParams prior_mean_K
#' @param draws Positive integer number of independent simulations.
#' @param seed Optional integer seed. If supplied, calls [set.seed()].
#' @return An integer vector of length `draws`.
#' @references Gnedin, A. (2010). A species sampling model with finitely many
#'   types. Electronic Communications in Probability, 15, 79--88.
#'   \doi{10.1214/ECP.v15-1532}
#' @export
#' @examples
#' K <- prior_sample_K(20, gnedin_prior(0.5), draws = 1000, seed = 31)
#' c(simulated = mean(K), exact = prior_mean_K(20, gnedin_prior(0.5)))
prior_sample_K <- function(n, prior, draws = 10000L, seed = NULL) {
  .check_prior_moment_inputs(n, prior)
  if (!is.numeric(draws) || length(draws) != 1L || !is.finite(draws) ||
      draws < 1 || draws != floor(draws)) {
    stop("`draws` must be one positive integer.", call. = FALSE)
  }
  if (!is.null(seed)) set.seed(seed)
  K <- rep.int(1L, draws)
  for (m in seq_len(n - 1L)) {
    new_group <- switch(prior$type,
      gnedin = K * (K - prior$gamma) / (m * (m + prior$gamma)),
      dp = rep(prior$alpha / (m + prior$alpha), draws),
      py = (prior$alpha + K * prior$sigma) / (m + prior$alpha),
      dm = prior$beta * (prior$K - K) / (m + prior$K * prior$beta))
    K <- K + stats::rbinom(draws, size = 1L, prob = new_group)
  }
  as.integer(K)
}

.check_prior_moment_inputs <- function(n, prior) {
  if (!is.numeric(n) || length(n) != 1L || !is.finite(n) ||
      n < 1 || n != floor(n)) {
    stop("`n` must be one positive integer.", call. = FALSE)
  }
  if (!inherits(prior, "btsbm_partition_prior") ||
      !prior$type %in% c("gnedin", "dp", "py", "dm")) {
    stop("`prior` must be created by a clustering-prior constructor.", call. = FALSE)
  }
  invisible(NULL)
}
