"""Build the analysis sample with polars.

Reads the simulated firm panel and the factor file,
rebuilds the mispricing signal from the raw accounting
variables (profitability + value), standardizes it within
each month, lags it one month per firm, and drops the
first month (no lag available). The signal is rebuilt here
on purpose: the cleaning step does real work, and the
generator never has to ship the signal column.

Input:   data/raw/firm_panel.csv   (git-ignored)
         data/raw/factors.csv      (git-ignored)
Output:  data/clean/analysis.parquet (git-ignored)
"""

from __future__ import annotations

from pathlib import Path

import polars as pl

PANEL = Path("data/raw/firm_panel.csv")
CLEAN = Path("data/clean")


def main() -> None:
    df = pl.read_csv(PANEL).with_columns(
        (pl.col("month") + "-01")
        .str.to_date("%Y-%m-%d")
        .alias("month_date"),
    )

    # Rebuild the raw signal from accounting variables.
    df = df.with_columns(
        (pl.col("earnings") / pl.col("assets")
         + 0.5 * pl.col("book_equity") / pl.col("assets"))
        .alias("raw_signal"),
    )

    # Cross-sectional z-score within each month.
    df = df.with_columns(
        ((pl.col("raw_signal")
          - pl.col("raw_signal").mean().over("month_date"))
         / pl.col("raw_signal").std().over("month_date"))
        .alias("signal"),
    )

    # Lag the signal one month within each firm.
    df = df.sort(["firm", "month_date"]).with_columns(
        pl.col("signal").shift(1).over("firm")
        .alias("signal_lag"),
    )

    out = (
        df.drop_nulls("signal_lag")
        .select(["firm", "month_date", "ret", "signal_lag"])
        .sort(["month_date", "firm"])
    )

    CLEAN.mkdir(parents=True, exist_ok=True)
    dest = CLEAN / "analysis.parquet"
    out.write_parquet(dest)
    print(f"wrote {dest}  rows={out.height}  "
          f"cols={out.width}")
    print(f"months={out['month_date'].n_unique()}  "
          f"firms={out['firm'].n_unique()}")


if __name__ == "__main__":
    main()
