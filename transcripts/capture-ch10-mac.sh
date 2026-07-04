#!/usr/bin/env bash
# Capture the Ch 10 (Scripts that fail loudly) macOS/BSD facts on
# the user's Mac.
#
# Ch 10's portable/GNU output (the shebang, set -euo pipefail,
# exit codes, the trap, the set -e footguns, bash -x, tee,
# /usr/bin/time -v, LC_ALL/TZ pinning, and the verify.sh anchor)
# is captured in the book's Linux sandbox (ch10-*.txt). This
# script captures the four things the sandbox cannot, and ALL are
# ordinary non-interactive commands (no interactive shell is
# driven, so nothing hangs on a real terminal):
#   1. ch10-lint-mac.txt   - ShellCheck + shfmt. Both are
#      GitHub-release binaries blocked in the sandbox; they behave
#      the same cross-platform, so the Mac capture is the evidence
#      (like Ch 7 DuckDB / Ch 8 fd). shellcheck flags the SC2086
#      unquoted expansion Ch 6 warned about; shfmt shows a format
#      diff.
#   2. ch10-bash32-mac.txt - the macOS bash-3.2 floor. macOS ships
#      /bin/bash frozen at 3.2.57 (Ch 3's DIVERGENCE); a script
#      using a bash-4+ feature runs on Linux and FAILS here. Shows
#      the version and three real failures (declare -A, ${v^^},
#      mapfile).
#   3. ch10-bsd-mac.txt    - BSD /usr/bin/time -l (macOS has no
#      GNU -v) and BSD `date -r EPOCH` (GNU uses `date -d @EPOCH`).
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal), the way ch04/ch07/ch08/ch09 were run:
#   bash transcripts/capture-ch10-mac.sh
# then review the three ch10-*-mac.txt files it writes and paste
# them back (or just say "done" and let the chapter be reconciled
# against them).
#
# Requirements: shellcheck and shfmt on PATH
# (brew install shellcheck shfmt), plus the system /bin/bash 3.2,
# BSD /usr/bin/time, and BSD date (all stock macOS). Its only
# writes are mktemp scratch dirs (removed on exit) and the
# transcripts/ folder. Nothing is installed by this script, no
# sudo is run, and no real credential is touched.

# NOT set -e: several demos (shellcheck on a bad script, the
# bash-3.2 failures) are EXPECTED to exit nonzero and must be
# recorded, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub,
# transcripts/README.md; same helper as capture-ch09-mac.sh incl.
# the $TMPDIR folder-hash scrub).
acct="$(id -un)"
mask() {
  sed -E \
    -e "s|${HOME}|/Users/[account]|g" \
    -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
    -e "s|${acct}|[account]|g"
}

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

lout="$here/ch10-lint-mac.txt"
bout="$here/ch10-bash32-mac.txt"
sout="$here/ch10-bsd-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

hdr() {
  # hdr <chapter-tool-line> <noteline...>
  echo "# transcript"
  echo "chapter: 10"
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
# 1. ShellCheck + shfmt.
# =============================================================
lscratch="$(mktemp -d "${TMPDIR:-/tmp}/ch10lint.XXXXXX")"
cd "$lscratch" || exit 1

# unsafe.sh: an unquoted expansion, exactly as shown in the
# chapter, so ShellCheck's line numbers match.
cat > unsafe.sh <<'SH'
#!/usr/bin/env bash
infile=$1
wc -l $infile
SH

# messy.sh: inconsistent formatting for shfmt to fix.
cat > messy.sh <<'SH'
#!/usr/bin/env bash
if [ -f data.csv ];then
echo "found"
fi
SH

sc_ver="$(shellcheck --version 2>&1 | awk '/version:/{print $2; exit}')"
sf_ver="$(shfmt --version 2>&1)"

{
  hdr "ShellCheck ${sc_ver:-?} / shfmt ${sf_ver:-?}" \
    "ShellCheck and shfmt are blocked GitHub-release binaries in" \
    "the sandbox; they behave the same cross-platform, so this Mac" \
    "capture is the evidence (Ch 7 DuckDB / Ch 8 fd pattern). No" \
    "personal data is shown; paths are masked."
  echo ""
  echo "\$ shellcheck --version"
  shellcheck --version 2>&1 | mask
  echo "\$ cat unsafe.sh"
  cat unsafe.sh
  echo "\$ shellcheck unsafe.sh"
  shellcheck unsafe.sh 2>&1 | mask
  echo ""
  echo "\$ shfmt --version"
  shfmt --version 2>&1 | mask
  echo "\$ cat messy.sh"
  cat messy.sh
  echo "\$ shfmt -d messy.sh"
  shfmt -d messy.sh 2>&1 | mask
} > "$lout"

cd "$here" || exit 1
rm -rf "$lscratch"

# =============================================================
# 2. macOS bash-3.2 floor.
# =============================================================
bver="$(/bin/bash --version 2>&1 | head -1)"
{
  hdr "system /bin/bash (macOS)" \
    "macOS ships /bin/bash frozen at 3.2.57 (Ch 3). A script that" \
    "uses a bash-4+ feature runs on Linux (sandbox bash 5.1) and" \
    "FAILS on the system bash here. The fix is a Homebrew bash" \
    "pointed at by the shebang; the system bash never moves."
  echo ""
  echo "\$ /bin/bash --version"
  printf '%s\n' "$bver" | mask
  echo "\$ /bin/bash -c 'declare -A m; m[x]=1; echo \${m[x]}'"
  /bin/bash -c 'declare -A m; m[x]=1; echo ${m[x]}' 2>&1 | mask
  echo "\$ /bin/bash -c 'v=hi; echo \${v^^}'"
  /bin/bash -c 'v=hi; echo ${v^^}' 2>&1 | mask
  echo "\$ /bin/bash -c 'mapfile -t rows < /etc/hosts; echo \${#rows[@]}'"
  /bin/bash -c 'mapfile -t rows < /etc/hosts; echo ${#rows[@]}' 2>&1 | mask
} > "$bout"

# =============================================================
# 3. BSD /usr/bin/time -l and BSD date -r.
# =============================================================
{
  hdr "BSD /usr/bin/time + BSD date (macOS)" \
    "macOS /usr/bin/time has no GNU -v; it uses -l for the long" \
    "resource report. BSD date reads an epoch with -r, where GNU" \
    "date uses -d @EPOCH. The time figures vary run to run; only" \
    "the shape and the 'real' line are used in the chapter."
  echo ""
  echo "\$ /usr/bin/time -l sleep 0.2"
  /usr/bin/time -l sleep 0.2 2>&1 | mask
  echo ""
  echo "\$ date -u -r 1700000000 +\"%Y-%m-%d %H:%M %Z\""
  date -u -r 1700000000 +"%Y-%m-%d %H:%M %Z" 2>&1 | mask
  echo "\$ date -d @1700000000 +\"%Y-%m-%d %H:%M %Z\"   # GNU form: fails on BSD"
  date -d @1700000000 +"%Y-%m-%d %H:%M %Z" 2>&1 | mask
} > "$sout"

echo "captured -> $lout"
echo "captured -> $bout"
echo "captured -> $sout"
