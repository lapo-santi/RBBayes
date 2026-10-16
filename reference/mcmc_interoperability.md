# Convert a preference fit to a matrix of saved posterior draws

Columns `q[i]` are item strengths divided by their sum in each saved
draw. With `normalise = FALSE`, `theta[i]` are the stored, unnormalised
strengths. The index i follows `fit$data$item_labels`. K_item and
K_ranking contain occupied-group counts when available. Only retained
draws are returned.

All fits must use identical data (including item order) and model
specification, and have the same number of retained draws. The caller
must supply independently run chains, preferably with different seeds
and initialisations; these converters cannot establish independence.

## Usage

``` r
# S3 method for class 'btsbm_fit'
as.matrix(x, ..., normalise = TRUE, pars = NULL)

# S3 method for class 'btsbm_fit'
as.array(x, ..., normalise = TRUE, pars = NULL)

as_draws_array(x, normalise = TRUE, pars = NULL)

# S3 method for class 'btsbm_fit'
as.mcmc(x, ..., normalise = TRUE, pars = NULL)

# S3 method for class 'btsbm_fit'
as.mcmc.list(x, ..., normalise = TRUE, pars = NULL)

as_mcmc_chains(x, normalise = TRUE, pars = NULL)
```

## Arguments

- x:

  One btsbm_fit, or a non-empty list of fits from independent runs.

- ...:

  Reserved for generic compatibility.

- normalise:

  Logical; report sum-to-one item strengths by default.

- pars:

  Optional parameter names, as in as.matrix.btsbm_fit().

## Value

A numeric matrix with saved draws in rows and quantities in columns.

An array with dimensions iteration, chain, parameter. A single fit
contains one chain. Warm-up is already excluded.

as_draws_array returns an iteration by chain by parameter array.
as_mcmc_chains returns a coda mcmc.list, retaining original iteration
numbering. Its chains must also have equal warm-up lengths.

A coda mcmc object. Its first iteration is warmup + 1 and thin is 1.

## Details

Variable-length block-strength vectors and arbitrary allocation labels
are deliberately excluded. Mixture and LBM fits currently expose group
counts only, because a single profile-independent item-strength vector
is absent. For coda::gelman.diag(), use multivariate = FALSE: sum-to-one
strengths have a singular joint covariance. A constant group-count trace
can also have undefined convergence diagnostics. coda and bayesplot are
optional.
