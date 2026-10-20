test_that("Dirichlet-multinomial constructor preserves per-group concentration", {
  prior <- dirichlet_multinomial_prior(max_clusters = 4, concentration = 2)
  expect_identical(prior, finite_partition(max_clusters = 4, concentration = 2))
  expect_equal(prior$beta, 2)
  expect_error(dirichlet_multinomial_prior(0), "max_clusters")
})

test_that("summaries identify BT versus BT-SBM without changing the likelihood", {
  data <- as_bt_data(matrix(c(0, 4, 1, 0), 2, 2))
  for (structure in c("BT", "BT-SBM")) {
    model <- if (structure == "BT") bt_model() else bt_sbm_model()
    fit <- fit_preference(data, model, mcmc_control(iter = 20, warmup = 10, seed = 5))
    result <- summary(fit)
    expect_equal(result$model, structure)
    expect_equal(result$likelihood, "Bradley-Terry")
    expect_output(print(result), "Bradley-Terry")
  }
})

test_that("midranks average occupied item positions within each draw", {
  draws <- rbind(c(8, 8, 8, 2, 2), c(8, 4, 4, 4, 1))
  result <- compute_expected_wins_rank_posterior(draws, ties.method = "average")
  expect_equal(unname(result$rank_samples),
               rbind(c(2, 2, 2, 4.5, 4.5), c(1, 3, 3, 3, 5)))
})
