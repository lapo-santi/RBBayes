#' Prior variance of the occupied-group count under a Dirichlet process
#'
#' For n items and concentration alpha, new-group indicators are independent
#' Bernoulli variables with probabilities alpha/(alpha+i-1), i=1,...,n.
#' Their summed variances give the prior variance of K_n.
#' @param n Positive integer number of items.
#' @param concentration Positive finite Dirichlet-process concentration.
#' @return A numeric scalar, the prior variance of the occupied-group count.
#' @export
dirichlet_process_K_var <- function(n, concentration = 1) {
  if (!is.numeric(concentration) || length(concentration) != 1L ||
      !is.finite(concentration) || concentration <= 0) {
    stop("`concentration` must be one positive finite number.", call. = FALSE)
  }
  prior <- dirichlet_process_prior(concentration)
  .check_prior_moment_inputs(n, prior)
  p_new <- concentration / (concentration + seq_len(n) - 1)
  sum(p_new * (1 - p_new))
}
