# Plot posterior item strengths and their uncertainty

This forest plot answers a first analysis question: which items appear
stronger, and how uncertain is that ordering? Overlapping intervals mean
that the data do not cleanly distinguish the corresponding strengths.

## Usage

``` r
plot_strength_summary(fit, credible_mass = 0.9)
```

## Arguments

- fit:

  A simple BT/PL or item-SBM btsbm_fit object.

- credible_mass:

  Width of the central posterior interval, in (0, 1).

## Value

A ggplot object.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
plot_strength_summary(fit)
```
