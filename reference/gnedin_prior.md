# Gnedin prior for a latent partition

A Gnedin (2010) prior allows a random but almost surely finite number of
occupied groups.

## Usage

``` r
gnedin_prior(gnedin_hyper = 0.5, gnedin_hyperparameter = NULL)
```

## Arguments

- gnedin_hyper:

  Gnedin hyperparameter \\\gamma\\ in `(0, 1)`.

- gnedin_hyperparameter:

  Deprecated alias for `gnedin_hyper`.

## Value

An object of class `btsbm_partition_prior`.

## Examples

``` r
gnedin_prior(gnedin_hyper = 0.5)
#> <clustering_prior> Gnedin(gnedin_hyper = 0.5) 
prior_mean_K(20, gnedin_prior(0.5))
#> [1] 3.988173
```
