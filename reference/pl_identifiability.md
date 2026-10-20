# Set the reporting scale for Plackett–Luce strengths

A Plackett–Luce likelihood only identifies strength ratios. By default
each saved strength vector is divided by its sum (`"sum"`), so reported
strengths are shares that add to one, exactly like the normalised
Bradley–Terry strengths. `"logmean0"` (geometric mean one) is kept for
compatibility.

## Usage

``` r
pl_identifiability(method = c("sum", "none", "logmean0"))
```

## Arguments

- method:

  One of `"sum"` (default), `"none"` or `"logmean0"`.

## Value

An object of class `btsbm_pl_identifiability`.
