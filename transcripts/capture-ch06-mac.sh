#!/usr/bin/env bash
# Capture the Ch 6 macOS/BSD divergence transcript for the
# pipes/redirection/danger chapter.
#
# The sandbox is Linux/GNU only, so the macOS-specific behavior
# that Ch 6 contrasts has to be captured on a real Mac:
#   1. the default shell is zsh, and the system bash is 3.2;
#   2. an unmatched glob is a hard ERROR in zsh ("no matches
#      found") but is passed through LITERALLY in bash, the
#      single most important portability break in this chapter;
#   3. noclobber refuses an overwrite with a different message
#      under zsh than under bash;
#   4. null-safe find -print0 | xargs -0 behaves identically on
#      BSD findutils, while the naive find | xargs still breaks
#      on spaced names;
#   5. redirection order (2>&1 >file does NOT merge) is the same
#      portable rule as on Linux, confirmed here.
#
# Run on the Mac, from anywhere:
#   bash source-private/terminal/transcripts/capture-ch06-mac.sh
# then review/commit transcripts/ch06-divergence-mac.txt.
#
# Safe and reversible: every demo runs in a fresh mktemp -d
# scratch dir under /tmp and the dir is removed at the end. No
# file outside that scratch dir is touched, and no git is run.

# NOT `set -e`: several demos intentionally fail (an unmatched
# glob, a refused overwrite, a broken xargs) and we want to
# capture those nonzero exits, not abort on them.
set -uo pipefail

# Quiet the recurring environment-noise lines (per the G2
# capture convention), in case this is run from an active venv.
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$here/ch06-divergence-mac.txt"

scratch="$(mktemp -d /tmp/ch06-mac.XXXXXX)"
cleanup() { rm -rf "$scratch"; }
trap cleanup EXIT

# Two spaced CSV copies + a tiny tree for the demos.
: >"$scratch/fy 2011.csv"
: >"$scratch/fy 2012.csv"
printf 'a\nb\n' >"$scratch/fy 2011.csv"
printf 'a\nb\n' >"$scratch/fy 2012.csv"

zver="$(zsh --version 2>/dev/null | awk '{print $2}')"
bver_sys="$(/bin/bash --version | head -1 |
            sed -E 's/.*version ([0-9.]+).*/\1/')"

# --- transcript header --------------------------------------
{
  echo "# transcript"
  echo "chapter: 06"
  echo "os: $(sw_vers -productName) $(sw_vers -productVersion)" \
       "(Apple Silicon)"
  echo "shell: zsh ${zver:-?} (login default); /bin/bash" \
       "${bver_sys:-?} (system)"
  echo "tool: BSD coreutils/findutils (macOS base)"
  echo "date: $(date +%F)"
  echo "captured-by: user-mac"
  echo "note: macOS/BSD divergences for Ch 6. Unmatched glob:" \
       "zsh errors, bash passes it literally. All demos run in"
  echo "      a mktemp scratch dir, removed on exit."
  echo "---"
} >"$out"

# Echo a label, run a snippet, tee combined output.
runz() {  # run a snippet under zsh
  echo "" | tee -a "$out"
  echo "# zsh: $1" | tee -a "$out"
  echo "\$ $2" | tee -a "$out"
  ( cd "$scratch" && zsh -c "$2" ) 2>&1 | tee -a "$out"
}
runb() {  # run a snippet under the system bash 3.2
  echo "" | tee -a "$out"
  echo "# bash ${bver_sys}: $1" | tee -a "$out"
  echo "\$ $2" | tee -a "$out"
  ( cd "$scratch" && /bin/bash -c "$2" ) 2>&1 | tee -a "$out"
}

# 1. Version stamp (already in the header; echo for the record).
echo "" | tee -a "$out"
echo "\$ zsh --version; /bin/bash --version | head -1" \
  | tee -a "$out"
{ zsh --version; /bin/bash --version | head -1; } \
  2>&1 | tee -a "$out"

# 2. THE big divergence: an unmatched glob.
runz "unmatched glob is a hard error" 'ls *.xyz; echo "exit=$?"'
runb "unmatched glob passes through literally" \
  'ls *.xyz; echo "exit=$?"'

# 3. noclobber refusal message differs by shell.
runz "noclobber refusal message" \
  ': >f; set -o noclobber; echo y > f; echo "exit=$?"'
runb "noclobber refusal message" \
  ': >f; set -o noclobber; echo y > f; echo "exit=$?"'

# 4. Null-safety on BSD findutils: naive breaks, -0 is safe.
runb "naive find | xargs breaks on spaced names" \
  "find . -name '*.csv' | xargs wc -l"
runb "null-delimited find -print0 | xargs -0 is safe" \
  "find . -name '*.csv' -print0 | xargs -0 wc -l"

# 5. Redirection order is the same portable rule as on Linux.
runb "2>&1 >file does NOT merge (order matters)" \
  'ls . nope 2>&1 > out.log; echo "--- out.log ---"; cat out.log'

# Trailer goes to the terminal ONLY. The original tee -a wrote
# the absolute path (with the user's account name) into the
# transcript itself, which is how a personal path reached the
# public repo (found at the Ch 2 G3 audit; masked there per the
# transcripts/README scrub convention). Never tee the trailer.
echo "captured -> $out"
