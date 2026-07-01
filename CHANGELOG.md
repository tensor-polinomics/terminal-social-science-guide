# Changelog

Notable changes to the Terminal & Shell book build, newest first. Dates are
absolute. Detailed design and state notes live in separate planning docs that
are not part of this repo; this file is the repo-visible history.

## [Unreleased]

### Added

- **Chapter 6, "Pipes, Redirection, and the Danger Chapter" (Phase 2 exemplar 2
  of 3, drafted; pending gate).** Teaches the three streams (stdin/stdout/
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
  repointed the `curl|sh` cite to the Internet Archive capture + PoC). Remaining
  before the subgate closes: human review + commit. Full G2 also waits on Ch 16.
- **Chapter 11, "Make as Cross-Language Pipeline Glue" (Phase 2 exemplar 1 of 3,
  committed `2dc8bcd`).** First drafted chapter; the reproducibility showcase
  built on the committed `sandbox/asset-pricing/` graph. Teaches the dependency
  model, rule anatomy + the TAB trap, automatic variables, the one-command
  cross-language build (Python + R + Quarto), incremental rebuilds, the macOS
  Make 3.81 one-second-timestamp hazard, content-hash `make check`, `.PHONY`,
  illustrative-only Stata/EViews recipes, and a `just`/Snakemake aside. All shown
  output is real (Mac + sandbox transcripts under `transcripts/ch11-*`); sources
  logged in `verification/chapter-11.md`. Cleared the Ch 11 exemplar subgate
  (validator 0/0, HTML+PDF render, Codex blind audit, human review); full G2
  still waits on Ch 6 and Ch 16.
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
