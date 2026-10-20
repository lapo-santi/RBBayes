# Getting started: from results to a Bradley--Terry analysis

## What this package does

BTSBM analyses two kinds of preference data:

1.  Pairwise results: one item wins or loses against another, such as a
    match in a league.
2.  Rankings: a person places several items from most to least
    preferred.

This first tutorial uses pairwise results. The ranking tutorial is
vignette(“pl-ranking-models”).

A Bradley–Terry (BT) model assigns every player a positive strength. A
larger strength means a greater probability of winning against a player
with a smaller strength. A BT–SBM additionally lets the data group
players with similar strengths into latent tiers.

``` r

library(RBBayes)
```

## 1. Start with data you can inspect

The toy tennis league is synthetic and intentionally small. wins\[i, j\]
means the number of times player i beat player j. The diagonal is zero
because a player does not play themself.

``` r

tennis <- tennis_toy(matches_per_pair = 8, seed = 1)
tennis$wins
#>            Ace Baseline Crosscourt Dropshot Elite Forehand
#> Ace          0        5          6        6     5        8
#> Baseline     3        0          3        3     6        6
#> Crosscourt   2        5          0        6     7        7
#> Dropshot     2        5          2        0     4        6
#> Elite        3        2          1        4     0        4
#> Forehand     0        2          1        2     4        0
```

Before fitting a model, inspect the observed outcomes. Darker cells
identify frequent wins by the row player over the column player.

``` r

plot_pairwise_outcomes(tennis)
```

![](getting-started_files/figure-html/observed-outcomes-1.png)

This plot is descriptive: it does not yet account for uncertainty or
combine all opponents into one estimate of player strength.

## 2. Choose a model

Start with a BT–SBM when you think players may form broad tiers rather
than a completely reliable order from first to last. Here, the Gnedin
prior lets the number of tiers be learned from the data.

``` r

model <- bt_sbm_model(
  shape = 4, rate = exp(digamma(4)),
  item_clustering = gnedin_prior(gnedin_hyper = 0.5)
)
model
#> <btsbm_model> Bradley-Terry stochastic block model (BT-SBM), items share block strengths 
#>   strength prior:   lambda_k ~ iid Gamma(shape = 4, rate = 3.512)
#>   item partition:    z ~ Gnedin(gnedin_hyper = 0.5)
```

`shape` and `rate` define the Gamma prior on each block strength
\\\lambda_k\\. item_clustering is a prior over possible player tiers.
You can use finite_partition(max_clusters = 3) when a strict upper limit
is scientifically justified.

## 3. Fit the model

An MCMC fit produces many plausible values rather than one single
answer. warmup draws are discarded; the remaining draws represent
posterior uncertainty. The short chain below is suitable for a tutorial.
Use longer, multiple chains in a real study.

``` r

fit <- fit_model(
  tennis,
  model,
  mcmc_control(iter = 400, warmup = 200, seed = 2)
)
fit
#> <btsbm_fit> Bradley-Terry stochastic block model (BT-SBM), items share block strengths 
#>   6 items; 200 retained posterior draws. Use summary() for results.
```

## 4. Keep uncertainty in the number of tiers visible

The BT–SBM learns the number of occupied tiers in every MCMC draw. The
table reports the posterior probability of each sampled value of \\K\\;
it is more informative than reporting only the most frequent value.

``` r

posterior_K_table(fit)
#>   K draws probability
#> 1 1    18       0.090
#> 2 2   177       0.885
#> 3 3     5       0.025
```

Concentrated probability on one value means the data resolve the number
of tiers clearly. Probability spread across adjacent values means that
the broad hierarchy is supported but its precise resolution remains
uncertain.

## 5. Read the tier structure in the observed results

The next figure follows the analysis in Santi and Friel (2026). It
reorders the observed win-rate adjacency matrix by a representative
posterior partition and, within each tier, by marginal win proportion.
The horizontal and vertical boundaries and the coloured side band mark
changes between inferred tiers. Mixed colours inside a diagonal block
indicate competitive balance within a tier; consistently darker
upper-right blocks indicate that stronger tiers tend to defeat weaker
ones.

``` r

plot_ordered_adjacency(fit)
```

![Observed win rates reordered by the representative BT--SBM partition.
Boundary lines and the side band identify inferred
tiers.](getting-started_files/figure-html/block-adjacency-1.png)

Observed win rates reordered by the representative BT–SBM partition.
Boundary lines and the side band identify inferred tiers.

## 6. Separate assignment uncertainty from uncertainty in \\K\\

The assignment heatmap conditions on the posterior modal number of tiers
by default. This mirrors the paper’s Figure 4: conditioning on \\K\\
keeps the question focused on *which tier each player belongs to*,
rather than mixing it with uncertainty about how many tiers exist. Dark
cells indicate high posterior membership probability; diffuse rows
identify uncertain boundary players.

``` r

plot_assignment_probabilities(fit)
```

![Posterior tier-membership probabilities, conditional on the modal
number of
tiers.](getting-started_files/figure-html/assignment-probabilities-1.png)

Posterior tier-membership probabilities, conditional on the modal number
of tiers.

## 7. Check the sampler before interpreting it

MCMC draws should move around a stable region. Trace plots are a quick
screening tool: long trends or a completely stuck trace are reasons to
run longer chains or reconsider the model.

``` r

plot_mcmc_traces(fit)
```

![](getting-started_files/figure-html/trace-plot-1.png)

``` r

mcmc_diagnostics(fit)
#>          quantity  mean       sd      ess       mcse autocorrelation_lag_1
#> 1 n_item_clusters 1.935 0.333664 33.87867 0.05732528             0.6839837
```

## Where to go next

- Use bt_model() if every item should have its own strength without
  tiers.
- Use vignette(“pl-ranking-models”) when the observations are full or
  top-m rankings rather than wins and losses.
- Use vignette(“toy-data-gallery”) for additional worked synthetic
  examples.

## Reference

Santi, L. and Friel, N. (2026). The Bradley–Terry stochastic block
model. *The Annals of Applied Statistics*, 20(2), 1766–1787.
