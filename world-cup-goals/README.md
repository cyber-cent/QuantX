# FIFA World Cup Over 1.5 Goals — Quantitative Research in R

**Author:** Busari Aliu Oluwaseyi

## Research question

Does the Over 1.5 Goals outcome demonstrate a historically persistent high-frequency pattern in FIFA World Cup matches?

## Data status

The previous project README reported 964 matches, 704 Over 1.5 outcomes (73.03%), and a simple 95% Wald confidence interval of about 70.23%–75.83%. These figures were reported by the prior project and have not been re-run in this central repository because the underlying CSV was not present in the source repository.

Place the match-level source data at `data/matches_1930_2022.csv`. Required columns include `home_score`, `away_score`, and `Year`. See [data README](data/README.md).

## Run the analysis

From this directory, install dependencies once:

```r
install.packages(c("tidyverse", "scales"))
```

Then run the scripts in order:

```r
source("R/01_clean_data.R")
source("R/02_descriptive_analysis.R")
source("R/03_visualizations.R")
source("R/04_statistical_analysis.R")
```

## Interpretation

Historical frequency is not a guaranteed future probability or proof of betting profitability. A stronger quantitative study should include bookmaker odds, market-implied probabilities, match-specific features, and strict time-based out-of-sample validation.

For decimal odds `O` and a properly estimated match-specific probability `p`, expected value is `EV = p * O - 1`.

## Report

See [the Quarto report](report/world_cup_over15_report.qmd).
