# Summarise observed outcomes for each item

Return one row per item, in input order, for descriptive tables and
plots. An item's matches equal its wins plus its losses. Its observed
win rate is `wins / matches`, or `NA` if it has no comparisons. These
summaries do not adjust for the strengths of the opponents.

## Usage

``` r
pairwise_summary(pairwise)
```

## Arguments

- pairwise:

  Validated pairwise data from
  [`as_bt_data()`](https://lapo-santi.github.io/RBBayes/reference/as_bt_data.md).

## Value

A data frame with `item`, `matches`, `wins`, `losses` and `win_rate`.

## Examples

``` r
pairwise_summary(tennis_toy())
#>         item matches wins losses win_rate
#> 1        Ace      40   31      9    0.775
#> 2   Baseline      40   27     13    0.675
#> 3 Crosscourt      40   19     21    0.475
#> 4   Dropshot      40   20     20    0.500
#> 5      Elite      40   14     26    0.350
#> 6   Forehand      40    9     31    0.225
```
