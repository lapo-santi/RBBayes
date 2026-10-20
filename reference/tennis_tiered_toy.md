# Simulate a tiered twenty-player tennis league

Simulate a complete league with user-specified block strengths and
sizes. A common random permutation shuffles both axes.

## Usage

``` r
tennis_tiered_toy(
  matches_per_pair = 20L,
  seed = 101L,
  n_blocks = length(latent_strength),
  latent_strength = c(12, 6, 2, 1),
  players_per_block = 5L,
  item_labels = NULL,
  format = c("data", "edgelist")
)
```

## Arguments

- matches_per_pair:

  Positive integer number of matches for each pair.

- seed:

  Integer random seed, or NULL to use the current random state.

- n_blocks:

  Positive integer number of generating blocks.

- latent_strength:

  Positive vector with one strength per generating block. The default
  `c(12, 6, 2, 1)` is on the same scale as the default Gamma prior and
  gives tiers that are separable but not perfectly so.

- players_per_block:

  Positive integer block sizes, either one common size or a vector of
  length n_blocks.

- item_labels:

  Optional unique names for all players.

- format:

  Return validated data (default) or a winner/loser/count edge list.

## Value

A btsbm_pairwise_data object, or an edge-list data frame, with
generating groups and strengths stored in its truth attribute. All
observations are synthetic.
