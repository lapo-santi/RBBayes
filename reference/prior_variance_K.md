# Prior variance of the number of occupied groups

Supports Gnedin and Dirichlet-process priors. Returns NA for Pitman–Yor
and Dirichlet–multinomial priors; these variance calculations are not
implemented.

## Usage

``` r
prior_variance_K(n, prior)
```

## Arguments

- n:

  Positive integer number of items.

- prior:

  A partition prior created by a clustering-prior constructor.

## Value

A numeric scalar, or NA for unimplemented variance families.
