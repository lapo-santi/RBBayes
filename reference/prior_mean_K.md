# Prior expected number of occupied groups

Supports Gnedin, Dirichlet-process, Pitman–Yor and Dirichlet–multinomial
priors. The DM concentration is converted from per-group to total
concentration internally.

## Usage

``` r
prior_mean_K(n, prior)
```

## Arguments

- n:

  Positive integer number of items.

- prior:

  A partition prior created by a clustering-prior constructor.

## Value

A numeric scalar.
