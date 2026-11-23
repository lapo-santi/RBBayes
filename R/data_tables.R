#' Convert validated comparison or ranking data to a long table
#'
#' Pairwise data become `winner`, `loser`, `count` rows, including zero counts
#' but excluding the diagonal. Ranking data become `ranking`, `position`,
#' `item` rows, containing only reported positions. An unreported item in a
#' top-m ranking is below every reported item, but its exact position is unknown.
#' These ordinary data frames can be passed to `tibble::as_tibble()`.
#'
#' @param x Validated data from [as_bt_data()] or [as_rankings()].
#' @param row.names Optional row names for the returned data frame.
#' @param optional,... Passed to [base::as.data.frame()].
#' @return A data frame in long format.
#' @name data_tables
#' @examples
#' comparisons <- tennis_toy()
#' head(as.data.frame(comparisons))
#' head(as.data.frame(sushi_toy()))
NULL

#' @rdname data_tables
#' @export
as.data.frame.btsbm_pairwise_data <- function(x, row.names = NULL,
                                             optional = FALSE, ...) {
  pairs <- which(row(x$wins) != col(x$wins), arr.ind = TRUE)
  result <- data.frame(
    winner = x$item_labels[pairs[, 1L]],
    loser = x$item_labels[pairs[, 2L]],
    count = unname(x$wins[pairs]),
    stringsAsFactors = FALSE
  )
  as.data.frame(result, row.names = row.names, optional = optional, ...)
}

#' @rdname data_tables
#' @export
as.data.frame.btsbm_ranking_data <- function(x, row.names = NULL,
                                            optional = FALSE, ...) {
  result <- data.frame(
    ranking = rep(x$ranking_labels, each = x$rank_length),
    position = rep(seq_len(x$rank_length), times = x$n_rankings),
    item = x$item_labels[as.vector(t(x$rankings))],
    stringsAsFactors = FALSE
  )
  as.data.frame(result, row.names = row.names, optional = optional, ...)
}

#' Summarise observed outcomes for each item
#'
#' Return one row per item, in input order, for descriptive tables and plots.
#' An item's matches equal its wins plus its losses. Its observed win rate is
#' `wins / matches`, or `NA` if it has no comparisons. These summaries do not
#' adjust for the strengths of the opponents.
#'
#' @param pairwise Validated pairwise data from [as_bt_data()].
#' @return A data frame with `item`, `matches`, `wins`, `losses` and `win_rate`.
#' @export
#' @examples
#' pairwise_summary(tennis_toy())
pairwise_summary <- function(pairwise) {
  if (!inherits(pairwise, "btsbm_pairwise_data")) {
    stop("`pairwise` must be created by as_bt_data().", call. = FALSE)
  }
  wins <- rowSums(pairwise$wins)
  losses <- colSums(pairwise$wins)
  matches <- wins + losses
  data.frame(
    item = pairwise$item_labels,
    matches = unname(matches), wins = unname(wins), losses = unname(losses),
    win_rate = ifelse(matches > 0, wins / matches, NA_real_),
    row.names = NULL
  )
}
