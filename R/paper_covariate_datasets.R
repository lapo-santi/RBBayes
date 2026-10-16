#' NFL quarterback rankings with item covariates
#'
#' A faithful transcription of Tables 1 and 2 in Li, Yi and Liu (2022).
#' It records the week-12, 2014 rankings of 24 quarterbacks by 13 experts and
#' the 11 player statistics available before that week. Missing entries in
#' `ranking_positions` mean that an expert did not include that player in the
#' expert's top-24 list. Lower values are better ranks.
#'
#' The source websites in the article are dynamic historical sports websites.
#' Keeping this small, cited transcription makes the published example
#' reproducible without presenting it as a live data download.
#'
#' @return A list with `ranking_positions` (items by experts),
#'   `item_covariates` (items by covariates), and source metadata. The two
#'   tabular components share row names and can be used as a realistic fixture
#'   for future covariate-assisted ranking models.
#' @references Li, X., Yi, D. and Liu, J. S. (2022). Bayesian analysis of rank
#'   data with covariates and heterogeneous rankers. *Statistical Science*,
#'   37(1), 1--23. \doi{10.1214/20-STS818}
#' @export
nfl_quarterbacks_2014 <- function() {
  players <- c(
    "Andrew Luck", "Aaron Rodgers", "Peyton Manning", "Tom Brady",
    "Tony Romo", "Drew Brees", "Ben Roethlisberger", "Ryan Tannehill",
    "Matthew Stafford", "Mark Sanchez", "Russell Wilson", "Philip Rivers",
    "Cam Newton", "Eli Manning", "Matt Ryan", "Andy Dalton", "Alex Smith",
    "Colin Kaepernick", "Joe Flacco", "Jay Cutler", "Josh McCown",
    "Drew Stanton", "Teddy Bridgewater", "Brian Hoyer"
  )
  ranking_positions <- rbind(
    c(1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1),
    c(2, 3, 4, 2, 1, 2, 3, 3, 2, 2, 3, 4, 3),
    c(3, 2, 5, 4, 2, 3, 2, 2, 3, 4, 4, 2, 2),
    c(4, 7, 3, 5, 4, 5, 4, 6, 4, 3, 6, 8, 4),
    c(9, 5, 6, 1, 5, 4, 5, 4, 5, 5, 7, 6, 6),
    c(10, 4, 2, 8, 9, 7, 7, 5, 7, 6, 2, 3, 5),
    c(6, 8, 7, 7, 7, 6, 6, 10, 6, 7, 5, 7, 7),
    c(5, 6, 13, 6, 11, 8, 8, 7, 9, 9, 8, 5, 8),
    c(8, 9, 11, 13, 8, 9, 9, 8, 8, 8, 9, 9, 9),
    c(22, 10, 9, 9, 16, 10, 10, 9, 10, 10, 12, 12, 12),
    c(12, 13, 17, 10, 10, 12, 11, 12, 11, 12, 11, 14, 15),
    c(7, 14, 15, 20, 6, 17, 17, 11, 16, 15, 14, 10, 10),
    c(18, 12, 8, 17, 19, 11, 14, 14, 14, 16, 21, 13, 14),
    c(17, NA, 18, 19, 14, 19, 12, 13, 12, 13, 16, 23, 11),
    c(21, 17, 19, 15, 20, 15, 15, 15, 13, 11, 20, 21, 13),
    c(15, NA, 14, NA, 17, 14, 16, 20, 15, 14, 19, 22, 16),
    c(16, 11, 21, 16, 18, 18, 18, 16, 20, 21, 13, 11, 17),
    c(11, 16, 16, 11, 12, 16, 21, 17, 19, 18, 22, 16, 21),
    c(24, 15, 12, 14, 24, 13, 13, 18, 18, 20, 15, 15, 19),
    c(13, 18, 10, 12, 13, 21, 19, 19, 17, 17, 23, 20, 18),
    c(14, 19, 22, 18, 15, 22, 22, 21, 21, 19, 18, 17, 23),
    c(20, 20, NA, 22, 22, 20, 20, 23, 22, 22, 10, 19, 20),
    c(23, 21, 20, 21, 23, 23, 23, 22, 23, 24, 17, 18, 22),
    c(19, NA, NA, NA, 21, 24, 24, 24, 24, 23, 24, 24, 24)
  )
  rownames(ranking_positions) <- players
  colnames(ranking_positions) <- paste0("Expert_", sprintf("%02d", seq_len(ncol(ranking_positions))))

  item_covariates <- as.data.frame(rbind(
    c(11, 63.40, 42.20, 7.80, 331.00, 6.30, 2.20, 4.20, 4.20, 17.50, 30.40),
    c(11, 66.70, 31.10, 8.60, 268.80, 8.80, 0.90, 2.50, 6.40, 16.20, 50.00),
    c(11, 68.10, 40.20, 8.00, 323.50, 7.70, 2.00, 1.50, -0.50, -0.70, 0.00),
    c(11, 65.00, 37.90, 7.20, 272.50, 6.20, 1.40, 1.70, 0.70, 1.30, 21.10),
    c(10, 68.80, 29.50, 8.50, 251.90, 7.50, 2.00, 1.50, 2.50, 3.70, 20.00),
    c(11, 70.30, 42.00, 7.60, 317.40, 4.80, 2.40, 1.70, 2.80, 4.90, 26.30),
    c(11, 68.30, 37.50, 7.90, 297.30, 5.80, 1.50, 1.90, 1.10, 2.10, 19.00),
    c(11, 66.10, 36.40, 6.60, 234.70, 5.10, 2.10, 3.70, 6.70, 25.10, 36.60),
    c(11, 58.80, 37.70, 7.10, 267.50, 3.10, 2.40, 2.80, 2.00, 5.60, 16.10),
    c(4, 62.30, 36.50, 8.10, 296.80, 4.80, 4.10, 3.50, 0.60, 2.00, 7.10),
    c(11, 63.60, 28.50, 7.10, 202.70, 4.50, 1.60, 7.60, 7.70, 58.50, 45.20),
    c(11, 68.30, 33.00, 7.80, 257.70, 6.10, 2.50, 2.50, 2.50, 6.40, 25.00),
    c(10, 58.60, 33.30, 7.20, 239.20, 3.60, 3.00, 6.40, 4.60, 29.30, 37.50),
    c(11, 62.30, 36.90, 7.00, 257.50, 5.20, 3.00, 0.80, 3.80, 3.10, 33.30),
    c(11, 65.10, 38.50, 7.20, 278.70, 4.50, 2.10, 1.60, 4.30, 7.10, 33.30),
    c(11, 62.40, 30.70, 7.10, 219.40, 3.60, 3.00, 3.80, 2.50, 9.50, 33.30),
    c(11, 65.10, 29.70, 6.80, 201.00, 4.00, 1.20, 3.20, 5.50, 17.40, 25.70),
    c(11, 61.70, 31.50, 7.50, 237.70, 4.30, 1.70, 6.80, 4.50, 30.50, 22.70),
    c(11, 63.20, 34.10, 7.80, 251.30, 4.80, 2.10, 2.00, 1.70, 3.40, 45.50),
    c(11, 66.80, 36.40, 7.10, 256.80, 5.50, 3.00, 2.90, 3.90, 11.30, 28.10),
    c(6, 60.40, 30.30, 7.40, 225.00, 3.80, 4.40, 2.70, 5.80, 15.30, 50.00),
    c(6, 53.60, 25.20, 7.10, 178.20, 3.30, 2.00, 3.00, 2.00, 6.00, 22.20),
    c(8, 60.30, 32.80, 6.40, 211.10, 2.30, 2.70, 3.50, 4.60, 16.10, 32.10),
    c(11, 55.90, 33.20, 7.80, 260.40, 3.00, 2.20, 1.80, 0.90, 1.50, 20.00)
  ))
  names(item_covariates) <- c(
    "games_played", "pass_completion_pct", "pass_attempts_per_game",
    "passing_yards_per_attempt", "passing_yards_per_game", "touchdown_pct",
    "interception_pct", "rushing_attempts_per_game",
    "rushing_yards_per_attempt", "rushing_yards_per_game",
    "rushing_first_down_pct"
  )
  rownames(item_covariates) <- players

  list(
    ranking_positions = ranking_positions,
    item_covariates = item_covariates,
    ranking_labels = colnames(ranking_positions),
    source = list(
      citation = "Li, Yi and Liu (2022), Tables 1--2",
      ranking_source = c("fantasy.nfl.com/research/rankings", "fantasypros.com/nfl/rankings/qb.php"),
      covariate_source = "nfl.com/stats",
      note = "Static transcription of published tables; not a live scrape."
    )
  )
}

#' Orthodontics ranking-and-covariate excerpt
#'
#' An anonymised, published excerpt from Tables 3 and 4 in Li, Yi and Liu
#' (2022): 15 experts rank two non-overlapping groups (A and H) of 12 cases,
#' with 11 PAR-index covariates for every case. The full 108-case clinical
#' dataset is not provided by the article, so this deliberately exposes only
#' the reproducible table excerpt.
#'
#' @return A list with separate complete within-group ranking-position matrices,
#'   a 24-case covariate table, and source metadata. Lower values are better
#'   ranks in each `ranking_positions` matrix.
#' @references Li, X., Yi, D. and Liu, J. S. (2022). Bayesian analysis of rank
#'   data with covariates and heterogeneous rankers. *Statistical Science*,
#'   37(1), 1--23. \doi{10.1214/20-STS818}
#' @export
orthodontics_excerpt_2009 <- function() {
  case_labels <- list(A = paste0("A", 1:12), H = paste0("H", 1:12))
  ranking_positions <- list(
    A = rbind(
      c(1, 3, 5, 2, 4, 1, 1, 2, 5, 5, 10, 8, 2, 4, 2),
      c(11, 5, 10, 9, 9, 12, 9, 7, 11, 12, 4, 7, 5, 6, 5),
      c(6, 10, 8, 11, 11, 8, 11, 8, 12, 9, 6, 11, 12, 11, 11),
      c(3, 2, 4, 3, 1, 4, 2, 10, 1, 6, 8, 2, 1, 1, 1),
      c(9, 4, 7, 5, 6, 6, 6, 5, 3, 3, 2, 5, 11, 7, 9),
      c(10, 9, 3, 6, 5, 11, 5, 9, 6, 7, 3, 1, 6, 8, 7),
      c(8, 8, 11, 7, 12, 9, 12, 11, 8, 10, 7, 9, 8, 12, 12),
      c(4, 1, 1, 4, 3, 2, 4, 4, 2, 1, 1, 6, 3, 2, 6),
      c(2, 12, 9, 8, 8, 5, 7, 3, 9, 8, 11, 12, 7, 5, 8),
      c(7, 11, 6, 10, 10, 7, 8, 6, 7, 11, 9, 3, 10, 9, 4),
      c(5, 7, 2, 1, 2, 3, 10, 1, 10, 2, 5, 4, 9, 3, 3),
      c(12, 6, 12, 12, 7, 10, 3, 12, 4, 4, 12, 10, 4, 10, 10)
    ),
    H = rbind(
      c(4, 8, 5, 8, 4, 11, 4, 3, 8, 9, 4, 4, 3, 11, 8),
      c(1, 2, 4, 5, 2, 7, 2, 2, 1, 2, 1, 1, 2, 2, 1),
      c(2, 3, 2, 2, 1, 4, 1, 1, 2, 1, 6, 5, 5, 3, 3),
      c(3, 4, 3, 4, 3, 3, 3, 4, 3, 4, 7, 7, 1, 1, 2),
      c(12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 12, 12, 9, 12),
      c(6, 5, 1, 1, 6, 2, 7, 5, 7, 3, 5, 3, 7, 4, 6),
      c(8, 11, 6, 9, 10, 9, 11, 11, 10, 11, 11, 11, 6, 7, 10),
      c(11, 6, 8, 3, 7, 1, 6, 6, 6, 6, 8, 8, 4, 8, 9),
      c(5, 7, 10, 11, 5, 10, 10, 10, 11, 8, 2, 6, 10, 12, 4),
      c(10, 9, 9, 7, 9, 5, 5, 7, 5, 7, 12, 9, 11, 5, 7),
      c(9, 10, 7, 10, 11, 8, 9, 8, 9, 10, 9, 10, 8, 6, 11),
      c(7, 1, 11, 6, 8, 6, 8, 9, 4, 5, 3, 2, 9, 10, 5)
    )
  )
  for (group_name in names(ranking_positions)) {
    rownames(ranking_positions[[group_name]]) <- case_labels[[group_name]]
    colnames(ranking_positions[[group_name]]) <- paste0("Expert_", sprintf("%02d", 1:15))
  }

  item_covariates <- as.data.frame(rbind(
    c(1.56, .22, 1.44, 1.00, 0, 1.22, 0, .33, 0, 0, 0),
    c(1.33, .22, 1.00, .33, 0, .33, 0, .33, 0, .33, 0),
    c(1.22, .33, 1.00, .67, .11, 1.44, 0, 0, 0, 0, 0),
    c(0, 0, .11, 1.78, .22, 1.89, .33, .67, 0, 0, 0),
    c(1.33, .22, .78, 1.22, .11, 1.67, .33, 0, .78, 0, 0),
    c(1.11, .56, 1.78, .89, .22, .89, .67, 1, .78, 0, 0),
    c(1.22, .67, 1.89, .89, .11, 1, .67, .33, .67, 0, 0),
    c(1.44, .22, 1.56, .89, .22, .56, 2, 2, 0, 0, 0),
    c(1.11, .33, 1.22, .44, 0, 1, 2.33, .67, 0, 0, 0),
    c(.67, .11, .89, .11, 0, 0, .67, 1, 0, .67, 0),
    c(.67, .89, 1, .67, 1.33, 2.44, 1.33, 1, .11, 0, .67),
    c(.67, .11, .22, 1, 0, .56, .33, 1.33, 0, .33, 0),
    c(.67, .22, .78, 1.67, .56, .78, .67, 0, .78, 0, 0),
    c(1.56, .56, .22, .44, 0, .11, 0, .67, 0, 0, 0),
    c(.56, .22, 1, .33, .11, .78, 0, .67, 0, .33, 0),
    c(.56, .22, .67, .44, .11, .44, .67, 1, 0, 0, 0),
    c(1.22, .33, .67, .44, 0, .33, 1, .67, .33, 0, 0),
    c(.56, .11, 1.33, 1.22, 0, 1.33, 1, .67, .22, 0, 0),
    c(.56, .33, .78, .78, 0, 1.22, 2, 1.33, .44, .33, 0),
    c(.78, .22, 1.56, .89, 0, .33, 1.67, 2, 0, 0, 0),
    c(.44, .22, 1, 0, .11, .11, 1, 0, 0, 0, 0),
    c(1.11, .33, 1.78, .22, .22, .33, 1.33, 1.67, 0, 0, 0),
    c(.67, .67, 1, .67, .56, .56, 1, 1, .11, 0, 0),
    c(1.22, .78, 1, .33, .33, .67, 1, .67, .56, 0, 0)
  ))
  names(item_covariates) <- c(
    "upper_right_segment", "upper_anterior_segment", "upper_left_segment",
    "lower_right_segment", "lower_anterior_segment", "lower_left_segment",
    "right_buccal_occlusion", "left_buccal_occlusion", "overjet", "overbite",
    "centerline"
  )
  rownames(item_covariates) <- unlist(case_labels, use.names = FALSE)

  list(
    ranking_positions = ranking_positions,
    item_covariates = item_covariates,
    item_group = rep(names(case_labels), lengths(case_labels)),
    ranking_labels = colnames(ranking_positions[[1L]]),
    source = list(
      citation = "Li, Yi and Liu (2022), Tables 3--4",
      note = "Published 24-case excerpt only; not the full clinical dataset."
    )
  )
}
