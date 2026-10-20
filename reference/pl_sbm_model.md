# Define a Plackett–Luce stochastic block model

Define a Plackett–Luce stochastic block model

## Usage

``` r
pl_sbm_model(
  shape_lambda = 1,
  rate_lambda = 1,
  item_clustering = gnedin_prior(gnedin_hyper = 0.5),
  identifiability = pl_identifiability(),
  latent_strength = NULL,
  ability_prior = NULL,
  item_prior = NULL
)
```

## Arguments

- shape_lambda, rate_lambda:

  Shape and rate of the Gamma prior on every strength \\\lambda\\.

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
  if supplied it overrides `shape_lambda` and `rate_lambda`.

- item_prior:

  Deprecated alias for `item_clustering`.

## Value

A `btsbm_model`.
