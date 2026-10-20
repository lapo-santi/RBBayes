# Define a simple Bradley–Terry model

Each item \\i\\ has its own positive strength \\\lambda_i\\, and
\$\$y\_{ij} \mid \lambda \sim \mathrm{Binomial}\left(n\_{ij},
\frac{\lambda_i}{\lambda_i + \lambda_j}\right).\$\$ The strengths are
given independent and identically distributed Gamma priors, \\\lambda_i
\sim \mathrm{Gamma}(\mathrm{shape}, \mathrm{rate})\\. Only the shape and
rate need to be supplied: the model knows the \\\lambda_i\\ are i.i.d.

## Usage

``` r
bt_model(
  shape = 4,
  rate = exp(digamma(shape)),
  latent_strength = NULL,
  ability_prior = NULL
)
```

## Arguments

- shape, rate:

  Shape and rate of the Gamma prior on every \\\lambda_i\\.

- latent_strength, ability_prior:

  Deprecated. A prior object from
  [`latent_strength()`](https://laposanti.github.io/BTSBM/reference/latent_strength.md);
  if supplied it overrides `shape` and `rate`.

## Value

A `btsbm_model`.

## Details

The default rate `exp(digamma(shape))` gives \\E\[\log \lambda_i\] =
0\\, so a typical strength is about one. Strengths used to simulate data
should be on a comparable scale (for example `c(12, 6, 2, 1)`, rather
than values spanning several orders of magnitude).

## Examples

``` r
bt_model(shape = 2)
#> <btsbm_model> Bradley-Terry (BT), one strength per item 
#>   strength prior:   lambda_i ~ iid Gamma(shape = 2, rate = 1.526)
```
