# Set the reporting scale for Plackett–Luce strengths

A Plackett–Luce likelihood only identifies strength ratios. By default
each saved strength vector is divided by its arithmetic mean (`"mean"`),
so strength is relative to the average item, as for Bradley–Terry
summaries. In an item-block model the mean is over items, weighting
blocks by size. `"sum"` (shares adding to one), `"none"` and
`"logmean0"` (geometric mean one) remain available. Posterior summaries
use arithmetic mean one unless another reporting scale is requested
explicitly.

## Usage

``` r
pl_identifiability(method = c("mean", "sum", "none", "logmean0"))
```

## Arguments

- method:

  One of `"mean"` (default), `"sum"`, `"none"` or `"logmean0"`.

## Value

An object of class `btsbm_pl_identifiability`.

## Examples

``` r
pl_identifiability()
#> $method
#> [1] "mean"
#> 
#> attr(,"class")
#> [1] "btsbm_pl_identifiability"
```
