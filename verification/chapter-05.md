# Source-verification log: Chapter 5 (Organizing a project from the shell)

Per PLAN.md Section 10. Chapter 5 is executable and almost
entirely real sandbox output, so this log is light on external
pins (only the two scaffolding-tool versions) and heavy on
transcript provenance. One provenance class this chapter, plus a
single cross-referenced Mac transcript owned by Chapter 4:

- **Real, sandbox (Linux/GNU baseline):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, GNU coreutils 8.32, aarch64. The scaffold and
  pitfall demos run in throwaway `/tmp` scratch directories; the
  tour runs in a clean copy of the asset-pricing project's
  repo-relevant tree at `/tmp/ap` (scripts + data + output +
  the root files, with `.venv/`, the `renv/` library, caches,
  and render products excluded). Transcripts: `ch05-scaffold.txt`,
  `ch05-place-files.txt`, `ch05-tour.txt`, `ch05-brace-space.txt`,
  `ch05-scaffold-tools.txt`. Every shown `$` block was diffed
  byte-for-byte against its transcript.
- **No new Mac capture this chapter.** The one place the layout
  meets a platform divergence, case-insensitive filenames, was
  captured on the author's Mac for Chapter 4
  (`transcripts/ch04-case-mac.txt`, macOS 26.5.1) and is
  cross-referenced here, not re-shown. There is therefore no
  `capture-ch05-mac.sh`: nothing in this chapter behaves
  differently enough on macOS to earn one.

Masks: none this chapter. The scaffold, tour, and pitfall use
plain `ls`/`ls -R`/`find` and throwaway `/tmp` paths, so no owner
columns, homes, or hostnames appear. The tool versions are read
with `python3 -c "... __version__"` (not `--version`), so they
print only the bare version string, no install path and no
account name. There is therefore nothing to mask and no mask is
claimed (an earlier draft version-checked with `--version`, whose
`site-packages` path carried the account name; that approach was
dropped in favor of `__version__`, which sidesteps the path
entirely). Access date for the two external pins below:
2026-07-02.

Forward/'"will" references: Ch 11 is drafted and committed, so
its cross-references are present tense ("Chapter 11 makes that
literal", the `make` regeneration). Ch 12 (environments; uv/renv
locks), Ch 13 (SSH to a server), and the companion Git book's
layout / never-commit chapters are cited as scope pointers
("Chapter 12's subject", "after you have SSH'd ... Chapter 13"),
never as claims that a stub already teaches or verifies anything.

### mkdir -p with brace expansion (the one-line scaffold)
- chapter/section: "Scaffold the whole tree in one move"
- source: live sandbox capture `ch05-scaffold.txt`: `mkdir
  asset-pricing`, `cd` in, then `mkdir -p data/{raw,clean}
  scripts output/{figures,tables}` (`echo $?` -> 0), `ls -R`
  walking the built tree, and `echo` on the same brace pattern
  showing the five expanded paths. The one-liner uses three
  separate brace groups (not one nested path token) so each
  typed line stays within the ~64-char width rule; the nested
  form is named in prose as legal but is not the shown command.
  Operationalizes Ch 4's `mkdir -p` (which flagged this
  scaffolding use forward) and `ls -R`.
- accessed: 2026-07-02 (capture date)
- verifies: exactly what is shown; brace expansion happens in
  the shell before `mkdir` runs (demonstrated by the `echo`)
- confirmable: yes (transcript; byte-diffed)

### touch placeholders + ls -a (front-matter files)
- chapter/section: "Scaffold the whole tree in one move"
- source: live sandbox capture `ch05-place-files.txt` (first
  block): `touch README.md Makefile report.qmd pyproject.toml
  .gitignore` (wrapped with a real `\` continuation) and `ls -a`
  showing `.gitignore` visible only because of `-a`.
- accessed: 2026-07-02 (capture date)
- verifies: creating empty top-level files; the dotfile is
  hidden from plain `ls` (callback to Ch 4's `-a`)
- confirmable: yes (transcript)

### PITFALL: a space inside the braces
- chapter/section: "Scaffold the whole tree in one move"; PITFALL
- source: live sandbox capture `ch05-brace-space.txt`: `echo
  data/{raw, clean}` printing the pattern verbatim (expansion
  suppressed by the space), then `mkdir -p data/{raw, clean}`
  silently creating a `data/{raw,` directory and a top-level
  `clean}` (word-split into two arguments), confirmed by `ls`
  and `ls data`. Exit status is zero, so the failure is silent.
- accessed: 2026-07-02 (capture date)
- verifies: the real, reproducible consequence of a space inside
  a brace group; ties back to the same word-splitting named in
  the naming section
- confirmable: yes (transcript; byte-diffed)

### The project tour (a place for everything)
- chapter/section: "A place for everything: a tour of the project"
- source: live sandbox capture `ch05-tour.txt` on the clean
  `/tmp/ap` copy: `ls` (root), `ls -R data` (raw vs clean),
  `ls scripts` (numbered 00-04 + helpers), `ls -R output`
  (figures + tables). Names each home the running example uses;
  the figure `fig-ch05-layout` summarizes the raw -> scripts ->
  generated flow. **Human-review addition (2026-07-02):** an
  annotated layout tree opens the section as a labeled,
  non-runnable `text` map (per-home roles inline, no `$`
  prompts); the prose notes "walking it with the Chapter 4
  commands confirms it is really on disk," so the real `ls -R`
  output is the evidence and the tree is the schematic. The
  tree's names were checked line-for-line against `ch05-tour.txt`;
  the following naming paragraph was trimmed to complement the
  tree (the raw/clean/output split) rather than re-list every
  home.
- accessed: 2026-07-02 (capture date)
- verifies: the actual layout of `sandbox/asset-pricing/`, so
  the chapter delivers exactly the structure Ch 6 opens by
  assuming ("raw data here, scripts there, output in its own
  folder"); the annotated tree matches that real output
- confirmable: yes (transcript; the tour output and the annotated
  map match the committed sandbox project minus the
  git-ignored/cache paths)

### Directory hygiene + tracked-vs-regenerated (incl. the .gitkeep caveat)
- chapter/section: "Raw in, generated out"; "What Git tracks and
  what `make` rebuilds"; REPRODUCIBILITY; PITFALL
- source: the raw-vs-generated flow AND the "ignored dirs are
  recreated by the pipeline" claim are read directly from the
  committed `sandbox/asset-pricing/`: the scripts each create
  their own output directory before writing, verified in the code
  (`00_make_data.py:188` `RAW.mkdir(parents=True, exist_ok=True)`;
  `01_clean.py:60` `CLEAN.mkdir(...)`; `02_portfolio.py:65`
  `OUT.parent.mkdir(...)`; `03_figure.py:35` `FIG.mkdir(...)`;
  `04_regression.R:34` `dir.create("output/tables",
  recursive=TRUE)`), and the ignore is real (`.gitignore`
  `/sandbox/**/data/` + `/sandbox/**/output/`, so `data/raw`,
  `data/clean`, and `output` are fully untracked). **Codex round
  1 fix (blocker):** the earlier draft taught `.gitkeep` inside
  `data/raw`/`data/clean`/`output` to make empty dirs survive a
  commit, which is FALSE, those paths are git-ignored, so a
  `.gitkeep` under them is ignored too. The `.gitkeep` command
  block was removed; the section now teaches (a) the ignored dirs
  are not on a fresh clone and the scripts/`make` recreate them,
  and (b) `.gitkeep` is the technique for a genuinely
  *non-ignored* empty dir and explicitly does NOT keep an ignored
  one. **Codex re-review then caught a surviving instance:** the
  Try-it exercise 4 still told readers to add `.gitkeep` to the
  four ignored data/output dirs, re-enacting the corrected
  pattern; it was rewritten to "test the `.gitkeep` boundary" on
  a non-ignored `study/logs/` and to explain why `.gitkeep` does
  NOT go under the `.gitignore`d paths. REPRODUCIBILITY routes
  the "one command rebuilds
  everything" claim to Ch 11 (drafted); the never-commit rationale
  routes to the companion Git book.
- accessed: 2026-07-02 (source read of the sandbox scripts +
  `.gitignore`)
- verifies: the tracked-vs-ignored split, the pipeline's
  directory self-creation (code-verified), and the corrected
  `.gitkeep` caveat; no `.gitkeep` command block is shown
- confirmable: yes (the scripts' `mkdir`/`dir.create` calls and
  the `.gitignore` patterns are in the committed sandbox project)

### DIVERGENCE: case-insensitive names biting the layout (cross-ref Ch 4)
- chapter/section: "Names that survive the trip to the server";
  DIVERGENCE
- source: NOT re-captured. This is Chapter 4's case-sensitivity
  divergence (`ch04-case.txt` Linux side; `ch04-case-mac.txt`
  macOS APFS side) applied to directory names in a project that
  moves from a case-insensitive Mac to a case-sensitive Linux
  server. The chapter points at `transcripts/ch04-case-mac.txt`
  for the captured macOS behavior rather than duplicating it.
- accessed: 2026-07-02 (Ch 4 capture reused)
- verifies: the layout-level consequence (a wrong-case path that
  works on the Mac fails on the server); no new claim beyond
  what Ch 4 already captured on both platforms
- confirmable: yes (via the Ch 4 transcripts)

### copier / cookiecutter (version pins; not run)
- chapter/section: "Templating a stable layout"
- source: real install evidence in `ch05-scaffold-tools.txt`
  (`python3 -c` reading each package's `__version__`):
  cookiecutter 2.7.1, copier 9.16.0, both from PyPI in the
  sandbox. The chapter version-stamps them "as of 2026-07-02"
  and does NOT run a scaffold: a template is its own project
  (placeholder syntax, a config file, a token-named directory),
  and teaching that syntax is out of scope (the Ch 16
  version-stamp + document pattern). The one template-invocation
  block is a labeled `text` fence, "illustrative; not executed."
- external pins (access-dated 2026-07-02): cookiecutter and
  copier are pinned to their captured installed versions
  (transcript) and to their PyPI/project pages
  (cookiecutter.readthedocs.io; copier.readthedocs.io) for the
  "current release" claim; both are volatile and stamped.
- verifies: the tools exist, install from PyPI, and are at the
  stated versions; the illustrative invocation is marked
  non-runnable
- confirmable: yes for versions (captured); the invocation is
  deliberately not run and is labeled as such

### Internal cross-references (not externally pinned)
- chapter/section: Ch 5 throughout
- source: this book, Ch 4 (`mkdir -p`, `ls -R`, `ls -a`, `\`
  line continuation, case sensitivity), Ch 6 (opens on this
  chapter's layout), Ch 11 (one `make` regenerates
  `data/clean` + `output`), Ch 12 (uv/renv locks; environments),
  Ch 13 (SSH to a server). The companion Git book is
  cross-referenced for the canonical-layout rationale (its
  replication-package chapter) and for what must never be
  committed, not re-taught (PLAN Section 6).
- accessed: n/a
- verifies: the chapter delivers the layout Ch 1/2/4 promised
  and Ch 6 assumes, and sets up rather than steals Ch 6's
  danger, Ch 11's Make, and Ch 12's environment jobs
- confirmable: yes (internal)

## Gate confirmations

- **Validator: 0 errors / 0 warnings** in the sandbox (whole
  book, via a PyYAML-equipped `python3 tools/validate_book.py
  book`) AND under the canonical `uv run` on the Mac (confirmed
  2026-07-02). The two brace one-liners were rewritten from a
  single nested path token (which was intrinsically > 64 chars)
  into separate brace groups so every typed line satisfies the
  width rule with real, re-captured output.
- **Render: two issues found and fixed, then re-render PASSED.**
  (a) The §5.2 annotated tree used Unicode box glyphs that dropped
  out of the PDF (Codex, Ch 2 p.19); switched to ASCII connectors
  (`|--`/`` `-- ``/`|`). (b) The figure's HTML SVG was BROKEN:
  `dvisvgm --pdf` (the skill's `render.sh` path) emitted a 1-node
  SVG (only the first card, no text), so the HTML figure was
  near-empty (the PDF figure was fine, which is why the first
  117-page PDF render looked OK). The SVG is rebuilt
  font-independently (`gs -dNoOutputFonts` traces all text to
  paths, then `pdftocairo -svg`) and the figure now uses
  `\usepackage{lmodern}` so the `\ttfamily` labels outline
  cleanly; the rebuilt SVG (290 KB) was rasterized and eyeballed
  complete. **Codex re-rendered on the Mac (2026-07-02, Darwin,
  quarto 1.9.36): `quarto render book` passed, 118-page PDF; the
  ASCII trees render correctly (Ch 2 p.19, Ch 5 p.56) and Figure
  5.1 is clean (p.58).**
- **Figure:** one authored TikZ exhibit `fig-ch05-layout`
  (textbook-diagrams design system; raw -> scripts -> generated
  flow, tracked-root band). Built with `pdflatex`; PDF is the
  `lmodern` build (135 KB) and the web SVG is the
  `gs -dNoOutputFonts` + `pdftocairo -svg` outline (290 KB, text
  as paths, no font dependency), NOT the broken `dvisvgm --pdf`
  output. Source + PDF + SVG committed under
  `book/assets/figures/ch05/`; the `.tex` header records the
  build recipe. Rasterized and inspected complete before install,
  then confirmed in Codex's 118-page Mac render (Figure 5.1 clean
  on p.58). Per the durable figure rule now in `CLAUDE.md`, the
  SVG is eyeballed separately from the PDF.
- **Counts:** 6 numbered content sections (4 beginner, 2
  advanced) + unnumbered Try-it; callouts 1 REPRODUCIBILITY,
  2 PITFALL (space-in-braces; editing-raw-in-place / mixing
  generated into source), 1 DIVERGENCE (case-insensitive names,
  cross-ref Ch 4). No DANGER (nothing here destroys; not forced).
  0 em-dashes; all shown `$` blocks byte-diffed to a `ch05-*`
  transcript.
- **External pins:** only the two scaffolding-tool versions
  (cookiecutter 2.7.1, copier 9.16.0), captured from a real
  install and stamped 2026-07-02 (Codex confirmed both are the
  current PyPI releases). No dead-host/Internet-Archive fallback
  needed. Everything else is real sandbox output or an internal /
  Git-book cross-reference.
- **Codex blind audit round 1 (2026-07-02): 3 blockers + 1
  tighten, ALL FIXED (the `.gitkeep` fix took two passes: the
  section prose first, then the Try-it exercise on Codex
  re-review).** (1) the `.gitkeep`-in-ignored-dirs workflow was
  false in BOTH the section and Try-it exercise 4, both rewritten
  (see the hygiene entry above); (2) a stale mask claim (the
  chapter/verification said
  `ch05-scaffold-tools.txt` held a masked `/home/[account]` but
  the `__version__` capture shows no path), removed; (3) stale
  gate docs (render/validator) reconciled here and across
  CHANGELOG / RESUME / handover; (4, tighten) added the
  synthetic-data exception sentence in "Raw in, generated out"
  (`00_make_data.py` generates the synthetic raw stand-in; treat
  it as immutable from that seam on). What Codex passed:
  validator 0/0, render + figure, counts, block/transcript
  matches, the case-sensitivity reuse, and the version claims.
