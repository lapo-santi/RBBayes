# Create validated Bradley–Terry pairwise data

Converts a square win-count matrix or a directed edge-list data frame
into the same validated pairwise-data representation used by
fit_model().

## Usage

``` r
as_bt_data(
  wins,
  item_labels = NULL,
  winner = "winner",
  loser = "loser",
  count = NULL,
  format = c("auto", "matrix", "edgelist", "matches")
)
```

## Arguments

- wins:

  Numeric square win-count matrix, or a data frame of directed outcomes
  with winner and loser columns. Repeated edges are added together.

- item_labels:

  Optional character vector of item names. By default, matrix row names
  are used when available. For an edge list, this is the complete item
  universe and ordering, including any unobserved items.

- winner, loser:

  Names of edge-list columns identifying the winning and losing item.
  Values are converted to character item identifiers.

- count:

  Optional edge-list count-column name. NULL means one win per row in
  the legacy `format = "auto"` interface. With `format = "edgelist"`,
  NULL selects the standard `"count"` column. Counts must be
  non-negative integers. Self-comparisons are rejected.

- format:

  Input representation: `"matrix"` for a square win-count matrix,
  `"edgelist"` for aggregated winner/loser/count rows, or `"matches"`
  for one winner/loser outcome per row. The default `"auto"` preserves
  the earlier interface: the object type determines the representation
  and `count` must be specified explicitly for aggregated rows.

## Value

An object of class `btsbm_pairwise_data`.

## Examples

``` r
as_bt_data(matrix(c(0, 2, 3, 0), 2, 2))
#> <btsbm_pairwise_data> 2 items and 5 wins
edges <- data.frame(winner = c("A", "B"), loser = c("B", "A"), count = c(3, 2))
as_bt_data(edges, format = "edgelist")
#> <btsbm_pairwise_data> 2 items and 5 wins
```
