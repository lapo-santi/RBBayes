# Eurovision-inspired toy ranking data

A synthetic preference-ranking dataset for a song-contest setting. Two
latent voting profiles produce different rankings of eight fictional
acts. It is designed to demonstrate
[`pl_mixture_model()`](https://lapo-santi.github.io/RBBayes/reference/pl_mixture_model.md)
without redistributing data from a real contest.

## Usage

``` r
eurovision_toy(n_rankings = 40L, rank_length = 5L, seed = 2030L)
```

## Arguments

- n_rankings:

  Number of synthetic jury or viewer rankings.

- rank_length:

  Number of reported positions per ranking.

- seed:

  Integer seed.

## Value

A btsbm_ranking_data object. Its truth attribute contains the synthetic
voter-group labels and generating latent strengths.

## Examples

``` r
head(eurovision_toy())
#> $rankings
#>            Rank_1 Rank_2 Rank_3 Rank_4 Rank_5
#> Ranking_1       5      1      6      7      3
#> Ranking_2       1      6      3      8      2
#> Ranking_3       1      7      8      3      5
#> Ranking_4       6      1      8      3      7
#> Ranking_5       4      7      5      3      2
#> Ranking_6       7      6      2      4      8
#> Ranking_7       5      1      4      7      3
#> Ranking_8       6      8      5      4      2
#> Ranking_9       5      4      1      6      2
#> Ranking_10      8      6      4      2      5
#> Ranking_11      1      7      4      3      5
#> Ranking_12      2      4      8      1      6
#> Ranking_13      6      7      1      5      3
#> Ranking_14      5      7      1      4      8
#> Ranking_15      3      7      1      5      4
#> Ranking_16      8      4      6      2      1
#> Ranking_17      5      2      4      8      7
#> Ranking_18      6      4      2      3      1
#> Ranking_19      8      4      6      5      1
#> Ranking_20      1      7      3      2      4
#> Ranking_21      3      1      6      8      5
#> Ranking_22      6      5      3      1      7
#> Ranking_23      5      2      1      3      6
#> Ranking_24      2      7      4      6      5
#> Ranking_25      3      2      5      4      7
#> Ranking_26      8      7      3      1      5
#> Ranking_27      1      8      3      7      6
#> Ranking_28      1      3      2      8      5
#> Ranking_29      7      8      6      5      1
#> Ranking_30      7      4      1      2      6
#> Ranking_31      2      5      4      8      7
#> Ranking_32      8      2      5      6      4
#> Ranking_33      2      4      6      8      7
#> Ranking_34      6      8      1      3      4
#> Ranking_35      3      6      2      8      7
#> Ranking_36      3      2      7      4      6
#> Ranking_37      5      4      1      3      6
#> Ranking_38      3      5      8      4      2
#> Ranking_39      7      1      4      2      8
#> Ranking_40      1      6      7      5      4
#> 
#> $rho
#>            Rank_1 Rank_2 Rank_3 Rank_4 Rank_5
#> Ranking_1       5      1      6      7      3
#> Ranking_2       1      6      3      8      2
#> Ranking_3       1      7      8      3      5
#> Ranking_4       6      1      8      3      7
#> Ranking_5       4      7      5      3      2
#> Ranking_6       7      6      2      4      8
#> Ranking_7       5      1      4      7      3
#> Ranking_8       6      8      5      4      2
#> Ranking_9       5      4      1      6      2
#> Ranking_10      8      6      4      2      5
#> Ranking_11      1      7      4      3      5
#> Ranking_12      2      4      8      1      6
#> Ranking_13      6      7      1      5      3
#> Ranking_14      5      7      1      4      8
#> Ranking_15      3      7      1      5      4
#> Ranking_16      8      4      6      2      1
#> Ranking_17      5      2      4      8      7
#> Ranking_18      6      4      2      3      1
#> Ranking_19      8      4      6      5      1
#> Ranking_20      1      7      3      2      4
#> Ranking_21      3      1      6      8      5
#> Ranking_22      6      5      3      1      7
#> Ranking_23      5      2      1      3      6
#> Ranking_24      2      7      4      6      5
#> Ranking_25      3      2      5      4      7
#> Ranking_26      8      7      3      1      5
#> Ranking_27      1      8      3      7      6
#> Ranking_28      1      3      2      8      5
#> Ranking_29      7      8      6      5      1
#> Ranking_30      7      4      1      2      6
#> Ranking_31      2      5      4      8      7
#> Ranking_32      8      2      5      6      4
#> Ranking_33      2      4      6      8      7
#> Ranking_34      6      8      1      3      4
#> Ranking_35      3      6      2      8      7
#> Ranking_36      3      2      7      4      6
#> Ranking_37      5      4      1      3      6
#> Ranking_38      3      5      8      4      2
#> Ranking_39      7      1      4      2      8
#> Ranking_40      1      6      7      5      4
#> 
#> $n_items
#> [1] 8
#> 
#> $n_rankings
#> [1] 40
#> 
#> $rank_length
#> [1] 5
#> 
#> $ranking_labels
#>  [1] "Ranking_1"  "Ranking_2"  "Ranking_3"  "Ranking_4"  "Ranking_5" 
#>  [6] "Ranking_6"  "Ranking_7"  "Ranking_8"  "Ranking_9"  "Ranking_10"
#> [11] "Ranking_11" "Ranking_12" "Ranking_13" "Ranking_14" "Ranking_15"
#> [16] "Ranking_16" "Ranking_17" "Ranking_18" "Ranking_19" "Ranking_20"
#> [21] "Ranking_21" "Ranking_22" "Ranking_23" "Ranking_24" "Ranking_25"
#> [26] "Ranking_26" "Ranking_27" "Ranking_28" "Ranking_29" "Ranking_30"
#> [31] "Ranking_31" "Ranking_32" "Ranking_33" "Ranking_34" "Ranking_35"
#> [36] "Ranking_36" "Ranking_37" "Ranking_38" "Ranking_39" "Ranking_40"
#> 
```
