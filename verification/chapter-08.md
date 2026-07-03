# Source-verification log: Chapter 8 (Finding things)

Per PLAN.md Section 10. Chapter 8 is executable: nearly all of
it is real command output, so this log is heavier on transcript
provenance than on external pins. Provenance classes:

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, GNU findutils 4.8.0 (`find`, `xargs`),
  ripgrep 13.0.0, aarch64. Run in a clean copy of the
  asset-pricing project placed at `/tmp/ap` and turned into a
  git repository (`git init`, no commit needed) so the
  ignore-aware behavior is real; every file-deleting demo is
  confined to throwaway `/tmp` scratch, never the project's own
  files. Transcripts: `ch08-find.txt`, `ch08-find-time.txt`,
  `ch08-exec-xargs.txt`, `ch08-glob-regex.txt`, `ch08-printf.txt`,
  `ch08-rg.txt`, `ch08-ignore.txt`, `ch08-find-delete.txt`.
  Every sandbox block the chapter shows was diffed line-for-line
  against its transcript (see the counts section).
- **Real, user's Mac (macOS/BSD `find` divergences + `fd`),
  read-only: INGESTED and RECONCILED 2026-07-03** (macOS
  26.5.1, zsh 5.9, Apple Silicon). The user ran
  `transcripts/capture-ch08-mac.sh` (makes ONE `mktemp -d`
  scratch holding a git-repo copy of the project's `scripts/`
  + `data/` + `.gitignore`, removes it on exit, installs
  nothing; applies the standard capture-time masks incl. the
  `$TMPDIR` folder-hash scrub; preflight checks for `fd` and
  the data files). It wrote `ch08-find-mac.txt` and
  `ch08-fd-mac.txt`; masks verified (no home path, account
  name, or `$TMPDIR` hash in either). Of the six Mac-backed
  blocks, FIVE matched the draft byte-for-byte and ONE changed:
  `fd --version` is `fd 10.4.2`, not the drafted `fd 10.2.0`
  (the Ch 7 DuckDB version lesson; fixed in the chapter). The
  no-path check confirmed the prose: BSD `find -name '*.py'`
  fails (`find: illegal option -- n` + usage), so a starting
  path is required. The six blocks:
  1. BSD `find -E scripts -regex '.*/0[0-9]_.*[.]py'` (the four
     numbered scripts) - MATCHED the draft (same four scripts).
  2. BSD `find scripts -name '*.py' -printf '%f\n'` FAILURE -
     MATCHED: `find: -printf: unknown primary or operator`,
     byte-for-byte.
  3. `fd --version` - CHANGED on reconcile to `fd 10.4.2`
     (drafted `fd 10.2.0` was wrong; version-stamped from the
     real capture, the Ch 7 DuckDB v1.4.1 -> v1.5.4 lesson).
  4. `fd -e py | sort` - MATCHED (the five `scripts/*.py` paths).
  5. `fd firm_panel` - MATCHED (empty; the file is ignored).
  6. `fd -I firm_panel` - MATCHED (`data/raw/firm_panel.csv`).
  The Mac script also records a `find -name '*.py'` (no path)
  run to check the prose claim that BSD `find` requires a
  starting path; that block is not shown in the chapter, only
  used to confirm/refute the sentence.

No masks appear in the shown blocks (no user-specific data in
any of them: relative paths, project filenames, identifiers,
and line counts only). The capture script still masks at
capture time as a guard, per `transcripts/README.md`.

## Pinned external claims

1. **ripgrep skips `.gitignore`d paths by default, but only
   inside a git repository; `--no-ignore` (and `-u`) turn it
   off.** Pinned: ripgrep GUIDE.md, "Automatic filtering"
   (https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md,
   fetched 2026-07-03): by default rg ignores files matching
   "`.gitignore` globs (including global and repo-specific
   globs). This includes `.gitignore` files in parent
   directories that are part of the same `git` repository.
   (Unless the `--no-require-git` flag is given.)" and "You can
   disable all ignore-related filtering with the `--no-ignore`
   flag." The `-u`/`-uu`/`-uuu` escalation ("`-u` will disable
   `.gitignore` handling, `-uu` will search hidden files ...")
   is from the same section. The chapter's PITFALL claim, and
   the "inside a git repository" wording, rest on this plus the
   sandbox capture (`ch08-ignore.txt`): with `.git` present rg
   omits `data/`, and `--no-ignore` restores it. The
   git-repo-scoping was verified live (a copy WITHOUT `.git`
   did not skip `data/`; adding `.git` made it skip).
2. **rg applies ignore rules to files found by traversal, not
   to paths named explicitly.** Verified live in the sandbox
   (`rg -l 'firm' data` reads the ignored `data/` dir when it is
   named directly, while `rg -l 'firm' .` omits it); consistent
   with the GUIDE's model that automatic filtering happens
   during recursive directory traversal. Backs the chapter
   sentence "pointing it straight at an ignored path searches
   that path anyway."
3. **`find` never consults `.gitignore`.** Shown by contrast in
   `ch08-ignore.txt` (`find . -name 'firm_panel.csv'` finds the
   ignored file). `find` (POSIX/GNU findutils) has no notion of
   git; no separate pin needed.
4. **fd ignores `.gitignore` by default; `-I`/`--no-ignore`
   disables it; the search pattern is a regex by default;
   `-e`/`--extension` filters by extension.** Pinned: fd
   README (https://github.com/sharkdp/fd/blob/master/README.md,
   fetched 2026-07-03): Features list "Regular expression
   (default) and glob-based patterns", "Ignores patterns from
   your `.gitignore`, by default", and "If we work in a
   directory that is a Git repository ... *fd* does not search
   folders ... that match one of the `.gitignore` patterns. To
   disable this behavior, we can use the `-I` (or `--no-ignore`)
   option"; the `-h` option table lists `-I, --no-ignore`,
   `-e, --extension`, `-g, --glob`, and smart-case defaults.
   The chapter's fd blocks are ALSO real Mac captures
   (`ch08-fd-mac.txt`, reconciled 2026-07-03), which are the
   primary evidence; the doc is the secondary pin, and the
   version stamp (`fd 10.4.2`) comes from the captured
   `fd --version`.
   fd install is `brew install fd` on macOS (README, macOS
   section). Note the Debian/Ubuntu binary is `fdfind`, not
   relevant to the Mac capture but worth knowing for a server.
5. **BSD `find` uses `-E` for extended regex and lacks
   `-printf`; GNU `find` uses `-regextype` and has `-printf`.**
   GNU side captured in the sandbox (`ch08-glob-regex.txt` for
   `-regextype posix-extended`, `ch08-printf.txt` for
   `-printf '%f\n'`). BSD side captured on the Mac
   (`ch08-find-mac.txt`, reconciled 2026-07-03): the
   `-E`-before-path spelling matched, the `-printf` failure
   text matched byte-for-byte (`find: -printf: unknown primary
   or operator`), and `find -name` with no path fails with
   `find: illegal option -- n`. No web pin needed: both sides
   are
   real output on the two platforms the book targets (the
   appendix divergence table collects them).

## Cross-chapter promises touched

- **Ch 7's forward promise is delivered.** Ch 7 said "Chapter 8
  will draw the same [glob-vs-regex] line from the other side,
  when it searches file trees and their contents." The
  "Glob or regex, from the finding side" section does exactly
  that: `find -name` takes a glob, `find -regex` and `rg -g`
  vs the `rg` pattern separate glob (files) from regex (text).
  Present tense (Ch 7 is committed, `10cc8b0`).
- **Ch 6 null-safety is REINFORCED, not re-taught.** The
  `find -print0 | xargs -0` block points back to Ch 6's rule
  (present tense; Ch 6 committed `22eec6c`); pipes/quoting
  themselves are not re-explained.
- **Ch 5 raw-data immutability** is cross-referenced in the
  DANGER callout (present tense; Ch 5 committed `6d46e79`): the
  `.gitignore` that hides `data/` is the one Ch 5 set, and the
  look-before-you-leap habit ties to Ch 5's immutability rule
  and Ch 6's clobber hazard.
- **Ch 4** `ls -l`/`stat` metadata is referenced (present
  tense; committed `3d5a62b`) as the properties `find -size`
  and `-mtime` select on.
- **Ch 13 (rsync, servers)** referenced with forward "will"
  language (stub): the `-size` demo motivates knowing a file's
  size before an rsync.
- **Ch 3** `brew install` is present tense (Ch 3 committed
  `d2b173b`) for the `fd` install line, version-stamped
  "current as of 2026-07-03".

## Counts (self-check, 2026-07-03)

7 content sections + unnumbered Try-it; 5 beginner, 2 advanced.
Sections: (1) Finding files by name, (2) Finding by type,
time, and size, (3) Acting on what you find: -exec and
null-safe xargs, (4) Glob or regex from the finding side,
(5) Searching contents across a tree: ripgrep [all beginner],
(6) fd: the ergonomic find, (7) When search skips your data
[both advanced]. Callouts: 1 DIVERGENCE (BSD vs GNU find),
1 DANGER (find -delete / -exec rm), 1 PITFALL (ignore-aware
default hides data/). No RECOVERY (the DANGER's whole lesson is
prevention: -print before -delete). No REPRODUCIBILITY (not
earned; nothing here is a determinism/replication step). No
figure (none earned; the chapter is command/output driven).
Shown `$` blocks: all sandbox blocks byte-diffed to a
transcript; the six Mac-backed blocks reconciled byte-for-byte
2026-07-03 (five matched as drafted, `fd --version` corrected
to `fd 10.4.2`). Validator: canonical command is
`uv run python tools/validate_book.py book`, 0/0 (in the
sandbox; confirm on the Mac at the gate). Bare `python3
tools/validate_book.py book` requires PyYAML, which a stock Mac
`python3` lacks, so always use the `uv run` form.
