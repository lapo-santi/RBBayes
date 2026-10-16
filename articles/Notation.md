# Notation and object dimensions for the common BTSBM interface

## Overview

All supported models use the same public workflow:

``` r

data <- as_bt_data(wins) # or as_rankings(rankings)
model <- bt_sbm_model()  # or another BT/PL model constructor
fit <- fit_model(data, model, mcmc_control())
```

The data object validates the observations, the model object states the
likelihood and latent structure, and
[`mcmc_control()`](https://laposanti.github.io/BTSBM/reference/mcmc_control.md)
contains computational settings.
[`fit_model()`](https://laposanti.github.io/BTSBM/reference/fit_model.md)
always returns a `btsbm_fit` object. The lower-level `gibbs_bt_*()`
functions remain available for compatibility, but new analyses should
use this common architecture.

## Data notation

### Pairwise outcomes

For \\n\\ items, let \\w\_{ij}\\ be the number of times item \\i\\
defeats item \\j\\. The directed win matrix is

\\ \mathbf W=(w\_{ij})\in\mathbb N^{n\times n}, \qquad w\_{ii}=0, \\

and the number of comparisons for an unordered pair is

\\ n\_{ij}=w\_{ij}+w\_{ji}. \\

[`as_bt_data()`](https://laposanti.github.io/BTSBM/reference/as_bt_data.md)
stores these quantities as `data$wins`, `data$n_items`, and
`data$item_labels`. Users do not supply \\\mathbf N\\; it is computed
when needed.

### Ranking outcomes

For \\L\\ observed rankings of length \\m\\, row \\\ell\\ of the integer
matrix \\\boldsymbol\rho\\ lists item identifiers from most to least
preferred. A row may be a complete ranking or a top-\\m\\ prefix from
one common universe of \\n\\ available items.

[`as_rankings()`](https://laposanti.github.io/BTSBM/reference/as_rankings.md)
stores `data$rankings` with dimension `L x m`, together with
`data$n_rankings`, `data$rank_length`, `data$n_items`, and stable item
and ranking labels.

## Model notation

The package separates the observation likelihood from the latent
structure.

| Constructor | Likelihood | Sampled partition | Strength used by an observation |
|----|----|----|----|
| [`bt_model()`](https://laposanti.github.io/BTSBM/reference/bt_model.md) | Bradley–Terry | none | item strength \\\lambda_i\\ |
| [`bt_sbm_model()`](https://laposanti.github.io/BTSBM/reference/bt_sbm_model.md) | Bradley–Terry | item labels \\x_i\\ | block strength \\\lambda\_{x_i}\\ |
| [`pl_model()`](https://laposanti.github.io/BTSBM/reference/pl_model.md) | Plackett–Luce | none | item strength \\\lambda_i\\ |
| [`pl_sbm_model()`](https://laposanti.github.io/BTSBM/reference/pl_sbm_model.md) | Plackett–Luce | item labels \\x_i\\ | block strength \\\lambda\_{x_i}\\ |
| [`pl_mixture_model()`](https://laposanti.github.io/BTSBM/reference/pl_mixture_model.md) | Plackett–Luce | ranking labels \\z\_\ell\\ | profile-specific strength \\\lambda\_{z\_\ell i}\\ |
| [`pl_lbm_model()`](https://laposanti.github.io/BTSBM/reference/pl_lbm_model.md) | Plackett–Luce | \\x_i\\ and \\z\_\ell\\ | profile-by-item-block strength \\\lambda\_{z\_\ell x_i}\\ |

For Bradley–Terry models,

\\ \Pr(i\text{ defeats }j)=\frac{\lambda_i}{\lambda_i+\lambda_j}, \\

with \\\lambda_i\\ replaced by \\\lambda\_{x_i}\\ in a BT–SBM. For a
Plackett–Luce ranking, the probability of the item selected at each
position is its positive strength divided by the total strength of the
remaining risk set.

## Prior and control objects

Positive strengths use `latent_strength(shape, rate)`. Latent partitions
use one of the following common constructors:

``` r

gnedin_prior(gnedin_hyperparameter = 0.5)
dirichlet_process_prior(concentration = 1)
pitman_yor_prior(concentration = 1, discount = 0.2)
finite_partition(max_clusters = 4, concentration = 1)
```

If `iter` is the total number of iterations and `warmup` is the
discarded prefix, the number of saved draws is

\\ S=\texttt{iter}-\texttt{warmup}. \\

These names are shared by BT and PL models through
`mcmc_control(iter, warmup, seed, ...)`.

## The `btsbm_fit` object

Every fit has the same top-level components:

``` r

fit$data
fit$model
fit$control
fit$draws
fit$diagnostics
fit$elapsed
```

The contents of `fit$draws` depend on the selected structure.

| Draw component | Meaning | Dimension or form |
|----|----|----|
| `item_cluster` | sampled \\x_i\\ | `S x n` integer matrix |
| `ranking_cluster` | sampled \\z\_\ell\\ | `S x L` integer matrix |
| `n_item_clusters` | occupied item blocks | length `S` |
| `n_ranking_clusters` | occupied ranking profiles | length `S` |
| `latent_strength` | sampler-scale strengths | matrix for simple models; list of length `S` for variable-dimensional models |
| `item_strength` | item-level reported strengths | `S x n` when defined |
| `component_strength` | PL-mixture profile strengths | list of length `S` |
| `cell_strength` | PL–LBM profile-by-block strengths | list of length `S` |

Raw cluster numbers have no meaning across MCMC draws. Paper-style
BT–SBM summaries relabel each draw by decreasing block strength, so
cluster 1 is the strongest occupied block. Pairwise co-clustering
summaries, such as
[`posterior_similarity()`](https://laposanti.github.io/BTSBM/reference/posterior_similarity.md),
are label-invariant and do not require this step.

## Posterior summaries and plots

The public summaries consume the `btsbm_fit` object directly:

``` r

posterior_strength(fit)
strength_summary(fit)
posterior_similarity(fit, target = "item")
log_lik(fit)
mcmc_diagnostics(fit)
```

For a BT–SBM, the paper-oriented outputs use the same fit object:

``` r

pretty_table_K_distribution(fit)
plot_block_adjacency(fit)
plot_assignment_probabilities(fit)
plot_rank_intervals(fit)
```

[`plot_assignment_probabilities()`](https://laposanti.github.io/BTSBM/reference/plot_assignment_probabilities.md)
conditions on the posterior modal number of item blocks by default.
Supply `max_n_clust = K` to condition on another sampled value. This
separates uncertainty in item membership from uncertainty in the number
of blocks.

## Log-likelihood dimensions

`log_lik(fit)` returns one contribution per observational unit:

- for BT models, an `S x D` matrix, where \\D\\ is the number of
  observed unordered pairs \\(i,j)\\ with \\i\<j\\ and \\n\_{ij}\>0\\;
- for PL models, an `S x L` matrix, with one contribution per complete
  ranking row.

If `loo` is installed, `loo_btsbm(fit)` uses this same observation-level
definition.

## Minimal end-to-end example

``` r

library(RBBayes)

pairwise <- tennis_toy(matches_per_pair = 8, seed = 1)
model <- bt_sbm_model(
  latent_strength = latent_strength(shape = 4, rate = exp(digamma(4))),
  item_clustering = gnedin_prior(gnedin_hyperparameter = 0.5)
)
fit <- fit_model(
  pairwise,
  model,
  mcmc_control(iter = 400, warmup = 200, seed = 2)
)

dim(fit$draws$item_cluster)       # S x n
length(fit$draws$n_item_clusters) # S
dim(log_lik(fit))                 # S x D

pretty_table_K_distribution(fit, p_min = 0)
plot_block_adjacency(fit)
plot_assignment_probabilities(fit)
```

## Validation rules

- Pairwise wins must form a square, finite, non-negative matrix with
  zero diagonal and unique item labels.
- Ranking rows must contain distinct integer item identifiers in
  `1:item_count`.
- BT models require data from
  [`as_bt_data()`](https://laposanti.github.io/BTSBM/reference/as_bt_data.md);
  PL models require data from
  [`as_rankings()`](https://laposanti.github.io/BTSBM/reference/as_rankings.md).
- `warmup` must be smaller than `iter`, and partition priors must
  satisfy their documented parameter constraints.

This interface keeps data preparation, model specification, computation,
and posterior interpretation separate while using the same function
architecture throughout the package.
