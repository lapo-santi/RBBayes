# Summarise posterior item strengths with credible intervals

This is a compact numerical companion to
[`plot_strength_summary()`](https://lapo-santi.github.io/RBBayes/reference/plot_strength_summary.md).
By default strengths are reported as relative strengths: in every draw
each \\\lambda_i\\ is divided by \\\sum_j \lambda_j\\, so they are
shares that add to one and do not depend on the arbitrary overall scale.
A larger value means a higher chance of beating (BT) or being preferred
to (PL) others.

## Usage

``` r
strength_summary(fit, credible_mass = 0.9, scale = c("relative", "raw"))
```

## Arguments

- fit:

  A simple BT/PL or item-SBM btsbm_fit object.

- credible_mass:

  Width of the central posterior interval, in (0, 1).

- scale:

  `"relative"` (default, shares adding to one) or `"raw"` (the strengths
  as stored by the sampler).

## Value

A data frame with one row per item, ordered from larger to smaller
posterior mean strength.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
strength_summary(fit)
#>     item mean median lower upper
#> 1 Item_1  0.5    0.5   0.5   0.5
#> 2 Item_2  0.5    0.5   0.5   0.5
```
