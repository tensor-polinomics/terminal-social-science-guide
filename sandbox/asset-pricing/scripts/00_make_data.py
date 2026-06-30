"""Generate a synthetic firm-month panel for the
signal-sorted long-short example.

All data in this project are SIMULATED. Nothing here is
real CRSP, Compustat, or Bloomberg data. Generating from a
seeded script is the whole point: licensed data cannot live
in a repo, but a seed can, so anyone rebuilds the panel
from this file alone. See PLAN.md Section 7.

The data-generating process embeds one story: an accounting
signal earns a long-short return that the five Fama-French
factors do not span (the "mispricing" alpha). The
econometrics is illustrative scaffolding; the book teaches
the terminal, not asset pricing.

  R(i,t) = RF_t + beta_i . factors_t
           + LAMBDA * S(i,t-1) + noise

Outputs (both git-ignored):
  data/raw/factors.csv      month-level FF5 factors + RF
  data/raw/firm_panel.csv   firm-month returns + accounting
"""

from __future__ import annotations

import hashlib
from pathlib import Path

import numpy as np
import pandas as pd

# --- Locked invariant parameters (see CLAUDE.md) ---------
SEED = 20260629
N_FIRMS = 300
N_MONTHS = 180
LAMBDA = 0.00149       # signal -> return loading
SIGMA_IDIO = 0.060     # idiosyncratic monthly vol
RAW = Path("data/raw")

FACTOR_NAMES = ["mkt_rf", "smb", "hml", "rmw", "cma"]
# Monthly means and vols (decimals), plausible magnitudes.
FACTOR_MEANS = np.array([0.0060, 0.0010, 0.0020,
                         0.0020, 0.0010])
FACTOR_VOLS = np.array([0.0440, 0.0300, 0.0300,
                        0.0200, 0.0200])
# Modest factor correlations (kept PSD).
FACTOR_CORR = np.array([
    [1.00, 0.20, -0.20, -0.20, -0.10],
    [0.20, 1.00, -0.10, -0.20, -0.05],
    [-0.20, -0.10, 1.00, 0.10, 0.30],
    [-0.20, -0.20, 0.10, 1.00, 0.20],
    [-0.10, -0.05, 0.30, 0.20, 1.00],
])
FACTOR_CHOL = np.array([
    [0.044000000000, 0.000000000000, 0.000000000000,
     0.000000000000, 0.000000000000],
    [0.006000000000, 0.029393876913, 0.000000000000,
     0.000000000000, 0.000000000000],
    [-0.006000000000, -0.001837117307, 0.029336410823,
     0.000000000000, 0.000000000000],
    [-0.004000000000, -0.003265986324, 0.001022619985,
     0.019294755290, 0.000000000000],
    [-0.002000000000, -0.000612372436, 0.005688323667,
     0.003326448331, 0.018767064644],
])


def _uniform01(size: int, stream: str) -> np.ndarray:
    """Deterministic uniforms independent of NumPy RNG internals."""
    out = np.empty(size, dtype=np.float64)
    i = 0
    counter = 0
    prefix = f"{SEED}:{stream}:".encode()
    scale = float(2 ** 64)
    while i < size:
        block = hashlib.sha256(
            prefix + str(counter).encode()).digest()
        for j in range(0, len(block), 8):
            if i >= size:
                break
            raw = int.from_bytes(block[j:j + 8], "little")
            out[i] = (raw + 0.5) / scale
            i += 1
        counter += 1
    return out


def _normal(shape: tuple[int, ...] | int, stream: str) -> np.ndarray:
    """Deterministic standard normals via Box-Muller."""
    if isinstance(shape, int):
        shape = (shape,)
    size = int(np.prod(shape))
    n_pairs = (size + 1) // 2
    u = _uniform01(2 * n_pairs, stream)
    u1 = np.clip(u[0::2], np.finfo(np.float64).tiny, 1.0)
    u2 = u[1::2]
    radius = np.sqrt(-2.0 * np.log(u1))
    theta = 2.0 * np.pi * u2
    z = np.empty(2 * n_pairs, dtype=np.float64)
    z[0::2] = radius * np.cos(theta)
    z[1::2] = radius * np.sin(theta)
    return z[:size].reshape(shape)


def _digest(*arrays: np.ndarray) -> str:
    """Cross-machine-stable content hash.

    Hash the raw IEEE-754 bytes of each array rounded to 6
    decimals, the same precision the CSVs are written at, so
    any consumer that re-reads the stored data reproduces the
    digest. Byte layout is identical on aarch64 Linux and
    Apple Silicon, so the digest is platform-stable and does
    not depend on CSV or parquet formatting.
    """
    h = hashlib.sha256()
    for a in arrays:
        h.update(np.ascontiguousarray(
            a.astype(np.float64).round(6)).tobytes())
    return h.hexdigest()


def main() -> None:
    months = pd.period_range("2011-01", periods=N_MONTHS,
                             freq="M")

    # --- Factor series (multivariate normal) -------------
    # Use a fixed Cholesky transform instead of
    # Generator.multivariate_normal(), whose internal method
    # is not a cross-version reproducibility contract.
    z_factors = _normal((N_MONTHS, len(FACTOR_NAMES)),
                        "factors")
    factors = FACTOR_MEANS + z_factors @ FACTOR_CHOL.T
    rf = np.clip(0.0013 + 0.0002 * _normal(N_MONTHS, "rf"),
                 0.0, None)

    # --- Firm factor loadings (cross-section) ------------
    betas = np.column_stack([
        1.0 + 0.25 * _normal(N_FIRMS, "beta-mkt"),
        0.2 + 0.50 * _normal(N_FIRMS, "beta-smb"),
        0.0 + 0.50 * _normal(N_FIRMS, "beta-hml"),
        0.0 + 0.40 * _normal(N_FIRMS, "beta-rmw"),
        0.0 + 0.40 * _normal(N_FIRMS, "beta-cma"),
    ])

    # --- Synthetic accounting vars (persistent) ----------
    # assets follow a lognormal random walk; book equity and
    # earnings are noisy fractions of assets. These three are
    # the only accounting series the cleaning step sees; it
    # rebuilds the signal from them.
    log_assets = np.zeros((N_FIRMS, N_MONTHS))
    log_assets[:, 0] = 7.0 + 0.5 * _normal(
        N_FIRMS, "log-assets-initial")
    asset_shocks = 0.05 * _normal(
        (N_FIRMS, N_MONTHS - 1), "log-assets-shocks")
    for t in range(1, N_MONTHS):
        log_assets[:, t] = log_assets[:, t - 1] \
            + asset_shocks[:, t - 1]
    assets = np.exp(log_assets)
    book_equity = assets * np.clip(
        0.55 + 0.12 * _normal(
            (N_FIRMS, N_MONTHS), "book-equity"),
        0.05, 0.95)
    earnings = assets * (
        0.02 + 0.03 * _normal(
            (N_FIRMS, N_MONTHS), "earnings"))

    # --- Signal S(i,t): cross-sectional z-score ----------
    # Combine a profitability and a value leg, then
    # standardize within each month. (Recomputed in 01.)
    profitability = earnings / assets
    value = book_equity / assets
    raw_signal = profitability + 0.5 * value
    mu = raw_signal.mean(axis=0, keepdims=True)
    sd = raw_signal.std(axis=0, keepdims=True)
    signal = (raw_signal - mu) / sd

    # --- Returns -----------------------------------------
    sys_part = betas @ factors.T          # (firm, month)
    noise = SIGMA_IDIO * _normal(
        (N_FIRMS, N_MONTHS), "return-noise")
    lagged_signal = np.zeros((N_FIRMS, N_MONTHS))
    lagged_signal[:, 1:] = signal[:, :-1]
    ret = (rf[None, :] + sys_part
           + LAMBDA * lagged_signal + noise)
    ret[:, 0] = rf[0] + sys_part[:, 0] + noise[:, 0]

    # --- Write factors.csv -------------------------------
    RAW.mkdir(parents=True, exist_ok=True)
    fac = pd.DataFrame(factors, columns=FACTOR_NAMES)
    fac.insert(0, "month", months.astype(str))
    fac["rf"] = rf
    fac = fac.round(6)
    fac.to_csv(RAW / "factors.csv", index=False)

    # --- Write firm_panel.csv (long) ---------------------
    firm_id = np.repeat(np.arange(N_FIRMS), N_MONTHS)
    month_col = np.tile(months.astype(str), N_FIRMS)
    panel = pd.DataFrame({
        "firm": [f"F{ i:04d}" for i in firm_id],
        "month": month_col,
        "ret": ret.reshape(-1).round(6),
        "book_equity": book_equity.reshape(-1).round(4),
        "earnings": earnings.reshape(-1).round(4),
        "assets": assets.reshape(-1).round(4),
    })
    panel.to_csv(RAW / "firm_panel.csv", index=False)

    digest = _digest(ret, factors, rf)
    print(f"wrote {RAW/'factors.csv'}  "
          f"months={N_MONTHS}")
    print(f"wrote {RAW/'firm_panel.csv'}  "
          f"rows={len(panel)}  firms={N_FIRMS}")
    print(f"seed={SEED}  lambda={LAMBDA}  "
          f"sigma={SIGMA_IDIO}")
    print(f"content-sha256={digest}")


if __name__ == "__main__":
    main()
