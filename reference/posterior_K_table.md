# Posterior distribution of the number of blocks K

Tabulates \\\Pr(K = k \mid y)\\, where \\K\\ is the number of occupied
item blocks, from the saved draws of a block model.

## Usage

``` r
posterior_K_table(
  fit,
  format = c("data.frame", "html", "latex", "markdown"),
  digits = 3,
  p_min = 0
)
```

## Arguments

- fit:

  A block-model `btsbm_fit`.

- format:

  `"data.frame"` (default) returns a data frame with one row per value
  of K. `"html"`, `"latex"` or `"markdown"` return a formatted
  [`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html) table
  with one column per value of K.

- digits:

  Rounding used for formatted tables.

- p_min:

  Values of K with posterior probability at most `p_min` are dropped.

## Value

A data frame (columns `K`, `draws`, `probability`) or a kable.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
posterior_K_table(fit)
#>   K draws probability
#> 1 1    30           1
```
