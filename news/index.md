# Changelog

## RBBayes 1.0.0

### Release preparation

- Added `simulate_data(model = "bt")` and
  `simulate_data(model = "bt-sbm")` for paired comparisons with
  individual or shared block strengths. The older teaching-data
  generators remain available.

- [`as_bt_data()`](https://lapo-santi.github.io/RBBayes/reference/as_bt_data.md)
  accepts explicit `format = "matrix"`, `"edgelist"` and `"matches"`
  inputs. Aggregated edge lists use the standard `count` column without
  requiring `count = "count"`; the default preserves the earlier API.

- [`plot_pairwise_outcomes()`](https://lapo-santi.github.io/RBBayes/reference/plot_pairwise_outcomes.md)
  now dispatches on pairwise-data and BT-fit classes. `reorder = TRUE`
  sorts both axes by observed win rate; `FALSE` retains input order. The
  heatmap always shows observed counts.

- Declared optional plotting and vignette prerequisites for no-Suggests
  checks.

- Removed a deprecated matrix-attribute assignment from the Gibbs
  sampler.

- Corrected package website links and made previously disabled examples
  runnable.

- Expanded the package description and identified the copyright holder.

### Tutorial-driven interface revision

- Model constructors take the Gamma prior directly:
  `bt_model(shape_lambda = 2, rate_lambda = 1)`,
  `bt_sbm_model(shape_lambda, rate_lambda, item_clustering)`, and
  likewise for PL models. The strengths are i.i.d. a priori;
  [`latent_strength()`](https://lapo-santi.github.io/RBBayes/reference/latent_strength.md)
  objects are still accepted (deprecated). The default BT prior is now
  Gamma(4, exp(digamma(4))), matching BT–SBM.
- `gnedin_prior(gnedin_hyper = 0.5)`; `gnedin_hyperparameter` is a
  deprecated alias.
- Notation: `z_i` is the block of item `i`; `lambda_i` (BT) and
  `lambda_k` (BT–SBM) are strengths.
- New names:
  [`posterior_K_table()`](https://lapo-santi.github.io/RBBayes/reference/posterior_K_table.md)
  (was
  [`pretty_table_K_distribution()`](https://lapo-santi.github.io/RBBayes/reference/pretty_table_K_distribution.md),
  which remains) and
  [`plot_ordered_adjacency()`](https://lapo-santi.github.io/RBBayes/reference/plot_ordered_adjacency.md)
  (wraps
  [`plot_block_adjacency()`](https://lapo-santi.github.io/RBBayes/reference/plot_block_adjacency.md)).
- MCMC parameters are named after items: `rel_strength[<item>]` (share
  of total strength), `lambda[<item>]`, `n_item_blocks`,
  `n_ranking_groups`. Old names `q[i]`, `theta[i]`, `K_item`,
  `K_ranking` are still accepted in `pars`.
- [`summary()`](https://rdrr.io/r/base/summary.html) returns a
  `summary.btsbm_fit` with descriptive field names and a readable print
  method (data size, priors, MCMC run, posterior K and partition for
  block models, relative strengths otherwise).
- Plackett–Luce strengths are reported as shares summing to one by
  default (`pl_identifiability("sum")`), replacing the geometric-mean
  scale.
  [`strength_summary()`](https://lapo-santi.github.io/RBBayes/reference/strength_summary.md)
  and
  [`plot_strength_summary()`](https://lapo-santi.github.io/RBBayes/reference/plot_strength_summary.md)
  use relative strengths.
- New:
  [`partition_point_estimate()`](https://lapo-santi.github.io/RBBayes/reference/partition_point_estimate.md),
  [`credible_ball()`](https://lapo-santi.github.io/RBBayes/reference/credible_ball.md)
  /
  [`plot_credible_ball()`](https://lapo-santi.github.io/RBBayes/reference/plot_credible_ball.md)
  (Wade & Ghahramani credible balls; optional `mcclust.ext`
  cross-check),
  [`block_stability()`](https://lapo-santi.github.io/RBBayes/reference/block_stability.md),
  [`prob_stronger()`](https://lapo-santi.github.io/RBBayes/reference/prob_stronger.md)
  /
  [`plot_prob_stronger()`](https://lapo-santi.github.io/RBBayes/reference/plot_prob_stronger.md)
  for Pr(lambda_i \> lambda_j \| y).
- [`plot_assignment_probabilities()`](https://lapo-santi.github.io/RBBayes/reference/plot_assignment_probabilities.md)
  uses a diverging colour scale centred at 0.5, prints probabilities,
  and states the conditioning K and number of draws.
- [`plot_posterior_similarity()`](https://lapo-santi.github.io/RBBayes/reference/plot_posterior_similarity.md)
  orders items by the estimated partition and outlines its blocks.
- Block colours: colour-blind-safe palette for up to 8 blocks, distinct
  HCL colours beyond; short user palettes are interpolated instead of
  failing.
- `salso`, `mcclust` and `kableExtra` moved to Suggests; a built-in VI
  search is used when `salso` is absent, so installation is lighter for
  students.
- [`tennis_tiered_toy()`](https://lapo-santi.github.io/RBBayes/reference/tennis_tiered_toy.md)
  defaults to strengths `c(12, 6, 2, 1)` and the edge list carries the
  true tiers in `attr(, "truth")`.
- A hands-on tutorial is installed at
  `system.file("tutorial", "RBBayes-tutorial.Rmd", package = "RBBayes")`.

### Package rename

- The installable package is now `RBBayes`. Use
  [`library(RBBayes)`](https://github.com/lapo-santi/RBBayes) after
  installing from `lapo-santi/RBBayes`; the repository address is
  unchanged.
- Existing function names and fitted-object classes remain compatible.

### Pairwise-data workflow updates

- [`as_bt_data()`](https://lapo-santi.github.io/RBBayes/reference/as_bt_data.md)
  also accepts directed edge-list data frames, with explicit winner,
  loser and optional count columns. Repeated edges are aggregated.
- [`tennis_tiered_toy()`](https://lapo-santi.github.io/RBBayes/reference/tennis_tiered_toy.md)
  accepts generating block counts, strength vectors, player counts and
  names, and can return an aggregated edge list.
- [`dirichlet_process_K_var()`](https://lapo-santi.github.io/RBBayes/reference/dirichlet_process_K_var.md)
  provides a dedicated prior-variance function;
  [`prior_variance_K()`](https://lapo-santi.github.io/RBBayes/reference/prior_variance_K.md)
  delegates to it for Dirichlet-process priors.

### Development interface updates

- Use
  [`fit_model()`](https://lapo-santi.github.io/RBBayes/reference/fit_model.md)
  as the common BT/PL fitting entry point. Earlier fitter names remain
  available for compatibility.
- Convert fits directly with
  [`as.matrix()`](https://rdrr.io/r/base/matrix.html),
  [`as.array()`](https://rdrr.io/r/base/array.html),
  [`coda::as.mcmc()`](https://rdrr.io/pkg/coda/man/mcmc.html) and
  [`coda::as.mcmc.list()`](https://rdrr.io/pkg/coda/man/mcmc.list.html).
  Relative item strengths and occupied-group counts provide
  fixed-dimensional draws for coda and bayesplot.
- Combine independent runs using
  [`as_draws_array()`](https://lapo-santi.github.io/RBBayes/reference/mcmc_interoperability.md)
  and
  [`as_mcmc_chains()`](https://lapo-santi.github.io/RBBayes/reference/mcmc_interoperability.md),
  preserving chain identity and checking compatible data and model
  definitions.

### BTSBM 0.1.0

### Initial CRAN submission

- Initial release of BTSBM.
- Added Gibbs samplers for Bradley-Terry stochastic block models.
- Added posterior relabelling and partition summaries.
- Added plotting utilities for adjacency, assignment uncertainty, lambda
  uncertainty, and rank intervals.
- Added ATP demo data and introductory vignettes.
