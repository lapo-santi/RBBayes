# Dirichlet–multinomial prior for a latent partition

A symmetric Dirichlet prior on group weights, integrated out to give an
allocation prior.

## Usage

``` r
dirichlet_multinomial_prior(max_clusters, concentration = 1)
```

## Arguments

- max_clusters:

  Positive integer number of available groups.

- concentration:

  Positive Dirichlet parameter for each group. Total concentration is
  `max_clusters * concentration`.

## Value

An object of class `btsbm_partition_prior`.
