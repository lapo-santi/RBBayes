# Plot posterior probabilities that one item is stronger than another

Heatmap of \\\Pr(\lambda_i \> \lambda_j \mid y)\\ (row item \\i\\,
column item \\j\\). The colour scale diverges at 0.5: blue cells mean
the row item is probably stronger, red cells mean it is probably weaker,
and white cells mean the data cannot tell them apart. In a block model,
pairs in the same block are tied, so both directions can be well below
0.5.

## Usage

``` r
plot_prob_stronger(fit, show_values = NULL, max_items = NULL)
```

## Arguments

- fit:

  A simple BT/PL or item-block `btsbm_fit`.

- show_values:

  Print probabilities in the cells. Defaults to `TRUE` for at most 20
  items.

- max_items:

  Optional: show only the strongest `max_items` items.

## Value

A ggplot object.
