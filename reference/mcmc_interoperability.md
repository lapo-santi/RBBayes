# Convert preference-model fits for coda and bayesplot

Interoperability with standard posterior diagnostics and plots without
merging independent chains or including warm-up.

## Usage

``` r
# S3 method for class 'btsbm_fit'
as.matrix(x, ..., normalise = TRUE, pars = NULL)
# S3 method for class 'btsbm_fit'
as.array(x, ..., normalise = TRUE, pars = NULL)
# S3 method for class 'btsbm_fit'
as.mcmc(x, ..., normalise = TRUE, pars = NULL)
# S3 method for class 'btsbm_fit'
as.mcmc.list(x, ..., normalise = TRUE, pars = NULL)
as_draws_array(x, normalise = TRUE, pars = NULL)
as_mcmc_chains(x, normalise = TRUE, pars = NULL)
```

## Arguments

- x:

  A btsbm_fit object. For as_draws_array and as_mcmc_chains, a non-empty
  list of independent fits is also accepted.

- ...:

  Reserved for generic compatibility.

- normalise:

  Logical. Divide each item's strength by total strength within each
  draw (default TRUE). FALSE reports strengths on their stored scale.

- pars:

  Optional character vector selecting and ordering parameter columns.

## Value

A saved-draw matrix; an iteration by chain by parameter array; a coda
mcmc object; or a coda mcmc.list, depending on the function.

## Details

Columns q\[i\] are sum-to-one relative item strengths; theta\[i\] are
strengths on the stored scale when normalise is FALSE. Indices follow
x\$data\$item_labels. K_item and K_ranking are occupied-group counts,
when available. Mixture and LBM fits currently expose only these counts:
their varying-dimensional profile strengths and arbitrary allocation
labels are not presented as fixed parameters.

Multiple fits must have identical data, item ordering and model
specifications, and equal retained lengths. coda lists also require
equal warm-up lengths. The caller must provide independently run chains:
combining repeated copies of one fit does not establish independent
replication. A single fit produces one chain.

Because relative strengths sum to one, their joint covariance is
singular; use `multivariate = FALSE` in
[`coda::gelman.diag()`](https://rdrr.io/pkg/coda/man/gelman.diag.html).
Diagnostics for a group-count trace that is constant throughout a run
can be undefined.

coda iterations start at warmup + 1 with thinning interval one. Both
coda and bayesplot are optional packages. Arrays do not require either
package; bayesplot accepts a fit directly through its as.array method.

## Examples

``` r
if (FALSE) { # \dontrun{
fit <- fit_model(tennis_tiered_toy(), bt_model(),
                 mcmc_control(iter = 1000, warmup = 500, seed = 1))
chain <- coda::as.mcmc(fit)
coda::effectiveSize(chain)
bayesplot::mcmc_trace(fit, pars = c("q[1]", "q[2]"))
fit2 <- fit_model(fit$data, fit$model,
                  mcmc_control(iter = 1000, warmup = 500, seed = 2))
coda::gelman.diag(as_mcmc_chains(list(fit, fit2)),
                   autoburnin = FALSE, multivariate = FALSE)
bayesplot::mcmc_trace(as_draws_array(list(fit, fit2)), pars = "q[1]")
} # }
```
