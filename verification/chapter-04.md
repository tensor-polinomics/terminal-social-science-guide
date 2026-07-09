# Source-verification log: Chapter 4 (How to Read a Shell Command)

Per PLAN.md Section 10. This chapter was added 2026-07-08 as the
shell-literacy on-ramp for Part I: a reference chapter that teaches
the reader to read a command before the later chapters use shell
syntax at speed.

## Provenance

Chapter 4 is **reference material, not an executed chapter.** It
contains three tables (command anatomy and quoting, a brackets
decoder, and a common-command shortlist) plus a read-only "Try it
yourself" decoding exercise. Nothing is run, so:

- **No transcripts.** There are no `chNN-*` capture files for this
  chapter, and none are needed. The one command shown in the Try-it
  section (`cut -d, -f1 data/returns.csv | sort | uniq -c`) is
  presented as a line to *read*, explicitly not run; it is not shown
  with output and is not transcript-backed. Every command that does
  appear elsewhere in the book keeps its own transcript in the
  chapter that introduces it.
- **No external/volatile claims to pin.** The content is definitional
  shell grammar (flags, quoting, brackets, command purposes) drawn
  from standard shell behavior; it makes no version-specific or
  source-pinned factual claim. The Shotts further-reading citation
  planned for the literacy thread is routed through paper-wiki in a
  later session, not added here.

## Cross-references

- Defines `#sec-command-anatomy` (in "The shape of a command") and the
  table labels `#tbl-command-anatomy`, `#tbl-brackets`,
  `#tbl-common-commands`.
- The Reference-appendix `cheatsheet.qmd` reuses the common-command
  shortlist and links back to `#sec-command-anatomy`.
- Forward references use "will" language: pipes and grouping are
  attributed to Chapter 7, globs and `test` to Chapter 11, and the
  Try-it one-liner to Chapter 8. All are drafted; none is claimed as
  already demonstrated here.

## Tier

Single BEGINNER on-ramp; no ADVANCED sections. Each of the three
content sections carries `{.tier-beginner}`, matching the current
book-wide tiering contract. A planned switch to ADVANCED-only
labeling (beginner as the unlabeled default) is a later book-wide
pass; when it lands, these badges come off with the rest.

## Mechanical

Validator (`uv run python tools/validate_book.py book`): part of the
Session 1 gate run. No em-dashes; tables are pipe-tables; the sole
prose code sample is inline (not a fenced listing), so the 64-char
code-width rule does not apply to it.
