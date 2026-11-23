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
# Each edge contributes wins to its winner and losses to its loser.
player_table <- bind_rows(
  edges |> transmute(player = winner, matches = count, wins = count),
  edges |> transmute(player = loser, matches = count, wins = 0)
) |>
  group_by(player) |>
  summarise(across(c(matches, wins), sum), .groups = "drop") |>
  mutate(win_rate = wins / matches) |>
  arrange(desc(win_rate))

player_table |> slice_head(n = 6) |> knitr::kable(digits = 3)

# ---- eda-winrate ----
ggplot(player_table, aes(x = win_rate, y = reorder(player, win_rate))) +
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

# ---- bt-ranks ----
plot_rank_intervals(bt_fit)

# ---- bt-prob-stronger ----
plot_prob_stronger(bt_fit)

# ---- bt-coda ----
if (has_coda) {
  top_players <- strength_summary(bt_fit) |>
    slice_head(n = 4) |>
    transmute(parameter = paste0("rel_strength[", item, "]")) |>
    pull(parameter)
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

# ---- z-hat ----
set.seed(100)
z_hat <- partition_point_estimate(sbm_fit)
tibble(item = names(z_hat), estimated_block = unname(z_hat)) |>
  left_join(truth, by = "item") |>
  count(estimated_block, true_block) |>
  pivot_wider(names_from = true_block, values_from = n, values_fill = 0) |>
  knitr::kable()

# ---- ordered-adjacency ----
plot_ordered_adjacency(sbm_fit, z_hat = z_hat, clean_fun = NULL)

# ---- assign-K4 ----
plot_assignment_probabilities(sbm_fit, k_show = 4, clean_fun = NULL)
# Check recovery without depending on the arbitrary numerical block labels.
true_tier <- truth$true_block[match(tennis_sbm$item_labels, truth$item)]
true_pairs <- outer(true_tier, true_tier, `==`)
recovers_truth <- apply(sbm_fit$draws$item_cluster, 1, function(z) {
  all(outer(z, z, `==`) == true_pairs)
})
recovery_given_K4 <- mean(recovers_truth[sbm_fit$draws$n_item_clusters == 4])

# ---- assign-K5 ----
plot_assignment_probabilities(sbm_fit, k_show = 5, clean_fun = NULL)

# ---- psm ----
set.seed(100)  # Use the same partition search as in z-hat for the outlines.
plot_posterior_similarity(sbm_fit)
similarity <- posterior_similarity(sbm_fit)
within_estimate <- outer(z_hat, z_hat, `==`)
within_similarity <- range(similarity[within_estimate & row(similarity) != col(similarity)])
outside_similarity <- range(similarity[!within_estimate])

# ---- block-stability ----
sbm_stability <- block_stability(sbm_fit, z_hat)
sbm_stability[, c("block", "size", "together", "split", "merged")]

# ---- credible-ball ----
cb <- credible_ball(sbm_fit, z_hat = z_hat, credible_mass = 0.95)
cb
plot_credible_ball(cb)

# ---- sbm-prob-stronger ----
plot_prob_stronger(sbm_fit) +
  labs(title = expression(Pr(theta[i] > theta[j] ~ "|" ~ y)))

# ---- sbm-ties ----
p_sbm <- prob_stronger(sbm_fit)
round(attr(p_sbm, "prob_equal")[1:5, 1:5], 2)

# ---- sbm-chain2 ----
sbm_fit2 <- fit_model(tennis_sbm, sbm_model,
  mcmc_control(iter = 10000, warmup = 5000, seed = 202))
full_join(
  posterior_K_table(sbm_fit) |> select(K, chain1 = probability),
  posterior_K_table(sbm_fit2) |> select(K, chain2 = probability), by = "K"
) |> knitr::kable(digits = 3)

# ---- atp-load ----
atp <- ATP_2000_2025[["2017"]]
players <- atp$players_df
atp_data <- as_bt_data(atp$Y_ij, format = "matrix",
                       item_labels = make.unique(players$player_label))
atp_edges <- as_tibble(atp_data$wins, rownames = "winner") |>
  pivot_longer(-winner, names_to = "loser", values_to = "count") |>
  filter(winner != loser)
atp_data

# ---- atp-eda ----
atp_pairs <- atp_edges |>
  group_by(first = pmin(winner, loser), second = pmax(winner, loser)) |>
  summarise(matches = sum(count), .groups = "drop")
atp_overview <- tibble(
  players = atp_data$n_items, matches = sum(atp_edges$count),
  pairs_that_met = sum(atp_pairs$matches > 0),
  possible_pairs = nrow(atp_pairs)
)
atp_overview |> knitr::kable()

# ---- atp-eda-plots ----
atp_players <- bind_rows(
  atp_edges |> transmute(player = winner, matches = count, wins = count),
  atp_edges |> transmute(player = loser, matches = count, wins = 0)
) |>
  group_by(player) |>
  summarise(across(c(matches, wins), sum), .groups = "drop") |>
  mutate(win_rate = wins / matches) |>
  left_join(tibble(player = atp_data$item_labels, last_rank = players$last_rank), by = "player")
ggplot(atp_players, aes(matches)) +
  geom_histogram(binwidth = 2, fill = "#0072B2", colour = "white") +
  labs(x = "Matches against other top-105 players", y = "Players") + theme_minimal()
ggplot(atp_players, aes(last_rank, win_rate)) +
  geom_point(aes(size = matches), alpha = 0.6, colour = "#0072B2") +
  scale_x_log10() +
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

# ---- atp-zhat ----
set.seed(200)  # Reproduce the partition search.
atp_z <- partition_point_estimate(atp_fit)
table(atp_z)
names(atp_z)[atp_z == 1]          # the top tier

# ---- atp-adjacency ----
plot_ordered_adjacency(atp_fit, z_hat = atp_z, clean_fun = NULL)

# ---- atp-vs-ranking ----
set.seed(201) # Reproduce the horizontal jitter.
atp_players <- atp_players |>
  left_join(tibble(player = names(atp_z), block = unname(atp_z)), by = "player") |>
  mutate(block = factor(block))
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
atp_stability[, c("block", "size", "together", "split", "merged")]

# ---- atp-assign ----
plot_assignment_probabilities(atp_fit, clean_fun = NULL)

# ---- atp-prob-stronger ----
p_atp <- prob_stronger(atp_fit)
atp_equal <- attr(p_atp, "prob_equal")
federer <- grep("Federer", rownames(p_atp), value = TRUE)
nadal <- grep("Nadal", rownames(p_atp), value = TRUE)
plot_prob_stronger(atp_fit, max_items = 15) +
  labs(title = expression(Pr(theta[i] > theta[j] ~ "|" ~ y)))

# ---- pl-data ----
sushi <- sushi_toy(n_rankings = 40, rank_length = 5, seed = 3)
sushi
head(sushi$rankings, 3)
plot_ranking_positions(sushi)

# ---- pl-fit ----
pl_fit <- fit_model(sushi, pl_model(shape_lambda = 1),
                    mcmc_control(iter = 2000, warmup = 1000, seed = 4))
summary(pl_fit)

# ---- pl-strength ----
plot_strength_summary(pl_fit)

# ---- pl-prob-stronger ----
plot_prob_stronger(pl_fit)

# ---- run-settings ----
fits <- list(BT = bt_fit, BT_SBM_1 = sbm_fit, BT_SBM_2 = sbm_fit2,
             ATP_BT_SBM = atp_fit, PL = pl_fit)
if (has_coda) fits <- append(fits, list(BT_2 = bt_fit2), after = 1)
run_settings <- bind_rows(lapply(names(fits), function(name) {
  fit <- fits[[name]]
  tibble(model = name, iterations = fit$control$iter, burn_in = fit$control$warmup,
         retained = nrow(as.matrix(fit)), seed = fit$control$seed)
}))
knitr::kable(run_settings)

# ---- bt-bayesplot ----
if (has_bayesplot) {
  top_players <- strength_summary(bt_fit) |>
    slice_head(n = 4) |>
    transmute(parameter = paste0("rel_strength[", item, "]")) |>
    pull(parameter)
  print(bayesplot::mcmc_trace(bt_fit, pars = top_players[1:2]))
  print(bayesplot::mcmc_intervals(bt_fit, pars = top_players, prob = 0.5, prob_outer = 0.95))
}

# ---- session ----
sessionInfo()

