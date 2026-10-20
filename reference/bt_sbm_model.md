# Define a Bradley–Terry stochastic block model

Item \\i\\ belongs to block \\z_i \in \\1, \ldots, K\\\\ and all items
in block \\k\\ share the strength \\\lambda_k\\: \$\$\Pr(i \text{ beats
} j \mid z, \lambda) = \frac{\lambda\_{z_i}}{\lambda\_{z_i} +
\lambda\_{z_j}}.\$\$ Block strengths are i.i.d.
\\\mathrm{Gamma}(\mathrm{shape}, \mathrm{rate})\\ and the partition
\\z\\ receives the prior `item_clustering`.

## Usage

``` r
bt_sbm_model(
  shape = 4,
  rate = exp(digamma(shape)),
  item_clustering = gnedin_prior(gnedin_hyper = 0.5),
  latent_strength = NULL,
  ability_prior = NULL,
  item_prior = NULL
)
```

## Arguments

- shape, rate:

  Shape and rate of the Gamma prior on every \\\lambda_i\\.

- item_clustering:

  Prior on the item partition \\z\\; see
  [`gnedin_prior()`](https://laposanti.github.io/BTSBM/reference/gnedin_prior.md),
  [`dirichlet_process_prior()`](https://laposanti.github.io/BTSBM/reference/dirichlet_process_prior.md),
  [`pitman_yor_prior()`](https://laposanti.github.io/BTSBM/reference/pitman_yor_prior.md)
  or
  [`dirichlet_multinomial_prior()`](https://laposanti.github.io/BTSBM/reference/dirichlet_multinomial_prior.md).

- latent_strength, ability_prior:

  Deprecated. A prior object from
  [`latent_strength()`](https://laposanti.github.io/BTSBM/reference/latent_strength.md);
  if supplied it overrides `shape` and `rate`.

- item_prior:

  Deprecated alias for `item_clustering`.

## Value

A `btsbm_model`.

## Examples

``` r
bt_sbm_model(shape = 2, item_clustering = gnedin_prior(gnedin_hyper = 0.5))
#> <btsbm_model> Bradley-Terry stochastic block model (BT-SBM), items share block strengths 
#>   strength prior:   lambda_k ~ iid Gamma(shape = 2, rate = 1.526)
#>   item partition:    z ~ Gnedin(gnedin_hyper = 0.5)
```
