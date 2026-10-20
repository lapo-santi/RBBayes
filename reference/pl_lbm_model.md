# Define a Plackett–Luce latent block model

The PL–LBM jointly partitions ranking rows and items. Each pair of
latent groups has its own positive strength.

## Usage

``` r
pl_lbm_model(
  shape = 1,
  rate = 1,
  ranking_clustering = gnedin_prior(gnedin_hyper = 0.5),
  item_clustering = gnedin_prior(gnedin_hyper = 0.5),
  identifiability = pl_identifiability(),
  latent_strength = NULL,
  ability_prior = NULL,
  ranking_prior = NULL,
  item_prior = NULL
)
```

## Arguments

- shape, rate:

  Shape and rate of the Gamma prior on every \\\lambda_i\\.

- ranking_clustering:

  Prior on latent ranking groups.

- item_clustering:

  Prior on the item partition \\z\\; see
  [`gnedin_prior()`](https://laposanti.github.io/BTSBM/reference/gnedin_prior.md),
  [`dirichlet_process_prior()`](https://laposanti.github.io/BTSBM/reference/dirichlet_process_prior.md),
  [`pitman_yor_prior()`](https://laposanti.github.io/BTSBM/reference/pitman_yor_prior.md)
  or
  [`dirichlet_multinomial_prior()`](https://laposanti.github.io/BTSBM/reference/dirichlet_multinomial_prior.md).

- identifiability:

  PL reporting constraint, see
  [`pl_identifiability()`](https://laposanti.github.io/BTSBM/reference/pl_identifiability.md).

- latent_strength, ability_prior:

  Deprecated. A prior object from
  [`latent_strength()`](https://laposanti.github.io/BTSBM/reference/latent_strength.md);
  if supplied it overrides `shape` and `rate`.

- ranking_prior:

  Deprecated alias for `ranking_clustering`.

- item_prior:

  Deprecated alias for `item_clustering`.

## Value

A `btsbm_model`.
