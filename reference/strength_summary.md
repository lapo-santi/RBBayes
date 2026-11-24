# Summarise posterior item strengths with credible intervals

This is a compact numerical companion to
[`plot_strength_summary()`](https://lapo-santi.github.io/RBBayes/reference/plot_strength_summary.md).
By default strengths are reported as relative strengths: in every draw
each \\\lambda_i\\ is divided by the arithmetic mean of all item
strengths, except for BT–SBM, which uses the mean across occupied blocks
before mapping block strengths to items. Thus a value of 2 means twice
the mean item strength for standard BT/PL, or twice the mean
occupied-block strength for BT–SBM. The reporting scale does not depend
on the arbitrary raw scale. A larger value means a higher chance of
beating (BT) or being preferred to (PL) others.

## Usage

``` r
strength_summary(
  fit,
  credible_mass = 0.9,
  scale = c("relative", "share", "raw")
)
```

## Arguments

- fit:

  A simple BT/PL or item-SBM btsbm_fit object.

- credible_mass:

  Width of the central posterior interval, in (0, 1).

- scale:

  `"relative"` (default, arithmetic mean one), `"share"` (item shares
  summing to one), or `"raw"` (the strengths as stored by the sampler).
  For BT–SBM, `"relative"` uses the occupied-block mean.

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
#> 1 Item_1    1      1     1     1
#> 2 Item_2    1      1     1     1
```
