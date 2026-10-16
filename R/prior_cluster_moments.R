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
prior_variance_K <- function(n, prior) {
  .check_prior_moment_inputs(n, prior)
  if (prior$type == "gnedin") return(gnedin_K_var(n, prior$gamma))
  if (prior$type == "dp") return(dirichlet_process_K_var(n, prior$alpha))
  NA_real_
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
