# Define a Bradley–Terry stochastic block model

Item \\i\\ belongs to block \\x_i \in \\1, \ldots, K\\\\ and all items
in block \\k\\ share the strength \\\lambda_k\\: \$\$\Pr(i \text{ beats
} j \mid z, \lambda) = \frac{\lambda\_{x_i}}{\lambda\_{x_i} +
\lambda\_{x_j}}.\$\$ Block strengths are i.i.d.
\\\mathrm{Gamma}(\mathrm{shape\\lambda}, \mathrm{rate\\lambda})\\ and
the partition \\z\\ receives the prior `item_clustering`.

## Usage

``` r
bt_sbm_model(
  shape_lambda = 4,
  rate_lambda = exp(digamma(shape_lambda)),
  item_clustering = gnedin_prior(gnedin_hyper = 0.5),
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
  [`gnedin_prior()`](https://lapo-santi.github.io/RBBayes/reference/gnedin_prior.md),
  [`dirichlet_process_prior()`](https://lapo-santi.github.io/RBBayes/reference/dirichlet_process_prior.md),
  [`pitman_yor_prior()`](https://lapo-santi.github.io/RBBayes/reference/pitman_yor_prior.md)
  or
  [`dirichlet_multinomial_prior()`](https://lapo-santi.github.io/RBBayes/reference/dirichlet_multinomial_prior.md).

- latent_strength, ability_prior:

  Deprecated. A prior object from
  [`latent_strength()`](https://lapo-santi.github.io/RBBayes/reference/latent_strength.md);
  if supplied it overrides `shape_lambda` and `rate_lambda`.

- item_prior:

  Deprecated alias for `item_clustering`.

## Value

A `btsbm_model`.

## Examples

``` r
bt_sbm_model(shape_lambda = 2, item_clustering = gnedin_prior(gnedin_hyper = 0.5))
#> <btsbm_model> Bradley-Terry stochastic block model (BT-SBM), items share block strengths 
#>   strength prior:   lambda_k ~ iid Gamma(shape_lambda = 2, rate_lambda = 1.526)
#>   item partition:    x ~ Gnedin(gnedin_hyper = 0.5)
```
