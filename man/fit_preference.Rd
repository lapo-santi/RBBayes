\name{fit_preference}
\alias{fit_preference}
\title{Fit a Bayesian preference model}
\usage{
fit_preference(data, model, control = mcmc_control())
}
\arguments{
\item{data}{A pairwise-data or ranking-data object created by
\code{as_bt_data()} or \code{as_rankings()}.}
\item{model}{A \code{btsbm_model} object specifying the likelihood and structure.}
\item{control}{MCMC controls created by \code{mcmc_control()}.}
}
\value{An object of class \code{btsbm_fit}.}
\description{Compatibility wrapper for \code{fit_model()}. New analyses should use \code{fit_model()}.}
\seealso{\code{\link{fit_model}}}
