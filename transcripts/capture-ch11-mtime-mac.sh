#!/usr/bin/env bash
# Real-project mtime margin for the Ch 12 Make timestamp hazard.
# Unlike the deterministic ch11-timestamp-mac demo (touch -t on a
# toy project), this captures the ACTUAL mtimes of the study's
# table and report after a correct, forced rebuild, to show the
# sub-second margin GNU Make 3.81 (Apple's) can lose.
#
# The values are NON-deterministic (they depend on build timing),
# so this is a ONE-TIME record, not a reproducible constant:
# re-running produces new mtimes, and the Ch 12 stat block plus
# its "N seconds apart" sentence must be updated to match whatever
# this writes. That is expected and fine (same class as the
# /usr/bin/time resource figures).
#
# Run on the Mac (needs your normal build toolchain: uv, R,
# Quarto), from anywhere:
#   bash source-private/terminal/transcripts/capture-ch11-mtime-mac.sh
# then let Claude read transcripts/ch11-mtime-mac.txt (or paste
# the two output lines back).
#
# This DOES rebuild the real study (make -B report.html), which
# regenerates the deterministic data (same locked hash) and
# re-renders the report. No git is run. Paths are relative, so no
# personal data appears.

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
proj="$here/../sandbox/asset-pricing"
out="$here/ch11-mtime-mac.txt"

cd "$proj" || { echo "no project dir at $proj" >&2; exit 1; }

# Force a correct, sequential rebuild: the R regression writes
# output/tables/ff5_alpha.tex, then the Quarto render writes
# report.html a few seconds later, so the two land in different
# integer seconds (a "rebuilt correctly" run).
echo "rebuilding the study (make -B report.html); this takes a minute..."
if ! make -B report.html; then
  echo "build failed; fix the toolchain (uv/R/Quarto) and re-run" >&2
  exit 1
fi

{
  echo "# transcript"
  echo "chapter: 11"
  echo "os: $(sw_vers -productName) $(sw_vers -productVersion) (Apple Silicon)"
  echo "shell: bash ${BASH_VERSION} (script)"
  echo "tool: BSD stat (macOS)"
  echo "date: $(date +%F)"
  echo "captured-by: user-mac"
  echo "note: Real study mtimes after a forced correct rebuild"
  echo "      (make -B report.html). NON-deterministic: the two"
  echo "      epoch values change per run, so the Ch 12 stat"
  echo "      block is a one-time record updated to match this"
  echo "      file. Relative paths; no personal data."
  echo "---"
  echo "\$ stat -f '%Fm  %N' output/tables/ff5_alpha.tex report.html"
  stat -f '%Fm  %N' output/tables/ff5_alpha.tex report.html
} >"$out"

echo ""
echo "captured -> $out"
echo "--- the two lines Claude will wire in: ---"
stat -f '%Fm  %N' output/tables/ff5_alpha.tex report.html
