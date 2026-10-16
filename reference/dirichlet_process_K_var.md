# Prior variance of the occupied-group count under a Dirichlet process

Sum the variances of independent Bernoulli new-group indicators with
probabilities concentration/(concentration+i-1), for i=1,...,n.

## Usage

``` r
dirichlet_process_K_var(n, concentration = 1)
```

## Arguments

- n:

  Positive integer number of items.

- concentration:

  Positive finite Dirichlet-process concentration.

## Value

A numeric scalar, the prior variance of the occupied-group count.

## Examples

``` r
dirichlet_process_K_var(20, concentration = 1)
#> [1] 2.001576
```
