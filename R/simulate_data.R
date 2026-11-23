#' Simulate Bradley--Terry paired comparisons
#'
#' Generate synthetic paired comparisons from a standard Bradley--Terry model
#' (`model = "bt"`) or a model with shared block strengths
#' (`model = "bt-sbm"`). Every unordered pair plays `matches_per_pair` matches.
#' Given item strengths, pair counts are independent binomial draws, with
#' probability lambda_i / (lambda_i + lambda_j) that item i wins.
#'
#' For BT, `latent_strength` supplies one fixed positive strength per item,
#' aligned with `item_labels` before the output order is shuffled. For BT--SBM,
#' it supplies one strength per generating block; memberships are randomly
#' assigned to item names subject to the requested block sizes. These supplied
#' strengths are not drawn from the Gamma prior used later for model fitting.
#'
#' @param model Either `"bt"` (default) or `"bt-sbm"`.
#' @param latent_strength Positive generating strengths. Defaults to 20 distinct
#'   log-spaced item strengths from 12 to 1 for BT, or `c(12, 6, 2, 1)` for BT--SBM.
#' @param n_blocks Number of generating blocks, for BT--SBM only. If NULL,
#'   inferred from the length of `latent_strength`.
#' @param players_per_block Positive integer block sizes for BT--SBM: a scalar
#'   repeats one size, or a vector specifies each size separately.
#' @param matches_per_pair Positive integer match count for every unordered pair.
#' @param item_labels Optional unique item names. BT uses names on
#'   `latent_strength` when available, otherwise `"Item 1"`, etc. BT--SBM
#'   retains the fictional tennis names used by [tennis_tiered_toy()].
#' @param seed Integer random seed, or NULL to use the current random state.
#' @param format Output representation: validated `"data"` (default), an
#'   aggregated `"edgelist"`, or a win-count `"matrix"`.
#' @return Synthetic data in the requested representation. The `"truth"`
#'   attribute records generating item strengths, and block memberships for
#'   BT--SBM. Edge lists include both directions and zero counts.
#' @export
#' @examples
#' edges <- simulate_data("bt", latent_strength = c(A = 8, B = 3, C = 1),
#'                        matches_per_pair = 10, seed = 1, format = "edgelist")
#' as_bt_data(edges, format = "edgelist")
#' simulate_data("bt-sbm", latent_strength = c(8, 3, 1),
#'               players_per_block = c(2, 3, 4), seed = 1)
simulate_data <- function(model = c("bt", "bt-sbm"), latent_strength = NULL,
                          n_blocks = NULL, players_per_block = 5L,
                          matches_per_pair = 20L, item_labels = NULL,
                          seed = NULL, format = c("data", "edgelist", "matrix")) {
  model <- match.arg(model)
  format <- match.arg(format)
  if (is.null(latent_strength)) {
    latent_strength <- if (model == "bt") exp(seq(log(12), 0, length.out = 20L)) else c(12, 6, 2, 1)
  }
  if (!is.null(seed) && (!is.numeric(seed) || length(seed) != 1L ||
                         !is.finite(seed) || seed != floor(seed))) {
    stop("`seed` must be NULL or one integer.", call. = FALSE)
  }
  if (model == "bt-sbm") {
    if (is.null(n_blocks)) n_blocks <- length(latent_strength)
    # Reuse the established generator to preserve its seeded simulations.
    data <- tennis_tiered_toy(
      n_blocks = n_blocks, latent_strength = latent_strength,
      players_per_block = players_per_block, matches_per_pair = matches_per_pair,
      item_labels = item_labels, seed = seed,
      format = if (format == "edgelist") "edgelist" else "data"
    )
    if (format == "edgelist") return(data)
    truth <- attr(data, "truth")
    attr(data, "truth") <- data.frame(item = data$item_labels,
                                       true_block = truth$item_cluster,
                                       true_strength = truth$item_strength)
    if (format == "data") return(data)
    wins <- data$wins
    attr(wins, "truth") <- attr(data, "truth")
    return(wins)
  }
  if (!is.null(n_blocks) || !missing(players_per_block)) {
    stop("`n_blocks` and `players_per_block` apply only to `model = 'bt-sbm'`.", call. = FALSE)
  }
  if (!is.numeric(latent_strength) || length(latent_strength) < 2L ||
      any(!is.finite(latent_strength)) || any(latent_strength <= 0)) {
    stop("For BT, `latent_strength` must give a positive finite strength for each of at least two items.", call. = FALSE)
  }
  if (!is.numeric(matches_per_pair) || length(matches_per_pair) != 1L ||
      !is.finite(matches_per_pair) || matches_per_pair < 1 || matches_per_pair != floor(matches_per_pair)) {
    stop("`matches_per_pair` must be one positive integer.", call. = FALSE)
  }
  n_items <- length(latent_strength)
  if (is.null(item_labels)) item_labels <- names(latent_strength)
  if (is.null(item_labels)) item_labels <- paste("Item", seq_len(n_items))
  if (!is.character(item_labels) || length(item_labels) != n_items ||
      anyNA(item_labels) || anyDuplicated(item_labels) || any(!nzchar(item_labels))) {
    stop("`item_labels` must give one unique non-empty name per item.", call. = FALSE)
  }
  if (!is.null(seed)) set.seed(seed)
  wins <- matrix(0, n_items, n_items)
  for (i in seq_len(n_items - 1L)) {
    for (j in (i + 1L):n_items) {
      wins[i, j] <- stats::rbinom(1L, matches_per_pair,
                                 latent_strength[i] / (latent_strength[i] + latent_strength[j]))
      wins[j, i] <- matches_per_pair - wins[i, j]
    }
  }
  item_order <- sample.int(n_items)
  labels <- item_labels[item_order]
  wins <- wins[item_order, item_order, drop = FALSE]
  data <- as_bt_data(wins, item_labels = labels)
  truth <- data.frame(item = labels, true_strength = unname(latent_strength[item_order]))
  if (format == "edgelist") {
    index <- which(row(wins) != col(wins), arr.ind = TRUE)
    index <- index[order(index[, 1], index[, 2]), , drop = FALSE]
    data <- data.frame(winner = labels[index[, 1]], loser = labels[index[, 2]],
                        count = as.numeric(wins[index]))
  } else if (format == "matrix") {
    data <- data$wins
  }
  attr(data, "truth") <- truth
  data
}
