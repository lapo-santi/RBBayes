test_that("co-clustering uses every retained draw across different K values", {
  memberships <- rbind(c(1, 1, 1, 2), c(1, 1, 2, 3),
                       c(1, 2, 3, 4), c(3, 3, 4, 5))
  fit <- structure(list(
    data = as_bt_data(matrix(0, 4, 4), item_labels = c("A", "B", "C", "D")),
    draws = list(item_cluster = memberships,
                 item_strength = matrix(1, 4, 4), n_item_clusters = c(2, 3, 4, 3))
  ), class = "btsbm_fit")
  expected <- matrix(c(1, .75, .25, 0, .75, 1, .25, 0,
                       .25, .25, 1, 0, 0, 0, 0, 1), 4, 4)
  expect_equal(posterior_similarity(fit), expected)
  set.seed(100)
  p <- plot_posterior_similarity(fit, order_rows = FALSE, show_blocks = FALSE,
                                 show_values = TRUE, digits = 4)
  expect_equal(nrow(p$data), 16L)
  expect_equal(p$data$probability, as.vector(expected))
  labels <- ggplot2::ggplot_build(p)$data[[2]]$label
  expect_equal(labels, sprintf("%.4f", as.vector(expected)))
  expect_equal(p$scales$get_scales("fill")$limits, c(0, 1))
  expect_error(plot_posterior_similarity(fit, digits = 7), "digits")
})
