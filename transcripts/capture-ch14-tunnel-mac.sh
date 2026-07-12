#!/usr/bin/env bash
# Re-capture ONLY the Ch 14 ssh -L port-forward demo.
#
# The main capture-ch14-mac.sh runs the tunnel inline as
# `ssh -f -L ... 'timeout N python3 -m http.server'`, which raced
# the server's startup and produced an empty curl. This script
# separates the two steps for reliability: start a short-lived
# http.server on the server first, THEN open a background tunnel
# (ssh -fN, no remote command), then curl through it. ~30 seconds,
# no compile.
#
# Usage, from the terminal repo root, with YOUR ssh alias:
#   bash transcripts/capture-ch14-tunnel-mac.sh <ssh-alias>
#
# It writes transcripts/ch14-tunnel-mac.txt (overwriting the empty
# one). Server identifiers are derived live and masked; the only
# content is a demo directory listing. It creates and deletes a
# throwaway ~/ch14-tunnel-demo on the server and kills both the
# server process and the local tunnel at the end.

set -uo pipefail

SERVER="${1:?usage: bash transcripts/capture-ch14-tunnel-mac.sh <ssh-alias>}"
SSHO=(-o BatchMode=yes -o ConnectTimeout=15)
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
today="$(date +%F)"
macct="$(id -un)"
machost="$(scutil --get LocalHostName 2>/dev/null || hostname -s 2>/dev/null || true)"

if ! ssh "${SSHO[@]}" "$SERVER" true 2>/dev/null; then
  echo "ERROR: cannot ssh to '$SERVER' non-interactively." >&2
  exit 1
fi

rhost="$(ssh "${SSHO[@]}" "$SERVER" 'hostname' 2>/dev/null)"
racct="$(ssh "${SSHO[@]}" "$SERVER" 'id -un' 2>/dev/null)"
rhome="$(ssh "${SSHO[@]}" "$SERVER" 'printf %s "$HOME"' 2>/dev/null)"

MASK=(-E
  -e "s|${HOME}|/Users/[account]|g"
  -e "s|${macct}|[account]|g")
[ -n "${machost:-}" ] && MASK+=(-e "s|${machost}|[hostname]|g")
[ -n "${rhome:-}" ]   && MASK+=(-e "s|${rhome}|~|g")
[ -n "${rhost:-}" ]   && MASK+=(-e "s|${rhost}|[hostname]|g")
[ -n "${racct:-}" ]   && MASK+=(-e "s|${racct}|[account]|g")
MASK+=(-e "s|${SERVER}|lab-server|g"
  -e 's|([0-9]{1,3}\.){3}[0-9]{1,3}|[ip]|g'
  -e 's/[[:blank:]]+$//')
mask() { sed "${MASK[@]}"; }

LP=8899
# Ask the server for a guaranteed-free ephemeral port, so the demo
# http.server can't collide with an existing service (e.g. a
# JupyterHub already bound to 8000).
RP="$(ssh "${SSHO[@]}" "$SERVER" python3 - <<'PYEOF' 2>/dev/null
import socket
s = socket.socket(); s.bind(("127.0.0.1", 0))
print(s.getsockname()[1]); s.close()
PYEOF
)"
RP="${RP:-8791}"
demo="ch14-tunnel-demo"

# 1. Start a short-lived http.server on the server, serving a small
#    demo dir. timeout kills it; nohup + detached subshell so the
#    one-shot ssh returns immediately.
ssh "${SSHO[@]}" "$SERVER" "rm -rf ~/${demo} && mkdir -p ~/${demo} \
  && printf 'served from the server via the tunnel\n' \
     > ~/${demo}/HELLO.txt \
  && printf 'print(1)\n' > ~/${demo}/step.py \
  && cd ~/${demo} \
  && (nohup timeout 30 python3 -m http.server ${RP} \
       >/tmp/ch14hs.log 2>&1 &) ; sleep 1" >/dev/null 2>&1

# 2. Open a background tunnel (no remote command, -N).
ssh -fN "${SSHO[@]}" -L ${LP}:localhost:${RP} "$SERVER" 2>/dev/null
sleep 2

# 3. Reach the server-side server THROUGH the tunnel.
{
  echo "# transcript"
  echo "chapter: 14"
  echo "os: macOS (Apple Silicon) + remote Linux server"
  echo "shell: zsh (login default)"
  echo "tool: OpenSSH ssh -L (port forward)"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  echo "note: ssh -fN -L ${LP}:localhost:${RP} opens a background"
  echo "note: tunnel; a short-lived python3 -m http.server on the"
  echo "note: server (timeout-killed) is reached with curl THROUGH"
  echo "note: the tunnel at localhost:${LP}. Started as two separate"
  echo "note: steps (server, then tunnel) for reliability. Only demo"
  echo "note: filenames appear; host/account/ip masked."
  echo "---"
  echo "# open the tunnel in the background (no remote shell):"
  echo "\$ ssh -fN -L ${LP}:localhost:${RP} lab-server"
  echo "# reach the server-side http.server THROUGH the tunnel:"
  echo "\$ curl -s http://localhost:${LP}/ | sed -n '1,12p'"
  curl -s "http://localhost:${LP}/" 2>&1 | sed -n '1,12p' | mask
} > "$here/ch14-tunnel-mac.txt"

# 4. Cleanup: close the tunnel, stop the server, remove the dir.
pkill -f "ssh -fN .*-L ${LP}:localhost:${RP} ${SERVER}" 2>/dev/null || true
ssh "${SSHO[@]}" "$SERVER" \
  "pkill -f 'http.server ${RP}' 2>/dev/null; rm -rf ~/${demo}" \
  2>/dev/null || true

echo "captured -> $here/ch14-tunnel-mac.txt"
echo "----------"
cat "$here/ch14-tunnel-mac.txt"
