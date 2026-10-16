# Compute pointwise log likelihoods from an RBBayes fit

Compute pointwise log likelihoods from an RBBayes fit

## Usage

``` r
log_lik(object, ...)
```

## Arguments

- object:

  A `btsbm_fit` object.

- ...:

  Unused.

## Value

An `S × R` matrix with one column for each pair-count cell (BT) or whole
ranking row (PL). It has a `unit_index` attribute.
