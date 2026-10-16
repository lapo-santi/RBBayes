# Covariate-assisted ranking: a package roadmap

This note records a deliberate next step for BTSBM. It does not claim
that covariate-assisted inference is implemented yet.

## What is available now

[`nfl_quarterbacks_2014()`](https://laposanti.github.io/BTSBM/reference/nfl_quarterbacks_2014.md)
reproduces the published NFL example as a small, fully documented data
fixture. It includes 13 incomplete expert ranking lists and eleven
player-level covariates.
[`orthodontics_excerpt_2009()`](https://laposanti.github.io/BTSBM/reference/orthodontics_excerpt_2009.md)
makes the published 24-case, two-group table excerpt available in the
same transparent form. The full clinical orthodontics dataset (108
cases, 69 experts, nine groups) is not supplied with the article and
should not be guessed at or redistributed without an explicit
data-access and ethics decision.

Both functions keep `ranking_positions` separate from `item_covariates`.
This mirrors the data in the article and avoids claiming that the
current PL sampler already supports ragged rankings or covariates.

## The model worth adding first

For an item `i`, let `x_i` be its measured attributes. A
covariate-assisted PL model should use

``` R
log(strength_i) = x_i' * covariate_effects + residual_strength_i.
```

The first term is an interpretable, population-level explanation; the
second is an item-specific remainder. The PL probability is then
unchanged except that it uses `exp(log(strength_i))`. The identical
linear predictor gives a natural BT extension:

``` R
log odds(i beats j) = (x_i - x_j)' * covariate_effects
                       + residual_strength_i - residual_strength_j.
```

This is preferable to covariates replacing item strength entirely. A
pure regression model can be badly biased when important features are
unobserved; the residual lets the ranking data correct the covariate
explanation.

## A user-facing API

The eventual API should be explicit about what varies and what is being
shrunk. For example:

``` r

players <- nfl_quarterbacks_2014()

rankings <- as_rankings(
  rankings = players$ranking_positions,
  item_covariates = players$item_covariates,
  ranking_format = "positions"
)

model <- pl_covariate_model(
  covariate_effects = normal_effects(scale = 1),
  residual_strength = normal_residual_strength(scale = 1),
  standardize_covariates = TRUE
)
```

`item_covariates`, `covariate_effects`, and `residual_strength` say what
a user is modelling. They are preferable to a positional `X`, `beta`,
and anonymous variance parameters. The same component should be accepted
by a future `bt_covariate_model()`.

## Identification and priors

The implementation must not silently fit an intercept twice. It should
centre numeric covariates by default, omit the regression intercept, and
constrain the residual strengths to sum to zero. The total log strengths
can then be centred before exponentiation. Reasonable initial choices
are independent Normal priors for standardized covariate effects and
residuals, with an option for a shared global-local shrinkage prior when
there are many covariates.

The data should retain the centre and scale used during fitting so that
new data and coefficient plots are interpretable. The output should
distinguish:

- `posterior_covariate_effects()` — effect estimates with probability
  intervals;
- `posterior_residual_strength()` — what the covariates did not explain;
  and
- [`posterior_strength()`](https://laposanti.github.io/BTSBM/reference/posterior_strength.md)
  — the combined ranking quantity.

## Latent structure models

The stable first extension for PL–SBM is

``` R
log(strength_i) = x_i' * covariate_effects + block_residual_[item_block_i].
```

Thus blocks group items by their residual preference, not merely by a
covariate such as passing yards. This is both useful and identifiable.
For a PL mixture, the next choice is whether ranking groups have
different residual profiles, different covariate effects, or both. Start
with shared effects and group-specific residual profiles;
cluster-specific regressions need enough rankings per group and stronger
shrinkage. A PL co-clustering model can then use both a ranking-group
and an item-block residual, with shared covariate effects as the
conservative default.

## Required engineering sequence

1.  Generalise
    [`as_rankings()`](https://laposanti.github.io/BTSBM/reference/as_rankings.md)
    to accept variable-length top-m lists and position matrices with
    `NA` for unranked items.
2.  Add the simple PL covariate model, clear prior constructors, and
    posterior coefficient/residual plots.
3.  Test recovery on simulated data, then analyse the NFL fixture.
4.  Add the residual-block PL–SBM, followed by mixture and co-clustering
    variants.
5.  Port the augmentation and regression updates to C++ only after the R
    reference implementation is validated.

This follows Li, Yi and Liu’s BARC idea of a covariate effect plus an
item-specific remainder, while preserving the package’s PL likelihood
and latent-block architecture. The article also notes the natural future
extension to ranker covariates; those should be a separate design after
item covariates, because they change the score by ranker and
substantially increase the data requirements.
