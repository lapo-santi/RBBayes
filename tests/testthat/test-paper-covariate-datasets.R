test_that("NFL paper fixture preserves table alignment and incompleteness", {
  data <- nfl_quarterbacks_2014()

  expect_equal(dim(data$ranking_positions), c(24L, 13L))
  expect_equal(dim(data$item_covariates), c(24L, 11L))
  expect_identical(rownames(data$ranking_positions), rownames(data$item_covariates))
  expect_equal(data$ranking_positions["Andrew Luck", "Expert_01"], 1)
  expect_true(is.na(data$ranking_positions["Brian Hoyer", "Expert_02"]))
  expect_equal(data$item_covariates["Peyton Manning", "rushing_yards_per_game"], -0.7)
})

test_that("orthodontics excerpt keeps within-group ranks and covariates", {
  data <- orthodontics_excerpt_2009()

  expect_named(data$ranking_positions, c("A", "H"))
  expect_equal(dim(data$ranking_positions$A), c(12L, 15L))
  expect_equal(dim(data$ranking_positions$H), c(12L, 15L))
  expect_true(all(vapply(data$ranking_positions, function(x) {
    all(apply(x, 2L, function(rank_column) all(sort(rank_column) == 1:12)))
  }, logical(1))))
  expect_equal(dim(data$item_covariates), c(24L, 11L))
  expect_identical(rownames(data$item_covariates), c(rownames(data$ranking_positions$A), rownames(data$ranking_positions$H)))
  expect_equal(data$item_covariates["A1", "upper_right_segment"], 1.56)
})
