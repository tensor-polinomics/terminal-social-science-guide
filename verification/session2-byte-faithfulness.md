# Book-wide byte-faithfulness sweep (review-response Session 2, 2026-07-09)

Prompted by the Codex Ch 7 findings (a dropped `echo $?`/`1` line and a
dropped blank line that broke the "every shown `$`/`>` block is a
contiguous transcript substring" rule), all 256 session code blocks in
`book/chapters/*.qmd` were checked against `transcripts/*.txt`. Method: a
block passes if, after normalizing only the accepted line-continuation
wrapping (`\`), it is a contiguous substring of some transcript, with hash
truncation (a line ending `...`) and marked `[...]` elisions allowed.
**Correction (Codex round 2 -- see the last section): the first pass of
this checker exempted any block that merely CONTAINED a `[...]`, which hid
blocks that mark one elision but silently drop OTHER output. The checker
was rebuilt to require each segment BETWEEN elision markers to be its own
contiguous, in-order transcript slice; that caught four Ch 12 blocks.**
Ch 7 itself came back clean after the two Codex fixes.

Author decisions that set the policy (2026-07-09):
- **Blank lines: restore book-wide.** The transcripts put a blank line
  between successive captured commands; blocks that merged several
  commands into one fence dropped those blanks. Restored so each block is
  again a strict contiguous substring.
- **Wrapped commands: hand-wrap with `\`, no `>` (match the book).** When a
  typed command is wrapped to <=64 cols the chapters show `\` continuations
  without the shell's `>` continuation (PS2) prompt. Transcripts are the
  raw capture and may retain the real `>` (e.g. `ch04-stat-mac.txt`) or not
  (e.g. `ch15-bat-mac.txt`). Output must match byte-for-byte; the `\`-wrap
  and PS2-stripping are accepted presentation transforms (like hash
  truncation and `[...]` elision). The Ch 11 primer was reformatted to this
  convention (see below).

## Fixed (18 blocks) — each re-verified as a contiguous transcript substring

Blank lines restored (transcript verbatim span re-inserted):

- `02-mental-model.qmd`: 8 blocks (`pwd`/`ls`; `echo $HOME`/`ls /`;
  `echo $$`/`ps`; two `bash -c 'echo $$'`; `type cd`/`type ls`;
  `DATASET=`/`export DATASET`; `echo $PATH`/`command -v python3`;
  `ls data/raw`/`echo $?`/`ls nope_dir`/`echo $?`). Transcripts
  `ch02-filesystem`, `-filesystem-mac`, `-process`, `-builtin`, `-env`,
  `-path`, `-exit-codes`.
- `03-setup.qmd`: `apt --version`/`dpkg --version` (`ch03-linux-pkg`).
- `05-navigation.qmd`: `echo $HOME`/`echo ~` (`ch04-home-mac`).
- `12-make-pipeline.qmd`: 3 blocks (`touch`/`make -n`; two
  `touch`/`stat`/`make`) (`ch11-make-mac`, `ch11-timestamp-mac`).

Trailing whitespace restored to match the capture:

- `16-modern-cli-tuis.qmd`: `bat` block (3 line-number lines regained a
  trailing space) and `git diff` block (2 context lines regained a single
  space) (`ch15-bat-mac`, `ch15-diff-mac`).

Merged block split into per-command fences (the shown commands are not
contiguous in the transcript because an un-shown command sits between them,
or they were captured in the other order):

- `03-setup.qmd`: `ps`/`bash --version` split into two fences
  (`ch03-linux-id` captured them in the reverse order);
  `command -v brew`/`brew --prefix` split into two fences
  (`ch03-brew-mac` has `brew --version` between them).

De-wrapped a command that fit on one line, plus restored blanks:

- `12-make-pipeline.qmd`: the `sed`/`make check` failure block; the `sed`
  fit on one line (matching `ch11-make-mac`), and the two dropped blanks
  (after `sed`, before `1 check(s) FAILED`) were restored.

## Ch 11 primer reformatted to the no-`>` convention

The primer's `for`, `while` (counter), and `while read` demos originally
showed the real PS2 `>` continuation prompt. Per the author decision they
were reformatted to the book convention: `for` and the `while` counter on
one line (58 and 62 cols), `while read` hand-wrapped with `\` and no `>`.
`transcripts/ch10-primer.txt` was updated to match; output is unchanged
(re-run 2026-07-09, byte-identical), so all eight primer blocks remain
contiguous substrings of the transcript.

## Not a defect (accepted convention)

- `05-navigation.qmd` `stat -f '%N %z ...'` block: the chapter hand-wraps
  the command with `\` and no `>`; `ch04-stat-mac.txt` retains the real
  `>` continuation prompt. Output matches byte-for-byte. Accepted per the
  wrapping policy above; the transcript is left as the raw capture.

## RESOLVED 2026-07-09 — the one uncaptured block is now captured

- **`12-make-pipeline.qmd` `stat -f '%Fm  %N' output/tables/ff5_alpha.tex
  report.html` block.** Was the one shown output in the book with no
  backing transcript (BSD `stat -f '%Fm'` nanosecond mtimes, not
  producible in the Linux/GNU sandbox). Captured on the Mac via the new
  `transcripts/capture-ch11-mtime-mac.sh` (forced `make -B report.html`,
  then `stat`), producing `transcripts/ch11-mtime-mac.txt` (macOS 26.5.2,
  BSD stat, 2026-07-09). The chapter block was de-wrapped to one line and
  updated to the real mtimes
  (`1783601038.862631182  output/tables/ff5_alpha.tex` /
  `1783601041.000129705  report.html`, 2.14 s apart); it now matches
  byte-for-byte and the "2.14 seconds apart" prose was updated to match.
  The mtimes are non-deterministic, so a future re-capture must re-sync
  the block. (This section originally claimed every shown block was then
  transcript-backed except Ch 5; that was PREMATURE -- Codex round 2 found
  four more Ch 12 blocks with unmarked drift, now fixed; see the final
  section. After those fixes the claim holds.)

## Codex round 2 (2026-07-09) -- Ch 12 make-block drift, all fixed

Codex's round-2 blind audit caught four Chapter 12 blocks the first sweep
missed because of the checker blind spot above (each carried a marked
elision but ALSO dropped real output, or spliced two runs). The checker
was rebuilt (elision- and truncation-aware); the re-sweep now reports only
the accepted Ch 5 PS2 case (255 session blocks, 1 accepted). Fixes:

- **`$ make` full-build block.** Restored the dropped `months=179
  firms=300`, `wrote data/clean/portfolio.csv`, and `alpha %/mo = ...`
  lines plus the blank before `alpha`; marked the uv venv-setup noise with
  `[...]`; kept the hash truncation and the quarto `[...]`. Now an honest
  contiguous slice of `ch11-make-mac.txt`.
- **`touch scripts/02_portfolio.py; make` block.** Same class: restored the
  `wrote`/`mean`/`alpha %/mo` output it had dropped and the blank after the
  touch; one `[...]` for the quarto render. Honest slice of
  `ch11-make-mac.txt`.
- **`make output/figures/cumret.png` Python-subgraph block.** Its single
  `[... uv installs ...]` marker had also swallowed the two
  `wrote data/raw/...` lines, and later `wrote`/`mean` lines were dropped
  unmarked. Restored the raw lines; added `[...]` markers for the two
  genuinely-elided output runs. Honest slice of `ch11-python-subgraph.txt`.
- **`touch scripts/04_regression.R; make` block -- SPLICE, RE-CAPTURED.**
  The chapter showed `touch; make` rerunning the R step AND re-rendering
  the report. The original `ch11-make-mac.txt` capture shows `touch; make`
  reran only the R step and did NOT re-render (a live instance of the tie
  bug the next section teaches); the render-`make` the chapter spliced in
  had no `touch` before it (it followed a `make -n`). Resolved with a
  FRESH Mac capture (author ran it 2026-07-09): the new
  `transcripts/capture-ch11-touch-regression-mac.sh` does a `make` to
  settle, `sleep 2` so the rebuilt table is a clear second newer than the
  report (dodging the tie), then `touch scripts/04_regression.R; make`,
  which reliably reruns Rscript (table) and re-renders the report ->
  `transcripts/ch11-touch-regression-mac.txt` (macOS 26.5.2). The chapter
  now shows that real run (`Rscript` + alpha + `quarto render`, `[...]`
  for the quarto output, then `Output created: report.html`),
  byte-faithful to the new transcript, and the original prose ("only the
  table and the report rebuild") + the `make -n` preview are restored. The
  interim `make -n`-only workaround and its tie-foreshadow were reverted.

The honest-via-marked-elision blocks Codex listed as legitimate
(`14-ssh-remote-compute.qmd` L314/L472; `18-startup-files-path.qmd`
L185/L286) were re-verified with the rebuilt checker: each segment between
markers is a contiguous slice of its transcript, in order -- honest
truncations/elisions, not drift.
