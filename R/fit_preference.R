#' Fit a Bayesian preference model
#'
#' Use [fit_model()] for new analyses. This entry point remains available
#' for compatibility with earlier development versions.
#'
#' @inheritParams fit_model
#' @return An object of class `btsbm_fit`.
#' @export
#' @examples
#' data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
#' # A short run illustrates the interface; use longer runs for inference.
#' fit <- fit_preference(data, bt_sbm_model(),
#'                  mcmc_control(iter = 60, warmup = 30, seed = 1))
#' fit
fit_preference <- function(data, model, control = mcmc_control()) {
  fit <- fit_model(data = data, model = model, control = control)
  fit$call <- match.call()
  fit
}
