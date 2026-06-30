# Changelog

Notable changes to the Terminal & Shell book build, newest first. Dates are
absolute. Detailed design and state notes live in separate planning docs that
are not part of this repo; this file is the repo-visible history.

## [Unreleased]

### Added

- `SETUP.md`: build environment and per-phase dependency guide across three
  machines (Mac, an SSH Linux box, the workspace sandbox).
- `CHANGELOG.md`: this file.

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
