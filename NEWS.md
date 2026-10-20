# Tutorial-driven interface revision

* Model constructors take the Gamma prior directly: `bt_model(shape = 2, rate = 1)`,
  `bt_sbm_model(shape, rate, item_clustering)`, and likewise for PL models. The
  strengths are i.i.d. a priori; `latent_strength()` objects are still accepted
  (deprecated). The default BT prior is now Gamma(4, exp(digamma(4))), matching BT--SBM.
* `gnedin_prior(gnedin_hyper = 0.5)`; `gnedin_hyperparameter` is a deprecated alias.
* Notation: `z_i` is the block of item `i`; `lambda_i` (BT) and `lambda_k` (BT--SBM)
  are strengths.
* New names: `posterior_K_table()` (was `pretty_table_K_distribution()`, which
  remains) and `plot_ordered_adjacency()` (wraps `plot_block_adjacency()`).
* MCMC parameters are named after items: `rel_strength[<item>]` (share of total
  strength), `lambda[<item>]`, `n_item_blocks`, `n_ranking_groups`. Old names
  `q[i]`, `theta[i]`, `K_item`, `K_ranking` are still accepted in `pars`.
* `summary()` returns a `summary.btsbm_fit` with descriptive field names and a
  readable print method (data size, priors, MCMC run, posterior K and partition
  for block models, relative strengths otherwise).
* Plackett--Luce strengths are reported as shares summing to one by default
  (`pl_identifiability("sum")`), replacing the geometric-mean scale.
  `strength_summary()` and `plot_strength_summary()` use relative strengths.
* New: `partition_point_estimate()`, `credible_ball()` / `plot_credible_ball()`
  (Wade & Ghahramani credible balls; optional `mcclust.ext` cross-check),
  `block_stability()`, `prob_stronger()` / `plot_prob_stronger()` for
  Pr(lambda_i > lambda_j | y).
* `plot_assignment_probabilities()` uses a diverging colour scale centred at 0.5,
  prints probabilities, and states the conditioning K and number of draws.
* `plot_posterior_similarity()` orders items by the estimated partition and
  outlines its blocks.
* Block colours: colour-blind-safe palette for up to 8 blocks, distinct HCL colours
  beyond; short user palettes are interpolated instead of failing.
* `salso`, `mcclust` and `kableExtra` moved to Suggests; a built-in VI search is
  used when `salso` is absent, so installation is lighter for students.
* `tennis_tiered_toy()` defaults to strengths `c(12, 6, 2, 1)` and the edge list
  carries the true tiers in `attr(, "truth")`.
* A hands-on tutorial is installed at
  `system.file("tutorial", "RBBayes-tutorial.Rmd", package = "RBBayes")`.

# Package rename

* The installable package is now `RBBayes`. Use `library(RBBayes)` after
  installing from `lapo-santi/RBBayes`; the repository address is unchanged.
* Existing function names and fitted-object classes remain compatible.

# Pairwise-data workflow updates

* `as_bt_data()` also accepts directed edge-list data frames, with explicit
  winner, loser and optional count columns. Repeated edges are aggregated.
* `tennis_tiered_toy()` accepts generating block counts, strength vectors,
  player counts and names, and can return an aggregated edge list.
* `dirichlet_process_K_var()` provides a dedicated prior-variance function;
  `prior_variance_K()` delegates to it for Dirichlet-process priors.

# Development interface updates

* Use `fit_model()` as the common BT/PL fitting entry point. Earlier fitter names
  remain available for compatibility.
* Convert fits directly with `as.matrix()`, `as.array()`, `coda::as.mcmc()` and
  `coda::as.mcmc.list()`. Relative item strengths and occupied-group counts
  provide fixed-dimensional draws for coda and bayesplot.
* Combine independent runs using `as_draws_array()` and `as_mcmc_chains()`,
  preserving chain identity and checking compatible data and model definitions.

# BTSBM 0.1.0

## Initial CRAN submission

- Initial release of BTSBM.
- Added Gibbs samplers for Bradley-Terry stochastic block models.
- Added posterior relabelling and partition summaries.
- Added plotting utilities for adjacency, assignment uncertainty, lambda uncertainty, and rank intervals.
- Added ATP demo data and introductory vignettes.
