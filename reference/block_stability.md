# How stable is each estimated block?

Co-clustering probabilities below one inside an estimated block can look
puzzling in
[`plot_posterior_similarity()`](https://lapo-santi.github.io/RBBayes/reference/plot_posterior_similarity.md):
if two players are not always together, where does the rest of the
probability go? This function answers that question. For every block of
the point estimate \\\hat z\\ it reports the posterior probability that,
in a draw,

- `together`:

  all its items share one block and no outside item joins them (the
  block is reproduced exactly);

- `split`:

  its items are spread over two or more blocks;

- `merged`:

  at least one of its items shares a block with an item from a different
  estimated block.

`split` and `merged` can both happen in the same draw, so the three
columns need not add to one. A pairwise co-clustering below one with a
`merged` probability near zero means the missing mass goes to splitting
the block into finer sub-blocks, not to other blocks.

## Usage

``` r
block_stability(fit, z_hat = NULL)
```

## Arguments

- fit:

  A block-model `btsbm_fit`.

- z_hat:

  Optional point estimate; defaults to
  [`partition_point_estimate()`](https://lapo-santi.github.io/RBBayes/reference/partition_point_estimate.md).

## Value

A data frame with one row per estimated block.

## Examples

``` r
data <- as_bt_data(matrix(c(0, 3, 2, 0), 2, 2))
# A short run illustrates the interface; use longer runs for inference.
fit <- fit_model(data, bt_sbm_model(),
                 mcmc_control(iter = 60, warmup = 30, seed = 1))
block_stability(fit)
#> Warning: The number of clusters equals the default maximum possible number of clusters.
#>   block size together split merged        members
#> 1     1    2        1     0      0 Item_1, Item_2
```
