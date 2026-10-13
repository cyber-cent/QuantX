# Run from the repository root:
# Rscript xtrac/tests/test_sensitivity.R

source("xtrac/R/sensitivity_analysis.R")

small <- run_xtrac_sensitivity(
  buffer_fractions = c(0.01, 0.02),
  max_drawdowns = c(0.05, 0.10),
  seeds = 1:3,
  n_days = 30L
)

stopifnot(nrow(small) == 12L)
stopifnot(all(small$buffer_fraction %in% c(0.01, 0.02)))
stopifnot(all(small$max_drawdown %in% c(0.05, 0.10)))
stopifnot(all(small$difference_pct_of_initial_aum ==
                100 * small$difference_vs_baseline / 100e9))
stopifnot(all(is.finite(small$baseline_terminal_value)))
stopifnot(all(is.finite(small$xtrac_terminal_value)))

# Same seed and same parameters must produce the same terminal outputs.
a <- run_xtrac_sensitivity(buffer_fractions = 0.01,
                           max_drawdowns = 0.10, seeds = 123, n_days = 30L)
b <- run_xtrac_sensitivity(buffer_fractions = 0.01,
                           max_drawdowns = 0.10, seeds = 123, n_days = 30L)
stopifnot(identical(a, b))

cat("All Aliu-XtraC sensitivity tests passed.\n")
