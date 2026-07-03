#!/usr/bin/env bash
# Capture the Ch 8 (Finding things) macOS/BSD facts on the
# user's Mac.
#
# Ch 8's portable/GNU output (find, ripgrep, xargs) is captured
# in the book's Linux sandbox (ch08-*.txt). This script captures
# the two things the sandbox cannot:
#   1. ch08-find-mac.txt  - BSD `find` divergences from GNU:
#      the regex flag is `-E` before the path (not GNU's
#      `-regextype`), `-printf` does not exist, and BSD `find`
#      insists on a starting path. Each is recorded with its
#      real output and, where it fails, its exit status.
#   2. ch08-fd-mac.txt    - `fd` (REAL Mac capture): fd is a
#      blocked GitHub-release binary in the sandbox, like DuckDB
#      in Ch 7, so its output comes from the Mac. Version, a
#      by-extension search, and the .gitignore-aware default
#      (which hides the ignored data file until `-I`).
#
# Everything runs in a throwaway copy of the running example
# made into a git repo, so fd's ignore behavior is real; the
# copy is removed on exit and the project itself is untouched.
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal), the way ch04/ch07 were run:
#   bash transcripts/capture-ch08-mac.sh
# then review the two ch08-*-mac.txt files it writes and paste
# them back (or just say "done" and let the chapter be
# reconciled against them).
#
# Requirements: the running example's files must exist
# (sandbox/asset-pricing/scripts/*.py and data/raw/*.csv; run
# `make` in sandbox/asset-pricing first if the data is missing),
# and `fd` must be on PATH (brew install fd). The script checks
# both and says what is missing. Its only writes are ONE mktemp
# scratch (removed on exit) and the transcripts/ folder.

# NOT set -e: a nonzero demo (the failing BSD `-printf`) must be
# recorded, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub,
# transcripts/README.md; copied from capture-ch07-mac.sh incl.
# the $TMPDIR folder-hash scrub). These demos print relative
# paths, but errors and the scratch location can expose the home
# path, the account name, or the per-account $TMPDIR hash, so
# all three masks are applied to every captured line.
acct="$(id -un)"
mask() {
  sed -E \
    -e "s|${HOME}|/Users/[account]|g" \
    -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
    -e "s|${acct}|[account]|g"
}

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/.." && pwd)"
proj="$root/sandbox/asset-pricing"

fout="$here/ch08-find-mac.txt"
dout="$here/ch08-fd-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

hdr() {
  # hdr <toolline> <noteline...>
  echo "# transcript"
  echo "chapter: 08"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: $1"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  shift
  for ln in "$@"; do echo "note: ${ln}"; done
  echo "---"
}

# Preflight: data/scripts files and fd.
missing=0
for f in "$proj/scripts/00_make_data.py" \
  "$proj/data/raw/firm_panel.csv" \
  "$proj/.gitignore"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f (run \`make\` in sandbox/asset-pricing)" >&2
    missing=1
  fi
done
if ! command -v fd >/dev/null 2>&1; then
  echo "MISSING: fd not on PATH (brew install fd)" >&2
  missing=1
fi
[ "$missing" -eq 1 ] && exit 1

# A throwaway copy of the project, made a git repo so fd's
# ignore behavior is real. Removed on exit.
scratch="$(mktemp -d "${TMPDIR:-/tmp}/ch08mac.XXXXXX")"
cleanup() { rm -rf "$scratch"; }
trap cleanup EXIT

ap="$scratch/asset-pricing"
mkdir -p "$ap"
# Copy the taught tree: scripts, data, and the .gitignore that
# drives the ignore demo. Keep it small and deterministic.
cp -R "$proj/scripts" "$ap/scripts"
cp -R "$proj/data" "$ap/data"
cp "$proj/.gitignore" "$ap/.gitignore"
rm -rf "$ap/scripts/__pycache__" 2>/dev/null
cd "$ap" || exit 1
git init -q >/dev/null 2>&1

# --- 1. BSD find divergences ---------------------------------
{
  hdr "BSD find (macOS base)" \
    "BSD \`find\` (macOS) diverges from GNU find (Linux, the" \
    "sandbox). The regex engine is selected with a \`-E\` flag" \
    "BEFORE the path, not GNU's \`-regextype\`; \`-printf\` does" \
    "not exist; and a starting path is required. Run in a" \
    "throwaway git-repo copy of the project. Listings sorted" \
    "for determinism. No user data in these lines."
  echo ""
  echo "\$ find -E scripts -regex '.*/0[0-9]_.*[.]py' | sort"
  find -E scripts -regex '.*/0[0-9]_.*[.]py' 2>&1 | sort | mask
  echo ""
  echo "\$ find scripts -name '*.py' -printf '%f\\n'"
  find scripts -name '*.py' -printf '%f\n' </dev/null 2>&1 | mask
  echo ""
  echo "\$ find -name '*.py'"
  out="$(find -name '*.py' </dev/null 2>&1)"
  st=$?
  printf '%s\n' "$out" | mask
  echo "\$ echo \$?"
  echo "$st"
} >"$fout"

# --- 2. fd: the ergonomic find -------------------------------
{
  hdr "fd ($(fd --version 2>/dev/null | head -1))" \
    "REAL Mac capture (fd is a blocked GitHub-release binary in" \
    "the sandbox, like DuckDB in Ch 7). fd searches from the" \
    "current dir by default, matches a regex, and skips" \
    ".gitignore'd paths (the project ignores data/); \`-I\`" \
    "turns that off. Run in the throwaway git-repo copy. Output" \
    "sorted for determinism where a list is shown. No user" \
    "data in these lines."
  echo ""
  echo "\$ fd --version"
  fd --version 2>&1 | mask
  echo ""
  echo "\$ fd -e py | sort"
  fd -e py 2>&1 | sort | mask
  echo ""
  echo "\$ fd firm_panel"
  fd firm_panel 2>&1 | mask
  echo ""
  echo "\$ fd -I firm_panel"
  fd -I firm_panel 2>&1 | mask
} >"$dout"

echo "captured -> $fout"
echo "captured -> $dout"
