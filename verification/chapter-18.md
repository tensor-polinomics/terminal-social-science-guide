# Source-verification log: Chapter 18 (Startup Files, PATH & Portable Dotfiles)

Per PLAN.md Section 10. Startup-file ordering is the most
folklore-ridden topic in the book ("macOS Terminal runs a login
shell", "SSH reads `.bashrc`", "cron reads `.profile`" are each
partly true and version/OS/config dependent), so the governing
rule here is **run it**: every ordering claim is confirmed by a
real invocation that echoes a marker from each startup file, and
the manuals are pinned only for the *why*. Access date for all
web sources: 2026-07-07.

The bash startup order and the non-interactive environment seam
are captured in the Linux sandbox (real GNU bash 5.1.16); the zsh
order, the macOS bash-3.2 floor, and launchd are Mac captures; the
remote "fails over SSH" seam is captured from the Mac against the
user's real Linux server (the Chapter 14 box). Every shell runs
against a THROWAWAY `HOME` seeded with demo rc files, so the
user's real dotfiles are never read (the Ch 16 throwaway-db mask,
applied to whole dotfiles).

### Bash startup-file ORDER (run live, sandbox)
- chapter/section: Ch 18, "Which file loads when"
- source: real sandbox capture `transcripts/ch17-bash-order.txt`
  (throwaway HOME, demo `.bash_profile`/`.bashrc`/`.profile`),
  backed for the *why* by the bash(1) manual, INVOCATION section
  (Ubuntu jammy manpage,
  https://manpages.ubuntu.com/manpages/jammy/en/man1/bash.1.html)
- accessed: 2026-07-07
- verifies, confirmed by the capture and the manual:
  - a **login** shell reads `/etc/profile`, then the FIRST of
    `~/.bash_profile`, `~/.bash_login`, `~/.profile` that exists
    (capture: `bash -lc` fired `.bash_profile`; with only
    `.profile` present it fired `.profile`).
  - an **interactive non-login** shell reads `/etc/bash.bashrc`
    and `~/.bashrc` (capture: `bash -i` fired `.bashrc`).
  - a **non-interactive** shell (a script, `bash -c`) reads
    NEITHER; it reads `$BASH_ENV` if that names a file (capture:
    `bash -c` fired nothing; `BASH_ENV=~/.bashrc bash -c` fired
    `.bashrc`). The manual notes PATH is not used to find
    `$BASH_ENV`.
- version note: GNU bash 5.1.16 (sandbox); the ORDER is stable
  across bash 3.2-5.x, so it also describes the Mac's bash 3.2.
- confirmable: yes (transcript + manual)

### The sshd/.bashrc special case (folklore, pinned precisely)
- chapter/section: Ch 18, "Works in terminal, fails over SSH";
  PITFALL / RECOVERY
- source: bash(1) manual, INVOCATION (Ubuntu jammy manpage, as
  above); real server capture `transcripts/ch17-ssh-seam-mac.txt`
- accessed: 2026-07-07
- verifies: bash "attempts to determine when it is being run with
  its standard input connected to a network connection, as when
  executed by ... the secure shell daemon sshd. If bash determines
  it is being run in this fashion, it reads ... `~/.bashrc`". This
  is why "SSH reads `.bashrc`" is only PARTLY true and not to be
  relied on: (a) the behavior is a BUILD-TIME option, not
  guaranteed on (the chapter no longer asserts a specific "Debian/
  Ubuntu disable it" claim, which is not pinnable to a build
  source; it says do not rely on it); (b) it never applies when
  bash is invoked as `sh`; and (c) DECISIVE here, the stock
  `~/.bashrc` on Debian/Ubuntu self-guards with
  `case $- in *i*) ;; *) return;; esac`, returning immediately
  when non-interactive, so even where bash sources it the file
  does nothing. Net effect on a typical Ubuntu server: a
  non-interactive `ssh host 'cmd'` does NOT pick up your `~/.bashrc`
  PATH edits, so `~/.local/bin` tools are not found unless named
  in full or a login shell is forced (`ssh host 'bash -lc "..."'`).
  The server capture is the ground truth; the manual explains why.
  CONFIRMED 2026-07-07 (`ch17-ssh-seam-mac.txt`): non-interactive
  `ssh host 'echo $PATH'` had no `~/.local/bin` and `command -v
  uv` reported not found; forcing `bash -lc` restored
  `~/.local/bin` and found `uv` at `/home/[account]/.local/bin/uv`.
- version note: n/a (behavior is config/distro dependent, stated
  as such, not as universal law). MASK NOTE: the first server
  capture leaked the real account and home path because BSD `sed`
  on the Mac has no `\b` word boundary and the server home is not
  under `/home`; the transcript was scrubbed on ingestion and
  `capture-ch17-ssh-mac.sh` fixed to mask the real `$HOME` path
  with plain (BSD-safe) substitutions. A SECOND pass (Codex
  blocker) masked the machine-specific data-mount path in the
  server's `PATH`: `capture-ch17-ssh-mac.sh` now collapses any
  `/mnt/<...>` mount to `/mnt/[mount]` (a general BSD-safe rule
  that carries no server path in the tracked script), and the
  transcript was re-scrubbed to match. Repo re-grepped clean for
  the account name and the mount name in tracked files (only
  gitignored `.venv/` and `private/` retain the account). The
  chapter shows only the PATH front and elides the tail with
  `[...]`.
- confirmable: yes (manual + real server capture)

### The non-interactive environment (run live, sandbox)
- chapter/section: Ch 18, "The portable dotfile" (interactive-only
  caveat); "Scheduled / non-interactive contexts"
- source: real sandbox capture
  `transcripts/ch17-noninteractive.txt`
- accessed: 2026-07-07
- verifies: a PATH edit placed in an interactive rc is visible to
  an interactive shell (`bash -i` shows `~/.local/bin` on PATH)
  but invisible to a non-interactive one (`bash -c` does not);
  `env -i bash -c` shows the stripped environment a scheduled job
  starts from. This is the mechanism behind the "works in my
  terminal" PITFALL and the Ch 11 REPRODUCIBILITY cross-ref.
- version note: n/a (real capture)
- confirmable: yes (transcript)

### Zsh startup-file order
- chapter/section: Ch 18, "Which file loads when"; DIVERGENCE
- source: zsh manual, "5.1 Startup/Shutdown Files"
  (https://zsh.sourceforge.io/Doc/Release/Files.html); real Mac
  capture `transcripts/ch17-zsh-order-mac.txt`
- accessed: 2026-07-07
- verifies: zsh reads `/etc/zshenv` then `$ZDOTDIR/.zshenv`
  (`HOME` if `ZDOTDIR` unset) on EVERY invocation, including
  non-interactive scripts; then, if login, `zprofile`; if
  interactive, `zshrc`; if login, `zlogin`. The headline
  divergence from bash: `.zshenv` runs even for a `zsh -c` script,
  so PATH that must exist everywhere goes in `.zshenv` (the manual
  warns to keep it small, guarded by `[[ -o rcs ]]`). The Mac
  capture confirms which markers fire for `zsh -l -i`, `zsh -i`,
  and `zsh -c`.
- version note: zsh manual 5.9.1 (2026-05-31); user Mac zsh
  version stamped in `ch17-versions-mac.txt`.
- confirmable: yes (manual + Mac capture)

### macOS Terminal opens a login shell (DIVERGENCE)
- chapter/section: Ch 18, "Which file loads when"; DIVERGENCE
- source: real Mac capture `transcripts/ch17-login-shell-mac.txt`
  (`[[ -o login ]]` and `[[ -o interactive ]]` run in a real
  Terminal.app tab, the canonical zsh tests); the login-shell
  default is confirmed by that capture, not asserted from docs
- accessed: 2026-07-07
- verifies: macOS Terminal.app starts each tab as a LOGIN +
  interactive shell by default (CONFIRMED 2026-07-07:
  `[[ -o login ]]` in a real Terminal.app tab prints
  `login shell`, `[[ -o interactive ]]` prints `interactive`,
  captured in `ch17-login-shell-mac.txt`; a WezTerm tab returned
  the same). So a Mac tab reads `.zprofile` AND `.zshrc`. Many
  Linux terminal emulators instead start a NON-login interactive
  shell, reading only `.bashrc`/`.zshrc`, which is why the
  `.bash_profile`-vs-`.bashrc` split bites differently across the
  two platforms. The chapter frames login-ness as EMULATOR-decided
  (not OS-decided) to stay honest about the "macOS = login" half-
  truth.
- version note: CONFIRMED 2026-07-07. IMPORTANT correction: an
  early plan used `echo $0` (a leading `-`) as the login test.
  That is a BASH-only heuristic; in zsh `echo $0` prints
  `/bin/zsh` regardless of login state (verified), so it does NOT
  report login. The chapter uses the canonical `[[ -o login ]]`
  (zsh) / `shopt -q login_shell` (bash) and says so. This is the
  chapter's own run-it-not-the-folklore lesson, caught live.
- confirmable: yes (captured `[[ -o login ]]` + documented
  emulator behavior)

### launchd's environment (Mac)
- chapter/section: Ch 18, "Scheduled / non-interactive contexts"
- source: real Mac capture `transcripts/ch17-launchd-mac.txt`
  (`launchctl getenv PATH`); the `launchd.plist(5)` and
  `launchctl(1)` man pages (the `EnvironmentVariables` key)
- accessed: 2026-07-07
- verifies: a process started by launchd (a GUI app, a
  LaunchAgent) inherits launchd's environment, not your shell's,
  so its PATH is a bare default (often unset) and your dotfile
  edits are absent; a scheduled Mac job sets PATH explicitly (a
  plist `EnvironmentVariables` key) rather than relying on the
  shell config. The plist is documented and quarantined, not run.
- version note: CONFIRMED 2026-07-07: `launchctl getenv PATH`
  printed nothing on the user's Mac (`ch17-launchd-mac.txt`),
  i.e. launchd carries no PATH from the shell config. The chapter
  states this in prose (an empty result is not shown as a fenced
  output block).
- confirmable: yes (capture + docs)

### cron's environment
- chapter/section: Ch 18, "Scheduled / non-interactive contexts";
  REPRODUCIBILITY
- source: crontab(5) manual (cronie, Paul Vixie;
  https://man7.org/linux/man-pages/man5/crontab.5.html)
- accessed: 2026-07-07
- verifies: cron sets a MINIMAL environment automatically:
  `SHELL=/bin/sh`, and `LOGNAME`/`HOME` from the crontab owner's
  `/etc/passwd` line; it reads NONE of your shell startup files.
  Environment for a job is set with `name = value` lines in the
  crontab itself, so a cron job that needs a specific PATH sets
  `PATH=...` there. The chapter shows a real cron LINE as a
  labeled, illustrative (not run) block and demonstrates the
  stripped-environment mechanism with `env -i` in the sandbox.
  The cron spool is not writable in the sandbox, so no live cron
  job is installed; the claim rests on crontab(5) plus the
  `env -i` mechanism demo.
- version note: crontab(5) from cronie (page dated 2026-05-24).
- confirmable: yes (manual + `env -i` demo)

### CI (conceptual / quarantined)
- chapter/section: Ch 18, "Scheduled / non-interactive contexts"
- source: general CI behavior; no capture
- accessed: n/a
- verifies: a CI runner executes steps in a non-interactive,
  non-login shell whose environment is set by the CI config, not
  your dotfiles; the same "put PATH where the non-interactive
  shell reads it" rule applies. Named in one line, not run.
- version note: n/a
- confirmable: n/a (conceptual, clearly labeled)

### Internal cross-references (delivering forward promises)
- chapter/section: Ch 18 throughout
- source: this book: Ch 2 (env/`export`, the process view,
  `2:343`), Ch 3 (`brew shellenv` line + `~/.local/bin`,
  `3:260`/`3:273`), Ch 5 (`cp -i`/`mv -i` alias, `4:500`), Ch 7
  (`set -o noclobber`, `6:149`/`6:690`; PATH-hijack risk), Ch 10
  (history hygiene `HISTCONTROL`, `9:522`), Ch 11 (scripts pin
  `LC_ALL`/`TZ`/PATH), Ch 14 (the `ssh host 'cmd'` seam,
  `13:489`), Ch 16 (zoxide/fzf hooks + graceful-degradation
  aliases, `15:148`/`15:184`/`15:198`)
- accessed: n/a
- verifies: Ch 18 DELIVERS each forward promise as one line of
  config plus the placement rule, and does NOT re-teach the
  mechanism that a prior chapter owns (the env model, install,
  `cp -i`/`mv -i`, `noclobber`, history hygiene, `ssh` itself, or
  the modern kit). Graceful degradation is delivered as
  `command -v <tool> >/dev/null && alias ...` guards so a dotfile
  copied to a bare server still works.
- version note: n/a
- confirmable: yes (internal; forward-promise lines grep-verified
  at 2:343, 3:260/273, 4:500, 6:149/690, 9:522, 13:489,
  15:148/184/198)

## Gate confirmations

- **Bash order + non-interactive seam: captured live in the
  sandbox** (`ch17-bash-order.txt`, `ch17-noninteractive.txt`),
  masked to `/home/[account]`.
- **Mac + server captures DONE 2026-07-07.** The user ran
  `capture-ch17-mac.sh` (versions: macOS 26.5.1, zsh 5.9, bash
  3.2.57; `ch17-zsh-order-mac.txt` markers fire per the manual
  after a ZDOTDIR fix; `ch17-launchd-mac.txt` PATH empty) and
  `capture-ch17-ssh-mac.sh` (`ch17-ssh-seam-mac.txt`), plus the
  `[[ -o login ]]` check in a real Terminal tab
  (`ch17-login-shell-mac.txt`). All shown `$`-blocks are
  transcript-backed (a scripted contiguous-substring check passed:
  38/38 lines exact or `[...]`-elided-prefix). Repo re-grepped
  clean for the account name in tracked files.
- **Validator** 0/0 in the sandbox (`python3` + PyYAML). Counts
  confirmed: 6 content sections + unnumbered Try-it; 4 beginner /
  2 advanced; callouts 1 PITFALL / 1 RECOVERY / 1 DIVERGENCE /
  1 REPRODUCIBILITY, no DANGER; 0 em-dashes; no typed command
  line >64. Canonical `uv run python tools/validate_book.py book`
  is the Mac gate step.
- **Render check is a Mac gate step.** Confirm the invocation
  matrix table and the ASCII dotfile tree render without overflow
  or dropped glyphs (the Ch 6 box-glyph lesson: ASCII connectors
  only), and note the page range (Ch 18 currently a stub after
  Ch 17; the book was 203pp through Ch 17).
- **Closeout done in-draft:** TWO forward-`will` references to
  Ch 18 flipped to present tense: `03-setup.qmd:273`, and
  `02-mental-model.qmd:399` ("Chapter 3 sets you up and Chapter
  18 makes it stick", which also retired a stale forward-`will`
  for the now-committed Ch 3). A same-line grep missed the second
  one because "Chapter" and "17" span two source lines; a
  multi-line grep (`grep -A2 'chapter 17' | grep '\bwill\b'`)
  catches it and now returns clean. The other Ch 18 pointers
  (2:343, 4:500, 6:149/690, 9:522, 13:489, 15:148/184/198) are
  already present-tense parentheticals; the Ch 1 roadmap does not
  reference Ch 18.
