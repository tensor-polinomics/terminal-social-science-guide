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
`ch06-rm-rf-danger.txt`) so it ties to its chapter. Each file begins with a
header block, then the verbatim command(s) and output:

```
# transcript
chapter: 06
os: macOS 15.5 (Apple Silicon)   # or: Ubuntu 24.04 (workspace sandbox)
shell: zsh 5.9                   # or bash 5.2, etc.
tool: GNU coreutils 9.5          # tool + version when relevant; else n/a
date: 2026-06-29
captured-by: sandbox | user-mac
---
$ <command exactly as run>
<verbatim output, unedited>
```

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
