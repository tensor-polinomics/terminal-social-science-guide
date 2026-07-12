#!/usr/bin/env bash
# Capture the Ch 18 (Startup files, PATH & portable dotfiles)
# macOS/zsh facts on the user's Mac. The sandbox is Linux/GNU with
# no zsh, so the zsh startup-file ORDER and the macOS specifics
# (bash 3.2 floor, launchd's bare environment) are Mac captures;
# the bash startup order was already captured in the sandbox
# (ch18-bash-order.txt) and is bash-version-stable.
#
# SAFETY / PRIVACY (higher-stakes for this chapter). Dotfiles are
# the most personal files on the machine. This script NEVER reads
# your real ~/.zshenv / ~/.zprofile / ~/.zshrc / ~/.zlogin / bash
# rc files. Every zsh invocation runs against a THROWAWAY HOME
# (mktemp -d) seeded with demo rc files this script writes and
# removes on exit, exactly the zoxide-throwaway-db lesson from
# Ch 16 applied to whole dotfiles. Home path, account name, and
# $TMPDIR hash are masked at capture time.
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal):
#   bash transcripts/capture-ch18-mac.sh
# then paste back the ch18-*-mac.txt files it writes (or say
# "done" and let the chapter be reconciled against them).
#
# NOT `set -e`: a shell that emits a non-tty notice or a missing
# tool must be recorded, not treated as fatal.
set -uo pipefail

unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

acct="$(id -un)"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

vout="$here/ch18-versions-mac.txt"
zout="$here/ch18-zsh-order-mac.txt"
lout="$here/ch18-launchd-mac.txt"

# --- 1. version stamps --------------------------------------
maskv() { sed -E -e "s|${HOME}|/Users/[account]|g" \
                 -e "s|${acct}|[account]|g"; }
{
  echo "# transcript"
  echo "chapter: 18"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: zsh + bash version anchor"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: Version anchor for the 'current as of ${today}'"
  echo "note: stamp. macOS bash is the 3.2 floor (DIVERGENCE);"
  echo "note: the login shell is zsh. Paths masked."
  echo "---"
  echo ""
  echo "\$ zsh --version"
  zsh --version 2>&1 | maskv
  echo ""
  echo "\$ bash --version | head -1"
  bash --version 2>&1 | head -1 | maskv
  echo ""
  echo "\$ echo \$SHELL"
  echo "$SHELL" | maskv
} > "$vout"

# --- 2. zsh startup-file ORDER (throwaway HOME) -------------
# The five zsh files, each echoing a marker, under a demo HOME so
# the real dotfiles are never read. zsh sources .zshenv on EVERY
# invocation (even a script), which is the headline divergence
# from bash. Interactive zsh with no tty may print a job-control
# notice on stderr; 2>/dev/null drops it (a real terminal has a
# tty and never prints it).
zh="$(mktemp -d "${TMPDIR:-/tmp}/ch17zsh.XXXXXX")"
cleanup() { rm -rf "$zh"; }
trap cleanup EXIT
printf "%s\n" "echo 'reading ~/.zshenv'"   > "$zh/.zshenv"
printf "%s\n" "echo 'reading ~/.zprofile'" > "$zh/.zprofile"
printf "%s\n" "echo 'reading ~/.zshrc'"    > "$zh/.zshrc"
printf "%s\n" "echo 'reading ~/.zlogin'"   > "$zh/.zlogin"
maskz() { sed -E -e "s|${zh}|/Users/[account]|g" \
                 -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
                 -e "s|${HOME}|/Users/[account]|g" \
                 -e "s|${acct}|[account]|g"; }
{
  echo "# transcript"
  echo "chapter: 18"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver}"
  echo "tool: zsh (startup-file order)"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: Every zsh here runs against a THROWAWAY HOME (and"
  echo "note: ZDOTDIR) with demo rc files; the real ~/.zshenv etc."
  echo "note: are never read. ZDOTDIR is pointed at the throwaway"
  echo "note: too, because zsh reads \$ZDOTDIR/.zshenv (not"
  echo "note: \$HOME/.zshenv) whenever ZDOTDIR is set. Interactive"
  echo "note: zsh with no tty drops a job-control notice on stderr"
  echo "note: with 2>/dev/null; a real Terminal tab has a tty and"
  echo "note: never prints it. HOME/ZDOTDIR/\$TMPDIR masked."
  echo "---"
  export HOME="$zh"; export ZDOTDIR="$zh"; cd "$zh" || exit 1
  echo ""
  echo "\$ ls -a"
  ls -a | tr '\n' ' ' | sed 's/ $/\n/' | maskz
  echo ""
  echo "\$ zsh -l -i -c 'true' 2>/dev/null   # login + interactive"
  zsh -l -i -c 'true' 2>/dev/null | maskz
  echo ""
  echo "\$ zsh -i -c 'true' 2>/dev/null      # non-login interactive"
  zsh -i -c 'true' 2>/dev/null | maskz
  echo ""
  echo "\$ zsh -c 'true'                      # non-interactive script"
  zsh -c 'true' 2>&1 | maskz
} > "$zout"

# --- 3. launchd's bare environment --------------------------
# A process started by launchd (a GUI app, a LaunchAgent) does NOT
# read your shell dotfiles; it inherits launchd's own environment.
# launchctl getenv PATH shows what that PATH is, evidence for why
# a scheduled/GUI job needs its PATH set explicitly.
{
  echo "# transcript"
  echo "chapter: 18"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver}"
  echo "tool: launchd / launchctl"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: launchd's environment is not your shell's. PATH may"
  echo "note: be empty (unset) if nothing set it. Paths masked."
  echo "---"
  echo ""
  echo "\$ launchctl getenv PATH"
  launchctl getenv PATH 2>&1 | maskv
  echo "(empty output = PATH is not set in launchd's environment)"
} > "$lout"

echo "captured -> $vout"
echo "captured -> $zout"
echo "captured -> $lout"
