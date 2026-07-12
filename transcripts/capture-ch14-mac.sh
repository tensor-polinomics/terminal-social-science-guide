#!/usr/bin/env bash
# Capture the Ch 14 (SSH & remote compute) facts that the Linux
# sandbox cannot produce: the macOS SSH/rsync client, and every
# real interaction with the user's remote Linux server.
#
# The sandbox already captured the portable, semantics-only
# material (ch14-versions.txt, ch14-rsync-move.txt, ch14-keygen.txt,
# ch14-bundle.txt, ch14-space.txt): rsync's trailing-slash and
# --delete behavior, a throwaway ssh-keygen demo, tar/gzip, and du.
# Those need no network. THIS script captures what only a real
# laptop -> server round-trip can show:
#
#   1. ch14-versions-mac.txt   - the Mac's ssh + rsync versions
#                                (macOS ships openrsync, the
#                                DIVERGENCE against Linux GNU rsync).
#   2. ch14-divergence-mac.txt - probe whether GNU-only rsync flags
#                                (--itemize-changes, -z) exist on the
#                                Mac's openrsync (they are ACCEPTED on
#                                current macOS; the divergence is the
#                                implementation/protocol, not a flag
#                                failure), captured live.
#   3. ch14-config-mac.txt     - the effective ~/.ssh/config for the
#                                server alias (via ssh -G) and the
#                                local ~/.ssh permissions.
#   4. ch14-server-mac.txt     - ssh one-shots on the server:
#                                uname, df, and ~/.ssh permissions.
#   5. ch14-transfer-mac.txt   - a real rsync push of the project
#                                (excluding .venv/ and renv/library/,
#                                the Ch 13 "commit the lock, not the
#                                environment" line) into a throwaway
#                                ~/ch14-demo, a checksum of the moved
#                                data on both machines (shasum -a 256
#                                vs sha256sum), and a pull back.
#   6. ch14-restore-mac.txt    - rebuild the environment on arrival:
#                                uv sync (fast) and renv::restore()
#                                (compiles from the lock; the long
#                                pole, ~15 min).
#   7. ch14-tunnel-mac.txt     - an ssh -L port forward to a
#                                server-side python3 -m http.server,
#                                reached with curl through the tunnel.
#
# Usage, from the terminal repo root (source-private/terminal),
# passing YOUR ssh alias for the server (the Host name in your
# ~/.ssh/config):
#
#   bash transcripts/capture-ch14-mac.sh <ssh-alias>
#   # e.g. bash transcripts/capture-ch14-mac.sh lab-server
#
# then paste back (or say "done") and the chapter is reconciled
# against the seven ch14-*-mac.txt files byte-for-byte.
#
# PRIVACY: this TRACKED script hardcodes NO personal data. It
# derives the server hostname, account, home, mount point, device,
# and any literal IP at runtime and MASKS them at capture time
# (the Ch 13 mask() plus a remote-identifier set), so the server's
# identity never lands in the repo. All ssh calls are
# non-interactive one-shots (BatchMode; no interactive remote
# shell, so nothing hangs over ssh, the Ch 10 lesson). It writes
# only under transcripts/ and a throwaway ~/ch14-demo on the
# server, which it deletes at the end. Nothing is installed on the
# Mac; renv bootstrap on the SERVER installs into the throwaway
# copy only.

# NOT set -e: a remote hiccup (a slow compile, a missing package)
# must be RECORDED in the transcript, not abort the capture.
set -uo pipefail
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

SERVER="${1:?usage: bash transcripts/capture-ch14-mac.sh <ssh-alias>}"
SSHO=(-o BatchMode=yes -o ConnectTimeout=15)

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project="$here/../sandbox/asset-pricing"
today="$(date +%F)"
macct="$(id -un)"
# The Mac's own hostname can appear inside ~/.ssh filenames
# (e.g. environment-<LocalHostName>), which the server-derived
# masks below do not cover; scrub it too.
machost="$(scutil --get LocalHostName 2>/dev/null || hostname -s 2>/dev/null || true)"

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
rmount="$(ssh "${SSHO[@]}" "$SERVER" \
  'df -P "$HOME" | tail -1 | awk "{print \$6}"' 2>/dev/null)"
rdev="$(ssh "${SSHO[@]}" "$SERVER" \
  'df -P "$HOME" | tail -1 | awk "{print \$1}"' 2>/dev/null)"

# Build the mask in order: home before mount/account (home CONTAINS
# both as substrings), literal IPs last. A trailing-blank strip
# keeps aligned tables from tripping the whitespace check.
MASK=(-E
  -e "s|${HOME}|/Users/[account]|g"
  -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g"
  -e "s|${macct}|[account]|g")
[ -n "${machost:-}" ] && MASK+=(-e "s|${machost}|[hostname]|g")
[ -n "${rhome:-}" ]  && MASK+=(-e "s|${rhome}|~|g")
[ -n "${rmount:-}" ] && [ "${rmount:-}" != "/" ] && \
  MASK+=(-e "s|${rmount}|[mount]|g")
[ -n "${rdev:-}" ]   && MASK+=(-e "s|${rdev}|[device]|g")
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
# 1. Mac ssh + rsync versions (the openrsync DIVERGENCE)
# =============================================================
{
  hdr "macOS OpenSSH + openrsync" \
    "macOS ships openrsync (an OpenBSD reimplementation) and a" \
    "newer OpenSSH than the Linux sandbox; the sandbox side is in" \
    "ch14-versions.txt. No personal data in these version lines."
  echo "\$ ssh -V"
  ssh -V 2>&1 | mask
  echo "\$ rsync --version | head -2"
  rsync --version 2>&1 | head -2 | mask
} > "$here/ch14-versions-mac.txt"

# =============================================================
# 2. Probe GNU-only rsync flags on the Mac's openrsync (accepted
#    on current macOS; the divergence is implementation/protocol)
# =============================================================
scratch="$(mktemp -d)"
mkdir -p "$scratch/src"; printf 'x\n' > "$scratch/src/a.txt"
{
  hdr "openrsync (option coverage)" \
    "Probe whether GNU-only rsync flags exist on macOS openrsync." \
    "On current macOS both --itemize-changes and -z are ACCEPTED," \
    "so the divergence is the implementation/protocol (openrsync" \
    "proto 29 vs GNU proto 31), not a flag failure. Scratch paths" \
    "masked; no network, no personal data."
  echo "\$ rsync -a --itemize-changes src/ dst"
  ( cd "$scratch" && rsync -a --itemize-changes src/ dst 2>&1 ) | mask
  echo "\$ rsync -az src/ dst"
  ( cd "$scratch" && rsync -az src/ dst 2>&1 ) | mask
} > "$here/ch14-divergence-mac.txt"
rm -rf "$scratch"

# =============================================================
# 3. Effective ssh config for the alias + local ~/.ssh perms
# =============================================================
{
  hdr "OpenSSH ssh_config (ssh -G) + local ~/.ssh perms" \
    "ssh -G prints the config the alias resolves to; the real" \
    "hostname/user are masked. The chapter shows the config-file" \
    "FORM as a labeled template. ~/.ssh permissions are the" \
    "PITFALL evidence (700 dir, 600 keys)."
  echo "\$ ssh -G lab-server | grep -Ei '^(hostname|user|port|identityfile) '"
  ssh -G "$SERVER" 2>/dev/null \
    | grep -Ei '^(hostname|user|port|identityfile) ' | mask
  echo "\$ ls -l ~/.ssh"
  ls -l "$HOME/.ssh" 2>&1 | mask
} > "$here/ch14-config-mac.txt"

# =============================================================
# 4. Server one-shots: uname, df, ~/.ssh perms
# =============================================================
{
  hdr "remote Linux (ssh one-shots)" \
    "Non-interactive ssh lab-server 'cmd' one-shots. hostname, IP," \
    "account, home, mount, and device are all masked at capture" \
    "time. Shows the server is just another Linux box, plus the" \
    "server-side ~/.ssh permission evidence."
  echo "\$ ssh lab-server 'uname -a'"
  ssh "${SSHO[@]}" "$SERVER" 'uname -a' 2>&1 | mask
  echo "\$ ssh lab-server 'df -h \$HOME'"
  ssh "${SSHO[@]}" "$SERVER" 'df -h "$HOME"' 2>&1 | mask
  echo "\$ ssh lab-server 'ls -ld ~/.ssh; ls -l ~/.ssh'"
  ssh "${SSHO[@]}" "$SERVER" 'ls -ld ~/.ssh; ls -l ~/.ssh' 2>&1 | mask
} > "$here/ch14-server-mac.txt"

# =============================================================
# 5. Real transfer: push (excluding the built environments),
#    checksum both ends, pull back.
# =============================================================
demo="ch14-demo"
ssh "${SSHO[@]}" "$SERVER" "rm -rf ~/${demo} && mkdir -p ~/${demo}" 2>/dev/null
pullback="$(mktemp -d)"
{
  hdr "rsync push/pull + cross-machine checksum" \
    "rsync -av EXCLUDING .venv/ and renv/library/: the lockfiles" \
    "(uv.lock, renv.lock) travel; the built environments do NOT" \
    "(Ch 13). Then the moved CSVs are checksummed on both ends" \
    "(Mac shasum -a 256 vs server sha256sum) to prove the bytes" \
    "survived (Ch 11's manifest idea, across machines). All paths" \
    "and the transfer's host: prefixes are masked."
  echo "\$ rsync -av --exclude='.venv' --exclude='renv/library' \\"
  echo "    sandbox/asset-pricing/ lab-server:${demo}/"
  ( cd "$project" && rsync -av \
      --exclude='.venv' --exclude='renv/library' \
      ./ "$SERVER:${demo}/" 2>&1 ) | mask | tail -25
  echo ""
  echo "# Checksum the transferred CSVs on the SERVER:"
  echo "\$ ssh lab-server 'cd ${demo} && find . -name \"*.csv\" | sort \\"
  echo "    | xargs sha256sum'"
  ssh "${SSHO[@]}" "$SERVER" \
    "cd ${demo} && find . -name '*.csv' | sort | xargs sha256sum" \
    2>&1 | mask
  echo ""
  echo "# ...and on the MAC with shasum -a 256 (Ch 3's divergence):"
  echo "\$ find . -name '*.csv' | sort | xargs shasum -a 256"
  ( cd "$project" && find . -name '*.csv' \
      -not -path './.venv/*' -not -path './renv/*' \
      | sort | xargs shasum -a 256 2>&1 ) | mask
  echo ""
  echo "# Pull one directory back to show the reverse direction:"
  echo "\$ rsync -av lab-server:${demo}/scripts/ /tmp/pull/"
  rsync -av "$SERVER:${demo}/scripts/" "$pullback/" 2>&1 \
    | mask | tail -12
} > "$here/ch14-transfer-mac.txt"
rm -rf "$pullback"

# =============================================================
# 6. Rebuild the environment on arrival: uv sync + renv::restore
#    (the renv restore COMPILES from source; this is the ~15-min
#    long pole. NOT set -e, so a failure is recorded.)
# =============================================================
{
  hdr "uv sync + renv::restore() on the server" \
    "The Ch 13 payoff, live on the server: uv sync rebuilds the" \
    "Python env from uv.lock (wheels, fast); renv::restore()" \
    "bootstraps renv and rebuilds the R library from renv.lock" \
    "(compiles from source, several minutes). The server R is" \
    "4.5.2 vs the lock's 4.5.3, same R-4.5 library, so restore" \
    "proceeds with a version notice, itself the Ch 13 point that" \
    "versions pin packages, not R. Long install logs are captured" \
    "in full here; the chapter shows a contiguous slice."
  echo "\$ ssh lab-server 'cd ${demo} && ~/.local/bin/uv sync'"
  ssh "${SSHO[@]}" "$SERVER" \
    "cd ${demo} && ~/.local/bin/uv sync" 2>&1 | mask
  echo ""
  echo "\$ ssh lab-server 'cd ${demo} && Rscript -e \"renv::restore(prompt=FALSE)\"'"
  ssh "${SSHO[@]}" "$SERVER" \
    "cd ${demo} && Rscript -e 'renv::restore(prompt = FALSE)'" \
    2>&1 | mask
} > "$here/ch14-restore-mac.txt"

# =============================================================
# 7. Port forward: ssh -L to a server-side http.server, via curl
# =============================================================
{
  hdr "ssh -L port forward" \
    "ssh -L 8899:localhost:8000 forwards a local port to a" \
    "service bound to the server's own localhost. A short-lived" \
    "python3 -m http.server on the server (timeout-killed) serves" \
    "the demo dir; curl reaches it THROUGH the tunnel at" \
    "localhost:8899. Filenames only; masked."
  echo "\$ ssh -f -L 8899:localhost:8000 lab-server \\"
  echo "    'cd ${demo} && timeout 20 python3 -m http.server 8000'"
  ssh -f "${SSHO[@]}" -L 8899:localhost:8000 "$SERVER" \
    "cd ${demo} && timeout 20 python3 -m http.server 8000 \
     >/dev/null 2>&1" 2>&1 | mask
  sleep 3
  echo "\$ curl -s http://localhost:8899/ | head -15"
  curl -s http://localhost:8899/ 2>&1 | head -15 | mask
  sleep 20
} > "$here/ch14-tunnel-mac.txt"

# =============================================================
# Cleanup: remove the throwaway server dir.
# =============================================================
ssh "${SSHO[@]}" "$SERVER" "rm -rf ~/${demo}" 2>/dev/null

for f in versions divergence config server transfer restore tunnel; do
  echo "captured -> $here/ch13-${f}-mac.txt"
done
