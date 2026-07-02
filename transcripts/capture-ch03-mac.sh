#!/usr/bin/env bash
# Capture the Ch 3 (Setup) macOS facts on the user's Mac.
#
# Ch 3 is the platform-specific chapter. Its Linux/WSL2 track is
# captured in the book's Linux sandbox (ch03-linux-*.txt); its
# WSL2 and PowerShell material is documented + quarantined
# (no such machine exists). This script captures the pieces only
# a real Mac can produce, and it is strictly READ-ONLY: it runs
# NO installer (not Homebrew, not a package install) and changes
# nothing. It writes three transcripts under transcripts/:
#   1. ch03-shell-mac.txt  - the login shell (zsh) and its %
#      prompt evidence, plus the macOS system bash 3.2 floor
#      (/bin/bash --version), the DIVERGENCE the scripting
#      chapter (Ch 10) returns to.
#   2. ch03-brew-mac.txt   - Homebrew presence, version, prefix
#      (/opt/homebrew on Apple Silicon), and the `brew shellenv`
#      lines that front the PATH (Apple Silicon PATH note).
#   3. ch03-toolchain-mac.txt - the Command Line Tools path
#      (git and the compilers come from there), git --version,
#      the BSD-side checksum tool `shasum -a 256` (same digest as
#      the sandbox's GNU sha256sum, different name), and a
#      GUARDED tldr version (recorded only if already installed;
#      nothing is installed to satisfy this script).
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal), the way the user ran it:
#   bash transcripts/capture-ch03-mac.sh
# then review the three ch03-*-mac.txt files it writes and paste
# them back (or just say "done" and let the chapter be
# reconciled against them).
#
# Safe and read-only: it inspects the shell, Homebrew, and the
# toolchain, and hashes a literal string. It writes nothing
# outside transcripts/. No git repo operation and no install
# is run.

# NOT set -e: a missing tool must be recorded, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub
# convention, transcripts/README.md): any user-account home-path
# segment is masked to /Users/[account] before anything is
# written, so a rerun can never leak a personal path. The
# Homebrew and toolchain outputs live under /opt and /Library and
# carry no account segment, but the mask is applied to every
# capture regardless, defensively.
mask() { sed -e "s|${HOME}|/Users/[account]|g"; }

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sout="$here/ch03-shell-mac.txt"
bout="$here/ch03-brew-mac.txt"
tout="$here/ch03-toolchain-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

# --- 1. shell: login shell, zsh identity, bash 3.2 floor ------
{
  echo "# transcript"
  echo "chapter: 03"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: zsh; macOS system /bin/bash"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: macOS's login shell is zsh (SHELL=/bin/zsh), whose"
  echo "      prompt ends in % not \$. \`ps -p \$\$\` is run under"
  echo "      zsh with a trailing \`; true\` so zsh does not"
  echo "      exec-replace itself with ps (single-command"
  echo "      optimization); a reader at the prompt types just"
  echo "      \`ps -p \$\$\`. /bin/bash is the macOS SYSTEM bash,"
  echo "      frozen at 3.2.57 (2007) for licensing reasons; this"
  echo "      is the bash-3.2 floor Ch 10 returns to. No personal"
  echo "      data in these lines; \$HOME masking applied anyway."
  echo "---"

  echo ""
  echo "\$ echo \$SHELL"
  echo "$SHELL" | mask

  echo ""
  echo "\$ zsh --version"
  zsh --version 2>&1 | mask

  echo ""
  echo "\$ zsh -c 'ps -p \$\$ -o comm=; true'"
  zsh -c 'ps -p $$ -o comm=; true' 2>&1 | mask

  echo ""
  echo "\$ /bin/bash --version | head -1"
  /bin/bash --version 2>&1 | head -1 | mask
} >"$sout"

# --- 2. Homebrew: presence, version, prefix, shellenv ---------
{
  echo "# transcript"
  echo "chapter: 03"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: Homebrew (as installed on the user's Mac)"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: read-only Homebrew inspection (no install runs)."
  echo "      On Apple Silicon the default prefix is"
  echo "      /opt/homebrew; \`brew shellenv\` prints the lines a"
  echo "      login shell evaluates to put /opt/homebrew/bin at"
  echo "      the FRONT of PATH. Those paths are under /opt, not"
  echo "      the user's home; \$HOME masking is applied anyway."
  echo "---"

  echo ""
  echo "\$ command -v brew"
  command -v brew 2>&1 | mask

  echo ""
  echo "\$ brew --version | head -1"
  brew --version 2>&1 | head -1 | mask

  echo ""
  echo "\$ brew --prefix"
  brew --prefix 2>&1 | mask

  echo ""
  echo "\$ brew shellenv"
  brew shellenv 2>&1 | mask
} >"$bout"

# --- 3. toolchain: CLT, git, BSD checksum, guarded tldr -------
{
  echo "# transcript"
  echo "chapter: 03"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: xcode-select; Apple git; shasum; tldr if installed"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: the Command Line Tools supply git and the compilers"
  echo "      on macOS; \`xcode-select -p\` prints their path."
  echo "      \`shasum -a 256\` is the BSD-side checksum tool; the"
  echo "      literal 'hello' digest matches the sandbox's GNU"
  echo "      sha256sum (ch03-checksum-linux.txt) byte for byte,"
  echo "      only the command name differs. tldr is recorded"
  echo "      ONLY if already installed (nothing is installed for"
  echo "      this script); if absent, the chapter documents +"
  echo "      quarantines the install recipe instead. \$HOME"
  echo "      masking applied; paths here are under /Library."
  echo "---"

  echo ""
  echo "\$ xcode-select -p"
  xcode-select -p 2>&1 | mask

  echo ""
  echo "\$ git --version"
  git --version 2>&1 | mask

  echo ""
  echo "\$ printf 'hello\\n' | shasum -a 256"
  printf 'hello\n' | shasum -a 256 2>&1 | mask

  echo ""
  if command -v tldr >/dev/null 2>&1; then
    echo "\$ tldr --version"
    tldr --version 2>&1 | mask
  else
    echo "\$ command -v tldr"
    echo "(tldr: not installed on this Mac; chapter will"
    echo " document + quarantine the tldr install recipe,"
    echo " not show a version)"
  fi
} >"$tout"

echo "captured -> $sout"
echo "captured -> $bout"
echo "captured -> $tout"
