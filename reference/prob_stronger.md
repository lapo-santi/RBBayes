# Posterior probability that one item is stronger than another

Computes \\\Pr(\lambda_i \> \lambda_j \mid y)\\ for every pair of items,
as the proportion of saved draws in which item \\i\\'s strength exceeds
item \\j\\'s. The comparison is unaffected by how strengths are
normalised. In a block model, two items in the same block have exactly
equal strength; that probability, \\\Pr(z_i = z_j \mid y)\\, is returned
in the `prob_equal` attribute, so that \\\Pr(\lambda_i \> \lambda_j) +
\Pr(\lambda_j \> \lambda_i) + \Pr(\lambda_i = \lambda_j) = 1\\.

## Usage

``` r
prob_stronger(fit)
```

## Arguments

- fit:

  A simple BT/PL or item-block `btsbm_fit`.

## Value

A square matrix with rows and columns named by item; entry `[i, j]` is
\\\Pr(\lambda_i \> \lambda_j \mid y)\\. Items are ordered by decreasing
posterior mean strength.

## Examples

``` r
# \donttest{
data <- tennis_tiered_toy(seed = 1)
fit <- fit_model(data, bt_model(shape_lambda = 2),
                 mcmc_control(iter = 400, warmup = 200, seed = 1))
round(prob_stronger(fit)[1:4, 1:4], 2)
#>           Dan Moss Cara Reed Alex Vale Jack Ford
#> Dan Moss        NA      0.72      0.74      0.87
#> Cara Reed     0.28        NA      0.56      0.62
#> Alex Vale     0.26      0.44        NA      0.57
#> Jack Ford     0.13      0.38      0.43        NA
# }
```
