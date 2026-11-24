# Fixed draws make the reporting convention and its interpretation testable.
make_scale_fit <- function() {
  wins <- matrix(c(0, 2, 1, 1, 0, 2, 2, 1, 0), nrow = 3)
  data <- as_bt_data(wins, item_labels = c('A', 'B', 'C'))
  fit <- fit_model(data, bt_model(), mcmc_control(iter = 4, warmup = 2, seed = 1))
  fit$draws$item_strength <- rbind(c(1, 1, 4), c(4, 2, 2))
  fit
}

test_that('normalisation precedes averaging and is invariant to draw-specific scaling', {
  fit <- make_scale_fit()
  raw <- fit$draws$item_strength
  theta <- posterior_strength(fit)
  expect_equal(unname(rowMeans(theta)), c(1, 1))
  expect_equal(theta, rbind(c(.5, .5, 2), c(1.5, .75, .75)))
  expect_equal(posterior_strength(fit, scale = 'share'), theta / 3)
  expect_equal(posterior_strength(fit, scale = 'raw'), raw)
  expect_equal(unname(posterior_strength(fit, summary = 'mean')), colMeans(theta))
  expect_false(isTRUE(all.equal(colMeans(theta), colMeans(raw) / mean(raw))))
  changed <- fit
  changed$draws$item_strength <- raw * c(9, .2)
  expect_equal(posterior_strength(changed), theta)
  expect_equal(strength_summary(changed), strength_summary(fit))
  expect_equal(strength_summary(fit, scale = 'share')$mean,
               strength_summary(fit)$mean / 3)
  expect_equal(unname(as.matrix(fit)), theta)
  expect_equal(ggplot2::ggplot_build(plot_strength_summary(fit))$data[[1]]$xintercept, 1)
})

test_that('reference-player odds and pairwise probabilities use the same strengths', {
  fit <- make_scale_fit()
  raw <- fit$draws$item_strength
  theta <- posterior_strength(fit)
  p_reference <- raw / (raw + rowMeans(raw))
  expect_equal(p_reference, theta / (1 + theta))
  expect_equal(p_reference / (1 - p_reference), theta)
  expect_equal(raw[, 1] / (raw[, 1] + raw[, 3]),
               theta[, 1] / (theta[, 1] + theta[, 3]))
  changed <- fit
  changed$draws$item_strength <- raw * c(9, .2)
  expect_equal(prob_stronger(fit), prob_stronger(changed))
})

test_that('PL reporting weights unequal item blocks and retains older scales', {
  normalise <- RBBayes:::.normalise_strength
  expect_equal(pl_identifiability()$method, 'mean')
  expect_equal(normalise(c(1, 4), 'mean', weights = c(2, 1)), c(.5, 2))
  expect_equal(normalise(c(1, 4), 'sum'), c(.2, .8))
  expect_equal(normalise(c(1, 4), 'none'), c(1, 4))
  expect_equal(prod(normalise(c(1, 4), 'logmean0')), 1)
  data <- sushi_toy(n_rankings = 8, rank_length = 3, seed = 1)
  for (model in list(pl_model(), pl_sbm_model(), pl_lbm_model())) {
    fit <- fit_model(data, model, mcmc_control(iter = 12, warmup = 6, seed = 2))
    if (!is.null(fit$draws$item_strength)) {
      expect_equal(unname(rowMeans(fit$draws$item_strength)), rep(1, 6))
    } else {
      for (s in seq_len(6)) {
        implied <- fit$draws$cell_strength[[s]][, fit$draws$item_cluster[s, ], drop = FALSE]
        expect_equal(unname(rowMeans(implied)), rep(1, nrow(implied)))
      }
    }
  }
})
