# Source-verification log: Chapter 13 (Environments from the shell)

Per PLAN.md Section 10. Chapter 13 is largely executable on the
Python side: every uv block (`uv sync`, `uv run`, `uv add`,
`uv pip list`, the `.venv` reads) and every lockfile read
(`pyproject.toml`, `uv.lock`, `renv.lock`, `.Rprofile`,
`.gitignore`, the `renv/` listings) is a real sandbox capture.
Two blocks run on the user's Mac (renv::status/restore; the
R.version.string/packageVersion receipts) because the sandbox
has no R and cannot reach CRAN (confirmed at G0); those were
drafted from best-known values and RECONCILED byte-for-byte
2026-07-04 against the user's `capture-ch13-mac.sh` run (the
Ch 8 DuckDB / Ch 9 `fd` / Ch 11 ShellCheck pattern; two
drafted guesses corrected). External behavior is pinned to
official docs, fetched 2026-07-04.

## Provenance classes

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, uv 0.11.19 (aarch64-unknown-linux-gnu, the
  sandbox-preinstalled binary), CPython 3.10.12 (`/usr/bin/
  python3`, the interpreter `uv sync` selected), GNU coreutils
  8.32, jq 1.6. The restore-and-run demos run in a clean `/tmp`
  copy of the asset-pricing project (`pyproject.toml` +
  `uv.lock` + `scripts/` only, so `uv sync` demonstrably
  rebuilds the rest); the `uv add` demo runs in a SEPARATE
  throwaway `/tmp` copy, synced first as setup so the add shows
  only the new package, and the real project lock is never
  touched. The lockfile and `renv/` reads run read-only in the
  real project directory with relative paths. Transcripts:
  `ch13-uv-version.txt`, `ch13-uv-sync.txt`, `ch13-uv-run.txt`,
  `ch13-venv-tree.txt`, `ch13-uv-list.txt`, `ch13-uv-add.txt`,
  `ch13-lockread.txt`, `ch13-renv-tree.txt`. Every sandbox block
  the chapter shows was diffed against its transcript as a
  contiguous substring (14 blocks, all byte-identical; see
  counts). Capture-noise disclosure: `UV_LINK_MODE=copy` is
  exported in the capture environment to silence a
  sandbox-specific uv advisory about hardlinking across
  filesystems (`/tmp` vs the uv cache); it does not change what
  is installed, and it is disclosed in the transcript notes and
  the chapter's provenance note.
- **Mac-backed, RECONCILED byte-for-byte 2026-07-04 (2 blocks,
  4 commands):** `renv::status()` + the no-op `renv::restore()`
  (section 4) and `R.version.string` +
  `packageVersion("fixest")` (section 5), all via
  non-interactive `Rscript` in the real project on the user's
  Mac (macOS 26.5.1, zsh 5.9; R 4.5.3, renv 1.2.3), captured by
  `transcripts/capture-ch13-mac.sh` into `ch13-renv-mac.txt`
  (plus the Mac `uv --version` stamp in `ch13-uv-mac.txt` and
  one full `sessionInfo()` after `library(fixest)` recorded for
  the log and described in prose, not shown as a block). Both
  chapter blocks were re-diffed and are byte-identical. Two
  drafted guesses were corrected against the real capture (the
  Ch 8/8/10 lesson): the R 4.5.3 release date is **2026-03-11**
  (drafted "2026-02-28"), and `packageVersion` prints Unicode
  curly quotes, `[1] ‘0.14.2’`, not ASCII `'0.14.2'` (kept
  byte-faithful in the chapter; FLAGGED for the PDF render
  check, the class of the Ch 6 box-glyph lesson, since the
  curly quotes sit inside a verbatim block). Two drafted calls
  were confirmed as drafted: the status/restore wording matched
  exactly, and renv's loader prints NO banner line under
  `Rscript` (so the auto-activation evidence remains the
  `.Rprofile` read, as drafted). The full `sessionInfo()`
  capture confirms the section-5 prose claims: it reports the R
  version and platform (aarch64-apple-darwin25.3.0), the BLAS
  in use (Homebrew openblas 0.3.32), the locale
  (`C.UTF-8`), the time zone, and `fixest_0.14.2` under "other
  attached packages", with `renv_1.2.3` visible in the loaded
  namespaces. The Mac uv stamp is **uv 0.11.2 (Homebrew
  2026-03-26 aarch64-apple-darwin)**, older than the sandbox's
  0.11.19; the chapter stamps only the sandbox uv and claims
  nothing version-specific about the Mac install, so no chapter
  text changed. The `renv.lock`-side values the receipts agree
  with are sandbox-verified by `jq` (R 4.5.3, fixest 0.14.2,
  `ch13-lockread.txt`), consistent with Chapter 8's committed
  jq reads of the same file.
- **Authored, non-capture:** the `.venv/` annotated layout tree
  (section 2) is a labeled non-runnable `text` schematic (the
  Ch 6 house device, ASCII connectors), paired with the real
  `ls .venv` + `site-packages` listing beside it as evidence;
  its entry names were checked against that listing.

## Behavior verified live in the sandbox (not assumed)

- **`uv sync` restores the locked environment from a bare copy**
  (`ch13-uv-sync.txt`): with only `pyproject.toml` + `uv.lock` +
  `scripts/` present, `uv sync` selects CPython 3.10.12, creates
  `.venv/`, and installs all 20 packages at exactly the locked
  versions (`statsmodels==0.14.6` etc.); a second `uv sync`
  verifies instead of reinstalling ("Checked 20 packages").
- **`uv run` executes inside the project environment without
  activation** (`ch13-uv-run.txt`): step 0 of the pipeline runs
  in the restored copy and reprints the locked content hash
  `49b3a173...`. The chapter is precise that the numbers
  reproduce because the generator is deterministic by design
  (seed 20260629, the G1 invariant `make check` re-derives, not
  re-derived here); the lockfile's contribution is that the
  code computing them is version-identical everywhere.
- **`uv add` updates environment, manifest, and lock together**
  (`ch13-uv-add.txt`): `uv add tabulate` installs
  tabulate==0.10.0, appends `"tabulate>=0.10.0"` to the
  `pyproject.toml` dependencies stanza, and writes the pinned
  `0.10.0` entry into `uv.lock` (shown by before/after reads).
  The resolved version 0.10.0 is itself a
  drafted-guess-would-have-been-wrong case: tabulate's
  well-known version is 0.9.0.
- **The manifest declares ranges, the lock records exact
  versions** (`ch13-lockread.txt`): the real project's
  dependencies stanza is five `>=` floors; `uv.lock` pins
  `statsmodels 0.14.6` and every other package the project
  pulls in (28 `[[package]]` entries; the count includes the
  project itself and per-Python-range duplicates such as three
  `numpy` pins, because the lock is universal, so the chapter
  deliberately does not state a single package count for it),
  and `jq` reads R 4.5.3 / fixest 0.14.2 out of `renv.lock`
  (36 packages, agreeing with Chapter 8's committed jq reads).
- **The environment is a machine-wired artifact**
  (`ch13-venv-tree.txt`): `.venv/pyvenv.cfg` records
  `home = /usr/bin` and `readlink .venv/bin/python` resolves to
  `/usr/bin/python3`, the sandbox machine's interpreter (shown
  with `readlink`, not `ls -l`, so no owner column appears).
- **The project ignores the environments and tracks the locks**
  (`ch13-lockread.txt`): the real `.gitignore` lists `.venv/`
  and `renv/library/` (+ renv/local, cellar, lock, python,
  staging), while `uv.lock` and `renv.lock` are tracked.
- **renv's on-disk layout is platform-named**
  (`ch13-renv-tree.txt`): the real project's `.Rprofile` is the
  one-line `source("renv/activate.R")`, `renv/` holds
  activate.R / library / settings.json / staging, and the
  library sits under `renv/library/macos/R-4.5` (built on the
  author's Mac; listed read-only from the sandbox, which is
  possible precisely because a file listing is not a running
  environment).

## Cross-references honored (no re-teaching)

- **Ch 2 / Ch 10 shell environment vs language environment:**
  section 1 explicitly disambiguates the two meanings of
  "environment"; `PATH`/`export` (Ch 2) and env-var secrets
  (Ch 10) are referenced, not re-taught.
- **Ch 6** named `pyproject.toml`/`uv.lock`/`renv.lock` in the
  layout and deferred operational use to Ch 13; delivered here.
  The commit-the-lock rule applies Ch 6's tracked-vs-regenerated
  line, not a new rule.
- **Ch 8** used `renv.lock` as `jq` material and deferred its
  meaning to Ch 13; delivered (same file, same tool, new
  question). The jq reads here (R 4.5.3, 36 packages' stack,
  fixest 0.14.2) are consistent with Ch 8's committed values.
- **Ch 11**: the run-log habit (`tee`, dated filenames) is
  extended to environment receipts; the REPRODUCIBILITY callout
  assigns each Part-III layer its own pin (Ch 11 shell env,
  Ch 13 language env, Ch 12 orchestration + `make check`)
  without crediting any layer for another's work.
- **Ch 12**: `PY := uv run python` and the `Rscript` node are
  quoted as the seam where Make invokes this chapter's
  environments; no Make mechanics are taught. The seed/content
  hash is referenced as the G1 locked invariant, not re-derived;
  the alpha-locked-at-4dp caveat is attributed to Ch 12's
  record.
- **Ch 5** `readlink` is applied (the `.venv/bin/python`
  symlink), not re-taught.
- **Ch 14 (stub)** stays forward: "which Chapter 14 will lean
  on when this project moves to a remote server."
- **The Git book** owns the why-pin-environments argument
  (PLAN Section 6); cross-referenced in the opening, not
  re-argued.

## Pinned external sources (fetched 2026-07-04)

- **uv, Project structure and files**
  (docs.astral.sh/uv/concepts/projects/layout/) - fetched clean
  2026-07-04 (page dated 2025-10-07). Pins: `pyproject.toml` =
  broad requirements vs `uv.lock` = exact resolved versions;
  the lockfile "should be checked into version control"; the
  `.venv` project environment is NOT recommended for version
  control (uv auto-excludes it via an internal `.gitignore`);
  `uv.lock` is a human-readable TOML file "managed by uv and
  should not be edited manually"; `uv.lock` is a *universal /
  cross-platform* lockfile resolving across operating systems,
  architectures, and Python versions (the DIVERGENCE callout's
  doc anchor); do not modify the environment manually with
  `uv pip install`, use `uv add`.
- **uv, Locking and syncing**
  (docs.astral.sh/uv/concepts/projects/sync/) - fetched clean
  2026-07-04 (page dated 2026-06-05). Pins: locking and syncing
  are AUTOMATIC on `uv run`/`uv sync` (the basis for the
  PITFALL's "uv hides the failure mode locally; the commit
  boundary is where the pair separates"); `uv run --locked`
  errors instead of re-locking when the lockfile is outdated
  (the strict collaborator-side form the PITFALL names);
  `--frozen` skips the check; uv does NOT consider new upstream
  releases a reason to update the lock, upgrades happen only
  via `uv lock --upgrade` / `--upgrade-package` (the basis for
  "a lockfile never goes stale on its own"); `uv sync` performs
  exact syncing by default.
- **renv, Introduction to renv**
  (rstudio.github.io/renv/articles/renv.html, renv 1.2.3) -
  fetched clean 2026-07-04. Pins: `renv::init()` creates the
  project library, `renv.lock`, and a project `.Rprofile` that
  R runs automatically at startup so the project library is
  used ("once you turn on renv for a project, it stays on");
  `snapshot()` records current versions into the lockfile and
  `restore()` installs "exactly the same version of every
  package"; the files to commit are `renv.lock`, `.Rprofile`,
  `renv/settings.json`, `renv/activate.R` (renv writes its own
  `.gitignore` for the rest, which the chapter's `.gitignore`
  read shows on the project side); the lockfile is JSON with
  `R` and `Packages` components. The vignette's Caveats section
  anchors the REPRODUCIBILITY callout's honesty scope: renv
  tracks but does not manage the R version, and does not pin
  the OS / system libraries / compilers, for which it points to
  Docker (also the section-7 Docker paragraph's anchor). The
  packrat-is-superseded point matches the vignette family's
  "packrat vs. renv" article.
- **renv, status() reference**
  (rstudio.github.io/renv/reference/status.html, renv 1.2.3) -
  fetched clean 2026-07-04. Pins: `status()` "reports issues
  caused by inconsistencies across the project lockfile,
  library, and dependencies()" - which anchors the chapter's
  no-manifest-file point (Codex round-1 blocker fix):
  `renv.lock` is compared against the project dependencies; it
  is the lockfile that records versions, not a manifest the
  user edits, and "you should strive to
  ensure that status() reports no issues, as this maximizes
  your chances of successfully restore()ing the project in the
  future or on another machine" (the chapter's "renv's
  documentation is blunt" sentence). The exact clean-state
  output line is NOT quoted in the reference page; it is
  transcript-backed by the Mac capture (`ch13-renv-mac.txt`,
  reconciled byte-for-byte 2026-07-04; see provenance
  classes).
- **renv, dependencies() reference**
  (rstudio.github.io/renv/reference/dependencies.html, renv
  1.2.3) - fetched clean 2026-07-04. Pins the exact
  dependency-discovery language used in the blocker fix:
  `dependencies()` scans project files for R files and package
  uses, primarily by parsing code for `library()`, `require()`,
  `requireNamespace()`, and `package::method()` calls; by
  default it searches the current working directory and its
  children. This is the source for "project code plays the
  manifest-like role; `renv.lock` records the resolved
  versions," with the usual static-analysis caveat.
- **Alternatives named in section 7** (conda/mamba, Poetry,
  pipenv, venv+pip; packrat): named in one breath as
  orientation, no behavior asserted beyond lock-first vs not,
  so no per-tool pin is owed; packrat's supersession is pinned
  to the renv article family above. Docker is NAMED only (PLAN
  Section 3 cut: own book); nothing is run, no Dockerfile is
  shown as runnable.

## Counts (self-check)

- **7 numbered content sections** (5 beginner, 2 advanced) +
  unnumbered `## Try it yourself`:
  1. A language environment is not a shell variable (beginner)
  2. Restore and run: `uv sync` and `uv run` (beginner)
  3. Change it on purpose: `uv add` (beginner)
  4. The same job for R: renv (beginner)
  5. Provenance: what did this run against? (beginner)
  6. Commit the lock, not the environment (advanced)
  7. Beyond uv and renv (advanced)
- **Callouts: 1 PITFALL, 1 REPRODUCIBILITY, 1 DIVERGENCE.**
  PITFALL: manifest and lock separating at the commit boundary.
  REPRODUCIBILITY: the three-layer Part-III stack, with honest
  edges (lockfiles pin packages, not R itself, not the OS, not
  the data). DIVERGENCE: the lockfile is cross-platform by
  design, the built environments are platform-wired
  (`pyvenv.cfg`/symlink on Linux, `renv/library/macos/R-4.5` on
  the Mac). No DANGER (nothing here destroys; deliberate, as in
  Ch 6), no RECOVERY (the recovery IS the restore verbs, taught
  in the body), no figure (the annotated tree carries the
  layout).
- Mechanical: `grep -E '^## ' | grep -v 'Try it yourself' | wc
  -l` = 7; `grep -c '{.tier-beginner}'` = 5; `grep -c
  '{.tier-advanced}'` = 2; em-dashes = 0; validator 0/0 in the
  sandbox AND under the canonical `uv run` on the Mac (Codex,
  2026-07-04); `quarto render book` passed in the final
  re-review (Codex, 2026-07-04: 177-page PDF, Ch 13
  pp. 145-156, Ch 14 starts p. 157, no clipping, the §5 curly
  quotes `[1] ‘0.14.2’`, the long content-sha256 line, and the
  uv sync install list all render clean, so the curly-quote
  render flag is RESOLVED); 16 shown bash blocks = 14 sandbox
  + 2 Mac, ALL byte-identical (contiguous-substring diff
  re-run 2026-07-04 after the reconcile and again after the
  Codex round-1 fixes).
