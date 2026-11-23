# Plot observed pairwise win counts

This descriptive heatmap is useful before fitting a Bradley–Terry model.
Rows are winners and columns are losers; it displays the number of
observed wins, not a fitted probability.

## Usage

``` r
plot_pairwise_outcomes(pairwise, reorder = FALSE, ...)

# Default S3 method
plot_pairwise_outcomes(pairwise, reorder = FALSE, ...)

# S3 method for class 'btsbm_fit'
plot_pairwise_outcomes(pairwise, reorder = FALSE, ...)

# S3 method for class 'btsbm_pairwise_data'
plot_pairwise_outcomes(pairwise, reorder = FALSE, ...)
```

## Arguments

- pairwise:

  A `btsbm_pairwise_data` object created by
  [`as_bt_data()`](https://lapo-santi.github.io/RBBayes/reference/as_bt_data.md),
  or a BT `btsbm_fit`.

- reorder:

  Logical. If TRUE, order both axes by decreasing observed overall win
  rate (total wins divided by total comparisons). Ties retain input
  order; items with no comparisons are placed last. FALSE (default)
  preserves the input item order. This is descriptive ordering, not an
  estimate of model strengths or latent blocks.

- ...:

  Reserved for method extensions.

## Value

A ggplot object.

## Details

This S3 generic dispatches on the class of `pairwise`. The data method
plots validated pairwise observations; the fitted-model method extracts
the observed data from a BT fit. Neither displays fitted probabilities.

## Examples

``` r
plot_pairwise_outcomes(tennis_toy())

plot_pairwise_outcomes(tennis_toy(), reorder = TRUE)
```
