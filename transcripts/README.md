# Captured terminal transcripts

Real output only (PLAN.md Section 9; CLAUDE.md). Every command shown in a
chapter is run for real and its output captured here, then quoted into the
chapter. Never invent or edit transcript output. The sole exceptions are
Stata/EViews recipes, which are illustrative and labeled "illustrative; not run
here" and therefore are NOT stored as transcripts.

## Where output comes from

- **Linux/GNU** (portable + Linux side of any DIVERGENCE): the workspace
  sandbox. Note: never run `git` in the sandbox (see CLAUDE.md sandbox
  realities); it is for pipeline commands and output capture only.
- **macOS/BSD** (zsh, BSD sed/date/readlink/xargs, Homebrew, bash 3.2): the
  user's Mac, pasted in.
- **Remote/SSH/SLURM/GPU and AI-CLI** runs that cannot execute here: captured
  on the user's real machine, or documented and quarantined in a callout
  (run nothing; version-stamp).

## Capture format (auditable; defined at G0)

One transcript per file. Name it `chNN-<slug>.txt` (e.g.
`ch07-rm-rf.txt`) so it ties to its chapter. Each file begins with a
header block, then the verbatim command(s) and output:

```
# transcript
chapter: 07
os: macOS 15.5 (Apple Silicon)   # or: Ubuntu 24.04 (workspace sandbox)
shell: zsh 5.9                   # or bash 5.2, etc.
tool: GNU coreutils 9.5          # tool + version when relevant; else n/a
date: 2026-06-29
captured-by: sandbox | user-mac
---
$ <command exactly as run>
<verbatim output, unedited>
```

## Transcript numbering matches the chapter (provenance realignment done)

Every `chNN-` filename prefix and the `chapter:` header field record the
current chapter the transcript backs: Chapter N is backed by `chNN-*`
transcripts (`ch02-*` for Chapter 2, up through `ch18-*` for Chapter 18).
Chapters 1-3 are unchanged; Chapter 4 (shell literacy) is reference tables
only and has no transcripts.

The Session-1 transcript and figure freeze offset was eliminated in the dedicated
provenance-realignment pass (review-response
`private/review-response-2026-07-08.md`, Section 6, Session 7). Every
transcript and figure asset, each `chapter:` header, every capture-script
name and its internal transcript-write paths, and every `![](...)` path and
`fig-chNN` label were renamed to the current numbering. The renames leave
shown output bytes byte-identical, touching only names, the `chapter:`
header, note cross-references, and script-internal write paths; the
demo/scratch alignment below edits shown content in a few disclosed
places: the demo/scratch path renames (command paths only), the Chapter 15
`# The Ch 10 log`->`# The Ch 11 log` cross-reference comment, the
masked `mktemp` tag, and a removed leaked trailer.

**Demo and scratch names are aligned too.** The demo directories, job
files, and scratch dirs the captures create carry the current chapter
number: `ch14-demo` (Chapter 14 ssh: `ch14-restore-mac.txt`,
`ch14-transfer-mac.txt`), `ch15-job.sh` / `ch15-job.log` (Chapter 15:
`ch15-server-mac.txt`), `/tmp/ch08/` (Chapter 8: `ch08-sed.txt`), and
`/tmp/ch15demo` (Chapter 15: `ch15-progress.txt`, `ch15-sendkeys.txt`).
These names appear only as directory/file paths in the commands, and every
shown output value (checksums, step counters, package lists, CSV headers)
is independent of the path, so they were renamed in lockstep across the
capture script, the transcript, and the quoted chapter block; a re-run of
the capture script reproduces the same bytes. Two special cases: the
`mktemp` tag in `ch05-symlink-mac.txt` is masked to `ch05mac.[rand]` (the
random suffix is non-reproducible and non-identifying; the capture script
applies the mask at capture time), and a stray leaked `captured -> ...`
trailer that had slipped into `ch07-divergence-mac.txt` was removed (per
the trailer rule above). The illustrative Try-it scratch paths in the
chapters (`/tmp/ch04-play`, `/tmp/ch05-play`) and the note-header scratch
dirs (`/tmp/ch04mk`, `/tmp/ch04case`) were bumped too, in prose and
metadata only.

A chapter's own source-verification log (`verification/chapter-N.md`) names
the exact `chNN-*` transcripts it relies on, so provenance stays auditable.
## Rules

- Record OS + shell + tool version + date for every transcript; these drive the
  DIVERGENCE callouts and keep output reproducible.
- Verbatim only. No trimming that changes meaning, no hand-edited output.
- Scrub secrets/paths before a transcript is committed (PUBLIC repo). Raw or
  unscrubbed captures go under `transcripts/raw/` or `transcripts/private/`,
  which are gitignored.
- **Personal-data mask (added at the Ch 2 G3 audit, 2026-07-01):** no
  user-specific data in committed transcripts: account/home paths, personal
  file or directory names, usernames, hostnames or machine identifiers,
  emails, or any other identifying value. Mask with bracket placeholders
  that keep the teaching point (`/Users/[account]`, `/home/[account]`,
  `[hostname]`, `[account]`); truncate machine-specific list tails (e.g.
  the login PATH's user tool directories) with a marked `[...]`. Every
  mask is documented in the transcript's `note:` header; everything else
  stays byte-verbatim, and a quoted chapter block must stay byte-identical
  to its (masked) transcript. **Capture scripts must apply the mask at
  capture time** (see `capture-ch02-mac.sh`'s `mask` helpers) so a rerun
  cannot reintroduce personal data; output the user pastes back by hand is
  masked on ingestion, before it is written to any file. Script trailers
  ("captured -> ...") must never be written into the transcript itself.
  Upstream third-party metadata (e.g. package-author emails in
  `renv.lock`) is not user data and is left untouched.
