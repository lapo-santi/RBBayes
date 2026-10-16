#' Dirichlet--multinomial prior for a latent partition
#'
#' Defines a symmetric Dirichlet distribution over a fixed number of available
#' groups, integrated out to obtain a prior on item allocations.
#' @param max_clusters Positive integer number of available groups.
#' @param concentration Positive Dirichlet parameter for each group; the total
#'   concentration is `max_clusters * concentration`.
#' @return An object of class `btsbm_partition_prior`.
#' @export
dirichlet_multinomial_prior <- function(max_clusters, concentration = 1) {
  clustering_prior("finite_dirichlet", concentration = concentration,
                   max_clusters = max_clusters)
}
