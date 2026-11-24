make_block_scale_fit <- function() {
  data <- as_bt_data(matrix(c(0, 2, 1, 1, 0, 2, 2, 1, 0), 3),
                     item_labels = c('A', 'B', 'C'))
  fit <- fit_model(data, bt_model(), mcmc_control(iter = 4, warmup = 2, seed = 1))
  fit$model <- bt_sbm_model()
  # Unequal block sizes, a gap in the labels, and a second draw with K = 1.
  fit$draws$item_cluster <- rbind(c(1L, 1L, 3L), rep(2L, 3))
  fit$draws$latent_strength <- list(c(1, 999, 4, NA), c(NA, 7, 999))
  fit$draws$n_item_clusters <- c(2L, 1L)
  fit$draws$item_strength <- rbind(c(1, 1, 4), rep(7, 3))
  fit
}

test_that('BT-SBM normalises occupied blocks before assigning player strengths', {
  fit <- make_block_scale_fit()
  normalise <- RBBayes:::.normalise_occupied_block_strengths
  blocks <- normalise(fit$draws$item_cluster, fit$draws$latent_strength)
  expect_equal(blocks, list(c(.4, NA, 1.6, NA), c(NA, 1, NA)))
  expect_equal(vapply(blocks, mean, numeric(1), na.rm = TRUE), c(1, 1))
  theta <- posterior_strength(fit)
  expect_equal(theta, rbind(c(.4, .4, 1.6), rep(1, 3)))
  expect_equal(unname(rowMeans(theta)), c(.8, 1)) # The reference is a block mean.
  expect_equal(unname(posterior_strength(fit, summary = 'mean')), colMeans(theta))
  expect_equal(posterior_strength(fit, scale = 'raw'), fit$draws$item_strength)
  expect_equal(unname(rowSums(posterior_strength(fit, scale = 'share'))), c(1, 1))
  expect_equal(unname(as.matrix(fit)[, 1:3]), theta)
  expect_equal(unname(as.array(fit)[, 1, 1:3]), theta)
  if (requireNamespace('coda', quietly = TRUE)) {
    expect_equal(unname(as.matrix(coda::as.mcmc(fit))[, 1:3]), theta)
  }
  expect_equal(strength_summary(fit)$mean, sort(colMeans(theta), decreasing = TRUE))
  plot <- plot_strength_summary(fit)
  expect_match(plot$labels$x, 'occupied-block mean')
  expect_equal(ggplot2::ggplot_build(plot)$data[[1]]$xintercept, 1)
})

test_that('block size, unused labels and raw scale do not change the block reference', {
  normalise <- RBBayes:::.normalise_occupied_block_strengths
  raw <- list(c(1, 999, 4, NA))
  first <- normalise(matrix(c(1, 1, 3), 1), raw)
  second <- normalise(matrix(c(1, 3, 3), 1), raw)
  expect_equal(first, second)
  expect_equal(normalise(matrix(c(1, 1, 3), 1), lapply(raw, `*`, 10)), first)
  # Different blocks with the same strength still each contribute to the mean.
  expect_equal(normalise(matrix(1:3, 1), list(c(1, 1, 4)))[[1]], c(.5, .5, 2))
  fit <- make_block_scale_fit()
  theta <- posterior_strength(fit)
  raw <- fit$draws$item_strength
  p <- theta[, 1] / (theta[, 1] + theta[, 3])
  expect_equal(p, raw[, 1] / (raw[, 1] + raw[, 3]))
  changed <- fit
  changed$draws$latent_strength <- Map(`*`, fit$draws$latent_strength, c(9, .2))
  changed$draws$item_strength <- raw * c(9, .2)
  expect_equal(posterior_strength(changed), theta)
  expect_equal(prob_stronger(changed), prob_stronger(fit))
})

test_that('new BT-SBM fits store mean-one block strengths alongside raw Gamma draws', {
  data <- simulate_data('bt-sbm', n_blocks = 2, latent_strength = c(4, 1),
                        players_per_block = c(4, 2), matches_per_pair = 3, seed = 5)
  fit <- fit_model(data, bt_sbm_model(), mcmc_control(iter = 30, warmup = 15, seed = 6))
  blocks <- fit$draws$block_strength
  expect_length(blocks, 15)
  expect_equal(vapply(blocks, mean, numeric(1), na.rm = TRUE), rep(1, 15))
  for (s in seq_len(15)) {
    occupied <- unique(fit$draws$item_cluster[s, ])
    expect_equal(blocks[[s]][occupied],
                 fit$draws$latent_strength[[s]][occupied] /
                   mean(fit$draws$latent_strength[[s]][occupied]))
    expect_true(all(is.na(blocks[[s]][-occupied])))
  }
  mapped <- RBBayes:::.implied_ability_from_blocks(fit$draws$item_cluster, blocks)
  expect_equal(posterior_strength(fit), mapped)
  # A fit saved by an earlier package version can be rescaled too.
  fit$draws$block_strength <- NULL
  expect_equal(posterior_strength(fit), mapped)
})
