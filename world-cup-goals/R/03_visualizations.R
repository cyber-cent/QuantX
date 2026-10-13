# 03_visualizations.R

library(tidyverse)
library(scales)

if (!file.exists("results/tournament_analysis.csv")) {
  stop("Run R/02_descriptive_analysis.R first.")
}

tournament <- read_csv("results/tournament_analysis.csv", show_col_types = FALSE)
era <- read_csv("results/era_analysis.csv", show_col_types = FALSE)
df <- read_csv("data/matches_clean_with_over15.csv", show_col_types = FALSE)

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

p1 <- ggplot(tournament, aes(x = factor(Year), y = over15_rate)) +
  geom_col() +
  scale_y_continuous(labels = percent, limits = c(0, 1)) +
  labs(title = "Over 1.5 Goals Rate by FIFA World Cup", x = "Year", y = "Over 1.5 Rate") +
  theme_minimal()
ggsave("figures/over15_by_tournament.png", p1, width = 10, height = 6, dpi = 300)

p2 <- ggplot(tournament, aes(x = factor(Year), y = avg_goals)) +
  geom_col() +
  labs(title = "Average Goals per Match by FIFA World Cup", x = "Year", y = "Average Goals") +
  theme_minimal()
ggsave("figures/goals_by_tournament.png", p2, width = 10, height = 6, dpi = 300)

p3 <- ggplot(era, aes(x = era, y = over15_rate)) +
  geom_col() +
  scale_y_continuous(labels = percent, limits = c(0, 1)) +
  labs(title = "Over 1.5 Goals Rate by Era", x = "Era", y = "Over 1.5 Rate") +
  theme_minimal()
ggsave("figures/era_comparison.png", p3, width = 9, height = 6, dpi = 300)

p4 <- ggplot(df, aes(x = total_goals)) +
  geom_histogram(binwidth = 1, boundary = -0.5) +
  labs(title = "Distribution of Total Goals", x = "Total Goals", y = "Matches") +
  theme_minimal()
ggsave("figures/goal_distribution.png", p4, width = 9, height = 6, dpi = 300)
