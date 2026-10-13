# Aliu-XtraC Framework — Reproducible Simulation Prototype

This folder contains an **illustrative R simulation and sensitivity analysis** inspired by the proposed dual-ledger framework described in [the research note](../research/aliu-xtrac-framework.md).

## Included

- A seeded synthetic 252-day return path with calm, decline, selloff, rebound, and normalization regimes.
- A comparison between a traditional hard-stop baseline and a two-ledger model: a protected core and a separately allocated tactical buffer.
- The expectancy gate from the research note: `E = (Pw × R) − (1 − Pw) ≥ α`.
- A tactical buffer that cannot fall below zero.
- CSV outputs for the daily path, terminal summary, and sensitivity grid.
- Base-R tests and a GitHub Actions workflow.

## Run from the repository root

Requires base R only; no third-party packages are needed.

```bash
Rscript xtrac/R/simulate_xtrac.R
Rscript xtrac/tests/test_simulation.R
Rscript xtrac/R/sensitivity_analysis.R
Rscript xtrac/tests/test_sensitivity.R
```

The simulation writes `output/xtrac_daily_path.csv` and `output/xtrac_summary.csv`. The sensitivity analysis evaluates 450 seeded synthetic scenarios by default and writes `output/xtrac_sensitivity.csv` and `output/xtrac_sensitivity_summary.csv`.

## Interpretation and limitations

This is a transparent synthetic prototype, not a validated trading system. The synthetic returns are deliberately constructed for reproducibility and are not market observations. The buffer uses the same synthetic daily return stream after activation; this simplification is not a model of actual tactical trade entries, execution, or position sizing. The expectancy gate is supplied as a fixed assumption, not estimated from historical information available at each decision point.

The source paper reports a 252-day simulation ending at $91.43bn for Aliu-XtraC versus $90bn for a traditional model. The paper did not provide its daily return series, full simulation code, or sufficient parameter details to independently reproduce those values. **This prototype does not claim to reproduce or validate the paper's reported $1.43bn alpha.**

## Allocation caveat

The source note gives the core formula as `Vcore = AUM0 × (1 - MDDlimit - XtraClimit)`. At a 10% drawdown limit and 1% buffer, that formula implies an 89% core allocation, whereas this prototype uses a simplified 99% core + 1% buffer split so the two ledgers sum to initial AUM. The source paper does not explain the remaining 10% clearly enough to resolve this difference. This must be clarified before treating the code as a faithful implementation.

Before drawing investment conclusions, use a documented market dataset, estimate gate parameters without look-ahead bias, model actual trades and position sizing, include transaction costs and slippage, test multiple regimes, and run out-of-sample and stress tests.
