# Fit a Bayesian preference model

Compatibility wrapper for
[`fit_model()`](https://laposanti.github.io/BTSBM/reference/fit_model.md).
New analyses should use
[`fit_model()`](https://laposanti.github.io/BTSBM/reference/fit_model.md).

## Usage

``` r
fit_preference(data, model, control = mcmc_control())
```

## Arguments

- data:

  A pairwise-data or ranking-data object created by
  [`as_bt_data()`](https://laposanti.github.io/BTSBM/reference/as_bt_data.md)
  or
  [`as_rankings()`](https://laposanti.github.io/BTSBM/reference/as_rankings.md).

- model:

  A `btsbm_model` object specifying the likelihood and structure.

- control:

  MCMC controls created by
  [`mcmc_control()`](https://laposanti.github.io/BTSBM/reference/mcmc_control.md).

## Value

An object of class `btsbm_fit`.

## See also

[`fit_model`](https://laposanti.github.io/BTSBM/reference/fit_model.md)
