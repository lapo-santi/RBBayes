# Fit a Bayesian Bradley–Terry or Plackett–Luce model

Compatibility wrapper for
[`fit_model()`](https://laposanti.github.io/BTSBM/reference/fit_model.md).
New analyses should use
[`fit_model()`](https://laposanti.github.io/BTSBM/reference/fit_model.md).

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

## See also

[`fit_model`](https://laposanti.github.io/BTSBM/reference/fit_model.md)
