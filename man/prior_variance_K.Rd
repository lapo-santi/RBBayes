\name{prior_variance_K}
\alias{prior_variance_K}
\title{Prior variance of the number of occupied groups}
\usage{prior_variance_K(n, prior)}
\arguments{
\item{n}{Positive integer number of items.}
\item{prior}{A partition prior created by a clustering-prior constructor.}
}
\value{A numeric scalar, or NA for unimplemented variance families.}
\description{Supports Gnedin and Dirichlet-process priors. Returns NA for Pitman--Yor and Dirichlet--multinomial priors; these variance calculations are not implemented.}
