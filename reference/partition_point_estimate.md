# Point estimate of the item partition

Summarises the posterior over the item partition \\z\\ by the partition
that minimises the posterior expected loss. With `loss = "VI"` this is
the variation-of-information estimate of Wade and Ghahramani (2018).
When the salso package is installed its search algorithm is used;
otherwise a built-in search over the sampled partitions (and
hierarchical cuts of the posterior similarity matrix) is used, so the
function always works on a fresh installation.

## Usage

``` r
partition_point_estimate(fit, loss = c("VI", "binder"))
```

## Arguments

- fit:

  A block-model `btsbm_fit`, e.g. from
  [`bt_sbm_model()`](https://lapo-santi.github.io/RBBayes/reference/bt_sbm_model.md).

- loss:

  Either `"VI"` (default) or `"binder"`.

## Value

A named integer vector with one block label per item.

## Details

Blocks are labelled so that block 1 has the largest posterior mean
strength.

## References

Wade, S. and Ghahramani, Z. (2018). Bayesian cluster analysis: point
estimation and credible balls. *Bayesian Analysis*, 13(2), 559–626.
[doi:10.1214/17-BA1073](https://doi.org/10.1214/17-BA1073)

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
partition_point_estimate(fit)
#> Warning: The number of clusters equals the default maximum possible number of clusters.
#> Item_1 Item_2 
#>      1      1 
```
