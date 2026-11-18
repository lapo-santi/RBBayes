# Summarise an RBBayes fit

Collects the main features of a fit under self-explanatory names: the
model, the data size, the priors, the MCMC run and the key posterior
results. For models with item-specific strengths, the strength table
uses relative strengths (each strength divided by the sum of all
strengths in a draw). For block models, it reports the posterior
distribution of the number of blocks \\K\\ and the point estimate of the
partition \\z\\ instead, because individual strengths are not the
natural summary there.

## Usage

``` r
# S3 method for class 'btsbm_fit'
summary(object, credible_mass = 0.9, ...)
```

## Arguments

- object:

  A `btsbm_fit` object.

- credible_mass:

  Width of the reported credible intervals.

- ...:

  Unused.

## Value

An object of class `summary.btsbm_fit`, a named list.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
summary(fit)
#> Warning: The number of clusters equals the default maximum possible number of clusters.
#> Model:   Bradley-Terry stochastic block model (BT-SBM), items share block strengths
#> Data:    2 items, 1 compared pairs, 5 comparisons
#> Priors:  lambda_k ~ iid Gamma(shape_lambda = 4, rate_lambda = 3.512)
#>          item partition z ~ Gnedin(gnedin_hyper = 0.5)
#> MCMC:    60 iterations, 30 warm-up, 30 retained draws (0.0 s)
#> 
#> Posterior number of blocks, Pr(K = k | y):
#> 1 
#> 1 
#> 
#> Point estimate of the partition (block 1 = strongest):
#>   Block 1 (2 items): Item_1, Item_2
```
