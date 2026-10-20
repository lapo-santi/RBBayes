#' Create validated Bradley--Terry pairwise data
#'
#' Converts a square win-count matrix or a directed edge-list data frame into
#' the same validated pairwise-data representation used by fit_model().
#'
#' @param wins Numeric square win-count matrix, or a data frame of directed
#'   outcomes with winner and loser columns. Repeated edges are added together.
#' @param item_labels Optional character vector of item names.  By default,
#'   matrix row names are used when available. For an edge list, this is the
#'   complete item universe and ordering, including any unobserved items.
#' @param winner,loser Names of edge-list columns identifying the winning and
#'   losing item. Values are converted to character item identifiers.
#' @param count Optional edge-list count-column name. NULL means one win per
#'   row. Counts must be non-negative integers. Self-comparisons are rejected.
#'
#' @return An object of class `btsbm_pairwise_data`.
#' @export
as_bt_data <- function(wins, item_labels = NULL, winner = "winner",
                       loser = "loser", count = NULL) {
  if (is.data.frame(wins)) {
    return(.bt_data_from_edges(wins, item_labels, winner, loser, count))
  }
  if (!is.matrix(wins) || nrow(wins) != ncol(wins) || nrow(wins) < 2L) {
    stop("`wins` must be a square matrix with at least two items.", call. = FALSE)
  }
  if (!is.numeric(wins) || any(!is.finite(wins))) {
    stop("`wins` must contain finite numeric counts.", call. = FALSE)
  }
  if (any(wins < 0) || any(diag(wins) != 0)) {
    stop("`wins` must be non-negative with a zero diagonal.", call. = FALSE)
  }

  n_items <- nrow(wins)
  if (is.null(item_labels)) item_labels <- rownames(wins)
  if (is.null(item_labels)) item_labels <- paste0("Item_", seq_len(n_items))
  if (!is.character(item_labels) || length(item_labels) != n_items ||
      anyNA(item_labels) || anyDuplicated(item_labels)) {
    stop("`item_labels` must be a unique, non-missing character vector of length n_items.", call. = FALSE)
  }

  dimnames(wins) <- list(item_labels, item_labels)
  structure(
    list(wins = wins, n_items = n_items, item_labels = item_labels),
    class = "btsbm_pairwise_data"
  )
}

#' Create validated Plackett--Luce ranking data
#'
#' Rows of `rankings` are preference orderings and columns are successive
#' positions, from most to least preferred. Each row may be a complete ranking
#' or a top-`m` prefix from one common universe of items. Internally this is
#' represented in the compact integer format used by the PLuce reference code,
#' but users never need to work with that internal name.
#'
#' @param rankings Integer-like matrix. Row `l` lists item ids from most to
#'   least preferred in ranking `l`.
#' @param item_count Total number of available items. If `NULL`, it is inferred
#'   as `max(rankings)`; supply it when a top-`m` dataset has never-ranked
#'   items.
#' @param ranking_labels Optional unique character vector identifying ranking rows.
#' @param item_labels Optional unique character vector of length `item_count`.
#'
#' @return An object of class `btsbm_ranking_data`.
#' @references Caron, F. and Doucet, A. (2012). Efficient Bayesian inference
#'   for generalized Bradley--Terry models. *Journal of Computational and
#'   Graphical Statistics*, 21(1), 174--196.
#'   \doi{10.1080/10618600.2012.638220}
#' @export
as_rankings <- function(rankings, item_count = NULL, ranking_labels = NULL,
                        item_labels = NULL) {
  if (!is.matrix(rankings) || nrow(rankings) < 1L || ncol(rankings) < 1L) {
    stop("`rankings` must be a non-empty matrix with one row per ranking.", call. = FALSE)
  }
  if (!is.numeric(rankings) || any(!is.finite(rankings)) || any(rankings != floor(rankings))) {
    stop("`rankings` must contain finite integer item ids.", call. = FALSE)
  }
  rankings <- matrix(as.integer(rankings), nrow = nrow(rankings), ncol = ncol(rankings),
                     dimnames = dimnames(rankings))

  if (is.null(item_count)) item_count <- max(rankings)
  if (length(item_count) != 1L || !is.finite(item_count) || item_count != floor(item_count) || item_count < 2L) {
    stop("`item_count` must be one integer of at least two.", call. = FALSE)
  }
  n_items <- as.integer(item_count)
  if (any(rankings < 1L | rankings > n_items)) {
    stop("Every `rankings` entry must lie in 1:item_count.", call. = FALSE)
  }
  if (any(apply(rankings, 1L, anyDuplicated))) {
    stop("Each ranking row in `rankings` must contain distinct item ids.", call. = FALSE)
  }

  n_rankings <- nrow(rankings)
  if (is.null(ranking_labels)) ranking_labels <- rownames(rankings)
  if (is.null(ranking_labels)) ranking_labels <- paste0("Ranking_", seq_len(n_rankings))
  if (!is.character(ranking_labels) || length(ranking_labels) != n_rankings ||
      anyNA(ranking_labels) || anyDuplicated(ranking_labels)) {
    stop("`ranking_labels` must be a unique, non-missing character vector of length nrow(rankings).", call. = FALSE)
  }

  if (is.null(item_labels)) item_labels <- paste0("Item_", seq_len(n_items))
  if (!is.character(item_labels) || length(item_labels) != n_items ||
      anyNA(item_labels) || anyDuplicated(item_labels)) {
    stop("`item_labels` must be a unique, non-missing character vector of length n_items.", call. = FALSE)
  }

  rownames(rankings) <- ranking_labels
  colnames(rankings) <- paste0("Rank_", seq_len(ncol(rankings)))
  structure(
    list(
      rankings = rankings,
      rho = rankings,
      n_items = n_items,
      n_rankings = n_rankings,
      rank_length = ncol(rankings),
      ranking_labels = ranking_labels,
      ranking_id = ranking_labels,
      item_labels = item_labels
    ),
    class = "btsbm_ranking_data"
  )
}

#' @rdname as_rankings
#' @param rho Deprecated name for `rankings`.
#' @param n_items Deprecated name for `item_count`.
#' @param ranking_id Deprecated name for `ranking_labels`.
#' @export
as_pl_data <- function(rho, n_items = NULL, ranking_id = NULL, item_labels = NULL) {
  as_rankings(
    rankings = rho,
    item_count = n_items,
    ranking_labels = ranking_id,
    item_labels = item_labels
  )
}

#' @export
print.btsbm_pairwise_data <- function(x, ...) {
  cat("<btsbm_pairwise_data>", x$n_items, "items and", sum(x$wins), "wins\n")
  invisible(x)
}

#' @export
print.btsbm_ranking_data <- function(x, ...) {
  cat("<btsbm_ranking_data>", x$n_rankings, "rankings of length", x$rank_length,
      "from", x$n_items, "items\n")
  invisible(x)
}

#' @export
print.btsbm_strength_prior <- function(x, ...) {
  cat("<strength prior> Gamma(shape = ", signif(x$shape, 4), ", rate = ",
      signif(x$rate, 4), ")\n", sep = "")
  invisible(x)
}

#' @export
print.btsbm_partition_prior <- function(x, ...) {
  description <- switch(
    x$type,
    gnedin = paste0("Gnedin(gnedin_hyper = ", x$gamma, ")"),
    dp = paste0("Dirichlet process(concentration = ", x$concentration, ")"),
    py = paste0("Pitman--Yor(concentration = ", x$concentration,
                ", discount = ", x$discount, ")"),
    dm = paste0("finite Dirichlet(max_clusters = ", x$max_clusters,
                ", concentration = ", x$concentration, ")")
  )
  cat("<clustering_prior>", description, "\n")
  invisible(x)
}

#' Gamma prior object for positive strengths (low-level)
#'
#' Model constructors such as [bt_model()] now take `shape` and `rate`
#' directly, so most users never need this function. It is kept for
#' compatibility with code written for earlier development versions.
#'
#' @param shape Positive Gamma shape for each latent strength.
#' @param rate Positive Gamma rate for each latent strength.
#'
#' @return An object of class `btsbm_strength_prior`.
#' @export
latent_strength <- function(shape = 1, rate = 1) {
  if (length(shape) != 1L || !is.finite(shape) || shape <= 0 ||
      length(rate) != 1L || !is.finite(rate) || rate <= 0) {
    stop("`shape` and `rate` must be finite positive scalars.", call. = FALSE)
  }
  structure(list(family = "gamma", shape = as.numeric(shape), rate = as.numeric(rate)),
            class = c("btsbm_strength_prior", "btsbm_ability_prior"))
}

#' @rdname latent_strength
#' @export
gamma_ability <- function(shape = 1, rate = 1) {
  latent_strength(shape = shape, rate = rate)
}

#' Choose a prior for a latent partition
#'
#' This is the common prior selector for item blocks in PL--SBM and ranking
#' groups in a PL mixture. `family = "gnedin"` is a flexible finite-cluster
#' prior and is the default. A Dirichlet process and Pitman--Yor process allow
#' a potentially unbounded number of groups. A finite Dirichlet prior fixes an
#' upper bound through `max_clusters`.
#'
#' @param family One of `"gnedin"`, `"dirichlet_process"`, `"pitman_yor"`,
#'   or `"finite_dirichlet"`.
#' @param gnedin_hyper Gnedin hyperparameter \eqn{\gamma} in `(0, 1)`.
#'   Larger values favour more occupied groups a priori.
#' @param gnedin_hyperparameter Deprecated alias for `gnedin_hyper`.
#' @param concentration Concentration for the Dirichlet-process, Pitman--Yor,
#'   or finite-Dirichlet prior.
#' @param discount Pitman--Yor discount in `[0, 1)`.
#' @param max_clusters Required maximum number of groups for
#'   `family = "finite_dirichlet"`.
#'
#' @return An object of class `btsbm_partition_prior`.
#' @export
clustering_prior <- function(
    family = c("gnedin", "dirichlet_process", "pitman_yor", "finite_dirichlet"),
    gnedin_hyper = 0.5, concentration = 1, discount = 0.2,
    max_clusters = NULL, gnedin_hyperparameter = NULL) {
  family <- match.arg(family)
  if (!is.null(gnedin_hyperparameter)) gnedin_hyper <- gnedin_hyperparameter
  gnedin_hyperparameter <- gnedin_hyper
  type <- switch(
    family,
    gnedin = "gnedin",
    dirichlet_process = "dp",
    pitman_yor = "py",
    finite_dirichlet = "dm"
  )
  if (type == "gnedin") {
    if (!is.finite(gnedin_hyperparameter) || gnedin_hyperparameter <= 0 || gnedin_hyperparameter >= 1) {
      stop("`gnedin_hyper` must lie in (0, 1).", call. = FALSE)
    }
    values <- list(
      type = type, family = family,
      gnedin_hyper = as.numeric(gnedin_hyperparameter),
      gnedin_hyperparameter = as.numeric(gnedin_hyperparameter),
      gamma = as.numeric(gnedin_hyperparameter)
    )
  } else if (type == "dp") {
    if (!is.finite(concentration) || concentration <= 0) {
      stop("`concentration` must be positive for a Dirichlet-process prior.", call. = FALSE)
    }
    values <- list(type = type, family = family, concentration = as.numeric(concentration),
                   alpha = as.numeric(concentration), discount = 0, sigma = 0)
  } else if (type == "py") {
    if (!is.finite(discount) || discount < 0 || discount >= 1 ||
        !is.finite(concentration) || concentration <= -discount) {
      stop("Pitman--Yor requires `discount` in [0, 1) and `concentration > -discount`.", call. = FALSE)
    }
    values <- list(type = type, family = family, concentration = as.numeric(concentration),
                   alpha = as.numeric(concentration), discount = as.numeric(discount),
                   sigma = as.numeric(discount))
  } else {
    if (!is.finite(concentration) || concentration <= 0 || length(max_clusters) != 1L ||
        !is.finite(max_clusters) || max_clusters < 1 || max_clusters != floor(max_clusters)) {
      stop("A finite-Dirichlet prior requires positive `concentration` and integer `max_clusters >= 1`.", call. = FALSE)
    }
    values <- list(type = type, family = family, concentration = as.numeric(concentration),
                   beta = as.numeric(concentration), max_clusters = as.integer(max_clusters),
                   K = as.integer(max_clusters))
  }
  structure(values, class = "btsbm_partition_prior")
}

#' Gnedin prior for a latent partition
#'
#' A Gnedin (2010) prior allows a random but almost surely finite number of
#' occupied groups.
#'
#' @param gnedin_hyper Gnedin hyperparameter \eqn{\gamma} in `(0, 1)`.
#' @param gnedin_hyperparameter Deprecated alias for `gnedin_hyper`.
#' @return An object of class `btsbm_partition_prior`.
#' @examples
#' gnedin_prior(gnedin_hyper = 0.5)
#' prior_mean_K(20, gnedin_prior(0.5))
#' @export
gnedin_prior <- function(gnedin_hyper = 0.5, gnedin_hyperparameter = NULL) {
  if (!is.null(gnedin_hyperparameter)) gnedin_hyper <- gnedin_hyperparameter
  clustering_prior("gnedin", gnedin_hyper = gnedin_hyper)
}

#' Dirichlet-process prior for a latent partition
#'
#' @param concentration Positive concentration parameter.
#' @return An object of class `btsbm_partition_prior`.
#' @export
dirichlet_process_prior <- function(concentration = 1) {
  clustering_prior("dirichlet_process", concentration = concentration)
}

#' Pitman--Yor prior for a latent partition
#'
#' @param concentration Concentration parameter.
#' @param discount Discount parameter in `[0, 1)`.
#' @return An object of class `btsbm_partition_prior`.
#' @export
pitman_yor_prior <- function(concentration = 1, discount = 0.2) {
  clustering_prior("pitman_yor", concentration = concentration, discount = discount)
}

#' Define a finite-Dirichlet prior for a latent partition
#'
#' @param max_clusters Positive integer upper bound on the number of groups.
#' @param concentration Positive symmetric Dirichlet concentration.
#' @return An object of class `btsbm_partition_prior`.
#' @export
finite_partition <- function(max_clusters, concentration = 1) {
  clustering_prior("finite_dirichlet", concentration = concentration,
                   max_clusters = max_clusters)
}

#' Legacy partition-prior interface
#'
#' @param type One of `"gnedin"`, `"dp"`, `"py"`, or `"dm"`.
#' @param gamma Gnedin hyperparameter.
#' @param alpha DP/Pitman--Yor concentration.
#' @param sigma Pitman--Yor discount.
#' @param beta Finite-Dirichlet concentration.
#' @param K Maximum finite-Dirichlet groups.
#' @return An object of class `btsbm_partition_prior`.
#' @export
partition_prior <- function(type = c("gnedin", "dp", "py", "dm"),
                            gamma = 0.5, alpha = 1, sigma = 0.2,
                            beta = 1, K = NULL) {
  type <- match.arg(type)
  switch(
    type,
    gnedin = clustering_prior("gnedin", gnedin_hyper = gamma),
    dp = clustering_prior("dirichlet_process", concentration = alpha),
    py = clustering_prior("pitman_yor", concentration = alpha, discount = sigma),
    dm = clustering_prior("finite_dirichlet", concentration = beta, max_clusters = K)
  )
}

#' Set the reporting scale for Plackett--Luce strengths
#'
#' A Plackett--Luce likelihood only identifies strength ratios. By default each
#' saved strength vector is divided by its sum (`"sum"`), so reported strengths
#' are shares that add to one, exactly like the normalised Bradley--Terry
#' strengths. `"logmean0"` (geometric mean one) is kept for compatibility.
#'
#' @param method One of `"sum"` (default), `"none"` or `"logmean0"`.
#'
#' @return An object of class `btsbm_pl_identifiability`.
#' @export
pl_identifiability <- function(method = c("sum", "none", "logmean0")) {
  structure(list(method = match.arg(method)), class = "btsbm_pl_identifiability")
}

#' Set MCMC controls for an RBBayes fit
#'
#' @param iter Total MCMC iterations.
#' @param warmup Number of warmup iterations.
#' @param seed Optional integer seed.
#' @param store Whether to store the minimal state or latent augmentations.
#' @param init_item_cluster Optional initial item partition.
#' @param init_ranking_cluster Optional initial ranking partition for PL mixture
#'   and PL--LBM models.
#' @param verbose Whether to report progress.
#' @param progress_every Progress frequency when `verbose` is `TRUE`.
#' @param partition_moves Optional result of [partition_moves()].
#'
#' @return An object of class `btsbm_mcmc_control`.
#' @export
mcmc_control <- function(iter = 2000, warmup = floor(iter / 2), seed = NULL,
                         store = c("minimal", "augmented"),
                         init_item_cluster = NULL, init_ranking_cluster = NULL,
                         verbose = FALSE,
                         progress_every = 1000L, partition_moves = NULL) {
  store <- match.arg(store)
  if (length(iter) != 1L || iter < 2 || iter != floor(iter) ||
      length(warmup) != 1L || warmup < 0 || warmup != floor(warmup) || warmup >= iter) {
    stop("Require integer `iter >= 2` and `0 <= warmup < iter`.", call. = FALSE)
  }
  if (!is.null(seed) && (length(seed) != 1L || !is.finite(seed) || seed != floor(seed))) {
    stop("`seed` must be NULL or one integer.", call. = FALSE)
  }
  if (length(progress_every) != 1L || !is.finite(progress_every) ||
      progress_every < 1L || progress_every != floor(progress_every)) {
    stop("`progress_every` must be a positive integer.", call. = FALSE)
  }
  structure(
    list(
      iter = as.integer(iter), warmup = as.integer(warmup), seed = seed,
      store = store, init_item_cluster = init_item_cluster,
      init_ranking_cluster = init_ranking_cluster,
      verbose = isTRUE(verbose), progress_every = as.integer(progress_every),
      partition_moves = partition_moves
    ),
    class = "btsbm_mcmc_control"
  )
}

#' Set partition-move controls
#'
#' @param split_merge Number of generic split--merge moves per iteration.
#' @param ranking_split_merge,item_split_merge PL--LBM moves for the ranking
#'   and item partitions respectively.
#' @param pair_proposal Pair-selection rule for a future split--merge kernel.
#' @param restricted_scans Number of restricted Gibbs scans.
#'
#' @return An object of class `btsbm_partition_moves`.
#' @export
partition_moves <- function(split_merge = 0L, ranking_split_merge = 0L,
                            item_split_merge = 0L,
                            pair_proposal = c("uniform", "balanced", "informed"),
                            restricted_scans = 1L) {
  values <- c(split_merge, ranking_split_merge, item_split_merge, restricted_scans)
  if (any(!is.finite(values)) || any(values < 0) || any(values != floor(values)) || restricted_scans < 1L) {
    stop("Move counts must be non-negative integers and `restricted_scans >= 1`.", call. = FALSE)
  }
  structure(
    list(
      split_merge = as.integer(split_merge),
      ranking_split_merge = as.integer(ranking_split_merge),
      item_split_merge = as.integer(item_split_merge),
      pair_proposal = match.arg(pair_proposal),
      restricted_scans = as.integer(restricted_scans)
    ),
    class = "btsbm_partition_moves"
  )
}

.default_latent_strength <- function(shape = 1, rate = 1) {
  latent_strength(shape = shape, rate = rate)
}

.new_btsbm_model <- function(likelihood, structure, latent_strength, item_clustering = NULL,
                              ranking_clustering = NULL, identifiability = NULL) {
  if (!inherits(latent_strength, "btsbm_strength_prior")) {
    stop("`latent_strength` must be created by `latent_strength()`.", call. = FALSE)
  }
  if (!is.null(item_clustering) && !inherits(item_clustering, "btsbm_partition_prior")) {
    stop("`item_clustering` must be created by `clustering_prior()` or a named prior helper.", call. = FALSE)
  }
  if (!is.null(ranking_clustering) && !inherits(ranking_clustering, "btsbm_partition_prior")) {
    stop("`ranking_clustering` must be created by `clustering_prior()` or a named prior helper.", call. = FALSE)
  }
  structure(
    list(
      likelihood = likelihood, structure = structure,
      latent_strength = latent_strength,
      item_clustering = item_clustering,
      ranking_clustering = ranking_clustering,
      identifiability = identifiability,
      # Compatibility fields for code written before the public API rename.
      ability_prior = latent_strength, item_prior = item_clustering,
      ranking_prior = ranking_clustering
    ),
    class = "btsbm_model"
  )
}

.resolve_strength_prior <- function(shape, rate, latent_strength = NULL,
                                    ability_prior = NULL) {
  legacy <- if (!is.null(latent_strength)) latent_strength else ability_prior
  # Positional legacy call, e.g. bt_model(latent_strength(2, 1)).
  if (is.null(legacy) && inherits(shape, "btsbm_strength_prior")) legacy <- shape
  if (!is.null(legacy)) {
    if (!inherits(legacy, "btsbm_strength_prior")) {
      stop("`latent_strength` must be created by `latent_strength()`; ",
           "new code should pass `shape` and `rate` directly.", call. = FALSE)
    }
    return(legacy)
  }
  latent_strength(shape = shape, rate = rate)
}

#' Define a simple Bradley--Terry model
#'
#' Each item \eqn{i} has its own positive strength \eqn{\lambda_i}, and
#' \deqn{y_{ij} \mid \lambda \sim \mathrm{Binomial}\left(n_{ij},
#'   \frac{\lambda_i}{\lambda_i + \lambda_j}\right).}
#' The strengths are given independent and identically distributed Gamma
#' priors, \eqn{\lambda_i \sim \mathrm{Gamma}(\mathrm{shape}, \mathrm{rate})}.
#' Only the shape and rate need to be supplied: the model knows the
#' \eqn{\lambda_i} are i.i.d.
#'
#' The default rate `exp(digamma(shape))` gives \eqn{E[\log \lambda_i] = 0},
#' so a typical strength is about one. Strengths used to simulate data should
#' be on a comparable scale (for example `c(12, 6, 2, 1)`, rather than values
#' spanning several orders of magnitude).
#'
#' @param shape,rate Shape and rate of the Gamma prior on every
#'   \eqn{\lambda_i}.
#' @param latent_strength,ability_prior Deprecated. A prior object from
#'   [latent_strength()]; if supplied it overrides `shape` and `rate`.
#' @return A `btsbm_model`.
#' @examples
#' bt_model(shape = 2)
#' @export
bt_model <- function(shape = 4, rate = exp(digamma(shape)),
                     latent_strength = NULL, ability_prior = NULL) {
  prior <- .resolve_strength_prior(shape, rate, latent_strength, ability_prior)
  .new_btsbm_model("bt", "none", prior)
}

#' Define a Bradley--Terry stochastic block model
#'
#' Item \eqn{i} belongs to block \eqn{z_i \in \{1, \ldots, K\}} and all items
#' in block \eqn{k} share the strength \eqn{\lambda_k}:
#' \deqn{\Pr(i \text{ beats } j \mid z, \lambda) =
#'   \frac{\lambda_{z_i}}{\lambda_{z_i} + \lambda_{z_j}}.}
#' Block strengths are i.i.d. \eqn{\mathrm{Gamma}(\mathrm{shape}, \mathrm{rate})}
#' and the partition \eqn{z} receives the prior `item_clustering`.
#'
#' @inheritParams bt_model
#' @param item_clustering Prior on the item partition \eqn{z}; see
#'   [gnedin_prior()], [dirichlet_process_prior()], [pitman_yor_prior()] or
#'   [dirichlet_multinomial_prior()].
#' @param item_prior Deprecated alias for `item_clustering`.
#' @return A `btsbm_model`.
#' @examples
#' bt_sbm_model(shape = 2, item_clustering = gnedin_prior(gnedin_hyper = 0.5))
#' @export
bt_sbm_model <- function(shape = 4, rate = exp(digamma(shape)),
                         item_clustering = gnedin_prior(gnedin_hyper = 0.5),
                         latent_strength = NULL, ability_prior = NULL,
                         item_prior = NULL) {
  prior <- .resolve_strength_prior(shape, rate, latent_strength, ability_prior)
  if (!is.null(item_prior)) item_clustering <- item_prior
  .new_btsbm_model("bt", "item_sbm", prior, item_clustering = item_clustering)
}

#' Define a simple Plackett--Luce model
#'
#' Item strengths are i.i.d. \eqn{\mathrm{Gamma}(\mathrm{shape},
#' \mathrm{rate})}. By default reported strengths are divided by their sum in
#' every draw, so they are shares that add to one.
#'
#' @inheritParams bt_model
#' @param identifiability PL reporting constraint, see [pl_identifiability()].
#' @return A `btsbm_model`.
#' @export
pl_model <- function(shape = 1, rate = 1,
                     identifiability = pl_identifiability(),
                     latent_strength = NULL, ability_prior = NULL) {
  prior <- .resolve_strength_prior(shape, rate, latent_strength, ability_prior)
  .new_btsbm_model("pl", "none", prior, identifiability = identifiability)
}

#' Define a Plackett--Luce stochastic block model
#' @inheritParams bt_sbm_model
#' @inheritParams pl_model
#' @return A `btsbm_model`.
#' @export
pl_sbm_model <- function(shape = 1, rate = 1,
                         item_clustering = gnedin_prior(gnedin_hyper = 0.5),
                         identifiability = pl_identifiability(),
                         latent_strength = NULL, ability_prior = NULL,
                         item_prior = NULL) {
  prior <- .resolve_strength_prior(shape, rate, latent_strength, ability_prior)
  if (!is.null(item_prior)) item_clustering <- item_prior
  .new_btsbm_model("pl", "item_sbm", prior, item_clustering = item_clustering,
                    identifiability = identifiability)
}

#' Define a Plackett--Luce ranking-mixture model
#'
#' Ranking rows are assigned to latent preference groups. Each group has a
#' separate vector of item strengths.
#'
#' @inheritParams pl_model
#' @param ranking_clustering Prior on latent ranking groups.
#' @param ranking_prior Deprecated alias for `ranking_clustering`.
#' @return A `btsbm_model`.
#' @export
pl_mixture_model <- function(shape = 1, rate = 1,
                             ranking_clustering = gnedin_prior(gnedin_hyper = 0.5),
                             identifiability = pl_identifiability(),
                             latent_strength = NULL, ability_prior = NULL,
                             ranking_prior = NULL) {
  prior <- .resolve_strength_prior(shape, rate, latent_strength, ability_prior)
  if (!is.null(ranking_prior)) ranking_clustering <- ranking_prior
  .new_btsbm_model("pl", "ranking_mixture", prior,
                    ranking_clustering = ranking_clustering,
                    identifiability = identifiability)
}

#' Define a Plackett--Luce latent block model
#'
#' The PL--LBM jointly partitions ranking rows and items. Each pair of latent
#' groups has its own positive strength.
#'
#' @inheritParams pl_model
#' @inheritParams pl_mixture_model
#' @inheritParams bt_sbm_model
#' @return A `btsbm_model`.
#' @export
pl_lbm_model <- function(shape = 1, rate = 1,
                         ranking_clustering = gnedin_prior(gnedin_hyper = 0.5),
                         item_clustering = gnedin_prior(gnedin_hyper = 0.5),
                         identifiability = pl_identifiability(),
                         latent_strength = NULL, ability_prior = NULL,
                         ranking_prior = NULL, item_prior = NULL) {
  prior <- .resolve_strength_prior(shape, rate, latent_strength, ability_prior)
  if (!is.null(ranking_prior)) ranking_clustering <- ranking_prior
  if (!is.null(item_prior)) item_clustering <- item_prior
  .new_btsbm_model("pl", "lbm", prior,
                    item_clustering = item_clustering,
                    ranking_clustering = ranking_clustering,
                    identifiability = identifiability)
}

#' @export
print.btsbm_model <- function(x, ...) {
  cat("<btsbm_model>", .model_long_name(x), "\n")
  symbol <- if (x$structure == "none") "lambda_i" else "lambda_k"
  cat("  strength prior:   ", symbol, " ~ iid Gamma(shape = ",
      signif(x$latent_strength$shape, 4), ", rate = ",
      signif(x$latent_strength$rate, 4), ")\n", sep = "")
  if (!is.null(x$item_clustering)) {
    cat("  item partition:    z ~ ", .prior_description(x$item_clustering), "\n", sep = "")
  }
  if (!is.null(x$ranking_clustering)) {
    cat("  ranking partition: ", .prior_description(x$ranking_clustering), "\n", sep = "")
  }
  invisible(x)
}
