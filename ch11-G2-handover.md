# Ch 11 handover for blind audit (Codex)

**Scope:** Chapter 11, "Make as Cross-Language Pipeline Glue."
This is **exemplar 1 of 3** for the Phase 2 / G2 style gate.
Chapters 6 and 16 are not yet drafted; the full G2 audit will
cover all three. This early hand-off is for Ch 11 only, the
exemplar that carries the running-example climax.

**What you are auditing against (the contract, not my read):**
`PLAN.md` (design + delivery spec) and `CLAUDE.md` (durable
rules + reproducibility invariant). Audit independently for:
accuracy, source-pinning, security (supply-chain, secrets,
destructive commands), portability (do the divergence claims
hold), and render. Per `PLAN.md` Section 15 you get the
artifact plus the contract; this summary is a file map and a
list of unresolved facts, not a verdict.

**Mechanical gate status:** `uv run python
tools/validate_book.py book` -> `0 error(s), 0 warning(s)`.
(`uv run` is the canonical command; it provisions PyYAML from
`uv.lock`. A bare `python3` only works if PyYAML is already on
the interpreter, which it is not by default.) The structural
validator
is a lint, NOT a render. **The chapter has not yet been
`quarto render`-ed**; an HTML+PDF render on the Mac is part of
the audit (see Open items).

---

## Artifact manifest

| File | Purpose |
|---|---|
| `book/chapters/11-make-pipeline.qmd` | the chapter (647 lines) |
| `tools/validate_book.py` | **changed** (see "Deliberate decisions", item 1) |
| `verification/chapter-11.md` | source-verification log, 8 entries, dated 2026-06-30 |
| `transcripts/ch11-make-mac.txt` | Mac: full cross-language build, incremental rebuilds, timestamp diagnostic, `make check` pass + drift-fail |
| `transcripts/ch11-make-version.txt` | sandbox: GNU Make 4.3 version |
| `transcripts/ch11-tab-trap.txt` | sandbox: TAB trap (Make 4.3) |
| `transcripts/ch11-tab-trap-mac.txt` | Mac: TAB trap (Make 3.81) |
| `transcripts/ch11-automatic-vars.txt` | sandbox: `$@ $< $^` demo |
| `transcripts/ch11-python-subgraph.txt` | sandbox: Python half builds in /tmp, hash reproduces |
| `transcripts/ch11-timestamp-mac.txt` | Mac: deterministic `touch -t` mtime demo |
| `transcripts/capture-ch11-mac.sh` | capture script (Mac cross-language demos) |
| `transcripts/capture-ch11-tabtrap-mac.sh` | capture script (Mac 3.81 TAB message) |
| `transcripts/capture-ch11-timestamp-mac.sh` | capture script (Mac timestamp demo) |

The chapter is built on the committed Phase 1 pipeline in
`sandbox/asset-pricing/` (Makefile + scripts), not re-locked.

---

## Output provenance (for the "real output only" check)

Every command block in the chapter traces to a transcript on
the machine that produced it. The toolchain split (PLAN
Section 4 / CLAUDE.md) is: Python runs in the locked-down
Linux sandbox; R + integrated `make` + Quarto render are
Mac-only.

- **Mac (macOS 26.5.1, GNU Make 3.81, R 4.5.3, Quarto 1.9.36):**
  the full build, incremental rebuilds, timestamps, `make
  check`, the 3.81 TAB message, the deterministic timestamp
  demo.
- **Sandbox (Ubuntu 22.04, GNU Make 4.3, uv 0.11.19):** generic
  Make mechanics (TAB trap, automatic variables) and the Python
  half of the pipeline (steps 00-03), which reproduces the
  locked data hash.
- **Stata / EViews:** recipes are illustrative and **never
  executed**; both are labeled "illustrative; not run here."

Long verbatim tool-output lines may exceed 64 chars by design
(see Deliberate decisions, item 1). Wrapping convention: typed
command lines wrap with a real shell `\`; tool output is shown
verbatim.

---

## Locked reproducibility invariant (verify the numbers)

From `CLAUDE.md`, LOCKED at G1; the chapter must not contradict
these:

| Quantity | Value |
|---|---|
| Seed | `20260629` |
| Lambda | `0.00149` |
| Panel | 300 firms x 180 months (179 after the lag) |
| Data content SHA-256 | `49b3a1733cf22f5339f1f56edb50bcb6ae02e8d6a029b8f894f279cdf55dbccb` |
| Long-short alpha | `0.0034`/mo (4 dp), t approx 2.64 |
| Figure | cumulative long-short return, ends approx 104% (103.95%) |
| Factor loadings | 4 of 5 insignificant; HML marginal (t approx -1.8, p approx 0.07) |

The chapter quotes the hash truncated (`49b3a1733cf2...`) and
the alpha as `0.0034`. It does not claim "all betas zero" (it
does not discuss the betas; that honesty lives in the
pipeline's `report.qmd`).

---

## Source-pinned claims to scrutinize

All logged in `verification/chapter-11.md` with URLs + access
dates. The load-bearing ones:

1. **Automatic variables** `$@`/`$<`/`$^` — GNU Make manual +
   live demo.
2. **`.PHONY`** semantics — GNU Make manual.
3. **Timestamp rule + low-resolution ties** — GNU Make manual
   `.LOW_RESOLUTION_TIME` (same-second = up to date), Make 4.0
   release + 2011 hi-res patch (sub-second postdates 3.81).
   Also shown deterministically and observed as a real race.
4. **TAB message identical on 3.81 and 4.3** — both captured.
   (See Deliberate decisions, item 3: an earlier draft claimed
   3.81 was terser; that was wrong and is corrected.)
5. **`cat -A` (GNU) vs `cat -et` (BSD/macOS)** — captured.
6. **Stata `stata -b do` writes a log** — Stata FAQ.
7. **EViews is Windows/interactive; consumed as a committed
   prerequisite** — EViews command reference.

---

## Deliberate decisions (evaluate, do not flag as drift)

1. **Validator change (`tools/validate_book.py`).** The ~64
   width check now applies only to typed `$ `/`> ` command
   lines and to authored code listings (Makefiles, scripts);
   verbatim tool output inside a terminal-session block is
   exempt. Rationale: the width rule exists so a reader can
   copy commands without horizontal scroll and so PDF code
   stays in the margin, which applies to input, not to machine
   output that must stay byte-faithful to the "real output
   only" rule. This is a **gate-contract change** introduced
   this phase; please assess whether it weakens the gate. Unit
   behavior: long `$` command -> warns; long output -> exempt;
   long authored listing -> warns.

2. **Five callouts, two new to this book.** DANGER
   (`.callout-caution`) and DIVERGENCE (`.callout-note`) get
   their templates set here (the Git book used only PITFALL /
   RECOVERY / REPRODUCIBILITY). The DANGER callout is on `make
   clean` running `rm -rf` unconfirmed, cross-referencing Ch 6.

3. **A mid-draft accuracy error was caught and corrected.** I
   initially asserted macOS Make 3.81 prints a terser
   `missing separator` message without the "did you mean TAB"
   hint. The Mac capture disproved it (3.81 prints the
   identical hint). The chapter, both TAB transcripts, and the
   verification log were corrected. Flagged here for
   transparency; please confirm no residue of the wrong claim
   remains.

4. **Tiering.** Sections are tagged BEGINNER / ADVANCED per
   CLAUDE.md. The graph-reading, build, incremental, smoke-check
   sections are BEGINNER; automatic variables, timestamps,
   `.PHONY`, the portable-Python tier, Stata/EViews, and the
   `just`/Snakemake aside are ADVANCED.

---

## Post-audit fixes (round 1, applied 2026-06-30)

Codex's blind audit found six textual/provenance issues; all
fixed:

- **High** Makefile spine excerpt was a broken graph
  (`ff5_alpha.tex` needed `portfolio.csv`, which had no rule).
  Added `data/clean/portfolio.csv: data/clean/portfolio.parquet
  ;` and updated the prose to cover both ride-along files.
- **High** chapter showed `$ python scripts/check.py` but the
  transcript (and a clean shell) uses `uv run python`. Fixed
  prose and block to `uv run python scripts/check.py`.
- **Medium** "figure byte for byte" overclaimed (only the data
  hash and final cumulative return are verified, not PNG
  bytes). Changed to "the locked data hash and the final
  cumulative return (103.95%)".
- **Medium** stale false comment in
  `capture-ch11-tabtrap-mac.sh` (the old "3.81 is terser"
  assumption). Corrected.
- **Medium** this handover's gate command corrected to
  `uv run python tools/validate_book.py book`.
- **Low** exercise 4 now says `cat -et` on macOS / `cat -A` on
  GNU/Linux.

Re-validated: `0 error(s), 0 warning(s)`. Recipe lines in the
spine excerpt confirmed to be real TABs.

## Closeout status after Codex audit/render

1. **Fresh render completed on the Mac.** After the round-1
   fixes, Codex ran the repo-local validator and then rendered
   the configured book outputs with `quarto render` from
   `book/`. The render produced both `_book/index.html` and
   `_book/The-Terminal-and-Shell-for-Social-Science-Researchers.pdf`
   (43 pages). No `fvextra` header was needed.

2. **Full G2 pending Ch 6 and Ch 16.** This audit is Ch 11
   only. The style-gate sign-off should ultimately weigh all
   three exemplars together.

3. **Git closeout happens from the Mac repo**, not from the
   sandbox. The chapter artifacts are now ready for the
   Ch 11 commit/push if the staged set matches the manifest.
