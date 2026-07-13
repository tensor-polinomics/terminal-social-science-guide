# Source-verification log: Phase 8 (citations and bibliography)

Provenance record for the Phase 8 citation workstream (2026-07-13),
per PLAN.md Section 10 and `private/phase8-citations-runbook.md`.
This phase added a formal bibliography and tasteful in-prose
citations; it drafted no new tool behavior and captured no new
output.

## Two classes of cited source

1. **Tool and standard documentation** (POSIX, the GNU manuals,
   uv, renv, OpenSSH, rsync, DuckDB, jq, ShellCheck, shfmt,
   Homebrew, PowerShell execution policy, Slurm, tmux, crontab(5),
   the modern-kit repos, and the AI-CLI docs). Each of these was
   ALREADY pinned in the per-chapter logs with a URL and fetch
   date; Phase 8 only surfaced that same authority to the reader
   as an in-prose citation, and the bib URLs and urldates are
   those recorded fetch dates. For a few cross-cutting tools the
   pin lives in the log of the chapter where the behavior was
   first verified, not the chapter where Phase 8 places the
   citation: e.g. the GNU Findutils manual is pinned in the
   Chapter 7 log (url .../find_html/, fetched 2026-06-30) and
   cited in Chapter 9, with a cross-reference record added to the
   Chapter 9 log.

2. **Canonical works** (sandveEtAl2013, wilsonEtAl2017, turingway,
   kernighanPike1984, ahoEtAl2023, gentzkowshapiro2014,
   bryanHester; plus the pre-existing friedl2006 and shotts2024).
   These are NEW bibliographic sources that were NOT in the
   per-chapter logs before Phase 8. Each was verified during this
   phase, and a per-chapter source record was ADDED to the
   relevant log (see the "Phase 8 citations" sections appended to
   `verification/chapter-01.md`, `-06.md`, `-08.md`, `-13.md`).

## Bibliography

`book/references.bib` grew from 2 entries to **34**. It is
maintained per the paper-wiki conventions and paper-wiki is the
file's designated sole writer (DOI/ISBN for canonical works;
`@misc` with url + urldate for docs; version stamps on volatile
tool/AI docs). Entries sorted by citekey. Case-sensitive names in
titles, and bare-domain `howpublished` values, are brace-protected
so Chicago author-date rendering preserves them.

DOIs verified to resolve: sandveEtAl2013
(10.1371/journal.pcbi.1003285), wilsonEtAl2017
(10.1371/journal.pcbi.1005510), turingway (10.5281/zenodo.7625728,
the versioned 1.0.2 release dated 2022-07-27; NOT the all-versions
concept DOI 10.5281/zenodo.3233853). ISBNs confirmed: ahoEtAl2023
(9780138269722), kernighanPike1984 (9780139376818), friedl2006
(9780596528126).

Authorship set from the primary source in each case:
`crontabman` -> Paul Vixie (cronie project); `rsync` -> Andrew
Tridgell and Paul Mackerras, the manual's AUTHOR section, with
many later contributors noted in `howpublished`; `bryanHester` ->
Bryan, Hester, Pileggi, Aja.

## In-prose citations, by chapter

- Ch 1: sandveEtAl2013, wilsonEtAl2017, turingway (grouped
  reproducibility-canon reading pointer); kernighanPike1984 (Unix
  small-tools lineage). shotts2024 was already present.
- Ch 2: gnucoreutils (GNU ls exit-code documentation), posix2018
  (`command -v` portability).
- Ch 3: homebrew (attached to the `brew install` mechanics the
  docs support, not the "de facto standard" claim), msExecutionPolicy.
- Ch 6: gentzkowshapiro2014, wilsonEtAl2017 (folder-structure
  clause only, not the replication-crisis clause).
- Ch 7: posix2018 (`&>` undefined in POSIX sh), gnubash (shopt).
- Ch 8: ahoEtAl2023 (awk), duckdb, jqmanual; friedl2006 already
  present.
- Ch 9: gnufindutils (find), ripgrep (attached to the "skips the
  noise files" behavior the repo documents, not an "every file"
  claim), fdfind.
- Ch 10: gnucoreutils (chmod), zshmanual (HIST_IGNORE_SPACE).
- Ch 11: shellcheck, shfmt.
- Ch 12: gnumake.
- Ch 13: uv, renv; bryanHester as a further-reading pointer in
  "Beyond uv and renv" for the project-oriented R workflow,
  distinct from the renv docs cited for status/restore behavior.
- Ch 14: openssh, rsync (trailing slash), slurm.
- Ch 15: tmux.
- Ch 16: ezacli, fdfind, ripgrep.
- Ch 17: claudecode_permissions, openai_codex_security, geminicli.
- Ch 18: gnubash (INVOCATION), zshmanual (startup files),
  crontabman.

Citation-verify: all 34 entries cited at least once; zero orphans;
zero undefined citekeys.
