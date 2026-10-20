# Posterior summaries for latent partitions and strengths.
#
# Notation follows the tutorial: z_i is the block of item i, lambda_k the
# strength of block k (lambda_i in the unclustered model), and K the number of
# occupied blocks.

# ---------------------------------------------------------------------------
# Colour palette for blocks
# ---------------------------------------------------------------------------

.okabe_ito <- c("#0072B2", "#D55E00", "#009E73", "#CC79A7",
                "#E69F00", "#56B4E9", "#F0E442", "#000000")

# Return exactly K distinct colours. Up to eight blocks use the colour-blind
# safe Okabe--Ito palette; larger K uses an evenly spaced HCL palette, which
# stays distinct for any K. A user palette that is too short is interpolated
# (with a warning) rather than causing an error.
.block_palette <- function(K, palette = NULL) {
  K <- as.integer(K)
  if (length(K) != 1L || is.na(K) || K < 1L) stop("`K` must be a positive integer.", call. = FALSE)
  if (!is.null(palette)) {
    palette <- unname(as.character(palette))
    if (length(palette) >= K) return(palette[seq_len(K)])
    if (length(palette) >= 2L) {
      warning("`palette` has ", length(palette), " colours but ", K,
              " blocks are shown; interpolating extra colours.", call. = FALSE)
      return(grDevices::colorRampPalette(palette)(K))
    }
    warning("`palette` has fewer than two colours; using the default palette.", call. = FALSE)
  }
  if (K <= length(.okabe_ito)) return(.okabe_ito[seq_len(K)])
  grDevices::hcl.colors(K, palette = "Dark 3")
}

# Kept under its historical name for plot_lambda_uncertainty().
btsbm_block_palette <- function(K, palette = NULL) .block_palette(K, palette)

# ---------------------------------------------------------------------------
# Partition utilities
# ---------------------------------------------------------------------------

.require_item_partition <- function(fit) {
  if (!inherits(fit, "btsbm_fit")) stop("`fit` must be a `btsbm_fit` object.", call. = FALSE)
  if (is.null(fit$draws$item_cluster)) {
    stop("This fit has no sampled item partition z; use a block model such as ",
         "bt_sbm_model().", call. = FALSE)
  }
  invisible(fit)
}

.psm_from_draws <- function(draws) {
  draws <- as.matrix(draws)
  n <- ncol(draws)
  out <- matrix(0, n, n)
  for (s in seq_len(nrow(draws))) out <- out + outer(draws[s, ], draws[s, ], `==`)
  out / nrow(draws)
}

# Variation of information (base-2 logarithms, as in mcclust).
.vi_distance <- function(a, b) {
  n <- length(a)
  tab <- table(a, b) / n
  pa <- rowSums(tab)
  pb <- colSums(tab)
  pab <- tab[tab > 0]
  -sum(pa * log2(pa)) - sum(pb * log2(pb)) - 2 * sum(pab * log2(pab / outer(pa, pb)[tab > 0]))
}

.vi_to_draws <- function(center, draws) {
  apply(draws, 1L, function(row) .vi_distance(center, row))
}

# Wade & Ghahramani (2018) lower bound of the expected VI, computed from the PSM.
.vi_lower_bound <- function(candidate, psm) {
  same <- outer(candidate, candidate, `==`)
  sum(log2(rowSums(same)) - 2 * log2(rowSums(same * psm)) + log2(rowSums(psm))) / length(candidate)
}

.expected_binder <- function(candidate, psm) {
  same <- outer(candidate, candidate, `==`)
  sum(abs(same - psm)[upper.tri(psm)])
}

.compact_labels <- function(z) match(z, unique(z))

# Order block labels so that block 1 has the largest mean item strength.
.relabel_by_strength <- function(z, item_strength_mean) {
  z <- as.integer(z)
  labs <- unique(z)
  means <- vapply(labs, function(k) mean(item_strength_mean[z == k]), numeric(1))
  map <- stats::setNames(seq_along(labs), labs[order(means, decreasing = TRUE)])
  as.integer(map[as.character(z)])
}

.item_strength_mean <- function(fit) {
  draws <- fit$draws$item_strength
  if (is.null(draws)) return(rep(0, fit$data$n_items))
  colMeans(draws / rowSums(draws))
}

.native_point_estimate <- function(draws, loss = c("VI", "binder"), max_candidates = 2000L) {
  loss <- match.arg(loss)
  draws <- t(apply(as.matrix(draws), 1L, .compact_labels))
  if (ncol(draws) == 1L) draws <- t(draws)
  psm <- .psm_from_draws(draws)
  keys <- apply(draws, 1L, paste, collapse = ",")
  freq <- sort(table(keys), decreasing = TRUE)
  candidates <- lapply(utils::head(names(freq), max_candidates),
                       function(k) as.integer(strsplit(k, ",", fixed = TRUE)[[1]]))
  n <- ncol(draws)
  if (n > 1L) {
    tree <- stats::hclust(stats::as.dist(1 - psm), method = "average")
    for (k in seq_len(min(n, 30L))) candidates[[length(candidates) + 1L]] <- stats::cutree(tree, k = k)
  }
  if (loss == "binder") {
    scores <- vapply(candidates, .expected_binder, numeric(1), psm = psm)
    return(as.integer(.compact_labels(candidates[[which.min(scores)]])))
  }
  lower <- vapply(candidates, .vi_lower_bound, numeric(1), psm = psm)
  shortlist <- candidates[order(lower)[seq_len(min(10L, length(candidates)))]]
  sub <- if (nrow(draws) > 1000L) {
    draws[unique(round(seq(1, nrow(draws), length.out = 1000L))), , drop = FALSE]
  } else draws
  exact <- vapply(shortlist, function(cand) mean(.vi_to_draws(cand, sub)), numeric(1))
  as.integer(.compact_labels(shortlist[[which.min(exact)]]))
}

.partition_point_estimate_draws <- function(draws, loss = c("VI", "binder")) {
  loss <- match.arg(loss)
  if (requireNamespace("salso", quietly = TRUE)) {
    est <- salso::salso(draws, loss = if (loss == "VI") salso::VI() else salso::binder(),
                        nRuns = 16L, nCores = 1L)
    return(as.integer(est))
  }
  .native_point_estimate(draws, loss = loss)
}

#' Point estimate of the item partition
#'
#' Summarises the posterior over the item partition \eqn{z} by the partition
#' that minimises the posterior expected loss. With `loss = "VI"` this is the
#' variation-of-information estimate of Wade and Ghahramani (2018). When the
#' \pkg{salso} package is installed its search algorithm is used; otherwise a
#' built-in search over the sampled partitions (and hierarchical cuts of the
#' posterior similarity matrix) is used, so the function always works on a
#' fresh installation.
#'
#' Blocks are labelled so that block 1 has the largest posterior mean strength.
#'
#' @param fit A block-model `btsbm_fit`, e.g. from [bt_sbm_model()].
#' @param loss Either `"VI"` (default) or `"binder"`.
#' @return A named integer vector with one block label per item.
#' @references Wade, S. and Ghahramani, Z. (2018). Bayesian cluster analysis:
#'   point estimation and credible balls. *Bayesian Analysis*, 13(2), 559--626.
#'   \doi{10.1214/17-BA1073}
#' @export
partition_point_estimate <- function(fit, loss = c("VI", "binder")) {
  .require_item_partition(fit)
  loss <- match.arg(loss)
  est <- .partition_point_estimate_draws(fit$draws$item_cluster, loss = loss)
  est <- .relabel_by_strength(est, .item_strength_mean(fit))
  stats::setNames(est, fit$data$item_labels)
}

# ---------------------------------------------------------------------------
# Credible ball
# ---------------------------------------------------------------------------

#' Credible ball for the item partition
#'
#' The \eqn{(1-\alpha)} credible ball (Wade and Ghahramani, 2018) is the
#' smallest ball, in variation-of-information (VI) distance, around a point
#' estimate \eqn{\hat z} that contains at least `credible_mass` of the
#' posterior draws. It is summarised by three bounds:
#' \describe{
#'   \item{upper vertical bound}{the partitions in the ball with the
#'     \emph{fewest} blocks that are furthest from \eqn{\hat z} (coarsest
#'     plausible tiering);}
#'   \item{lower vertical bound}{the partitions in the ball with the
#'     \emph{most} blocks that are furthest from \eqn{\hat z} (finest plausible
#'     tiering);}
#'   \item{horizontal bound}{the partitions furthest from \eqn{\hat z}.}
#' }
#'
#' The native implementation needs no extra packages. If the GitHub package
#' \pkg{mcclust.ext} is installed, `method = "mcclust.ext"` calls
#' `mcclust.ext::credibleball()` instead, which is useful as a cross-check.
#'
#' @param fit A block-model `btsbm_fit`.
#' @param z_hat Optional point estimate; defaults to
#'   [partition_point_estimate()].
#' @param credible_mass Posterior mass of the ball, in (0, 1).
#' @param method `"native"` (default) or `"mcclust.ext"`.
#' @return An object of class `btsbm_credible_ball`: a list with the centre,
#'   radius, the three bounds (each relabelled so block 1 is the strongest),
#'   the number of blocks of each bound and the VI distance of every draw.
#' @references Wade, S. and Ghahramani, Z. (2018). Bayesian cluster analysis:
#'   point estimation and credible balls. *Bayesian Analysis*, 13(2), 559--626.
#'   \doi{10.1214/17-BA1073}
#' @seealso [plot_credible_ball()]
#' @export
credible_ball <- function(fit, z_hat = NULL, credible_mass = 0.95,
                          method = c("native", "mcclust.ext")) {
  .require_item_partition(fit)
  method <- match.arg(method)
  if (length(credible_mass) != 1L || !is.finite(credible_mass) ||
      credible_mass <= 0 || credible_mass >= 1) {
    stop("`credible_mass` must lie strictly between zero and one.", call. = FALSE)
  }
  draws <- t(apply(fit$draws$item_cluster, 1L, .compact_labels))
  if (is.null(z_hat)) z_hat <- partition_point_estimate(fit)
  z_hat <- as.integer(z_hat)
  if (length(z_hat) != ncol(draws)) stop("`z_hat` must have one label per item.", call. = FALSE)
  strength <- .item_strength_mean(fit)
  labels <- fit$data$item_labels

  if (method == "mcclust.ext") {
    ext_pkg <- "mcclust.ext"  # GitHub-only; deliberately not declared in DESCRIPTION
    if (!requireNamespace(ext_pkg, quietly = TRUE)) {
      stop("Install mcclust.ext with remotes::install_github('sarawade/mcclust.ext'), ",
           "or use method = 'native'.", call. = FALSE)
    }
    credibleball <- getExportedValue(ext_pkg, "credibleball")
    cb <- credibleball(c.star = z_hat, cls.draw = draws,
                       c.dist = "VI", alpha = 1 - credible_mass)
    first_row <- function(m) as.integer(if (is.matrix(m)) m[1, ] else m)
    upper <- first_row(cb$c.uppervert); lower <- first_row(cb$c.lowervert)
    horiz <- first_row(cb$c.horiz)
    radius <- cb$dist.horiz
    distances <- .vi_to_draws(z_hat, draws)
  } else {
    distances <- .vi_to_draws(z_hat, draws)
    S <- length(distances)
    radius <- sort(distances)[ceiling(credible_mass * S)]
    inside <- which(distances <= radius + 1e-12)
    k_inside <- apply(draws[inside, , drop = FALSE], 1L, function(z) length(unique(z)))
    furthest <- function(idx) idx[which.max(distances[idx])]
    upper <- draws[furthest(inside[k_inside == min(k_inside)]), ]
    lower <- draws[furthest(inside[k_inside == max(k_inside)]), ]
    horiz <- draws[furthest(inside), ]
  }
  relab <- function(z) stats::setNames(.relabel_by_strength(z, strength), labels)
  out <- list(
    point_estimate = relab(z_hat),
    upper_vertical = relab(upper),
    lower_vertical = relab(lower),
    horizontal = relab(horiz),
    radius = radius,
    credible_mass = credible_mass,
    prob_inside = mean(distances <= radius + 1e-12),
    n_blocks = c(point_estimate = length(unique(z_hat)),
                 upper_vertical = length(unique(upper)),
                 lower_vertical = length(unique(lower)),
                 horizontal = length(unique(horiz))),
    vi_distance = distances,
    method = method
  )
  class(out) <- "btsbm_credible_ball"
  out
}

#' @export
print.btsbm_credible_ball <- function(x, ...) {
  cat("<credible ball for the item partition z>\n")
  cat(sprintf("  %g%% ball, VI radius %.3f (contains %.1f%% of draws; method: %s)\n",
              100 * x$credible_mass, x$radius, 100 * x$prob_inside, x$method))
  cat("  Number of blocks K:\n")
  cat(sprintf("    point estimate        %d\n", x$n_blocks[["point_estimate"]]))
  cat(sprintf("    upper vertical bound  %d  (coarsest partition in the ball)\n", x$n_blocks[["upper_vertical"]]))
  cat(sprintf("    lower vertical bound  %d  (finest partition in the ball)\n", x$n_blocks[["lower_vertical"]]))
  cat(sprintf("    horizontal bound      %d  (furthest partition from the estimate)\n", x$n_blocks[["horizontal"]]))
  invisible(x)
}

#' Plot the credible ball for the item partition
#'
#' Shows the point estimate next to the upper vertical, lower vertical and
#' horizontal bounds of [credible_ball()]. Each column is one partition; items
#' sharing a colour are in the same block, and block 1 is the strongest.
#'
#' @param x A `btsbm_credible_ball`, or a block-model `btsbm_fit` (in which case
#'   [credible_ball()] is computed with default settings).
#' @param palette Optional block colours.
#' @param ... Passed to [credible_ball()] when `x` is a fit.
#' @return A ggplot object.
#' @export
plot_credible_ball <- function(x, palette = NULL, ...) {
  .require_ggplot2()
  if (inherits(x, "btsbm_fit")) x <- credible_ball(x, ...)
  if (!inherits(x, "btsbm_credible_ball")) {
    stop("`x` must be a credible_ball() result or a block-model fit.", call. = FALSE)
  }
  parts <- list(
    "Point estimate" = x$point_estimate,
    "Upper vertical\n(fewest blocks)" = x$upper_vertical,
    "Lower vertical\n(most blocks)" = x$lower_vertical,
    "Horizontal" = x$horizontal
  )
  items <- names(x$point_estimate)
  ord <- items[order(x$point_estimate, x$lower_vertical)]
  plot_data <- do.call(rbind, lapply(names(parts), function(nm) {
    data.frame(partition = nm, item = items, block = parts[[nm]], stringsAsFactors = FALSE)
  }))
  K <- max(plot_data$block)
  plot_data$block <- factor(plot_data$block, levels = seq_len(K))
  plot_data$item <- factor(plot_data$item, levels = rev(ord))
  col_labels <- paste0(names(parts), "\nK = ", x$n_blocks)
  plot_data$partition <- factor(plot_data$partition, levels = names(parts),
                                labels = col_labels)
  ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$partition, y = .data$item,
                                          fill = .data$block)) +
    ggplot2::geom_tile(colour = "white", linewidth = 0.6) +
    ggplot2::scale_fill_manual(values = .block_palette(K, palette), name = "Block\n(1 = strongest)") +
    ggplot2::labs(x = NULL, y = NULL,
                  title = sprintf("%g%% credible ball for the partition", 100 * x$credible_mass),
                  subtitle = sprintf("VI radius %.2f around the point estimate", x$radius)) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(panel.grid = ggplot2::element_blank())
}

# ---------------------------------------------------------------------------
# Pr(lambda_i > lambda_j | y)
# ---------------------------------------------------------------------------

#' Posterior probability that one item is stronger than another
#'
#' Computes \eqn{\Pr(\lambda_i > \lambda_j \mid y)} for every pair of items,
#' as the proportion of saved draws in which item \eqn{i}'s strength exceeds
#' item \eqn{j}'s. The comparison is unaffected by how strengths are
#' normalised. In a block model, two items in the same block have exactly equal
#' strength; that probability, \eqn{\Pr(z_i = z_j \mid y)}, is returned in the
#' `prob_equal` attribute, so that
#' \eqn{\Pr(\lambda_i > \lambda_j) + \Pr(\lambda_j > \lambda_i) +
#' \Pr(\lambda_i = \lambda_j) = 1}.
#'
#' @param fit A simple BT/PL or item-block `btsbm_fit`.
#' @return A square matrix with rows and columns named by item; entry
#'   `[i, j]` is \eqn{\Pr(\lambda_i > \lambda_j \mid y)}. Items are ordered by
#'   decreasing posterior mean strength.
#' @examples
#' \donttest{
#' data <- tennis_tiered_toy(seed = 1)
#' fit <- fit_model(data, bt_model(shape = 2),
#'                  mcmc_control(iter = 400, warmup = 200, seed = 1))
#' round(prob_stronger(fit)[1:4, 1:4], 2)
#' }
#' @export
prob_stronger <- function(fit) {
  if (!inherits(fit, "btsbm_fit")) stop("`fit` must be a `btsbm_fit` object.", call. = FALSE)
  draws <- posterior_strength(fit, summary = "draws")
  labels <- fit$data$item_labels
  n <- ncol(draws)
  greater <- matrix(0, n, n)
  equal <- matrix(0, n, n)
  for (j in seq_len(n)) {
    greater[, j] <- colMeans(draws > draws[, j])
    equal[, j] <- colMeans(draws == draws[, j])
  }
  dimnames(greater) <- dimnames(equal) <- list(labels, labels)
  ord <- order(colMeans(draws / rowSums(draws)), decreasing = TRUE)
  greater <- greater[ord, ord, drop = FALSE]
  equal <- equal[ord, ord, drop = FALSE]
  diag(greater) <- NA_real_
  diag(equal) <- NA_real_
  attr(greater, "prob_equal") <- equal
  greater
}

#' Plot posterior probabilities that one item is stronger than another
#'
#' Heatmap of \eqn{\Pr(\lambda_i > \lambda_j \mid y)} (row item \eqn{i},
#' column item \eqn{j}). The colour scale diverges at 0.5: blue cells mean
#' the row item is probably stronger, red cells mean it is probably weaker,
#' and white cells mean the data cannot tell them apart. In a block model,
#' pairs in the same block are tied, so both directions can be well below 0.5.
#'
#' @param fit A simple BT/PL or item-block `btsbm_fit`.
#' @param show_values Print probabilities in the cells. Defaults to `TRUE`
#'   for at most 20 items.
#' @param max_items Optional: show only the strongest `max_items` items.
#' @return A ggplot object.
#' @export
plot_prob_stronger <- function(fit, show_values = NULL, max_items = NULL) {
  .require_ggplot2()
  prob <- prob_stronger(fit)
  if (!is.null(max_items)) {
    keep <- seq_len(min(max_items, nrow(prob)))
    prob <- prob[keep, keep, drop = FALSE]
  }
  labels <- rownames(prob)
  if (is.null(show_values)) show_values <- length(labels) <= 20L
  plot_data <- expand.grid(row = labels, column = labels, stringsAsFactors = FALSE,
                           KEEP.OUT.ATTRS = FALSE)
  plot_data$probability <- as.vector(prob)
  plot_data$row <- factor(plot_data$row, levels = rev(labels))
  plot_data$column <- factor(plot_data$column, levels = labels)
  is_block <- !is.null(fit$draws$item_cluster)
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$column, y = .data$row,
                                               fill = .data$probability)) +
    ggplot2::geom_tile(colour = "white", linewidth = 0.2) +
    ggplot2::scale_fill_gradient2(low = "#B2182B", mid = "#F7F7F7", high = "#2166AC",
                                  midpoint = 0.5, limits = c(0, 1), na.value = "grey85",
                                  name = "Pr(row > column)") +
    ggplot2::coord_fixed() +
    ggplot2::labs(
      x = NULL, y = NULL,
      title = expression(Pr(lambda[i] > lambda[j] ~ "|" ~ y)),
      subtitle = if (is_block) {
        "Items ordered by posterior mean strength; same-block pairs are ties"
      } else "Items ordered by posterior mean strength"
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
                   panel.grid = ggplot2::element_blank())
  if (isTRUE(show_values)) {
    p <- p + ggplot2::geom_text(
      data = plot_data[!is.na(plot_data$probability), ],
      ggplot2::aes(label = sprintf("%.2f", .data$probability)), size = 2.4
    )
  }
  p
}

# ---------------------------------------------------------------------------
# Renamed user-facing helpers
# ---------------------------------------------------------------------------

#' Posterior distribution of the number of blocks K
#'
#' Tabulates \eqn{\Pr(K = k \mid y)}, where \eqn{K} is the number of occupied
#' item blocks, from the saved draws of a block model.
#'
#' @param fit A block-model `btsbm_fit`.
#' @param format `"data.frame"` (default) returns a data frame with one row per
#'   value of K. `"html"`, `"latex"` or `"markdown"` return a formatted
#'   [knitr::kable()] table with one column per value of K.
#' @param digits Rounding used for formatted tables.
#' @param p_min Values of K with posterior probability at most `p_min` are
#'   dropped.
#' @return A data frame (columns `K`, `draws`, `probability`) or a kable.
#' @export
posterior_K_table <- function(fit, format = c("data.frame", "html", "latex", "markdown"),
                              digits = 3, p_min = 0) {
  .require_item_partition(fit)
  format <- match.arg(format)
  counts <- fit$draws$n_item_clusters
  if (is.null(counts)) counts <- apply(fit$draws$item_cluster, 1L, function(z) length(unique(z)))
  tab <- table(counts)
  out <- data.frame(K = as.integer(names(tab)), draws = as.vector(tab),
                    probability = as.vector(tab) / sum(tab))
  out <- out[out$probability > p_min, , drop = FALSE]
  rownames(out) <- NULL
  if (format == "data.frame") return(out)
  wide <- as.data.frame(t(out$probability))
  colnames(wide) <- paste0("K = ", out$K)
  wide <- cbind(" " = "Pr(K = k | y)", wide)
  kable_format <- if (format == "markdown") "pipe" else format
  tab_out <- knitr::kable(wide, digits = digits, format = kable_format)
  if (format != "markdown" && requireNamespace("kableExtra", quietly = TRUE)) {
    tab_out <- kableExtra::kable_styling(tab_out, full_width = FALSE,
                                         latex_options = "hold_position")
  }
  tab_out
}

#' Plot the observed outcomes ordered by the estimated blocks
#'
#' Heatmap of observed win proportions \eqn{y_{ij}/n_{ij}}, with rows and
#' columns ordered by the point estimate of the item partition and block
#' boundaries drawn. This is the new name of [plot_block_adjacency()].
#'
#' @param fit A BT--SBM `btsbm_fit`.
#' @param z_hat Optional partition used for the ordering; defaults to
#'   [partition_point_estimate()].
#' @param ... Further arguments passed to [plot_block_adjacency()].
#' @return A ggplot object.
#' @export
plot_ordered_adjacency <- function(fit, z_hat = NULL, ...) {
  .require_item_partition(fit)
  if (is.null(z_hat)) z_hat <- partition_point_estimate(fit)
  plot_block_adjacency(fit, x_hat = as.integer(z_hat), ...)
}

#' How stable is each estimated block?
#'
#' Co-clustering probabilities below one inside an estimated block can look
#' puzzling in [plot_posterior_similarity()]: if two players are not always
#' together, where does the rest of the probability go? This function answers
#' that question. For every block of the point estimate \eqn{\hat z} it reports
#' the posterior probability that, in a draw,
#' \describe{
#'   \item{`together`}{all its items share one block and no outside item joins
#'     them (the block is reproduced exactly);}
#'   \item{`split`}{its items are spread over two or more blocks;}
#'   \item{`merged`}{at least one of its items shares a block with an item
#'     from a different estimated block.}
#' }
#' `split` and `merged` can both happen in the same draw, so the three columns
#' need not add to one. A pairwise co-clustering below one with a `merged`
#' probability near zero means the missing mass goes to splitting the block
#' into finer sub-blocks, not to other blocks.
#'
#' @param fit A block-model `btsbm_fit`.
#' @param z_hat Optional point estimate; defaults to [partition_point_estimate()].
#' @return A data frame with one row per estimated block.
#' @export
block_stability <- function(fit, z_hat = NULL) {
  .require_item_partition(fit)
  if (is.null(z_hat)) z_hat <- partition_point_estimate(fit)
  z_hat <- as.integer(z_hat)
  draws <- fit$draws$item_cluster
  blocks <- sort(unique(z_hat))
  do.call(rbind, lapply(blocks, function(k) {
    members <- which(z_hat == k)
    others <- which(z_hat != k)
    split <- apply(draws[, members, drop = FALSE], 1L, function(r) length(unique(r)) > 1L)
    merged <- if (length(others)) {
      vapply(seq_len(nrow(draws)), function(s) any(draws[s, others] %in% draws[s, members]), logical(1))
    } else rep(FALSE, nrow(draws))
    data.frame(block = k, size = length(members),
               together = mean(!split & !merged), split = mean(split), merged = mean(merged),
               members = paste(fit$data$item_labels[members], collapse = ", "),
               stringsAsFactors = FALSE)
  }))
}
