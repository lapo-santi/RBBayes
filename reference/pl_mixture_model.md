# Define a Plackett–Luce ranking-mixture model

Ranking rows are assigned to latent preference groups. Each group has a
separate vector of item strengths.

## Usage

``` r
pl_mixture_model(
  shape_lambda = 1,
  rate_lambda = 1,
  ranking_clustering = gnedin_prior(gnedin_hyper = 0.5),
  identifiability = pl_identifiability(),
  latent_strength = NULL,
  ability_prior = NULL,
  ranking_prior = NULL
)
```

## Arguments

- shape_lambda, rate_lambda:

  Shape and rate of the Gamma prior on every strength \\\lambda\\.

- ranking_clustering:

  Prior on latent ranking groups.

- identifiability:

  PL reporting constraint, see
  [`pl_identifiability()`](https://laposanti.github.io/BTSBM/reference/pl_identifiability.md).

- latent_strength, ability_prior:

  Deprecated. A prior object from
  [`latent_strength()`](https://laposanti.github.io/BTSBM/reference/latent_strength.md);
  if supplied it overrides `shape_lambda` and `rate_lambda`.

- ranking_prior:

  Deprecated alias for `ranking_clustering`.

## Value

A `btsbm_model`.
