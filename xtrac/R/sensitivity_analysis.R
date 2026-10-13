# Aliu-XtraC sensitivity analysis
# Base R only. Run from the QuantX repository root:
# Rscript xtrac/R/sensitivity_analysis.R
#
# This is a synthetic stress/sensitivity experiment, not a reproduction of the
# source paper's reported results and not investment advice.

source("xtrac/R/simulate_xtrac.R")

run_xtrac_sensitivity <- function(
  buffer_fractions = c(0.005, 0.01, 0.02),
  max_drawdowns = c(0.05, 0.10, 0.15),
  seeds = 1:50,
  initial_aum = 100e9,
  p_win = 0.70,
  reward_to_risk = 3.0,
  alpha = 1.5,
  n_days = 252L
) {
  stopifnot(length(buffer_fractions) > 0L,
            all(buffer_fractions > 0 & buffer_fractions < 1),
            length(max_drawdowns) > 0L,
            all(max_drawdowns > 0 & max_drawdowns < 1),
            length(seeds) > 0L)

  grid <- expand.grid(
    buffer_fraction = buffer_fractions,
    max_drawdown = max_drawdowns,
    seed = seeds,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )

  rows <- lapply(seq_len(nrow(grid)), function(i) {
    scenario <- grid[i, ]
    sim <- run_xtrac_simulation(
      initial_aum = initial_aum,
      buffer_fraction = scenario$buffer_fraction,
      max_drawdown = scenario$max_drawdown,
      p_win = p_win,
      reward_to_risk = reward_to_risk,
      alpha = alpha,
      n_days = n_days,
      seed = as.integer(scenario$seed)
    )
    baseline <- sim$summary$terminal_value[1]
    xtrac <- sim$summary$terminal_value[2]
    data.frame(
      buffer_fraction = scenario$buffer_fraction,
      max_drawdown = scenario$max_drawdown,
      seed = as.integer(scenario$seed),
      gate_expectancy = sim$gate$expectancy,
      gate_passes = sim$gate$passes,
      activation_day = sim$summary$activation_day[2],
      baseline_terminal_value = baseline,
      xtrac_terminal_value = xtrac,
      difference_vs_baseline = xtrac - baseline,
      difference_pct_of_initial_aum = 100 * (xtrac - baseline) / initial_aum
    )
  })

  do.call(rbind, rows)
}

if (sys.nframe() == 0L) {
  sensitivity <- run_xtrac_sensitivity()
  dir.create("output", showWarnings = FALSE, recursive = TRUE)
  write.csv(sensitivity, "output/xtrac_sensitivity.csv", row.names = FALSE)

  aggregate_results <- aggregate(
    cbind(difference_vs_baseline, difference_pct_of_initial_aum) ~
      buffer_fraction + max_drawdown,
    data = sensitivity,
    FUN = mean
  )
  write.csv(aggregate_results, "output/xtrac_sensitivity_summary.csv",
            row.names = FALSE)

  print(aggregate_results)
  cat("\nWrote 450 seeded synthetic scenarios to output/xtrac_sensitivity.csv.\n")
  cat("Synthetic results are diagnostic only; they do not validate the source paper's reported alpha.\n")
}
