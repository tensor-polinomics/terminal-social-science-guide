# Changelog

Notable changes to the Terminal & Shell book build, newest first. Dates are
absolute. Detailed design and state notes live in separate planning docs that
are not part of this repo; this file is the repo-visible history.

## [Unreleased]

### Added

- **Chapter 9, "Processes, Permissions, and Secrets" (Phase 4,
  Part II, 3 of 3, the LAST Part-II chapter, so its commit
  CLOSES gate G4; drafted 2026-07-03; validator 0/0 in the
  sandbox AND under the canonical `uv run` on the Mac; 14 sandbox
  blocks byte-backed; the `chown` Mac block RECONCILED
  byte-for-byte against the user's capture, BSD `ps` Mac capture
  in hand; `quarto render book` passed (153-page PDF, Ch 9
  pp. 105-117, no overflow); Codex blind audit rounds 1-2 passed
  (round 1: one content clarification, the secret-handling one,
  plus status-doc reconciliation; round 2: content approved,
  page-figure and status-doc drift reconciled); human review
  approved, and this is the Mac closeout commit that closes G4.
  This commit also carries the
  pending Ch 8 `63090ca` CHANGELOG hash-line touch, since a
  commit cannot contain its own hash).** Draws processes, permissions,
  and secrets together as one idea: who and what can see a file
  or a secret, and where it leaks. Seven content sections (5
  beginner, 2 advanced) plus unnumbered Try-it: running a job in
  the background (`&`, `$!`, `jobs`, `wait`, `kill %1`, and `ps`
  to see it as an OS process); signals and `kill` (default
  SIGTERM is catchable and lets a trapped handler clean up,
  SIGKILL/`-9` cannot be caught, shown with a trap script whose
  cleanup runs on TERM but not on KILL); `nohup` to survive a
  SIGHUP when the terminal closes (the local stopgap, with tmux
  in Chapter 14 and remote work in Chapter 13 as the fuller
  answers); permissions with `chmod` (symbolic `u+x` and octal
  `600`/`644`/`755`, applying not re-teaching Chapter 4's
  reading of the `rwx` triples, with `chmod 600` on a `.env`
  tying permissions to secrets); ownership with `chown`/`chgrp`
  (the privilege-free parts plus the honest un-privileged
  failure, since changing a file's owner needs root); secrets in
  environment variables (Chapter 2's `export` made operational,
  the project's own `.gitignore` secrets stanza as the anchor,
  cross-ref the Git book for never-commit); and where a secret
  leaks (its command-line argument exposed in `ps` to every
  user, its text written to shell history, and its printed
  output copied into logs, screenshots, and agent transcripts).
  Callouts: 2 DANGER (`chmod 777` world-writable; the three-way
  secret leak via history/`ps`/logs, framed as the reveal-it
  sibling of Chapter 6's destroy-it danger), 2 PITFALL (`kill
  -9` skips a process's cleanup; an exported env var is
  inherited by every child process including an AI agent
  launched from the same shell, cross-ref Chapter 16), 2
  DIVERGENCE (BSD vs GNU `ps` invocation, `ps aux` portable vs
  `ps -ef` the System V idiom; bash `HISTCONTROL=ignorespace`
  vs zsh `setopt HIST_IGNORE_SPACE` for the leading-space
  trick), 1 RECOVERY (a leaked secret is rotated at the
  provider, not deleted, since a shown secret cannot be
  un-shown). No REPRODUCIBILITY (not earned); no figure
  (command/output driven; a `~/.ssh` permissions tree is more
  naturally Chapter 13's). Real output: nine sandbox
  transcripts (`ch09-jobs.txt`, `ch09-signals.txt`,
  `ch09-nohup.txt`, `ch09-chmod.txt`, `ch09-env.txt`,
  `ch09-ps.txt`, `ch09-ps-leak.txt`, `ch09-gitignore.txt`,
  `ch09-history.txt`; GNU bash 5.1.16, GNU coreutils 8.32,
  procps-ng 3.3.17, Python 3.10.12; all demos in throwaway
  `/tmp` scratch, every secret value fake, the `ls -l` account
  name masked to `[account]`). Shell history hygiene is a real
  sandbox bash capture (`HISTCONTROL=ignorespace` +
  `set +o history`, `ch09-history.txt`); the zsh equivalent
  (`setopt HIST_IGNORE_SPACE`) is pinned to the zsh manual,
  because an interactive zsh on a real terminal reads the
  keyboard rather than a script's piped input (an earlier Mac
  capture script that drove interactive shells hung on the
  user's terminal and was replaced). The one Mac-backed block,
  `chown` ownership, was RECONCILED byte-for-byte against the
  user's capture (`ch09-chown-mac.txt` matched the draft exactly:
  the un-privileged `chown daemon` fails "Operation not
  permitted", exit 1); the BSD `ps` Mac capture
  (`ch09-ps-mac.txt`) backs the `ps` DIVERGENCE (a `PID ARGS`
  header vs Linux `PID COMMAND`). The capture script runs no
  `sudo`, no interactive shell, and applies the standard
  capture-time masks. Verified live in the sandbox, not
  assumed: the
  SIGTERM-trap-vs-SIGKILL cleanup difference, the exported vs
  unexported env inheritance, the `ps` arg exposure and its
  env-read mitigation, and the `chmod` bit changes. Scope held:
  no re-teaching of Chapter 6's `rm`/`>`/`curl | sh` danger or
  its quoting/null-safety (sibling, referenced), Chapter 2's
  env-var concept (made operational), or Chapter 4's reading of
  the permission string (applied with `chmod`); persistent
  sessions (Chapter 14), remote jobs and `~/.ssh` keys (Chapter
  13), `set -euo pipefail`/locale (Chapter 10) stay forward
  "will"; AI-prompt specifics stay Chapter 16 (present-tense
  cross-ref). Sources pinned in `verification/chapter-09.md`
  (GNU libc Termination Signals, coreutils chmod, bash Bash
  History Facilities/Builtins, zsh Options; all fetched
  2026-07-03).
- **Chapter 8, "Finding Things" (Phase 4, Part II, 2 of 3;
  drafted 2026-07-03; Mac captures reconciled byte-for-byte
  2026-07-03; validator 0/0 in the sandbox and canonical
  `uv run` on the Mac; `quarto render book` passed, 142-page
  PDF, Ch 8 pp. 94-104, no overflow; Codex blind audit passed
  (two should-tighten fixes applied: a prose/command mismatch
  and a byte-identity blank line in the `fd firm_panel` block);
  human review passed; committed + pushed 2026-07-03 as
  `63090ca`; gate G4 stays open until Ch 9 also lands. This
  commit also carries the pending Ch 7 `10cc8b0` CHANGELOG
  hash-line touch, since a commit cannot contain its own hash).** Finding
  files in a tree and searching their contents across it, the
  layer beneath Chapter 7 (which searched inside one named
  file). Seven content sections (5 beginner, 2 advanced) plus
  unnumbered Try-it: `find` by name with a `-name` glob (and
  why the glob is quoted, and why listings are piped through
  `sort` since `find`'s traversal order is unspecified);
  `find` by `-type`, `-size`, and `-mtime` (the last shown on
  files given known timestamps in throwaway scratch, since
  "days ago" is measured from now); acting on results with
  `-exec ... {} +` and the null-safe `find -print0 | xargs -0`
  that REINFORCES (not re-teaches) Chapter 6; the glob-vs-regex
  line from the finding side (`find -name` takes a glob,
  `find -regex` a regex over the whole path), which delivers
  Chapter 7's explicit forward promise; `ripgrep` (`rg`) as
  Chapter 7's `grep` turned loose on a tree (recursive by
  default, `-n`/`-c`, `-g` glob file-filter vs the regex
  pattern), traced across four scripts and two languages via
  the running example's `ls_ret`; `fd` as the ergonomic modern
  `find` (regex by default, smart-case, `-e` extension); and
  the ignore-aware trap. Callouts: 1 DIVERGENCE (BSD vs GNU
  `find`: GNU `-regextype posix-extended` vs BSD `-E` before
  the path, GNU `-printf` absent on BSD, BSD requiring a
  starting path), 1 DANGER (`find -delete` / `-exec rm` across
  a tree with no undo; the look-before-you-leap habit of
  `-print` first, ties to Chapter 6's clobber and Chapter 5's
  raw-data immutability), 1 PITFALL (the headline finding:
  `rg` and `fd` skip `.gitignore`d paths by default, so a
  recursive search silently omits the ignored `data/` and
  `output/` dirs, the very files a researcher hunts; the fix
  is `--no-ignore` / `-I`, naming the path directly, or plain
  `find` which never filtered). No RECOVERY (the DANGER's
  lesson is prevention), no REPRODUCIBILITY (not earned), no
  figure. A verified subtlety, not assumed: `rg`/`fd` only
  honor `.gitignore` INSIDE a git repository (a bare `/tmp`
  copy does not skip `data/` until `.git` exists), and the
  filtering applies to files found by traversal, not to a path
  named explicitly (`rg firm data/` reads the ignored dir).
  Real output: eight sandbox transcripts (`ch08-find.txt`,
  `ch08-find-time.txt`, `ch08-exec-xargs.txt`,
  `ch08-glob-regex.txt`, `ch08-printf.txt`, `ch08-rg.txt`,
  `ch08-ignore.txt`, `ch08-find-delete.txt`; GNU findutils
  4.8.0, ripgrep 13.0.0), run in a clean `/tmp` copy of the
  asset-pricing project made a git repo so the ignore behavior
  is real, with every deletion demo in throwaway `/tmp`
  scratch. The six Mac-backed blocks (BSD `find` `-E`/`-printf`
  divergences, four `fd` blocks) were captured on the author's
  Mac via `capture-ch08-mac.sh` (a throwaway git-repo copy;
  standard capture-time masks incl. the `$TMPDIR` scrub) and
  reconciled byte-for-byte 2026-07-03: five matched the draft,
  one changed (`fd --version` is `fd 10.4.2`, not the drafted
  placeholder `fd 10.2.0`, the Ch 7 DuckDB-version lesson), and
  the no-path check confirmed BSD `find` requires a starting
  path (`find: illegal option -- n`). `fd` is REAL Mac capture,
  not quarantine (user decision 2026-07-03): installed on the
  Mac, a blocked GitHub-release binary in the sandbox. Scope
  held: no re-teaching of Chapter 7's single-file `grep` or the
  regex primer (referenced and contrasted: `rg` = `grep` across
  a tree), no re-teaching of Chapter 6 pipes/quoting (null-
  safety reinforced only); processes/permissions (Chapter 9)
  and locale pinning (Chapter 10) stay forward. The modern kit
  is bounded to `fd`/`rg` (no `bat`/`eza`/`delta`, which are
  viewing, not finding, Chapter 15). Sources: the git-repo
  scoping of `.gitignore` filtering is pinned to the ripgrep
  GUIDE and fd README (both fetched 2026-07-03), plus the live
  captures; logged in `verification/chapter-08.md`.
- **Chapter 7, "Text and Tabular Data as Data" (Phase 4,
  Part II, 1 of 3; drafted 2026-07-02; Mac captures reconciled
  byte-for-byte 2026-07-03; validator 0/0 in the sandbox and
  canonical `uv run` on the Mac; all 39 shown blocks
  transcript-backed; Codex blind audit passed; committed +
  pushed 2026-07-03 as `10cc8b0`; gate G4 stays open until
  Ch 8 and Ch 9 also land).** Treats text and
  tabular files as data from the shell, in two passes: lines
  and fields, then tables. Seven content sections (5 beginner,
  2 advanced) plus unnumbered Try-it: `grep` for content search
  (`-F`, `-n`, `-c`, and anchoring a pattern to the file's
  structure); the globs-vs-regex line Chapter 6 explicitly
  deferred here (shell expands filename globs before the
  command runs; grep/sed interpret regexes over line content);
  `sed` as a stream editor (row windows with `-n 'N,Mp'`,
  header rename redirected to a NEW file per Ch 5's
  raw-in/generated-out hygiene, and the `sed -i` in-place
  hazard); the tabular toolkit `cut`/`sort`/`uniq`/`tr`
  (balance-check via `uniq -c`, ranking via `sort -t, -k2,2gr`
  with the `-g`-not-`-n` scientific-notation point, CRLF
  stripping with `tr -d '\r'`); `awk` kept deliberately shallow
  (fields, a filter with the header-sneaks-past-a-numeric-
  comparison lesson, a column mean; awk-as-programming is an
  explicit PLAN cut); `jq` on the project's real `renv.lock`
  (keys, key path, length, iterate-and-format with `-r`); and
  the DuckDB CLI as the chapter's climax, real SQL directly
  over the raw CSVs and the clean Parquet (SELECT, DESCRIBE,
  aggregate counts, a firm_panel x factors join, a Parquet
  count), version-stamped (DuckDB CLI v1.5.4 "Variegata",
  captured on the Mac 2026-07-03) and pinned to duckdb.org
  docs. Callouts: 2 PITFALL (grep matches
  anywhere in the line, 3640 vs the anchored 3600; `uniq`
  collapses only adjacent duplicates), 1 DANGER (`sed -i` on a
  data file is the `>` clobber wearing an editor's clothes,
  ties to Ch 5 raw-data immutability), 2 DIVERGENCE (BSD
  `sed -i` REQUIRES a backup suffix vs GNU optional; macOS BWK
  awk vs gawk, with the shallow subset portable and `systime()`
  as the gawk-only trap), 1 REPRODUCIBILITY (locale flips
  `sort` order and stream checksums; pinning deferred to
  Ch 10). No figure (none earned). Real output: nine sandbox
  transcripts (`ch07-grep.txt`, `ch07-regex-glob.txt`,
  `ch07-sed.txt`, `ch07-sed-inplace.txt`, `ch07-tabular.txt`,
  `ch07-tr.txt`, `ch07-locale.txt`, `ch07-awk.txt`,
  `ch07-jq.txt`), all in a clean `/tmp` copy of the
  asset-pricing project with file-creating demos in throwaway
  scratch; all 39 shown blocks byte-diffed against them. The
  eight Mac-backed blocks (BSD `sed -i`, `systime()`, six
  DuckDB blocks) quote `capture-ch07-mac.sh` output, ingested
  and reconciled byte-for-byte on 2026-07-03 (DuckDB is REAL
  Mac capture, not quarantine: the CLI is installed on the Mac
  but not installable in the sandbox). Reconcile changed three
  drafted guesses to match reality: the BSD `sed` error text
  spans a newline (`"factors.csv` then `": invalid command
  code f`), the DuckDB CLI is v1.5.4 not the placeholder
  v1.4.1, and `DESCRIBE` prints `NULL` in its
  null/key/default/extra columns, not empty fields; the
  `systime()` failure, awk counts, join floats, and Parquet
  count matched as drafted. The cross-platform locale check
  came back the opposite of the drafted worry: on the Mac,
  `sort` under `C` and `en_US.UTF-8` produced byte-identical
  order and the same two checksums as the sandbox, so the
  REPRODUCIBILITY callout was rewritten to report that
  agreement rather than assert a divergence that did not
  occur. The DuckDB blocks use
  `-csv` output on purpose: the CLI's default duckbox table
  draws Unicode box glyphs, the class the book's LaTeX PDF
  drops (the Ch 5 render lesson). Scope held: no
  `find`/`fd`/`ripgrep` (Chapter 8), no pipe re-teaching
  (Chapter 6, cross-referenced), no locale pinning (Chapter
  10), no environments teaching (Chapter 12; `renv.lock` is
  used as data only). Sources/provenance in
  `verification/chapter-07.md`.
- **House-style device: annotated structure trees (2026-07-02,
  human-review request).** Codified in `CLAUDE.md` (Writing
  rules): when a chapter shows a directory/file *layout*, pair a
  labeled non-runnable `text` tree with the real `ls`/`ls -R`
  output as the evidence beside it (no `$` prompts, <=64
  chars/line). **Connectors are ASCII (`|--`, `` `-- ``, `|`),
  NOT Unicode box-drawing glyphs:** Codex's PDF render showed the
  box glyphs (`├ │ └`) dropping out on Ch 2 p.19, so both trees
  and the rule were switched to font-independent ASCII. First
  used in Ch 5's project-layout tour, then retrofit to Ch 2's
  filesystem-root section (an annotated `/` tree of the common
  system directories, home/usr/etc/var/tmp/opt, beside the real
  `ls /`). Reserved for containment/layout; dependency/data-flow
  graphs stay arrows (Ch 11's `script -> output` block is
  unchanged). Flagged in the rule for Ch 12 (`.venv/`/`renv/`),
  Ch 13 (`~/.ssh/`), and Ch 17 (dotfiles) when those are drafted.
  Both the Ch 2 and Ch 5 trees are ASCII now (validator 0/0), and
  Codex's Mac re-render (2026-07-02, quarto 1.9.36, 118-page PDF)
  confirms they render correctly (Ch 2 p.19, Ch 5 p.56); both
  trees are committed in `6d46e79` (the Ch 2 retrofit rode with
  the Ch 5 commit).
- **Chapter 5, "Organizing a Project from the Shell" (Phase 3,
  Part I, 5 of 5, the LAST Part-I chapter; drafted 2026-07-02;
  validator 0/0 in the sandbox + canonical Mac `uv run`; render
  passed; no Mac capture needed; Codex blind audit round 1 fixed;
  human review passed; committed + pushed `6d46e79`; closes gate
  G3 and carries the Ch 4 `3d5a62b` hash-line touch above).**
  Turns the running example's directory tree into a taught
  layout, built and toured from the shell. Six content sections
  (4 beginner, 2 advanced) plus unnumbered Try-it: scaffolding
  the whole tree in one command (`mkdir -p` with brace
  expansion, shown as separate brace groups so every typed line
  stays within the width rule, plus `echo` to demystify the
  expansion and `touch` for the front-matter files); a tour of
  the project (opening with an annotated layout-tree map added on
  human review, a labeled non-runnable `text` block the real
  `ls -R` output then confirms) naming every home (`data/raw` vs
  `data/clean`, `scripts/` with the numbered steps,
  `output/{figures,tables}`, and the tracked root files
  `Makefile`/`report.qmd`/`README.md`/
  `pyproject.toml`+`uv.lock`/`renv.lock`/`.gitignore`);
  directory hygiene (immutable raw input vs regenerated output,
  the one-directional flow, with the synthetic-data seam noted:
  `00_make_data.py` generates the raw stand-in, immutable from
  there on); what Git tracks vs what `make` rebuilds (the ignored
  data/output dirs are recreated by the scripts on a fresh clone,
  and the `.gitkeep` caveat that it cannot keep a git-ignored
  directory); portable naming that survives a case-sensitive
  server; and the scaffolding tools `copier`/`cookiecutter`. Delivers exactly
  the layout Chapter 6 opens by assuming ("raw data here,
  scripts there, output in its own folder") and the scaffold
  Chapters 1/2/4 promised. Callouts: 1 REPRODUCIBILITY
  (the layout is the precondition for Chapter 11's one-command
  rebuild), 2 PITFALL (a space inside the braces silently makes
  wrong directories; editing raw data in place or mixing
  generated files into source), 1 DIVERGENCE (case-insensitive
  Mac names biting the layout on a Linux server, cross-referenced
  to Chapter 4's capture, not re-shown). No DANGER (nothing here
  destroys; not forced). The book's SECOND figure: an authored
  TikZ layout exhibit (`fig-ch05-layout`, textbook-diagrams
  design system, raw -> scripts -> generated flow with a
  tracked-root band), built in the sandbox and committed as
  source + PDF + SVG under `book/assets/figures/ch05/`. Real
  output: all from the Linux sandbox (`ch05-scaffold.txt`,
  `ch05-place-files.txt`, `ch05-tour.txt`, `ch05-brace-space.txt`,
  `ch05-scaffold-tools.txt`), the scaffold and pitfall in
  throwaway `/tmp` scratch, the tour in a clean copy of the
  asset-pricing tree; every shown block byte-diffed. No
  `capture-ch05-mac.sh`: the only platform divergence (case
  sensitivity) reuses Chapter 4's `ch04-case-mac.txt`.
  `copier`/`cookiecutter` are version-stamped from a real
  install (cookiecutter 2.7.1, copier 9.16.0, current as of
  2026-07-02) but not run, and the one template-invocation block
  is a labeled illustrative `text` fence. The canonical-layout
  rationale and the never-commit rule are cross-referenced to
  the companion Git book, not re-argued. Sources/provenance in
  `verification/chapter-05.md`. Validator 0/0 in the sandbox and
  under the canonical `uv run` on the Mac (2026-07-02); the figure
  PDF placement is confirmed (Codex `quarto render`, 117-page PDF,
  Ch 5 pp. 53-62, no overflow). Two render fixes landed after:
  the annotated-tree box glyphs dropped out of the PDF (now ASCII,
  see the house-device entry above), and Figure 5.1's HTML SVG was
  broken (`dvisvgm --pdf` emitted a 1-node SVG, near-empty in
  HTML), rebuilt font-independently (`gs -dNoOutputFonts` +
  `pdftocairo -svg`, `\usepackage{lmodern}` for the mono labels;
  durable recipe now in `CLAUDE.md`). Codex's Mac re-render
  (2026-07-02, quarto 1.9.36) confirms both: `quarto render book`
  passed, 118-page PDF, ASCII trees on Ch 2 p.19 / Ch 5 p.56 and
  Figure 5.1 clean on p.58. Codex blind
  audit round 1 returned 3 blockers + 1 tighten, ALL FIXED (the
  false `.gitkeep`-in-ignored-dirs workflow rewritten in both the
  section prose and the Try-it exercise, the latter caught on
  Codex re-review; a stale mask claim removed; stale gate docs
  reconciled; the synthetic-data exception added). Gate checks
  passed: validator, render, Codex blind audit, human review,
  commit, and push. **All of Part I (Ch 1-5) is in and gate G3
  is closed.**
- **Chapter 4, "Navigation & file operations" (Phase 3,
  Part I, 4 of 5; drafted 2026-07-02; validator 0/0 in the
  sandbox; Mac captures reconciled 2026-07-02; Codex blind
  audit and human review passed after fixes; committed + pushed
  `3d5a62b`).**
  The daily navigation loop made operational on top of Ch 2's
  model. Seven content sections (5 beginner, 2 advanced) plus
  unnumbered Try-it: where you are and what is here (`pwd`,
  `ls`, `ls <dir>`); moving through the tree (`cd` relative /
  `..` / absolute / `cd -` / `~`, and the `cd`-is-a-builtin
  callback) with a PITFALL on a relative path run from the
  wrong directory; looking closely (`ls -l`/`-a`/`-h`, `stat`,
  and reading the permission string as type + owner/group/other
  rwx triples; `chmod`/`chown` stay Ch 9); making and clearing
  directories (`mkdir -p`, `rmdir` as the
  safe empties-only remove); copying and moving (`cp`, `cp -r`,
  `mv` for rename+move) with the silent-overwrite hazard, the
  look-before-you-leap habit, and `cp -i`/`mv -i`; symbolic
  links (`ln -s`, `readlink`); and case sensitivity. Carries
  the book's FIRST inline BSD-vs-GNU DIVERGENCE callouts on
  everyday commands: `ls -l` `total` block units (512-byte BSD
  vs 1K GNU) + the `-G` false friend (GNU `-G` = --no-group
  suppresses the group column, BSD `-G` colorizes; both accept
  `--color=when`); `stat -c` (GNU) vs
  `stat -f` (BSD); `readlink -f`/`realpath` recent macOS
  parity with older-BSD caution; and the macOS
  case-INSENSITIVE default filesystem vs Linux case-sensitive
  (`Foo.txt` vs `foo.txt`). Callouts: 4 DIVERGENCE, 1 DANGER
  (short: `cp`/`mv` silently clobber, points to Ch 6 + App A),
  1 PITFALL, 1 RECOVERY (honest recovery after a clobber:
  `git restore`, `make` regeneration, or none). No figure
  (none earned). Scope held to the daily loop: no `rm -rf`
  (routed to Ch 6), no project-layout tour (routed to Ch 5),
  no `find`/`grep` searching (routed to Ch 7/8). Real output:
  the portable/GNU side runs in the sandbox in a clean
  `/tmp/asset-pricing` copy and `/tmp` scratch dirs
  (`ch04-*.txt`, all shown blocks byte-diffed to their
  transcripts incl. `stat`'s literal tabs); the BSD divergences
  are captured on the user's Mac by the new read-only
  `transcripts/capture-ch04-mac.sh` (one `mktemp -d` scratch
  removed on exit, installs nothing, masks `$HOME` + the
  account name that `ls -l`/`stat` owner columns now expose,
  plus the `$TMPDIR` folder hash the symlink resolvers reveal).
  Sources/provenance in `verification/chapter-04.md`. Mac
  captures reconciled 2026-07-02 (macOS 26.5.1): the key
  uncertainty resolved, both `readlink -f` and `realpath` work
  on recent macOS, so the symlink DIVERGENCE was rewritten to
  "recent parity, older systems may lack them, prefer plain
  `readlink`"; the real BSD `stat -f` output was added. Gate
  checks included the canonical `uv run` validators, Quarto
  HTML/PDF render checks, Codex blind-audit rounds, and human
  review. The Ch 4 commit also carries the pending post-push
  CHANGELOG hash-line touch that fills in Ch 3's own `d2b173b`
  (a commit cannot contain its own hash).
- **Chapter 3, "Setup: the platform-specific zone" (Phase 3,
  Part I, 3 of 5; drafted 2026-07-01; validator 0/0; Mac captures
  reconciled 2026-07-01; Codex blind audit passed after fixes;
  committed + pushed `d2b173b`).**
  The one chapter
  where platform-specifics run free, as parallel macOS / Linux /
  WSL2 tracks. Seven content sections (5 beginner, 2 advanced)
  plus unnumbered Try-it: opening a terminal per OS (Windows ->
  WSL2 Ubuntu shell, not PowerShell); which shell you have
  (`echo $SHELL`, `ps -p $$`, zsh/bash, $ vs %) with the macOS
  bash-3.2 floor as a DIVERGENCE; package managers (Homebrew vs
  APT, with the tldr install Ch 2 deferred); the Apple Silicon
  `/opt/homebrew` PATH note (`brew shellenv`, persistence routed
  to Ch 17); installing safely (the real Homebrew `curl`-into-bash
  one-liner shown NOT run, a DANGER that extends rather than
  contradicts Ch 6, the fetch-read-run habit, and the
  `sha256sum`-vs-`shasum -a 256` checksum DIVERGENCE); `/mnt/c`
  and the WSL2 boundary; and the four-point PowerShell sidebar
  (PLAN Section 5). Callouts: 3 DIVERGENCE, 1 DANGER, 1 PITFALL
  (installed-but-PATH-can't-see-it). No figure (none in scope).
  Delivers the Ch 1/2/6 promises (parallel tracks; which shell
  and why; how to open a terminal per OS; WSL2-over-PowerShell;
  PATH setup; /mnt/c in practice; tldr install; verifying
  installers). Real output: the Linux track from the sandbox
  (`ch03-linux-*.txt`); the macOS facts read-only from the user's
  Mac via `capture-ch03-mac.sh` (`ch03-*-mac.txt`). WSL2, the
  `apt` install commands, the Homebrew installer, and the
  PowerShell sidebar are documented + quarantined, version-stamped
  "current as of 2026-07-01" and pinned (Homebrew, Microsoft
  Learn, Ubuntu docs) in `verification/chapter-03.md`. No
  installer is run on any machine. The Ch 3 commit (`d2b173b`)
  also carried, and thereby resolved, the pending post-push
  CHANGELOG hash-line touch left over from the Ch 1-2 polish
  (`5f07b30`). Its own `d2b173b` hash line, added here after the
  push, is the new pending touch and rides with the Ch 4 commit
  (a commit cannot contain its own hash).
- **Ch 1 + Ch 2 post-gate polish from human review (2026-07-01,
  seven fixes; committed `5f07b30`).** Reader-facing gaps found in human
  review after the Ch 2 gate: (1) the `$`-prompt reading convention
  is now an explicit convention in Ch 1's "How to read this book"
  (three conventions, was two), with a first-use reminder at Ch 2's
  first command block; (2) Ch 2's streams section now introduces the
  running example properly at its first on-page use (where the
  scripts live, what the two generated CSVs are, the one-portfolio /
  one-regression / one-figure payload, data regenerated from seed
  and not stored in the repo), with the full tour still routed to
  Ch 5/11; (3) the `/Users/[account]` mask is explained as a
  placeholder the reader's machine replaces with a real account
  name; (4) "the terminal is the window" now disclaims any relation
  to the Windows OS; (5) a one-sentence Windows note in "One tree of
  files": drive letters are Windows-proper, WSL2 mounts `C:` at
  `/mnt/c` (pinned to Microsoft Learn in
  `verification/chapter-02.md`); (6) the Ch 2 figure's PDF placement
  reworked twice: dropping `fig-pos="H"` fixed the stranded
  whitespace but let the figure land on a float-only page that split
  the first command block (Codex re-render catch), so the figure is
  now 4.6in with `fig-pos="!tbp"` plus a `placeins` `\FloatBarrier`
  at its section boundary, making a split of that block impossible;
  (7) PDF code blocks now break long
  lines via fvextra in `_quarto.yml` (HTML already wrapped), fixing
  the overflowing BSD `ls` usage line without hand-editing verbatim
  output. Deliberately NOT pulled into Ch 2: platform terminal
  differences, WSL2-vs-PowerShell, and how to open a terminal per
  OS (Ch 3's contracted job, now with explicit forward pointers).
  Counts unchanged (9 sections, 8/1 tiers, 5 callouts); validator
  0/0; Mac re-render confirmed the figure/command-block placement
  and BSD `ls` line wrap.
- **Chapter 2, "The Mental Model" (Phase 3, Part I, 2 of 5; drafted
  2026-07-01, passed the chapter gate, committed `7f849b1`).** The
  conceptual spine the later chapters lean on:
  terminal vs shell vs OS, the one rooted filesystem tree and working
  directories, processes and PIDs (and why `cd` must be a builtin,
  the chapter's one ADVANCED section), environment inheritance and
  `export`, PATH search with first-match-wins, the three standard
  streams introduced in the abstract (mechanics stay in Ch 6), exit
  codes and `$?`, and a help/discovery ladder (`--help`, `man`,
  `tldr`, with `type`/`command -v` taught in the PATH section). Nine
  content sections (8 beginner, 1 advanced) plus unnumbered Try-it
  tied to the asset-pricing example. Delivers the division-of-labor
  contract Ch 6/11/16 forward-referenced ("the shell runs commands";
  Git versions, Make orchestrates, uv/renv and rsync routed forward
  with contract language to still-stub Ch 12/13). The book's FIRST
  figure: an authored TikZ diagram (terminal -> shell -> kernel ->
  process, streams and exit code returning), built with the
  textbook-diagrams design system, committed as source + PDF + SVG
  under `book/assets/figures/ch02/` (HTML/PDF render check passed on
  the Mac at the gate). Twelve new transcripts: nine
  sandbox (`ch02-*.txt`) and three Mac (`ch02-*-mac.txt` via
  `capture-ch02-mac.sh`), including real BSD `--help` rejection,
  zsh-builtin `which`, Homebrew PATH ordering, a real `tldr` run
  (tealdeer 1.8.1, version-stamped), and the sandbox's own stripped
  man pages as the minimized-server example. Callouts: 2 DIVERGENCE,
  2 PITFALL (one of them, `$?` consumed by the next command, was
  demonstrated by the chapter's own first capture attempt), 1
  REPRODUCIBILITY (PATH decides which interpreter runs); no DANGER
  by design, nothing here destroys anything. Sources pinned in
  `verification/chapter-02.md`. Codex blind-audit round 1
  (2026-07-01): render + validator + backing checks all confirmed
  clean; one blocker (the Mac capture script could re-emit the
  full login PATH on rerun) fixed with capture-time masking. Same
  day, personal-data policy set (governance rule in CLAUDE.md +
  `transcripts/README.md`): ALL user-specific data (account/home
  paths, personal file names, usernames, hostnames) is masked with
  bracket placeholders, e.g. `/Users/[account]`, across all tracked
  transcripts and quoted blocks (masks documented in transcript
  notes and the chapter provenance note; pasted-back Mac output is
  masked on ingestion, and capture scripts mask at capture time),
  and the Ch 6 capture script's tee-trailer bug that originally
  wrote a personal path into a committed transcript is fixed.
- **Chapter 1, "Why the Terminal for Researchers" (Phase 3, Part I,
  1 of 5; passed the four-step G3 gate 2026-07-01; committed
  `e3bad9d`).** The book's
  opening chapter, and the lightest: pure framing, no executed commands. Motivates the
  differentiator (a social scientist moving a real pipeline from laptop
  to remote server needs the terminal, the one interface present on
  every machine), but makes the laptop-first case just as hard: even
  before any server, the terminal earns its place because a command is
  a reproducible record where a click is not, commands travel and
  clicks do not (teach/share), and batch file work (rename/move/search/
  extract across many files) is a one-liner instead of a manual
  afternoon (human-review addition, "The payoff starts on the laptop").
  Lays out the spine as one continuous motion (laptop
  -> organize -> script -> Make -> SSH -> tmux -> GPU pod -> bring
  results back -> reproduce), and draws the boundary around what the
  shell will not do (it runs commands; it does not version, reproduce
  environments, or move data by itself, and it can destroy
  irreversibly). Cross-references the companion Git book's
  reproducibility argument instead of re-arguing it (PLAN Section 6).
  Two callouts (REPRODUCIBILITY = the Git-book cross-ref anchor;
  DIVERGENCE = the portable-baseline / macOS-BSD-zsh vs Linux-GNU-bash
  promise). One labeled non-runnable `text` roadmap sketch (each command
  will be taught, with captured output, in its named later chapter; Ch 11
  drafted, Ch 12/13/14 still stubs). Six numbered content sections
  (plus an unnumbered Try-it-yourself), tiered lightly (three
  beginner: the two laptop-value on-ramps and the journey/roadmap;
  the three conceptual-framing sections are untiered because there
  is no beginner/advanced distinction to draw). Reflective
  Try-it-yourself tied to the asset-pricing example. External platform
  facts (macOS zsh default, WSL2 = full Linux, BSD/GNU split) pinned in
  `verification/chapter-01.md`; the shell/coreutils split is already
  transcript-backed from Ch 6. Validator 0/0.
- **Chapter 16, "AI in the Terminal" (Phase 2 exemplar 3 of 3, committed
  `7571ab2`).** The last G2 exemplar, teaching terminal
  AI agents (Claude Code, OpenAI Codex CLI, Google Gemini CLI) principles-first
  and version-stamped ("current as of 2026-07-01"). Covers the durable spine:
  permission models (the ask / auto-edit / trust-everything axis), the
  destructive-command boundary (an agent runs the same shell, so it can issue the
  Chapter 6 `rm -rf` / `>` / `curl | sh` lines), file and scope boundaries,
  network access and supply-chain/prompt-injection risk, secrets in prompts
  (cross-ref Chapter 9), review discipline (diff before you accept), the
  reproducibility of agent-run commands (an agent authors the Makefile, it does
  not replace it), and the short list an agent must never run unsupervised. All
  five callouts present; DIVERGENCE is reframed as tool-vs-tool / version drift:
  each tool has a one-flag trust-all switch (Claude Code `bypassPermissions`;
  Codex `--yolo`, alias for `--dangerously-bypass-approvals-and-sandbox`; Gemini
  `--yolo`), and Codex additionally exposes two independent axes (sandbox mode vs
  approval policy). Deliberately
  document-and-quarantine heavy: live agent sessions are non-deterministic and
  API-costing (all three CLIs are installed on the Mac, but running them is a
  choice not made here), so every agent interaction is a labeled illustrative
  `text` block and the weight is on version-stamping + source-pinning
  (three official docs fetched clean, no Internet-Archive fallback; logged in
  `verification/chapter-16.md`). The one executed block is an AI-free `diff` of a
  decile->quintile edit to `02_portfolio.py` (`transcripts/ch16-review-diff.txt`,
  sandbox /tmp), shown byte-faithful. Validator 0/0. Mac version anchor captured
  for all three tools (Claude Code 2.1.197, Codex 0.142.5, Gemini CLI 0.49.0; help
  output confirms the permission/sandbox flags, incl. Gemini `--yolo` / `--sandbox`
  / `--approval-mode` default/auto_edit/yolo/plan). The kickoff premise that Gemini
  CLI was not installed was wrong (it is at `/opt/homebrew/bin/gemini`; the user has
  since logged it in), so all three CLIs are quarantined by deliberate choice, not
  absence. Codex `--yolo` is docs- and capture-backed (`codex --yolo --version`
  runs) though `codex --help` prints only the long form. Cleared the full gate:
  validator 0/0, Mac HTML/PDF render, human review, and five Codex blind-audit
  rounds (PDF-table overflow; stale conflation wording; stale Codex approval enum
  + `--yolo`; handover consistency; provenance wording), final audit clean, then
  committed + pushed (`7571ab2`). **This clears and closes the G2 style sign-off
  across Ch 6, 11, and 16;** Phase 2 is complete.
- **Chapter 6, "Pipes, Redirection, and the Danger Chapter" (Phase 2 exemplar 2
  of 3, committed `22eec6c`).** Teaches the three streams (stdin/stdout/
  stderr), redirection (`>`, `>>`, `2>`, `2>&1`, the order rule, `noclobber`/
  `>|`), pipes and `pipefail`, and makes DANGER first-class: `>` clobbering,
  `rm -rf` with the empty-variable `${VAR:?}` guard, and a quarantined (never
  run) `curl | sh` with the supply-chain and PATH-hijack risks. Quoting (`"$f"`/
  `"${f}"`), globs-are-not-regex, and null-safe `find -print0 | xargs -0` are
  taught at BEGINNER tier as mandatory shell safety, not advanced garnish. All
  Linux/GNU output is real (sandbox transcripts `transcripts/ch06-*`, every
  destructive demo run in `/tmp`); the macOS/BSD divergences (zsh unmatched-glob
  error vs bash literal pass-through, noclobber wording, BSD null-safe parity)
  were captured on the Mac in `transcripts/ch06-divergence-mac.txt` via
  `transcripts/capture-ch06-mac.sh`. Sources logged in
  `verification/chapter-06.md`. Validator 0/0 (canonical `uv run` on the Mac);
  Mac HTML+PDF render clean (Ch 6 = PDF pp. 13-25, no overflow). Codex blind
  audit received and its findings applied (added `ch06-provenance.txt` +
  `ch06-path-hijack.txt` so every shown block has a real transcript; corrected
  the `"$@"` quoting rule; made the `rm -rf /` claim preserve-root-accurate;
  repointed the `curl|sh` cite to the Internet Archive capture + PoC).
  Human-reviewed and committed (`22eec6c`); part of the cleared G2 sign-off.
- **Chapter 11, "Make as Cross-Language Pipeline Glue" (Phase 2 exemplar 1 of 3,
  committed `5b58eee`).** First drafted chapter; the reproducibility showcase
  built on the committed `sandbox/asset-pricing/` graph. Teaches the dependency
  model, rule anatomy + the TAB trap, automatic variables, the one-command
  cross-language build (Python + R + Quarto), incremental rebuilds, the macOS
  Make 3.81 one-second-timestamp hazard, content-hash `make check`, `.PHONY`,
  illustrative-only Stata/EViews recipes, and a `just`/Snakemake aside. All shown
  output is real (Mac + sandbox transcripts under `transcripts/ch11-*`); sources
  logged in `verification/chapter-11.md`. Cleared the Ch 11 exemplar subgate
  (validator 0/0, HTML+PDF render, Codex blind audit, human review) and committed
  (`5b58eee`); part of the cleared G2 sign-off across Ch 6, 11, and 16.
- **Phase 1 running-example pipeline (G1 cleared)** in `sandbox/asset-pricing/`: a seeded
  synthetic FF5 study wired as one `make` graph. Python (`00_make_data.py` ->
  `01_clean.py` -> `02_portfolio.py` -> `03_figure.py`) generates, cleans,
  forms a decile long-short portfolio, and draws the cumulative-return figure;
  R (`04_regression.R`, fixest) runs the FF5 regression and
  table; `report.qmd` assembles the Quarto/LaTeX report. `scripts/check.py`
  (`make check`) re-derives the data hash and alpha. Python deps pinned in
  `pyproject.toml` + `uv.lock`; R deps via `scripts/bootstrap_renv.R` ->
  `renv.lock` (created on the Mac).
- Reproducibility invariant re-locked after Codex audit found the original
  sandbox hash `76c76eb...` did not reproduce on the Mac. The final G1 lock uses
  deterministic hash-based streams with lambda 0.00149, data SHA-256
  `49b3a173...`, long-short alpha 0.0034/mo (t = 2.635), and a cumulative-return
  figure ending at 103.95%. Verified from VS Code/WezTerm on the Mac: standalone
  R regression, Make-invoked R target, `make check`, HTML render, PDF render,
  and book validator all passed.
- `SETUP.md`: build environment and per-phase dependency guide across three
  machines (Mac, an SSH Linux box, the workspace sandbox).
- `CHANGELOG.md`: this file.

### Changed

- **History rewritten on 2026-07-01 after Ch 2 landed.** Rewrote the
  public Git history with `git filter-repo` so historical transcript
  blobs use the same `/Users/[account]` mask as the current tree.
  New history was force-pushed after a bundle backup; current reachable
  history greps clean for the pre-mask home path.
- **`tools/validate_book.py` width check (option A, Ch 11).** The ~64-char rule
  now applies only to typed command lines (`$ `/`> `) and authored code listings;
  verbatim tool output inside a terminal-session block is exempt, so real
  captured output stays byte-faithful while the gate keeps a meaningful 0/0.

### Decisions

- **Mac-centric, server-optional** framing: the Mac is the assumed reader laptop
  (WSL2 is the similar-enough Windows path); remote compute is framed as "any
  Linux box you can SSH to," and the remote-compute climax is kept.
- All R runs on the Mac; R packages come through project `renv`, not global
  installs.
- Neither the sandbox nor the SSH box has root, so dependencies install per
  phase: Homebrew on the Mac, userspace (PyPI / `~/.local/bin` / HPC modules)
  elsewhere.

## [e81ac03] - 2026-06-29 - Phase 0 scaffold

- Quarto book scaffold: `_quarto.yml` with 17 chapter stubs across 4 parts, plus
  appendices A (panic/safety), B (divergence), C (cheat sheet), a checklist,
  index, and references. No chapter prose yet.
- HTML + PDF output; theme matched to the companion Git/GitHub book, with tier
  badges and five callouts (PITFALL, RECOVERY, REPRODUCIBILITY, DIVERGENCE,
  DANGER).
- `tools/validate_book.py` structural lint (Quarto references, YAML front
  matter, balanced fences, em-dash ban, code width). Gate: 0 errors, 0 warnings.
- `pyproject.toml` + `uv.lock` so the gate runs reproducibly under `uv`.
- Format specs: `verification/README.md` (source log) and
  `transcripts/README.md` (captured-output format). `sandbox/` reserved for the
  Phase 1 pipeline.

## [0e142cd] - 2026-06-29 - Repository genesis

- Initialized the public repository and committed `.gitignore` (the
  repo-boundary policy). Design was specified before any build work began.
