# Convert validated comparison or ranking data to a long table

Pairwise data become `winner`, `loser`, `count` rows, including zero
counts but excluding the diagonal. Ranking data become `ranking`,
`position`, `item` rows, containing only reported positions. An
unreported item in a top-m ranking is below every reported item, but its
exact position is unknown. These ordinary data frames can be passed to
[`tibble::as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html).

## Usage

``` r
# S3 method for class 'btsbm_pairwise_data'
as.data.frame(x, row.names = NULL, optional = FALSE, ...)

# S3 method for class 'btsbm_ranking_data'
as.data.frame(x, row.names = NULL, optional = FALSE, ...)
```

## Arguments

- x:

  Validated data from
  [`as_bt_data()`](https://lapo-santi.github.io/RBBayes/reference/as_bt_data.md)
  or
  [`as_rankings()`](https://lapo-santi.github.io/RBBayes/reference/as_rankings.md).

- row.names:

  Optional row names for the returned data frame.

- optional, ...:

  Passed to
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

## Value

A data frame in long format.

## Examples

``` r
comparisons <- tennis_toy()
head(as.data.frame(comparisons))
#>       winner    loser count
#> 1   Baseline      Ace     3
#> 2 Crosscourt      Ace     3
#> 3   Dropshot      Ace     2
#> 4      Elite      Ace     1
#> 5   Forehand      Ace     0
#> 6        Ace Baseline     5
head(as.data.frame(sushi_toy()))
#>     ranking position          item
#> 1 Ranking_1        1 cucumber_roll
#> 2 Ranking_1        2           egg
#> 3 Ranking_1        3    sea_urchin
#> 4 Ranking_1        4        shrimp
#> 5 Ranking_1        5          tuna
#> 6 Ranking_2        1         squid
```
