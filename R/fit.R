#' Fit a Bayesian Bradley--Terry or Plackett--Luce model
#'
#' `fit_model()` is the common fitting entry point.  This first implementation
#' supports simple BT, BT--SBM, simple PL, PL--SBM, PL ranking mixtures, and
#' PL--LBM. The latter two start with readable R Gibbs kernels derived from the
#' PLuce exponential-race architecture; their high-performance C++ kernels are
#' a later parity-tested optimisation.
#'
#' @param data A `btsbm_pairwise_data` or `btsbm_ranking_data` object created
#'   by [as_bt_data()] or [as_rankings()].
#' @param model A `btsbm_model` object.
#' @param control A `btsbm_mcmc_control` object.
#'
#' @return An object of class `btsbm_fit`.
#' @references Caron, F. and Doucet, A. (2012). Efficient Bayesian inference
#'   for generalized Bradley--Terry models. *Journal of Computational and
#'   Graphical Statistics*, 21(1), 174--196.
#'   \doi{10.1080/10618600.2012.638220}
#' @export
fit_model <- function(data, model, control = mcmc_control()) {
  if (!inherits(model, "btsbm_model")) {
    stop("`model` must be created by a model constructor such as `pl_model()`.", call. = FALSE)
  }
  if (!inherits(control, "btsbm_mcmc_control")) {
    stop("`control` must be created by `mcmc_control()`.", call. = FALSE)
  }
  if (!is.null(control$seed)) set.seed(control$seed)

  started <- proc.time()[["elapsed"]]
  fit <- if (model$likelihood == "bt") {
    if (!inherits(data, "btsbm_pairwise_data")) {
      stop("BT models require data created by `as_bt_data()`.", call. = FALSE)
    }
    .fit_bt_model(data, model, control)
  } else {
    if (!inherits(data, "btsbm_ranking_data")) {
      stop("PL models require data created by `as_rankings()`.", call. = FALSE)
    }
    .fit_pl_model(data, model, control)
  }
  fit$elapsed <- proc.time()[["elapsed"]] - started
  fit$call <- match.call()
  fit$data <- data
  fit$model <- model
  fit$control <- control
  class(fit) <- "btsbm_fit"
  fit
}

.new_fit <- function(draws, diagnostics = list()) {
  list(
    call = NULL,
    data = NULL,
    model = NULL,
    control = NULL,
    draws = draws,
    diagnostics = diagnostics,
    elapsed = NA_real_
  )
}

.fit_bt_model <- function(data, model, control) {
  prior <- model$latent_strength
  if (model$structure == "none") {
    raw <- gibbs_bt_simple(
      w_ij = data$wins,
      a = prior$shape,
      b = prior$rate,
      T_iter = control$iter,
      T_burn = control$warmup,
      verbose = control$verbose
    )
    return(.new_fit(draws = list(
      latent_strength = raw$lambda_samples,
      item_strength = raw$lambda_samples,
      # Compatibility aliases, superseded by latent_strength/item_strength.
      ability = raw$lambda_samples,
      item_ability = raw$lambda_samples
    )))
  }
  if (model$structure != "item_sbm") {
    stop("This BT structure is not implemented yet.", call. = FALSE)
  }

  legacy <- .legacy_partition_arguments(model$item_clustering)
  raw <- gibbs_bt_sbm(
    w_ij = data$wins,
    a = prior$shape,
    b = prior$rate,
    prior = legacy$prior,
    alpha_PY = legacy$alpha_PY,
    sigma_PY = legacy$sigma_PY,
    beta_DM = legacy$beta_DM,
    K_DM = legacy$K_DM,
    gamma_GN = legacy$gamma_GN,
    T_iter = control$iter,
    T_burn = control$warmup,
    init_x = control$init_item_cluster,
    store_z = identical(control$store, "augmented"),
    verbose = control$verbose
  )
  implied <- .implied_ability_from_blocks(raw$x_samples, raw$lambda_samples)
  .new_fit(
    draws = list(
      item_cluster = raw$x_samples,
      n_item_clusters = raw$K_per_iter,
      latent_strength = raw$lambda_samples,
      item_strength = implied,
      ability = raw$lambda_samples,
      item_ability = implied,
      augmented = raw$z_samples
    )
  )
}

.legacy_partition_arguments <- function(prior) {
  out <- list(
    prior = switch(prior$type, gnedin = "GN", dp = "DP", py = "PY", dm = "DM"),
    alpha_PY = NA_real_, sigma_PY = NA_real_, beta_DM = NA_real_,
    K_DM = NA_integer_, gamma_GN = NA_real_
  )
  if (prior$type == "gnedin") out$gamma_GN <- prior$gamma
  if (prior$type == "dp") out$alpha_PY <- prior$alpha
  if (prior$type == "py") {
    out$alpha_PY <- prior$alpha
    out$sigma_PY <- prior$sigma
  }
  if (prior$type == "dm") {
    out$beta_DM <- prior$beta
    out$K_DM <- prior$K
  }
  out
}

.model_long_name <- function(model) {
  if (model$likelihood == "bt") {
    if (model$structure == "none") "Bradley-Terry (BT), one strength per item"
    else "Bradley-Terry stochastic block model (BT-SBM), items share block strengths"
  } else {
    switch(model$structure,
           none = "Plackett-Luce (PL), one strength per item",
           item_sbm = "Plackett-Luce stochastic block model (PL-SBM)",
           ranking_mixture = "Plackett-Luce mixture over ranking groups",
           lbm = "Plackett-Luce latent block model (PL-LBM)",
           model$structure)
  }
}

.model_short_name <- function(model) {
  if (model$likelihood == "bt") {
    if (model$structure == "none") "BT" else "BT-SBM"
  } else {
    switch(model$structure, none = "PL", item_sbm = "PL-SBM",
           ranking_mixture = "PL mixture", lbm = "PL-LBM", model$structure)
  }
}

.prior_description <- function(prior) {
  if (is.null(prior)) return(NULL)
  switch(prior$type,
         gnedin = sprintf("Gnedin(gnedin_hyper = %g)", prior$gamma),
         dp = sprintf("Dirichlet process(concentration = %g)", prior$alpha),
         py = sprintf("Pitman-Yor(concentration = %g, discount = %g)", prior$alpha, prior$sigma),
         dm = sprintf("Dirichlet-multinomial(max_clusters = %d, concentration = %g)",
                      prior$K, prior$beta))
}

#' Print an RBBayes fit
#' @param x A `btsbm_fit` object.
#' @param ... Unused.
#' @return The input object, invisibly.
#' @export
print.btsbm_fit <- function(x, ...) {
  cat("<btsbm_fit>", .model_long_name(x$model), "\n")
  cat("  ", x$data$n_items, " items; ", .fit_n_draws(x),
      " retained posterior draws. Use summary() for results.\n", sep = "")
  invisible(x)
}

#' Summarise an RBBayes fit
#'
#' Collects the main features of a fit under self-explanatory names: the
#' model, the data size, the priors, the MCMC run and the key posterior
#' results. For models with item-specific strengths, the strength table uses
#' relative strengths (each strength divided by the sum of all strengths in a
#' draw). For block models, it reports the posterior distribution of the number
#' of blocks \eqn{K} and the point estimate of the partition \eqn{z} instead,
#' because individual strengths are not the natural summary there.
#'
#' @param object A `btsbm_fit` object.
#' @param credible_mass Width of the reported credible intervals.
#' @param ... Unused.
#' @return An object of class `summary.btsbm_fit`, a named list.
#' @export
summary.btsbm_fit <- function(object, credible_mass = 0.9, ...) {
  fit <- object
  model <- fit$model
  data <- fit$data
  out <- list(
    model = .model_short_name(model),
    model_description = .model_long_name(model),
    likelihood = switch(model$likelihood, bt = "Bradley-Terry", pl = "Plackett-Luce"),
    item_structure = switch(model$structure, none = "item-specific strengths",
                            item_sbm = "latent item blocks",
                            ranking_mixture = "latent ranking groups",
                            lbm = "latent ranking groups and item blocks"),
    n_items = data$n_items,
    strength_prior = sprintf("%s ~ iid Gamma(shape = %s, rate = %s)",
                             if (model$structure == "none") "lambda_i" else "lambda_k",
                             signif(model$latent_strength$shape, 4),
                             signif(model$latent_strength$rate, 4)),
    item_partition_prior = .prior_description(model$item_clustering),
    ranking_partition_prior = .prior_description(model$ranking_clustering),
    mcmc_iterations = fit$control$iter,
    mcmc_warmup = fit$control$warmup,
    retained_draws = .fit_n_draws(fit),
    run_time_seconds = unname(fit$elapsed)
  )
  if (inherits(data, "btsbm_ranking_data")) {
    out$n_rankings <- data$n_rankings
    out$ranking_length <- data$rank_length
  } else {
    n_ij <- data$wins + t(data$wins)
    out$n_pairs_compared <- sum(upper.tri(n_ij) & n_ij > 0)
    out$n_comparisons <- sum(data$wins)
  }
  if (!is.null(fit$draws$item_cluster)) {
    out$posterior_K <- posterior_K_table(fit)
    z_hat <- partition_point_estimate(fit)
    out$point_estimate_partition <- z_hat
    out$blocks <- data.frame(
      block = sort(unique(z_hat)),
      size = as.vector(table(factor(z_hat, levels = sort(unique(z_hat))))),
      members = vapply(sort(unique(z_hat)), function(k) paste(names(z_hat)[z_hat == k], collapse = ", "),
                       character(1)),
      stringsAsFactors = FALSE
    )
  } else if (!is.null(fit$draws$item_strength)) {
    out$relative_strengths <- strength_summary(fit, credible_mass = credible_mass)
  }
  if (!is.null(fit$draws$n_ranking_clusters)) {
    tab <- table(fit$draws$n_ranking_clusters)
    out$posterior_ranking_groups <- data.frame(groups = as.integer(names(tab)),
                                               probability = as.vector(tab) / sum(tab))
  }
  out$credible_mass <- credible_mass
  class(out) <- "summary.btsbm_fit"
  out
}

#' @export
print.summary.btsbm_fit <- function(x, ...) {
  cat("Model:   ", x$model_description, "\n", sep = "")
  if (!is.null(x$n_comparisons)) {
    cat("Data:    ", x$n_items, " items, ", x$n_pairs_compared, " compared pairs, ",
        x$n_comparisons, " comparisons\n", sep = "")
  } else {
    cat("Data:    ", x$n_items, " items, ", x$n_rankings, " rankings of length ",
        x$ranking_length, "\n", sep = "")
  }
  cat("Priors:  ", x$strength_prior, "\n", sep = "")
  if (!is.null(x$item_partition_prior)) cat("         item partition z ~ ", x$item_partition_prior, "\n", sep = "")
  if (!is.null(x$ranking_partition_prior)) cat("         ranking partition ~ ", x$ranking_partition_prior, "\n", sep = "")
  cat(sprintf("MCMC:    %d iterations, %d warm-up, %d retained draws (%.1f s)\n",
              x$mcmc_iterations, x$mcmc_warmup, x$retained_draws, x$run_time_seconds))
  if (!is.null(x$posterior_K)) {
    cat("\nPosterior number of blocks, Pr(K = k | y):\n")
    pk <- stats::setNames(round(x$posterior_K$probability, 3), x$posterior_K$K)
    print(pk)
    cat("\nPoint estimate of the partition (block 1 = strongest):\n")
    for (r in seq_len(nrow(x$blocks))) {
      cat(sprintf("  Block %d (%d items): %s\n", x$blocks$block[r], x$blocks$size[r],
                  x$blocks$members[r]))
    }
  }
  if (!is.null(x$relative_strengths)) {
    cat(sprintf("\nRelative strengths (share of total strength), %g%% credible intervals:\n",
                100 * x$credible_mass))
    tab <- x$relative_strengths
    show <- utils::head(tab, 10L)
    show[, -1] <- round(show[, -1], 3)
    print(show, row.names = FALSE)
    if (nrow(tab) > 10L) cat("  ... ", nrow(tab) - 10L, " more items; see strength_summary().\n", sep = "")
  }
  if (!is.null(x$posterior_ranking_groups)) {
    cat("\nPosterior number of ranking groups:\n")
    print(stats::setNames(round(x$posterior_ranking_groups$probability, 3),
                          x$posterior_ranking_groups$groups))
  }
  invisible(x)
}

.fit_n_draws <- function(fit) {
  candidate <- fit$draws$item_cluster
  if (is.null(candidate)) candidate <- fit$draws$ranking_cluster
  if (is.null(candidate)) candidate <- fit$draws$latent_strength
  if (is.null(candidate)) candidate <- fit$draws$ability
  if (is.list(candidate)) length(candidate) else nrow(candidate)
}

.implied_ability_from_blocks <- function(cluster_draws, ability_draws) {
  S <- nrow(cluster_draws)
  n <- ncol(cluster_draws)
  out <- matrix(NA_real_, S, n)
  for (s in seq_len(S)) {
    out[s, ] <- ability_draws[[s]][cluster_draws[s, ]]
  }
  out
}

#' Compute pointwise log likelihoods from an RBBayes fit
#'
#' @param object A `btsbm_fit` object.
#' @param ... Unused.
#' @return An `S × R` matrix with one column for each pair-count cell (BT) or
#'   whole ranking row (PL).  It has a `unit_index` attribute.
#' @export
log_lik <- function(object, ...) {
  UseMethod("log_lik")
}

#' @export
log_lik.btsbm_fit <- function(object, ...) {
  if (object$model$likelihood == "pl") return(.pl_log_lik_fit(object))
  .bt_log_lik_fit(object)
}

.bt_log_lik_fit <- function(fit) {
  w <- fit$data$wins
  n_ij <- w + t(w)
  idx <- which(upper.tri(n_ij) & n_ij > 0, arr.ind = TRUE)
  S <- .fit_n_draws(fit)
  out <- matrix(NA_real_, S, nrow(idx))
  for (s in seq_len(S)) {
    lambda_i <- if (fit$model$structure == "none") {
      fit$draws$latent_strength[s, ]
    } else {
      fit$draws$latent_strength[[s]][fit$draws$item_cluster[s, ]]
    }
    for (d in seq_len(nrow(idx))) {
      i <- idx[d, 1L]; j <- idx[d, 2L]
      out[s, d] <- stats::dbinom(
        w[i, j], size = n_ij[i, j], prob = lambda_i[i] / (lambda_i[i] + lambda_i[j]), log = TRUE
      )
    }
  }
  attr(out, "unit_index") <- idx
  out
}

#' Compute posterior similarity for an inferred partition
#'
#' @param fit A `btsbm_fit` object.
#' @param target Either `"item"` or `"ranking"`.
#'
#' @return A posterior similarity matrix.
#' @export
posterior_similarity <- function(fit, target = c("item", "ranking")) {
  if (!inherits(fit, "btsbm_fit")) stop("`fit` must be a `btsbm_fit` object.", call. = FALSE)
  target <- match.arg(target)
  draws <- if (target == "item") fit$draws$item_cluster else fit$draws$ranking_cluster
  if (is.null(draws)) {
    stop("This fit does not contain a sampled ", target, " partition.", call. = FALSE)
  }
  n <- ncol(draws)
  out <- matrix(0, n, n)
  for (s in seq_len(nrow(draws))) out <- out + outer(draws[s, ], draws[s, ], `==`)
  out / nrow(draws)
}

#' Summarise posterior item strengths
#'
#' @param fit A simple BT/PL or item-SBM fit.
#' @param summary Either `"draws"` or `"mean"`.
#'
#' @return A draws matrix or named posterior mean vector.
#' @export
posterior_strength <- function(fit, summary = c("draws", "mean")) {
  if (!inherits(fit, "btsbm_fit")) stop("`fit` must be a `btsbm_fit` object.", call. = FALSE)
  summary <- match.arg(summary)
  draws <- fit$draws$item_strength
  if (is.null(draws)) {
    stop("Item strengths are not available until mixture/LBM post-processing is implemented.", call. = FALSE)
  }
  if (summary == "draws") return(draws)
  stats::setNames(colMeans(draws), fit$data$item_labels)
}

#' Summarise posterior item strengths with credible intervals
#'
#' This is a compact numerical companion to [plot_strength_summary()]. By
#' default strengths are reported as relative strengths: in every draw each
#' \eqn{\lambda_i} is divided by \eqn{\sum_j \lambda_j}, so they are shares that
#' add to one and do not depend on the arbitrary overall scale. A larger value
#' means a higher chance of beating (BT) or being preferred to (PL) others.
#'
#' @param fit A simple BT/PL or item-SBM btsbm_fit object.
#' @param credible_mass Width of the central posterior interval, in (0, 1).
#' @param scale `"relative"` (default, shares adding to one) or `"raw"`
#'   (the strengths as stored by the sampler).
#'
#' @return A data frame with one row per item, ordered from larger to smaller
#'   posterior mean strength.
#' @export
strength_summary <- function(fit, credible_mass = 0.9, scale = c("relative", "raw")) {
  if (!inherits(fit, "btsbm_fit")) {
    stop("'fit' must be a btsbm_fit object.", call. = FALSE)
  }
  scale <- match.arg(scale)
  if (length(credible_mass) != 1L || !is.finite(credible_mass) ||
      credible_mass <= 0 || credible_mass >= 1) {
    stop("'credible_mass' must lie strictly between zero and one.", call. = FALSE)
  }
  draws <- posterior_strength(fit, summary = "draws")
  if (scale == "relative") draws <- draws / rowSums(draws)
  tail_probability <- (1 - credible_mass) / 2
  result <- data.frame(
    item = fit$data$item_labels,
    mean = colMeans(draws),
    median = apply(draws, 2L, stats::median),
    lower = apply(draws, 2L, stats::quantile, probs = tail_probability),
    upper = apply(draws, 2L, stats::quantile, probs = 1 - tail_probability),
    stringsAsFactors = FALSE
  )
  result <- result[order(result$mean, decreasing = TRUE), , drop = FALSE]
  rownames(result) <- NULL
  result
}

#' Compute implied item abilities from a fit
#'
#' `implied_ability()` is retained as a compatibility alias for
#' [posterior_strength()]. New code should use `posterior_strength()`.
#'
#' @inheritParams posterior_strength
#' @return A draws matrix or named posterior mean vector.
#' @export
implied_ability <- function(fit, summary = c("draws", "mean")) {
  posterior_strength(fit, summary = summary)
}

#' Run Pareto-smoothed importance-sampling LOO for a fit
#'
#' @param fit A `btsbm_fit` object.
#' @param ... Passed to [loo::loo()].
#' @return A `loo` object.
#' @export
loo_btsbm <- function(fit, ...) {
  if (!requireNamespace("loo", quietly = TRUE)) {
    stop("Package `loo` is required for `loo_btsbm()`.", call. = FALSE)
  }
  loo::loo(log_lik(fit), ...)
}

.initial_positive_sequence_ess <- function(trace) {
  trace <- as.numeric(trace)
  n <- length(trace)
  if (n < 4L || !is.finite(stats::var(trace)) || stats::var(trace) == 0) {
    return(as.numeric(n))
  }
  autocorrelation <- stats::acf(
    trace, lag.max = min(n - 1L, 500L), plot = FALSE
  )$acf[, 1L, 1L]
  integrated_time <- 1
  lag_index <- 2L
  while (lag_index + 1L <= length(autocorrelation)) {
    paired_autocorrelation <- autocorrelation[lag_index] + autocorrelation[lag_index + 1L]
    if (!is.finite(paired_autocorrelation) || paired_autocorrelation < 0) break
    integrated_time <- integrated_time + 2 * paired_autocorrelation
    lag_index <- lag_index + 2L
  }
  max(1, n / integrated_time)
}

.fit_diagnostic_traces <- function(fit) {
  traces <- fit$diagnostics$traces
  if (is.null(traces)) traces <- list()
  if (is.null(traces$n_item_clusters) && !is.null(fit$draws$n_item_clusters)) {
    traces$n_item_clusters <- fit$draws$n_item_clusters
  }
  if (is.null(traces$n_ranking_clusters) && !is.null(fit$draws$n_ranking_clusters)) {
    traces$n_ranking_clusters <- fit$draws$n_ranking_clusters
  }
  if (is.null(traces$log_likelihood) && fit$model$likelihood == "pl") {
    traces$log_likelihood <- rowSums(log_lik(fit))
  }
  traces
}

#' Summarise MCMC mixing diagnostics
#'
#' Computes a lightweight initial-positive-sequence effective sample size,
#' Monte Carlo standard error, and lag-one autocorrelation for saved scalar
#' traces. PL fits include the total ranking log likelihood; block models also
#' include their occupied-cluster traces.
#'
#' @param fit A `btsbm_fit` object.
#'
#' @return A data frame with one row per available scalar trace.
#' @export
mcmc_diagnostics <- function(fit) {
  if (!inherits(fit, "btsbm_fit")) {
    stop("`fit` must be a `btsbm_fit` object.", call. = FALSE)
  }
  traces <- .fit_diagnostic_traces(fit)
  if (!length(traces)) {
    return(data.frame(
      quantity = character(), mean = numeric(), sd = numeric(),
      ess = numeric(), mcse = numeric(), autocorrelation_lag_1 = numeric()
    ))
  }
  do.call(rbind, lapply(names(traces), function(quantity) {
    trace <- as.numeric(traces[[quantity]])
    ess <- .initial_positive_sequence_ess(trace)
    trace_sd <- stats::sd(trace)
    data.frame(
      quantity = quantity,
      mean = mean(trace),
      sd = trace_sd,
      ess = ess,
      mcse = trace_sd / sqrt(ess),
      autocorrelation_lag_1 = if (length(trace) > 1L && is.finite(trace_sd) && trace_sd > 0) {
        stats::cor(trace[-length(trace)], trace[-1L])
      } else {
        NA_real_
      },
      row.names = NULL
    )
  }))
}

#' Compatibility entry point for Bayesian preference models
#' @inheritParams fit_model
#' @return An object of class `btsbm_fit`.
#' @export
fit_btsbm <- function(data, model, control = mcmc_control()) {
  fit <- fit_model(data, model, control)
  fit$call <- match.call()
  fit
}
