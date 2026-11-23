# Simulate Bradley–Terry paired comparisons

Generate synthetic paired comparisons from a standard Bradley–Terry
model (`model = "bt"`) or a model with shared block strengths
(`model = "bt-sbm"`). Every unordered pair plays `matches_per_pair`
matches. Given item strengths, pair counts are independent binomial
draws, with probability lambda_i / (lambda_i + lambda_j) that item i
wins.

## Usage

``` r
simulate_data(
  model = c("bt", "bt-sbm"),
  latent_strength = NULL,
  n_blocks = NULL,
  players_per_block = 5L,
  matches_per_pair = 20L,
  item_labels = NULL,
  seed = NULL,
  format = c("data", "edgelist", "matrix")
)
```

## Arguments

- model:

  Either `"bt"` (default) or `"bt-sbm"`.

- latent_strength:

  Positive generating strengths. Defaults to 20 distinct log-spaced item
  strengths from 12 to 1 for BT, or `c(12, 6, 2, 1)` for BT–SBM.

- n_blocks:

  Number of generating blocks, for BT–SBM only. If NULL, inferred from
  the length of `latent_strength`.

- players_per_block:

  Positive integer block sizes for BT–SBM: a scalar repeats one size, or
  a vector specifies each size separately.

- matches_per_pair:

  Positive integer match count for every unordered pair.

- item_labels:

  Optional unique item names. BT uses names on `latent_strength` when
  available, otherwise `"Item 1"`, etc. BT–SBM retains the fictional
  tennis names used by
  [`tennis_tiered_toy()`](https://lapo-santi.github.io/RBBayes/reference/tennis_tiered_toy.md).

- seed:

  Integer random seed, or NULL to use the current random state.

- format:

  Output representation: validated `"data"` (default), an aggregated
  `"edgelist"`, or a win-count `"matrix"`.

## Value

Synthetic data in the requested representation. The `"truth"` attribute
records generating item strengths, and block memberships for BT–SBM.
Edge lists include both directions and zero counts.

## Details

For BT, `latent_strength` supplies one fixed positive strength per item,
aligned with `item_labels` before the output order is shuffled. For
BT–SBM, it supplies one strength per generating block; memberships are
randomly assigned to item names subject to the requested block sizes.
These supplied strengths are not drawn from the Gamma prior used later
for model fitting.

## Examples

``` r
edges <- simulate_data("bt", latent_strength = c(A = 8, B = 3, C = 1),
                       matches_per_pair = 10, seed = 1, format = "edgelist")
as_bt_data(edges, format = "edgelist")
#> <btsbm_pairwise_data> 3 items and 30 wins
simulate_data("bt-sbm", latent_strength = c(8, 3, 1),
              players_per_block = c(2, 3, 4), seed = 1)
#> <btsbm_pairwise_data> 9 items and 720 wins
```
