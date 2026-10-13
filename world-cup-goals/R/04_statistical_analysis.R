# 04_statistical_analysis.R

library(tidyverse)

if (!file.exists("data/matches_clean_with_over15.csv")) {
  stop("Run R/01_clean_data.R first.")
}

dir.create("results", showWarnings = FALSE, recursive = TRUE)
df <- read_csv("data/matches_clean_with_over15.csv", show_col_types = FALSE)

n <- nrow(df)
x <- sum(df$over15, na.rm = TRUE)
p <- x / n
se <- sqrt(p * (1 - p) / n)

ci_lower <- p - 1.96 * se
ci_upper <- p + 1.96 * se
test <- prop.test(x, n, p = 0.50, alternative = "greater", correct = FALSE)

results <- tibble(
  matches = n,
  over15 = x,
  under15 = n - x,
  over15_rate = p,
  standard_error = se,
  ci_lower = ci_lower,
  ci_upper = ci_upper,
  benchmark = 0.50,
  p_value_vs_50pct = test$p.value
)

write_csv(results, "results/statistical_results.csv")
print(results)

cat("\nHistorical reciprocal rate benchmark:", round(1 / p, 4), "\n")
cat("Important: historical frequency is not a guaranteed future probability or proof of positive expected value.\n")
