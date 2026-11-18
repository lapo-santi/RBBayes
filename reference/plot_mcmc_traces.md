# Plot saved MCMC traces

Trace plots make it possible to see whether saved MCMC draws move around
a stable region. They are a first diagnostic, not a proof of
convergence.

## Usage

``` r
plot_mcmc_traces(fit, quantities = NULL)
```

## Arguments

- fit:

  A btsbm_fit object.

- quantities:

  Optional character vector of trace names to show.

## Value

A ggplot object.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
plot_mcmc_traces(fit)
```
