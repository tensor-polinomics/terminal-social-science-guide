#!/usr/bin/env bash
# Capture the Ch 2 macOS/BSD divergences and the Mac-only
# demos on the user's Mac.
#
# Ch 2 (the mental model) runs its portable GNU/bash demos in
# the Linux sandbox. This script captures the pieces only a
# real Mac can produce:
#   1. ch02-divergence-mac.txt — zsh type/which behavior
#      (which is a zsh BUILTIN, not the external program Linux
#      runs); the Apple-Silicon PATH with /opt/homebrew/bin
#      first (login zsh so ~/.zprofile's brew shellenv runs);
#      and BSD ls rejecting --help (GNU long options are a
#      GNU-ism).
#   2. ch02-filesystem-mac.txt — pwd, HOME, and the macOS root
#      listing (/Users, /Applications, /System) for the
#      one-tree section.
#   3. ch02-help-mac.txt — a real man page excerpt (the
#      sandbox image strips most man pages) and a GUARDED tldr
#      capture: if tldr is not installed, the script records
#      that fact and the chapter will document + quarantine
#      tldr instead of showing a run. Do not install anything
#      for this script.
#
# Run on the Mac, from the repo root:
#   bash source-private/terminal/transcripts/capture-ch02-mac.sh
# then review the three ch02-*-mac.txt files it writes and
# paste them back (or just say "done" and let the chapter be
# reconciled against them).
#
# Safe and read-only: it inspects the environment and reads
# man/help text only. It writes nothing outside transcripts/.
# No git is run.

# NOT set -e: a missing tool must be recorded, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub
# convention, transcripts/README.md): user-account home-path
# segments are masked to /Users/[account] before anything is
# written, so rerunning this script can never reintroduce a
# personal path into a transcript. The PATH capture is
# additionally truncated after the standard system entries
# (marked [...]): the tail holds only user tool directories.
mask() { sed -e "s|${HOME}|/Users/[account]|g"; }
mask_path_tail() { sed -E 's#(:/sbin):.+$#\1:[...]#'; }

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dout="$here/ch02-divergence-mac.txt"
fout="$here/ch02-filesystem-mac.txt"
hout="$here/ch02-help-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

# --- 1. divergences: zsh type/which, PATH order, BSD --help --
{
  echo "# transcript"
  echo "chapter: 02"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: BSD coreutils (macOS base); zsh builtins"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: zsh's which is a shell builtin (Linux runs an"
  echo "      external /usr/bin/which); login zsh puts"
  echo "      /opt/homebrew/bin early on PATH via ~/.zprofile;"
  echo "      BSD ls rejects the GNU-style --help long option."
  echo "      The PATH line is truncated at capture time after"
  echo "      the system entries (marked [...]): the removed"
  echo "      tail held only user-specific tool directories,"
  echo "      scrubbed for the public repo per transcripts/README."
  echo "---"

  echo ""
  echo "\$ zsh -c 'type -a sort'"
  zsh -c 'type -a sort' 2>&1

  echo ""
  echo "\$ zsh -c 'which which'"
  zsh -c 'which which' 2>&1

  echo ""
  echo "\$ zsh -c 'type -a which'"
  zsh -c 'type -a which' 2>&1

  echo ""
  echo "\$ zsh -lc 'echo \$PATH'   # login zsh: brew shellenv ran"
  zsh -lc 'echo $PATH' 2>&1 | mask | mask_path_tail

  echo ""
  echo "\$ /bin/ls --help; echo \"exit=\$?\""
  /bin/ls --help 2>&1
  echo "exit=$?"
} >"$dout"

# --- 2. filesystem: pwd, HOME, the macOS root ----------------
{
  echo "# transcript"
  echo "chapter: 02"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: BSD coreutils (macOS base)"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: run from the user's home directory; one rooted"
  echo "      tree on macOS too, with homes under /Users. The"
  echo "      account segment of home paths is masked to"
  echo "      /Users/[account] at capture time (public-repo"
  echo "      scrub, transcripts/README)."
  echo "---"

  echo ""
  echo "\$ cd; pwd"
  (cd && pwd) 2>&1 | mask

  echo ""
  echo "\$ echo \$HOME"
  echo "$HOME" | mask

  echo ""
  echo "\$ ls /"
  ls / 2>&1
} >"$fout"

# --- 3. help/discovery: man excerpt + guarded tldr -----------
{
  echo "# transcript"
  echo "chapter: 02"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: man (macOS base); tldr client if installed"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: man page excerpt (col -b strips overstrike"
  echo "      formatting). tldr is captured ONLY if already"
  echo "      installed; if the lines below say 'not installed',"
  echo "      the chapter documents + quarantines tldr instead"
  echo "      of showing a run."
  echo "---"

  echo ""
  echo "\$ man ls | col -b | head -12"
  man ls 2>&1 | col -b | head -12

  echo ""
  if command -v tldr >/dev/null 2>&1; then
    echo "\$ command -v tldr"
    command -v tldr
    echo ""
    echo "\$ tldr --version"
    tldr --version 2>&1
    echo ""
    echo "\$ tldr tar | head -14"
    tldr tar 2>&1 | head -14
  else
    echo "\$ command -v tldr"
    echo "(tldr: not installed on this Mac; chapter will"
    echo " document + quarantine tldr, not show a run)"
  fi
} >"$hout"

echo "captured -> $dout"
echo "captured -> $fout"
echo "captured -> $hout"
