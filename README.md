# RBBayes

[![R-CMD-check](https://github.com/lapo-santi/RBBayes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/lapo-santi/RBBayes/actions/workflows/R-CMD-check.yaml)

Bayesian Bradley--Terry and Plackett--Luce models for paired comparisons and
rankings, including latent item blocks and respondent-profile mixtures.

The development version also includes an initial Plackett--Luce interface for
strict complete and top-`m` rankings: validated ranking data, simple PL, and
item-block PL--SBM fitting, ranking mixtures, and joint ranking/item latent
block models. The mixture and LBM currently use clear R reference kernels;
the PLuce C++ kernels remain a planned performance upgrade.

## Installation

RBBayes is being prepared for its first CRAN release. Install the development
version from GitHub using the `remotes` package:

```r
# Development version
remotes::install_github("lapo-santi/RBBayes")
```

## Minimal example

```r
library(RBBayes)

wins <- ATP_2000_2025$`2017`$Y_ij
pairwise <- as_bt_data(wins)

fit <- fit_model(
  pairwise,
  bt_sbm_model(
    shape_lambda = 4, rate_lambda = exp(digamma(4)),
    item_clustering = gnedin_prior(gnedin_hyper = 0.8)
  ),
  mcmc_control(iter = 500, warmup = 250, seed = 1)
)

posterior_K_table(fit)
plot_ordered_adjacency(fit)
plot_assignment_probabilities(fit)
```

## Plackett--Luce ranking example

```r
library(RBBayes)

# Synthetic teaching data with Sushi Preference Dataset-style item labels.
# It contains no rows from the original, non-redistributable benchmark.
rankings <- sushi_toy(n_rankings = 40, rank_length = 5)

fit_pl <- fit_model(
  rankings,
  pl_sbm_model(
    shape_lambda = 1, rate_lambda = 1,
    item_clustering = gnedin_prior(gnedin_hyper = 0.5)
  ),
  mcmc_control(iter = 600, warmup = 300, seed = 1)
)

posterior_strength(fit_pl, summary = "mean")
posterior_similarity(fit_pl, target = "item")
```

## Read a fitted model with plots

The same plotting vocabulary works across the modern BT and PL interfaces.
It separates three practical questions: which items are strong, which items
behave alike, and whether the sampler has settled down.

```r
# For ranking data, first inspect which items tend to occur near the top.
plot_ranking_positions(rankings)

# Summarise item strength with an uncertainty interval.
plot_strength_summary(fit_pl)

# Reveal item groups suggested by the posterior (PL--SBM and BT--SBM).
plot_posterior_similarity(fit_pl, target = "item")

# Inspect saved Markov-chain quantities before drawing conclusions.
plot_mcmc_traces(fit_pl)
```

For an introduction that explains each picture in context, start with
`vignette("getting-started", package = "RBBayes")` for paired comparisons or
`vignette("pl-ranking-models", package = "RBBayes")` for rankings.

`item_clustering` can also use `dirichlet_process_prior()`,
`pitman_yor_prior()`, or `finite_partition(max_clusters = ...)`. See
`?clustering_prior` for the common parameterisation.

See `vignette("pl-ranking-models", package = "RBBayes")` for the ranking-data
format, model scope, references, and the original Sushi benchmark's licence.
See `vignette("toy-data-gallery", package = "RBBayes")` for reproducible tennis,
Eurovision-inspired, Sushi-inspired, and joint-clustering examples.
See [IMPLEMENTATION_STATUS.md](https://github.com/lapo-santi/RBBayes/blob/main/IMPLEMENTATION_STATUS.md) for the current model
matrix and the remaining PLuce-porting work.

## Documentation

- Hands-on tutorial (R Markdown, knit it locally):
  `file.copy(system.file("tutorial", "RBBayes-tutorial.Rmd", package = "RBBayes"), ".")`

- Package website: https://lapo-santi.github.io/RBBayes
- Function reference: https://lapo-santi.github.io/RBBayes/reference/index.html
- Getting started vignette: https://lapo-santi.github.io/RBBayes/articles/getting-started.html

## coda and bayesplot integration

```r
fit <- fit_model(tennis_tiered_toy(), bt_model(),
                 mcmc_control(iter = 1000, warmup = 500, seed = 1))
chain <- coda::as.mcmc(fit)
coda::effectiveSize(chain)
bayesplot::mcmc_intervals(fit, regex_pars = "rel_strength")

fit2 <- fit_model(fit$data, fit$model,
                  mcmc_control(iter = 1000, warmup = 500, seed = 2))
chains <- as_mcmc_chains(list(fit, fit2))
coda::gelman.diag(chains, autoburnin = FALSE, multivariate = FALSE)
bayesplot::mcmc_trace(as_draws_array(list(fit, fit2)),
                     pars = colnames(as.matrix(fit))[1:2])
```

By default, `rel_strength[<item>]` is that item's share of total strength
within each draw, named after the item. Use `as.matrix(fit, normalise = FALSE)`
for strengths on the stored scale (`lambda[<item>]`). Occupied-group counts are included when
available. Mixtures and joint latent block models currently export group-count
traces only. Variable-length block strengths and arbitrary allocation labels
are excluded. Arrays retain separate iteration, chain and parameter dimensions.
`coda` and `bayesplot` are optional dependencies.

## Edge-list input and configurable teaching data

```r
edges <- simulate_data(
  model = "bt-sbm",
  n_blocks = 3, latent_strength = c(25, 5, 1),
  players_per_block = c(3, 4, 5), format = "edgelist", seed = 101
)
pairwise <- as_bt_data(edges, format = "edgelist")
pairwise$wins[1:4, 1:4]

# Standard BT: supply one strength per item, without defining blocks.
individual <- simulate_data("bt", latent_strength = c(A = 8, B = 3, C = 1), seed = 1)
plot_pairwise_outcomes(individual, reorder = TRUE)

# For one outcome per row, use format = "matches".
# Custom column names and a full, ordered item universe can be supplied:
# as_bt_data(matches, format = "matches", winner = "winner_id", loser = "loser_id",
#            item_labels = all_player_ids)

dirichlet_process_K_var(n = 20, concentration = 1)
```

The fitter takes the validated object returned by `as_bt_data()`. Matrix input
remains supported. `format = "edgelist"` reads the standard `count` column;
use `count` only to select a different column name. Repeated directed edges
are added, and self-comparisons are rejected. `format = "matches"` records one
win per row. Existing calls using `count = "count"` remain valid.

## Acknowledgements

We acknowledge the `speedyBBT` package by Rowland Seymour, Christine Stawitz
and Heather Turner as an inspiration for RBBayes. This acknowledgement concerns
inspiration rather than code adapted from `speedyBBT`.
See [speedyBBT](https://github.com/rowlandseymour/speedyBBT).
