# Fit a Bayesian Bradley–Terry or Plackett–Luce model

`fit_model()` is the common fitting entry point. This first
implementation supports simple BT, BT–SBM, simple PL, PL–SBM, PL ranking
mixtures, and PL–LBM. The latter two start with readable R Gibbs kernels
derived from the PLuce exponential-race architecture; their
high-performance C++ kernels are a later parity-tested optimisation.

## Usage

``` r
fit_model(data, model, control = mcmc_control())
```

## Arguments

- data:

  A `btsbm_pairwise_data` or `btsbm_ranking_data` object created by
  [`as_bt_data()`](https://lapo-santi.github.io/RBBayes/reference/as_bt_data.md)
  or
  [`as_rankings()`](https://lapo-santi.github.io/RBBayes/reference/as_rankings.md).

- model:

  A `btsbm_model` object.

- control:

  A `btsbm_mcmc_control` object.

## Value

An object of class `btsbm_fit`.

## Details

BT–SBM reporting normalises the occupied block strengths to arithmetic
mean one in each retained draw, then maps these strengths to players.
Each occupied block contributes once, irrespective of its size. The fit
stores these vectors in `draws$block_strength`; `draws$latent_strength`
retains the raw Gamma-scale draws used by the sampler. Unused label
slots are `NA` in `draws$block_strength` and excluded from its
arithmetic mean.

## References

Caron, F. and Doucet, A. (2012). Efficient Bayesian inference for
generalized Bradley–Terry models. *Journal of Computational and
Graphical Statistics*, 21(1), 174–196.
[doi:10.1080/10618600.2012.638220](https://doi.org/10.1080/10618600.2012.638220)

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
fit
#> <btsbm_fit> Bradley-Terry stochastic block model (BT-SBM), items share block strengths 
#>   2 items; 30 retained posterior draws. Use summary() for results.
```
