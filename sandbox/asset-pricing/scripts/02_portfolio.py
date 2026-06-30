"""Form the signal-sorted long-short portfolio.

Each month, sort firms by the lagged signal into deciles,
go long the top decile and short the bottom decile (equal
weight), and record the long-short return. The result is a
self-financing monthly return series, merged with the FF5
factors, ready for one time-series regression.

Input:   data/clean/analysis.parquet (git-ignored)
         data/raw/factors.csv        (git-ignored)
Output:  data/clean/portfolio.parquet (git-ignored)
"""

from __future__ import annotations

from pathlib import Path

import polars as pl

CLEAN = Path("data/clean/analysis.parquet")
FACTORS = Path("data/raw/factors.csv")
OUT = Path("data/clean/portfolio.parquet")
N_PORT = 10  # deciles


def main() -> None:
    df = pl.read_parquet(CLEAN)

    # Decile rank of the lagged signal within each month.
    ranked = df.with_columns(
        pl.col("signal_lag")
        .rank("ordinal").over("month_date")
        .alias("rk"),
        pl.col("signal_lag").count().over("month_date")
        .alias("n"),
    ).with_columns(
        (((pl.col("rk") - 1) * N_PORT) // pl.col("n"))
        .alias("decile"),  # 0 = lowest, N_PORT-1 = highest
    )

    legs = (
        ranked.filter(
            pl.col("decile").is_in([0, N_PORT - 1]))
        .group_by(["month_date", "decile"])
        .agg(pl.col("ret").mean().alias("leg_ret"))
    )

    wide = legs.pivot(
        values="leg_ret", index="month_date",
        on="decile",
    ).rename({"0": "low", str(N_PORT - 1): "high"})

    ls = wide.with_columns(
        (pl.col("high") - pl.col("low")).alias("ls_ret"),
    ).select(["month_date", "ls_ret"]).sort("month_date")

    fac = pl.read_csv(FACTORS).with_columns(
        (pl.col("month") + "-01")
        .str.to_date("%Y-%m-%d").alias("month_date"),
    ).drop("month")

    merged = ls.join(fac, on="month_date", how="inner") \
        .sort("month_date")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    merged.write_parquet(OUT)
    # Also emit CSV so the R step needs no parquet reader.
    merged.write_csv(OUT.with_suffix(".csv"))
    print(f"wrote {OUT}  months={merged.height}")
    print(f"wrote {OUT.with_suffix('.csv')}")
    print(f"mean ls_ret={merged['ls_ret'].mean():.6f}  "
          f"sd={merged['ls_ret'].std():.6f}")


if __name__ == "__main__":
    main()
