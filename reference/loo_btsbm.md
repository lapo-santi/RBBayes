# Run Pareto-smoothed importance-sampling LOO for a fit

Run Pareto-smoothed importance-sampling LOO for a fit

## Usage

``` r
loo_btsbm(fit, ...)
```

## Arguments

- fit:

  A `btsbm_fit` object.

- ...:

  Passed to [`loo::loo()`](https://mc-stan.org/loo/reference/loo.html).

## Value

A `loo` object.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
if (requireNamespace("loo", quietly = TRUE)) loo_btsbm(fit)
#> Warning: Can't fit generalized Pareto distribution because all tail values are the same.
#> Warning: Some Pareto k diagnostic values are too high. See help('pareto-k-diagnostic') for details.
#> 
#> Computed from 30 by 1 log-likelihood matrix.
#> 
#>          Estimate SE
#> elpd_loo     -1.2 NA
#> p_loo         0.0 NA
#> looic         2.3 NA
#> ------
#> MCSE of elpd_loo is NA.
#> MCSE and ESS estimates assume independent draws (r_eff=1).
#> 
#> Pareto k diagnostic values:
#>                           Count Pct.    Min. ESS
#> (-Inf, 0.32]   (good)     0       0.0%  <NA>    
#>    (0.32, 1]   (bad)      0       0.0%  <NA>    
#>     (1, Inf)   (very bad) 1     100.0%  <NA>    
#> See help('pareto-k-diagnostic') for details.
```
