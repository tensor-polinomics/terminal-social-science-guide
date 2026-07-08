#!/usr/bin/env bash
# Ch 17 remote-shell startup seam: "works in terminal, fails over
# SSH". Captured from the Mac against the user's real Linux server
# (the same class of box as Ch 13). A non-interactive
# `ssh host 'cmd'` runs a shell that does NOT read the login/
# interactive startup files, so PATH is the bare server default
# and tools installed in ~/.local/bin are not found; forcing a
# login shell (`bash -lc`) reads the profile and PATH is restored.
# It runs echo / command -v only and writes nothing on the
# server. Note the `bash -lc` form DOES execute the server's real
# login profile (that is the point of the demo); it reads the
# profile but captures only the resulting PATH, which is masked.
#
# Usage, from the terminal repo root (source-private/terminal):
#   bash transcripts/capture-ch17-ssh-mac.sh <user@host>
# e.g.  bash transcripts/capture-ch17-ssh-mac.sh lab-server
#
# PRIVACY: the server account, home path, and hostname are masked
# at capture time to [account] / /home/[account] / [hostname],
# and any machine-specific /mnt mount path to /mnt/[mount].
set -uo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <user@host>" >&2
  exit 2
fi
HOST="$1"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
today="$(date +%F)"
out="$here/ch17-ssh-seam-mac.txt"

# Learn the remote account, HOME path, and hostname once, to mask
# them out. The home may NOT be under /home (e.g. /mnt/.../<user>),
# so mask the real $HOME path, not a guessed /home/<user>.
ruser="$(ssh "$HOST" 'printf %s "$USER"' 2>/dev/null || echo user)"
rhome="$(ssh "$HOST" 'printf %s "$HOME"' 2>/dev/null || echo /home/user)"
rhost="$(ssh "$HOST" 'hostname -s 2>/dev/null || hostname' 2>/dev/null || echo host)"

# BSD sed (macOS) has NO \b word boundary, so use plain global
# substitutions. Mask the real remote HOME path FIRST (a home not
# under /home, e.g. /mnt/<vol>/<user>/.local/bin, becomes
# /home/[account]/.local/bin), then any bare account or hostname
# token, then any machine-specific /mnt mount path.
mask() {
  sed -e "s|${rhome}|/home/[account]|g" \
      -e "s|${ruser}|[account]|g" \
      -e "s|${rhost}|[hostname]|g" \
      -e "s|${HOST}|[hostname]|g" \
      -e "s|/mnt/[^: ]*|/mnt/[mount]|g"
}

# run <remote-command-string>: display line uses the EXACT string
# sent to ssh (so the shown command is byte-identical to what ran,
# only the host is shown masked as [hostname]).
run() {
  echo ""
  echo "\$ ssh [hostname] '$1'"
  ssh "$HOST" "$1" 2>&1 | mask
}

{
  echo "# transcript"
  echo "chapter: 17"
  echo "os: Linux (user's remote server, over ssh)"
  echo "shell: bash (server login shell)"
  echo "tool: OpenSSH client -> remote bash"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: A non-interactive ssh 'cmd' skips the login/rc files;"
  echo "note: forcing bash -lc DOES execute the server's real login"
  echo "note: profile (this is read-only in the sense that it runs"
  echo "note: only echo / command -v and writes nothing, but it does"
  echo "note: read the server's profile; only the resulting PATH is"
  echo "note: captured). Remote account/home/hostname masked to"
  echo "note: [account] / /home/[account] / [hostname]; machine-"
  echo "note: specific /mnt mount paths to /mnt/[mount]."
  echo "---"
  run 'echo $PATH'
  run 'command -v uv || echo "uv: not found"'
  run 'bash -lc "echo \$PATH"'
  run 'bash -lc "command -v uv || echo \"uv: not found\""'
} > "$out"

echo "captured -> $out"
echo "review it, then paste it back."
