"""Plot the cumulative long-short return.

Reads the monthly long-short series and draws one line:
the cumulative compounded return of the self-financing
signal portfolio. One figure, no econometrics.

Input:   data/clean/portfolio.parquet (git-ignored)
Output:  output/figures/cumret.png
"""

from __future__ import annotations

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import polars as pl

PORT = Path("data/clean/portfolio.parquet")
FIG = Path("output/figures")


def main() -> None:
    df = (
        pl.read_parquet(PORT)
        .sort("month_date")
        .with_columns(
            ((1.0 + pl.col("ls_ret")).cum_prod() - 1.0)
            .alias("cum_ls"),
        )
    )

    FIG.mkdir(parents=True, exist_ok=True)
    fig, ax = plt.subplots(figsize=(7, 4))
    ax.plot(df["month_date"], df["cum_ls"] * 100,
            color="#1f4e79", lw=1.5)
    ax.axhline(0, color="grey", ls="--", lw=0.8)
    ax.set_xlabel("Month")
    ax.set_ylabel("Cumulative long-short return (%)")
    ax.set_title("Signal-sorted long-short portfolio")
    fig.tight_layout()
    dest = FIG / "cumret.png"
    fig.savefig(dest, dpi=120)
    final = float(df["cum_ls"][-1]) * 100
    print(f"wrote {dest}  "
          f"final cumulative return={final:.2f}%")


if __name__ == "__main__":
    main()
