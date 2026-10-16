# Prior variance of the number of occupied groups

Compute the variance for Gnedin and Dirichlet-process priors. Variances
for Pitman–Yor and Dirichlet–multinomial priors are not implemented
here.

## Usage

``` r
prior_variance_K(n, prior)
```

## Arguments

- n:

  Positive integer number of items.

- prior:

  A partition prior returned by a clustering-prior constructor.

## Value

A numeric scalar, or `NA_real_` for Pitman–Yor and Dirichlet–multinomial
priors.
