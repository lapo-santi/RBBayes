# Prior variance of the occupied-group count under a Dirichlet process

For n items and concentration alpha, new-group indicators are
independent Bernoulli variables with probabilities alpha/(alpha+i-1),
i=1,...,n. Their summed variances give the prior variance of K_n.

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
