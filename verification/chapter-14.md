# Source-verification log: Chapter 14 (Persistent sessions)

Per PLAN.md Section 10. Chapter 14 teaches tmux for surviving
disconnects on long jobs, with screen as a one-breath aside.
tmux is preinstalled in the Linux sandbox (tmux 3.2a) and on the
remote server (Ch 13 probe: `/usr/bin/tmux`), so most of the
chapter is captured live in the sandbox; only the one claim that
requires actual remoteness, that a session outlives the `ssh`
connection that started it, is captured on the author's Mac
against a real remote Linux server. Behavior that cannot be
driven non-interactively (the prefix key, `Ctrl-b d`, an
interactive `attach`) is pinned to the tmux and GNU Screen
manuals, fetched 2026-07-05, and everything scriptable is
verified by a real run.

## Provenance classes

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, tmux 3.2a, GNU Screen 4.09.00. Every tmux
  demo is captured NON-interactively through tmux's command
  interface (`new-session -d`, `ls`, `capture-pane -p`,
  `send-keys`, `new-window`, `split-window`, `list-windows`,
  `list-panes`, `kill-session`), never by an interactive
  `attach`, which would take over the terminal and hang a
  scripted capture (the Ch 9 interactive-shell lesson). All
  sessions run in the sandbox with book-chosen names (`work`,
  `job`, `analysis`, `build`); pane size fixed at 80x24 (`-x`,
  `-y`) so captures are stable. Transcripts: `ch14-coreloop.txt`
  (new/ls/kill lifecycle), `ch14-progress.txt` (a job
  progressing while detached, two `capture-pane` dumps),
  `ch14-structure.txt` (window/pane containment via
  `list-windows`/`list-panes`), `ch14-sendkeys.txt`
  (`send-keys` + `capture-pane`), `ch14-selfdestruct.txt` (a
  session whose only command exits ends by itself),
  `ch14-screen.txt` (`screen --version` only; `screen -ls` is
  not shown because its socket path embeds the account name).
- **Mac + real remote server, captured by
  `transcripts/capture-ch14-mac.sh`:** `ch14-versions-mac.txt`
  (the Mac's tmux + screen versions) and `ch14-server-mac.txt`
  (the survive-a-disconnect demo). The script hardcodes NO
  personal data; it derives the server hostname, account, and
  home at runtime and masks them at capture time, emits the
  server alias as `lab-server`, and uses only the book's session
  name `job`. All `ssh` calls are non-interactive one-shots
  (BatchMode); connection A starts the detached session and
  returns, and connections B, C, D are independent `ssh`
  invocations that find the session still running and advancing,
  then read its intact `tee` log, proving nothing depended on
  the first connection staying open. STATUS: RECONCILED
  byte-for-byte 2026-07-05 after the user ran
  `capture-ch14-mac.sh` (Mac tmux 3.7a, screen 4.00.03; server
  session created 19:57:08, Connection C at step 8, log tail at
  steps 14-16). The chapter shows Connection A (start), B
  (`tmux ls`, session present), C (`capture-pane`, step 8), and
  the log tail; the capture also took a fourth read (a second
  `capture-pane`, step 15), kept in the transcript but dropped
  from the chapter as redundant with the local demo. `tmux ls`
  is filtered at capture time to the demo session, so the
  author's unrelated pre-existing sessions never enter the repo.

## Verified live in the sandbox (not assumed)

- A detached session created with `tmux new-session -d` appears
  in `tmux ls` with no client attached, and `tmux kill-session`
  removes it; when the last session ends, the tmux server exits
  (`no server running on ...`). (`ch14-coreloop.txt`.)
- A job in a detached session keeps running with no terminal
  attached: two `capture-pane -p` calls a few seconds apart show
  it advanced from 3 to 7 steps. (`ch14-progress.txt`.) This is
  the persistence mechanism, captured without ever attaching.
- The session/window/pane containment is real:
  `new-window`/`split-window` build a session with two windows,
  the second holding two panes, confirmed by
  `list-windows`/`list-panes`. (`ch14-structure.txt`.)
- `send-keys` types a command into a pane and `capture-pane`
  reads the result, both without attaching.
  (`ch14-sendkeys.txt`.)
- The self-destruct PITFALL is a real run, not a doc claim: a
  session whose only process is the job ends the moment the job
  exits, so `tmux ls` a few seconds later reports no server.
  (`ch14-selfdestruct.txt`.) The documented mechanism is
  `remain-on-exit` (off by default), so a window closes when its
  program exits and the last window closing ends the session.

## Source-pinned, external / interactive-only (fetched 2026-07-05)

- **Default prefix key `C-b`; `C-b d` detaches; `C-b` sent twice
  passes the prefix through to a nested tmux; `attach-session`
  (`attach`) with `-d` detaches any other clients attached to
  the session; `capture-pane` with `-p` prints the pane contents
  to standard output.** tmux(1) manual.
  <https://man7.org/linux/man-pages/man1/tmux.1.html> and the
  tmux "Getting Started" wiki
  <https://github.com/tmux/tmux/wiki/Getting-Started>. Confirmed
  2026-07-05. The scriptable half of each (`capture-pane -p`,
  session lifecycle) is additionally verified by live capture
  above; the interactive keystrokes cannot be captured
  non-interactively and rely on the manual.
- **GNU Screen's default command character is `C-a`** (commands
  are two keystrokes, `C-a` then one more), so screen's prefix
  differs from tmux's `C-b`. GNU Screen manual, "Command
  Character".
  <https://www.gnu.org/software/screen/manual/html_node/Command-Character.html>
  The command-line flags used in the chapter's DIVERGENCE
  (`screen -S` names a session, `screen -ls` lists, `screen -r`
  reattaches, `screen -dmS` starts one detached) are the screen
  manual's command-line options, "Invoking Screen".
  <https://www.gnu.org/software/screen/manual/html_node/Invoking-Screen.html>
  Both confirmed 2026-07-05. `screen --version` (4.09.00) is a
  real sandbox capture; the `-dmS`/`-ls`/`-X quit` loop was also
  run live in the sandbox during the probe.

## Cross-references (asserted, not re-taught; verified in prior chapters)

- `ssh` and the dropped-connection/`SIGHUP` hazard: Chapter 13
  (committed `8c2cf09`) and Chapter 9's `nohup` section. Chapter
  14 delivers the forward promise both made (Ch 9: "the tool
  built for running long jobs you detach from and later reattach
  to ... is tmux, which Chapter 14 will cover"; Ch 13's closing
  line).
- The `tee` run log: Chapter 10 (committed `f973acb`). The
  REPRODUCIBILITY callout ties the surviving job to its
  surviving log without re-crediting Chapter 10's mechanism.
- The `sbatch` scheduler as the right tool when a job must
  survive a reboot: Chapter 13's HPC section (recognize-and-
  route), contrasted with tmux, which does not survive a reboot.
- The process model (a session is processes that outlive a
  terminal): Chapter 2, framed on, not re-taught.
