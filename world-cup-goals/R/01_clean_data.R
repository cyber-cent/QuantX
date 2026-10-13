# 01_clean_data.R
# FIFA World Cup Over 1.5 Goals quantitative research

library(tidyverse)

input_file <- "data/matches_1930_2022.csv"
output_file <- "data/matches_clean_with_over15.csv"

if (!file.exists(input_file)) {
  stop("Missing data/matches_1930_2022.csv. Add the source dataset before running the analysis.")
}

df <- read_csv(input_file, show_col_types = FALSE) %>%
  mutate(
    total_goals = home_score + away_score,
    over15 = if_else(total_goals >= 2, 1L, 0L)
  )

write_csv(df, output_file)

cat("Clean dataset written to:", output_file, "\n")
cat("Matches:", nrow(df), "\n")
