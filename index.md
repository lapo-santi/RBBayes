---
title: "RBBayes: Bayesian Bradley–Terry and Plackett–Luce Models"
output:
  rmarkdown::html_document:
    toc: true
    toc_depth: 3
    toc_float: true 
vignette: >
  %\VignetteIndexEntry{RBBayes: Bayesian Inference for the Bradley–Terry Stochastic Block Model}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---


## Overview

**RBBayes** provides one public architecture for Bayesian Bradley–Terry (BT)
models for paired comparisons and Plackett–Luce (PL) models for rankings.
Both likelihoods can be combined with latent block structures.

The package provides:

1. Validated pairwise and ranking data objects

2. Explicit BT, PL, prior, and MCMC-control constructors

3. A common `fit_model()` entry point and `btsbm_fit` result

4. Fit-level uncertainty summaries, diagnostics, and visualizations

Applications include, among the others, **sports analytics**, **psychometrics**, and **ranking problems** with hidden group structure.

---

### Quick Links

For a complete overview of all functions, see the 👉 [Function Reference](https://laposanti.github.io/BTSBM/reference/index.html)  
For a step-by-step example using tennis data, visit the 👉 [Getting Started Vignette](https://laposanti.github.io/BTSBM/articles/getting-started.html)

---

## When to Use RBBayes

Use the BT models when outcomes can be summarized as pairwise preferences
(`i` beats `j`). Below are a few illustrative examples:

| Domain | Example |
|:--|:--|
| ⚽ Sports & games | Player `i` beats player `j` |
| 🔍 Information retrieval | Document `i` preferred to `j` |
| 🧠 Psychometrics | Stimulus `i` chosen over `j` |
| 🧪 A/B testing | Variant `i` performs better than `j` |

The data can contain one binary result per comparison or aggregated non-negative
win counts. This page uses sports terminology for the pairwise workflow; the
ranking vignette presents the corresponding PL workflow using the same
data--model--fit architecture.


## Required Inputs

To fit the model, first create one validated pairwise-data object:

### `wins`: pairwise interaction matrix

*It is as a directed weighted/binary adjacency matrix.*

- Square matrix (`n × n`), where `wins[i, j]` = number of times player *i* beats *j*
- Diagonal must be 0 (`wins[i, i] = 0`)
- For each unordered pair `{i,j}`:  
\( n_{ij} = w_{ij} + w_{ji} \)


---


### Examples

<div style="display: flex; gap: 1.5em;">

<div style="flex: 1;">

**(A) Aggregated counts**

```r
# items: A, B, C, D
# w[i, j] = number of times i beat j
wins <- matrix(
c( 0, 3, 0, 2,
1, 0, 4, 0,
2, 0, 0, 1,
0, 1, 3, 0 ),
nrow = 4, byrow = TRUE,
dimnames = list(c("A","B","C","D"), c("A","B","C","D"))
)
````

</div>

<div style="flex: 1;">

**(B) Binary outcomes**

```r
# one comparison per pair observed (0/1 wins)
# w[i, j] is binary
binary_wins <- matrix(
c( 0, 1, 0, 1,
0, 0, 1, 0,
1, 0, 0, 0,
0, 1, 1, 0 ),
nrow = 4, byrow = TRUE,
dimnames = list(c("A","B","C","D"), c("A","B","C","D"))
)
```

</div>
</div>

⚠️ The matrix must **not** be symmetric!

---

## Installation

Install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("lapo-santi/BTSBM-0b39af08")
library(RBBayes)
```

---

## Minimal Example

Let’s fit the BT–SBM with a Gnedin prior on 2017 ATP season data:

```r
# prepare the 2017 season
wins <- ATP_2000_2025$`2017`$Y_ij
pairwise <- as_bt_data(wins)

# specify and fit the model
fit <- fit_model(
  pairwise,
  bt_sbm_model(
    latent_strength = latent_strength(shape = 4, rate = exp(digamma(4))),
    item_clustering = gnedin_prior(gnedin_hyperparameter = 0.8)
  ),
  mcmc_control(iter = 500, warmup = 250, seed = 1)
)

# keep uncertainty in K and block membership visible
pretty_table_K_distribution(fit, p_min = 0)
plot_block_adjacency(fit)
plot_assignment_probabilities(fit)
```

Together, these outputs show posterior uncertainty in the number of blocks,
the observed win-rate matrix reordered by a representative block partition,
and assignment uncertainty conditional on a chosen number of blocks.


---

## Workflow at a Glance

1. **Prepare data** with `as_bt_data(wins)`

2. **Inspect prior** using [`gnedin_K_mean()`](https://laposanti.github.io/BTSBM/reference/gnedin_K_mean.html) and [`gnedin_K_var()`](https://laposanti.github.io/BTSBM/reference/gnedin_K_var.html)

3. **Specify a model** with `bt_model()` or `bt_sbm_model()`

4. **Fit the model** with [`fit_model()`](https://laposanti.github.io/BTSBM/reference/fit_btsbm.html)

5. **Report block uncertainty** with `pretty_table_K_distribution()`,
   `plot_block_adjacency()`, and `plot_assignment_probabilities()`

---

## Learn More

👉 [Function Reference](https://laposanti.github.io/BTSBM/reference/index.html)

👉 [Getting Started Vignette](https://laposanti.github.io/BTSBM/articles/getting-started.html)

---

## Citation

Santi, L., & Friel, N. (2026). *The Bradley–Terry stochastic block model.*
*The Annals of Applied Statistics*, 20(2), 1766--1787.

---
