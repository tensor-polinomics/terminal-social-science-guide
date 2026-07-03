# Source-verification log: Chapter 7 (Text and tabular data as data)

Per PLAN.md Section 10. Chapter 7 is executable: nearly all of
it is real command output, so this log is heavier on transcript
provenance than on external pins. Provenance classes:

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, GNU coreutils 8.32, GNU grep 3.7, GNU sed
  4.8, GNU Awk 5.1.0, jq 1.6, aarch64. Run in a clean copy of
  the asset-pricing project at `/tmp/ap` (the repo-relevant
  tree, as Ch 5's tour used), with every file-creating or
  in-place demo confined to throwaway `/tmp` scratch
  (`/tmp/ch07`, a separate scratch for the `sed -i` demo),
  never the project's own data. Transcripts: `ch07-grep.txt`,
  `ch07-regex-glob.txt`, `ch07-sed.txt`,
  `ch07-sed-inplace.txt`, `ch07-tabular.txt`, `ch07-tr.txt`,
  `ch07-locale.txt`, `ch07-awk.txt`, `ch07-jq.txt`. Every
  sandbox block the chapter shows was diffed byte-for-byte
  against its transcript (31 of the chapter's 39 shown blocks;
  the other 8 are the Mac captures below).
- **Real, user's Mac (macOS/BSD divergences + DuckDB),
  read-only: INGESTED and RECONCILED 2026-07-03** (macOS
  26.5.1, zsh 5.9, Apple Silicon). The user ran
  `transcripts/capture-ch07-mac.sh` (makes ONE `mktemp -d`
  scratch, removes it on exit, installs nothing; applies the
  standard capture-time masks incl. the `$TMPDIR` folder-hash
  scrub; preflight checks for `duckdb` and the data files).
  Transcripts in: `ch07-sed-mac.txt`, `ch07-awk-mac.txt`,
  `ch07-sort-locale-mac.txt`, `ch07-duckdb-mac.txt`; masks
  verified (repo greps clean of home paths, account name, and
  the `$TMPDIR` hash). The chapter's 8 Mac-backed blocks (the
  BSD `sed -i` failure, the `systime()` failure, and the six
  DuckDB blocks) were reconciled byte-for-byte. Three drafted
  guesses changed to match the capture: (a) the BSD `sed`
  error text spans a newline (`sed: 1: "factors.csv` then
  `": invalid command code f`), not one line; (b) the DuckDB
  CLI is v1.5.4 "Variegata" (`08e34c447b`), not the placeholder
  v1.4.1; (c) `DESCRIBE` prints `NULL` in the
  null/key/default/extra columns, not empty fields. The
  `systime()` failure text and exit 2, the awk filter count
  (33) and mean (0.00718315), the join means, and the Parquet
  count (179) all matched as drafted. DuckDB is a REAL Mac
  capture, not quarantine (user decision 2026-07-02: DuckDB is
  installed on the Mac; the CLI binary is a blocked
  GitHub-release download in the sandbox, so it cannot run
  there).

No masks appear in the shown blocks (no user-specific data in
any of them: relative paths, project filenames, and data values
only). The capture script still masks at capture time as a
guard, per `transcripts/README.md`. Upstream third-party
metadata inside `renv.lock` (package authors' emails) is not
user data and is untouched; the chapter's jq queries print only
package names and versions.

## Pinned external claims

1. **DuckDB CLI `-c` and `-csv` arguments** (run a command and
   exit; CSV output mode). Pinned:
   https://duckdb.org/docs/current/clients/cli/arguments.html
   (fetched 2026-07-02; table lists `-c COMMAND` "Run COMMAND
   and exit" and `-csv` "Set output mode to csv"; the default
   interactive mode is the box-drawing `duckbox`, which is why
   the chapter's blocks use `-csv`: the box glyphs are the same
   class the book's LaTeX PDF drops, the Ch 5 render lesson,
   and CSV output composes with the chapter's other tools).
2. **DuckDB CLI is a single, dependency-free executable, based
   on the SQLite shell.** Pinned:
   https://duckdb.org/docs/current/clients/cli/overview.html
   (fetched 2026-07-02). The chapter's "single-binary, no
   server, no import step" sentence rests on this plus the
   capture.
3. **DuckDB queries CSV and Parquet files directly by path.**
   Verified by the Mac capture (`ch07-duckdb-mac.txt`,
   reconciled 2026-07-03) and by the docs, fetched 2026-07-03:
   the CSV overview shows `SELECT * FROM 'flights.csv'` and the
   Parquet overview shows `SELECT * FROM 'test.parquet'` and
   `DESCRIBE SELECT * FROM 'test.parquet'`, exactly the
   path-as-table form the chapter uses:
   https://duckdb.org/docs/current/data/csv/overview and
   https://duckdb.org/docs/current/data/parquet/overview. The
   chapter's closing sentence points readers at duckdb.org.
   Version stamp: the chapter says "current as of 2026-07-03"
   for the DuckDB material; the captured `duckdb --version`
   line (`v1.5.4 (Variegata) 08e34c447b`, Mac, 2026-07-03) is
   the authoritative version evidence.
4. **`systime()` is a gawk extension, not POSIX awk.** Pinned:
   https://www.gnu.org/software/gawk/manual/html_node/Time-Functions.html
   (fetched 2026-07-02: "They are gawk extensions; they are not
   specified in the POSIX standard."). The macOS failure is
   captured (`ch07-awk-mac.txt`, 2026-07-03: BWK awk prints
   `awk: calling undefined function systime` / ` source line
   number 1` and exits 2); the DIVERGENCE callout claims only
   what the capture shows and the manual states.
5. **GNU `sort -n` does not parse scientific notation; `-g`
   does.** Checked live in the sandbox (2026-07-02):
   `printf 'a,-4.2e-05\nb,-0.5\nc,2\n' | sort -t, -k2,2n`
   orders `-4.2e-05` before `-0.5` (numeric prefix read as
   -4.2), while `-k2,2g` orders correctly. Not a shown block;
   backs the prose sentence in the tabular section. The
   chapter's example values (`-4.2e-05` in the hml column) are
   from the real `factors.csv` (grep-verified 2026-07-02).
6. **BSD `sed -i` requires a suffix argument; GNU makes it
   optional.** GNU side captured in the sandbox
   (`ch07-sed-inplace.txt`, GNU sed 4.8 accepts bare `-i`);
   BSD side captured (`ch07-sed-mac.txt`, 2026-07-03: bare
   `-i` fails with `sed: 1: "factors.csv` + newline +
   `": invalid command code f`, exit 1). No web pin needed:
   both sides are real captures on the two platforms the book
   targets.
7. **Locale changes `sort` order and stream checksums.**
   Demonstrated live in the sandbox (`ch07-locale.txt`,
   LC_ALL=C vs en_US.UTF-8, different order and different
   sha256). Cross-platform reconcile (`ch07-sort-locale-mac.txt`,
   2026-07-03): the Mac's BSD `sort` under BOTH `C` and
   `en_US.UTF-8` produced order byte-identical to the sandbox
   and the SAME two `shasum -a 256` values the chapter shows
   under `sha256sum` (`2335b02a...` for `C`, `544c6e64...` for
   UTF-8). So the drafted "same locale name can order
   differently across platforms" was NOT observed here; the
   REPRODUCIBILITY callout was rewritten to report the observed
   agreement and to keep the durable point (a locale name
   promises a language, not a byte order; pin `LC_ALL=C`). The
   note headers in `ch07-sort-locale-mac.txt` and
   `capture-ch07-mac.sh`, which had speculated that macOS UTF-8
   locales collate in byte order unlike glibc, were neutralized
   (per the Codex audit) to describe only what is tested;
   collation is platform-defined, and whichever order appears
   is recorded and compared with the sandbox. The captured
   output lines are untouched. Locale pinning itself is
   deferred to Chapter 10 (forward language).
8. **jq syntax** (`keys`, key paths, `length`, `.[]` iteration,
   `-r`). All capture-backed (`ch07-jq.txt`, jq 1.6 on the
   project's real `renv.lock`). Manual fetched 2026-07-03:
   https://jqlang.org/manual/ documents `-r`/`--raw-output`
   and the builtins used.

## Cross-chapter promises touched

- Ch 6's deferral "grep and sed use [regex] (Chapter 7 and
  Chapter 8 draw that line carefully)" is delivered by the
  globs-vs-regex section; Ch 8 references use forward "will"
  language (Ch 8 is a stub).
- Pipes, redirection, heredoc kinship, quoting, and the `>`
  clobber are cross-referenced to Ch 6 (present tense), not
  re-taught.
- Raw-in/generated-out hygiene cross-referenced to Ch 5
  (present tense); every edited file lands in `/tmp` scratch.
- Locale pinning deferred to Ch 10, environments/lockfiles to
  Ch 12 (both "will," stubs).
- The Ch 11 references (Makefile, `make check` hash lock,
  locked alpha 0.0034) are present tense (Ch 11 committed);
  the Try-it item 6 number 0.0034 matches the locked invariant
  (CLAUDE.md).

## Counts (self-check, 2026-07-02; reconcile 2026-07-03)

7 content sections + unnumbered Try-it; 5 beginner, 2 advanced.
Callouts: 2 PITFALL, 1 DANGER, 2 DIVERGENCE, 1 REPRODUCIBILITY
(no RECOVERY: nothing here destroys without warning once the
DANGER is heeded; recovery routes are Ch 6's and Appendix A's).
No figure (none earned). All 39 shown `$`/`>` blocks
byte-diffed to a transcript (31 sandbox + 8 Mac). Validator:
the canonical command is `uv run python tools/validate_book.py
book`, 0/0 (in the sandbox, and on the Mac confirmed by Codex
2026-07-03 alongside a clean 132-page `quarto render`, Ch 7 on
pp. 79-93). Bare `python3 tools/validate_book.py book` requires
PyYAML, which a stock Mac `python3` lacks
(`ModuleNotFoundError: No module named 'yaml'`), so always use
the `uv run` form.
