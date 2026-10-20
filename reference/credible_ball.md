# Credible ball for the item partition

The \\(1-\alpha)\\ credible ball (Wade and Ghahramani, 2018) is the
smallest ball, in variation-of-information (VI) distance, around a point
estimate \\\hat z\\ that contains at least `credible_mass` of the
posterior draws. It is summarised by three bounds:

- upper vertical bound:

  the partitions in the ball with the *fewest* blocks that are furthest
  from \\\hat z\\ (coarsest plausible tiering);

- lower vertical bound:

  the partitions in the ball with the *most* blocks that are furthest
  from \\\hat z\\ (finest plausible tiering);

- horizontal bound:

  the partitions furthest from \\\hat z\\.

## Usage

``` r
credible_ball(
  fit,
  z_hat = NULL,
  credible_mass = 0.95,
  method = c("native", "mcclust.ext")
)
```

## Arguments

- fit:

  A block-model `btsbm_fit`.

- z_hat:

  Optional point estimate; defaults to
  [`partition_point_estimate()`](https://laposanti.github.io/BTSBM/reference/partition_point_estimate.md).

- credible_mass:

  Posterior mass of the ball, in (0, 1).

- method:

  `"native"` (default) or `"mcclust.ext"`.

## Value

An object of class `btsbm_credible_ball`: a list with the centre,
radius, the three bounds (each relabelled so block 1 is the strongest),
the number of blocks of each bound and the VI distance of every draw.

## Details

The native implementation needs no extra packages. If the GitHub package
mcclust.ext is installed, `method = "mcclust.ext"` calls
`mcclust.ext::credibleball()` instead, which is useful as a cross-check.

## References

Wade, S. and Ghahramani, Z. (2018). Bayesian cluster analysis: point
estimation and credible balls. *Bayesian Analysis*, 13(2), 559–626.
[doi:10.1214/17-BA1073](https://doi.org/10.1214/17-BA1073)

## See also

[`plot_credible_ball()`](https://laposanti.github.io/BTSBM/reference/plot_credible_ball.md)
