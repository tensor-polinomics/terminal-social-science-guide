# Source-verification log: Chapter 10 (Scripts that fail loudly)

Per PLAN.md Section 10. Chapter 10 is largely executable: the
shebang, `set -euo pipefail`, exit codes, the `trap`, the
`set -e` footguns, `bash -x`, `tee`, `/usr/bin/time -v`, the
`TZ`/`LC_ALL` behavior, and the `verify.sh` anchor are real
sandbox captures. Four blocks are captured on the user's Mac
(ShellCheck, shfmt, the bash-3.2 floor, BSD `/usr/bin/time`/`date`)
because the sandbox cannot produce them; those were drafted from
best-known values and RECONCILED byte-for-byte 2026-07-03 against
the user's `capture-ch10-mac.sh` run (the Ch 7 DuckDB / Ch 8 `fd`
pattern; five drafted guesses corrected). External behavior is
pinned to official docs, fetched 2026-07-03.

## Provenance classes

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, GNU coreutils 8.32 (`cp`, `wc`, `sort`,
  `sha256sum`, `date`), util-linux 2.37.2 (`script`), GNU time
  (`/usr/bin/time`; its `--version` reports the build as
  UNKNOWN, so no version number is asserted), aarch64. All demos
  run in throwaway `/tmp` scratch dirs; the `verify.sh` anchor
  runs over a fresh `/tmp` copy of the running example's
  `data/raw/`. Transcripts: `ch10-shebang.txt`, `ch10-set.txt`,
  `ch10-nosete.txt`, `ch10-exit-trap.txt`, `ch10-footguns.txt`,
  `ch10-debug.txt`, `ch10-tee.txt`, `ch10-time.txt`,
  `ch10-locale.txt`, `ch10-verify.txt`. Every sandbox block the
  chapter shows was diffed against its transcript as a contiguous
  substring (14 blocks, all byte-identical; see counts).
- **Mac-backed, RECONCILED byte-for-byte 2026-07-03 (4 blocks):**
  the bash-3.2 floor (`/bin/bash --version` + `declare -A`
  failure), ShellCheck on `unsafe.sh` (SC2086), shfmt on
  `messy.sh`, and BSD `/usr/bin/time -l`. The user ran
  `transcripts/capture-ch10-mac.sh` (macOS 26.5.1, zsh 5.9; no
  interactive shell, no sudo, standard capture-time masks),
  writing `ch10-bash32-mac.txt`, `ch10-lint-mac.txt`,
  `ch10-bsd-mac.txt`; all four chapter blocks were re-diffed and
  are byte-identical. Five drafted guesses were corrected against
  the real capture (the Ch 7/8 lesson): the system bash build is
  `arm64-apple-darwin25` (drafted `darwin24`); the `declare -A`
  block ends with a real `1` because bash 3.2 rejects `-A` and
  then reads `m[x]=1` as an *indexed* assignment whose `echo`
  prints `1` (a sharper "silently does the wrong thing" point,
  now in the prose); ShellCheck's footer truncates as `globbing
  ...` (drafted `globb...`); `shfmt -d` prints a `diff
  messy.sh.orig messy.sh` header line before the unified diff
  (added); and BSD `/usr/bin/time -l` reports `maximum resident
  set size` `1196032` at its own indentation (drafted a
  different number/indent; the figure varies per run, only the
  `real` line and the RSS line's shape are used). Versions
  stamped from the capture: **ShellCheck 0.11.0, shfmt 3.13.1**
  (current as of 2026-07-03). The `date -d @EPOCH` vs BSD
  `date -r EPOCH` divergence is described in prose and its BSD
  side captured in `ch10-bsd-mac.txt` (`date -r` gives the same
  instant; GNU `date -d @` errors `illegal option -- d` on BSD),
  confirming the prose claim.
- **Authored, non-capture:** the REPRODUCIBILITY callout's
  four-line standard header (`#!/usr/bin/env bash`, `set -euo
  pipefail`, `export LC_ALL=C`, `export TZ=UTC`) is an authored
  listing (no `$` prompts), a summary of the chapter's own real
  blocks, not a transcript.

## Behavior verified live in the sandbox (not assumed)

Each of these was run and its output captured before the chapter
asserted it:

- **`set -e` stops on the first failed command** and yields its
  nonzero status; the following line does not run (`ch10-set.txt`,
  `step.sh`: "step 2" absent, `$?` = 1).
- **`set -u` aborts on an unset variable**, naming the line
  (`ch10-set.txt`, `need.sh`: `line 3: OUTDIR: unbound variable`).
- **A script without `set -e` marches past a failure** and writes
  an empty output while exiting 0 (`ch10-nosete.txt`,
  `summarize.sh`: `sort` fails, `count.txt` = 0, `$?` = 0). This
  is the DANGER.
- **Explicit `exit 3`** propagates the chosen status
  (`ch10-exit-trap.txt`, `guard.sh`).
- **`trap ... ERR`** fires on failure and reports `$LINENO`/`$?`
  before the `set -e` exit (`ch10-exit-trap.txt`, `traps.sh`:
  `failed at line 5 (exit 1)`).
- **The three `set -e` footguns**, each verified live
  (`ch10-footguns.txt`): (1) `local n=$(false-cmd)` masks the
  failure because `local` succeeds, so the function and the
  script continue; (2) a function used as an `if` condition runs
  to the end with `set -e` suppressed; (3) the left side of `&&`
  may fail without aborting. A BARE `n=$(false-cmd)` assignment,
  by contrast, DOES trigger `set -e` (checked in the probe), so
  the chapter attributes the mask to `local`, not to command
  substitution in general.
- **`bash -x`** prints the expanded trace and reveals the failing
  line (`ch10-debug.txt`, `pipeline_step.sh`: line 4 `wc` on a
  missing file, `n` empty).
- **`tee`** writes to a file and the screen at once
  (`ch10-tee.txt`).
- **`/usr/bin/time -v`** prints the resource report; only the
  stable top lines (Command, User, System, %CPU, Elapsed) are
  quoted, and the note flags that the figures vary per run
  (`ch10-time.txt`).
- **`TZ` changes `date` rendering of a fixed epoch**
  (`ch10-locale.txt`: `@1700000000` = `2023-11-14 22:13 UTC` vs
  `17:13 EST`), using a fixed epoch so the shown output is
  byte-stable.
- **`verify.sh` anchor** (`ch10-verify.txt`): the file-level
  `sha256sum -c` against a locked `SHA256SUMS` reports `OK` and
  exits 0 on intact data; after one appended byte it reports
  `factors.csv: FAILED` + the `sha256sum` WARNING, the `ERR` trap
  fires `failed at line 10 (exit 1)`, and `$?` = 1. The locked
  file hashes (`8648c3be...` factors, `5056f919...` firm_panel)
  are `sha256sum` of the deterministic raw CSVs, confirmed
  byte-stable on repeat; they are DISTINCT from the pipeline's
  content digest `49b3a173...` that `make check` re-derives
  (Chapter 11), and the chapter says so rather than conflating
  them.

## Cross-references honored (no re-teaching)

- **Ch 6 `pipefail`** is carried as part of `set -euo pipefail`,
  reinforced not re-derived; the DANGER is framed as the scripted
  sibling of Ch 6's `pipefail` trap. The **`tee`** promise Ch 6
  made ("Chapter 10") is delivered here.
- **Ch 2** exit codes / `$?` / `set -e` are made operational
  (explicit `exit N`, `trap ERR`, `bash -x`), delivering Ch 2's
  forward "will."
- **Ch 3** bash target + bash-3.2 floor is made operational
  (what breaks in a script; `env bash` finds a modern bash).
- **Ch 7** `LC_ALL` pin is delivered as part of the standard
  header; the chapter references, not re-derives, Ch 7's
  locale/sort demo.
- **Ch 11 `make check`** is cross-referenced as the content-hash
  sibling of `verify.sh`'s file-level check; Make mechanics are
  not taught (the script is the node, Make is the graph).
- **Ch 9** `chmod +x`, `>&2`, and the `SIGTERM` cleanup handler
  are referenced (permissions, stderr, trap-as-cleanup), not
  re-taught. Locale/`TZ` that Ch 9 forward-referenced to Ch 10
  is delivered.

## Pinned external sources (fetched 2026-07-03)

- **ShellCheck SC2086** ("Double quote to prevent globbing and
  word splitting"), shellcheck.net/wiki/SC2086 - fetched clean
  2026-07-03. Confirms the rule name and rationale the chapter
  states; the caret span, "(info)" severity, "Did you mean", and
  footer are now RECONCILED against the Mac run (ShellCheck
  0.11.0), byte-identical.
- **shfmt / mvdan.cc/sh** (github.com/mvdan/sh) - fetched clean
  2026-07-03. Latest stable release v3.13.1 (2026-04-06); default
  style uses tabs; `shfmt -l -w script.sh` documented; BSD-3
  license. The chapter's `shfmt -d` diff (the `diff ...orig`
  header, tab indent, `; then` spacing) is RECONCILED against the
  Mac run; installed shfmt is 3.13.1.
- **Bash Reference Manual, The Set Builtin (`-e`, `-u`,
  `-o pipefail`) and Bourne Shell Builtins (`trap`, `ERR`/`EXIT`),
  gnu.org.** The HTML node
  `.../html_node/The-Set-Builtin.html` returned EMPTY on fetch
  this session (a recurring issue with some gnu.org bash HTML
  pages, also seen at Ch 9); the `set`/`trap` behavior the chapter
  asserts is PRIMARY-evidenced by the live sandbox captures above,
  which is stronger than a doc for behavior. Re-pin from a
  reachable mirror on a later pass if a doc citation is wanted.
- **POSIX / execve shebang portability:** the `#!` interpreter
  line and the `/bin/sh`-is-dash-on-Debian point are standard
  behavior; the `/bin/sh` = dash fact is Debian policy (Debian
  ships `dash` as `/bin/sh`). Prefer `#!/usr/bin/env bash` so
  `PATH` lookup finds a Homebrew/Linuxbrew bash.
- **GNU time `-v` vs BSD `-l`; `time` the shell keyword.** GNU
  `/usr/bin/time -v` verified live in the sandbox
  (`ch10-time.txt`); the BSD `-l` form is captured on the Mac and
  reconciled. `time` as a bash keyword vs `/usr/bin/time` the
  program is standard bash behavior.
- **util-linux `script`** records a full session into a
  `typescript`. Its sandbox output carries a non-deterministic
  timestamp header, `^M` carriage returns, and a
  `[<not executed on terminal>]` non-TTY artifact, so `script` is
  presented in PROSE with its command form (not a captured block),
  the way Ch 9 handled interactive-only features. `tee` is the
  fully-captured everyday tool.

## Counts (self-check)

- **7 numbered content sections** (5 beginner, 2 advanced) +
  unnumbered `## Try it yourself`:
  1. The shebang and the bash target (beginner)
  2. Fail loudly: `set -euo pipefail` (beginner)
  3. Exit codes you can act on: `exit`, `$?`, `trap` (beginner)
  4. Lint before you run: ShellCheck and shfmt (beginner)
  5. Leave a run log you can trust (advanced)
  6. Pin the environment: `LC_ALL` and `TZ` (beginner)
  7. Putting it together: a `verify.sh` for the project (advanced)
- **Callouts: 1 DANGER, 1 PITFALL, 2 DIVERGENCE,
  1 REPRODUCIBILITY, 1 RECOVERY.** DANGER: a no-`set -e` script
  writes a silent empty output. PITFALL: the three `set -e`
  footguns. DIVERGENCE: macOS bash-3.2 floor; BSD `/usr/bin/time`
  `-l` (and BSD `date -r`). REPRODUCIBILITY: the pinned standard
  header. RECOVERY: debug a failed script with `bash -x`. No
  figure (command/output driven).
- Mechanical: `grep -E '^## ' | grep -v 'Try it yourself' | wc -l`
  = 7; `grep -c '{.tier-beginner}'` = 5; `grep -c
  '{.tier-advanced}'` = 2; em-dashes = 0; validator 0/0 (sandbox
  AND canonical Mac `uv run`, Codex 2026-07-03); widest typed
  line 62 (<= 64, output exempt).
