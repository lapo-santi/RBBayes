# Create validated Bradley–Terry pairwise data

Convert a square directed win-count matrix or a directed edge-list data
frame to the validated pairwise-data format used by fit_model().
Repeated edges are added and self-comparisons are rejected.

## Usage

``` r
as_bt_data(wins, item_labels = NULL, winner = "winner",
           loser = "loser", count = NULL)
```

## Arguments

- wins:

  Numeric square matrix or an edge-list data frame. For a matrix, entry
  `wins[i, j]` is the number of wins for item `i` over item `j`.

- item_labels:

  Optional character vector of item names. By default, matrix row names
  are used when available. For an edge list, this specifies the complete
  item universe and ordering, including unobserved items.

- winner,loser:

  Names of edge-list columns identifying the winning and losing item.

- count:

  Optional count-column name. NULL means one win per row. Aggregated
  counts must be non-negative integers.

## Value

An object of class `btsbm_pairwise_data`.

## Examples

``` r
edges <- data.frame(winner = c("A", "B", "A"), loser = c("B", "A", "B"), count = c(2, 1, 3))
as_bt_data(edges, count = "count")$wins
#>   A B
#> A 0 5
#> B 1 0
```
