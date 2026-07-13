# Source-verification log: Chapter 1 (Why the terminal)

Per PLAN.md Section 10. Chapter 1 is the book's opening and is
pure framing: it **executes no commands**, so it has no captured
transcript of its own. The one fenced block is a labeled,
non-runnable `text` roadmap sketch; each command in it **is**
taught, with real captured output, in the later chapter named
beside it (Make = Ch 12, ssh/rsync/GPU = Ch 14, tmux = Ch 15),
all now drafted and committed (Part III complete at G5), so the
roadmap now describes chapters that really do teach and capture
those commands, not a forward contract. The chapter's
reproducibility argument, including the
claim that journals, funders, and referees increasingly expect a
rebuild (REPRODUCIBILITY callout) and that reproducibility is now
a basic research obligation ("The payoff starts on the laptop"),
is **deferred to and sourced in the companion Git book** (PLAN
Section 6); Ch 1 attributes it in-text ("as the Git book
documents," "the Git book argues at length ... and this book
takes that as settled") and does not re-source it here. The
laptop-payoff section's other claims (a command is a record you
can rerun and share; batch file operations replace manual
repetition) are self-evident shell mechanics **demonstrated**
with real commands in the later chapters they are routed forward
to (Ch 5, 8, 9, now drafted and committed), not external facts
needing a pin.

That leaves a small number of external/volatile platform facts,
all in the DIVERGENCE callout and the Mac-centric framing.
Access date for all web sources below: 2026-07-01.

### macOS defaults to the zsh shell; most Linux servers default to bash
- chapter/section: Ch 1, "How to read this book" + DIVERGENCE
  callout; also exercise 2 (`$` vs `%` prompt)
- source: Apple Support, "Change the default shell in Terminal
  on Mac"
  (https://support.apple.com/guide/terminal/change-the-default-shell-trml113/mac),
  which documents zsh as the macOS default; plus the book's own
  real captures, `transcripts/ch07-divergence-mac.txt` (zsh 5.9
  on the author's Mac) and the Linux sandbox (GNU bash 5.1)
- accessed: 2026-07-01
- verifies: the macOS interactive default is zsh, Linux is
  typically bash; this is the recurring shell split the book's
  DIVERGENCE callouts rest on. Already transcript-backed in Ch 7.
- version note: zsh has been the macOS default since Catalina
  (2019); stable
- confirmable: yes (doc + real Ch 7 transcript)

### macOS ships BSD core tools; Linux ships GNU core tools
- chapter/section: Ch 1, DIVERGENCE callout
- source: the book's own captures, GNU coreutils in the Linux
  sandbox vs BSD tools on the author's Mac
  (`transcripts/ch07-divergence-mac.txt`,
  `transcripts/ch12-*-mac.txt`); this is the same BSD/GNU
  divergence pinned in `verification/chapter-07.md` and
  `verification/chapter-12.md`
- accessed: 2026-07-01
- verifies: the same command can print different output on macOS
  (BSD) and Linux (GNU); Ch 1 only asserts the split exists and
  points forward, the concrete cases are demonstrated in Ch 7/11
- version note: n/a (stable, long-standing platform divergence)
- confirmable: yes (real transcripts in Ch 7/11)

### WSL2 is a real Linux (full Linux kernel) running inside Windows
- chapter/section: Ch 1, "How to read this book" (Windows =
  WSL2 recommended path)
- source: Microsoft Learn, "What is Windows Subsystem for Linux"
  (https://learn.microsoft.com/en-us/windows/wsl/about) and
  "Comparing WSL Versions"
  (https://learn.microsoft.com/en-us/windows/wsl/compare-versions),
  which state WSL2 runs a full Linux kernel in a lightweight VM
- accessed: 2026-07-01
- verifies: the claim that WSL2 is "a real Linux running inside
  Windows" that behaves closely enough for the book's body to
  apply with divergences flagged
- version note: current as of 2026-07-01
- confirmable: yes

### uv (Python) and renv (R) are the environment tools that pin dependencies
- chapter/section: Ch 1, "Why researchers specifically"
- source: docs.astral.sh/uv and rstudio.github.io/renv (the
  authoritative homes per PLAN Section 10); operational teaching
  is deferred to Ch 13
- accessed: 2026-07-01
- verifies: only that uv and renv are named as the Python and R
  environment managers; Ch 1 shows no uv/renv command and makes
  no version-specific claim about either, so the naming is safe.
  Operational behavior is **deferred to Ch 13 (now drafted and
  committed) and is NOT verified by Ch 1.**
- version note: named-only in Ch 1; version-stamped operationally
  in Ch 13 (now drafted)
- confirmable: yes (named-only)


## Phase 8 citations (2026-07-13)

Four canonical works cited in this chapter's reproducibility and
lineage prose as further-reading / verify-here pointers (the
argument itself stays cross-referenced to the Git book, not
re-made here). These are NEW bibliographic sources, not previously
in this log; each verified during Phase 8:

- sandveEtAl2013 -- Sandve, Nekrutenko, Taylor, Hovig, "Ten Simple
  Rules for Reproducible Computational Research," PLoS Comput Biol
  9(10):e1003285, DOI 10.1371/journal.pcbi.1003285 (resolved via
  the PLoS article page, 2026-07-13).
- wilsonEtAl2017 -- Wilson et al., "Good Enough Practices in
  Scientific Computing," PLoS Comput Biol 13(6):e1005510, DOI
  10.1371/journal.pcbi.1005510 (resolved 2026-07-13).
- turingway -- The Turing Way Community, versioned release 1.0.2,
  DOI 10.5281/zenodo.7625728 (Zenodo record dated 2022-07-27;
  resolved 2026-07-13). Concept DOI is 10.5281/zenodo.3233853.
- kernighanPike1984 -- Kernighan & Pike, "The Unix Programming
  Environment," Prentice-Hall 1984, ISBN 9780139376818 (publisher
  / catalog records, 2026-07-13).

shotts2024 (already recorded above) unchanged.
