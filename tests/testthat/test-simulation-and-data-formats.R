test_that("BT simulation preserves supplied item strengths and pair totals", {
  lambda <- c(A = 12, B = 6, C = 2, D = 1)
  edges <- simulate_data("bt", latent_strength = lambda, matches_per_pair = 9,
                         seed = 17, format = "edgelist")
  truth <- attr(edges, "truth")
  expect_equal(truth$true_strength, unname(lambda[truth$item]))
  expect_false("true_block" %in% names(truth))
  expect_identical(edges, simulate_data("bt", latent_strength = lambda,
                                       matches_per_pair = 9, seed = 17, format = "edgelist"))
  data <- as_bt_data(edges, format = "edgelist")
  expect_equal(data$n_items, 4)
  expect_true(all((data$wins + t(data$wins))[upper.tri(data$wins)] == 9))
  direct <- simulate_data("bt", latent_strength = lambda, matches_per_pair = 9, seed = 17)
  expect_equal(direct$wins, data$wins)
  mat <- simulate_data("bt", latent_strength = lambda, matches_per_pair = 9,
                       seed = 17, format = "matrix")
  expect_equal(unname(mat), unname(structure(data$wins, truth = truth)))
  expect_error(simulate_data("bt", latent_strength = 1), "at least two")
  expect_error(simulate_data("bt", latent_strength = c(1, -1)), "positive finite")
  expect_error(simulate_data("bt", n_blocks = 2), "only")
  expect_error(simulate_data("bt", players_per_block = 3), "only")
  expect_error(simulate_data("bt", matches_per_pair = 1.5), "positive integer")
})

test_that("BT-SBM simulation accepts unequal block sizes and preserves legacy draws", {
  edges <- simulate_data("bt-sbm", latent_strength = c(12, 6, 2, 1),
                         players_per_block = c(3, 4, 5, 8), seed = 101, format = "edgelist")
  expect_equal(as.integer(table(attr(edges, "truth")$true_block)), c(3, 4, 5, 8))
  expect_identical(edges, tennis_tiered_toy(latent_strength = c(12, 6, 2, 1),
                                           players_per_block = c(3, 4, 5, 8), seed = 101,
                                           format = "edgelist"))
  data <- simulate_data("bt-sbm", seed = 101)
  expect_equal(data$wins, tennis_tiered_toy(seed = 101)$wins)
  expect_named(attr(data, "truth"), c("item", "true_block", "true_strength"))
  expect_equal(data$n_items, 20)
  expect_error(simulate_data("bt-sbm", n_blocks = 2, latent_strength = c(1, 2, 3)), "one positive")
})

test_that("explicit data formats distinguish aggregated counts and individual matches", {
  edges <- data.frame(winner = c("A", "B"), loser = c("B", "A"), count = c(7, 3))
  aggregate <- as_bt_data(edges, format = "edgelist")
  expect_equal(aggregate$wins["A", "B"], 7)
  expect_equal(as_bt_data(edges, format = "matches")$wins["A", "B"], 1)
  expect_equal(as_bt_data(edges)$wins["A", "B"], 1) # Legacy default is preserved.
  expect_identical(as_bt_data(edges, count = "count"), aggregate)
  renamed <- edges
  names(renamed) <- c("win", "lose", "frequency")
  expect_identical(as_bt_data(renamed, format = "edgelist", winner = "win",
                              loser = "lose", count = "frequency"), aggregate)
  expect_error(as_bt_data(edges, format = "matrix"), "matrix")
  expect_error(as_bt_data(aggregate$wins, format = "edgelist"), "data frame")
  expect_error(as_bt_data(edges, format = "matches", count = "count"), "omit")
  expect_error(as_bt_data(edges[, 1:2], format = "edgelist"), "existing")
})

test_that("pairwise plotting dispatches on class and reorders without changing counts", {
  wins <- matrix(c(0, 1, 0, 5, 0, 3, 2, 0, 0), 3, byrow = TRUE)
  data <- as_bt_data(wins, item_labels = c("A", "B", "C"))
  original <- plot_pairwise_outcomes(data, reorder = FALSE)
  sorted <- plot_pairwise_outcomes(data, reorder = TRUE)
  expect_equal(levels(original$data$loser), c("A", "B", "C"))
  expect_equal(levels(sorted$data$loser), c("B", "C", "A"))
  for (i in data$item_labels) for (j in data$item_labels) {
    cell <- sorted$data$winner == i & sorted$data$loser == j
    expect_equal(sorted$data$wins[cell], data$wins[i, j])
  }
  fit <- fit_model(data, bt_model(), mcmc_control(iter = 12, warmup = 6, seed = 1))
  expect_equal(plot_pairwise_outcomes(fit, reorder = TRUE)$data, sorted$data)
  sparse <- matrix(0, 4, 4)
  sparse[1:3, 1:3] <- wins
  sparse <- as_bt_data(sparse, item_labels = c("A", "B", "C", "Unplayed"))
  expect_equal(levels(plot_pairwise_outcomes(sparse, reorder = TRUE)$data$loser),
               c("B", "C", "A", "Unplayed"))
  tied <- as_bt_data(matrix(c(0, 2, 2, 0), 2), item_labels = c("Second", "First"))
  expect_equal(levels(plot_pairwise_outcomes(tied, reorder = TRUE)$data$loser),
               c("Second", "First"))
  expect_error(plot_pairwise_outcomes(data, reorder = NA), "TRUE or FALSE")
  expect_error(plot_pairwise_outcomes(wins), "as_bt_data")
})
