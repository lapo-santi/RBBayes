# Define a simple Plackett–Luce model

Item strengths are i.i.d. \\\mathrm{Gamma}(\mathrm{shape},
\mathrm{rate})\\. By default reported strengths are divided by their sum
in every draw, so they are shares that add to one.

## Usage

``` r
pl_model(
  shape = 1,
  rate = 1,
  identifiability = pl_identifiability(),
  latent_strength = NULL,
  ability_prior = NULL
)
```

## Arguments

- shape, rate:

  Shape and rate of the Gamma prior on every \\\lambda_i\\.

- identifiability:

  PL reporting constraint, see
  [`pl_identifiability()`](https://laposanti.github.io/BTSBM/reference/pl_identifiability.md).

- latent_strength, ability_prior:

  Deprecated. A prior object from
  [`latent_strength()`](https://laposanti.github.io/BTSBM/reference/latent_strength.md);
  if supplied it overrides `shape` and `rate`.

## Value

A `btsbm_model`.
