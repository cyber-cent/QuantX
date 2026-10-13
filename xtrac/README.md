# Aliu-XtraC Framework — Reproducible Simulation Prototype

This folder contains a **new, illustrative R simulation** inspired by the proposed dual-ledger framework described in [the research note](../research/aliu-xtrac-framework.md).

## What it does

- Generates a deterministic, seeded **synthetic** 252-day return path with calm, decline, selloff, rebound, and normalization regimes.
- Compares a traditional hard-stop baseline with a two-ledger model: a protected core and a separately allocated tactical buffer.
- Applies the expectancy gate from the research note:
  `E = (Pw × R) − (1 − Pw) ≥ α`.
- Keeps the tactical buffer from going below zero.
- Writes the daily path and terminal summary as CSV files.

## Run it

Requires base R only; no third-party packages are needed. From the repository root:

```bash
Rscript xtrac/R/simulate_xtrac.R
Rscript xtrac/tests/test_simulation.R
```

The simulation writes CSV output files to an `output/` directory relative to the current working directory.

## Allocation caveat

The source note gives the core formula as `Vcore = AUM0 × (1 - MDDlimit - XtraClimit)`. At a 10% drawdown limit and 1% buffer, that formula implies an 89% core allocation, whereas this prototype uses a simplified 99% core + 1% buffer split so the two ledgers sum to initial AUM. The original paper does not explain the remaining 10% clearly enough to resolve this difference. The prototype therefore illustrates mechanics; it is not a faithful reproduction of the source balance-sheet formula.

## Important distinction

The source paper reports a 252-day simulation ending at $91.43bn for Aliu-XtraC versus $90bn for a traditional model. The paper did not provide its daily return series, full simulation code, or sufficient parameter details to independently reproduce those values. **This prototype does not claim to reproduce or validate the paper's reported $1.43bn alpha.** It uses synthetic returns to make the mechanics inspectable and testable.

Before drawing investment conclusions, replace synthetic returns with a documented dataset, estimate gate parameters without look-ahead bias, include transaction costs and slippage, test multiple regimes, and run out-of-sample and stress tests.
