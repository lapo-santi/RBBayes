#' Fit a Bayesian preference model
#'
#' Use [fit_model()] for new analyses. This entry point remains available
#' for compatibility with earlier development versions.
#'
#' @inheritParams fit_model
#' @return An object of class `btsbm_fit`.
#' @export
fit_preference <- function(data, model, control = mcmc_control()) {
  fit <- fit_model(data = data, model = model, control = control)
  fit$call <- match.call()
  fit
}
