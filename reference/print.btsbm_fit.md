# Print an RBBayes fit

Print an RBBayes fit

## Usage

``` r
# S3 method for class 'btsbm_fit'
print(x, ...)
```

## Arguments

- x:

  A `btsbm_fit` object.

- ...:

  Unused.

## Value

The input object, invisibly.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
print(fit)
#> <btsbm_fit> Bradley-Terry stochastic block model (BT-SBM), items share block strengths 
#>   2 items; 30 retained posterior draws. Use summary() for results.
```
