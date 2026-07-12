#!/usr/bin/env bash
# Capture the Ch 16 (Modern CLI kit & TUIs) facts on the user's
# Mac. The whole kit is blocked in the book's Linux sandbox
# (GitHub-release / cargo / brew binaries; only ripgrep and du
# are preinstalled there, and both are already taught in Ch 9 and
# Ch 14), so like Ch 17 this is a Mac-heavy capture chapter.
#
# This script does two jobs at once:
#   1. PROBE + version stamp. It runs `--version` for all nine
#      kit tools (eza, bat, delta, zoxide, fzf, lazygit, btop,
#      ncdu, fd) into ch16-versions-mac.txt. Any tool that is not
#      installed is recorded as "not found", so the first run
#      tells us exactly what to `brew install` and stamps the
#      exact versions the chapter's "current as of" line pins.
#   2. Real, deterministic demo output for the line-output and
#      ANSI tools, with COLOR and ICONS OFF, because the color /
#      syntax highlight / icons are Unicode+ANSI that the LaTeX
#      PDF drops (the Ch 6 box-glyph and Ch 8 duckbox lessons).
#      The three pure TUIs (lazygit, btop, ncdu) are NOT run as
#      sessions; a full-screen TUI owns the terminal and cannot
#      be scripted, so their only evidence is `--version`.
#
# Determinism + privacy: the eza/bat/delta demos run in a
# throwaway git-repo COPY of the running example (removed on
# exit), so the git-status column and the diff are real but do
# not expose the author's actual working tree. zoxide is pointed
# at a throwaway database via _ZO_DATA_DIR, so the author's real
# directory history is never read or shown (a `zoxide query -l`
# on the real db would dump the entire history). All output is
# passed through the standard capture-time mask (home path,
# account name, $TMPDIR hash).
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal):
#   bash transcripts/capture-ch16-mac.sh
# then review the ch16-*-mac.txt files it writes and paste them
# back (or just say "done" and let the chapter be reconciled
# against them). Read-only w.r.t. the project: it copies files
# out, never edits the project itself, starts no TUI, runs no git
# inside the repo, and its only writes are ONE mktemp scratch
# (removed on exit) and the transcripts/ folder.

# NOT `set -e`: a missing tool or a nonzero demo must be recorded,
# not treated as fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention),
# and neutralize any global eza icon default so the capture is
# deterministic regardless of the user's shell config.
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE
unset EZA_ICONS_AUTO 2>/dev/null || true

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub,
# transcripts/README.md; same helper as capture-ch09-mac.sh).
# eza -l owner columns, absolute paths in zoxide/fzf/diff output,
# and the $TMPDIR scratch location can each expose the home path,
# the account name, or the per-account $TMPDIR hash.
acct="$(id -un)"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/.." && pwd)"
proj="$root/sandbox/asset-pricing"

# The running example's real absolute path is deep and specific
# to the author's checkout, so collapse the whole project path to
# a clean, representative form BEFORE the generic home/account
# masks. This is for a cleaner, reader-representative block, not a
# secrecy requirement (the repo-location string is not secret and
# appears in other capture headers); a reader would have the
# project at a plain path like this anyway.
mask() {
  sed -E \
    -e "s|${proj}|/Users/[account]/projects/asset-pricing|g" \
    -e "s|${HOME}|/Users/[account]|g" \
    -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
    -e "s|${acct}|[account]|g"
}

vout="$here/ch16-versions-mac.txt"
eout="$here/ch16-eza-mac.txt"
bout="$here/ch16-bat-mac.txt"
nout="$here/ch16-nav-mac.txt"
dout="$here/ch16-diff-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

hdr() {
  # hdr <toolline> <noteline...>
  echo "# transcript"
  echo "chapter: 16"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: $1"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  shift
  for ln in "$@"; do echo "note: ${ln}"; done
  echo "---"
}

# --- 0. Preflight: the running example must exist ------------
missing=0
for f in "$proj/scripts/02_portfolio.py" \
  "$proj/scripts/00_make_data.py" \
  "$proj/.gitignore"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f (run \`make\` in sandbox/asset-pricing)" >&2
    missing=1
  fi
done
[ "$missing" -eq 1 ] && exit 1

# Report (do not fail on) any kit tool that is not installed, so
# the first run doubles as the PROBE list.
absent=""
for t in eza bat delta zoxide fzf lazygit btop ncdu fd; do
  command -v "$t" >/dev/null 2>&1 || absent="$absent $t"
done

# --- 1. version stamps (PROBE) ------------------------------
ver() {
  # ver <tool> : print "$ tool --version" + first line, or a
  # clear not-found marker (non-fatal).
  echo ""
  echo "\$ $1 --version"
  if command -v "$1" >/dev/null 2>&1; then
    "$1" --version 2>&1 | head -1 | mask
  else
    echo "$1: not found (brew install $1)"
  fi
}
{
  hdr "modern CLI kit + TUIs (version anchor)" \
    "PROBE + version anchor for the 'current as of ${today}'" \
    "stamp. Nine tools; any 'not found' line is a to-install" \
    "signal, not a chapter claim. The three TUIs (lazygit," \
    "btop, ncdu) appear ONLY here: a full-screen TUI owns the" \
    "terminal and cannot be scripted, so --version is their" \
    "only evidence (the Ch 17 quarantine pattern)."
  for t in eza bat delta zoxide fzf lazygit btop ncdu fd; do
    ver "$t"
  done
} >"$vout"

# --- shared throwaway git-repo copy of the running example ---
# Drives the eza --git column, the bat view, and the delta diff
# baseline from ONE deterministic edit (decile -> quintile, the
# same one-line change Ch 17 used). Removed on exit.
scratch="$(mktemp -d "${TMPDIR:-/tmp}/ch16mac.XXXXXX")"
cleanup() { rm -rf "$scratch"; }
trap cleanup EXIT

ap="$scratch/asset-pricing"
mkdir -p "$ap"
cp -R "$proj/scripts" "$ap/scripts"
cp "$proj/.gitignore" "$ap/.gitignore"
rm -rf "$ap/scripts/__pycache__" 2>/dev/null || true
cd "$ap" || exit 1
git init -q >/dev/null 2>&1
git add -A >/dev/null 2>&1
git -c user.name=book -c user.email=book@example.com \
  commit -qm "baseline" >/dev/null 2>&1

# Detect the working icon-disable flag once (eza renamed
# --no-icons to --icons=never across versions; run it, do not
# trust memory).
icons=""
if command -v eza >/dev/null 2>&1; then
  if eza --color=never --icons=never -d . >/dev/null 2>&1; then
    icons="--icons=never"
  elif eza --color=never --no-icons -d . >/dev/null 2>&1; then
    icons="--no-icons"
  fi
fi

# --- 2. eza: the ls upgrade (color + icons OFF) -------------
# Show it BEFORE the edit (clean tree), then the git column
# AFTER the edit so one file reads as modified.
{
  hdr "eza ($(eza --version 2>/dev/null | sed -n '2p' | mask))" \
    "REAL Mac capture; eza is a blocked binary in the sandbox." \
    "COLOR + ICONS OFF on purpose: eza's color and Nerd-Font" \
    "icons are ANSI/Unicode the PDF drops. \`--tree\` uses" \
    "Unicode branch glyphs, so it is captured for reference but" \
    "the chapter leans on the ASCII-safe \`-l --git\` block and" \
    "describes the tree. Run in a throwaway git-repo copy so the" \
    "git-status column is real without exposing the working" \
    "tree. One file (02_portfolio.py) was edited after the" \
    "baseline commit so its git column reads modified."
  if command -v eza >/dev/null 2>&1; then
    echo ""
    echo "\$ eza --tree --level=2 scripts"
    eza --color=never $icons --tree --level=2 scripts 2>&1 | mask
    # make the deterministic edit that both eza --git and the
    # delta diff will show
    sed -i '' 's/^N_PORT = 10.*/N_PORT = 5  # quintiles/' \
      scripts/02_portfolio.py 2>/dev/null \
      || sed -i 's/^N_PORT = 10.*/N_PORT = 5  # quintiles/' \
        scripts/02_portfolio.py
    echo ""
    echo "\$ eza -l --git scripts"
    eza --color=never $icons -l --git scripts 2>&1 | mask
  else
    echo ""
    echo "eza: not found (brew install eza); section skipped."
    # still make the edit so the diff section works
    sed -i '' 's/^N_PORT = 10.*/N_PORT = 5  # quintiles/' \
      scripts/02_portfolio.py 2>/dev/null \
      || sed -i 's/^N_PORT = 10.*/N_PORT = 5  # quintiles/' \
        scripts/02_portfolio.py
  fi
} >"$eout"

# --- 3. bat: the cat upgrade (color OFF) --------------------
# Line numbers survive; syntax color does not. Bat the pristine
# head of a real script (independent of the edit above).
{
  hdr "bat ($(bat --version 2>/dev/null | mask))" \
    "REAL Mac capture; bat is a blocked binary in the sandbox." \
    "COLOR OFF (\`--color=never\`): bat's syntax highlighting is" \
    "ANSI the PDF cannot show, and that IS its main draw, so the" \
    "chapter is honest that print keeps only the line numbers and" \
    "the decoration column. \`--decorations=always\` is forced" \
    "because bat auto-plains (acts like cat) when its output is" \
    "not a terminal, e.g. redirected to this file; run" \
    "interactively you just type \`bat <file>\`. \`--paging=never\`" \
    "so no pager is invoked; a bounded line range keeps it short."
  if command -v bat >/dev/null 2>&1; then
    echo ""
    echo "\$ bat --style=numbers --decorations=always \\"
    echo "      --color=never --paging=never \\"
    echo "      --line-range=1:16 scripts/00_make_data.py"
    bat --style=numbers --decorations=always \
      --color=never --paging=never \
      --line-range=1:16 scripts/00_make_data.py 2>&1 | mask
  else
    echo ""
    echo "bat: not found (brew install bat); section skipped."
  fi
} >"$bout"

# --- 4. zoxide + fzf: getting there faster ------------------
# zoxide against a THROWAWAY database (never the real history);
# fzf driven non-interactively with --filter (the live UI is
# described in prose, not captured).
{
  hdr "zoxide + fzf (see versions file for exact versions)" \
    "REAL Mac capture. zoxide is pointed at a THROWAWAY database" \
    "via _ZO_DATA_DIR and seeded with only the demo directories," \
    "so the author's real directory history is never read (a" \
    "\`zoxide query -l\` on the real db would dump all of it)." \
    "fzf is driven with --filter so it runs non-interactively;" \
    "the live full-screen finder is described in the chapter, not" \
    "captured. Paths masked to /Users/[account]."
  if command -v zoxide >/dev/null 2>&1; then
    export _ZO_DATA_DIR="$scratch/zoxide"
    mkdir -p "$_ZO_DATA_DIR"
    zoxide add "$proj" 2>/dev/null || true
    zoxide add "$proj/scripts" 2>/dev/null || true
    echo ""
    echo "\$ zoxide query asset-pricing"
    zoxide query asset-pricing 2>&1 | mask
    echo ""
    echo "\$ zoxide query scripts"
    zoxide query scripts 2>&1 | mask
  else
    echo ""
    echo "zoxide: not found (brew install zoxide); part skipped."
  fi
  if command -v fzf >/dev/null 2>&1; then
    echo ""
    echo "\$ ls scripts | fzf --filter portfolio"
    (cd "$ap" && ls scripts | sort) | fzf --filter portfolio \
      2>&1 | mask
  else
    echo ""
    echo "fzf: not found (brew install fzf); part skipped."
  fi
} >"$nout"

# --- 5. delta baseline: the portable git diff ---------------
# delta is a git-diff PAGER whose colored side-by-side view is
# its whole point and cannot survive print, so the chapter
# describes it and version-stamps it. What it shows here is the
# PORTABLE baseline: the plain `git diff` delta would page.
{
  hdr "git diff (portable baseline for the delta section)" \
    "The delta section is describe-and-version-stamp (its color" \
    "side-by-side view is exactly what a print PDF drops). This" \
    "is the plain, portable \`git diff\` of the same decile ->" \
    "quintile edit; the chapter describes how delta re-renders" \
    "it. color.ui=never so the diff is plain text on any box." \
    "Run in the throwaway repo; paths are relative."
  echo ""
  echo "\$ git diff scripts/02_portfolio.py"
  git -c color.ui=never diff scripts/02_portfolio.py 2>&1 | mask
} >"$dout"

echo "captured -> $vout"
echo "captured -> $eout"
echo "captured -> $bout"
echo "captured -> $nout"
echo "captured -> $dout"
if [ -n "$absent" ]; then
  echo ""
  echo "NOTE: not installed (recorded as 'not found' above):${absent}"
  echo "      brew install${absent}   # to capture their demos"
fi
