# Tennis-league toy paired-comparison data

A synthetic, tiered round-robin tournament for demonstrating the
Bradley–Terry and BT–SBM interfaces. It contains no real player results.

## Usage

``` r
tennis_toy(matches_per_pair = 8L, seed = 2031L)
```

## Arguments

- matches_per_pair:

  Positive number of matches played by each pair.

- seed:

  Integer seed.

## Value

A btsbm_pairwise_data object. Its truth attribute contains the
generating player strengths and latent tiers.

## Examples

``` r
head(tennis_toy())
#> $wins
#>            Ace Baseline Crosscourt Dropshot Elite Forehand
#> Ace          0        5          5        6     7        8
#> Baseline     3        0          6        5     6        7
#> Crosscourt   3        2          0        4     5        5
#> Dropshot     2        3          4        0     5        6
#> Elite        1        2          3        3     0        5
#> Forehand     0        1          3        2     3        0
#> 
#> $n_items
#> [1] 6
#> 
#> $item_labels
#> [1] "Ace"        "Baseline"   "Crosscourt" "Dropshot"   "Elite"     
#> [6] "Forehand"  
#> 
```
