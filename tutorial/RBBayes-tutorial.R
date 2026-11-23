# RBBayes practicals: BT, BT-SBM and PL
# Setup and downloads: https://lapo-santi.github.io/RBBayes/tutorial.html
# Open RBBayes-tutorial.Rproj, install packages, then run sections in order.
# To display all output when sourcing: source('RBBayes-tutorial.R', echo = TRUE)

# ---- packages ----
library(RBBayes)
library(dplyr)
library(tidyr)
library(ggplot2)
has_coda <- requireNamespace("coda", quietly = TRUE)
has_bayesplot <- requireNamespace("bayesplot", quietly = TRUE)
packageVersion("RBBayes")

# ---- simulate ----
lambda <- exp(seq(log(12), 0, length.out = 20)) # One strength per player.
edges <- simulate_data(
  model = "bt", latent_strength = lambda,
  item_labels = paste("Player", seq_along(lambda)),
  matches_per_pair = 20, seed = 101, format = "edgelist"
)
edges |> slice_head(n = 6) |> knitr::kable()

# ---- as-bt-data ----
tennis <- as_bt_data(edges, format = "edgelist")
tennis

# ---- eda-table ----
player_table <- pairwise_summary(tennis) |> # One row per player.
  as_tibble() |>
  arrange(desc(win_rate))                   # Order by observed win rate.
player_table |> slice_head(n = 6) |> knitr::kable(digits = 3)

# ---- eda-winrate ----
ggplot(player_table, aes(x = win_rate, y = reorder(item, win_rate))) +
  geom_point(colour = "#0072B2", size = 2) +
  geom_vline(xintercept = 0.5, linetype = "dashed", colour = "grey50") +
  labs(x = "Overall win rate", y = NULL,
       title = "Overall win rate of each player") +
  theme_minimal()

# ---- eda-matrix ----
plot_pairwise_outcomes(tennis, reorder = FALSE)

# ---- eda-matrix-ordered ----
plot_pairwise_outcomes(tennis, reorder = TRUE)

# ---- fit-bt ----
bt_fit <- fit_model(
  tennis,
  bt_model(shape_lambda = 2),
  mcmc_control(iter = 4000, warmup = 2000, seed = 12)
)
bt_fit
summary(bt_fit)

# ---- bt-strength ----
bt_strength <- strength_summary(bt_fit)
plot_strength_summary(bt_fit)

# ---- exercise-bt-information ----
local({
  less_data <- simulate_data("bt", latent_strength = lambda,
    item_labels = paste("Player", seq_along(lambda)), matches_per_pair = 5, seed = 101)
  less_fit <- fit_model(less_data, bt_fit$model, bt_fit$control) # Same prior and MCMC.
  list(original = bt_fit, fewer_matches = less_fit) |>
    lapply(function(f) summarise(strength_summary(f),
      mean_width = mean(upper - lower))) |> # Average interval width over players.
    bind_rows(.id = "data") |> knitr::kable(digits = 3)
})

# ---- bt-ranks ----
plot_rank_intervals(bt_fit)

# ---- bt-prob-stronger ----
plot_prob_stronger(bt_fit)

# ---- bt-coda ----
if (has_coda) {
  top_players <- strength_summary(bt_fit) |>
    slice_head(n = 4) |>                       # Four largest posterior means.
    transmute(parameter = paste0("rel_strength[", item, "]")) |>
    pull(parameter)                            # Names used by coda/bayesplot.
  chain <- coda::as.mcmc(bt_fit)
  round(coda::effectiveSize(chain)[top_players])
}

# ---- bt-two-chains ----
if (has_coda) {
  bt_fit2 <- fit_model(tennis, bt_fit$model,
                       mcmc_control(iter = 4000, warmup = 2000, seed = 112))
  chains <- as_mcmc_chains(list(bt_fit, bt_fit2))
  coda::gelman.diag(chains[, top_players], autoburnin = FALSE, multivariate = FALSE)
}

# ---- simulate-sbm ----
edges_sbm <- simulate_data(
  model = "bt-sbm",
  n_blocks = 4, latent_strength = c(12, 6, 2, 1), # One strength per block.
  players_per_block = 5, # Unequal sizes are also allowed: c(3, 4, 5, 8).
  matches_per_pair = 20, seed = 101, format = "edgelist"
)
tennis_sbm <- as_bt_data(edges_sbm, format = "edgelist")
truth <- attr(edges_sbm, "truth")
edges_sbm |> slice_head(n = 6) |> knitr::kable()

# ---- prior-K ----
priors <- list(
  Gnedin = gnedin_prior(gnedin_hyper = 0.5),
  DP = dirichlet_process_prior(concentration = 1),
  PitmanYor = pitman_yor_prior(concentration = 1, discount = 0.2),
  DirMult_max4 = dirichlet_multinomial_prior(max_clusters = 4, concentration = 1)
)
tibble(
  prior = names(priors),
  mean_K = vapply(priors, function(p) prior_mean_K(20, p), numeric(1)),
  sd_K = sqrt(vapply(priors, function(p) prior_variance_K(20, p), numeric(1)))
) |> knitr::kable(digits = 2) # NA: variance not implemented for PY/DM.

# ---- exercise-prior ----
local({
  tibble(gamma = c(0.2, 0.5, 0.8), alpha = c(0.5, 1, 3)) |>
    rowwise() |>                            # Evaluate each parameter setting.
    mutate(
      Gnedin_mean_K = prior_mean_K(20, gnedin_prior(gnedin_hyper = gamma)),
      DP_mean_K = prior_mean_K(20, dirichlet_process_prior(concentration = alpha))) |>
    ungroup() |> knitr::kable(digits = 2)     # Two independent sensitivity checks.
})

# ---- fit-sbm ----
sbm_model <- bt_sbm_model(
  shape_lambda = 2,
  item_clustering = gnedin_prior(gnedin_hyper = 0.5)
)
sbm_model
sbm_fit <- fit_model(tennis_sbm, sbm_model,
                     mcmc_control(iter = 10000, warmup = 5000, seed = 2))
summary(sbm_fit)

# ---- K-table ----
posterior_K_table(sbm_fit)

# ---- K-trace ----
plot_mcmc_traces(sbm_fit)

# ---- exercise-sbm-information ----
local({
  less_data <- simulate_data("bt-sbm", latent_strength = c(12, 6, 2, 1),
    players_per_block = 5, matches_per_pair = 5, seed = 101) # Fewer comparisons.
  refit <- fit_model(less_data, sbm_model, sbm_fit$control)   # Same fitting prior.
  posterior_K_table(refit) |> knitr::kable(digits = 3)
})

# ---- z-hat ----
set.seed(100)                               # Reproduce the partition search.
z_hat <- partition_point_estimate(sbm_fit)
tibble(item = names(z_hat), estimated_block = unname(z_hat)) |>
  left_join(truth, by = "item") |>            # Match players by name.
  count(estimated_block, true_block) |>       # Count the overlap of blocks.
  pivot_wider(names_from = true_block, values_from = n, values_fill = 0) |>
  knitr::kable()                             # Display a cross-tabulation.

# ---- ordered-adjacency ----
plot_ordered_adjacency(sbm_fit, z_hat = z_hat, clean_fun = NULL)

# ---- assign-K4 ----
plot_assignment_probabilities(sbm_fit, k_show = 4, clean_fun = NULL)
true_tier <- truth$true_block[match(tennis_sbm$item_labels, truth$item)] # Align items.
true_pairs <- outer(true_tier, true_tier, `==`) # Label-invariant truth.
recovers_truth <- apply(sbm_fit$draws$item_cluster, 1, function(z) {
  all(outer(z, z, `==`) == true_pairs)          # Compare co-memberships.
})
recovery_given_K4 <- mean(recovers_truth[sbm_fit$draws$n_item_clusters == 4])

# ---- assign-K5 ----
plot_assignment_probabilities(sbm_fit, k_show = 5, clean_fun = NULL)

# ---- psm ----
set.seed(100)                               # Reproduce the plotted outlines.
plot_posterior_similarity(sbm_fit)
similarity <- posterior_similarity(sbm_fit)
within_estimate <- outer(z_hat, z_hat, `==`) # Pairs in the same estimated block.
within_similarity <- range(similarity[within_estimate & row(similarity) != col(similarity)])
outside_similarity <- range(similarity[!within_estimate]) # Between-block pairs.

# ---- block-stability ----
sbm_stability <- block_stability(sbm_fit, z_hat)
sbm_stability |>
  select(block, size, together, split, merged) |> # Retain interpretable summaries.
  knitr::kable(digits = 3)

# ---- credible-ball ----
cb <- credible_ball(sbm_fit, z_hat = z_hat, credible_mass = 0.95)
cb
plot_credible_ball(cb)

# ---- exercise-sbm-signal ----
local({
  closer <- simulate_data("bt-sbm", latent_strength = c(12, 9, 2, 1),
    players_per_block = 5, matches_per_pair = 20, seed = 101)
  refit <- fit_model(closer, sbm_model, sbm_fit$control) # Preserve the fitting prior.
  set.seed(100)                              # Reproduce the partition search.
  ball <- credible_ball(refit)
  tibble(data = c("original", "closer"),
    Pr_K4 = c(mean(sbm_fit$draws$n_item_clusters == 4),
              mean(refit$draws$n_item_clusters == 4)),
    VI_radius = c(cb$radius, ball$radius)) |> knitr::kable(digits = 3)
})

# ---- sbm-prob-stronger ----
plot_prob_stronger(sbm_fit) +
  labs(title = expression(Pr(theta[i] > theta[j] ~ "|" ~ y)))

# ---- sbm-ties ----
p_sbm <- prob_stronger(sbm_fit)
round(attr(p_sbm, "prob_equal")[1:5, 1:5], 2)

# ---- sbm-chain2 ----
sbm_fit2 <- fit_model(tennis_sbm, sbm_model,
  mcmc_control(iter = 10000, warmup = 5000, seed = 202))
full_join(                                 # Align the supported values of K.
  posterior_K_table(sbm_fit) |> select(K, chain1 = probability),
  posterior_K_table(sbm_fit2) |> select(K, chain2 = probability), by = "K"
) |> knitr::kable(digits = 3)

# ---- atp-load ----
atp <- ATP_2000_2025[["2017"]]               # Select a season.
players <- atp$players_df
atp_data <- as_bt_data(atp$Y_ij, format = "matrix",
  item_labels = make.unique(players$player_label)) # Give each item a unique name.
atp_edges <- as_tibble(atp_data)             # Standard winner/loser/count table.
atp_data

# ---- atp-eda ----
atp_pairs <- atp_edges |>
  group_by(first = pmin(winner, loser),    # Give each unordered pair one key.
           second = pmax(winner, loser)) |>
  summarise(matches = sum(count), .groups = "drop") # Sum both directions.
atp_overview <- tibble(
  players = atp_data$n_items, matches = sum(atp_edges$count),
  pairs_that_met = sum(atp_pairs$matches > 0), # Exclude unobserved pairs.
  possible_pairs = nrow(atp_pairs)
)
atp_overview |> knitr::kable()

# ---- atp-eda-plots ----
atp_players <- pairwise_summary(atp_data) |> # Reuse the player-level summary.
  as_tibble() |>
  mutate(last_rank = players$last_rank)      # Metadata share the input item order.
ggplot(atp_players, aes(matches)) +
  geom_histogram(binwidth = 2, fill = "#0072B2", colour = "white") +
  labs(x = "Matches against other top-105 players", y = "Players") + theme_minimal()
ggplot(atp_players, aes(last_rank, win_rate)) +
  geom_point(aes(size = matches), alpha = 0.6, colour = "#0072B2") +
  scale_x_log10() +                          # ATP ranks span a wide range.
  labs(x = "Last observed ATP ranking in 2017 (log scale)", y = "Win rate", size = "Matches") +
  theme_minimal()

# ---- atp-fit ----
atp_fit <- fit_model(
  atp_data,
  bt_sbm_model(shape_lambda = 2,
               item_clustering = gnedin_prior(gnedin_hyper = 0.5)),
  mcmc_control(iter = 6000, warmup = 3000, seed = 1)
)
posterior_K_table(atp_fit)

# ---- exercise-atp-prior ----
local({
  alternatives <- list(Gnedin_08 = gnedin_prior(gnedin_hyper = 0.8),
                       DP_1 = dirichlet_process_prior(concentration = 1))
  refits <- lapply(alternatives, function(prior) {
    fit_model(atp_data, bt_sbm_model(shape_lambda = 2, item_clustering = prior),
              atp_fit$control)               # Change only the partition prior.
  })
  c(list(Gnedin_05 = atp_fit), refits) |>
    lapply(function(f) tibble(
      prior_mean_K = prior_mean_K(atp_data$n_items, f$model$item_clustering),
      posterior_mean_K = mean(f$draws$n_item_clusters))) |>
    bind_rows(.id = "prior") |> knitr::kable(digits = 2)
})

# ---- atp-zhat ----
set.seed(200)  # Reproduce the partition search.
atp_z <- partition_point_estimate(atp_fit)
table(atp_z)
names(atp_z)[atp_z == 1]          # the top tier

# ---- atp-adjacency ----
plot_ordered_adjacency(atp_fit, z_hat = atp_z, clean_fun = NULL)

# ---- atp-vs-ranking ----
set.seed(201)                               # Reproduce the horizontal jitter.
atp_players <- atp_players |>
  mutate(block = factor(atp_z[item]))        # Match block labels by item name.
ggplot(atp_players, aes(block, last_rank)) +
  geom_boxplot(outlier.shape = NA, fill = "grey90") +
  geom_jitter(width = 0.15, alpha = 0.6, colour = "#0072B2") +
  scale_y_log10() +
  labs(x = "Estimated block (1 = strongest)", y = "Last observed ATP ranking in 2017 (log)") +
  theme_minimal()

# ---- atp-cb ----
atp_cb <- credible_ball(atp_fit, z_hat = atp_z)
atp_cb
atp_stability <- block_stability(atp_fit, atp_z)
atp_stability |>
  select(block, size, together, split, merged) |> # Compare splitting and merging.
  knitr::kable(digits = 3)

# ---- atp-assign ----
plot_assignment_probabilities(atp_fit, clean_fun = NULL)

# ---- atp-prob-stronger ----
p_atp <- prob_stronger(atp_fit)
atp_equal <- attr(p_atp, "prob_equal")       # Keep ties separate from strict ordering.
federer <- grep("Federer", rownames(p_atp), value = TRUE) # Locate named players.
nadal <- grep("Nadal", rownames(p_atp), value = TRUE)
plot_prob_stronger(atp_fit, max_items = 15) +
  labs(title = expression(Pr(theta[i] > theta[j] ~ "|" ~ y)))

# ---- exercise-atp-season ----
local({
  season <- ATP_2000_2025[["2023"]]           # Change the year here.
  data <- as_bt_data(season$Y_ij, format = "matrix",
    item_labels = make.unique(season$players_df$player_label))
  refit <- fit_model(data, atp_fit$model, atp_fit$control) # Same prior and MCMC.
  bind_rows(`2017` = posterior_K_table(atp_fit),
            `2023` = posterior_K_table(refit), .id = "season") |>
    ggplot(aes(K, probability, fill = season)) + # Compare complete distributions.
    geom_col(position = "dodge") +
    scale_x_continuous(breaks = 3:17) +
    labs(y = "Posterior probability", fill = "Season") + theme_minimal()
})

# ---- pl-data ----
sushi <- sushi_toy(n_rankings = 40, rank_length = 5, seed = 3)
positions <- as_tibble(sushi)                 # One reported item-position per row.
positions |> slice_head(n = 5) |> knitr::kable() # The first respondent's top five.

# ---- pl-positions ----
plot_ranking_positions(sushi)

# ---- pl-profile-counts ----
set_A <- c("egg", "shrimp", "cucumber_roll", "inari") # Fixed teaching contrast.
profile_counts <- positions |>
  group_by(ranking) |>                       # Keep each respondent's choices together.
  summarise(in_A = sum(item %in% set_A), .groups = "drop")
ggplot(profile_counts, aes(in_A)) +
  geom_bar(fill = "#0072B2") +
  scale_x_continuous(breaks = 0:4, limits = c(-0.5, 4.5)) +
  labs(x = "Set A items in the top five", y = "Rankings") + theme_minimal()

# ---- pl-fit ----
pl_fit <- fit_model(sushi, pl_model(shape_lambda = 2), # Gamma shape, as for BT.
  mcmc_control(iter = 2000, warmup = 1000, seed = 4))
summary(pl_fit)

# ---- pl-strength ----
plot_strength_summary(pl_fit)

# ---- pl-prob-stronger ----
plot_prob_stronger(pl_fit)

# ---- pl-predictive ----
set.seed(400)
weights <- posterior_strength(pl_fit, summary = "draws") # One vector per MCMC draw.
set_ids <- match(set_A, sushi$item_labels)               # Translate names to item ids.
replicated_counts <- replicate(300, {
  q <- weights[sample.int(nrow(weights), 1), ]            # Include posterior uncertainty.
  replicate(sushi$n_rankings, {
    top_five <- sample.int(sushi$n_items, sushi$rank_length, prob = q)
    sum(top_five %in% set_ids)                           # Same count as in the data.
  })
})
replicated_variance <- apply(replicated_counts, 2, var)   # One statistic per dataset.
observed_variance <- var(profile_counts$in_A)

# ---- pl-predictive-plot ----
tibble(variance = replicated_variance) |>     # A dataset-level reference distribution.
  ggplot(aes(variance)) +
  geom_histogram(bins = 25, fill = "#0072B2", colour = "white") +
  geom_vline(xintercept = observed_variance, colour = "#b35806", linewidth = 1) +
  labs(x = "Variance of set A counts", y = "Replicated datasets",
       subtitle = "Orange line: observed variance; bars: single-PL replications") +
  theme_minimal()

# ---- run-settings ----
fits <- list(BT = bt_fit, BT_SBM_1 = sbm_fit, BT_SBM_2 = sbm_fit2,
             ATP_BT_SBM = atp_fit, PL = pl_fit)
if (has_coda) fits <- append(fits, list(BT_2 = bt_fit2), after = 1)
run_settings <- bind_rows(lapply(names(fits), function(name) { # One row per main fit.
  fit <- fits[[name]]
  tibble(model = name, iterations = fit$control$iter, burn_in = fit$control$warmup,
         retained = nrow(as.matrix(fit)), seed = fit$control$seed)
}))
knitr::kable(run_settings)

# ---- bt-bayesplot ----
if (has_bayesplot) {
  top_players <- strength_summary(bt_fit) |>
    slice_head(n = 4) |>                       # Select the same four player parameters.
    transmute(parameter = paste0("rel_strength[", item, "]")) |>
    pull(parameter)
  print(bayesplot::mcmc_trace(bt_fit, pars = top_players[1:2]))
  print(bayesplot::mcmc_intervals(bt_fit, pars = top_players, prob = 0.5, prob_outer = 0.95))
}

# ---- session ----
sessionInfo()

