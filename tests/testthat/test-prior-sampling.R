test_that("prior count simulations agree with independently propagated probabilities", {
  n <- 20L
  B <- 100000L
  priors <- list(gnedin_prior(0.5), dirichlet_process_prior(1.2),
                 pitman_yor_prior(1, 0.2), dirichlet_multinomial_prior(4, 1))
  for (i in seq_along(priors)) {
    prior <- priors[[i]]
    # Propagate the exact distribution instead of simulating a path.
    probability <- c(1, rep(0, n - 1L))
    for (m in seq_len(n - 1L)) {
      next_probability <- numeric(n)
      for (k in seq_len(m)) {
        new_group <- switch(prior$type,
          gnedin = k * (k - prior$gamma) / (m * (m + prior$gamma)),
          dp = prior$alpha / (m + prior$alpha),
          py = (prior$alpha + k * prior$sigma) / (m + prior$alpha),
          dm = prior$beta * (prior$K - k) / (m + prior$K * prior$beta))
        next_probability[k] <- next_probability[k] + probability[k] * (1 - new_group)
        next_probability[k + 1L] <- next_probability[k + 1L] + probability[k] * new_group
      }
      probability <- next_probability
    }
    samples <- prior_sample_K(n, prior, draws = B, seed = 30 + i)
    expect_type(samples, "integer")
    expect_true(all(samples >= 1 & samples <= n))
    observed <- tabulate(samples, nbins = n) / B
    # Six Monte Carlo standard errors, including a small allowance for rare cells.
    tolerance <- 6 * sqrt(probability * (1 - probability) / B) + 6 / B
    expect_true(all(abs(observed - probability) <= tolerance))
    variance <- sum((seq_len(n) - prior_mean_K(n, prior))^2 * probability)
    expect_lt(abs(mean(samples) - prior_mean_K(n, prior)), 6 * sqrt(variance / B))
  }
})

test_that("prior simulation handles boundaries, seeds and invalid inputs", {
  expect_identical(prior_sample_K(20, gnedin_prior(.5), 50, seed = 9),
                   prior_sample_K(20, gnedin_prior(.5), 50, seed = 9))
  expect_identical(prior_sample_K(1, gnedin_prior(.5), 5), rep(1L, 5))
  expect_identical(prior_sample_K(20, dirichlet_multinomial_prior(1), 5), rep(1L, 5))
  expect_true(all(prior_sample_K(20, dirichlet_multinomial_prior(4), 100) <= 4))
  expect_error(prior_sample_K(0, gnedin_prior(.5)), "positive integer")
  expect_error(prior_sample_K(20, gnedin_prior(.5), draws = 0), "draws")
  expect_error(prior_sample_K(20, gnedin_prior(.5), draws = 1.5), "draws")
})
