\name{tennis_tiered_toy}
\alias{tennis_tiered_toy}
\title{Simulate a tiered tennis league}
\usage{
tennis_tiered_toy(matches_per_pair = 20L, seed = 101L,
  n_blocks = length(latent_strength), latent_strength = c(64, 16, 4, 1),
  players_per_block = 5L, item_labels = NULL, format = c("data", "edgelist"))
}
\arguments{
\item{matches_per_pair}{Positive integer matches per pair.}
\item{seed}{Integer random seed, or NULL.}
\item{n_blocks}{Positive integer number of generating blocks.}
\item{latent_strength}{Positive strength vector with one value per block.}
\item{players_per_block}{Positive integer block sizes: a scalar or one value per block.}
\item{item_labels}{Optional unique names for all players.}
\item{format}{Return validated data or an aggregated winner/loser/count edge list.}
}
\value{A btsbm_pairwise_data object with a truth attribute, or an edge-list data frame.}
\description{Simulate pairwise results from specified block strengths and sizes. Default settings give twenty fictional players in four blocks of five. A common random permutation shuffles both matrix axes.}
\examples{
edges <- tennis_tiered_toy(n_blocks = 3, latent_strength = c(25, 5, 1),
                           players_per_block = 4, format = "edgelist")
as_bt_data(edges, count = "count")
}
