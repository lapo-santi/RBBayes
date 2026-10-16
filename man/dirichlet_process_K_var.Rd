\name{dirichlet_process_K_var}
\alias{dirichlet_process_K_var}
\title{Prior variance of the occupied-group count under a Dirichlet process}
\usage{dirichlet_process_K_var(n, concentration = 1)}
\arguments{
\item{n}{Positive integer number of items.}
\item{concentration}{Positive finite Dirichlet-process concentration.}
}
\value{A numeric scalar, the prior variance of the occupied-group count.}
\description{Sum the variances of independent Bernoulli new-group indicators with probabilities concentration/(concentration+i-1), for i=1,...,n.}
\examples{dirichlet_process_K_var(20, concentration = 1)}
