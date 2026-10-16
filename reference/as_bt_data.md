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
  count = NULL
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

  Optional edge-list count-column name. NULL means one win per row.
  Counts must be non-negative integers. Self-comparisons are rejected.

## Value

An object of class `btsbm_pairwise_data`.
