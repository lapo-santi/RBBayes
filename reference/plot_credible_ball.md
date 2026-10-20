# Plot the credible ball for the item partition

Shows the point estimate next to the upper vertical, lower vertical and
horizontal bounds of
[`credible_ball()`](https://laposanti.github.io/BTSBM/reference/credible_ball.md).
Each column is one partition; items sharing a colour are in the same
block, and block 1 is the strongest.

## Usage

``` r
plot_credible_ball(x, palette = NULL, ...)
```

## Arguments

- x:

  A `btsbm_credible_ball`, or a block-model `btsbm_fit` (in which case
  [`credible_ball()`](https://laposanti.github.io/BTSBM/reference/credible_ball.md)
  is computed with default settings).

- palette:

  Optional block colours.

- ...:

  Passed to
  [`credible_ball()`](https://laposanti.github.io/BTSBM/reference/credible_ball.md)
  when `x` is a fit.

## Value

A ggplot object.
