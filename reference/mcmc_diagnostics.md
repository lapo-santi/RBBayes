# Summarise MCMC mixing diagnostics

Computes a lightweight initial-positive-sequence effective sample size,
Monte Carlo standard error, and lag-one autocorrelation for saved scalar
traces. PL fits include the total ranking log likelihood; block models
also include their occupied-cluster traces.

## Usage

``` r
mcmc_diagnostics(fit)
```

## Arguments

- fit:

  A `btsbm_fit` object.

## Value

A data frame with one row per available scalar trace.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
mcmc_diagnostics(fit)
#>          quantity mean sd ess mcse autocorrelation_lag_1
#> 1 n_item_clusters    1  0  30    0                    NA
```
