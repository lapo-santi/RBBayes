# Edge-list conversion is explicit: no matrix layout or outcome coding is guessed.
.bt_data_from_edges <- function(edges, item_labels, winner, loser, count) {
  columns <- c(winner, loser, count)
  if (!is.character(winner) || length(winner) != 1L ||
      !is.character(loser) || length(loser) != 1L ||
      (!is.null(count) && (!is.character(count) || length(count) != 1L)) ||
      anyNA(columns) || anyDuplicated(columns) || !all(columns %in% names(edges))) {
    stop("Specify distinct existing winner, loser and optional count columns.", call. = FALSE)
  }
  winners <- as.character(edges[[winner]])
  losers <- as.character(edges[[loser]])
  if (anyNA(winners) || anyNA(losers) || any(!nzchar(winners)) || any(!nzchar(losers))) {
    stop("Winner and loser identifiers must be non-missing and non-empty.", call. = FALSE)
  }
  if (any(winners == losers)) stop("Self-comparisons are not allowed.", call. = FALSE)
  counts <- if (is.null(count)) rep(1, nrow(edges)) else edges[[count]]
  if (!is.numeric(counts) || any(!is.finite(counts)) || any(counts < 0) ||
      any(counts != floor(counts))) {
    stop("Edge counts must be finite non-negative integers.", call. = FALSE)
  }
  if (is.null(item_labels)) item_labels <- unique(c(winners, losers))
  if (!is.character(item_labels) || length(item_labels) < 2L ||
      anyNA(item_labels) || anyDuplicated(item_labels) || any(!nzchar(item_labels))) {
    stop("`item_labels` must contain at least two unique non-empty item names.", call. = FALSE)
  }
  row_index <- match(winners, item_labels)
  column_index <- match(losers, item_labels)
  if (anyNA(row_index) || anyNA(column_index)) {
    stop("All edge-list identifiers must occur in `item_labels`.", call. = FALSE)
  }
  wins <- matrix(0, length(item_labels), length(item_labels),
                 dimnames = list(item_labels, item_labels))
  for (edge in seq_len(nrow(edges))) {
    i <- row_index[edge]
    j <- column_index[edge]
    wins[i, j] <- wins[i, j] + counts[edge]
  }
  as_bt_data(wins, item_labels = item_labels)
}
