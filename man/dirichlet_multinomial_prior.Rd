\name{dirichlet_multinomial_prior}
\alias{dirichlet_multinomial_prior}
\title{Dirichlet--multinomial prior for a latent partition}
\usage{dirichlet_multinomial_prior(max_clusters, concentration = 1)}
\arguments{
\item{max_clusters}{Positive integer number of available groups.}
\item{concentration}{Positive Dirichlet parameter for each group. Total concentration is \code{max_clusters * concentration}.}
}
\value{An object of class \code{btsbm_partition_prior}.}
\description{A symmetric Dirichlet prior on group weights, integrated out to give an allocation prior.}
