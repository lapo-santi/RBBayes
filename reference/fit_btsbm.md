# Compatibility entry point for Bayesian preference models

Compatibility entry point for Bayesian preference models

## Usage

``` r
fit_btsbm(data, model, control = mcmc_control())
```

## Arguments

- data:

  A `btsbm_pairwise_data` or `btsbm_ranking_data` object created by
  [`as_bt_data()`](https://lapo-santi.github.io/RBBayes/reference/as_bt_data.md)
  or
  [`as_rankings()`](https://lapo-santi.github.io/RBBayes/reference/as_rankings.md).

- model:

  A `btsbm_model` object.

- control:

  A `btsbm_mcmc_control` object.

## Value

An object of class `btsbm_fit`.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_btsbm(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
fit
#> <btsbm_fit> Bradley-Terry stochastic block model (BT-SBM), items share block strengths 
#>   2 items; 30 retained posterior draws. Use summary() for results.
```
