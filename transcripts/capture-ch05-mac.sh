#!/usr/bin/env bash
# Capture the Ch 5 (Navigation & file operations) macOS/BSD
# facts on the user's Mac.
#
# Ch 5's portable/GNU output is captured in the book's Linux
# sandbox (ch05-*.txt). This script captures only the BSD
# divergences a real Mac shows, which the sandbox cannot:
#   1. ch05-home-mac.txt    - the ~ / $HOME shorthand resolving
#      to /Users/<you> (shown from the Mac, as in Ch 2, because
#      the sandbox home is a /sessions quirk).
#   2. ch05-ls-mac.txt      - BSD `ls -l` (the `total` line is
#      counted in 512-byte blocks, not GNU's 1K) and the `-G`
#      false friend: on macOS `-G` colorizes and KEEPS the
#      group column (shown by `ls -lG`), while GNU `-G` =
#      --no-group suppresses it; both accept `--color=when`.
#   3. ch05-stat-mac.txt    - BSD `stat` default output and the
#      BSD format flag `-f` (GNU uses `-c`, a different syntax).
#   4. ch05-symlink-mac.txt - BSD `ln -s`, `ls -l` arrow line,
#      `readlink`, and `readlink -f` / `realpath` (both resolve
#      on recent macOS, e.g. 26.5.1; older macOS lacked them,
#      so the capture records the real result for this machine).
#   5. ch05-case-mac.txt    - the default macOS filesystem is
#      case-INSENSITIVE: `Foo.txt` and `foo.txt` are the SAME
#      file (on Linux they are two files, ch05-case.txt).
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal), the way ch02/ch03 were run:
#   bash transcripts/capture-ch05-mac.sh
# then review the five ch05-*-mac.txt files it writes and paste
# them back (or just say "done" and let the chapter be
# reconciled against them).
#
# UNLIKE ch02/ch03 this script needs a scratch directory to run
# the ls / stat / symlink / case demos. It makes ONE with
# `mktemp -d`, works only inside it, and removes it on exit. It
# installs nothing and touches nothing outside that scratch and
# the transcripts/ folder.

# NOT set -e: a missing tool or a nonzero demo (a failing rmdir)
# must be recorded, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub,
# transcripts/README.md). Ch 5 is the first chapter to show
# `ls -l`, whose owner/group columns print the account name, so
# the mask covers BOTH the home path AND the bare account name.
# $HOME is masked first (it contains the account name), then any
# remaining standalone account token in an owner/group column.
# The standard macOS group `staff` is not user data and is left
# as-is. Numeric ids are not shown by these commands. The symlink
# demo resolves absolute paths under the macOS per-account
# $TMPDIR (/private/var/folders/<hash>/...), whose two-level
# folder hash is a machine identifier, so it is masked to
# /private/var/folders/[tmpdir] too.
acct="$(id -un)"
mask() {
  sed -E \
    -e "s|${HOME}|/Users/[account]|g" \
    -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
    -e "s|ch05mac\.[A-Za-z0-9]+|ch05mac.[rand]|g" \
    -e "s|${acct}|[account]|g"
}

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
hout="$here/ch05-home-mac.txt"
lout="$here/ch05-ls-mac.txt"
sout="$here/ch05-stat-mac.txt"
yout="$here/ch05-symlink-mac.txt"
cout="$here/ch05-case-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

hdr() {
  # hdr <toolline> <noteline...>
  echo "# transcript"
  echo "chapter: 05"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: $1"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  shift
  for ln in "$@"; do echo "note: ${ln}"; done
  echo "---"
}

# A scratch directory we fully own; removed on exit.
scratch="$(mktemp -d "${TMPDIR:-/tmp}/ch05mac.XXXXXX")"
cleanup() { rm -rf "$scratch"; }
trap cleanup EXIT

# --- 1. home: ~ and $HOME on macOS ----------------------------
{
  hdr "zsh; \$HOME / ~" \
    "The ~ shorthand and \$HOME resolve to /Users/<you> on" \
    "macOS; masked to /Users/[account]. Shown from the Mac" \
    "because the sandbox home is a /sessions quirk (Ch 2)."
  echo ""
  echo "\$ echo \$HOME"
  echo "$HOME" | mask
  echo ""
  echo "\$ echo ~"
  # ~ expands in the script's own shell; print it literally.
  ( cd ~ && pwd ) | mask
} >"$hout"

# --- 2. BSD ls -l: 512-byte total, and the -G color flag ------
{
  hdr "BSD ls (macOS base)" \
    "BSD \`ls -l\`. The \`total\` line counts 512-byte blocks" \
    "on macOS, not GNU's 1K, so the number differs from the" \
    "Linux capture for the same files. The \`-G\` flag is a" \
    "false friend: on macOS it COLORIZES (and keeps the group" \
    "column), while GNU \`-G\` = --no-group suppresses the" \
    "group. \`ls -lG\` here shows macOS keeping the group;" \
    "both platforms also accept \`--color=when\`. Owner masked" \
    "to [account]; the group \`staff\` is a standard macOS" \
    "group, not user data. Plain \`ls -G\` output is color" \
    "escapes with no stable text, so only its exit is recorded."
  cd "$scratch" || exit 1
  mkdir -p proj/data/raw
  printf 'x\n' > proj/data/raw/factors.csv
  printf 'y\n' > proj/data/raw/firm_panel.csv
  echo ""
  echo "\$ ls -l proj/data/raw"
  ls -l proj/data/raw | mask
  echo ""
  echo "\$ ls -lG proj/data/raw"
  ls -lG proj/data/raw | mask
  echo ""
  echo "\$ ls -G proj/data/raw; echo \"exit=\$?\""
  ls -G proj/data/raw >/dev/null 2>&1
  echo "exit=$?"
} >"$lout"

# --- 3. BSD stat: default output and the -f format flag -------
{
  hdr "BSD stat (macOS base)" \
    "BSD \`stat\` default output differs from GNU's, and the" \
    "format flag is \`-f\` (GNU uses \`-c\`) with different" \
    "specifiers. %N name, %z size, %Sp perms, %Sm mtime." \
    "Owner name (via %Su, if shown) masked to [account]."
  cd "$scratch" || exit 1
  echo ""
  echo "\$ stat proj/data/raw/factors.csv"
  stat proj/data/raw/factors.csv 2>&1 | mask
  echo ""
  echo "\$ stat -f '%N %z bytes, perms %Sp, modified %Sm' \\"
  echo ">     proj/data/raw/factors.csv"
  stat -f '%N %z bytes, perms %Sp, modified %Sm' \
    proj/data/raw/factors.csv 2>&1 | mask
} >"$sout"

# --- 4. BSD symlink: ln -s, readlink, readlink -f / realpath --
{
  hdr "BSD ln/readlink/realpath (macOS base)" \
    "\`ln -s\` and \`readlink\` behave like the GNU side. On" \
    "recent macOS \`readlink -f\` and \`realpath\` BOTH resolve" \
    "(older macOS lacked \`readlink -f\`, and \`realpath\`" \
    "arrived relatively recently), so both are run and their" \
    "real result recorded for this machine." \
    "Owner masked to [account]. The resolved absolute paths" \
    "sit under the macOS per-account \$TMPDIR, whose folder" \
    "hash is masked to /private/var/folders/[tmpdir] (a" \
    "machine identifier); the ch05mac.[rand] tag is a" \
    "masked random mktemp suffix, not identifying."
  cd "$scratch" || exit 1
  ln -s data/raw/factors.csv proj/latest_factors.csv
  echo ""
  echo "\$ ls -l proj/latest_factors.csv"
  ls -l proj/latest_factors.csv | mask
  echo ""
  echo "\$ readlink proj/latest_factors.csv"
  readlink proj/latest_factors.csv 2>&1 | mask
  echo ""
  echo "\$ readlink -f proj/latest_factors.csv; echo \"exit=\$?\""
  readlink -f proj/latest_factors.csv 2>&1 | mask
  echo "exit=$?"
  echo ""
  echo "\$ realpath proj/latest_factors.csv; echo \"exit=\$?\""
  realpath proj/latest_factors.csv 2>&1 | mask
  echo "exit=$?"
} >"$yout"

# --- 5. case-insensitivity on the default macOS filesystem ----
{
  hdr "APFS default (case-insensitive)" \
    "The default macOS volume is case-INSENSITIVE (but case-" \
    "preserving): Foo.txt and foo.txt name the SAME file, so" \
    "writing foo.txt overwrites Foo.txt and \`ls\` shows one" \
    "entry. On Linux (ch05-case.txt) they are two files. If" \
    "this Mac uses a case-sensitive volume the demo will show" \
    "two files instead; that is recorded honestly either way." \
    "No user data in these lines."
  cd "$scratch" || exit 1
  mkdir -p casedemo
  cd casedemo || exit 1
  echo ""
  echo "\$ touch Foo.txt"
  touch Foo.txt
  echo "\$ printf 'lower\\n' > foo.txt"
  printf 'lower\n' > foo.txt
  echo "\$ ls"
  ls | mask
  echo "\$ cat Foo.txt"
  cat Foo.txt 2>&1 | mask
} >"$cout"

echo "captured -> $hout"
echo "captured -> $lout"
echo "captured -> $sout"
echo "captured -> $yout"
echo "captured -> $cout"
