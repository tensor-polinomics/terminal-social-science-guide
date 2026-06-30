# Source-verification log

Per PLAN.md Section 10, no tool behavior, remote-tooling, environment, or
AI-CLI detail is drafted from memory. Command behavior is verified by running
the command in the sandbox and using the real output; external or volatile
facts are pinned to the authoritative sources listed in PLAN.md Section 10 and
logged here with an access date.

## What gets logged here

Anything that is *not* simply a captured command run, i.e. claims pinned to an
external authority (man pages, GNU manuals, POSIX spec, OpenSSH/tmux/uv/renv/
Quarto/DuckDB docs, AI-CLI docs). Pure "ran it, here is the output" evidence
lives in `transcripts/`, not here.

## One file per chapter

Name each log `chapter-NN.md` (e.g. `chapter-13.md`). Append one entry per
claim, newest last.

## Entry format

```
### <claim in one line>
- chapter/section: Ch 13, "SSH key hygiene"
- source: <title> — <stable URL or `man ssh_config`>
- accessed: YYYY-MM-DD
- verifies: <the exact sentence or behavior the source backs>
- version note: <"current as of YYYY-MM-DD" for volatile/AI-CLI facts;
  "n/a" for stable spec>
- confirmable: yes | NO (flag anything you could not confirm)
```

## Rules

- Every AI-CLI and version-volatile claim carries a `version note` and a dated
  "current as of" stamp. Flag anything not confirmable as current.
- Do not cite generic "Linux tutorial" blogs. Pin to the Section 10 list.
- A claim with `confirmable: NO` may not ship in a chapter until resolved or
  rewritten as explicitly uncertain.
