#!/usr/bin/env bash
# Capture the Ch 9 (Processes, permissions & secrets) macOS/BSD
# facts on the user's Mac.
#
# Ch 9's portable/GNU output (background jobs, signals, chmod,
# env inheritance, the ps arg leak, bash shell-history hygiene,
# the .gitignore read) is captured in the book's Linux sandbox
# (ch09-*.txt). This script captures the two things the sandbox
# cannot, and BOTH are ordinary non-interactive commands (no
# interactive shell is driven, so nothing hangs on a real
# terminal):
#   1. ch09-chown-mac.txt - chown/chgrp ownership. Changing a
#      file's OWNER to another user needs root even on macOS, so
#      this shows the privilege-free chown-to-yourself plus the
#      honest un-privileged failure (chown to another user) as
#      the evidence that ownership is privileged. No sudo is run.
#      ls -l and a chgrp change are recorded for reference below
#      the block the chapter shows.
#   2. ch09-ps-mac.txt   - BSD `ps` exposes command-line args
#      exactly as GNU ps does, confirming the leak is not a
#      Linux-only quirk.
#
# (Interactive shell history is NOT captured here. It is a
# per-shell interactive feature; driving an interactive zsh/bash
# from a script on a real terminal makes the shell read the
# keyboard, not the script, so it hangs. The bash form is shown
# from the Linux sandbox instead, and the zsh form is pinned to
# the zsh manual in verification/chapter-09.md.)
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal), the way ch04/ch07/ch08 were run:
#   bash transcripts/capture-ch09-mac.sh
# then review the two ch09-*-mac.txt files it writes and paste
# them back (or just say "done" and let the chapter be
# reconciled against them).
#
# Requirements: zsh on PATH (for the transcript header only) and
# python3 (for the ps demo). Its only writes are mktemp scratch
# dirs (removed on exit) and the transcripts/ folder. Nothing is
# installed, no sudo is run, and no real credential is touched.

# NOT set -e: the un-privileged `chown` is EXPECTED to fail and
# must be recorded, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub,
# transcripts/README.md; same helper as capture-ch08-mac.sh
# incl. the $TMPDIR folder-hash scrub). Ch 9 is extra
# exposure-prone: ls -l / id / ps print the account name, so the
# account mask matters here in particular.
acct="$(id -un)"
mask() {
  sed -E \
    -e "s|${HOME}|/Users/[account]|g" \
    -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
    -e "s|${acct}|[account]|g"
}

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cout="$here/ch09-chown-mac.txt"
pout="$here/ch09-ps-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

hdr() {
  # hdr <toolline> <noteline...>
  echo "# transcript"
  echo "chapter: 09"
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
# 1. chown / chgrp ownership.
# =============================================================
cscratch="$(mktemp -d "${TMPDIR:-/tmp}/ch09chown.XXXXXX")"
cd "$cscratch" || exit 1
echo "fake key material" > key.pem

# A group the account already belongs to but that differs from
# the file's current group, if one exists (for a visible chgrp).
curgrp="$(stat -f '%Sg' key.pem)"
altgrp=""
for g in $(id -Gn); do
  if [ "$g" != "$curgrp" ]; then altgrp="$g"; break; fi
done

{
  hdr "BSD chown/chgrp (macOS base)" \
    "Changing a file's OWNER to another user needs root even on" \
    "macOS, so this shows the privilege-free parts and the" \
    "honest un-privileged failure. No sudo is run. The account" \
    "name is masked to [account]; standard group names (staff," \
    "admin, ...) are not user-identifying and are left as-is." \
    "The chapter shows the two chown lines and the failure" \
    "contiguously; ls -l and a chgrp change are recorded below" \
    "the chapter's block for reference."
  echo ""
  echo "\$ chown \"\$(id -un)\" key.pem      # to yourself: allowed"
  chown "$(id -un)" key.pem 2>&1 | mask
  echo "\$ chown daemon key.pem           # to another user: denied"
  out="$(chown daemon key.pem 2>&1)"; st=$?
  printf '%s\n' "$out" | mask
  echo "\$ echo \$?"
  echo "$st"
  echo ""
  echo "# --- for reference (not shown in the chapter) ---"
  echo "\$ ls -l key.pem"
  ls -l key.pem | mask
  if [ -n "$altgrp" ]; then
    echo "\$ chgrp ${altgrp} key.pem"
    chgrp "$altgrp" key.pem 2>&1 | mask
    echo "\$ ls -l key.pem"
    ls -l key.pem | mask
  fi
} > "$cout"

cd "$here" || exit 1
rm -rf "$cscratch"

# =============================================================
# 2. BSD ps exposes command-line args too.
# =============================================================
python3 -c 'import time; time.sleep(30)' --password=hunter2 &
pspid=$!
sleep 0.5
{
  hdr "BSD ps (macOS base)" \
    "macOS ships BSD ps; Linux ships procps-ng. A secret in a" \
    "command's args is exposed by ps on both. ps aux (BSD form)" \
    "works on both platforms; ps -ef (System V) is the GNU" \
    "idiom. hunter2 is a fake placeholder. ps -o pid,args prints" \
    "no owner column, so nothing is masked."
  echo ""
  echo "\$ ps -o pid,args -p \"\$!\""
  ps -o pid,args -p "$pspid" 2>&1 | mask
} > "$pout"
kill "$pspid" 2>/dev/null
wait "$pspid" 2>/dev/null

echo "captured -> $cout"
echo "captured -> $pout"
