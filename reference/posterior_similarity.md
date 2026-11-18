# Compute posterior similarity for an inferred partition

Compute posterior similarity for an inferred partition

## Usage

``` r
posterior_similarity(fit, target = c("item", "ranking"))
```

## Arguments

- fit:

  A `btsbm_fit` object.

- target:

  Either `"item"` or `"ranking"`.

## Value

A posterior similarity matrix.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
posterior_similarity(fit)
#>      [,1] [,2]
#> [1,]    1    1
#> [2,]    1    1
```
