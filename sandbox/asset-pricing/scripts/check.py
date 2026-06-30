"""Smoke checks for the pipeline (make check).

Verifies the reproducibility invariant without trusting the
pipeline's own arithmetic: regenerate the content hash from
the raw data, recompute the long-short alpha independently
with statsmodels, and confirm the expected artifacts exist.
Exits nonzero on any failure so `make check` fails loudly.

The R table (ff5_alpha.tex) is checked only if present, so
this runs in the Linux sandbox (Python half) and on the Mac
(after the R step) alike.
"""

from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

import numpy as np
import pandas as pd
import polars as pl
import statsmodels.api as sm

# --- Locked invariant (see CLAUDE.md) --------------------
LOCKED_HASH = ("49b3a1733cf22f5339f1f56edb50bcb6"
               "ae02e8d6a029b8f894f279cdf55dbccb")
LOCKED_ALPHA_4DP = 0.0034
FACTORS = ["mkt_rf", "smb", "hml", "rmw", "cma"]

failures: list[str] = []


def ok(msg: str) -> None:
    print(f"  PASS  {msg}")


def bad(msg: str) -> None:
    failures.append(msg)
    print(f"  FAIL  {msg}")


def check_hash() -> None:
    panel = pd.read_csv("data/raw/firm_panel.csv")
    fac = pd.read_csv("data/raw/factors.csv")
    n_months = fac.shape[0]
    n_firms = panel["firm"].nunique()
    ret = (panel["ret"].to_numpy()
           .reshape(n_firms, n_months))
    factors = fac[FACTORS].to_numpy()
    rf = fac["rf"].to_numpy()
    h = hashlib.sha256()
    for a in (ret, factors, rf):
        h.update(np.ascontiguousarray(
            a.astype(np.float64).round(6)).tobytes())
    digest = h.hexdigest()
    if digest == LOCKED_HASH:
        ok(f"data content hash matches ({digest[:12]}...)")
    else:
        bad(f"data hash {digest[:12]}... != locked "
            f"{LOCKED_HASH[:12]}...")


def check_alpha() -> None:
    df = pl.read_parquet(
        "data/clean/portfolio.parquet").to_pandas()
    X = sm.add_constant(df[FACTORS])
    m = sm.OLS(df["ls_ret"], X).fit()
    a4 = round(float(m.params["const"]), 4)
    if a4 == LOCKED_ALPHA_4DP:
        ok(f"long-short alpha = {a4:.4f} "
           f"(t={m.tvalues['const']:.2f})")
    else:
        bad(f"alpha {a4:.4f} != locked "
            f"{LOCKED_ALPHA_4DP:.4f}")


def _table_alpha(text: str) -> float | None:
    """Pull the Alpha estimate out of the R table text."""
    for line in text.splitlines():
        if "Alpha (monthly)" in line:
            after = line.split("Alpha (monthly)", 1)[1]
            m = re.search(r"-?\d+\.\d+", after)
            if m:
                return float(m.group())
    return None


def check_files() -> None:
    fig = Path("output/figures/cumret.png")
    if fig.exists():
        ok(f"figure exists ({fig})")
    else:
        bad(f"missing figure {fig}")
    # Prefer the .tex (canonical), fall back to the .txt.
    tab = None
    for p in ("output/tables/ff5_alpha.tex",
              "output/tables/ff5_alpha.txt"):
        if Path(p).exists():
            tab = Path(p)
            break
    if tab is None:
        print("  SKIP  R table not built here "
              "(run on the Mac)")
        return
    a = _table_alpha(tab.read_text())
    if a is None:
        bad(f"{tab}: no Alpha row found")
    elif round(a, 4) == LOCKED_ALPHA_4DP:
        ok(f"R table alpha = {a:.4f} ({tab.name})")
    else:
        bad(f"{tab}: alpha {a:.4f} != locked "
            f"{LOCKED_ALPHA_4DP:.4f} (stale table?)")


def main() -> None:
    print("smoke checks:")
    check_hash()
    check_alpha()
    check_files()
    if failures:
        print(f"\n{len(failures)} check(s) FAILED")
        sys.exit(1)
    print("\nall checks passed")


if __name__ == "__main__":
    main()
