# 02_descriptive_analysis.R

library(tidyverse)

input_file <- "data/matches_clean_with_over15.csv"
if (!file.exists(input_file)) {
  stop("Run R/01_clean_data.R first.")
}

dir.create("results", showWarnings = FALSE, recursive = TRUE)
df <- read_csv(input_file, show_col_types = FALSE)

overall <- df %>%
  summarise(
    matches = n(),
    over15 = sum(over15, na.rm = TRUE),
    under15 = sum(over15 == 0, na.rm = TRUE),
    rate = mean(over15, na.rm = TRUE),
    avg_goals = mean(total_goals, na.rm = TRUE)
  )

write_csv(overall, "results/overall_summary.csv")

tournament <- df %>%
  group_by(Year) %>%
  summarise(
    matches = n(),
    over15 = sum(over15, na.rm = TRUE),
    under15 = sum(over15 == 0, na.rm = TRUE),
    over15_rate = mean(over15, na.rm = TRUE),
    avg_goals = mean(total_goals, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(tournament, "results/tournament_analysis.csv")

df <- df %>%
  mutate(
    era = case_when(
      Year >= 1930 & Year <= 1958 ~ "1930–1958",
      Year >= 1962 & Year <= 1986 ~ "1962–1986",
      Year >= 1990 & Year <= 2010 ~ "1990–2010",
      Year >= 2014 & Year <= 2022 ~ "2014–2022",
      TRUE ~ NA_character_
    )
  )

era <- df %>%
  filter(!is.na(era)) %>%
  group_by(era) %>%
  summarise(
    matches = n(),
    over15 = sum(over15, na.rm = TRUE),
    under15 = sum(over15 == 0, na.rm = TRUE),
    over15_rate = mean(over15, na.rm = TRUE),
    avg_goals = mean(total_goals, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(era, "results/era_analysis.csv")

print(overall)
print(tournament)
print(era)
