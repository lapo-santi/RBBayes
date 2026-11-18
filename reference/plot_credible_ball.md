# Plot the credible ball for the item partition

Shows the point estimate next to the upper vertical, lower vertical and
horizontal bounds of
[`credible_ball()`](https://lapo-santi.github.io/RBBayes/reference/credible_ball.md).
Each column is one partition; items sharing a colour are in the same
block, and block 1 is the strongest.

## Usage

``` r
plot_credible_ball(x, palette = NULL, ...)
```

## Arguments

- x:

  A `btsbm_credible_ball`, or a block-model `btsbm_fit` (in which case
  [`credible_ball()`](https://lapo-santi.github.io/RBBayes/reference/credible_ball.md)
  is computed with default settings).

- palette:

  Optional block colours.

- ...:

  Passed to
  [`credible_ball()`](https://lapo-santi.github.io/RBBayes/reference/credible_ball.md)
  when `x` is a fit.

## Value

A ggplot object.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
plot_credible_ball(credible_ball(fit))
#> Warning: The number of clusters equals the default maximum possible number of clusters.
```
