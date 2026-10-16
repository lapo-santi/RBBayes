# Format a block-count posterior distribution as a pretty- table

Given a common fit object (or lower-level relabelled output), this
function produces a horizontal table with the posterior distribution of
K, the number of occupied item blocks. It formats the result with
[`knitr::kable`](https://rdrr.io/pkg/knitr/man/kable.html) and
[`kableExtra::kable_styling`](https://rdrr.io/pkg/kableExtra/man/kable_styling.html).

## Usage

``` r
pretty_table_K_distribution(
  post,
  format = "html",
  p_min = 0,
  digits = 3,
  latex_options = "hold_position"
)
```

## Arguments

- post:

  A `btsbm_fit` with an item partition, or the output of
  [`relabel_by_lambda()`](https://laposanti.github.io/BTSBM/reference/relabel_by_lambda.md).

- format:

  Character string. The format of the output table. Default is "html".
  Switch to "latex" for a document-ready table.

- p_min:

  Numeric scalar. Probabilities \\\le\\ this threshold are dropped
  before pivoting. Defaults to `0`, so all sampled values are shown.

- digits:

  Integer passed to
  [`knitr::kable`](https://rdrr.io/pkg/knitr/man/kable.html) for
  rounding. Defaults to `3`.

- latex_options:

  Character vector of LaTeX options passed to
  [`kableExtra::kable_styling`](https://rdrr.io/pkg/kableExtra/man/kable_styling.html).
  Defaults to `"hold_position"`; add `"striped"` only when the document
  loads a table-aware colour package.

## Value

A `kableExtra` / `knitr_kable` object (suitable for LaTeX or HTML,
depending on `format`).

## Details

Values whose posterior probability is no larger than `p_min` are
omitted.
