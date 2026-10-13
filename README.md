# QuantX — Quantitative Research Lab

**Owner:** Busari Aliu Oluwaseyi  
**Focus:** quantitative finance, empirical research, risk architecture, and reproducible R analysis.

QuantX is the central repository for the author's quantitative research projects. Research findings are distinguished from prototypes, assumptions, and results that have not been independently reproduced.

## Projects

### 1. Aliu-XtraC Framework

A proposed dual-ledger risk architecture that separates a protected core portfolio from a tactical asymmetric buffer, with an expectancy-based activation gate.

- **Research note:** [Aliu-XtraC Framework](research/aliu-xtrac-framework.md)
- **R simulation prototype:** [xtrac/R/simulate_xtrac.R](xtrac/R/simulate_xtrac.R)
- **Tests:** [xtrac/tests/test_simulation.R](xtrac/tests/test_simulation.R)
- **Guide:** [xtrac/README.md](xtrac/README.md)

Run the synthetic prototype from the repository root with base R:

```bash
Rscript xtrac/R/simulate_xtrac.R
Rscript xtrac/tests/test_simulation.R
```

**Research integrity note:** the source paper reports a terminal value of $91.43bn for Aliu-XtraC versus $90bn for a traditional model. The paper's full code and daily return series were not available, so those results have not been independently reproduced. The included R prototype uses synthetic returns and does **not** claim to validate the reported $1.43bn alpha. There is also an allocation ambiguity: the paper's stated core formula gives 89% of AUM when the drawdown limit is 10% and the buffer is 1%, while this prototype uses a simplified 99% core + 1% buffer split. That formula must be clarified before treating this as a faithful implementation.

### 2. FIFA World Cup Over 1.5 Goals

An empirical study of historical Over 1.5 Goals frequencies in FIFA World Cup matches.

- **Analysis scripts:** [world-cup-goals/R](world-cup-goals/R)
- **Report:** [world-cup-goals/report/world_cup_over15_report.qmd](world-cup-goals/report/world_cup_over15_report.qmd)

The source project reports 704 Over 1.5 outcomes from 964 matches (73.03%). Those figures must be rerun against the underlying match-level CSV before treating them as independently reproduced. The source repository did not contain the dataset, so it has not been copied here; add it as `world-cup-goals/data/matches_1930_2022.csv` before running the analysis.

Required packages for this analysis: `tidyverse` and `scales`.

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
├── research/
│   └── aliu-xtrac-framework.md
├── xtrac/
│   ├── R/simulate_xtrac.R
│   ├── tests/test_simulation.R
│   └── README.md
└── world-cup-goals/
    ├── R/
    └── report/
```

## Research standards

- Clearly label synthetic data and assumptions.
- Do not treat historical frequency as a guaranteed future probability.
- Account for costs, slippage, liquidity, and model uncertainty.
- Prefer reproducible code, tests, sensitivity analysis, and out-of-sample validation.
- This repository is for research and education, not investment advice.

## License

MIT License. See [LICENSE](LICENSE).
