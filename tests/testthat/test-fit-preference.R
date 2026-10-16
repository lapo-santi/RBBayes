test_that("model-neutral fitting works for both likelihoods and preserves old results", {
  pairwise <- as_bt_data(matrix(c(0, 3, 1, 0), 2, 2))
  ranking <- as_rankings(matrix(c(1, 2, 2, 1), 2, 2, byrow = TRUE))
  control <- mcmc_control(iter = 24, warmup = 12, seed = 12)
  for (example in list(list(data = pairwise, model = bt_model()),
                       list(data = ranking, model = pl_model()))) {
    neutral <- fit_preference(example$data, example$model, control)
    legacy <- fit_btsbm(example$data, example$model, control)
    expect_s3_class(neutral, "btsbm_fit")
    expect_equal(neutral$draws, legacy$draws)
    expect_equal(neutral$model, legacy$model)
    expect_identical(neutral$call[[1]], quote(fit_preference))
  }
})
