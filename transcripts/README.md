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

## Transcript numbering is frozen at capture time (Session 1 renumber) — TEMPORARY

> **Temporary scaffolding, not the end state.** The freeze below holds only
> until the dedicated provenance-realignment pass (review-response
> `private/review-response-2026-07-08.md`, §6 Session 7), which renames every
> transcript to match the final chapter numbering and deletes this note. Until
> then, use the `ch(N-1)` mapping below. Do not "fix" the offset piecemeal;
> it is resolved once, in that session.

The `chNN-` filename prefix and the `chapter:` header field record the
chapter number **in effect when the transcript was captured**, and are
deliberately **not** renumbered when chapters are reordered. The
structural revision of 2026-07-08 inserted a new mini-chapter
(`04-shell-literacy.qmd`, "How to Read a Shell Command") after Setup, so
the former Chapters 4-17 shifted to 5-18. Their transcripts keep their
original prefixes.

Mapping after that renumber:

- Chapters 1-3: unchanged; transcripts `ch01`-`ch03`.
- Chapter N for N in 5..18: backed by transcripts `chMM` where
  `MM = N - 1` (e.g. Chapter 5, Navigation, uses `ch04-*`; Chapter 18,
  startup files, uses `ch17-*`).
- Chapter 4 (shell literacy): reference tables only, nothing executed,
  so it has **no** transcripts.

**Byte-faithful exception (important for the renumber).** A chapter-number
reference that appears INSIDE a shown verbatim capture block must stay
byte-identical to its transcript, i.e. frozen at the OLD number, even while the
surrounding prose is renumbered. The Session-1 prose bump wrongly touched one
such line; it has been reverted. The one live instance:
`15-persistent-sessions.qmd` shows `# The Ch 10 log survives...` (matching
`ch14-server-mac.txt`) directly under prose that correctly reads "its Chapter 11
log". That 1-off between the capture (frozen 10) and the prose (current 11) is
expected under the freeze and is resolved in Session 7, which realigns the
transcript and the block together. Rule for content sessions: never renumber a
chapter reference inside a `$`/`>`-prompt capture block.

Renumbering the ~80 transcript files was rejected as churn that would
rewrite provenance names cited across `CHANGELOG.md` and the handover
trail. A chapter's own source-verification log (`verification/chapter-N.md`)
names the exact `chMM-*` transcripts it relies on, so the link stays
auditable despite the offset.

The same freeze applies to **figure assets**: `book/assets/figures/chNN/`
directories and the `fig-chNN` cross-reference labels keep their original
chapter number. A `fig-chNN` label is internal (Quarto auto-numbers the
figure by whatever chapter now contains it), so freezing it is invisible
to readers and avoids repointing every `![](...)` at a renamed file.

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
