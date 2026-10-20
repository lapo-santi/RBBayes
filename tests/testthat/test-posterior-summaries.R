make_toy_sbm <- function() {
  data <- tennis_tiered_toy(seed = 3, matches_per_pair = 10)
  fit_model(data, bt_sbm_model(shape_lambda = 2), mcmc_control(iter = 600, warmup = 300, seed = 4))
}

test_that("model constructors accept shape_lambda and rate_lambda directly", {
  model <- bt_model(shape_lambda = 2, rate_lambda = 3)
  expect_equal(model$latent_strength$shape, 2)
  expect_equal(model$latent_strength$rate, 3)
  expect_equal(bt_sbm_model(shape_lambda = 2)$latent_strength$rate, exp(digamma(2)))
  legacy <- bt_model(latent_strength = latent_strength(shape = 2, rate = 3))
  expect_identical(legacy, model)
  expect_identical(bt_model(latent_strength(2, 3)), model)
})

test_that("VI distance matches known values", {
  vi <- RBBayes:::.vi_distance
  expect_equal(vi(c(1, 1, 2, 2), c(2, 2, 1, 1)), 0)
  expect_equal(vi(rep(1, 4), 1:4), 2)
  expect_equal(vi(c(1, 1, 2, 2), c(1, 2, 1, 2)), 2)
})

test_that("partition summaries, credible ball and K table are coherent", {
  fit <- make_toy_sbm()
  z_hat <- partition_point_estimate(fit)
  expect_length(z_hat, 20L)
  expect_named(z_hat, fit$data$item_labels)
  tab <- posterior_K_table(fit)
  expect_equal(sum(tab$probability), 1)
  expect_s3_class(posterior_K_table(fit, format = "markdown"), "knitr_kable")
  cb <- credible_ball(fit, credible_mass = 0.9)
  expect_s3_class(cb, "btsbm_credible_ball")
  expect_gte(cb$prob_inside, 0.9)
  expect_lte(cb$n_blocks[["upper_vertical"]], cb$n_blocks[["lower_vertical"]])
  expect_lte(cb$radius, log2(20))
  stab <- block_stability(fit, z_hat)
  expect_equal(nrow(stab), length(unique(z_hat)))
  expect_true(all(stab$together <= 1 - stab$split + 1e-12))
  expect_s3_class(plot_credible_ball(cb), "ggplot")
  expect_s3_class(suppressWarnings(plot_ordered_adjacency(fit)), "ggplot")
  expect_s3_class(plot_posterior_similarity(fit), "ggplot")
})

test_that("Pr(lambda_i > lambda_j) is a coherent probability matrix", {
  fit <- make_toy_sbm()
  p <- prob_stronger(fit)
  eq <- attr(p, "prob_equal")
  total <- p + t(p) + eq
  expect_true(all(abs(total[!is.na(total)] - 1) < 1e-12))
  expect_s3_class(plot_prob_stronger(fit), "ggplot")
})

test_that("the block palette returns K distinct colours for any K", {
  for (K in c(1, 4, 8, 9, 25)) {
    pal <- RBBayes:::.block_palette(K)
    expect_length(pal, K)
    expect_equal(length(unique(pal)), K)
  }
  expect_warning(pal <- RBBayes:::.block_palette(5, c("red", "blue")), "interpolating")
  expect_length(pal, 5)
})

test_that("PL strengths are reported as shares by default", {
  data <- sushi_toy(n_rankings = 10, rank_length = 3, seed = 1)
  fit <- fit_model(data, pl_model(), mcmc_control(iter = 40, warmup = 20, seed = 2))
  expect_equal(unname(rowSums(fit$draws$item_strength)), rep(1, 20))
})
