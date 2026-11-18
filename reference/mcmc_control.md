# Set MCMC controls for an RBBayes fit

Set MCMC controls for an RBBayes fit

## Usage

``` r
mcmc_control(
  iter = 2000,
  warmup = floor(iter/2),
  seed = NULL,
  store = c("minimal", "augmented"),
  init_item_cluster = NULL,
  init_ranking_cluster = NULL,
  verbose = FALSE,
  progress_every = 1000L,
  partition_moves = NULL
)
```

## Arguments

- iter:

  Total MCMC iterations.

- warmup:

  Number of warmup iterations.

- seed:

  Optional integer seed.

- store:

  Whether to store the minimal state or latent augmentations.

- init_item_cluster:

  Optional initial item partition.

- init_ranking_cluster:

  Optional initial ranking partition for PL mixture and PL–LBM models.

- verbose:

  Whether to report progress.

- progress_every:

  Progress frequency when `verbose` is `TRUE`.

- partition_moves:

  Optional result of
  [`partition_moves()`](https://lapo-santi.github.io/RBBayes/reference/partition_moves.md).

## Value

An object of class `btsbm_mcmc_control`.

## Examples

``` r
mcmc_control(iter = 100, warmup = 50, seed = 1)
#> $iter
#> [1] 100
#> 
#> $warmup
#> [1] 50
#> 
#> $seed
#> [1] 1
#> 
#> $store
#> [1] "minimal"
#> 
#> $init_item_cluster
#> NULL
#> 
#> $init_ranking_cluster
#> NULL
#> 
#> $verbose
#> [1] FALSE
#> 
#> $progress_every
#> [1] 1000
#> 
#> $partition_moves
#> NULL
#> 
#> attr(,"class")
#> [1] "btsbm_mcmc_control"
```
