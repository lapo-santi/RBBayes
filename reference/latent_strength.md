# Gamma prior object for positive strengths (low-level)

Model constructors such as
[`bt_model()`](https://laposanti.github.io/BTSBM/reference/bt_model.md)
now take `shape` and `rate` directly, so most users never need this
function. It is kept for compatibility with code written for earlier
development versions.

## Usage

``` r
latent_strength(shape = 1, rate = 1)

gamma_ability(shape = 1, rate = 1)
```

## Arguments

- shape:

  Positive Gamma shape for each latent strength.

- rate:

  Positive Gamma rate for each latent strength.

## Value

An object of class `btsbm_strength_prior`.
