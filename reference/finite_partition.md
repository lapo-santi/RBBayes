# Define a finite-Dirichlet prior for a latent partition

Define a finite-Dirichlet prior for a latent partition

## Usage

``` r
finite_partition(max_clusters, concentration = 1)
```

## Arguments

- max_clusters:

  Positive integer upper bound on the number of groups.

- concentration:

  Positive symmetric Dirichlet concentration.

## Value

An object of class `btsbm_partition_prior`.

## Examples

``` r
finite_partition(max_clusters = 4)
#> <clustering_prior> finite Dirichlet(max_clusters = 4, concentration = 1) 
```
