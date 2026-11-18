# Plot the observed outcomes ordered by the estimated blocks

Heatmap of observed win proportions \\y\_{ij}/n\_{ij}\\, with rows and
columns ordered by the point estimate of the item partition and block
boundaries drawn. This is the new name of
[`plot_block_adjacency()`](https://lapo-santi.github.io/RBBayes/reference/plot_block_adjacency.md).

## Usage

``` r
plot_ordered_adjacency(fit, z_hat = NULL, ...)
```

## Arguments

- fit:

  A BT–SBM `btsbm_fit`.

- z_hat:

  Optional partition used for the ordering; defaults to
  [`partition_point_estimate()`](https://lapo-santi.github.io/RBBayes/reference/partition_point_estimate.md).

- ...:

  Further arguments passed to
  [`plot_block_adjacency()`](https://lapo-santi.github.io/RBBayes/reference/plot_block_adjacency.md).

## Value

A ggplot object.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
plot_ordered_adjacency(fit)
#> Warning: The number of clusters equals the default maximum possible number of clusters.
```
