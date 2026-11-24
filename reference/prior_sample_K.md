# Simulate the prior number of occupied groups

Generate independent draws of `K_n` before observing outcomes. Starting
with one occupied group, each further item either joins an existing
group or creates a new one, using the specified partition prior's
predictive probability. Only the count is simulated, not the complete
partition. Every draw lies between 1 and `n`; a Dirichlet–multinomial
prior also respects its maximum number of groups.

## Usage

``` r
prior_sample_K(n, prior, draws = 10000L, seed = NULL)
```

## Arguments

- n:

  Positive integer number of items.

- prior:

  A partition prior returned by a clustering-prior constructor.

- draws:

  Positive integer number of independent simulations.

- seed:

  Optional integer seed. If supplied, calls
  [`set.seed()`](https://rdrr.io/r/base/Random.html).

## Value

An integer vector of length `draws`.

## References

Gnedin, A. (2010). A species sampling model with finitely many types.
Electronic Communications in Probability, 15, 79–88.
[doi:10.1214/ECP.v15-1532](https://doi.org/10.1214/ECP.v15-1532)

## Examples

``` r
K <- prior_sample_K(20, gnedin_prior(0.5), draws = 1000, seed = 31)
c(simulated = mean(K), exact = prior_mean_K(20, gnedin_prior(0.5)))
#> simulated     exact 
#>  3.961000  3.988173 
```
