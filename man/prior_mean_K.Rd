\name{prior_mean_K}
\alias{prior_mean_K}
\title{Prior expected number of occupied groups}
\usage{prior_mean_K(n, prior)}
\arguments{
\item{n}{Positive integer number of items.}
\item{prior}{A partition prior created by a clustering-prior constructor.}
}
\value{A numeric scalar.}
\description{Supports Gnedin, Dirichlet-process, Pitman--Yor and Dirichlet--multinomial priors. The DM concentration is converted from per-group to total concentration internally.}
