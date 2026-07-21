# Changelog

Notable changes to the Terminal & Shell book build, newest first. Dates are
absolute. Detailed design and state notes live in separate planning docs that
are not part of this repo; this file is the repo-visible history.

## [Unreleased]

### Changed

- **Preface revision for the publisher proposal (2026-07-21; not
  yet committed). Prose-only expansion of the Preface
  (`book/index.qmd`); no chapters, captured output, or the
  real-output/masking contract changed. Adds two sections: "Why
  this book exists" (a short first-person account of the gap the
  book fills for researchers, versus material written for sysadmins
  and engineers) and "The companion volume" (states the division of
  labor with *Git and GitHub for Social Science Researchers* and
  names the two deliberately-split boundary topics: environments,
  built at the shell in this book's Chapter 13 versus recorded in
  the repository in the companion's Chapter 8; and AI tools,
  directed at the prompt in this book's Chapter 17 versus reviewed
  as diffs in the companion's Chapter 16). Two smaller edits: the
  opening paragraph now names the companion volume in full with its
  italic title rather than "the companion Git book", and the "From
  first prompt to remote server" audience card is broadened to
  include the practicing researcher or analyst who was never
  formally taught the shell. Chapter cross-references stay plain
  prose per house style; the HTML-only hero-band buttons are
  unchanged. Verified pure ASCII, zero em-dashes, balanced Quarto
  fences. Source files touched (this CHANGELOG also updated):
  `book/index.qmd`. Awaiting the Mac-side gate (validator +
  `quarto render` + Codex read-through) before commit; this entry's
  hash-line rides the next commit, or is recorded in
  `private/RESUME.md` and project memory if none follows. The
  `## [1.0.0]` release stays deferred to the author's post-Phase-8
  read-through.**

- **Phase 8: citation and bibliography refactoring (2026-07-13; not
  yet committed). Expands `book/references.bib` from 2 entries to 34
  and adds tasteful in-prose citations across 16 chapters, per the
  runbook `private/phase8-citations-runbook.md` and `PLAN.md`
  Section 10. Follows the companion Git book's matched-set
  conventions (DOI/ISBN for canonical works; `@misc` with url +
  urldate for tool and standard docs; version stamps on volatile
  tool/AI docs; case-sensitive names and bare-domain `howpublished`
  values brace-protected). New canonical sources: Sandve et al. 2013
  (DOI 10.1371/journal.pcbi.1003285), Wilson et al. 2017
  (10.1371/journal.pcbi.1005510), The Turing Way 1.0.2
  (10.5281/zenodo.7625728), Kernighan & Pike 1984 (ISBN
  9780139376818), Aho/Kernighan/Weinberger 2023 (9780138269722),
  Gentzkow & Shapiro 2014, and Bryan/Hester/Pileggi/Aja (WTF-R);
  `friedl2006` and `shotts2024` preserved. The tool/standard-doc
  entries surface authorities already pinned in the per-chapter
  verification logs. All 34 entries cited, zero orphans; validator
  0/0 and `quarto render` shows no broken references. Cleared the
  4-step gate, including five Codex citation-accuracy audit rounds
  (author attributions set from primary sources; each citation
  placed only on a claim its source supports). Source files touched:
  `book/references.bib`; the 16 chapters 01-03 and 06-18 (not
  04-05); the verification logs `verification/chapter-01.md`,
  `-03.md`, `-06.md`, `-08.md`, `-09.md`, `-13.md`, and the new
  `verification/phase8-citations.md` (this CHANGELOG also updated).
  The `## [1.0.0]` release stays deferred to the author's
  post-Phase-8 read-through.**

- **Post-Phase-7 cleanup (2026-07-13; not yet committed). Small
  corrections after the book was completed at `2219fde`; no new
  content. Lettered the reproducibility and safety checklist as
  "Appendix D" (`book/checklist.qmd` H1) so the back matter is a
  uniform A/B/C/D appendix series; the `#sec-checklist` anchor and all
  cross-links are unchanged, and the Bibliography stays unlettered.
  `private/PLAN.md` Section 8 updated to match. Corrected three factual
  points the Phase-7 Codex audit surfaced in committed chapters:
  Chapter 3's PowerShell sidebar said the default execution policy on
  Windows clients is `RemoteSigned` (it is `Restricted`; `RemoteSigned`
  is a policy you set, and the Windows Server default); Chapter 3's
  checksum DIVERGENCE said macOS does not ship `sha256sum` (recent
  macOS, verified on 26.5, ships a stock Apple-signed
  `/sbin/sha256sum`, though `shasum -a 256` stays the version-portable
  choice); and Chapter 14 called the Linux rsync "GNU rsync" (rsync is
  not a GNU project; reworded to "the mainline rsync"). Fixed the `friedl2006`
  bibliography entry's edition field from `Third` to `Third Edition` so
  it renders "Third Edition" rather than "Third" (a one-field
  correction to `book/references.bib`, whose full paper-wiki-owned
  expansion is the separate Phase-8 citation workstream). Flipped the
  Phase-7 entry below to committed-and-pushed and added its `2219fde`
  hash-line. This entry's own hash-line rides the next commit, or is
  recorded in `private/RESUME.md` and project memory if none follows.
  Source files touched (this CHANGELOG also updated):
  `book/checklist.qmd`, `book/chapters/03-setup.qmd`,
  `book/chapters/14-ssh-remote-compute.qmd`, `book/references.bib`.**

- **Phase 7: reference appendices and the reproducibility
  checklist, the final book-completion workstream (2026-07-12;
  committed and pushed 2026-07-13 as `2219fde`,
  `2219fde9af844b4f207561e1823896383dac80b5`, "Close Phase 7 final
  reference gate"; gate G7 CLOSED). Fills the four Phase-0 stubs in the
  book's "Reference" part with authored content, from `PLAN.md`
  Section 8 (appendix rows A/B/C plus the checklist) and Section 15
  (the Phase 7 row). Appendix A, `book/panic.qmd` ("Panic and Safety
  Reference"): a single end-of-book table of the destructive
  commands (`rm -rf`, `>` clobber, `cp`/`mv` overwrite, `sed -i`,
  `find -delete`, `chmod 777`, `kill -9`, a secret on the command
  line, `rsync --delete`, `make clean`, a piped `curl` installer,
  `git reset --hard`/`clean`/`push --force`) with a guard column and
  chapter number, then recovery guidance by situation and the
  before-the-fact defenses; it consolidates the book's 13 DANGER and
  9 RECOVERY callouts and is the target the "Appendix A" pointers in
  Chapters 5, 7, and 17 already reference. Appendix B,
  `book/divergence.qmd` ("Divergence Reference"): the
  BSD/GNU/zsh-bash/PowerShell quick-reference tables (shell and
  platform basics, coreutils flags, shell behavior, build and
  environment tools, and the PowerShell sidebar), consolidating the
  book's 30 DIVERGENCE callouts, each row cross-referenced to its
  chapter. Appendix C, `book/cheatsheet.qmd` ("Portable Command
  Cheat Sheet"): expands the Session-1 seeded shortlist into the
  full themed reference, every command mapped to the chapter that
  introduces it; the streams family (pipe, redirects, `tee`,
  null-safe `xargs`) is shown as a `bash` block rather than a table
  so a literal `|` never sits in a pipe-table cell. The
  reproducibility and safety checklist, `book/checklist.qmd`: a
  `- [ ]` task-list pass grouped by theme (fail-loud scripts, locked
  environment, data with a defined home, secret hygiene, guarded
  destructive commands, end-to-end reproduction, config that
  survives leaving the machine), each item cross-referenced and
  closing on the clean-clone test, mirroring the companion Git
  book's `checklist.qmd`. No fabricated output (the docs quote no
  machine output; they are prose, tables, and the running example's
  four-line script header). Style rules held: 0 em-dashes, pure
  ASCII (no box glyphs), authored code lines wrapped to 64. This
  first Phase-7 commit also ships the deferred paperwork: Session
  7's own `98f9fd6` CHANGELOG hash-line plus its status flip below,
  and the still-deferred Chapter 18 `ae78ce1` hash-line (both
  verified absent as tracked hits before being added, since a commit
  cannot contain its own hash). Gate G7: sandbox
  `validate_book.py book` self-check 0/0; the canonical `uv run`
  validator, `quarto render book` (HTML and PDF, eyeballing the four
  new reference pages, the tables, and the cheat-sheet code block),
  Codex blind audit, and human review run at the Mac gate before the
  commit closes G7 and completes the book. The Codex blind audit
  returned NO-GO on rounds 1 and 2; each finding was addressed. The
  wide Appendix B tables were rebuilt as three-column tables to stop a
  PDF cell overlap; the checklist's non-interactive-shell claim was
  corrected and then refined to name the `sshd` exception (an ordinary
  non-interactive bash reads no user file unless `BASH_ENV` is set, but
  a bash started by `sshd` for `ssh host 'cmd'` may read `~/.bashrc`;
  zsh reads `~/.zshenv` on every invocation; probe and set each context
  explicitly); the panic reference split the `git` row so
  `git push --force` is scoped to `--force-with-lease` and a protected
  branch, softened "irreversible" to "destructive or
  security-sensitive", and scoped the `git reflog` claim to recovering
  a lost commit or branch tip; the divergence reference dropped the
  incorrect "GNU rsync" label and framed versions and defaults as
  typical observed values to check per machine; and the cheat sheet's
  "one-page" promise was reframed to "a quick reference" (a whole-book
  command reference runs a few pages), with `private/PLAN.md`
  Section 8 updated to match. The chapter references to the appendices
  were made global cross-reference links so they resolve as internal
  destinations in both HTML and PDF (a file-path link renders as an
  external `/URI` action in the PDF): `[Appendix A](#sec-panic)` in
  Chapters 5, 7, and 17, `[appendix divergence table](#sec-divergence)`
  in Chapter 9, and the pre-existing `[cheatsheet](#sec-cheatsheet)`
  link in Chapter 4 converted from its file-path form for the same
  reason. This entry's own `2219fde`
  hash-line is added in the post-Phase-7 cleanup commit below, since a
  commit cannot contain its own hash.
  Source files touched (this CHANGELOG also updated): `book/panic.qmd`,
  `book/divergence.qmd`, `book/cheatsheet.qmd`, `book/checklist.qmd`,
  and the linkified `book/chapters/04-shell-literacy.qmd`,
  `book/chapters/05-navigation.qmd`,
  `book/chapters/07-pipes-redirection-danger.qmd`,
  `book/chapters/09-finding-things.qmd`, and
  `book/chapters/17-ai-terminal.qmd`.**

- **Review-response Session 7: provenance realignment, the final
  consistency pass (2026-07-12; committed and pushed 2026-07-12 as
  `98f9fd6`, `98f9fd6877d543e55bf0bb1ab5f73a105ad794c8`, message
  "Close Session 7 provenance realignment"). Eliminates the
  Session-1 `ch(N-1)` transcript and figure freeze offset so the
  whole repo matches the final chapter numbering, from the author
  review (`private/review-response-2026-07-08.md` Section 6,
  Session 7 row; locked decision 6). Renamed every `transcripts/`
  file for the shifted chapters (Chapters 5-18; Chapters 1-3
  unchanged): 133 transcript captures and 19 capture scripts, each
  with its `chapter:` header, note-header sibling references, and
  capture-script transcript-write paths and `chapter:` echoes
  realigned by one. The renames leave shown output bytes
  unchanged (byte-faithfulness contract), touching only file names,
  the metadata `chapter:` header, note cross-references, and
  script-internal write paths. The edits to shown content are all
  small and disclosed: the in-place demo/scratch path renames
  (command paths only, no output value changes), the Chapter 15
  `# The Ch 10 log`->`# The Ch 11 log` cross-reference comment, the
  masked `mktemp` tag, and the removed leaked trailer. Renamed the two figure assets
  `fig-ch05-layout` to `fig-ch06-layout` (Chapter 6) and
  `fig-ch13-motion` to `fig-ch14-motion` (Chapter 14) and rebuilt
  each `.pdf`/`.svg` from its `.tex` per the CLAUDE.md recipe
  (`pdflatex` -> `gs -dNoOutputFonts` outline -> `pdftocairo -svg`;
  `lmodern` for `\ttfamily`); the committed SVGs are byte-identical
  to the pre-rename originals (`fig-ch05-layout.svg` /
  `fig-ch13-motion.svg`), so the rename changed no figure content, and
  each figure rebuilds from its `.tex` to the same figure, rasterized
  and eyeballed (render-identical; the exact SVG byte-serialization
  depends on the `pdftocairo` version, so a cross-version rebuild is
  visually but not byte-for-byte identical).
  Vendored the figure build dependencies (`preamble.tex` plus the
  needed `icons/cache/`) into `book/assets/figures/` and pointed each
  `.tex` at `../preamble.tex`, so both figures now rebuild standalone
  from the repo (the old `.tex` referenced an out-of-repo
  `scripts/render.sh`).
  Updated the `![](...)` paths, `{#fig-...}` labels, and
  `@fig-...` references in Chapters 6 and 14. Swept every remaining
  offset reference in the chapters and `verification/` (the
  local-only, gitignored `CLAUDE.md` rules body was swept too, but it
  is not part of this commit). Realigned the one
  frozen inside-block chapter cross-reference (`# The Ch 10 log` to
  `# The Ch 11 log`) in `ch15-server-mac.txt` and its Chapter 15
  quotation together, per the `transcripts/README.md`
  byte-faithful-exception note. Removed the temporary freeze and
  renumber banners from `transcripts/README.md` (tracked) and the
  local-only `CLAUDE.md` and `private/` planning docs. Also aligned the demo and scratch
  names the captures create (`ch13-demo`->`ch14-demo`,
  `ch14-job.*`->`ch15-job.*`, `/tmp/ch07/`->`/tmp/ch08/`,
  `/tmp/ch14demo`->`/tmp/ch15demo`) in lockstep across the capture
  script, transcript, and quoted chapter block -- byte-equivalent to
  a re-run because every shown output value is independent of the
  path; masked the non-reproducible `mktemp` tag to `ch05mac.[rand]`
  (the capture script now applies the mask at capture time); and
  removed a leaked `captured -> ...` trailer from
  `ch07-divergence-mac.txt`. The illustrative Try-it scratch paths
  (`/tmp/ch04-play`, `/tmp/ch05-play`) and note-header scratch dirs
  (`/tmp/ch04mk`, `/tmp/ch04case`) were bumped too, in prose and
  metadata only. Acceptance: a repo-wide grep finds no
  stale reference (all resolve), no `chapter:`/filename mismatch,
  every demo/scratch name carries its own chapter number, and no
  offset outside CHANGELOG dated history, the gitignored `CLAUDE.md`,
  and the `private/` trail (refs verified extension-agnostically). Reopens gates G2-G6 (mechanical):
  `uv run` validator 0/0 (sandbox self-check 0/0), `quarto render
  book`, Codex blind audit, and human review at the Mac gate. The
  Codex blind audit ran three rounds, each catching real issues since
  fixed: round 1 = stale transcript-glob families + demo/scratch
  dirs (`/tmp/ch04-play`, `ch04mk`) + a `ch12-mtime` note over-bump +
  figures not repo-reproducible; round 2 = bare extension-less refs
  (`ch04-home-mac`) that extension-scoped greps missed + a
  `shadows.blur` TikZ library the vendored preamble loaded but a
  minimal TeX lacks; round 3 = an over-strong SVG byte-identity claim
  (cross-`pdftocairo`-version serialization drift) and shown-content
  wording, corrected here. This
  entry's own `98f9fd6` hash-line and the deferred Chapter 18
  `ae78ce1` hash-line are both added in the first Phase-7 commit
  above (a commit cannot contain its own hash, so both waited for
  the next one). Source files touched (this CHANGELOG also updated): the
  renamed `transcripts/` files (133 `.txt` + 19 `.sh`), the modified
  `book/chapters/*.qmd` files, `transcripts/README.md`, the
  renamed/rebuilt `book/assets/figures/ch06` and `ch14`, the vendored
  `book/assets/figures/preamble.tex` + `icons/cache/`, and the
  modified `verification/*.md` files.**

- **Review-response Session 6: greenfield Preface write
  (2026-07-12; committed and pushed 2026-07-12 as `f47dc90d`,
  `f47dc90d6c4e71bee247385cb92882134410aa56`, message "Close
  Session 6 Preface"; Codex blind audit round 1 FAIL, 1 BLOCKER,
  4 SHOULD-FIX, and 1 NIT fixed, re-audit round 2 and human review
  PASS; validator 0/0 and `quarto render book` clean. Shipped
  Session 5's `229490cb` hash-line and flipped the Session-5 entry
  below to committed-and-pushed; this entry's own `f47dc90d`
  hash-line ships in the Session-7 commit, since a commit cannot
  contain its own hash.
  The Chapter 18 `ae78ce1` hash-line remained deferred at this
  session (it was added later, in the first Phase-7 commit above);
  this session did not add it.** Replaced the Preface
  stub in `book/index.qmd` with the full landing page, from the
  author review (`private/review-response-2026-07-08.md` Section 6,
  Session 6 row; point P). Prose plus an HTML-only hero band and a
  three-card feature grid, mirroring the companion Git book's
  Preface; no command blocks (the Preface runs nothing, like
  Chapter 1). The four asks: (a) why reproducibility is now the
  standard in social science and how the shell is the layer that
  executes it, stated as stakes and cross-referenced to the Git
  book and Chapter 1, not re-argued; (b) the terminal is
  intimidating at first but the skill is durable and compounds over
  a career; (c) shell literacy is what makes the agentic-AI coding
  tools effective, tied to Chapter 2's fourth-help-avenue point and
  Chapter 17; (d) you still learn the shell because you must read
  and verify what an agent runs, again pointing to Chapters 2 and
  17. The hero band and feature grid are guarded with
  `::: {.content-visible when-format="html"}` so the PDF drops them
  cleanly and falls back to the surrounding prose (the HTML/PDF
  guard the Chapter 5 figure taught). Wove in the single book-wide
  "About the captured output" note that Session 3 wrote to the
  stub, intact, as the closing section; its real-output and masking
  claims are unchanged. Beginner-default and unlabeled (no ADVANCED
  section); 0 em-dashes; sandbox `validate_book.py` self-check 0/0;
  canonical `uv run` validator and `quarto render book` (confirming
  the hero band and cards in HTML and the prose fallback plus
  surviving captures note in the PDF) run at the Mac gate, then
  Codex blind audit and human review. Source files touched (this
  CHANGELOG also updated): `book/index.qmd`.
- **Review-response Session 5: targeted per-chapter fixes and the
  first two `references.bib` entries (2026-07-11; committed and
  pushed 2026-07-11 as `229490cb`,
  `229490cb27bf605533dea38e8ff31b91d2241f89`, message "Close
  Session 5 targeted review fixes"; Codex blind audit round 1 FAIL,
  1 BLOCKER and 1 NIT fixed, re-audit PASS, then human review;
  validator 0/0 and `quarto render book` clean, 222pp. Shipped
  Session 4's `0b3bf1d` hash-line; this entry's own `229490cb`
  hash-line rides in the next commit, since a commit cannot contain
  its own hash).** The independent one-off
  fixes the earlier sessions deferred, from the author review
  (`private/review-response-2026-07-08.md` Section 6, Session 5 row;
  points 5, 8, 9, 10, 11, 14, 17). Prose and citation edits only; no
  fabricated output. Chapter 1 (`01-why-terminal.qmd`): added the
  "almost no screenshots; commands are copy-pasteable text" point
  after the paste line; named William Shotts's *The Linux Command
  Line* as further reading (~600pp, can feel intimidating) and cited
  it; glossed the leading `#` as a comment at its first appearance
  (the roadmap block); and deleted "rather than pretending the
  platforms are identical." Chapter 2 (`02-mental-model.qmd`): before
  "Try it yourself", added the AI-assistants-as-a-fourth-help-avenue
  point and the logic-beats-memorizing-syntax argument. Chapter 3
  (`03-setup.qmd`): added a short "what a terminal emulator is and
  does", named WezTerm among the cross-platform emulators, and
  expanded "zsh" to "the Z shell" and "bash" to "the Bourne-again
  shell". Chapter 5 (`05-navigation.qmd`): introduced
  `cd /tmp/asset-pricing` in the prose before the first `pwd` (the
  captured block and its `ch04-pwd-ls.txt` transcript left
  byte-identical); and taught `tree` (motivated for Finder/Explorer
  users, with the `brew install tree` / `apt install tree` caveat and
  `ls -R` as the always-available fallback), in prose, no fabricated
  `tree`/`ls -R` output. Chapter 8 (`08-text-tabular-data.qmd`): fixed
  the `mkt_rf` forward-reference by promoting the header-revealing
  `grep -n 'mkt_rf'` block ahead of the 8.8% sentence (each block
  stays byte-identical to `ch07-grep.txt`; only order and connective
  prose changed) and reworded "which is how you learn the header is
  line 1". Chapter 13 (`13-environments.qmd`): added a footnote
  glossing `polars` / `statsmodels` / `fixest` at first mention;
  Docker left as-is (already named, scoped out, none taught, per the
  memo's push-back). Chapter 18 (`18-startup-files-path.qmd`): added a
  three-line gloss of the five cron time fields where `0 6 * * *`
  sits, with a one-line `at` mention; cron not expanded. Bibliography
  (`book/references.bib`, via the paper-wiki skill, its sole writer):
  first two entries, both books with no registered DOI (confirmed via
  Crossref/OpenAlex + web search): `friedl2006` (Friedl, *Mastering
  Regular Expressions*, 3rd ed., O'Reilly, 2006) and `shotts2024`
  (Shotts, *The Linux Command Line*, 6th Internet ed., 2024). Cited
  `@shotts2024` in Chapter 1 and `@friedl2006` in Chapter 8's regex
  further-reading pointer (consolidated there rather than duplicated
  in Chapter 7, which only cross-references regex to Chapters 8/9).
  Source files touched (this CHANGELOG also updated): `book/chapters/01-why-terminal.qmd`,
  `02-mental-model.qmd`, `03-setup.qmd`, `05-navigation.qmd`,
  `08-text-tabular-data.qmd`, `13-environments.qmd`,
  `18-startup-files-path.qmd`, and `book/references.bib`. No new
  callouts; no section or ADVANCED-mark count change; validator
  target 0/0 (canonical `uv run` on the Mac at the gate); em-dashes
  0.
- **Review-response Session 4: first-use gloss audit across the
  chapters the review memo numbers Ch 2, 4, 6, 7, 8 (current
  numbering 2, 5, 7, 8, 9 after the Session-1 mini-chapter
  insertion) (2026-07-11; committed and pushed 2026-07-11 as
  `0b3bf1d`, `0b3bf1de5dbf9426eddc2dc9b1f528188042985f`, message
  "Close Session 4 first-use gloss audit"; Codex blind audit FAIL
  round 1, both findings fixed, re-audit PASS, then human review;
  validator 0/0 and `quarto render book` clean. Shipped Session 3's
  `7a61e86` hash-line; this entry's own `0b3bf1d` hash-line rides in
  the next commit, since a commit cannot contain its own hash).**
  Root cause C of the author
  review (`private/review-response-2026-07-08.md` Section 6, Session
  4 row, and the #C first-use items): commands used before they are
  glossed. One consistent pass added short prose glosses at first
  use only; it added no new command blocks (every shown `$`/`>`
  block stays transcript-backed), no new callouts, and changed no
  section or ADVANCED-mark count. Chapter 2 (`02-mental-model.qmd`):
  `echo` (prints its arguments) at its first use `echo $HOME`; and
  the `DATASET=panel_v2` assignment, the no-spaces-around-`=` rule,
  and the `${...}` braces (the existing `:-` default explanation
  kept and folded in). Chapter 5 (`05-navigation.qmd`): `printf` and
  `cat` at their first use in the copy-and-clobber demo. Chapter 7
  (`07-pipes-redirection-danger.qmd`): decoded `cut -d, -f1` (`-d`
  sets the delimiter, `-f1` keeps field 1); added the `tail -n +N`
  ("from line N") versus `head -n N` / `tail -n N` ("a count of N")
  asymmetry; and glossed `shopt -s` (bash's option switch) and the
  `find . -name ... | xargs` idiom (`.` is the start directory;
  `xargs` builds a command line from stdin). Chapter 8
  (`08-text-tabular-data.qmd`): labeled `F0000` a synthetic firm id
  at first use; and glossed `duckdb -c` (one-shot SQL, like
  `bash -c`; `-csv` was already explained). Chapter 9
  (`09-finding-things.qmd`): glossed `touch` and taught `-t` as the
  POSIX-portable timestamp flag, with `-d` (used in the chapter)
  flagged as non-POSIX whose accepted date strings vary by
  implementation (GNU free-form vs BSD/macOS narrower), so `-t` is
  the portable choice. Skipped where a
  gloss already exists (per the memo's corrections): `grep -n`
  (Chapter 8), `600` and `$HOME`, and Chapter 8's own `cut -d, -f`
  decode. New source pin: `verification/chapter-09.md` claim 6 (the
  `touch` `-t`/`-d` portability, doc-pinned, corrected in Codex
  round 1, not Mac-captured).
  Files touched: `book/chapters/02-mental-model.qmd`,
  `05-navigation.qmd`, `07-pipes-redirection-danger.qmd`,
  `08-text-tabular-data.qmd`, `09-finding-things.qmd`, and
  `verification/chapter-09.md`. Validator 0/0; 0 em-dashes added.
- **Review-response Session 3: plumbing sweep, repetition trim, and
  an ADVANCED-only heading-tier relabel book-wide (2026-07-11;
  committed and pushed 2026-07-11 as `7a61e86`,
  `7a61e862d230859112996a7bc1bca13171604017`, message "Close
  Session 3 review-response cleanup"; cleared the Codex blind-audit
  rounds and human review; validator 0/0 and `quarto render book`
  clean. Shipped Session 2's pending `9ddb38e` hash-line; this
  entry's own `7a61e86` hash-line rides in the next commit, since a
  commit cannot contain its own hash).** Three edits, from the author review
  (`private/review-response-2026-07-08.md` Section 6, Session 3 row,
  and points 6 and 7). (1) **Plumbing sweep (point 6).** The eight
  non-reader-facing mask/capture sentences that narrated the capture
  and masking mechanics to readers (Chapters 5, 6, 8, 9, 13, 14, 15,
  16) were removed or, where a chapter's own output shows bracket
  placeholders, reframed as a lean reader legend (what `[account]` /
  `[hostname]` / `[ip]` mean in that chapter's blocks) instead of a
  "the captures mask, at capture time, ..." methodology aside. The
  masking contract is now disclosed once, book-wide, in a new "About
  the captured output" note in the Preface (`index.qmd`), which
  states the real-output contract and the bracket-placeholder mask
  and renders in both HTML and PDF. (2) **Repetition/tic trim (point
  7).** The filler "wrinkle" was thinned from four uses to one, and
  the deliberate-voice "bite" from thirteen to five (kept where it
  lands, reworded the boilerplate provenance-note copies with varied
  words so no new tic replaces it). (3) **Tier relabel (point 8d /
  the print-bug fix).** Beginner is now the unlabeled default: all 89
  `.tier-beginner` class tokens were stripped from headings; the one
  heading that combined the token with an id dropped `.tier-beginner`
  and kept `#sec-command-anatomy`. Each of the 37 ADVANCED sections
  now carries a visible `(ADVANCED)`
  suffix in its heading text, e.g.
  `## Automatic variables (ADVANCED) {.tier-advanced}`. The
  `.tier-advanced` class is kept as an inert hook (grep/count still
  work); the badge-printing `::before` rules were removed from
  `book/includes/custom.scss`, since they rendered only in HTML and
  dropped out of the LaTeX PDF (the bug this replaces). Chapter 1's
  tier explanation was reworded to drop the "a heading marked
  BEGINNER" promise and describe the unmarked default plus the
  `(ADVANCED)` mark. The tier contract was reconciled in `CLAUDE.md`
  (per-chapter workflow, pre-handover self-check, writing rules, and
  the personal-data-mask disclosure rule) and `PLAN.md` Section 9 so
  they mandate the by-exception scheme, not label-both-tiers. Files
  touched: `book/index.qmd`, `book/includes/custom.scss`, all 18
  `book/chapters/*.qmd` (tier strip), and prose edits in Chapters 1,
  3, 5, 6, 7, 8, 9, 13, 14, 15, 16, 18. Validator 0/0; 0 em-dashes;
  `(ADVANCED)`-suffix count equals `{.tier-advanced}` count (37).
- **Review-response Session 2: scripting primer in Chapter 11 +
  back-references from Chapter 7 (2026-07-09; committed 2026-07-09
  as `9ddb38e`, `9ddb38e87aa6415143d08c094fc41daa2c284edc`,
  message "Add scripting primer and byte-faithfulness fixes";
  cleared the Codex blind-audit rounds + human review; validator
  0/0 and `quarto render book` clean. This hash-line rides in the
  next commit since a commit cannot contain its own hash).** The
  author review (Preface-Ch12) asked that the shell-script
  constructs be
  taught before they are used. A new BEGINNER section "Reading a
  script: tests, branches, and loops" was added to Chapter 11
  ("Scripts that fail loudly"), placed after "Fail loudly:
  `set -euo pipefail`" and before "Exit codes you can act on", so
  `if`/`then`/`else`/`fi`, `[[ ]]` tests (with `!` negation), the
  `[ ]`-vs-`[[ ]]` spacing lesson, `for...do...done`, `while`
  (counter and `while read`), reading exit status via `$?`, and
  `{ ...; }` command grouping are all defined before the chapter's
  `guard.sh` first uses `if [[ ! -f ... ]]`. Chapter 11 now has 8
  content sections (6 beginner, 2 advanced; was 7 / 5 / 2); the
  primer adds no callout. The two constructs the Pipes chapter
  (Chapter 7) uses without defining, its `for w in $f`
  word-splitting loop and its `{ ...; } > run.log 2>&1` grouping,
  now carry one-line forward pointers to the Chapter 11 primer
  instead of being re-explained; no Chapter 7 behavior claim
  changed. While Chapter 7 was open, a Codex blind audit caught
  two pre-existing byte-faithfulness drifts there, now repaired so
  each shown block is again a contiguous transcript substring: a
  dropped `echo $?` / `1` in the `noclobber` DANGER block (vs
  `transcripts/ch06-redirect.txt`) and a dropped blank line in the
  quoting `for` block (vs `transcripts/ch06-quoting.txt`). The
  same audit corrected two shell claims in the new Chapter 11
  primer: `[[ ! -f x ]]` is true when `x` is not a regular file
  (not only when it is absent), and for `{ ...; }` grouping the
  space after `{` plus a `;`/newline before `}` are what is
  required (not "spaces inside both braces"). Real output for the
  primer is captured in the new
  `transcripts/ch10-primer.txt`; all 8 shown blocks are
  byte-identical to it. That transcript was recorded in the
  CURRENT sandbox image (Ubuntu 24.04.4, GNU bash 5.2.21) rather
  than the 22.04 / bash 5.1.16 image of the sibling `ch10-*`
  files, and is frozen at the `ch10-` prefix per the Session-1
  transcript freeze; the control-flow output has no
  version-dependent content, so bash 5.1.16 is expected to
  reproduce it (not re-captured there), and the author may
  re-capture on the 22.04 image for single-image provenance.
  `verification/chapter-11.md` (counts,
  provenance, a new "primer runs as shown" bullet) and
  `verification/chapter-07.md` (the two forward pointers) updated.
  The review memo's point-13 `[ ]`-relocation was a no-op: there
  is no `[ ]` test in Chapter 7 to move, so the spacing lesson is
  authored fresh in the primer.

- **Review-response Session 2 book-wide byte-faithfulness sweep
  (2026-07-09; part of the Session-2 change set, committed in
  `9ddb38e`).** After Codex flagged two byte-faithful drifts in
  Chapter 7, all 256 shown `$`/`>` code blocks across the chapters
  were checked against `transcripts/*.txt` (a block must be a
  contiguous transcript substring, modulo the accepted `\`
  line-wrapping; marked `[...]` elisions exempt). Chapter 7 came
  back clean after its two fixes. Eighteen pre-existing blocks were
  repaired: dropped blank lines between merged commands restored in
  Chapters 2 (8 blocks), 3 (1), 5 (1), and 12 (3); trailing
  whitespace restored to two Chapter 16 blocks; two Chapter 3
  blocks split into per-command fences (their commands are not
  contiguous in the capture); and Chapter 12's `sed`/`make check`
  failure block de-wrapped onto one line and its two dropped blank
  lines restored. Author policy set here: restore transcript blank
  lines book-wide, and present wrapped typed commands hand-wrapped
  with `\` and no shell `>` continuation prompt (transcripts are
  the raw capture and may keep the real `>`; the byte-faithful
  contract is on output). Under that policy the Chapter 11 primer's
  `for`/`while`/`while read` demos were reformatted off the PS2
  `>` style (one line where they fit; `\`-wrap for `while read`),
  with `transcripts/ch10-primer.txt` updated to match and output
  unchanged. Every changed chapter re-validated 0 errors / 0
  warnings. The one block whose output was in no transcript,
  Chapter 12's `stat -f '%Fm  %N' output/tables/ff5_alpha.tex
  report.html`, was captured on the Mac (new
  `transcripts/capture-ch11-mtime-mac.sh` ->
  `transcripts/ch11-mtime-mac.txt`, macOS 26.5.2, BSD stat) and
  the block de-wrapped onto one line + updated to the real mtimes
  (2.14 s apart), so it now matches byte-for-byte (prose gap
  updated to 2.14 s). A Codex round-2 audit then caught four
  Chapter 12 `make` blocks that carried a marked `[...]` elision
  but ALSO silently dropped other real output (or spliced two
  runs) -- a blind spot in the first byte checker. The checker was
  rebuilt to be elision- and truncation-aware, and the four blocks
  were repaired into honest contiguous transcript slices; the
  `touch scripts/04_regression.R; make` splice was resolved with a
  fresh Mac capture (`transcripts/capture-ch11-touch-regression-mac.sh`
  -> `transcripts/ch11-touch-regression-mac.txt`; a `sleep` before
  the touch dodges the one-second tie so the report reliably
  re-renders), and the chapter now shows that real `touch; make`
  run byte-faithful, with the chapter's original prose restored. After that, every shown block
  in the book is transcript-backed except one accepted non-defect:
  Chapter 5's wrapped `stat` block, where the transcript keeps the
  real `>` and the chapter strips it per the wrapping convention.
  Full record: `verification/session2-byte-faithfulness.md`.

- **Structural renumber to insert the shell-literacy mini-chapter
  (2026-07-08; committed 2026-07-09 as `d0653ed`,
  `d0653edf40111fa20978e3de057eb49530c75921`, message "Add shell-literacy
  chapter and renumber book"; this hash-line rides in the next commit since
  a commit cannot contain its own hash).** An author review called for a
  "How to Read a Shell Command" on-ramp before navigation. It is
  slotted as the new Chapter 4 in Part I "Literacy Foundation", so the
  former Chapters 4-17 shift up by one to 5-18. This entry records the
  mechanical renumber; the mini-chapter itself is under Added below.
  Scope of the shift (working tree only, pre-commit):
  - `book/chapters/NN-*.qmd` filenames 04-17 renamed to 05-18
    (semantic slugs unchanged) and `_quarto.yml` reordered.
  - ~314 reader-facing chapter references bumped across the book:
    every prose "Chapter N" / "Ch N" and Oxford-comma or range list
    with N >= 4 (verified: Chapters 1-3 untouched; a tokenizing pass
    with a 0-anomaly cross-check, not a blind sed).
  - Figure labels and their asset files are FROZEN at their original
    chapter number, exactly like transcripts: a `fig-chNN` label is
    internal and never shown to a reader (Quarto auto-numbers the
    figure by its new chapter), and the assets live at
    `assets/figures/chNN/`. No `fig-*` label or figure path was
    changed, so none points at a missing asset.
  - `verification/chapter-04..17.md` renamed to `05..18.md` with their
    internal "Chapter N" (N>=4) and `.qmd` filename references bumped;
    a new `verification/chapter-04.md` documents the mini-chapter.
  - `cheatsheet.qmd` seeded with the common-command shortlist.

  | Old | New | Chapter |
  |----:|----:|---|
  | 4 | 5 | Navigation and file operations |
  | 5 | 6 | Organizing a project |
  | 6 | 7 | Pipes, redirection, and danger |
  | 7 | 8 | Text and tabular data |
  | 8 | 9 | Finding things |
  | 9 | 10 | Processes, permissions, secrets |
  | 10 | 11 | Scripts that fail loudly |
  | 11 | 12 | The Make pipeline |
  | 12 | 13 | Environments |
  | 13 | 14 | SSH and remote compute |
  | 14 | 15 | Persistent sessions |
  | 15 | 16 | Modern CLI and TUIs |
  | 16 | 17 | AI in the terminal |
  | 17 | 18 | Startup files, PATH, dotfiles |

  Not renumbered in this session: the ~80 `transcripts/` capture
  files (`chNN-*`, incl. the `chapter:` header field) and the
  `assets/figures/chNN/` figure files and their `fig-chNN` labels.
  This is **temporary** scaffolding: a dedicated final consistency pass
  will rename them to the current numbering so no `ch(N-1)` offset
  survives the revision. Permanently frozen (pinned to their commits):
  the dated historical narrative in this CHANGELOG, `RESUME.md`, and the
  handover trail. Those record work by the chapter
  number in effect when it happened and stay pinned to immutable git
  messages/hashes; the transcript freeze and old->new mapping are
  documented in `transcripts/README.md`. Under the new numbering, a
  chapter N in 5..18 is backed by `ch(N-1)-*` transcripts.

### Added

- **Chapter 4, "How to Read a Shell Command" (shell-literacy
  mini-chapter; 2026-07-08; committed 2026-07-09 as `d0653ed`).** A tight,
  reference-style BEGINNER on-ramp placed after
  Setup and before Navigation. Teaches the reader to *read* a command
  before the later chapters use syntax at speed: the shape of a command
  line, then Table A (command anatomy and the three quoting rows), a
  brackets-vs-docs decoder plus a one-rule "when to quote", and a
  common-command shortlist table (also seeded into `cheatsheet.qmd`).
  One read-only "Try it yourself" decoding exercise tied to the
  asset-pricing example; nothing is executed, so the chapter has no
  transcripts and pins no external claims (the Shotts further-reading
  cite is routed through paper-wiki in a later session). Each content
  section is tiered `{.tier-beginner}` per the current contract; the
  planned book-wide switch to ADVANCED-only labeling is a later pass.
  (Superseded by the Session 3 entry above: those beginner badges were
  stripped and beginner is now the unlabeled default.)
  Sandbox pre-check `python3 tools/validate_book.py book` = 0 errors, 0
  warnings; the canonical Mac `uv run` validator + `quarto render book`
  + Codex audit + human review remain to run before commit.

- **Chapter 17, "Startup Files, PATH, and Portable Dotfiles"
  (Phase 6, Part IV, the SECOND and LAST Part-IV chapter, so its
  commit CLOSES gate G6 and completes Part IV; Ch 16 "AI in the
  terminal" is a committed Phase-2 exemplar and is skipped here.
  Drafted 2026-07-07; canonical Mac validator 0/0; `quarto render
  book` produced a fresh 211-page PDF with Ch 17 on pp. 197-205;
  Codex blind audit cleared after three rounds; human review
  approved 2026-07-08; committed and pushed 2026-07-08 as
  `ae78ce1` (`ae78ce1f16ded6be8fe3bf7fdc8cd0f94e8935f0`, message
  "Add chapter 17 startup files"). This entry CARRIES the pending
  Ch 15 `91d8e4b` CHANGELOG hash-line touch, added to the Ch 15
  entry below with this work since a commit cannot contain its own
  hash, and it flips that entry's gate tail to committed-and-pushed
  language; Ch 17's own `ae78ce1` hash-line is added later, in the
  first Phase-7 commit, together with Session 7's `98f9fd6`.)**
  The spine: the shell you type into is not the shell your
  scripts, `ssh host 'cmd'` calls, and cron jobs run in, and a
  setting in a file only your interactive shell reads is invisible
  to all three, so put each setting where the situation that needs
  it will actually read it. The chapter cashes the promissory
  notes the earlier chapters left here, each delivered as one line
  of config plus the placement rule, never a re-teaching: the
  `cp -i`/`mv -i` aliases (Ch 4), `set -o noclobber` (Ch 6),
  history hygiene (Ch 9, `HIST_IGNORE_SPACE` / `HISTCONTROL`), the
  `zoxide`/`fzf` hooks and guarded aliases (Ch 15), the
  `brew shellenv` line and `~/.local/bin` PATH persistence (Ch 3),
  and the remote-shell seam (Ch 13). Six content sections (4
  beginner, 2 advanced) plus unnumbered Try-it: which file loads
  when (the bash/zsh login-vs-interactive invocation matrix, shown
  as a table, the device); PATH placement and search order plus
  the front-of-PATH hijack risk (Ch 3/6); the portable dotfile
  (aliases, `noclobber`, history, kit hooks, each guarded with
  `command -v <tool> >/dev/null &&` graceful degradation, plus an
  annotated ASCII dotfile tree, the Ch 5 house device); works in
  terminal, fails over SSH (the Ch 13 seam, captured on a real
  server); scheduled and non-interactive contexts (cron, launchd,
  CI, why each starts from a stripped environment); and the
  durable rule, config that survives all three. Callouts: 1
  PITFALL (config in an interactive rc is invisible to a script,
  an `ssh host 'cmd'`, and cron), 1 RECOVERY (debug the seam:
  `ssh host 'echo $PATH'`, `bash -lc`, echo a marker from each rc,
  or set the env in the script the Ch 10 way), 1 DIVERGENCE (bash
  vs zsh startup files, and login-ness is decided by the terminal
  emulator, not the OS: macOS Terminal.app opens a login +
  interactive shell, many Linux emulators open a non-login
  interactive shell), 1 REPRODUCIBILITY (a reproducible pipeline
  must not depend on interactive config; Ch 10 pins its own
  `LC_ALL`/`TZ`). No DANGER (config, not destruction) and no new
  figure (the book's three stay Ch 2/5/13); the devices are the
  matrix table and the ASCII dotfile tree. Mixed-capture: the bash
  startup order and the non-interactive environment are real Linux
  sandbox captures (GNU bash 5.1.16); the zsh order, the macOS
  bash 3.2 floor, `launchd`, and a terminal's login state are Mac
  captures (macOS 26.5.1, zsh 5.9, bash 3.2.57); the "fails over
  SSH" seam is captured from the Mac against a real Linux server.
  The local order demos ran against a THROWAWAY `HOME` (and
  `ZDOTDIR`) with demo rc files, so no real LOCAL dotfile was read
  (the Ch 15 throwaway-db mask applied to whole dotfiles); the one
  exception is the remote ssh capture, which forces a login shell
  (`bash -lc`) that does execute the server's real login profile
  but runs only `echo`/`command -v`, writes nothing, and shows
  only the resulting masked PATH. Paths and account masked at
  capture time (machine-specific mounts to `/mnt/[mount]`), long
  PATH tails elided with `[...]`. Two folklore claims were
  corrected by running it: "SSH reads `.bashrc`" (only under a
  build-time option not to be relied on, and the stock `~/.bashrc`
  self-guards by returning immediately when non-interactive, so a
  non-interactive `ssh host 'cmd'` does not pick up your PATH
  edits), and "test login with `echo $0`" (a bash-only heuristic;
  in zsh `echo $0` is `/bin/zsh` regardless, so the chapter uses
  `[[ -o login ]]`). Sources pinned + accessed 2026-07-07: the
  bash(1) INVOCATION section, the zsh manual "Startup/Shutdown
  Files", and `crontab(5)` (`verification/chapter-17.md`).
  Closeout: two forward-`will` references to Ch 17 were flipped
  to present tense (`02-mental-model.qmd`, "Chapter 3 sets you up
  and Chapter 17 makes it stick", which also retired a stale
  forward-`will` for the now-committed Ch 3; and `03-setup.qmd`);
  the other Ch 17 forward pointers (Ch 4/6/9/13/15) are already
  present-tense parentheticals; the Ch 1 roadmap does not
  reference Ch 17. Files:
  `book/chapters/17-startup-files-path.qmd`, two sandbox
  transcripts (`ch17-bash-order.txt`, `ch17-noninteractive.txt`),
  five Mac transcripts (`ch17-versions-mac.txt`,
  `ch17-zsh-order-mac.txt`, `ch17-launchd-mac.txt`,
  `ch17-ssh-seam-mac.txt`, `ch17-login-shell-mac.txt`), the two
  tracked capture scripts (`transcripts/capture-ch17-mac.sh`,
  `transcripts/capture-ch17-ssh-mac.sh`),
  `verification/chapter-17.md`, and handover
  `private/ch17-G6-handover.md`.
- **Chapter 15, "Modern CLI Kit and TUIs" (Phase 6, Part IV,
  the FIRST of the two Part-IV chapters, so its commit does NOT
  close gate G6, which needs Ch 15 + Ch 17. Drafted 2026-07-06;
  validator 0/0 in the sandbox and under the canonical Mac
  `uv run`; `quarto render book` produced a fresh 203-page PDF
  with Ch 15 on pp. 179-186; cleared two Codex blind-audit
  rounds; human review passed; committed + pushed 2026-07-07 as
  `91d8e4b`. This entry carries the pending Ch 14 `2611f22`
  CHANGELOG hash-line touch, added above with this work since a
  commit cannot contain its own hash; Ch 15's own `91d8e4b`
  hash line, added here after the push, becomes the pending
  touch and rides with the Ch 17 commit.)** A curated, honest
  survey of the modern CLI kit taught as ergonomic upgrades with
  a loud portability tax. The spine: these tools make the laptop
  in front of you faster, but the bare server of Chapter 13 has
  none of them, so adopt them as a convenience layer that never
  becomes a dependency of your work or your reflexes. Delivers
  Chapter 16's opening line ("Chapter 15 added a kit of faster,
  friendlier commands to the shell") and the `ncdu` routing
  Chapter 13 made. Six content sections (4 beginner, 2 advanced)
  plus unnumbered Try-it: `eza` (an `ls` upgrade, the git-status
  column and `--tree`); `bat` (a `cat` upgrade, line numbers,
  syntax, and tty-awareness); `zoxide` + `fzf` (a learning `cd`
  and a fuzzy finder, driven non-interactively); `delta` (a
  git-diff pager, described and version-stamped since its color
  side-by-side view is what print drops); the pure TUIs
  `lazygit`, `btop`, and `ncdu` (documented and version-stamped,
  not run, because a full-screen program owns the terminal and
  cannot be scripted, the Chapter 9 / 16 lesson); and the
  portability tax (a comparison table plus the precise account
  of what breaks where). Callouts: 1 PITFALL (aliasing
  `ls`->eza / `cat`->bat / `cd`->z so muscle memory and
  half-written scripts break on a bare server), 1 REPRODUCIBILITY
  (the Chapter 11 Makefile builds with `uv run python` / `Rscript`
  / `quarto` and never calls this kit, so eza/bat/delta are
  human conveniences, not build dependencies), 1 RECOVERY (on a
  bare server, fall back to the `ls`/`cat`/`cd`/`grep`/`find` of
  Parts I-II), 1 DIVERGENCE (the install story diverges brew vs
  cargo/apt/nothing, and Debian/Ubuntu rename `fd` to `fdfind`
  and `bat` to `batcat`; the exact name depends on the release,
  so check with `command -v`). No DANGER (this kit views and
  navigates, it does not
  destroy) and no new figure (the book's three stay Ch 2/5/13);
  the device is a comparison table. Mac-captured, since the kit
  is blocked in the Linux sandbox (only `ripgrep` and `du`
  preinstalled, both already taught); every tool version-stamped
  "current as of 2026-07-06" (`eza` 0.23.4, `bat` 0.26.1,
  `delta` 0.19.2, `zoxide` 0.9.9, `fzf` 0.70.0, `lazygit`
  0.62.2, `btop` 1.4.7, `ncdu` 2.9.2) and pinned to its repo in
  `verification/chapter-15.md`. Every shown block is a real Mac
  capture run with color and icons OFF (they are ANSI/Unicode
  the PDF drops): the five fenced blocks are `eza -l --git`
  (ASCII-safe git column; the Unicode `--tree` is described, not
  shown), `bat` numbered (forced with `--decorations=always`
  because bat auto-plains when piped), `zoxide query` (throwaway
  database, so the author's real history never appears), `fzf
  --filter`, and the plain `git diff` the `delta` section
  describes. Scope held:
  no re-teaching of `fd`/`ripgrep` (Ch 8, met there), `ls`/`cd`
  (Ch 4), `cat` (Ch 6), `du` (Ch 13), install/PATH (Ch 3), or
  git diff itself; alias/dotfile persistence is a forward "will"
  to Chapter 17. Files: `book/chapters/15-modern-cli-tuis.qmd`,
  five sandbox-blocked-so-Mac transcripts (`ch15-versions-mac.txt`,
  `ch15-eza-mac.txt`, `ch15-bat-mac.txt`, `ch15-nav-mac.txt`,
  `ch15-diff-mac.txt`), the tracked capture script
  `transcripts/capture-ch15-mac.sh`, `verification/chapter-15.md`,
  and handover `private/ch15-G6-handover.md`.
- **Chapter 14, "Persistent Sessions" (Phase 5, Part III, the
  FOURTH and LAST Part-III chapter, so its commit CLOSES gate G5;
  Ch 11 "Make" is a committed Phase-2 exemplar and is skipped
  here. Drafted 2026-07-05; validator 0/0 in the sandbox; all 9
  fenced `bash` blocks are transcript-backed and confirmed as
  contiguous substrings of the ch14-* transcripts by a scripted
  byte-checker (7 sandbox blocks plus the 2 Section-3 server
  blocks, the latter RECONCILED byte-for-byte 2026-07-05 against
  `ch14-server-mac.txt` after the user ran
  `transcripts/capture-ch14-mac.sh` against a real remote Linux
  server; the drafted placeholder timestamp and step counts were
  replaced with the real capture, `tmux ls` was filtered at
  capture time to the demo session so the author's unrelated
  pre-existing sessions never enter the repo, and the fourth
  server read, a second `capture-pane`, was captured but dropped
  from the chapter as redundant with the local demo, leaving
  Connection A start, B `tmux ls`, C `capture-pane`, and the log
  tail). One further authored non-runnable
  `text` fence (the session/window/pane ASCII tree) is a labeled
  schematic, not a capture; the RECOVERY callout is prose, with
  no pseudo-capture block.
  Sources pinned + confirmed 2026-07-05 (the tmux(1) manual and
  tmux Getting-Started wiki for the default `C-b` prefix,
  `C-b d` detach, nested-prefix `C-b C-b`, `attach -d`, and
  `capture-pane -p`; the GNU Screen manual "Command Character"
  for screen's `C-a`). No new figure; the book's three figures
  stay Ch 2/5/13, and the containment is carried by the annotated
  ASCII tree (the Ch 5 house device). The canonical Mac `uv run`
  validator passed 0/0 and `quarto render book` produced a fresh
  196-page PDF on 2026-07-06, with Ch 14 on pp. 170-178. Codex
  final review and human review passed; committed + pushed
  2026-07-06 as `2611f22` (HEAD = origin/main =
  refs/heads/main), which CLOSES gate G5 (Ch 10 + 12 + 13 + 14
  all in, Part III complete), and it carries the pending Ch 13
  `8c2cf09` CHANGELOG hash-line touch below, since a commit
  cannot contain its own hash; Ch 14's own `2611f22` hash line,
  added here after the push, becomes the pending touch and rides
  with the Ch 15 commit.)**
  Delivers the forward promise Chapter 9 (`nohup` section) and
  Chapter 13 (closing line) both made, on one spine: the
  connection is disposable, the session is not. In Chapter 13 a
  dropped `ssh` connection killed the remote job; tmux moves the
  job into a session that lives on the server independent of the
  connection, so you detach, close the laptop, reconnect from
  anywhere, reattach, and the job is still running, its recent
  output on screen and its Chapter 10 log intact. Five content
  sections (3
  beginner, 2 advanced) plus unnumbered Try-it: the core session
  loop (`new`/detach/`ls`/`attach`/`kill-session`, the `Ctrl-b`
  prefix, driven non-interactively with `new-session -d` because
  an interactive `attach` seizes the terminal and would hang a
  scripted capture); the session -> window -> pane containment
  (the annotated ASCII tree paired with real
  `list-windows`/`list-panes`, `new-window`/`split-window`);
  surviving a disconnect on a remote job (the local mechanic, a
  job progressing between two `capture-pane` dumps with no
  attach, then the server payoff over two independent `ssh`
  connections proving the session outlived the first); what tmux
  does NOT do (survives a disconnect, NOT a reboot, which ends
  the session, NOT a killed process; not a substitute for a
  cluster scheduler, Ch 13's `sbatch`; the precise tmux-vs-`nohup`
  delta, tmux adding reattach, live view, and multiple windows);
  and screen plus driving tmux from a script (`send-keys` /
  `capture-pane`). Callouts: 1 RECOVERY (reattach after a dropped
  connection with `tmux ls` then `tmux attach -t`, and `attach
  -d` when a session is already attached elsewhere), 2 PITFALL
  (a session started as `tmux new-session -d 'cmd'` self-destructs
  when the job exits, taking the scrollback, verified by a live
  capture, so run the job inside a shell or rely on the Ch 10
  log; and nested tmux, where `Ctrl-b` reaches the outer session
  and `Ctrl-b Ctrl-b` the inner), 1 REPRODUCIBILITY (the job and
  its Chapter 10 `tee` log both outlive the disconnect, and the
  log survives even the session self-destruct, neither Chapter
  credited for the other's job), 1 DIVERGENCE (tmux `C-b` vs
  screen `C-a`, and the different command sets). No DANGER
  (nothing here destroys, as Ch 5/12), no figure. A verified-not-
  assumed subtlety: the self-destruct is a real run, and the
  "progressed while detached" claim is two real `capture-pane`
  dumps, not an assertion. Real output: six sandbox transcripts
  (`ch14-coreloop.txt`, `ch14-progress.txt`, `ch14-structure.txt`,
  `ch14-sendkeys.txt`, `ch14-selfdestruct.txt`, `ch14-screen.txt`;
  Ubuntu 22.04.5, tmux 3.2a, GNU Screen 4.09.00; all demos in the
  sandbox, `capture-pane` pad-lines stripped). The Section-3
  server blocks are captured by `transcripts/capture-ch14-mac.sh`
  (ssh one-shots only, BatchMode, hostname/account/home/IP masked
  at capture time, `tmux ls` filtered to the demo session `job`;
  a throwaway `~/ch14-job.sh` and `~/ch14-job.log` written and
  removed at the end) into `ch14-versions-mac.txt` (the Mac's own
  tmux 3.7a and screen 4.00.03 stamped) and `ch14-server-mac.txt`,
  RECONCILED byte-for-byte 2026-07-05. Scope held: no
  re-teaching of `ssh`/`rsync` (Ch 13), `nohup`/`SIGHUP`/`disown`
  (Ch 9, cross-ref as the stopgap tmux replaces), the run log
  (Ch 10), or the process model (Ch 2); copy-mode, theming,
  status-line customization, and plugin managers are deliberately
  out (PLAN Section 3, when in doubt cut); screen is a one-breath
  aside, not a parallel tutorial. Sources in
  `verification/chapter-14.md`. This commit also folds in a
  one-line consistency fix to the committed Chapter 13: its
  `nohup` handoff no longer says the log can "only be read
  afterward" (you can follow it live with `tail -f`), matching
  Chapter 14's precise `nohup`-versus-tmux contrast, a Codex
  round-2 finding that the whole-tree sweep traced back to Ch 13.
- **Chapter 13, "SSH and Remote Compute" (Phase 5, Part III,
  the THIRD of the four Part-III chapters; Ch 11 "Make" is a
  committed Phase-2 exemplar and is skipped here. Drafted
  2026-07-05; validator 0/0 in the sandbox; of 21 fenced code
  blocks 18 are transcript-backed (17 prompted plus the renv
  output block) and confirmed as contiguous substrings of the
  ch13-* transcripts (5 sandbox transcripts + 7 Mac
  transcripts), with marked [...] elisions for the rsync file
  list and the uv/renv install logs, and the other 3 are
  authored non-capture listings. The Mac transcripts were
  captured by the user running transcripts/capture-ch13-mac.sh
  and a tunnel re-capture against a real remote Linux server
  (AWS EC2 Ubuntu, kernel 6.8.0-aws, with R and uv userspace);
  the capture scripts hardcode no personal data, deriving the
  server hostname/account/home/mount/device/IP at runtime and
  masking them, emitting the alias as lab-server, with two
  further masks applied on ingestion and documented (the Mac's
  own hostname inside a ~/.ssh filename, and a host-named private
  key). Sources pinned + fetched 2026-07-05 (OpenSSH
  ssh/ssh_config/ssh-keygen, rsync, openrsync, and the Slurm
  sbatch/squeue/scancel docs). The book's THIRD figure,
  fig-ch13-motion, was authored and built font-independently
  (pdflatex -> gs -dNoOutputFonts -> pdftocairo -svg, per the
  Ch 5 lesson, not dvisvgm) and eyeballed from the outlined PDF.
  Codex blind audit round 1 is DONE 2026-07-05: the canonical
  Mac `uv run` validator (0/0) and `quarto render` (189-page
  PDF, Ch 13 pp. 157-169, the figure renders in HTML and PDF
  and the long output lines wrap without overflow) both passed,
  and round 1's five blockers, four should-fixes, and two nits
  were ALL applied (the ~/.ssh filename masks, the softened
  R-version claim, the per-second Runpod billing correction with
  pinned docs, the tunnel block's missing line, and smaller
  wording/fence fixes). Codex round 2 (paperwork reconciliation)
  then caught the stale public docs and one stale note in
  `ch13-restore-mac.txt` (an R-version assertion left in the
  transcript header after the chapter/verification/CHANGELOG were
  fixed), all reconciled; the final Codex green-light re-review
  and human review passed; committed + pushed 2026-07-05 as
  `8c2cf09` (HEAD = origin/main = refs/heads/main). This
  chapter's commit does NOT close gate G5, which needs
  Ch 10 + 12 + 13 + 14; it carries the pending Ch 12 `1b3fb47`
  CHANGELOG hash-line touch below, since a commit cannot contain
  its own hash; Ch 13's own `8c2cf09` hash line, added here after
  the push, becomes the pending touch and rides with the Ch 14
  commit.)** Delivers the
  laptop-to-server motion Chapter 1 promised and the environment
  rebuild Chapter 12 deferred, on one spine: the same project
  and workflow, on a machine you cannot see. Seven content
  sections (5 beginner, 2 advanced) plus unnumbered Try-it:
  reaching a shell with `ssh` (interactive and one-shot, the
  known_hosts host-key-change RECOVERY, and an honest scope on
  what ssh does and does not guarantee); keys and the
  permissions that make them work (a throwaway `ssh-keygen`
  demo, `chmod 600`/`700` applying Chapter 9, `ssh-agent`, the
  annotated `~/.ssh/` tree, and the wrong-permissions PITFALL);
  a config file and a port forward (`~/.ssh/config` with
  `ssh -G` evidence, `ssh -L` reaching a server-side service via
  a real tunnel, and the agent-forwarding PITFALL quoting the
  ssh_config security warning); moving the project with `rsync`
  (the trailing-slash semantics, excluding `.venv`/`renv/library`
  per Chapter 12, the `--delete` DANGER shown with a `-n` dry
  run, and the openrsync-vs-GNU DIVERGENCE); verifying the
  transfer (cross-machine `sha256sum`/`shasum -a 256` agreement,
  the precise distinction between rsync's after-transfer
  whole-file checksum and an end-to-end manifest, `tar`/`du`/`df`,
  and a REPRODUCIBILITY callout tying checksum-verified transfer
  to the lockfile rebuild); rebuilding the environment and
  surviving a disconnect (a live `uv sync` and `renv::restore()`
  on the server, delivering Chapter 12's payoff on a third
  platform, and the SIGHUP/`nohup`/tmux-is-Chapter-14 handoff);
  and the bigger remote worlds (a GPU pod as another Linux box
  plus a meter, an HPC scheduler's `sbatch`/`squeue`/`scancel`
  as recognize-and-route, VS Code Remote as a pointer). A live
  finding corrected a drafted assumption: macOS openrsync accepts
  `--itemize-changes` and `-z` (the OpenBSD man page implied
  otherwise), so the divergence is framed as
  implementation/protocol, not flag failure. Scope held: no tmux
  (Chapter 14), no re-teaching of `chmod` (Chapter 9), checksum
  mechanics (Chapter 3/10), or uv/renv (Chapter 12); `ncdu` named
  and routed to Chapter 15; SSH server administration out
  (client-side only, no sudo on the box). Sources in
  `verification/chapter-13.md`.
- **Chapter 12, "Environments from the Shell" (Phase 5, Part
  III, the SECOND of the four Part-III chapters; Ch 11 "Make"
  is a committed Phase-2 exemplar and is skipped here. Drafted
  2026-07-04; validator 0/0 in the sandbox; 16 shown blocks
  byte-backed (14 sandbox + 2 Mac). The 2 Mac blocks
  (renv::status / no-op renv::restore; R.version.string /
  packageVersion("fixest")) were RECONCILED byte-for-byte
  2026-07-04 after the user ran `capture-ch12-mac.sh` (R 4.5.3,
  renv 1.2.3; two drafted guesses corrected: the R release
  date is 2026-03-11, and packageVersion prints Unicode curly
  quotes ‘0.14.2’, kept byte-faithful; the status/restore
  wording matched as drafted, and renv prints no loader banner
  under Rscript). Canonical Mac `uv run` validator 0/0,
  `quarto render` (fresh final 177-page PDF, Ch 12
  pp. 145-156, clean, incl. the curly-quote block, the long
  content-sha256 line, and the uv sync install list), Codex
  blind audit round 1, and final Codex green-light re-review
  are DONE (2026-07-04; 1 blocker + 2 should-fixes + 1 nit,
  applied: the renv no-manifest-file reword in the two flagged
  places, since renv discovers dependencies from the project
  code and renv.lock is the lockfile only, not a manifest; the
  split inline transcript path in the provenance note rejoined;
  a stale "pending reconcile" line in the verification log
  updated; the timezone-mask nit declined with rationale, the
  zone already being public via Ch 10's committed TZ example
  and the unmasked git author identity; the final re-review
  added the direct renv dependencies() source pin and re-swept
  the corrected render). Human review approved 2026-07-04;
  committed + pushed 2026-07-04 as `1b3fb47`.
  This chapter's commit does NOT close
  gate G5, which needs Ch 10 + 12 + 13 + 14. This chapter's
  commit carries the pending Ch 10 `f973acb` CHANGELOG
  hash-line touch below, since a commit cannot contain its own
  hash; Ch 12's own `1b3fb47` hash line, added here after the
  push, becomes the pending touch and rides with the Ch 13
  commit).** Continues Part III's reproducibility arc on one
  idea: a reproducible analysis needs a reproducible
  environment, the exact package versions the code ran
  against, captured in a lockfile and restored from the shell
  on any machine (Ch 10 pinned the shell environment, this
  chapter pins the language environment, Ch 11 orchestrates
  and re-checks). Seven content sections (5 beginner, 2
  advanced) plus unnumbered Try-it: the manifest/lockfile pair
  (a language environment is NOT a shell variable, Chapter
  2/9's concept disambiguated, not re-taught; the real
  `pyproject.toml` five `>=` floors vs `uv.lock` pinning
  `statsmodels==0.14.6` and 27 more, read in the real project);
  restore and run (`uv sync` in a clean `/tmp` copy rebuilds
  `.venv/` at exactly the locked versions and verifies on
  rerun; the annotated ASCII `.venv/` tree, the Ch 5 house
  device, paired with the real `ls`; `uv run` executes step 0
  without activation and reprints the locked `49b3a173...`
  content hash, stated precisely: the seed and the generator's
  deterministic design pin the numbers, the G1 invariant
  referenced not re-derived, while the lockfile pins the code
  computing them; `PY := uv run python` quoted as Ch 11's
  seam); changing it on purpose (`uv add tabulate` updates
  environment + manifest + lock together, tabulate==0.10.0
  being itself a drafted-guess-would-have-been-wrong case;
  upgrades only via explicit `uv lock --upgrade`, so a lock
  never goes stale on its own); renv as R's same job
  (`renv.lock` read with Ch 7's `jq`: R 4.5.3, fixest 0.14.2,
  consistent with Ch 7's committed values; the
  init/snapshot/restore/status verbs mapped one-to-one onto
  uv's; the one-line `.Rprofile` -> `renv/activate.R`
  auto-activation seam, why Make's `Rscript` node needs no
  wrapper; `scripts/bootstrap_renv.R` named as the project's
  real bootstrap); provenance receipts (`uv pip list` saved
  beside Ch 10's dated run log; `R.version.string` +
  `packageVersion("fixest")` agreeing with the lockfile;
  `sessionInfo()` taught in prose with one full capture
  recorded in the transcript, the Ch 10 `script` handling);
  commit the lock, not the environment (`pyvenv.cfg`'s
  `home = /usr/bin` + `readlink .venv/bin/python` ->
  `/usr/bin/python3` as machine-wiring evidence, Ch 4's
  readlink applied; the real `.gitignore` ignoring `.venv/` +
  `renv/library/` while tracking both locks, Ch 5's
  tracked-vs-regenerated applied); and beyond uv/renv
  (alternatives named in one breath: conda/mamba, Poetry,
  pipenv, venv+pip, packrat superseded by renv; Docker NAMED
  as the OS-layer next step per renv's own docs and PLAN
  Section 3's explicit cut, own book, nothing run). Callouts:
  1 PITFALL (the manifest and lock separate at the COMMIT
  boundary: uv re-locks automatically on the author's machine,
  so committing half the pair strands the collaborator on a
  fresh resolution or a `uv run --locked` error; same for
  renv::install without snapshot), 1 REPRODUCIBILITY (the
  three-layer Part-III stack with honest edges: lockfiles pin
  packages, not R itself, not the OS/system libraries, not the
  data, each pin named for its own layer), 1 DIVERGENCE (the
  lockfile is cross-platform BY DESIGN while the built
  environments are platform-wired: the sandbox's Linux `.venv`
  vs the same project's `renv/library/macos/R-4.5`, with the
  honest caveat that identical versions do not guarantee
  bit-identical numerics across BLAS builds, the 4-dp alpha
  lock Ch 11 records). No DANGER (nothing destroys, as Ch 5),
  no RECOVERY (the restore verbs ARE the recovery), no figure
  (the annotated tree carries the layout). Real output: eight
  sandbox transcripts (`ch12-uv-version.txt`,
  `ch12-uv-sync.txt`, `ch12-uv-run.txt`, `ch12-venv-tree.txt`,
  `ch12-uv-list.txt`, `ch12-uv-add.txt`, `ch12-lockread.txt`,
  `ch12-renv-tree.txt`; Ubuntu 22.04.5, uv 0.11.19, CPython
  3.10.12, jq 1.6; restore demos in clean `/tmp` copies, the
  `uv add` in a separate throwaway copy so the real lock is
  untouched, lockfile reads read-only in the real project;
  `UV_LINK_MODE=copy` exported to silence a sandbox-specific
  cross-filesystem hardlink advisory, disclosed in the
  transcript notes). The 2 Mac blocks were captured by
  `transcripts/capture-ch12-mac.sh` (non-interactive Rscript
  only, no sudo, no snapshot so `renv.lock` is never
  rewritten, standard capture-time masks incl. the `$TMPDIR`
  scrub) and reconciled byte-for-byte 2026-07-04, with one
  full masked `sessionInfo()` (openblas BLAS, C.UTF-8 locale,
  fixest_0.14.2) and the Mac uv stamp (uv 0.11.2, Homebrew)
  recorded in the transcripts for the log. Scope held: no re-teach
  of Chapter 2's shell-env/PATH concept or Chapter 9's env-var
  secrets (disambiguated and referenced), Chapter 11's Make
  (the environment is what Make invokes, cross-ref), Chapter
  6/7 tools (applied), or the G1 seed mechanics (referenced as
  the locked invariant); Docker named not taught; no
  environment-tool survey beyond the one-breath naming; SSH
  restore stays forward "will" (Chapter 13). Sources pinned in
  `verification/chapter-12.md` (uv project-layout and
  locking/syncing pages, renv intro vignette, status reference,
  and dependencies reference, all fetched 2026-07-04).
- **Chapter 10, "Scripts That Fail Loudly" (Phase 5, Part III,
  the FIRST of the four Part-III chapters; Ch 11 "Make" is
  already committed as a Phase-2 exemplar and is skipped here.
  Drafted 2026-07-03; validator 0/0 in the sandbox; 18 shown
  blocks byte-backed (14 sandbox + 4 Mac). The 4 Mac blocks
  (bash-3.2 floor, ShellCheck, shfmt, BSD `/usr/bin/time`) were
  RECONCILED byte-for-byte 2026-07-03 after the user ran
  `capture-ch10-mac.sh` (ShellCheck 0.11.0, shfmt 3.13.1; five
  drafted guesses corrected, incl. the bash build `darwin25`, the
  `declare -A` block's real trailing `1`, and the BSD RSS line).
  Canonical Mac `uv run` validator 0/0, `quarto render` (165-page
  PDF, Ch 10 pp. 118-130, clean), and Codex blind audit round 1
  (2 blockers + 3 should-fixes + 1 status-cleanup, all applied:
  the "four-line" header count, the narrowed LC_ALL/TZ claim, the
  "next chapter" bridge, the `/tmp`-fixture Try-it, and the
  ShellCheck "flags likely bugs" wording) are DONE (2026-07-03),
  and Codex round 2 (1 blocker, a residual "cost nothing / every
  analysis script" overclaim scoped down, + 1 stale-status-label
  should-fix) applied; final Codex green-light and human review
  passed; committed + pushed 2026-07-04 as `f973acb`. Its commit
  does NOT close gate G5, which needs Ch 10 + 12 + 13 + 14. That
  commit carries the pending Ch 9 `3c210d5` CHANGELOG hash-line
  touch above, since a commit cannot contain its own hash; Ch
  10's own `f973acb` hash line, added here after the push,
  becomes the pending touch and rides with the Ch 12 commit).** Opens Part III
  (the workflow climax) on one idea: a research script should fail
  loudly and reproduce identically. Seven content sections (5
  beginner, 2 advanced) plus unnumbered Try-it: the shebang and
  the bash target (`#!/usr/bin/env bash`, why not `/bin/sh` or
  zsh); `set -euo pipefail` line by line (`-e` stop on error, `-u`
  unset-variable guard, `-o pipefail` carried from Chapter 6, not
  re-taught); exit codes made operational (explicit `exit N`, a
  guard that chooses its status, `$?`, and a `trap ... ERR`/`EXIT`
  handler, delivering Chapter 2's forward promise); linting with
  ShellCheck (the SC2086 unquoted-expansion Chapter 6 warned about)
  and shfmt; a trustworthy run log with `tee` (delivering Chapter
  6's and Chapter 9's forward promise), `script` (in prose, its
  session capture being non-deterministic), and `/usr/bin/time -v`;
  pinning the environment with `LC_ALL=C` and `TZ=UTC` (delivering
  Chapter 7's deferred locale pin and Chapter 2/3's forward "will")
  so sort order, date strings, and checksums stop drifting; and a
  `verify.sh` anchor over the running example that combines the
  whole standard header with a file-level `sha256sum -c` against a
  locked manifest, failing loudly (nonzero exit, `ERR` trap) when a
  raw byte drifts and `tee`ing a log. Callouts: 1 DANGER (a
  no-`set -e` script marches past a failed step and writes a
  confident empty output while exiting 0, the scripted sibling of
  Chapter 6's `pipefail` trap and Chapter 5's raw-in/generated-out
  hygiene), 1 PITFALL (the three `set -e` footguns, each verified
  live: a `local x=$(cmd)` assignment masks the failure because
  `local` succeeds, a function used as an `if` condition suppresses
  `set -e` throughout, and the left of `&&` may fail; a BARE
  `x=$(cmd)` assignment by contrast DOES fire, so the mask is
  attributed to `local`, not command substitution in general), 2
  DIVERGENCE (the macOS bash-3.2 floor made operational, `declare
  -A`/`${var^^}`/`mapfile` failing on the system `/bin/bash`; and
  BSD `/usr/bin/time -l` vs GNU `-v` plus BSD `date -r` vs GNU
  `date -d @`, with `time` also a shell keyword), 1 REPRODUCIBILITY
  (the four-line standard script header), 1 RECOVERY (debug a
  failed script with `bash -x`, the `ERR` trap, and the exit code).
  No figure. Real output: ten sandbox transcripts
  (`ch10-shebang.txt`, `ch10-set.txt`, `ch10-nosete.txt`,
  `ch10-exit-trap.txt`, `ch10-footguns.txt`, `ch10-debug.txt`,
  `ch10-tee.txt`, `ch10-time.txt`, `ch10-locale.txt`,
  `ch10-verify.txt`; GNU bash 5.1.16, GNU coreutils 8.32,
  util-linux 2.37.2; every demo in throwaway `/tmp` scratch, the
  `verify.sh` anchor over a fresh `/tmp` copy of the running
  example's `data/raw/`). The `verify.sh` locked hashes
  (`8648c3be...`/`5056f919...`) are file checksums of the
  deterministic raw CSVs, distinct from the content digest
  `49b3a173...` that Chapter 11's `make check` re-derives; the
  chapter says so rather than conflating them. The 4 Mac blocks are
  captured by `transcripts/capture-ch10-mac.sh` (no interactive
  shell, no sudo, standard capture-time masks) and reconciled at
  the gate; the ShellCheck/shfmt versions are stamped from the real
  capture (the Ch 7 DuckDB / Ch 8 `fd` lesson). Scope held: no
  re-teaching of Chapter 6's pipe/redirection mechanics or
  quoting/null-safety (applied and reinforced), Chapter 2's
  exit-code concept (made operational), Chapter 11's Make (the
  script is the node, Make the graph, cross-ref), or Chapter 9's
  env-var secrets; environments/lockfiles (Chapter 12), SSH
  (Chapter 13), and tmux (Chapter 14) stay forward "will". Sources
  pinned in `verification/chapter-10.md` (ShellCheck SC2086 wiki
  and shfmt/mvdan.cc/sh fetched 2026-07-03; `set`/`trap` behavior
  primary-evidenced by live capture, the gnu.org Set-Builtin HTML
  node having returned empty this session).
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
  approved; committed + pushed 2026-07-03 as `3c210d5`, the Mac
  closeout commit that closes G4.
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
