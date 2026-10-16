\name{mcmc_interoperability}
\alias{as.matrix.btsbm_fit}
\alias{as.array.btsbm_fit}
\alias{as.mcmc.btsbm_fit}
\alias{as.mcmc.list.btsbm_fit}
\alias{as_draws_array}
\alias{as_mcmc_chains}
\title{Convert preference-model fits for coda and bayesplot}
\usage{
\method{as.matrix}{btsbm_fit}(x, ..., normalise = TRUE, pars = NULL)
\method{as.array}{btsbm_fit}(x, ..., normalise = TRUE, pars = NULL)
\method{as.mcmc}{btsbm_fit}(x, ..., normalise = TRUE, pars = NULL)
\method{as.mcmc.list}{btsbm_fit}(x, ..., normalise = TRUE, pars = NULL)
as_draws_array(x, normalise = TRUE, pars = NULL)
as_mcmc_chains(x, normalise = TRUE, pars = NULL)
}
\arguments{
\item{x}{A btsbm_fit object. For as_draws_array and as_mcmc_chains, a non-empty list of independent fits is also accepted.}
\item{...}{Reserved for generic compatibility.}
\item{normalise}{Logical. Divide each item's strength by total strength within each draw (default TRUE). FALSE reports strengths on their stored scale.}
\item{pars}{Optional character vector selecting and ordering parameter columns.}
}
\value{A saved-draw matrix; an iteration by chain by parameter array; a coda mcmc object; or a coda mcmc.list, depending on the function.}
\description{Interoperability with standard posterior diagnostics and plots without merging independent chains or including warm-up.}
\details{
Columns q[i] are sum-to-one relative item strengths; theta[i] are strengths on the stored scale when normalise is FALSE. Indices follow x$data$item_labels. K_item and K_ranking are occupied-group counts, when available. Mixture and LBM fits currently expose only these counts: their varying-dimensional profile strengths and arbitrary allocation labels are not presented as fixed parameters.

Multiple fits must have identical data, item ordering and model specifications, and equal retained lengths. coda lists also require equal warm-up lengths. The caller must provide independently run chains: combining repeated copies of one fit does not establish independent replication. A single fit produces one chain.

Because relative strengths sum to one, their joint covariance is singular; use \code{multivariate = FALSE} in \code{coda::gelman.diag()}. Diagnostics for a group-count trace that is constant throughout a run can be undefined.

coda iterations start at warmup + 1 with thinning interval one. Both coda and bayesplot are optional packages. Arrays do not require either package; bayesplot accepts a fit directly through its as.array method.
}
\examples{
\dontrun{
fit <- fit_model(tennis_tiered_toy(), bt_model(),
                 mcmc_control(iter = 1000, warmup = 500, seed = 1))
chain <- coda::as.mcmc(fit)
coda::effectiveSize(chain)
bayesplot::mcmc_trace(fit, pars = c("q[1]", "q[2]"))
fit2 <- fit_model(fit$data, fit$model,
                  mcmc_control(iter = 1000, warmup = 500, seed = 2))
coda::gelman.diag(as_mcmc_chains(list(fit, fit2)),
                   autoburnin = FALSE, multivariate = FALSE)
bayesplot::mcmc_trace(as_draws_array(list(fit, fit2)), pars = "q[1]")
}
}
