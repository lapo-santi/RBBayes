# Figure 4 plotting function Assignment probability heatmap (BT-SBM)

Heatmap of item-wise posterior assignment probabilities for clusters,
conditional on a chosen occupied-cluster count. Draws are relabelled so
that Cluster 1 is the strongest block by decreasing \\\lambda\\. Items
are ordered by their most probable cluster and marginal wins.

## Usage

``` r
plot_assignment_probabilities(
  fit,
  w_ij = NULL,
  max_n_clust = NULL,
  players_df = NULL,
  players_id_col = NULL,
  labels = NULL,
  labels_key_col = NULL,
  labels_value_col = NULL,
  clean_display_labels = NULL,
  clean_fun = clean_players_names,
  x_hat = NULL,
  order_ids = NULL,
  k_show = NULL,
  fill_low = "#B2182B",
  fill_high = "#2166AC",
  fill_mid = "#F7F7F7",
  show_values = NULL,
  z_hat = NULL
)
```

## Arguments

- fit:

  A BT–SBM `btsbm_fit` object, or relabelled sampler output for
  compatibility.

- w_ij:

  Optional wins matrix to compute marginal wins for ordering and
  annotation. If `NULL`, items are ordered by most-probable cluster
  only.

- max_n_clust:

  Number of occupied clusters on which to condition the assignment
  probabilities. If `NULL`, the posterior modal number is used.

- players_df:

  Optional data.frame for label lookup (e.g. season metadata).

- players_id_col:

  Optional column name in `players_df` that matches item IDs.

- labels:

  Optional character vector of display labels. Either named by item ID,
  or aligned with the items.

- labels_key_col:

  Optional column name in `players_df` to match item IDs.

- labels_value_col:

  Optional column name in `players_df` containing display labels.

- clean_display_labels:

  If `TRUE`, applies `clean_fun` to display labels.

- clean_fun:

  Optional function to prettify names. Defaults to
  [`clean_players_names()`](https://laposanti.github.io/BTSBM/reference/clean_players_names.md).

- x_hat:

  Optional hard partition used to order players by cluster.

- order_ids:

  Optional character vector specifying explicit item order.

- k_show:

  Compatibility alias for `max_n_clust`.

- fill_low, fill_mid, fill_high:

  Colours at probability 0, 0.5 and 1. The scale diverges at 0.5, so
  blue cells mark items that are more likely than not to belong to that
  block.

- show_values:

  Print the probabilities in the cells; defaults to `TRUE` for at most
  30 items.

- z_hat:

  Preferred name for `x_hat`: a hard partition used for ordering.

## Value

A `ggplot` object.

## Examples

``` r
if (FALSE) { # \dontrun{
p <- plot_assignment_probabilities(fit, w_ij)
} # }
```
