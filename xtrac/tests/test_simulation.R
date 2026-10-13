# Run from the repository root:
# Rscript xtrac/tests/test_simulation.R

source("xtrac/R/simulate_xtrac.R")

gate <- expectancy_gate(p_win = 0.70, reward_to_risk = 3, alpha = 1.5)
stopifnot(isTRUE(gate$passes))
stopifnot(abs(gate$expectancy - 1.8) < 1e-10)

result <- run_xtrac_simulation(seed = 20261013L)
stopifnot(nrow(result$daily) == 252L)
stopifnot(all(result$daily$buffer_value >= 0))
stopifnot(all(result$daily$core_value >= 0))
stopifnot(all(result$daily$total_xtrac_value >= 0))
stopifnot(result$parameters$initial_aum == 100e9)
stopifnot(result$summary$initial_aum[2] == 100e9)

no_gate <- run_xtrac_simulation(p_win = 0.20, reward_to_risk = 1,
                                alpha = 1.5, seed = 20261013L)
stopifnot(!no_gate$gate$passes)
stopifnot(length(unique(no_gate$daily$buffer_value)) == 1L)

cat("All Aliu-XtraC simulation tests passed.\n")
