#!/usr/bin/env bash
# Fresh capture of the "touch the regression script, then make"
# incremental-rebuild demo for Ch 12 ("Rebuilding only what
# changed"). Touching scripts/04_regression.R reruns only the R
# step (the table) and then re-renders the report, and nothing
# upstream.
#
# GNU Make 3.81 (Apple's) compares mtimes at ONE-SECOND
# granularity, so if the rebuilt table lands in the same integer
# second as the existing report, make skips the render (the "tie"
# the DIVERGENCE section explains). To capture the intended,
# correct cascade reliably, this sleeps 2 s before the touch so
# the new table is a clear second newer than the report and the
# render always runs.
#
# Run on the Mac:
#   bash source-private/terminal/transcripts/capture-ch11-touch-regression-mac.sh
# then let Claude read transcripts/ch11-touch-regression-mac.txt.
#
# Touches the real project build state (a make + a touch + a
# make). No git. Relative paths, no personal data. VIRTUAL_ENV
# is unset and the renv sync-check disabled so the recurring
# advisory lines do not appear (matching ch11-make-mac.txt).

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
proj="$here/../sandbox/asset-pricing"
out="$here/ch11-touch-regression-mac.txt"

cd "$proj" || { echo "no project dir at $proj" >&2; exit 1; }

unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# Ensure a current build exists (report.html present and fresh).
echo "ensuring a current build (make); may take a minute..."
if ! make >/dev/null 2>&1; then
  echo "initial build failed; fix the toolchain (uv/R/Quarto)" >&2
  exit 1
fi

# Sleep so the rebuilt table lands a clear second after the
# existing report; then touch the regression script and rebuild.
sleep 2

{
  echo "# transcript"
  echo "chapter: 11"
  echo "os: $(sw_vers -productName) $(sw_vers -productVersion) (Apple Silicon)"
  echo "shell: bash ${BASH_VERSION} (script)"
  echo "tool: $(make --version | head -1); R + Quarto on the Mac"
  echo "date: $(date +%F)"
  echo "captured-by: user-mac"
  echo "note: Touch the regression script, then make: only the R"
  echo "      step (the table) and the report rebuild, nothing"
  echo "      upstream. A 2 s sleep before the touch guarantees the"
  echo "      new table is a clear second newer than the report, so"
  echo "      Make 3.81 re-renders (avoiding the one-second tie the"
  echo "      DIVERGENCE section covers). Relative paths; no"
  echo "      personal data."
  echo "---"
  echo "\$ touch scripts/04_regression.R"
  touch scripts/04_regression.R
  echo ""
  echo "\$ make"
  make 2>&1
} >"$out"

echo ""
echo "captured -> $out"
echo "--- review it; Claude will wire the touch;make block to it ---"
cat "$out"
