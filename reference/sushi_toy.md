# Sushi-inspired toy ranking data

A reproducible, synthetic teaching dataset with two preference profiles
over ten sushi types. It is designed to demonstrate
[`as_rankings()`](https://lapo-santi.github.io/RBBayes/reference/as_rankings.md),
[`pl_model()`](https://lapo-santi.github.io/RBBayes/reference/pl_model.md),
PL mixtures, and PL–LBM data shapes without redistributing
respondent-level data from the Sushi Preference Dataset.

## Usage

``` r
sushi_toy(n_rankings = 40L, rank_length = 5L, seed = 2026L)
```

## Arguments

- n_rankings:

  Number of synthetic rankings.

- rank_length:

  Number of reported positions per ranking.

- seed:

  Integer seed.

## Value

A `btsbm_ranking_data` object. Its `"truth"` attribute contains
synthetic ranking-cluster labels and the generating ability matrix.

## References

Kamishima, T. (2003). Nantonac collaborative filtering: Recommendation
based on order responses. *Proceedings of the Ninth ACM SIGKDD
International Conference on Knowledge Discovery and Data Mining*. The
original Sushi Preference Dataset must be obtained from its authors; its
licence does not allow redistribution.

## Examples

``` r
head(sushi_toy())
#> $rankings
#>            Rank_1 Rank_2 Rank_3 Rank_4 Rank_5
#> Ranking_1       9      1      5      2      3
#> Ranking_2       4      2      6     10      1
#> Ranking_3       7      5      8      3      6
#> Ranking_4      10      7      3      2      5
#> Ranking_5       5      3     10      4      8
#> Ranking_6       3      9      4      5     10
#> Ranking_7       1     10      2      3      5
#> Ranking_8       8      5      7      4      6
#> Ranking_9       1     10      2      3      9
#> Ranking_10      2      3      6      5      1
#> Ranking_11      6      1      4      7      8
#> Ranking_12      3      4      5      6      9
#> Ranking_13     10      2      4      1      3
#> Ranking_14      7      9      6      5      3
#> Ranking_15     10      5      2      8      7
#> Ranking_16      2      3      7      9      8
#> Ranking_17      5      4      7      6      8
#> Ranking_18      7      3      5      2      6
#> Ranking_19      4      1      5      3      9
#> Ranking_20      6      1      3      9      2
#> Ranking_21      3      2      7      9      6
#> Ranking_22      7      3      4      5      6
#> Ranking_23      9      4      1      2      3
#> Ranking_24      1      9      5      8      4
#> Ranking_25      5      9      2      6     10
#> Ranking_26      5      7      6     10      4
#> Ranking_27      5      6      7      2      4
#> Ranking_28      4      2     10      3      1
#> Ranking_29      5      7      2      1      3
#> Ranking_30      5      7      3      4      2
#> Ranking_31      2      5      7      9      3
#> Ranking_32      9      7      6      5      2
#> Ranking_33      1      2      8      3      7
#> Ranking_34      8      4      6      7      2
#> Ranking_35      2      6      4      5     10
#> Ranking_36      6      4      8      3      5
#> Ranking_37      3      9      7      6      2
#> Ranking_38      4     10      9      5      6
#> Ranking_39      4      8      2      6      5
#> Ranking_40      6      2      9      8      4
#> 
#> $rho
#>            Rank_1 Rank_2 Rank_3 Rank_4 Rank_5
#> Ranking_1       9      1      5      2      3
#> Ranking_2       4      2      6     10      1
#> Ranking_3       7      5      8      3      6
#> Ranking_4      10      7      3      2      5
#> Ranking_5       5      3     10      4      8
#> Ranking_6       3      9      4      5     10
#> Ranking_7       1     10      2      3      5
#> Ranking_8       8      5      7      4      6
#> Ranking_9       1     10      2      3      9
#> Ranking_10      2      3      6      5      1
#> Ranking_11      6      1      4      7      8
#> Ranking_12      3      4      5      6      9
#> Ranking_13     10      2      4      1      3
#> Ranking_14      7      9      6      5      3
#> Ranking_15     10      5      2      8      7
#> Ranking_16      2      3      7      9      8
#> Ranking_17      5      4      7      6      8
#> Ranking_18      7      3      5      2      6
#> Ranking_19      4      1      5      3      9
#> Ranking_20      6      1      3      9      2
#> Ranking_21      3      2      7      9      6
#> Ranking_22      7      3      4      5      6
#> Ranking_23      9      4      1      2      3
#> Ranking_24      1      9      5      8      4
#> Ranking_25      5      9      2      6     10
#> Ranking_26      5      7      6     10      4
#> Ranking_27      5      6      7      2      4
#> Ranking_28      4      2     10      3      1
#> Ranking_29      5      7      2      1      3
#> Ranking_30      5      7      3      4      2
#> Ranking_31      2      5      7      9      3
#> Ranking_32      9      7      6      5      2
#> Ranking_33      1      2      8      3      7
#> Ranking_34      8      4      6      7      2
#> Ranking_35      2      6      4      5     10
#> Ranking_36      6      4      8      3      5
#> Ranking_37      3      9      7      6      2
#> Ranking_38      4     10      9      5      6
#> Ranking_39      4      8      2      6      5
#> Ranking_40      6      2      9      8      4
#> 
#> $n_items
#> [1] 10
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
