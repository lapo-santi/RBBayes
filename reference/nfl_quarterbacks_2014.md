# NFL quarterback rankings with item covariates

A faithful transcription of Tables 1 and 2 in Li, Yi and Liu (2022). It
records the week-12, 2014 rankings of 24 quarterbacks by 13 experts and
the 11 player statistics available before that week. Missing entries in
`ranking_positions` mean that an expert did not include that player in
the expert's top-24 list. Lower values are better ranks.

## Usage

``` r
nfl_quarterbacks_2014()
```

## Value

A list with `ranking_positions` (items by experts), `item_covariates`
(items by covariates), and source metadata. The two tabular components
share row names and can be used as a realistic fixture for future
covariate-assisted ranking models.

## Details

The source websites in the article are dynamic historical sports
websites. Keeping this small, cited transcription makes the published
example reproducible without presenting it as a live data download.

## References

Li, X., Yi, D. and Liu, J. S. (2022). Bayesian analysis of rank data
with covariates and heterogeneous rankers. *Statistical Science*, 37(1),
1–23. [doi:10.1214/20-STS818](https://doi.org/10.1214/20-STS818)
