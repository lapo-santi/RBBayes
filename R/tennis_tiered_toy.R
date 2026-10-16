#' Simulate a clearly separated twenty-player tennis league
#'
#' Simulate a complete league with user-specified block strengths and sizes.
#' A common random permutation shuffles both axes.
#' @param matches_per_pair Positive integer number of matches for each pair.
#' @param seed Integer random seed, or NULL to use the current random state.
#' @param n_blocks Positive integer number of generating blocks.
#' @param latent_strength Positive vector with one strength per generating block.
#' @param players_per_block Positive integer block sizes, either one common size
#'   or a vector of length n_blocks.
#' @param item_labels Optional unique names for all players.
#' @param format Return validated data (default) or a winner/loser/count edge list.
#' @return A btsbm_pairwise_data object, or an edge-list data frame, with generating groups and strengths
#'   stored in its truth attribute. All observations are synthetic.
#' @export
tennis_tiered_toy <- function(matches_per_pair = 20L, seed = 101L,
                               n_blocks = length(latent_strength),
                               latent_strength = c(64, 16, 4, 1),
                               players_per_block = 5L, item_labels = NULL,
                               format = c("data", "edgelist")) {
  format <- match.arg(format)
  if (!is.numeric(n_blocks) || length(n_blocks) != 1L || !is.finite(n_blocks) ||
      n_blocks < 1 || n_blocks != floor(n_blocks)) {
    stop("`n_blocks` must be one positive integer.", call. = FALSE)
  }
  if (!is.numeric(latent_strength) || length(latent_strength) != n_blocks ||
      any(!is.finite(latent_strength)) || any(latent_strength <= 0)) {
    stop("`latent_strength` must contain one positive finite strength per block.", call. = FALSE)
  }
  if (!is.numeric(players_per_block) ||
      !length(players_per_block) %in% c(1L, n_blocks) ||
      any(!is.finite(players_per_block)) || any(players_per_block < 1) ||
      any(players_per_block != floor(players_per_block))) {
    stop("`players_per_block` must contain positive integer block sizes.", call. = FALSE)
  }
  block_sizes <- rep(players_per_block, length.out = n_blocks)
  n_players <- sum(block_sizes)
  if (n_players < 2) stop("At least two players are required.", call. = FALSE)
  if (length(matches_per_pair) != 1L || !is.numeric(matches_per_pair) ||
      !is.finite(matches_per_pair) || matches_per_pair < 1 ||
      matches_per_pair != floor(matches_per_pair)) {
    stop("`matches_per_pair` must be one positive integer.", call. = FALSE)
  }
  if (!is.null(seed)) set.seed(seed)
  player_names <- c("Alex Vale", "Ben Holt", "Cara Reed", "Dan Moss",
                    "Ella Shaw", "Finn Lake", "Gina West", "Hugo Dale",
                    "Isla Kent", "Jack Ford", "Kira Lane", "Leo Wood",
                    "Maya Cole", "Noah Bell", "Orla Hart", "Paul Snow",
                    "Rosa Hill", "Sam Ward", "Tara Fox", "Will Gray")
  if (is.null(item_labels)) {
    player_names <- c(player_names, paste0("Player ", seq_len(n_players)))
    player_names <- player_names[seq_len(n_players)]
  } else {
    player_names <- item_labels
  }
  if (!is.character(player_names) || length(player_names) != n_players ||
      anyNA(player_names) || anyDuplicated(player_names) || any(!nzchar(player_names))) {
    stop("`item_labels` must give one unique non-empty name per player.", call. = FALSE)
  }
  true_block <- sample(rep(seq_len(n_blocks), times = block_sizes))
  true_strength <- latent_strength[true_block]
  wins <- matrix(0L, n_players, n_players)
  for (i in seq_len(n_players - 1L)) {
    for (j in (i + 1L):n_players) {
      probability <- true_strength[i] / (true_strength[i] + true_strength[j])
      wins[i, j] <- rbinom(1, matches_per_pair, probability)
      wins[j, i] <- matches_per_pair - wins[i, j]
    }
  }
  # Apply the same random permutation to both axes to retain item alignment.
  item_order <- sample(seq_along(player_names))
  tennis <- as_bt_data(wins[item_order, item_order],
                       item_labels = player_names[item_order])
  attr(tennis, "truth") <- list(
    item_cluster = true_block[item_order],
    item_strength = true_strength[item_order]
  )
  if (format == "edgelist") {
    # Include both directions, even zero counts, to retain all player names.
    index <- which(row(tennis$wins) != col(tennis$wins), arr.ind = TRUE)
    index <- index[order(index[, 1], index[, 2]), , drop = FALSE]
    return(data.frame(
      winner = tennis$item_labels[index[, 1]],
      loser = tennis$item_labels[index[, 2]],
      count = as.numeric(tennis$wins[index]), stringsAsFactors = FALSE
    ))
  }
  tennis
}
