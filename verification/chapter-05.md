# Source-verification log: Chapter 5 (Navigation & file operations)

Per PLAN.md Section 10. Chapter 5 is executable: nearly all of
it is real command output, so this log is lighter on external
pins than Ch 3 and heavier on transcript provenance. Two
provenance classes:

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, GNU coreutils 8.32, aarch64. Run in a clean
  copy of the asset-pricing project at `/tmp/asset-pricing`
  (the sandbox `$HOME` is a `/sessions/...` quirk, so a clean
  `/tmp` copy gives teachable absolute paths, exactly as Ch 2
  used `/tmp/ch02-fs/project`) and in throwaway `/tmp` scratch
  directories for the create/overwrite demos. Transcripts:
  `ch04-pwd-ls.txt`, `ch04-cd.txt`, `ch04-ls-long.txt`,
  `ch04-stat.txt`, `ch04-mkdir.txt`, `ch04-cp-mv.txt`,
  `ch04-symlink.txt`, `ch04-case.txt`. Every sandbox block the
  chapter shows was diffed byte-for-byte against its transcript
  (including the literal tabs in `stat` output).
- **Real, user's Mac (macOS/BSD divergences), read-only,
  RECONCILED 2026-07-02:** produced by
  `transcripts/capture-ch04-mac.sh` (makes ONE `mktemp -d`
  scratch, removes it on exit, installs nothing; masks `$HOME`,
  the bare account name, and the `$TMPDIR` folder hash).
  Transcripts: `ch04-home-mac.txt`, `ch04-ls-mac.txt`,
  `ch04-stat-mac.txt`, `ch04-symlink-mac.txt`,
  `ch04-case-mac.txt` (macOS 26.5.1, zsh 5.9). The user ran the
  script; the chapter's Mac blocks are reconciled to it. Two
  findings landed as edits: (1) on macOS 26.5.1 BOTH
  `readlink -f` and `realpath` resolve the link (exit 0), so
  the symlink DIVERGENCE was rewritten from "uneven, settle by
  capture" to "recent macOS has caught up; both work here, but
  older macOS/bare BSD may not, so portable scripts still
  prefer plain `readlink`"; (2) the BSD `stat -f` output line
  was added to the chapter. All other Mac values matched the
  draft (`~`/`$HOME` -> `/Users/[account]`; BSD `ls -l`
  `total 16` in 512-byte blocks + `ls -G` exit 0; APFS
  case-insensitive: one `Foo.txt`, `cat Foo.txt` -> `lower`).

Masks documented in each transcript `note:` header: home paths
to `/Users/[account]` / `/home/[account]`; the `ls -l` and
`stat` owner/group account name to `[account]` (this is the
first chapter to expose owner columns); and, NEW this chapter,
the macOS per-account `$TMPDIR` folder hash under
`/private/var/folders/<hash>/...` (exposed by `readlink -f` /
`realpath` resolving into the mktemp scratch) masked to
`/private/var/folders/[tmpdir]`. The capture script's `mask()`
was patched to scrub that folder hash on any rerun. The macOS
group `staff`, numeric uids/gids, and the random `ch04mac.XXXXXX`
mktemp suffix are not user-identifying and are left as
captured. Access date for the one external pin below:
2026-07-02.

Forward references: Ch 2, 3, 7, 12 are drafted and cited in
present tense / scope form; Ch 6, 10, 11, 18 and Appendix A are
stubs and every reference to them is a scope statement ("the
subject of Chapter 10", "Appendix A collects...") or
forward-contract language ("Chapter 6 will lean on it",
"Chapter 11 will return to this", "Chapter 18"), never a claim
they already teach or verify anything. (Appendix A is cited in
the present-tense "collects" form to match the committed Ch 7,
which established that phrasing.)

### pwd / ls / cd navigation (working-directory model made operational)
- chapter/section: "Where you are and what is here";
  "Moving through the tree"
- source: live sandbox captures `ch04-pwd-ls.txt` (`pwd`, `ls`,
  `ls data/raw`) and `ch04-cd.txt` (`cd` relative, `cd ..`,
  absolute `cd`, `cd -`, and the PITFALL rerun of `ls data/raw`
  from `/tmp` failing). Operationalizes Ch 2's absolute-vs-
  relative and the "silent precondition" behind `ls data/raw`.
- accessed: 2026-07-02 (capture date)
- verifies: exactly what is shown; the `cd` builtin point is a
  callback to Ch 2 (why `cd` must change the shell's own dir)
- confirmable: yes (transcripts; byte-diffed)

### ~ / $HOME shorthand (shown from the Mac)
- chapter/section: "Moving through the tree"
- source: RECONCILED `ch04-home-mac.txt`
  (`echo $HOME`, `echo ~` -> `/Users/[account]`). Shown from
  the Mac because the sandbox home is a `/sessions` quirk, the
  same reason Ch 2 showed `$HOME` from the Mac.
- accessed: 2026-07-02 (Mac reconcile)
- verifies: the `~`/`$HOME` = home shorthand; Linux `/home`
  noted in prose
- confirmable: yes (captured; matched the draft)

### ls -l / -a / -h and stat (GNU long format + metadata)
- chapter/section: "Looking closely"
- source: live sandbox captures `ch04-ls-long.txt`
  (`ls -l`, `ls -a`, `ls -lh`) and `ch04-stat.txt`
  (`stat`, `stat -c` format). **Human-review addition
  (2026-07-02):** the permission block is now decoded for
  READING (type char + owner/group/other rwx triples, using
  the captured `-rw-r--r--` and `drwxr-xr-x`, incl. execute-on-
  a-directory = may enter); CHANGING permissions (`chmod`, the
  octal 644/755, `chown`) stays Ch 10's job (stub, scope form).
  The decode explains output already captured, so it needs no
  new capture. The modification-time tie to `make` is routed
  to Ch 12 (drafted).
- accessed: 2026-07-02 (capture date)
- verifies: the `-l` field layout, the permission-string decode
  (reading only), dotfiles + `.`/`..` under `-a`, human sizes
  under `-h`, and `stat`'s record incl. the three timestamps
- confirmable: yes (transcripts; `stat` tabs byte-diffed)

### DIVERGENCE: ls -l `total` block units + the -G false friend (BSD vs GNU)
- chapter/section: "Looking closely"; DIVERGENCE 1
- source: GNU side live (`ch04-ls-long.txt`: `total` in 1K
  blocks, and an `ls -l` / `ls -lG` pair showing GNU `-G` =
  `--no-group` SUPPRESSING the group column); BSD side
  RECONCILED `ch04-ls-mac.txt` (`total 16` in 512-byte blocks;
  plain `ls -G` exit 0). The 512-vs-1K block-size default is
  BSD `ls` vs GNU `ls` documented behavior, confirmed both
  sides. The `-G` false-friend: GNU `-G` suppresses the group
  (captured, `ls --help` line `-G, --no-group`); on BSD (macOS)
  `-G` instead colorizes and keeps the group (BSD `ls`(1)
  documented behavior). Both platforms accept `--color=when`,
  so color is NOT the divergence, the short flag `-G` is.
  **Round-1 fix:** the earlier draft's false "BSD `ls` has no
  `--color`" claim was removed (Codex P1). **Round-2 fix:** the
  macOS side is now CAPTURED, not just doc-backed. The user
  re-ran `capture-ch04-mac.sh` and `ch04-ls-mac.txt` shows
  `ls -lG proj/data/raw` on macOS 26.5.1 keeping the `staff`
  group column (identical to `ls -l`), the direct contrast to
  GNU `-G` dropping it. So both sides of the false friend are
  now real output.
- accessed: 2026-07-02 (sandbox + Mac reconcile, two runs)
- verifies: the block-unit difference and the `-G` false
  friend, both platforms captured; default long format
  otherwise near-identical, not over-claimed as a date-format
  difference
- confirmable: yes, both sides captured verbatim

### DIVERGENCE: stat -c (GNU) vs stat -f (BSD)
- chapter/section: "Looking closely"; DIVERGENCE 2
- source: GNU side live (`ch04-stat.txt`, `stat -c '%n %s %A
  %y'`); BSD side RECONCILED `ch04-stat-mac.txt`
  (`stat -f '%N %z %Sp %Sm'` -> a name/size/perms/mtime line;
  the chapter now shows that real output). Different flag AND
  different format specifiers. Portable advice: branch on
  platform or use `wc -c` / `os.stat`.
- accessed: 2026-07-02 (sandbox + Mac reconcile)
- verifies: the flag + specifier divergence; that `stat -c`
  does not run usefully on macOS
- confirmable: yes (both sides captured)

### mkdir / mkdir -p / rmdir
- chapter/section: "Making and clearing directories"
- source: live sandbox capture `ch04-mkdir.txt`: plain `mkdir`
  failing on a missing parent (`echo $?` -> 1), `mkdir -p`
  building the chain (`echo $?` -> 0), `ls -R`, and `rmdir`
  removing an empty dir but refusing a non-empty one. The
  shown exit codes are the real immediate `$?` of each command
  (confirmed by an `exit=$?` probe run with no intervening
  command; the self-documenting capture harness's label-echo
  was kept out so `$?` is not consumed, the Ch 2 pitfall).
- accessed: 2026-07-02 (capture date)
- verifies: exactly what is shown; `mkdir -p` idempotence noted
  and routed forward to Ch 6 scaffolding (stub, "will"); the
  contrast with `rm -r` routed to Ch 7 (drafted)
- confirmable: yes (transcript)

### cp / cp -r / mv, the silent-overwrite DANGER, and cp -i
- chapter/section: "Copying and moving"; DANGER; RECOVERY
- source: live sandbox capture `ch04-cp-mv.txt`: `cp`, `cp -r`,
  `mv` (rename then move), the silent clobber (`cp new.csv
  results.csv` replacing `keep me` with `different`), and
  `cp -i` prompting (`n` fed on stdin for capture; disclosed in
  the transcript note and the chapter). DANGER points to Ch 7
  (owns `>`/`rm -rf`, the `${VAR:?}` guard) and Appendix A;
  RECOVERY cross-refs `git restore` (Git book), `make`
  regeneration (Ch 12), and the no-recovery case.
- accessed: 2026-07-02 (capture date)
- verifies: cp/cp -r/mv behavior, the silent overwrite, the
  `-i` guard; no runnable `rm` demo here (Ch 7 owns the
  mechanics). `rm -r` is named twice as a forward-reference /
  warning only (the DANGER callout and the Try-it cleanup
  note), never shown as an executed command.
- confirmable: yes (transcript)

### ln -s / readlink; DIVERGENCE: readlink -f / realpath (BSD support)
- chapter/section: "Symbolic links"; DIVERGENCE 3
- source: GNU side live `ch04-symlink.txt` (`ln -s`, `ls -l`
  arrow line, `readlink`, `readlink -f`, `realpath` all
  resolving). BSD side RECONCILED `ch04-symlink-mac.txt`
  (macOS 26.5.1): both `readlink -f` and `realpath` resolve the
  link to the absolute path, exit 0, matching GNU. This settles
  the divergence: recent macOS has caught up, but older macOS
  shipped no `realpath` and a `readlink` without `-f`, so the
  chapter keeps the portable advice (rely only on plain
  `readlink` cross-platform; resolve absolute paths another way
  when the target machine's age is unknown).
- accessed: 2026-07-02 (sandbox + Mac reconcile)
- verifies: link creation/inspection (portable); that on macOS
  26.5.1 both resolvers work (the "uneven history, recent
  parity" framing); the relative-target caveat
- confirmable: yes (both sides captured; the historical
  unevenness on older macOS is stated as the reason for the
  portable habit, not independently re-pinned)

### DIVERGENCE: case sensitivity (Linux ext4 vs macOS APFS default)
- chapter/section: "When names collide"; DIVERGENCE 4
- source: Linux side live `ch04-case.txt` (`Foo.txt` and
  `foo.txt` are two distinct files with distinct contents). Mac
  side RECONCILED `ch04-case-mac.txt` (default APFS is
  case-insensitive + case-preserving: `ls` shows one `Foo.txt`
  and `cat Foo.txt` -> `lower`, i.e. `foo.txt` overwrote it, so
  the same names are ONE file). Consequence framed in the bite
  direction: Mac-authored wrong-case paths fail on a
  case-sensitive Linux server; Git two-files-differ-only-by-
  case cannot coexist in a Mac working copy. Routed forward to
  Ch 11 (locale/line-endings, stub, "will").
- accessed: 2026-07-02 (sandbox + Mac reconcile)
- verifies: the case-sensitivity divergence and its
  research/reproducibility consequence
- confirmable: yes (both sides captured)

### Internal cross-references (not externally pinned)
- chapter/section: Ch 5 throughout
- source: this book, Ch 2 (working directory, absolute-vs-
  relative, `cd` is a builtin, the BSD/GNU split, `$HOME` shown
  from the Mac), Ch 3 (a working shell on your platform), Ch 7
  (owns `rm -rf` / `>` clobber / `${VAR:?}`; Appendix A), Ch 12
  (`make` mtime comparison; regeneration); forward to Ch 6
  (scaffolding), Ch 10 (permissions), Ch 11 (locale/case/line
  endings), Ch 18 (aliases in startup files); Appendix A (panic
  reference). The Git book is cross-referenced for `git restore`
  and `.gitignore`, not re-taught.
- accessed: n/a
- verifies: the chapter delivers Ch 1/2's stated Ch-4
  commitments (navigate and move files; the operational layer
  on Ch 2's model) and sets up rather than steals Ch 6/6's jobs
- confirmable: yes (internal)

## Gate confirmations

- **Validator: 0 errors / 0 warnings** in the sandbox (whole
  book and on `book/chapters/05-navigation.qmd` alone, via a
  PyYAML-equipped `python3 tools/validate_book.py book`).
  Canonical `uv run` on the Mac and a `quarto render` PDF
  overflow check are PENDING (Codex/Mac step), as in prior
  chapters.
- **Mac captures: RECONCILED 2026-07-02.** The user ran
  `capture-ch04-mac.sh` (read-only, `mktemp -d` scratch removed
  on exit, installs nothing); the five `ch04-*-mac.txt` files
  back the Mac blocks (macOS 26.5.1, zsh 5.9). Results:
  `~`/`$HOME` -> `/Users/[account]`; BSD `ls -l` `total 16`
  (512-byte blocks) + `ls -G` exit 0; BSD `stat -f` prints the
  name/size/perms/mtime line (added to the chapter); BOTH
  `readlink -f` and `realpath` resolve (exit 0) on this macOS,
  so the symlink DIVERGENCE was rewritten to "recent parity,
  older macOS may lack them"; APFS case-insensitive (one
  `Foo.txt`; `cat Foo.txt` -> `lower`). One extra mask landed
  on ingestion: the `$TMPDIR` folder hash exposed by the
  resolvers, scrubbed to `/private/var/folders/[tmpdir]` and
  the capture script's `mask()` patched to match. A SECOND Mac
  run (2026-07-02, after Codex round 2) captured `ls -lG`
  keeping the group column and refreshed all five transcripts;
  the `$TMPDIR` mask fired at capture time this run (folder
  hash already `[tmpdir]` in the raw file), and the chapter's
  BSD `stat -f` output line was updated to the new run's
  timestamp (13:45:42) to stay byte-identical. Repo
  re-grepped for the account name and the `$TMPDIR` hash:
  clean.
- **Counts:** 7 numbered content sections (5 beginner, 2
  advanced) + unnumbered Try-it; callouts 4 DIVERGENCE, 1
  DANGER (short, points to Ch 7 + App A), 1 PITFALL
  (relative-path-from-wrong-dir), 1 RECOVERY (after a cp/mv
  clobber). No figure (none earned). 0 em-dashes; all shown
  sandbox `$` blocks byte-diffed to a `ch04-*` transcript, and
  the Mac blocks reconciled to the `ch04-*-mac.txt` captures.
- **External pins:** the BSD-vs-GNU divergences (ls block-size,
  the `-G` false friend, stat flag, readlink/realpath, case
  sensitivity) are ALL settled by real capture on both
  platforms (sandbox GNU side, Mac BSD side, reconciled over
  two Mac runs on 2026-07-02), per PLAN Section 10's "run the
  command, use the real output." The round-2 re-run closed the
  last doc-only sub-claim: macOS `ls -lG` keeping the group
  column is now captured in `ch04-ls-mac.txt`. No web-source
  pin and no dead-host/Internet-Archive fallback needed.
