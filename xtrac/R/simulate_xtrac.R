# Aliu-XtraC illustrative simulation
# Base R only. This is a transparent toy model, not a reproduction of the
# source paper's reported $91.43bn result. It uses synthetic returns.

make_synthetic_returns <- function(n_days = 252L, seed = 20261013L) {
  stopifnot(n_days >= 1L)
  set.seed(seed)
  day <- seq_len(n_days)
  mu <- rep(0.0002, n_days)
  sigma <- rep(0.004, n_days)
  mu[day >= 61 & day <= 160] <- -0.0018
  sigma[day >= 61 & day <= 160] <- 0.006
  mu[day >= 161 & day <= 178] <- -0.012
  sigma[day >= 161 & day <= 178] <- 0.009
  mu[day >= 179 & day <= 215] <- 0.006
  sigma[day >= 179 & day <= 215] <- 0.012
  mu[day >= 216] <- 0.0004
  sigma[day >= 216] <- 0.005
  rnorm(n_days, mean = mu, sd = sigma)
}

expectancy_gate <- function(p_win, reward_to_risk, alpha = 1.5) {
  stopifnot(p_win >= 0, p_win <= 1, reward_to_risk >= 0, alpha >= 0)
  expectancy <- (p_win * reward_to_risk) - (1 - p_win)
  list(expectancy = expectancy, passes = expectancy >= alpha)
}

run_xtrac_simulation <- function(
  initial_aum = 100e9,
  buffer_fraction = 0.01,
  max_drawdown = 0.10,
  p_win = 0.70,
  reward_to_risk = 3.0,
  alpha = 1.5,
  n_days = 252L,
  seed = 20261013L
) {
  stopifnot(initial_aum > 0, buffer_fraction > 0, buffer_fraction < 1,
            max_drawdown > 0, max_drawdown < 1, n_days >= 2L)
  returns <- make_synthetic_returns(n_days = n_days, seed = seed)
  gate <- expectancy_gate(p_win, reward_to_risk, alpha)
  baseline_value <- initial_aum
  baseline_peak <- initial_aum
  baseline_frozen <- FALSE
  # Simplifying assumption: core + buffer sum to initial AUM. This is not
  # identical to the paper's Vcore = AUM0 * (1 - MDDlimit - XtraClimit)
  # formula; see xtrac/README.md for the unresolved 10% allocation ambiguity.
  core_value <- initial_aum * (1 - buffer_fraction)
  core_peak <- core_value
  core_frozen <- FALSE
  buffer_value <- initial_aum * buffer_fraction
  activation_day <- NA_integer_
  rows <- vector("list", n_days)

  for (i in seq_len(n_days)) {
    r <- returns[i]
    if (!baseline_frozen) {
      baseline_value <- baseline_value * (1 + r)
      baseline_peak <- max(baseline_peak, baseline_value)
      if (baseline_value <= baseline_peak * (1 - max_drawdown)) baseline_frozen <- TRUE
    }
    if (!core_frozen) {
      core_value <- core_value * (1 + r)
      core_peak <- max(core_peak, core_value)
      if (core_value <= core_peak * (1 - max_drawdown)) {
        core_frozen <- TRUE
        activation_day <- i
      }
    } else if (gate$passes) {
      # Buffer equity cannot fall below zero, so its maximum loss is its allocation.
      buffer_value <- max(0, buffer_value * (1 + r))
    }
    rows[[i]] <- data.frame(
      day = i, synthetic_return = r, baseline_value = baseline_value,
      baseline_frozen = baseline_frozen, core_value = core_value,
      core_frozen = core_frozen, buffer_value = buffer_value,
      total_xtrac_value = core_value + buffer_value,
      gate_expectancy = gate$expectancy, gate_passes = gate$passes
    )
  }
  daily <- do.call(rbind, rows)
  summary <- data.frame(
    model = c("Traditional hard-stop baseline", "Aliu-XtraC illustrative"),
    initial_aum = c(initial_aum, initial_aum),
    terminal_value = c(daily$baseline_value[n_days], daily$total_xtrac_value[n_days]),
    return_pct = 100 * (c(daily$baseline_value[n_days], daily$total_xtrac_value[n_days]) / initial_aum - 1),
    activation_day = c(NA_integer_, activation_day),
    expectancy_gate = c(NA_real_, gate$expectancy),
    gate_passes = c(NA, gate$passes)
  )
  list(daily = daily, summary = summary, gate = gate,
       parameters = list(initial_aum = initial_aum, buffer_fraction = buffer_fraction,
                         max_drawdown = max_drawdown, p_win = p_win,
                         reward_to_risk = reward_to_risk, alpha = alpha,
                         n_days = n_days, seed = seed))
}

if (sys.nframe() == 0L) {
  result <- run_xtrac_simulation()
  dir.create("output", showWarnings = FALSE, recursive = TRUE)
  write.csv(result$daily, "output/xtrac_daily_path.csv", row.names = FALSE)
  write.csv(result$summary, "output/xtrac_summary.csv", row.names = FALSE)
  print(result$gate)
  print(result$summary)
  cat("\nNOTE: Synthetic illustration only; this does not reproduce or validate the source paper's reported result.\n")
}
