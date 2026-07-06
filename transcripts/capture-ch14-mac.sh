#!/usr/bin/env bash
# Capture the Ch 14 (persistent sessions / tmux) fact that the
# Linux sandbox cannot show: that a tmux session on a REMOTE
# server outlives the ssh connection that started it.
#
# The sandbox already captured the portable, semantics-only
# material (ch14-coreloop.txt, ch14-progress.txt,
# ch14-structure.txt, ch14-sendkeys.txt, ch14-screen.txt): the
# core loop, a job progressing while detached, the
# session/window/pane structure, send-keys/capture-pane, and the
# screen version. Those need no network and behave the same on
# the server. THIS script captures the one thing only a real
# laptop -> server round-trip can prove:
#
#   1. ch14-versions-mac.txt - the Mac's tmux (and screen)
#                              version, for the DIVERGENCE / stamp.
#   2. ch14-server-mac.txt   - the survive-a-disconnect demo. A
#                              stepwise job is started in a DETACHED
#                              tmux session over ONE ssh one-shot,
#                              then SEPARATE ssh one-shots (each a
#                              fresh connection = a "reconnect")
#                              run `tmux ls` and `tmux capture-pane`
#                              and show the job still running and
#                              ADVANCING, with its `tee` log intact
#                              (Ch 10). The session is killed and
#                              the log removed at the end.
#
# The whole point is captured structurally: connection A starts
# the session and returns; connections B, C, D are independent
# ssh invocations that find the session still there. No single
# ssh session stays open across the job, so nothing depends on
# the connection surviving - which is exactly the claim.
#
# Usage, from the terminal repo root (source-private/terminal),
# passing YOUR ssh alias for the server (the Host in ~/.ssh/config):
#
#   bash transcripts/capture-ch14-mac.sh <ssh-alias>
#   # e.g. bash transcripts/capture-ch14-mac.sh lab-server
#
# then paste back (or say "done") and the chapter is reconciled
# against the two ch14-*-mac.txt files byte-for-byte.
#
# PRIVACY: this TRACKED script hardcodes NO personal data. It
# derives the server hostname, account, home, and any literal IP
# at runtime and MASKS them at capture time (the Ch 13 mask()),
# and uses only session/job names the book chose (`job`). All ssh
# calls are non-interactive one-shots (BatchMode); NO interactive
# `ssh` + `tmux attach` (that would take over the terminal and
# hang, the Ch 9 lesson). It writes only under transcripts/ and a
# throwaway ~/ch14-job.log on the server, removed at the end.
# Nothing is installed on either machine.

# NOT set -e: a remote hiccup must be RECORDED, not abort capture.
set -uo pipefail
unset VIRTUAL_ENV

SERVER="${1:?usage: bash transcripts/capture-ch14-mac.sh <ssh-alias>}"
SSHO=(-o BatchMode=yes -o ConnectTimeout=15)

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
today="$(date +%F)"
macct="$(id -un)"
machost="$(scutil --get LocalHostName 2>/dev/null \
  || hostname -s 2>/dev/null || true)"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"

# --- fail fast if the alias is unreachable (better than a hang) ---
if ! ssh "${SSHO[@]}" "$SERVER" true 2>/dev/null; then
  echo "ERROR: cannot ssh to '$SERVER' non-interactively." >&2
  echo "Load your key into the agent (ssh-add) and confirm" >&2
  echo "'ssh $SERVER true' works, then re-run." >&2
  exit 1
fi

# --- derive the identifiers to mask (live, nothing hardcoded) ---
rhost="$(ssh "${SSHO[@]}" "$SERVER" 'hostname' 2>/dev/null)"
racct="$(ssh "${SSHO[@]}" "$SERVER" 'id -un' 2>/dev/null)"
rhome="$(ssh "${SSHO[@]}" "$SERVER" 'printf %s "$HOME"' 2>/dev/null)"

MASK=(-E
  -e "s|${HOME}|/Users/[account]|g"
  -e "s|${macct}|[account]|g")
[ -n "${machost:-}" ] && MASK+=(-e "s|${machost}|[hostname]|g")
[ -n "${rhome:-}" ]  && MASK+=(-e "s|${rhome}|~|g")
[ -n "${rhost:-}" ]  && MASK+=(-e "s|${rhost}|[hostname]|g")
[ -n "${racct:-}" ]  && MASK+=(-e "s|${racct}|[account]|g")
MASK+=(-e "s|${SERVER}|lab-server|g"
  -e 's|([0-9]{1,3}\.){3}[0-9]{1,3}|[ip]|g'
  -e 's/[[:blank:]]+$//')
mask() { sed "${MASK[@]}"; }

hdr() {
  # hdr <tool-line> <noteline...>
  echo "# transcript"
  echo "chapter: 14"
  echo "os: ${os_name} ${os_ver} (Apple Silicon) + remote Linux server"
  echo "shell: ${zver} (login default)"
  echo "tool: $1"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  shift
  for ln in "$@"; do echo "note: ${ln}"; done
  echo "---"
}

# =============================================================
# 1. Mac tmux (+ screen) versions
# =============================================================
{
  hdr "macOS tmux + screen" \
    "The Mac's own tmux (Homebrew) and screen versions, for the" \
    "version stamp; the Linux side is in ch14-screen.txt. No" \
    "personal data in these version lines."
  echo "\$ tmux -V"
  tmux -V 2>&1 | mask
  echo "\$ screen --version"
  screen --version 2>&1 | mask
} > "$here/ch14-versions-mac.txt"

# =============================================================
# 2. Survive-a-disconnect: detached session on the server,
#    inspected by SEPARATE ssh connections.
# =============================================================
# strip: drop trailing whitespace and trailing blank pad-lines
# (capture-pane pads a pane to full height).
strip() {
  sed -e 's/[[:blank:]]*$//' \
    | awk 'BEGIN{n=0}{L[n++]=$0}
      END{last=n-1;while(last>=0&&L[last]==""){last--};
      for(i=0;i<=last;i++)print L[i]}'
}

# Clean any stale demo session/log first.
ssh "${SSHO[@]}" "$SERVER" \
  'tmux kill-session -t job 2>/dev/null; rm -f ~/ch14-job.sh ~/ch14-job.log' \
  2>/dev/null

# The job is a small book-provided stand-in for a slow analysis
# step: it counts to 30, printing a line every 2s (~60s total),
# and tees a log (Ch 10). Write it to the server with a QUOTED
# heredoc so $i / $(seq) reach the server intact (no nested-quote
# display problem, and the shown command stays a clean
# `bash ch14-job.sh`).
ssh "${SSHO[@]}" "$SERVER" 'cat > ~/ch14-job.sh' <<'REMOTE_JOB'
for i in $(seq 1 30); do
  echo "step $i/30 done"
  sleep 2
done | tee ~/ch14-job.log
REMOTE_JOB

{
  hdr "tmux over ssh (survive-a-disconnect)" \
    "Connection A starts a detached tmux session running a stepwise" \
    "job (ch14-job.sh, a book-provided counter that tees a log, Ch" \
    "10). Connections B, C, D are SEPARATE ssh one-shots (each opens" \
    "and closes its own connection) that find the session still" \
    "running and ADVANCING, then read the intact log. No connection" \
    "stays open across the job. hostname, account, home, and any IP" \
    "are masked at capture time; the session and job names are the" \
    "book's own. In tmux ls, the author's unrelated pre-existing" \
    "sessions are filtered out at capture time, leaving only the" \
    "demo session job."
  echo "# Connection A: start the job in a DETACHED session, then return."
  echo "\$ ssh lab-server 'tmux new-session -d -s job \"bash ch14-job.sh\"'"
  ssh "${SSHO[@]}" "$SERVER" \
    'tmux new-session -d -s job "bash ch14-job.sh"' 2>&1 | mask
  sleep 5
  echo ""
  echo "# Connection B (a fresh ssh): the session outlived connection A."
  echo "\$ ssh lab-server 'tmux ls'"
  ssh "${SSHO[@]}" "$SERVER" 'tmux ls' 2>&1 | grep -E '^job:' | mask
  echo ""
  echo "# Connection C (another fresh ssh): read the pane, no attach."
  echo "\$ ssh lab-server 'tmux capture-pane -t job -p'"
  ssh "${SSHO[@]}" "$SERVER" 'tmux capture-pane -t job -p' 2>&1 \
    | strip | mask
  sleep 12
  echo ""
  echo "# Connection D (later, fresh ssh): the job has MOVED ON by itself."
  echo "\$ ssh lab-server 'tmux capture-pane -t job -p'"
  ssh "${SSHO[@]}" "$SERVER" 'tmux capture-pane -t job -p' 2>&1 \
    | strip | mask
  echo ""
  echo "# The Ch 10 log survives independently of the session:"
  echo "\$ ssh lab-server 'tail -3 ~/ch14-job.log'"
  ssh "${SSHO[@]}" "$SERVER" 'tail -3 ~/ch14-job.log' 2>&1 | mask
  echo ""
  echo "# Clean up: end the session and remove the demo files."
  echo "\$ ssh lab-server 'tmux kill-session -t job'"
  ssh "${SSHO[@]}" "$SERVER" 'tmux kill-session -t job' 2>&1 | mask
} > "$here/ch14-server-mac.txt"

ssh "${SSHO[@]}" "$SERVER" 'rm -f ~/ch14-job.sh ~/ch14-job.log' 2>/dev/null

for f in versions server; do
  echo "captured -> $here/ch14-${f}-mac.txt"
done
