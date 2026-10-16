# Orthodontics ranking-and-covariate excerpt

An anonymised, published excerpt from Tables 3 and 4 in Li, Yi and Liu
(2022): 15 experts rank two non-overlapping groups (A and H) of 12
cases, with 11 PAR-index covariates for every case. The full 108-case
clinical dataset is not provided by the article, so this deliberately
exposes only the reproducible table excerpt.

## Usage

``` r
orthodontics_excerpt_2009()
```

## Value

A list with separate complete within-group ranking-position matrices, a
24-case covariate table, and source metadata. Lower values are better
ranks in each `ranking_positions` matrix.

## References

Li, X., Yi, D. and Liu, J. S. (2022). Bayesian analysis of rank data
with covariates and heterogeneous rankers. *Statistical Science*, 37(1),
1–23. [doi:10.1214/20-STS818](https://doi.org/10.1214/20-STS818)
