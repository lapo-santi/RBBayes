# Block-level Bradley-Terry win probabilities from player strengths

Aggregate player-level Bradley-Terry strengths into a block-by-block
table of expected win probabilities. The helper can summarise posterior
draws via the posterior mean or median, and can optionally weight
pairwise probabilities by an observed match-count matrix.

## Usage

``` r
block_winprob_table_from_lambdas(
  lambda_item,
  z,
  lambda_stat = c("mean", "median"),
  N_ij = NULL,
  include_diag = FALSE,
  diag_value = NA_real_
)
```

## Arguments

- lambda_item:

  Numeric vector of player strengths, or an iterations by players matrix
  of posterior draws.

- z:

  Integer vector of block memberships for each player.

- lambda_stat:

  Summary to use when `lambda_item` is a matrix.

- N_ij:

  Optional match-count matrix used to weight pairwise block averages.

- include_diag:

  Logical; if `TRUE`, compute within-block averages.

- diag_value:

  Value used on the diagonal when `include_diag = FALSE`.

## Value

A list with block win probabilities, contributing pair counts,
point-estimated player strengths, and block labels/sizes.

## Examples

``` r
lambda <- rbind(c(1, 2), c(1.2, 1.8), c(0.9, 2.1))
block_winprob_table_from_lambdas(lambda, z = c(1, 2))
#> $P_block
#>           Block_1   Block_2
#> Block_1        NA 0.3444444
#> Block_2 0.6555556        NA
#> 
#> $N_pairs
#>         Block_1 Block_2
#> Block_1       0       1
#> Block_2       1       0
#> 
#> $lambda_point
#> [1] 1.033333 1.966667
#> 
#> $block_sizes
#> Block_1 Block_2 
#>       1       1 
#> 
#> $block_labels
#> [1] 1 2
#> 
```
