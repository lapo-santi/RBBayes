# Simulate a tiered tennis league

Simulate pairwise results from specified block strengths and sizes.
Default settings give twenty fictional players in four blocks of five. A
common random permutation shuffles both matrix axes.

## Usage

``` r
tennis_tiered_toy(matches_per_pair = 20L, seed = 101L,
  n_blocks = length(latent_strength), latent_strength = c(64, 16, 4, 1),
  players_per_block = 5L, item_labels = NULL, format = c("data", "edgelist"))
```

## Arguments

- matches_per_pair:

  Positive integer matches per pair.

- seed:

  Integer random seed, or NULL.

- n_blocks:

  Positive integer number of generating blocks.

- latent_strength:

  Positive strength vector with one value per block.

- players_per_block:

  Positive integer block sizes: a scalar or one value per block.

- item_labels:

  Optional unique names for all players.

- format:

  Return validated data or an aggregated winner/loser/count edge list.

## Value

A btsbm_pairwise_data object with a truth attribute, or an edge-list
data frame.

## Examples

``` r
edges <- tennis_tiered_toy(n_blocks = 3, latent_strength = c(25, 5, 1),
                           players_per_block = 4, format = "edgelist")
as_bt_data(edges, count = "count")
#> <btsbm_pairwise_data> 12 items and 1320 wins
```
