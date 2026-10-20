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
