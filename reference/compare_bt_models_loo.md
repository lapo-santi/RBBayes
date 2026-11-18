# Compare BT models with Pareto-smoothed importance sampling LOO

Convenience wrapper around loo for comparing two log-likelihood matrices
(simple vs clustered BT).

## Usage

``` r
compare_bt_models_loo(simple_llo, cluster_llo)

compare_bt_models_loo(simple_llo, cluster_llo)
```

## Arguments

- simple_llo:

  list returned by
  [`make_bt_simple_loo()`](https://lapo-santi.github.io/RBBayes/reference/make_bt_simple_loo.md).

- cluster_llo:

  list returned by
  [`make_bt_cluster_loo()`](https://lapo-santi.github.io/RBBayes/reference/make_bt_cluster_loo.md).

## Value

A list with:

- `simple` — `loo` object for the simple BT.

- `cluster` — `loo` object for the clustered BT–SBM.

- `comparison` — result of `loo::compare_models()`.

A list with:

- `simple` — `loo` object for the simple BT.

- `cluster` — `loo` object for the clustered BT–SBM.

- `comparison` — result of
  [`loo::loo_compare()`](https://mc-stan.org/loo/reference/loo_compare.html).

## Examples

``` r
set.seed(1)
w <- matrix(c(0, 3, 2, 2, 0, 4, 3, 1, 0), 3, 3)
lambda <- cbind(rgamma(200, 20, 20), rgamma(200, 30, 20),
                rgamma(200, 25, 20))
simple <- make_bt_simple_loo(w, lambda)
clustered <- make_bt_cluster_loo(w, lambda,
  matrix(rep(1:3, each = 200), 200, 3))
compare_bt_models_loo(simple, clustered)
#> $simple
#> 
#> Computed from 200 by 3 log-likelihood matrix.
#> 
#>          Estimate  SE
#> elpd_loo     -4.8 1.1
#> p_loo         0.3 0.2
#> looic         9.7 2.2
#> ------
#> MCSE of elpd_loo is 0.0.
#> MCSE and ESS estimates assume independent draws (r_eff=1).
#> 
#> All Pareto k estimates are good (k < 0.57).
#> See help('pareto-k-diagnostic') for details.
#> 
#> $cluster
#> 
#> Computed from 200 by 3 log-likelihood matrix.
#> 
#>          Estimate  SE
#> elpd_loo     -4.8 1.1
#> p_loo         0.3 0.2
#> looic         9.7 2.2
#> ------
#> MCSE of elpd_loo is 0.0.
#> MCSE and ESS estimates assume independent draws (r_eff=1).
#> 
#> All Pareto k estimates are good (k < 0.57).
#> See help('pareto-k-diagnostic') for details.
#> 
#> $comparison
#>   model elpd_diff se_diff p_worse diag_diff diag_elpd
#>  model1       0.0     0.0      NA                    
#>  model2       0.0     0.0      NA                    
#> 
```
