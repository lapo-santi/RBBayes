test_that("edge-list input accumulates counts and preserves a supplied item universe", {
  edges <- data.frame(winner = c("A", "A", "B"), loser = c("B", "B", "A"),
                       count = c(2, 3, 4))
  data <- as_bt_data(edges, count = "count", item_labels = c("B", "A", "C"))
  expect_identical(data$item_labels, c("B", "A", "C"))
  expect_equal(unname(data$wins), matrix(c(0,4,0, 5,0,0, 0,0,0), 3, byrow = TRUE))
  matches <- edges[c(1, 1, 3), c("winner", "loser")]
  expect_equal(as_bt_data(matches)$wins["A", "B"], 2)
  names(edges) <- c("preferred", "other", "frequency")
  expect_equal(as_bt_data(edges, winner = "preferred", loser = "other", count = "frequency")$wins["A", "B"], 5)
  edges$preferred <- factor(edges$preferred)
  expect_equal(as_bt_data(edges, winner = "preferred", loser = "other", count = "frequency")$wins["A", "B"], 5)
})

test_that("invalid edge-list inputs fail explicitly", {
  edges <- data.frame(winner = "A", loser = "B", count = 2)
  expect_error(as_bt_data(edges, count = "missing"), "existing")
  expect_error(as_bt_data(edges, item_labels = c("A", "C")), "identifiers")
  bad <- edges; bad$loser <- "A"
  expect_error(as_bt_data(bad), "Self-comparisons")
  bad <- edges; bad$winner <- NA
  expect_error(as_bt_data(bad), "non-missing")
  bad <- edges; bad$count <- -1
  expect_error(as_bt_data(bad, count = "count"), "non-negative integers")
  bad$count <- 1.5
  expect_error(as_bt_data(bad, count = "count"), "non-negative integers")
})

test_that("tiered tennis accepts explicit generating blocks and strengths", {
  data <- tennis_tiered_toy(n_blocks = 3, latent_strength = c(25, 5, 1),
                            players_per_block = c(3, 4, 5), seed = 2)
  expect_equal(data$n_items, 12)
  truth <- attr(data, "truth")
  expect_equal(as.numeric(table(truth$item_cluster)), c(3, 4, 5))
  expect_equal(truth$item_strength, c(25, 5, 1)[truth$item_cluster])
  edges <- tennis_tiered_toy(n_blocks = 3, latent_strength = c(25, 5, 1),
                             players_per_block = c(3, 4, 5), seed = 2, format = "edgelist")
  expect_equal(as_bt_data(edges, count = "count")$wins, data$wins)
  expect_error(tennis_tiered_toy(n_blocks = 3), "one positive finite strength")
  expect_error(tennis_tiered_toy(latent_strength = c(1, -1)), "positive finite")
  expect_error(tennis_tiered_toy(players_per_block = c(2, 3)), "block sizes")
  expect_equal(tennis_tiered_toy(n_blocks = 1, latent_strength = 1,
                                players_per_block = 2)$n_items, 2)
})

test_that("dedicated DP variance agrees with finite Bernoulli calculations", {
  expect_equal(dirichlet_process_K_var(1, 2), 0)
  p <- 2 / (2 + 0:19)
  expect_equal(dirichlet_process_K_var(20, 2), sum(p * (1 - p)))
  expect_equal(prior_variance_K(20, dirichlet_process_prior(2)), dirichlet_process_K_var(20, 2))
  expect_error(dirichlet_process_K_var(20, c(1, 2)), "one positive")
  expect_error(dirichlet_process_K_var(20, -1), "positive")
})
