# Dirichlet–multinomial prior for a latent partition

Defines a symmetric Dirichlet distribution over a fixed number of
available groups, integrated out to obtain a prior on item allocations.

## Usage

``` r
dirichlet_multinomial_prior(max_clusters, concentration = 1)
```

## Arguments

- max_clusters:

  Positive integer number of available groups.

- concentration:

  Positive Dirichlet parameter for each group; the total concentration
  is `max_clusters * concentration`.

## Value

An object of class `btsbm_partition_prior`.
