test_that("prior means and variances agree with the group-count recursion", {
  n <- 20L
  priors <- list(gnedin_prior(0.5), dirichlet_process_prior(1),
                 pitman_yor_prior(1, 0.2), dirichlet_multinomial_prior(4, 1))
  for (prior in priors) {
    # Independently propagate P(K_m = k) using each prior's new-group mass.
    probability <- c(1, rep(0, n - 1L))
    for (m in seq_len(n - 1L)) {
      next_probability <- numeric(n)
      for (k in seq_len(m)) {
        new_group <- switch(prior$type,
          gnedin = k * (k - prior$gamma) / (m * (m + prior$gamma)),
          dp = prior$alpha / (m + prior$alpha),
          py = (prior$alpha + k * prior$sigma) / (m + prior$alpha),
          dm = prior$beta * (prior$K - k) / (m + prior$K * prior$beta))
        if (probability[k] == 0) next
        next_probability[k] <- next_probability[k] + probability[k] * (1 - new_group)
        next_probability[k + 1L] <- next_probability[k + 1L] + probability[k] * new_group
      }
      probability <- next_probability
    }
    mean_K <- sum(seq_len(n) * probability)
    expect_equal(prior_mean_K(n, prior), mean_K, tolerance = 1e-10)
    if (prior$type %in% c("gnedin", "dp")) {
      variance_K <- sum((seq_len(n) - mean_K)^2 * probability)
      expect_equal(prior_variance_K(n, prior), variance_K, tolerance = 1e-10)
    } else {
      expect_true(is.na(prior_variance_K(n, prior)))
    }
    expect_equal(prior_mean_K(1, prior), 1)
  }
  expect_equal(prior_mean_K(20, dirichlet_multinomial_prior(1)), 1)
  expect_error(prior_mean_K(0, priors[[1]]), "positive integer")
  expect_error(prior_variance_K(2.5, priors[[1]]), "positive integer")
  expect_error(prior_mean_K(20, list()), "constructor")
})

test_that("twenty-player teaching data are reproducible and consistently named", {
  first <- tennis_tiered_toy()
  expect_identical(first, tennis_tiered_toy())
  expect_equal(dim(first$wins), c(20L, 20L))
  expect_equal(unname(diag(first$wins)), rep(0, 20))
  expect_equal((first$wins + t(first$wins))[upper.tri(first$wins)], rep(20, 190))
  expect_identical(rownames(first$wins), colnames(first$wins))
  expect_identical(first$item_labels, rownames(first$wins))
  expect_equal(sort(as.numeric(table(attr(first, "truth")$item_cluster))), rep(5, 4))
  expect_error(tennis_tiered_toy(matches_per_pair = 1.5), "positive integer")
})
