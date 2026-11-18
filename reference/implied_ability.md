# Compute implied item abilities from a fit

`implied_ability()` is retained as a compatibility alias for
[`posterior_strength()`](https://lapo-santi.github.io/RBBayes/reference/posterior_strength.md).
New code should use
[`posterior_strength()`](https://lapo-santi.github.io/RBBayes/reference/posterior_strength.md).

## Usage

``` r
implied_ability(fit, summary = c("draws", "mean"))
```

## Arguments

- fit:

  A simple BT/PL or item-SBM fit.

- summary:

  Either `"draws"` or `"mean"`.

## Value

A draws matrix or named posterior mean vector.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
implied_ability(fit)
#>       [,1] [,2]
#>  [1,]    1    1
#>  [2,]    1    1
#>  [3,]    1    1
#>  [4,]    1    1
#>  [5,]    1    1
#>  [6,]    1    1
#>  [7,]    1    1
#>  [8,]    1    1
#>  [9,]    1    1
#> [10,]    1    1
#> [11,]    1    1
#> [12,]    1    1
#> [13,]    1    1
#> [14,]    1    1
#> [15,]    1    1
#> [16,]    1    1
#> [17,]    1    1
#> [18,]    1    1
#> [19,]    1    1
#> [20,]    1    1
#> [21,]    1    1
#> [22,]    1    1
#> [23,]    1    1
#> [24,]    1    1
#> [25,]    1    1
#> [26,]    1    1
#> [27,]    1    1
#> [28,]    1    1
#> [29,]    1    1
#> [30,]    1    1
```
