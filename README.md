# QuantX — Quantitative Research Lab

**Owner:** Busari Aliu Oluwaseyi  
**Focus:** quantitative finance, empirical research, risk architecture, and reproducible R analysis.

QuantX is the central repository for the author's quantitative research projects. It consolidates the World Cup Over 1.5 Goals research and the Aliu-XtraC risk-framework prototype previously maintained as separate research work. Research findings are distinguished from prototypes, assumptions, and results that have not been independently reproduced.

## Projects

### 1. Aliu-XtraC Framework

A proposed dual-ledger risk architecture that separates a protected core portfolio from a tactical asymmetric buffer, with an expectancy-based activation gate.

- **Research note:** [Aliu-XtraC Framework](research/aliu-xtrac-framework.md)
- **R simulation prototype:** [xtrac/R/simulate_xtrac.R](xtrac/R/simulate_xtrac.R)
- **Sensitivity analysis:** [xtrac/R/sensitivity_analysis.R](xtrac/R/sensitivity_analysis.R)
- **Tests:** [simulation tests](xtrac/tests/test_simulation.R) · [sensitivity tests](xtrac/tests/test_sensitivity.R)
- **Guide:** [xtrac/README.md](xtrac/README.md)

Run from the repository root with base R:

```bash
Rscript xtrac/R/simulate_xtrac.R
Rscript xtrac/tests/test_simulation.R
Rscript xtrac/R/sensitivity_analysis.R
Rscript xtrac/tests/test_sensitivity.R
```

The simulation writes seeded synthetic daily paths and summaries under `output/`. The sensitivity analysis runs a grid of buffer allocations, drawdown thresholds, and seeds. GitHub Actions runs the XtraC tests on relevant changes.

**Research integrity note:** the source paper reports a terminal value of $91.43bn for Aliu-XtraC versus $90bn for a traditional model. The paper's full code and daily return series were not available, so those results have not been independently reproduced. The included R prototype uses synthetic returns and does **not** claim to validate the reported $1.43bn alpha. There is also an allocation ambiguity: the paper's stated core formula gives 89% of AUM when the drawdown limit is 10% and the buffer is 1%, while this prototype uses a simplified 99% core + 1% buffer split. That formula must be clarified before treating this as a faithful implementation.

### 2. FIFA World Cup Over 1.5 Goals

An empirical study of historical Over 1.5 Goals frequencies in FIFA World Cup matches.

- **Analysis scripts:** [world-cup-goals/R](world-cup-goals/R)
- **Dataset requirements and provenance:** [world-cup-goals/data/README.md](world-cup-goals/data/README.md)
- **Report:** [world-cup-goals/report/world_cup_over15_report.qmd](world-cup-goals/report/world_cup_over15_report.qmd)

The previous project reported 704 Over 1.5 outcomes from 964 matches (73.03%). Those figures must be rerun against the underlying match-level CSV before treating them as independently reproduced. The previous source repository did not contain the dataset, so it could not be copied here. Add a verified file at `world-cup-goals/data/matches_1930_2022.csv` before running the analysis.

Required packages: `tidyverse` and `scales`.

From the `world-cup-goals` directory, run the scripts in order:

```r
source("R/01_clean_data.R")
source("R/02_descriptive_analysis.R")
source("R/03_visualizations.R")
source("R/04_statistical_analysis.R")
```

## Repository layout

```text
QuantX/
├── .github/workflows/xtrac-tests.yml
├── research/aliu-xtrac-framework.md
├── xtrac/
│   ├── R/simulate_xtrac.R
│   ├── R/sensitivity_analysis.R
│   ├── tests/
│   └── README.md
└── world-cup-goals/
    ├── R/
    ├── data/README.md
    └── report/world_cup_over15_report.qmd
```

## Research standards

- Clearly label synthetic data and assumptions.
- Do not treat historical frequency as a guaranteed future probability.
- Account for costs, slippage, liquidity, and model uncertainty.
- Prefer reproducible code, tests, sensitivity analysis, and out-of-sample validation.
- Do not present unverified source-paper figures as reproduced results.
- This repository is for research and education, not investment advice.

## License

MIT License. See [LICENSE](LICENSE).
