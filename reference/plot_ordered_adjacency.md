# Plot the observed outcomes ordered by the estimated blocks

Heatmap of observed win proportions \\y\_{ij}/n\_{ij}\\, with rows and
columns ordered by the point estimate of the item partition and block
boundaries drawn. This is the new name of
[`plot_block_adjacency()`](https://laposanti.github.io/BTSBM/reference/plot_block_adjacency.md).

## Usage

``` r
plot_ordered_adjacency(fit, z_hat = NULL, ...)
```

## Arguments

- fit:

  A BT–SBM `btsbm_fit`.

- z_hat:

  Optional partition used for the ordering; defaults to
  [`partition_point_estimate()`](https://laposanti.github.io/BTSBM/reference/partition_point_estimate.md).

- ...:

  Further arguments passed to
  [`plot_block_adjacency()`](https://laposanti.github.io/BTSBM/reference/plot_block_adjacency.md).

## Value

A ggplot object.
