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

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
log_lik(fit)
#>            [,1]
#>  [1,] -1.163151
#>  [2,] -1.163151
#>  [3,] -1.163151
#>  [4,] -1.163151
#>  [5,] -1.163151
#>  [6,] -1.163151
#>  [7,] -1.163151
#>  [8,] -1.163151
#>  [9,] -1.163151
#> [10,] -1.163151
#> [11,] -1.163151
#> [12,] -1.163151
#> [13,] -1.163151
#> [14,] -1.163151
#> [15,] -1.163151
#> [16,] -1.163151
#> [17,] -1.163151
#> [18,] -1.163151
#> [19,] -1.163151
#> [20,] -1.163151
#> [21,] -1.163151
#> [22,] -1.163151
#> [23,] -1.163151
#> [24,] -1.163151
#> [25,] -1.163151
#> [26,] -1.163151
#> [27,] -1.163151
#> [28,] -1.163151
#> [29,] -1.163151
#> [30,] -1.163151
#> attr(,"unit_index")
#>        row col
#> Item_1   1   2
```
