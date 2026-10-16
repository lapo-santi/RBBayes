# Compatibility entry point for Bayesian preference models

Compatibility entry point for Bayesian preference models

## Usage

``` r
fit_btsbm(data, model, control = mcmc_control())
```

## Arguments

- data:

  A `btsbm_pairwise_data` or `btsbm_ranking_data` object created by
  [`as_bt_data()`](https://laposanti.github.io/BTSBM/reference/as_bt_data.md)
  or
  [`as_rankings()`](https://laposanti.github.io/BTSBM/reference/as_rankings.md).

- model:

  A `btsbm_model` object.

- control:

  A `btsbm_mcmc_control` object.

## Value

An object of class `btsbm_fit`.
