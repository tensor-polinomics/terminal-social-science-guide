#!/usr/bin/env bash
# Capture the Ch 11 Mac-only transcripts for the Make chapter.
#
# These demos exercise the cross-language graph (Python + R +
# Quarto) that the locked-down sandbox cannot run: the full
# build, incremental rebuilds that cross into the R target, a
# dry run, and the `make check` drift-failure path. The output
# is the real thing; this script only orchestrates it and tees
# it into one transcript file.
#
# Run on the Mac, from anywhere:
#   bash source-private/terminal/transcripts/capture-ch11-mac.sh
# then review/commit transcripts/ch11-make-mac.txt.
#
# Safe and reversible: the only mutation is a temporary edit to
# output/tables/ff5_alpha.tex to force a drift failure, undone
# immediately by `make -B`. No git is run by this script.

# NOT `set -e`: we deliberately want to capture a FAILING
# `make check` (nonzero exit) without aborting the script.
set -uo pipefail

# Quiet the two environment-noise lines (per G2 decision):
unset VIRTUAL_ENV                            # stray outer venv
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE  # renv advisory

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
proj="$here/../sandbox/asset-pricing"
out="$here/ch11-make-mac.txt"

cd "$proj" || {
  echo "cannot cd to $proj" >&2
  exit 1
}

rver="$(Rscript -e 'cat(as.character(getRversion()))')"

# --- transcript header --------------------------------------
{
  echo "# transcript"
  echo "chapter: 11"
  echo "os: $(sw_vers -productName) $(sw_vers -productVersion)" \
       "(Apple Silicon)"
  echo "shell: bash ${BASH_VERSION} (script)"
  echo "tool: GNU Make $(make --version | head -1 |
        awk '{print $3}'); uv $(uv --version |
        awk '{print $2}'); R ${rver}; Quarto $(quarto --version)"
  echo "date: $(date +%F)"
  echo "captured-by: user-mac"
  echo "note: Cross-language Make demos (R + Quarto) for Ch 11."
  echo "      VIRTUAL_ENV unset and renv sync-check disabled so"
  echo "      the recurring noise lines do not appear."
  echo "---"
} >"$out"

# Echo a command, run it, tee output into the transcript.
run() {
  echo "" | tee -a "$out"
  echo "\$ $*" | tee -a "$out"
  "$@" 2>&1 | tee -a "$out"
}

# Same, but also record the real exit status (the tee pipe
# would otherwise mask a nonzero exit from `make check`).
run_status() {
  echo "" | tee -a "$out"
  echo "\$ $*" | tee -a "$out"
  "$@" 2>&1 | tee -a "$out"
  echo "(exit status: ${PIPESTATUS[0]})" | tee -a "$out"
}

# 1. Clean slate, then the full cross-language build.
run make clean
run make
run_status make check

# PDF render is a separate step (`all` targets HTML).
run quarto render report.qmd --to pdf

# 2. No-op: nothing changed, so make rebuilds nothing.
run make

# 3. Incremental, Python upstream: touch the portfolio
#    script and watch the cascade cross into R + Quarto.
run touch scripts/02_portfolio.py
run make

# 4. Incremental, R only: touch the regression script;
#    only the table and the report should rebuild.
run touch scripts/04_regression.R
run make

# 5. Dry run: what WOULD rebuild after a touch (no work done).
run touch scripts/04_regression.R
run make -n
run make   # actually bring it up to date before the drift demo

# 6. `make check` fails loudly on a drifted R table.
echo "" | tee -a "$out"
echo "\$ sed -i '' 's/0.0034/0.0099/' \
output/tables/ff5_alpha.tex" | tee -a "$out"
sed -i '' 's/0.0034/0.0099/' output/tables/ff5_alpha.tex
# Touch so make treats the table as up to date and does NOT
# rebuild it, forcing check.py to read the corrupted file.
touch output/tables/ff5_alpha.tex
run_status make check
run make -B output/tables/ff5_alpha.tex   # restore real table
run_status make check                     # back to all-pass

# 7. The help target.
run make help

echo "" | tee -a "$out"
echo "captured -> $out"
