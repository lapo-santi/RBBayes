# Plot the posterior similarity of items or rankings

Cell \\(i, j)\\ shows \\\Pr(z_i = z_j \mid y)\\, the proportion of draws
in which the two entities share a latent group. The plot is
label-invariant, which makes it safer to interpret than raw MCMC labels.

## Usage

``` r
plot_posterior_similarity(
  fit,
  target = c("item", "ranking"),
  order_rows = TRUE,
  show_blocks = TRUE,
  show_values = NULL
)
```

## Arguments

- fit:

  A btsbm_fit object containing an item or ranking partition.

- target:

  Whether to plot latent groups of "item" or "ranking".

- order_rows:

  Whether to reorder rows and columns for display.

- show_blocks:

  Outline the blocks of the point estimate (items only).

- show_values:

  Print probabilities in cells; defaults to `TRUE` for at most 20
  entities.

## Value

A ggplot object.

## Details

For item partitions, rows are ordered by the point estimate of the
partition (blocks outlined, block 1 strongest). Values below one inside
an outlined block do not mean the items move to another block: in a
given draw the block may simply be split into finer sub-blocks. Use
[`block_stability()`](https://laposanti.github.io/BTSBM/reference/block_stability.md)
to see whether the missing mass goes to splitting or to merging.
