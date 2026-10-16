# Prior expected number of occupied groups

Compute the expected number of occupied groups among `n` items under a
Gnedin, Dirichlet-process, Pitman–Yor or Dirichlet–multinomial prior.
For the Dirichlet–multinomial, the constructor's concentration is per
group; the moment calculation uses total concentration internally.

## Usage

``` r
prior_mean_K(n, prior)
```

## Arguments

- n:

  Positive integer number of items.

- prior:

  A partition prior returned by a clustering-prior constructor.

## Value

A numeric scalar.

## References

Legramanti, S., Rigon, T., Durante, D. and Dunson, D. B. (2022).
Extended stochastic block models with application to criminal networks.
The Annals of Applied Statistics, 16. The DP/PY/DM mean calculation
follows the accompanying ESBM expected_cl_py helper.
<https://github.com/danieledurante/ESBM/blob/master/Source/esbm.R>
