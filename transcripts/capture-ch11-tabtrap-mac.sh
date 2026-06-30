#!/usr/bin/env bash
# Capture the macOS GNU Make 3.81 TAB-trap message for Ch 11.
#
# Captures the real macOS GNU Make 3.81 TAB-trap message so
# the DIVERGENCE callout is verified, not asserted. (Result:
# 3.81 prints the SAME "(did you mean TAB instead of 8
# spaces?)" hint as the sandbox's Make 4.3; an earlier
# assumption that 3.81 was terser was wrong.)
#
# Run on the Mac, from anywhere:
#   bash source-private/terminal/transcripts/capture-ch11-tabtrap-mac.sh
# then review/commit transcripts/ch11-tab-trap-mac.txt.
#
# Builds throwaway Makefiles in a temp dir; nothing in the
# project is touched, and no git is run.

set -uo pipefail   # not -e: a failing `make` is the point

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$here/ch11-tab-trap-mac.txt"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work" || exit 1

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
  echo "note: macOS GNU Make 3.81 TAB-trap message, identical to"
  echo "      the sandbox 4.3 form. cat -et is the BSD spelling"
  echo "      of GNU cat -A: \$ marks line ends, ^I marks a TAB"
  echo "      (macOS cat has no -A)."
  echo "---"
} >"$out"

run() {
  echo "" | tee -a "$out"
  echo "\$ $*" | tee -a "$out"
  "$@" 2>&1 | tee -a "$out"
}

# Broken: recipe indented with 8 SPACES.
printf 'h:\n        echo hi\n' >Makefile
run cat -et Makefile
run make

# Fixed: recipe indented with a real TAB.
printf 'h:\n\techo hi\n' >Makefile
run cat -et Makefile
run make

echo "" | tee -a "$out"
echo "captured -> $out"
