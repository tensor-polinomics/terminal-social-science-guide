# Source-verification log: Chapter 9 (Processes, permissions, secrets)

Per PLAN.md Section 10. Chapter 9 is executable: the process,
permission, environment, `ps`, and `.gitignore` output is real
sandbox capture, and the external claims (signal semantics,
`chmod` modes, shell-history variables) are pinned to official
manuals fetched 2026-07-03. Provenance classes:

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, GNU coreutils 8.32 (`chmod`, `nohup`),
  procps-ng 3.3.17 (`ps`), Python 3.10.12, aarch64. All demos
  run in throwaway `/tmp` scratch dirs (the `.gitignore` read
  uses the tracked `sandbox/asset-pricing/.gitignore`).
  Transcripts: `ch09-jobs.txt`, `ch09-signals.txt`,
  `ch09-nohup.txt`, `ch09-chmod.txt`, `ch09-env.txt`,
  `ch09-ps.txt`, `ch09-ps-leak.txt`, `ch09-gitignore.txt`,
  `ch09-history.txt`. Every sandbox block the chapter shows was
  diffed against its transcript (14 blocks, all byte-identical;
  see counts).
- **bash shell history is a SANDBOX capture** (`ch09-history.txt`),
  not a Mac one. Interactive history cannot be captured by a
  script on a real terminal (an interactive zsh/bash reads the
  keyboard, not the script's piped input, so it hangs), but it
  works in the book's non-interactive Linux sandbox, where
  `bash -i` reads the here-doc. The chapter shows this bash
  capture (`HISTCONTROL=ignorespace` drops a leading-space
  `curl` bearer-token line; `set +o history` drops a stretch);
  the zsh equivalent is pinned to the zsh manual (claim 4), not
  captured, because it is the reader's default but not
  script-drivable. An earlier draft tried to drive interactive
  zsh/bash from the Mac capture script; that hung on a real
  terminal and was removed.
- **Real, user's Mac (macOS 26.5.1, zsh 5.9, Apple Silicon):
  RECONCILED 2026-07-03.** The user ran
  `transcripts/capture-ch09-mac.sh` (installs nothing, runs no
  `sudo`, masks at capture time incl. the `$TMPDIR` scrub):
  1. **chown** (`ch09-chown-mac.txt`) - the ONE drafted chapter
     block MATCHED the capture byte-for-byte: `$ chown "$(id
     -un)" key.pem` / `$ chown daemon key.pem` -> `chown:
     key.pem: Operation not permitted` / `$ echo $?` -> `1`.
     The reference `ls -l` shows `-rw-r--r--@ 1 [account] staff`
     (macOS `@` extended-attrs marker, `staff` group), and
     `chgrp everyone` flipped the group column to `everyone`,
     confirming a privilege-free group change; the account name
     is masked, `staff`/`everyone` are standard groups left
     as-is.
  2. **BSD ps** (`ch09-ps-mac.txt`) - backs the `ps` DIVERGENCE:
     `ps -o pid,args` on macOS printed the same exposed command
     line (`python3 ... --password=hunter2`) under a BSD `PID
     ARGS` header (vs Linux procps `PID COMMAND`). The chapter
     shows no Mac `ps` block, so this is a sanity backing, not a
     byte reconcile.

Masking: every secret value in the chapter is a FAKE placeholder
(`hunter2`, `sk-not-a-real-key-1234`, `DB_PASSWORD=hunter2`,
`sk-fake-...`); no real credential or real environment dump
appears anywhere. The account name that `ls -l` prints is masked
to `[account]` in `ch09-chmod.txt` (Ch 2 policy, as Ch 4 did).
`ps -o pid,args` prints no owner column, so the `ps` blocks carry
no user data. No real `$HISTFILE`, `env`, or `printenv` dump is
ever shown.

## Live sandbox verifications (behavior, not just docs)

These process/permission claims were confirmed by running them,
which is stronger than a doc citation:

- **A trapped `SIGTERM` runs the handler; `SIGKILL` (-9) does
  not.** `ch09-signals.txt`: the default `kill` let the script's
  `trap cleanup TERM` write its cleanup line; `kill -9` left the
  log after "started" with no cleanup line. Backs the section and
  the `kill -9` PITFALL.
- **An exported variable is inherited by a child; a plain shell
  variable is not.** `ch09-env.txt`: `bash -c 'echo [$DB_PASSWORD]'`
  printed `[]` before `export` and `[hunter2]` after. Backs the
  env-inheritance PITFALL (and the Ch 16 cross-ref: an agent
  launched from the same shell inherits the same exported
  secrets).
- **A command-line argument is exposed in `ps`; a value read from
  the environment is not.** `ch09-ps-leak.txt`:
  `ps -o pid,args` showed `--password=hunter2` in the arg list,
  and showed only `python3 readkey.py` for the env-reading
  program. Backs the leak DANGER and its mitigation.
- **`chmod` changes the shown permission bits.** `ch09-chmod.txt`:
  `chmod 600` took `.env` from `-rw-r--r--` to `-rw-------`;
  `chmod u+x` took a script from `-rw-r--r--` to `-rwxr--r--`;
  `chmod 777` produced `-rwxrwxrwx`. Backs the permissions
  section and the `chmod 777` DANGER.
- **`HISTCONTROL=ignorespace` and `set +o history` keep commands
  out of the saved bash history file.** Captured in the Linux
  sandbox (isolated `HISTFILE`, exit-write; `ch09-history.txt`):
  the saved file held `echo "public setup line"`, `set +o
  history`, `echo "public line after"` and omitted both the
  leading-space `curl` bearer-token line and the command run
  while history was off. This is the shown `bash_history_demo`
  block, a real sandbox capture (not a Mac draft).

## Pinned external claims (fetched 2026-07-03)

1. **`SIGTERM` is catchable and is `kill`'s default; `SIGKILL`
   (-9) cannot be caught, blocked, or ignored; `SIGHUP` reports a
   disconnected terminal.** Pinned: GNU C Library manual,
   "Termination Signals"
   (https://www.gnu.org/software/libc/manual/html_node/Termination-Signals.html,
   fetched 2026-07-03). Verbatim: SIGTERM "can be blocked,
   handled, and ignored. It is the normal way to politely ask a
   program to terminate. The shell command kill generates SIGTERM
   by default." SIGKILL "cannot be handled or ignored, and is
   therefore always fatal ... you should generate it only as a
   last resort, after first trying a less drastic method such as
   ... SIGTERM." SIGHUP "is used to report that the user's
   terminal is disconnected." Backs the signals section, the
   `kill -9` PITFALL, and the `nohup`/SIGHUP section.
2. **`chmod` sets file mode bits via octal (e.g. `644`) or
   symbolic (`u+x`, `a=r,u+w`) modes; only the file's owner (or a
   privileged process) may change them; `-R` is recursive.**
   Pinned: GNU coreutils manual, "chmod: Change access
   permissions"
   (https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html,
   fetched 2026-07-03): "Only a process whose effective user ID
   matches the user ID of the file, or a process with appropriate
   privileges, is permitted to change the file mode bits."
   Examples given include `chmod 644 foo`, `chmod a=r,u+w foo`,
   and `chmod ug+x file`. Backs the octal/symbolic teaching; the
   bit changes themselves are live in `ch09-chmod.txt`.
3. **Changing a file's owner to another user requires
   privilege.** The coreutils `chmod` pin above states the
   general model ("a process with appropriate privileges"); the
   POSIX/`chown` rule that only a privileged process may change a
   file's owner is long-standing, and the coreutils `chown` page
   documents it
   (https://www.gnu.org/software/coreutils/manual/html_node/chown-invocation.html).
   The claim is also evidenced DIRECTLY by the reconciled Mac
   capture (`ch09-chown-mac.txt`, 2026-07-03): an un-privileged
   `chown daemon key.pem` fails with "Operation not permitted"
   (exit 1), while `chown` to yourself and `chgrp` to a group you
   already belong to both succeed. Backs the ownership section.
4. **zsh `HIST_IGNORE_SPACE` drops a command line whose first
   character is a space.** Pinned: zsh manual, "Options"
   (https://zsh.sourceforge.io/Doc/Release/Options.html, fetched
   2026-07-03), verbatim: HIST_IGNORE_SPACE "Remove command lines
   from the history list when the first character on the line is a
   space, or when one of the expanded aliases contains a leading
   space." Backs the zsh leading-space mitigation and the
   bash-vs-zsh DIVERGENCE.
5. **bash `HISTCONTROL` controls which commands are saved, and
   `set -o history` / `set +o history` toggle history recording;
   `$HISTFILE` (default `~/.bash_history`) is where it is
   written.** Pinned: bash manual, "Bash History Facilities"
   (https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html,
   fetched 2026-07-03): "When the -o history option to the set
   builtin is enabled ... the shell provides access to the command
   history"; "The shell stores each command in the history list
   ... subject to the values of the shell variables HISTIGNORE and
   HISTCONTROL"; "The HISTCONTROL and HISTIGNORE variables may be
   set to cause the shell to save only a subset of the commands
   entered"; HISTFILE "default ~/.bash_history". The specific
   `HISTCONTROL=ignorespace` value's effect is verified LIVE in
   the sandbox (above) and reproduced in `ch09-history.txt`. The
   gnu.org "Bash Variables" page that enumerates the
   `ignorespace`/`ignoreboth` values is the authoritative source
   for those values (it did not return content on this session's
   fetch attempts, but is reachable; the Codex audit confirmed it
   2026-07-03), and the live capture is the primary evidence for
   the shown behavior either way. The `history` and `fc` builtins
   are documented in "Bash History Builtins"
   (https://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html,
   fetched 2026-07-03).

## Cross-chapter promises touched

- **Ch 4's deferral is honored.** Ch 4 said reading the `rwx`
  string is its job and "Changing permissions with `chmod`, the
  octal shorthand like `644` and `755`, and who owns a file are
  Chapter 9's subject." Ch 9's permissions and ownership sections
  deliver exactly that, applying (not re-teaching) Ch 4's reading
  of the triples. Present tense (Ch 4 committed `3d5a62b`).
- **Ch 2's environment is made operational.** `export`/env
  inheritance were taught conceptually in Ch 2; here they become
  the way to hand a program a secret. Present tense (Ch 2
  committed `7f849b1`). Ch 2 already forward-pointed to "keeping
  keys out of the environment," which this chapter delivers.
- **Ch 6's danger has a sibling, not a re-teach.** The secret-leak
  DANGER is framed as the "reveal it" sibling of Ch 6's "destroy
  it"; `rm -rf`/`>`/`curl | sh` and quoting/null-safety are
  referenced, not repeated. The `chmod 777` DANGER points to Ch 6
  the way that chapter treats `curl | sh`. Present tense (Ch 6
  committed `22eec6c`).
- **Ch 5's `.gitignore` rule is the anchor.** The secrets stanza
  read from the project's own `.gitignore` (`.env`, `*.pem`,
  `secrets.*`) is the one Ch 5's layout set. Present tense (Ch 5
  committed `6d46e79`).
- **Git book owns "never commit a secret"; Ch 9 owns the rest.**
  Cross-referenced (never committed; purge from history in the
  RECOVERY), not re-argued (PLAN Section 6).
- **Ch 16 (AI prompts) cross-ref, present tense (committed
  `7571ab2`).** The env-inheritance PITFALL notes an agent
  launched from the same shell inherits the exported secrets, and
  the leak section notes an agent transcript is one more place a
  printed secret lands. Ch 16 already cross-refs Ch 9 for exactly
  this, so the two are consistent.
- **Ch 10 (tee/script logs, `set -euo pipefail`, locale),
  Ch 13 (SSH/remote long jobs, `~/.ssh` keys), Ch 14 (tmux
  persistent reattachable sessions), Ch 17 (startup files)** are
  all referenced with forward "will" language (still stubs). The
  `nohup` section explicitly draws the line to tmux (Ch 14) and
  remote work (Ch 13) as the fuller answers.

## Counts (self-check, 2026-07-03)

7 content sections + unnumbered Try-it; 5 beginner, 2 advanced.
Sections: (1) Running a job in the background [beginner],
(2) Signals and kill [beginner], (3) Keeping a job alive after
logout: nohup [advanced], (4) Permissions: chmod [beginner],
(5) Ownership: chown and chgrp [advanced], (6) Secrets in
environment variables [beginner], (7) Where a secret leaks:
history, ps, and logs [beginner]. Callouts: 2 DANGER (chmod 777
world-writable; the three-way secret leak via history/ps/logs),
2 PITFALL (kill -9 skips cleanup; exported env vars inherited by
children incl. agents), 2 DIVERGENCE (BSD vs GNU ps invocation;
bash HISTCONTROL vs zsh HIST_IGNORE_SPACE), 1 RECOVERY (a leaked
secret is rotated, not deleted). No REPRODUCIBILITY (not earned).
No figure (command/output driven; a ~/.ssh permissions tree is
more naturally Ch 13's). Shown `$` blocks: 14 sandbox blocks
byte-diffed to transcripts (all identical); 1 Mac-backed block
(chown) RECONCILED byte-for-byte 2026-07-03 (matched the draft;
the BSD `ps` Mac capture backs the DIVERGENCE and is shown as no
chapter block, a sanity read). Render: `quarto render book`
passed on the Mac (153-page PDF, Ch 9 pp. 105-117, Ch 10 starts
p. 118, no overflow; Codex, 2026-07-03). Validator: canonical command is
`uv run python tools/validate_book.py book`, 0/0 in the sandbox
AND on the Mac (confirmed by the user and by Codex, 2026-07-03).
Bare `python3 tools/validate_book.py book` needs PyYAML, which a
stock Mac
`python3` lacks, so always use the `uv run` form.
