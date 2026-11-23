test_that("long comparison tables preserve counts, labels and isolated items", {
  wins <- matrix(c(0, 3, 0, 2, 0, 0, 0, 0, 0), 3, byrow = TRUE,
                 dimnames = list(c("Z", "A", "unplayed"), c("Z", "A", "unplayed")))
  data <- as_bt_data(wins)
  edges <- as.data.frame(data)
  expect_equal(nrow(edges), 6L)
  expect_false(any(edges$winner == edges$loser))
  expect_equal(as_bt_data(edges, item_labels = data$item_labels,
                          format = "edgelist")$wins, wins)
  totals <- pairwise_summary(data)
  expect_equal(totals$item, c("Z", "A", "unplayed"))
  expect_equal(totals$wins, c(3, 2, 0))
  expect_equal(totals$losses, c(2, 3, 0))
  expect_equal(totals$matches, c(5, 5, 0))
  expect_equal(totals$win_rate, c(0.6, 0.4, NA_real_))
  expect_equal(sum(totals$matches), 2 * sum(edges$count))
  expect_equal(as.data.frame(dplyr::as_tibble(data)), edges)
  expect_error(pairwise_summary(wins), "as_bt_data")
})

test_that("ranking tables retain row identities and top-m censoring", {
  data <- as_rankings(rbind(c(3, 1), c(2, 3)), item_count = 4,
                      ranking_labels = c("r1", "r2"),
                      item_labels = c("A", "B", "C", "unreported"))
  positions <- as.data.frame(data)
  expect_equal(positions$ranking, c("r1", "r1", "r2", "r2"))
  expect_equal(positions$position, c(1L, 2L, 1L, 2L))
  expect_equal(positions$item, c("C", "A", "B", "C"))
  expect_false("unreported" %in% positions$item)
  expect_equal(as.data.frame(dplyr::as_tibble(data)), positions)
  expect_equal(as.data.frame(data, row.names = letters[1:4]) |> rownames(), letters[1:4])
})
