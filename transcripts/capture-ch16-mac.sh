#!/usr/bin/env bash
# Capture the Ch 16 AI-CLI version stamps and the permission/
# sandbox flag evidence on the user's Mac.
#
# Ch 16 is principles-first and version-stamped. The one thing
# that MUST be a real, dated capture is the version anchor: the
# "current as of <date>" claim only means something if a real
# `--version` backs it. The permission/approval/sandbox behavior
# itself is pinned to each tool's official docs (see
# verification/chapter-16.md) and shown as labeled, non-runnable
# `text` blocks in the chapter, because a live agent session is
# non-deterministic and API-costing. This script captures only:
#   1. claude / codex / gemini --version, for all three tools;
#   2. the permission-relevant lines of each tool's --help, as
#      real evidence that the flags named in the chapter exist
#      (not as the authority for their semantics).
#
# All three CLIs (Claude Code, OpenAI Codex, Gemini) are installed
# on the user's Mac and captured here identically. They are still
# quarantined in the chapter by deliberate choice (volatile,
# non-deterministic, API-costing live sessions), not because any
# is missing; this script never starts a session.
#
# Run on the Mac, from the repo root:
#   bash source-private/terminal/transcripts/capture-ch16-mac.sh
# then review/commit the two ch16-*-mac.txt files it writes.
#
# Safe and read-only: it runs `--version` and `--help` only.
# It starts NO agent session, sends NO prompt, and touches no
# file outside transcripts/. No git is run.

# NOT `set -e`: a tool that errors on --help or is missing must be
# recorded, not treated as a fatal error.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vout="$here/ch16-versions-mac.txt"
hout="$here/ch16-help-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
today="$(date +%F)"

# --- 1. version stamps --------------------------------------
{
  echo "# transcript"
  echo "chapter: 16"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: zsh (login default)"
  echo "tool: Claude Code + OpenAI Codex + Gemini CLI"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: version anchor for the 'current as of ${today}'"
  echo "      stamp. All three CLIs are quarantined in the chapter"
  echo "      by choice (volatile, API-costing live sessions), not"
  echo "      because any is missing. Read-only: --version only."
  echo "---"

  echo ""
  echo "\$ claude --version"
  claude --version 2>&1 || echo "claude: not found"

  echo ""
  echo "\$ codex --version"
  codex --version 2>&1 || echo "codex: not found"

  echo ""
  echo "\$ gemini --version"
  gemini --version 2>&1 || echo "gemini: not found"
} >"$vout"

# --- 2. permission/sandbox flag evidence (installed tools) ---
# Grep the help for the flags the chapter names, so the shown
# flags are backed by real output. If a grep comes back empty
# (wording changed), that is itself a signal to re-pin the prose.
{
  echo "# transcript"
  echo "chapter: 16"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: zsh (login default)"
  echo "tool: Claude Code + OpenAI Codex + Gemini CLI"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: real evidence that the permission/approval/sandbox"
  echo "      flags named in the chapter exist. The SEMANTICS are"
  echo "      pinned to official docs (verification/chapter-16.md),"
  echo "      not to this help text, which is version-volatile."
  echo "---"

  echo ""
  echo "\$ claude --help | grep -iE 'permission|dangerous'"
  claude --help 2>&1 | grep -iE 'permission|dangerous' \
    || echo "(no matching lines; re-check claude --help wording)"

  echo ""
  echo "\$ codex --help | grep -iE 'sandbox|approval|approve|yolo'"
  codex --help 2>&1 | grep -iE 'sandbox|approval|approve|yolo' \
    || echo "(no matching lines; re-check codex --help wording)"

  # Functional proof that Codex accepts the --yolo alias, even if
  # `codex --help` prints only the long
  # --dangerously-bypass-approvals-and-sandbox form (round-5 audit).
  echo ""
  echo "\$ codex --yolo --version   # does the alias parse?"
  codex --yolo --version 2>&1 \
    || echo "(codex --yolo not accepted; alias is docs-only)"

  echo ""
  echo "\$ gemini --help | grep -iE 'approval|yolo|sandbox|allowed-tools'"
  gemini --help 2>&1 \
    | grep -iE 'approval|yolo|sandbox|allowed-tools' \
    || echo "(no matching lines; re-check gemini --help wording)"
} >"$hout"

echo "captured -> $vout"
echo "captured -> $hout"
