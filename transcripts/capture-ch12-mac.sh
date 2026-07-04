#!/usr/bin/env bash
# Capture the Ch 12 (Environments from the shell) macOS facts on
# the user's Mac.
#
# Ch 12's uv output (uv sync / uv run / uv add / uv pip list, the
# .venv tree, and every lockfile read) is captured in the book's
# Linux sandbox (ch12-*.txt). This script captures the things the
# sandbox cannot: R, renv, and sessionInfo() are Mac-only (the
# sandbox has no R and CRAN is blocked), the Ch 7 DuckDB / Ch 8 fd
# / Ch 10 ShellCheck pattern. ALL commands are ordinary
# non-interactive Rscript/uv invocations (no interactive shell is
# driven, so nothing hangs on a real terminal):
#   1. ch12-renv-mac.txt - renv::status() and a no-op
#      renv::restore() in the real asset-pricing project (both
#      read-only against a synchronized project: restore finds
#      nothing to change; NO renv::snapshot() is run, so
#      renv.lock is never rewritten); then the provenance
#      receipts R.version.string and packageVersion("fixest"),
#      and one full sessionInfo() after library(fixest) for the
#      record (the chapter quotes the receipts and describes
#      sessionInfo in prose).
#   2. ch12-uv-mac.txt   - uv --version on the Mac, so the
#      chapter's sandbox uv version stamp can be reconciled
#      against the Mac install.
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal), the way ch07/ch08/ch09/ch10 were run:
#   bash transcripts/capture-ch12-mac.sh
# then review the two ch12-*-mac.txt files it writes and paste
# them back (or just say "done" and let the chapter be reconciled
# against them).
#
# Requirements: R with the project renv library already restored
# (the normal state of the running example on the Mac), and uv on
# PATH. Its only writes are the transcripts/ folder. Nothing is
# installed by this script, no sudo is run, no interactive shell
# is started, and no real credential is touched.

# NOT set -e: a surprising renv state (e.g. an out-of-sync
# library) must be RECORDED, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub,
# transcripts/README.md; same helper as capture-ch10-mac.sh incl.
# the $TMPDIR folder-hash scrub). renv's loader and sessionInfo()
# can print the project's absolute path and locale values, so
# every R block is masked.
# R's aligned sessionInfo() tables can end lines with right-padding;
# strip that padding at capture time so tracked transcripts pass
# whitespace checks without changing any visible teaching content.
acct="$(id -un)"
mask() {
  sed -E \
    -e "s|${HOME}|/Users/[account]|g" \
    -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
    -e "s|${acct}|[account]|g" \
    -e 's/[[:blank:]]+$//'
}

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project="$here/../sandbox/asset-pricing"

rout="$here/ch12-renv-mac.txt"
uout="$here/ch12-uv-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

hdr() {
  # hdr <chapter-tool-line> <noteline...>
  echo "# transcript"
  echo "chapter: 12"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: $1"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  shift
  for ln in "$@"; do echo "note: ${ln}"; done
  echo "---"
}

# =============================================================
# 1. renv in the real project: status, no-op restore, receipts,
#    and one full sessionInfo() for the record.
# =============================================================
cd "$project" || exit 1

rver="$(Rscript --no-init-file -e 'cat(R.version.string)' 2>/dev/null \
  || echo 'R: not found')"
renvver="$(Rscript -e 'cat(as.character(packageVersion("renv")))' \
  2>/dev/null || echo '?')"

{
  hdr "${rver}; renv ${renvver}" \
    "run in sandbox/asset-pricing (the real project); Rscript is" \
    "non-interactive; renv activates via the project .Rprofile." \
    "renv::restore() against a synchronized library is a no-op;" \
	    "renv::snapshot() is deliberately NOT run (it would rewrite" \
	    "renv.lock). Home paths, the account name, and the TMPDIR" \
	    "hash are masked at capture time; R table right-padding is" \
	    "stripped after masking."
  echo ""
  echo "\$ Rscript -e 'renv::status()'"
  Rscript -e 'renv::status()' 2>&1 | mask
  echo "\$ Rscript -e 'renv::restore()'"
  Rscript -e 'renv::restore()' 2>&1 | mask
  echo ""
  echo "\$ Rscript -e 'R.version.string'"
  Rscript -e 'R.version.string' 2>&1 | mask
  echo "\$ Rscript -e 'packageVersion(\"fixest\")'"
  Rscript -e 'packageVersion("fixest")' 2>&1 | mask
  echo ""
  echo "\$ Rscript -e 'library(fixest); sessionInfo()'"
  Rscript -e 'library(fixest); sessionInfo()' 2>&1 | mask
} > "$rout"

cd "$here" || exit 1

# =============================================================
# 2. Mac uv version stamp.
# =============================================================
{
  hdr "uv (Homebrew or standalone install)" \
    "version stamp only, to reconcile the chapter's sandbox uv" \
    "0.11.19 stamp against the Mac install."
  echo ""
  echo "\$ uv --version"
  uv --version 2>&1 | mask
} > "$uout"

echo "captured -> $rout"
echo "captured -> $uout"
