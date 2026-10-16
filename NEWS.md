# Package rename

* The installable package is now `RBBayes`. Use `library(RBBayes)` after
  installing from `laposanti/BTSBM`; the repository address is unchanged.
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
