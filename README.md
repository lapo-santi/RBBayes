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

```r
# After CRAN release
# install.packages("RBBayes")

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
    latent_strength = latent_strength(shape = 4, rate = exp(digamma(4))),
    item_clustering = gnedin_prior(gnedin_hyperparameter = 0.8)
  ),
  mcmc_control(iter = 500, warmup = 250, seed = 1)
)

pretty_table_K_distribution(fit, p_min = 0)
plot_block_adjacency(fit)
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
    latent_strength = latent_strength(shape = 1, rate = 1),
    item_clustering = gnedin_prior(gnedin_hyperparameter = 0.5)
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
See [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) for the current model
matrix and the remaining PLuce-porting work.

## Documentation

- Package website: https://laposanti.github.io/BTSBM
- Function reference: https://laposanti.github.io/BTSBM/reference/index.html
- Getting started vignette: https://laposanti.github.io/BTSBM/articles/getting-started.html

## coda and bayesplot integration

```r
fit <- fit_model(tennis_tiered_toy(), bt_model(),
                 mcmc_control(iter = 1000, warmup = 500, seed = 1))
chain <- coda::as.mcmc(fit)
coda::effectiveSize(chain)
bayesplot::mcmc_intervals(fit, pars = c("q[1]", "q[2]"))

fit2 <- fit_model(fit$data, fit$model,
                  mcmc_control(iter = 1000, warmup = 500, seed = 2))
chains <- as_mcmc_chains(list(fit, fit2))
coda::gelman.diag(chains, autoburnin = FALSE, multivariate = FALSE)
bayesplot::mcmc_trace(as_draws_array(list(fit, fit2)), pars = "q[1]")
```

By default, `q[i]` is item `i`'s share of total strength within each draw, with
indices following `fit$data$item_labels`. Use `as.matrix(fit, normalise = FALSE)`
for strengths on the stored scale. Occupied-group counts are included when
available. Mixtures and joint latent block models currently export group-count
traces only. Variable-length block strengths and arbitrary allocation labels
are excluded. Arrays retain separate iteration, chain and parameter dimensions.
`coda` and `bayesplot` are optional dependencies.

## Edge-list input and configurable teaching data

```r
edges <- tennis_tiered_toy(
  n_blocks = 3, latent_strength = c(25, 5, 1),
  players_per_block = c(3, 4, 5), format = "edgelist", seed = 101
)
pairwise <- as_bt_data(edges, count = "count")
pairwise$wins[1:4, 1:4]

# For one outcome per row, omit count; each row contributes one win.
# Custom column names and a full, ordered item universe can be supplied:
# as_bt_data(matches, winner = "winner_id", loser = "loser_id",
#            item_labels = all_player_ids)

dirichlet_process_K_var(n = 20, concentration = 1)
```

The fitter takes the validated object returned by `as_bt_data()`. Matrix input
remains supported. For an aggregated edge list, supply the count-column name
explicitly; repeated directed edges are added. Self-comparisons are rejected.
