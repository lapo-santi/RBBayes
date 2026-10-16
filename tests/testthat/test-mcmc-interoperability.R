make_interop_fit <- function(seed = 12, iter = 30, warmup = 10) {
  data <- as_bt_data(matrix(c(0, 8, 3, 2, 0, 5, 7, 5, 0), 3, 3, byrow = TRUE),
                     item_labels = c("A", "B", "C"))
  fit_model(data, bt_model(), mcmc_control(iter = iter, warmup = warmup, seed = seed))
}

test_that("fit_model is the canonical fitter and earlier names remain compatible", {
  fit <- make_interop_fit()
  expect_identical(fit$call[[1]], quote(fit_model))
  for (fitter in list(fit_preference, fit_btsbm)) {
    other <- fitter(fit$data, fit$model, fit$control)
    expect_equal(other$draws, fit$draws)
  }
})

test_that("matrix and array conversions preserve draw values and dimensions", {
  fit <- make_interop_fit()
  draws <- as.matrix(fit)
  expect_equal(unname(rowSums(draws)), rep(1, 20))
  expect_identical(colnames(draws), paste0("q[", 1:3, "]"))
  expect_equal(unname(as.matrix(fit, normalise = FALSE)),
               unname(fit$draws$item_strength))
  array <- as.array(fit, pars = c("q[3]", "q[1]"))
  expect_equal(dim(array), c(20L, 1L, 2L))
  expect_equal(unname(array[, 1, ]), unname(draws[, c(3, 1)]))
  expect_equal(dim(as.array(fit, pars = "q[1]")), c(20L, 1L, 1L))
  expect_error(as.matrix(fit, pars = "missing"), "available")
  expect_error(as.matrix(fit, pars = c("q[1]", "q[1]")), "distinct")
  expect_error(as.matrix(fit, normalise = NA), "TRUE or FALSE")
})

test_that("multiple chains preserve their identities and reject incompatible fits", {
  first <- make_interop_fit(12)
  second <- make_interop_fit(13)
  array <- as_draws_array(list(first, second))
  expect_equal(dim(array), c(20L, 2L, 3L))
  expect_equal(unname(array[, 1, ]), unname(as.matrix(first)))
  expect_equal(unname(array[, 2, ]), unname(as.matrix(second)))
  expect_error(as_draws_array(list()), "non-empty")
  expect_error(as_draws_array(list(first, make_interop_fit(iter = 32))), "equal retained")
  changed <- second
  changed$data$item_labels <- rev(changed$data$item_labels)
  expect_error(as_draws_array(list(first, changed)), "item order")
  changed <- second
  changed$model <- bt_sbm_model()
  expect_error(as_draws_array(list(first, changed)), "model specification")
})

test_that("coda dispatch works and retains original iteration numbering", {
  skip_if_not_installed("coda")
  fit <- make_interop_fit()
  chain <- coda::as.mcmc(fit)
  expect_s3_class(chain, "mcmc")
  expect_equal(coda::mcpar(chain), c(11, 30, 1))
  expect_equal(unname(as.matrix(chain)), unname(as.matrix(fit)))
  expect_length(coda::effectiveSize(chain), 3)
  expect_s3_class(coda::as.mcmc.list(fit), "mcmc.list")
  chains <- as_mcmc_chains(list(fit, make_interop_fit(13)))
  expect_equal(coda::nchain(chains), 2)
  expect_equal(coda::varnames(chains), colnames(as.matrix(fit)))
  expect_equal(dim(coda::gelman.diag(chains, autoburnin = FALSE,
                                    multivariate = FALSE)$psrf), c(3L, 2L))
  expect_error(as_mcmc_chains(list(fit, make_interop_fit(iter = 31, warmup = 11))),
               "equal warm-up")
})

test_that("bayesplot accepts fits directly and combined arrays", {
  skip_if_not_installed("bayesplot")
  fit <- make_interop_fit()
  expect_s3_class(bayesplot::mcmc_trace(fit, pars = "q[1]"), "ggplot")
  expect_s3_class(bayesplot::mcmc_intervals(fit, pars = c("q[1]", "q[2]")), "ggplot")
  expect_s3_class(bayesplot::mcmc_dens_overlay(
    as_draws_array(list(fit, make_interop_fit(13))), pars = "q[1]"), "ggplot")
})

test_that("converters expose only fixed-dimensional quantities for latent models", {
  data <- sushi_toy(n_rankings = 8, rank_length = 3, seed = 1)
  models <- list(pl_model(), pl_sbm_model(), pl_mixture_model(), pl_lbm_model())
  for (model in models) {
    fit <- fit_model(data, model, mcmc_control(iter = 16, warmup = 8, seed = 2))
    draws <- as.matrix(fit)
    expect_equal(nrow(draws), 8)
    expect_true(all(is.finite(draws)))
    expect_false(any(grepl("allocation|lambda", colnames(draws))))
    if (is.null(fit$draws$item_strength)) {
      expect_true(all(colnames(draws) %in% c("K_item", "K_ranking")))
    }
  }
})
