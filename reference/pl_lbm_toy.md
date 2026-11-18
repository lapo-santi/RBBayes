# Structured Plackett–Luce latent-block-model toy data

Generates rankings from a two-way latent block model with known
ranking-row clusters, item blocks, and a `C × K` latent-strength matrix.
It is a compact test and vignette fixture for the future PL–LBM sampler.

## Usage

``` r
pl_lbm_toy(n_rankings = 30L, rank_length = 4L, seed = 2027L)
```

## Arguments

- n_rankings:

  Number of ranking rows.

- rank_length:

  Number of reported positions.

- seed:

  Integer seed.

## Value

A `btsbm_ranking_data` object with a `"truth"` attribute containing the
generating ranking and item partitions.

## Examples

``` r
head(pl_lbm_toy())
#> $rankings
#>            Rank_1 Rank_2 Rank_3 Rank_4
#> Ranking_1       3      2      5      4
#> Ranking_2       2      1      4      6
#> Ranking_3       3      6      4      5
#> Ranking_4       6      2      3      1
#> Ranking_5       4      3      6      2
#> Ranking_6       1      2      3      4
#> Ranking_7       1      5      3      6
#> Ranking_8       1      3      2      4
#> Ranking_9       1      3      5      4
#> Ranking_10      4      3      5      2
#> Ranking_11      2      6      4      1
#> Ranking_12      2      3      4      1
#> Ranking_13      2      3      1      4
#> Ranking_14      4      3      2      1
#> Ranking_15      1      3      5      2
#> Ranking_16      2      1      6      3
#> Ranking_17      5      3      4      6
#> Ranking_18      4      3      6      5
#> Ranking_19      3      6      4      5
#> Ranking_20      2      3      4      1
#> Ranking_21      2      1      3      4
#> Ranking_22      4      2      1      3
#> Ranking_23      3      6      4      5
#> Ranking_24      2      3      4      1
#> Ranking_25      2      5      1      3
#> Ranking_26      4      2      3      1
#> Ranking_27      4      5      3      6
#> Ranking_28      1      2      4      6
#> Ranking_29      4      3      1      2
#> Ranking_30      6      3      4      2
#> 
#> $rho
#>            Rank_1 Rank_2 Rank_3 Rank_4
#> Ranking_1       3      2      5      4
#> Ranking_2       2      1      4      6
#> Ranking_3       3      6      4      5
#> Ranking_4       6      2      3      1
#> Ranking_5       4      3      6      2
#> Ranking_6       1      2      3      4
#> Ranking_7       1      5      3      6
#> Ranking_8       1      3      2      4
#> Ranking_9       1      3      5      4
#> Ranking_10      4      3      5      2
#> Ranking_11      2      6      4      1
#> Ranking_12      2      3      4      1
#> Ranking_13      2      3      1      4
#> Ranking_14      4      3      2      1
#> Ranking_15      1      3      5      2
#> Ranking_16      2      1      6      3
#> Ranking_17      5      3      4      6
#> Ranking_18      4      3      6      5
#> Ranking_19      3      6      4      5
#> Ranking_20      2      3      4      1
#> Ranking_21      2      1      3      4
#> Ranking_22      4      2      1      3
#> Ranking_23      3      6      4      5
#> Ranking_24      2      3      4      1
#> Ranking_25      2      5      1      3
#> Ranking_26      4      2      3      1
#> Ranking_27      4      5      3      6
#> Ranking_28      1      2      4      6
#> Ranking_29      4      3      1      2
#> Ranking_30      6      3      4      2
#> 
#> $n_items
#> [1] 6
#> 
#> $n_rankings
#> [1] 30
#> 
#> $rank_length
#> [1] 4
#> 
#> $ranking_labels
#>  [1] "Ranking_1"  "Ranking_2"  "Ranking_3"  "Ranking_4"  "Ranking_5" 
#>  [6] "Ranking_6"  "Ranking_7"  "Ranking_8"  "Ranking_9"  "Ranking_10"
#> [11] "Ranking_11" "Ranking_12" "Ranking_13" "Ranking_14" "Ranking_15"
#> [16] "Ranking_16" "Ranking_17" "Ranking_18" "Ranking_19" "Ranking_20"
#> [21] "Ranking_21" "Ranking_22" "Ranking_23" "Ranking_24" "Ranking_25"
#> [26] "Ranking_26" "Ranking_27" "Ranking_28" "Ranking_29" "Ranking_30"
#> 
```
