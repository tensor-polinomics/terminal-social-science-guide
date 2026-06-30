#!/usr/bin/env bash
# Deterministic timestamp demo for Ch 11 ("When timestamps
# lie"). Make decides "out of date" by comparing modification
# times. This forces the mtimes by hand with `touch -t` so the
# skip-vs-rebuild decision is reproducible rather than a race:
# equal mtime means the target is up to date (skip); one
# second newer means a rebuild.
#
# NOTE: this shows the general mtime rule, which is the same on
# Make 3.81 and 4.x. It is NOT the version divergence; the
# real macOS race (ch11-make-mac.txt) is the evidence for
# 3.81's one-second-truncation hazard.
#
# Run on the Mac, from anywhere:
#   bash source-private/terminal/transcripts/capture-ch11-timestamp-mac.sh
# then review/commit transcripts/ch11-timestamp-mac.txt.
#
# Throwaway temp dir; nothing in the project is touched, and
# no git is run.

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$here/ch11-timestamp-mac.txt"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work" || exit 1

# A minimal one-rule project: out.txt is copied from in.txt.
printf 'out.txt: in.txt\n\tcp in.txt out.txt\n' >Makefile
echo data >in.txt

# --- transcript header --------------------------------------
{
  echo "# transcript"
  echo "chapter: 11"
  echo "os: $(sw_vers -productName) $(sw_vers -productVersion)" \
       "(Apple Silicon)"
  echo "shell: bash ${BASH_VERSION} (script)"
  echo "tool: $(make --version | head -1)"
  echo "date: $(date +%F)"
  echo "captured-by: user-mac"
  echo "note: Deterministic mtime demo. touch -t sets whole-"
  echo "      second mtimes by hand. When in.txt's mtime equals"
  echo "      out.txt's, make calls the target up to date and"
  echo "      skips it; one second newer triggers a rebuild."
  echo "      Shows the general rule (same on 3.81 and 4.x),"
  echo "      not the version divergence."
  echo "---"
} >"$out"

run() {
  echo "" | tee -a "$out"
  echo "\$ $*" | tee -a "$out"
  "$@" 2>&1 | tee -a "$out"
}

# First build: out.txt does not exist yet, so the recipe runs.
run make

# Force in.txt and out.txt to the SAME mtime (noon, whole
# second). Equal is not "newer", so make skips the rebuild.
run touch -t 202606301200.00 in.txt out.txt
echo "" | tee -a "$out"
echo "\$ stat -f '%Fm  %N' in.txt out.txt" | tee -a "$out"
stat -f '%Fm  %N' in.txt out.txt 2>&1 | tee -a "$out"
run make

# Make in.txt exactly one second newer; now make rebuilds.
run touch -t 202606301200.01 in.txt
echo "" | tee -a "$out"
echo "\$ stat -f '%Fm  %N' in.txt out.txt" | tee -a "$out"
stat -f '%Fm  %N' in.txt out.txt 2>&1 | tee -a "$out"
run make

echo "" | tee -a "$out"
echo "captured -> $out"
