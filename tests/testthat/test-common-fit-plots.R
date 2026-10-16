test_that("common fit summaries and pairwise plots support a BT--SBM fit", {
  skip_if_not_installed("ggplot2")
  pairwise <- tennis_toy(matches_per_pair = 4, seed = 101)
  fit <- fit_btsbm(
    pairwise,
    bt_sbm_model(item_clustering = finite_partition(max_clusters = 3)),
    mcmc_control(iter = 18, warmup = 9, seed = 102)
  )

  summary_data <- strength_summary(fit, credible_mass = 0.8)
  expect_equal(nrow(summary_data), pairwise$n_items)
  expect_true(all(summary_data$lower < summary_data$upper))
  expect_s3_class(plot_pairwise_outcomes(pairwise), "ggplot")
  expect_s3_class(plot_strength_summary(fit, credible_mass = 0.8), "ggplot")
  expect_s3_class(plot_rank_intervals(fit), "ggplot")
  expect_s3_class(plot_posterior_similarity(fit, target = "item"), "ggplot")
  expect_s3_class(suppressWarnings(plot_block_adjacency(fit)), "ggplot")
  assignment_plot <- plot_assignment_probabilities(fit)
  expect_s3_class(assignment_plot, "ggplot")
  expect_match(
    paste(capture.output(pretty_table_K_distribution(fit, p_min = 0)), collapse = "\n"),
    "Cluster|[123]"
  )
})

test_that("assignment probabilities condition on the requested cluster count", {
  skip_if_not_installed("ggplot2")
  pairwise <- tennis_toy(matches_per_pair = 4, seed = 109)
  fit <- fit_btsbm(
    pairwise,
    bt_sbm_model(item_clustering = finite_partition(max_clusters = 3)),
    mcmc_control(iter = 24, warmup = 12, seed = 110)
  )
  supported <- sort(unique(fit$draws$n_item_clusters))
  conditional_k <- supported[[1L]]

  plot <- plot_assignment_probabilities(fit, max_n_clust = conditional_k)
  plot_data <- plot$data
  probability_sums <- tapply(plot_data$prob, plot_data$pl_id, sum)

  expect_s3_class(plot, "ggplot")
  expect_equal(length(unique(plot_data$Cluster)), conditional_k)
  expect_equal(as.numeric(probability_sums), rep(1, length(probability_sums)))
})

test_that("common fit plots support PL data and MCMC diagnostics", {
  skip_if_not_installed("ggplot2")
  rankings <- sushi_toy(n_rankings = 12, rank_length = 4, seed = 103)
  fit <- fit_btsbm(
    rankings,
    pl_sbm_model(item_clustering = finite_partition(max_clusters = 3)),
    mcmc_control(iter = 18, warmup = 9, seed = 104)
  )

  expect_s3_class(plot_ranking_positions(rankings), "ggplot")
  expect_s3_class(plot_strength_summary(fit), "ggplot")
  expect_s3_class(plot_rank_intervals(fit), "ggplot")
  expect_s3_class(plot_posterior_similarity(fit, target = "item"), "ggplot")
  expect_s3_class(plot_mcmc_traces(fit), "ggplot")
  expect_error(plot_mcmc_traces(fit, quantities = "missing"), "No trace")
})

test_that("similarity plots work for PL mixture and PL--LBM outputs", {
  skip_if_not_installed("ggplot2")
  mixture <- fit_btsbm(
    eurovision_toy(n_rankings = 12, rank_length = 4, seed = 105),
    pl_mixture_model(ranking_clustering = finite_partition(max_clusters = 3)),
    mcmc_control(iter = 18, warmup = 9, seed = 106)
  )
  lbm <- fit_btsbm(
    pl_lbm_toy(n_rankings = 12, rank_length = 4, seed = 107),
    pl_lbm_model(
      ranking_clustering = finite_partition(max_clusters = 3),
      item_clustering = finite_partition(max_clusters = 3)
    ),
    mcmc_control(iter = 18, warmup = 9, seed = 108)
  )

  expect_s3_class(plot_posterior_similarity(mixture, target = "ranking"), "ggplot")
  expect_s3_class(plot_mcmc_traces(mixture), "ggplot")
  expect_s3_class(plot_posterior_similarity(lbm, target = "ranking"), "ggplot")
  expect_s3_class(plot_posterior_similarity(lbm, target = "item"), "ggplot")
})
