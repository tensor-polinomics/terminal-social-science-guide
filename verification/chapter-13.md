# Source-verification log: Chapter 13 (SSH and remote compute)

Per PLAN.md Section 10. Chapter 13 is unusual for this book:
its subject is the network between two machines, so it splits
cleanly into material that is fully demonstrable offline and
material that only a real laptop-to-server round-trip can show.
The offline half (rsync's trailing-slash and `--delete`
semantics, `ssh-keygen`, `ssh-agent`, `tar`, `du`) runs in the
Linux sandbox, where it is network-free and byte-identical to
the remote form; outbound `ssh` from the sandbox is blocked, so
every genuinely remote block is captured on the author's Mac
against a real AWS EC2 Ubuntu server by
`transcripts/capture-ch13-mac.sh`. External behavior is pinned
to the OpenSSH, rsync, and Slurm manuals, fetched 2026-07-05.

## Provenance classes

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5,
  GNU bash 5.1.16, OpenSSH_8.9p1, GNU rsync 3.2.7, GNU
  coreutils 8.32, GNU tar 1.34. The rsync-semantics demos
  (trailing slash, `--delete` with a `-n` dry run,
  `--itemize-changes`), the `ssh-keygen`/`ssh-agent` demo, the
  `tar`/`du` blocks all run in throwaway `/tmp` scratch
  directories. The `ssh-keygen` demo generates a THROWAWAY
  ed25519 keypair with a fixed `-C book-demo-key` comment,
  inside a scratch `~/.ssh`, run with relative paths so the
  commands stay within the 64-column limit; the private key
  body is never shown, only the public half and the
  fingerprint. Transcripts: `ch13-versions.txt`,
  `ch13-keygen.txt`, `ch13-rsync-move.txt`, `ch13-bundle.txt`,
  `ch13-space.txt`. Verified: outbound `ssh` from the sandbox
  fails at DNS resolution (allowlisted network), so the remote
  captures below could not be faked from here even in
  principle.
- **Mac + real remote server, captured by
  `transcripts/capture-ch13-mac.sh` (macOS 26.5.1, zsh 5.9;
  server: Ubuntu on AWS EC2, kernel 6.8.0-1039-aws, x86_64,
  with R and uv (userspace) present):** the seven `ch13-*-mac.txt`
  transcripts. The script hardcodes NO personal data; it
  derives the server hostname, account, home, mount, device,
  and any literal IP at runtime and masks them at capture time,
  and the server alias is emitted as `lab-server`. All `ssh`
  calls are non-interactive one-shots (BatchMode; the Ch 9 hang
  lesson applied over the network). The transfer, checksum,
  environment-rebuild, and tunnel demos run in a throwaway
  `~/ch13-demo` (and `~/ch13-tunnel-demo`) on the server, which
  the scripts delete afterward; nothing else of the user's is
  touched. Two identifiers the capture-time mask could not
  anticipate were masked ON INGESTION and noted in the
  transcript headers: the Mac's own LocalHostName inside a
  `~/.ssh` filename (`environment-<host>` ->
  `environment-[hostname]`, `ch13-config-mac.txt`) and a
  host-named private key (`id_rsa_<host>` -> `id_rsa_[hostname]`,
  `ch13-server-mac.txt`); the capture script's `mask()` was
  then hardened to scrub the Mac hostname on future runs.
- **Authored, non-capture (labeled listings):** the annotated
  `~/.ssh/` tree (Section 2, the Ch 5 house device, ASCII
  connectors), the `~/.ssh/config` template (Section 3), and
  the Slurm job script (Section 7) are labeled non-runnable
  blocks, not captures; every line is <= 64 columns and each
  is introduced in prose as illustrative. The `~/.ssh` tree's
  names are cross-checked against the real masked `ls -l`
  listings in `ch13-config-mac.txt` and `ch13-server-mac.txt`.

## Behavior verified live (not assumed)

- **rsync trailing-slash semantics** (`ch13-rsync-move.txt`):
  `rsync -a proj/ backup` copies the CONTENTS of `proj` into
  `backup`; `rsync -a proj nested` nests a `proj/` inside
  `nested`. Shown side by side with `find`.
- **`rsync --delete` deletes on the destination**
  (`ch13-rsync-move.txt`): a stale `OLD_RESULT.csv` on the
  target is reported `deleting OLD_RESULT.csv` under
  `-n --delete` and left in place (the `(DRY RUN)` marker and
  the intact `ls` confirm it), then actually removed when `-n`
  is dropped. This is the chapter's headline DANGER, captured
  with real output rather than asserted.
- **Cross-machine checksum agreement** (`ch13-transfer-mac.txt`):
  the three transferred CSVs produce identical SHA-256 hashes
  from GNU `sha256sum` on the server and BSD `shasum -a 256` on
  the Mac (`54989b46...`, `8648c3be...`, `5056f919...`). This
  is Chapter 3's `sha256sum`-vs-`shasum` divergence delivering
  its remote payoff, and Chapter 10's manifest idea applied
  across two machines.
- **`uv sync` rebuilds the Python env on the server**
  (`ch13-restore-mac.txt`): from the same universal `uv.lock`,
  the server's CPython 3.12 resolves to 18 installed packages
  where the sandbox's 3.10 gave 20 (Chapter 12's
  universal-lock divergence, now demonstrated on a third
  platform); `statsmodels` lands at the locked `0.14.6`.
- **`renv::restore()` rebuilds the R library on the server**
  (`ch13-restore-mac.txt`): the server had no renv, so restore
  first bootstraps renv 1.2.3, then compiles all 35 packages
  from source ("Successfully installed 35 packages in 420
  seconds"); `fixest` builds to `0.14.2`, matching the lock and
  Chapter 7's committed value. `lattice`/`nlme` show
  `[old -> new]` because the server had system copies renv
  overrides; the rest show `[* -> version]`. renv restores the
  locked package versions regardless of the server's R patch
  release (the chapter does not assert a specific server R
  version), the live illustration of Chapter 12's honest edge
  that a lockfile pins packages, not the R interpreter.
- **`ssh -L` port forwarding** (`ch13-tunnel-mac.txt`): a
  background tunnel (`ssh -fN -L 8899:localhost:<port>`) reaches
  a short-lived server-side `python3 -m http.server` via `curl`
  on the laptop; the returned directory listing (`HELLO.txt`,
  `step.py`) proves the forward. A free ephemeral remote port
  is chosen at capture time so the demo cannot collide with an
  existing service.
- **The openrsync divergence, CORRECTED by capture**
  (`ch13-versions-mac.txt`, `ch13-divergence-mac.txt`,
  `ch13-versions.txt`): macOS ships `openrsync` (protocol 29,
  "rsync 2.6.9 compatible"), the Linux sandbox GNU rsync 3.2.7
  (protocol 31). The draft assumed, from the OpenBSD manual,
  that GNU-only flags `--itemize-changes` and `-z` would fail
  on macOS; the live capture shows both ACCEPTED on macOS
  26.5.1 (`--itemize-changes` prints `cd+++++++`/`>f+++++++`).
  So the chapter frames the divergence as
  implementation/protocol, not flag failure, and advises
  checking `rsync --version` on any new machine, the honest,
  capture-backed claim.

## Cross-references honored (no re-teaching)

- **Ch 1** promised the laptop-to-server-to-GPU motion; this
  chapter delivers it (the opening figure states the same
  motion) without re-arguing Ch 1's case.
- **Ch 9** taught `chmod` and `nohup`; Section 2 APPLIES `600`/
  `700` to key files (not re-teaching bit-reading), and Section
  6 cross-refs `nohup` as the disconnect stopgap. The env-var
  secrets and `ps`/history leak vectors stay Ch 9's; SSH-agent
  handling is this chapter's own.
- **Ch 10** built a `sha256sum` manifest; Section 5 applies the
  same check across two machines and is explicit that rsync's
  own after-transfer whole-file checksum is a wire-integrity
  check, "nothing to do with" an end-to-end manifest checksum
  (rsync manual, verbatim).
- **Ch 12** ended on the promise that `uv sync`/`renv::restore()`
  would rebuild the environment on a server; Section 6 is that
  payoff, cross-referenced, with no uv/renv mechanics
  re-taught. The exclude-the-environments line
  (`.venv/`/`renv/library/`) is Ch 12's commit-the-lock rule
  applied to a transfer.
- **Ch 3** owns the `sha256sum`-vs-`shasum -a 256` divergence,
  reused at the remote-verify moment.
- **Ch 14 (tmux)** is forward "will": the dropped-connection
  fact is stated, `nohup` is named as the stopgap, and
  persistent reattachable sessions are named as the next
  chapter's subject. No tmux is taught here.
- **Ch 15** owns the modern TUI kit; `ncdu` is named and routed
  there rather than shown (it is an interactive TUI, not a
  one-shot command).
- **Ch 17** is forward: the non-interactive-`ssh` `PATH` note
  (`~/.local/bin/uv` named in full) points at Ch 17's
  startup-file material.
- **The Git book** owns reproducibility and replication-package
  layout; not re-argued.

## Pinned external sources (fetched 2026-07-05)

- **OpenSSH `ssh(1)`** (man.openbsd.org/ssh.1). Pins: `ssh` is
  "for logging into a remote machine and for executing commands
  on a remote machine"; "If a command is specified, it will be
  executed on the remote host instead of a login shell";
  `-L [bind_address:]port:host:hostport` forwards a local port
  to a host/port reachable from the remote side; `-N` = "Do not
  execute a remote command... useful for just forwarding
  ports"; `-f` backgrounds ssh; `-J` is shorthand for a
  `ProxyJump`. Host keys "are stored in ~/.ssh/known_hosts...
  Any new hosts are automatically added"; "If a host's
  identification ever changes, ssh warns about this and
  disables password authentication to prevent server spoofing
  or man-in-the-middle attacks" (the RECOVERY callout's
  wording).
- **OpenSSH `ssh_config(5)`** (man.openbsd.org/ssh_config.5).
  Pins: the per-user file is `~/.ssh/config`; "the first
  obtained value for each parameter is used" (Section 3's
  ordering note); the meanings of `Host`, `HostName`, `User`,
  `Port`, `IdentityFile`. The `ForwardAgent` SECURITY WARNING,
  quoted in the agent-forwarding PITFALL: users "with the
  ability to bypass file permissions on the remote host" can
  access the forwarded agent; "An attacker cannot obtain key
  material from the agent, however they can perform operations
  on the keys that enable them to authenticate using the
  identities loaded into the agent."
- **OpenSSH `ssh-keygen(1)`** (man.openbsd.org/ssh-keygen.1).
  Pins: it "generates, manages and converts authentication
  keys"; ed25519 is the default type; `-C` sets a comment,
  `-f` the filename, `-l` shows a fingerprint, `-p` changes a
  passphrase.
- **rsync(1)** (download.samba.org/pub/rsync/rsync.1). Pins:
  `-a` = `-rlptgoD`; `--delete` "delete extraneous files from
  dest dirs"; `-n`/`--dry-run`; `-i`/`--itemize-changes`. The
  trailing slash, verbatim: a trailing `/` on the source means
  "copy the contents of this directory" as opposed to "copy the
  directory by name." The integrity distinction, verbatim:
  "rsync always verifies that each transferred file was
  correctly reconstructed on the receiving side by checking a
  whole-file checksum that is generated as the file is
  transferred, but that automatic after-the-transfer
  verification has nothing to do with this option's
  before-the-transfer 'Does this file need to be updated?'
  check" (Section 5's precise credit).
- **openrsync(1)** (man.openbsd.org/openrsync.1, OpenBSD-current
  dated 2025-12-29). Pins the option list (no `--itemize-changes`
  or `-z` in the OpenBSD build) and "compatible with rsync
  protocol version 27." NOTE: the CHAPTER does not repeat the
  no-`-i`/`-z` claim, because the live macOS capture
  (`ch13-divergence-mac.txt`) shows Apple's openrsync accepting
  both; the divergence is framed as implementation/protocol and
  the reader is told to check `rsync --version`.
- **Slurm** (slurm.schedmd.com/{sbatch,squeue,scancel}.html,
  Version 26.05 docs, accessed 2026-07-05). Pins: "sbatch
  submits a batch script to Slurm"; a script "may contain one
  or more lines beginning with '#SBATCH'"; "squeue - view
  information about jobs located in the Slurm scheduling
  queue"; "scancel - Used to signal jobs or job steps." Used
  only for the one recognize-and-route page; the job script is
  a labeled non-runnable listing.
- **Runpod docs** (docs.runpod.io/pods/pricing and
  docs.runpod.io/pods/maintenance-and-outages, accessed
  2026-07-05). Pins the two Section-7 GPU-pod claims: Pods are
  billed PER SECOND (the chapter says "metered, on Runpod by the
  second", correcting a drafted "by the hour"), and a Pod's
  container disk / volume is ephemeral and can be lost when the
  Pod stops or is reset, so results must be moved off (rsync) or
  written to persistent storage. Nothing is run on a paid pod;
  the section is recognize-and-route, quarantined.
- **renv R-version behavior** (per the renv docs pinned in
  Chapter 12's verification log: renv TRACKS but does not MANAGE
  the R version). This backs the Section-6 wording that a server
  on a different R patch release restores the same package
  versions, not the same R. The chapter does NOT assert the
  server's specific R version, since the `R --version` probe was
  a chat-time check, not a committed capture; the shown restore
  output backs only the package-version overrides
  (`lattice`/`nlme` `[old -> new]`).

## Counts (self-check)

- **7 numbered content sections** (5 beginner, 2 advanced) +
  unnumbered `## Try it yourself`:
  1. Reaching a shell on a machine you cannot see (beginner)
  2. Keys, and the permissions that make them work (beginner)
  3. A config file, and forwarding a port (beginner)
  4. Moving the project with `rsync` (beginner)
  5. Did the bytes survive the trip? (beginner)
  6. Rebuilding the environment, and surviving a disconnect
     (advanced)
  7. The bigger remote worlds: GPU pods and HPC (advanced)
- **Callouts (6): 1 RECOVERY, 2 PITFALL, 1 DANGER, 1
  DIVERGENCE, 1 REPRODUCIBILITY.** RECOVERY: host-key-changed
  triage. PITFALL: wrong `~/.ssh` permissions make OpenSSH
  ignore a key; agent-forwarding exposure. DANGER:
  `rsync --delete` with the trailing-slash trap. DIVERGENCE:
  macOS openrsync vs Linux GNU rsync. REPRODUCIBILITY:
  checksum-verified transfer plus lockfile rebuild = same
  bytes and same versions on both machines.
- **1 figure:** `fig-ch13-motion` (the laptop-to-server-to-GPU
  arrow diagram at the chapter open; textbook-diagrams TikZ,
  built font-independently per the CLAUDE.md recipe).
- Mechanical: content sections = 7; `{.tier-beginner}` = 5;
  `{.tier-advanced}` = 2; em-dashes = 0; validator 0 errors /
  0 warnings (sandbox `python3`; canonical Mac `uv run` at the
  gate). Of the 21 fenced code blocks, 18 are transcript-backed
  (17 with `$`/`>` prompts plus the renv output block shown
  without a prompt) and were each verified as contiguous
  substrings of the `ch13-*` transcripts (with marked `[...]`
  elisions for the rsync file list and the uv/renv install
  logs); the other 3 are authored non-capture listings (the
  annotated `~/.ssh` tree, the `~/.ssh/config` template, and the
  Slurm job script), each <= 64 columns.
