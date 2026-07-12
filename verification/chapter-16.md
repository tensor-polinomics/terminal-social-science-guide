# Source-verification log: Chapter 16 (Modern CLI Kit and TUIs)

Per PLAN.md Section 10. This chapter is a curated survey of a
separately-installed tool kit, so, like the AI-CLI chapter, it is
**version-stamped**: every tool carries a "current as of
2026-07-06" note pinned to its project repository. The version
anchor is `transcripts/ch16-versions-mac.txt` (from
`transcripts/capture-ch16-mac.sh`, run on the user's Mac
2026-07-06), which records `bat` 0.26.1, `delta` 0.19.2,
`zoxide` 0.9.9, `fzf` 0.70.0, `lazygit` 0.62.2, `btop` 1.4.7,
`ncdu` 2.9.2, and `fd` 10.4.2. `eza`'s `--version` prints a
description line first, so the `head -1` probe in the versions
file captured that line rather than the number; `eza` 0.23.4 is
stamped instead in the header of `ch16-eza-mac.txt` (from `eza
--version | sed -n 2p`). `ripgrep` 13.0.0 and `fd` 10.4.2 were
already stamped in Chapter 9.

The whole kit is blocked in this book's Linux workspace sandbox
(GitHub-release / cargo / Homebrew binaries; only `ripgrep` and
`du` are preinstalled, both already taught), so every shown
command block is a **real Mac capture**, run with color and icons
OFF because those are ANSI/Unicode the print PDF drops. The three
pure TUIs (`lazygit`, `btop`, `ncdu`) are version-stamped but not
run: a full-screen program owns the terminal and cannot be
captured in a transcript (the Chapter 10 / 16 lesson). Access date
for all web sources: 2026-07-06.

### Shown blocks: all real Mac captures, byte-checked
- chapter/section: Ch 16, all six sections
- source: real Mac captures, no external claim
- accessed: 2026-07-06
- verifies: the five shown fenced `bash` blocks (eza, bat,
  zoxide, fzf, git diff) map to transcripts and were byte-checked
  with `cat -A`:
  - `eza -l --git scripts` -> `ch16-eza-mac.txt` (the `--tree`
    block in that transcript is Unicode box-glyphs and is
    deliberately NOT shown, only described; the ASCII-safe
    `-l --git` block with the real `-M` git-status marker on the
    edited `02_portfolio.py` is the shown one).
  - `bat --style=numbers --decorations=always --color=never
    --paging=never --line-range=1:16 scripts/00_make_data.py`
    -> `ch16-bat-mac.txt`. `--decorations=always` is forced
    because bat auto-plains (acts like `cat`) when its stdout is
    not a terminal, e.g. redirected to the capture file; that
    fallback is itself a taught point.
  - `zoxide query` (throwaway `_ZO_DATA_DIR` db) + `fzf --filter`
    -> `ch16-nav-mac.txt`.
  - `git diff scripts/02_portfolio.py` -> `ch16-diff-mac.txt`
    (the portable baseline the `delta` section describes; the
    same decile->quintile edit as Chapter 17's review demo).
- note (byte-identity, disclosed): editors strip trailing
  whitespace, so three whitespace-only lines cannot be reproduced
  in the `.qmd` and match the transcript only under
  trailing-whitespace normalization: the bat blank-line gutters
  (source lines 3, 9, 15 print as `   N ` with a trailing space
  in the transcript, `   N` in the chapter) and the two blank
  diff context lines (a single space in the transcript, empty in
  the chapter). Every non-whitespace character is identical. This
  is an unavoidable editor artifact, not an invented edit.
- version note: n/a (real capture)
- confirmable: yes (transcripts under `transcripts/`)

### eza (0.23.4): ls upgrade, git-status column, --tree
- chapter/section: Ch 16, "eza: `ls` with a git column"
- source: eza project repo (https://github.com/eza-community/eza)
- accessed: 2026-07-06
- verifies: eza is a maintained `ls` replacement; `-l` long
  listing with human sizes by default; `--git` adds a per-file
  git-status column (two chars, staged/unstaged); `--tree` draws
  a directory tree (Unicode branch glyphs); optional Nerd-Font
  icons. The `--version` banner names the repo.
- version note: current as of 2026-07-06, eza v0.23.4.
- confirmable: yes (repo + captured `--version`)

### bat (0.26.1): cat upgrade, numbers, syntax, tty-awareness
- chapter/section: Ch 16, "bat: `cat` that shows structure"
- source: bat project repo (https://github.com/sharkdp/bat)
- accessed: 2026-07-06
- verifies: bat is a `cat` clone with a line-number gutter,
  syntax highlighting, and a git change gutter; it auto-switches
  to plain `cat`-like output when stdout is not a terminal (so
  `bat file | cmd` behaves like `cat`), which is why the capture
  forces `--decorations=always`.
- version note: current as of 2026-07-06, bat 0.26.1.
- confirmable: yes (repo + captured demo)

### zoxide (0.9.9) and fzf (0.70.0): cd augment, fuzzy finder
- chapter/section: Ch 16, "zoxide and fzf: getting there faster"
- source: zoxide repo (https://github.com/ajeetdsouza/zoxide);
  fzf repo (https://github.com/junegunn/fzf)
- accessed: 2026-07-06
- verifies: zoxide is a "smarter cd" that ranks visited
  directories; the `z` command is installed by a shell init hook
  (`eval "$(zoxide init <shell>)"`), while `zoxide query` is the
  underlying lookup; it only knows directories already visited.
  fzf is a general fuzzy finder over stdin; its interactive UI is
  the default, and `--filter <query>` (`-f`) runs it
  non-interactively; its `Ctrl-R`/`Ctrl-T` key bindings are
  shell-integration set up in startup files (Chapter 18).
- version note: current as of 2026-07-06, zoxide 0.9.9, fzf
  0.70.0.
- confirmable: yes (repos + captured demos)

### delta (0.19.2): a syntax-highlighting pager for git diffs
- chapter/section: Ch 16, "delta: readable diffs"
- source: delta project repo (https://github.com/dandavison/delta)
- accessed: 2026-07-06
- verifies: delta is a pager for `git diff`/`diff` output (you
  point git's pager at it via git config); it adds syntax
  highlighting, line numbers, and optional side-by-side layout.
  It does not change the diff content, only its rendering, which
  is why the chapter shows the plain `git diff` it consumes and
  describes the coloring (inherently ANSI, dropped by print).
- version note: current as of 2026-07-06, delta 0.19.2.
- confirmable: yes (repo + captured plain `git diff`)

### TUIs: lazygit (0.62.2), btop (1.4.7), ncdu (2.9.2)
- chapter/section: Ch 16, "The TUIs: lazygit, btop, and ncdu"
- source: lazygit repo (https://github.com/jesseduffield/lazygit);
  btop repo (https://github.com/aristocratos/btop); ncdu homepage
  (https://dev.yorhel.nl/ncdu)
- accessed: 2026-07-06
- verifies: lazygit is a full-screen TUI front end for git; btop
  is a resource monitor (CPU/memory/network/process), a
  friendlier `top`; ncdu (NCurses Disk Usage) is the interactive,
  navigable `du` that Chapter 14 explicitly routed here. All
  three are full-screen TUIs that own the terminal and cannot be
  scripted, so only their `--version` is captured
  (`ch16-versions-mac.txt`); the walkthroughs are prose.
- version note: current as of 2026-07-06; lazygit 0.62.2, btop
  1.4.7, ncdu 2.9.2.
- confirmable: yes (repos/homepage + captured `--version`)

### DIVERGENCE: install story + the Debian/Ubuntu binary renames
- chapter/section: Ch 16, "The portability tax"; DIVERGENCE
- source: fd README (https://github.com/sharkdp/fd) and the
  Debian `fd-find` file list
  (https://packages.debian.org/bookworm/amd64/fd-find/filelist);
  bat README (https://github.com/sharkdp/bat) and the Debian
  `bat` file lists that ship `/usr/bin/batcat`
  (https://packages.debian.org/bookworm/amd64/bat/filelist,
  https://packages.debian.org/trixie/amd64/bat/filelist,
  https://packages.debian.org/sid/amd64/bat/filelist)
- accessed: 2026-07-06
- verifies: on Debian/Ubuntu `apt` renames these binaries to
  avoid clashes with packages that already own the short name.
  `fd` installs from package `fd-find` as `fdfind` (the name `fd`
  belongs to `fdclone`); the fd README recommends symlinking
  `fdfind` to `~/.local/bin/fd`. `bat` installs as `batcat`: the
  Debian file lists for bookworm, trixie, and sid all ship
  `/usr/bin/batcat`, i.e. current Debian still uses `batcat`, it
  was NOT moved back. The chapter therefore claims NO reversion;
  it says the exact name depends on the distribution and release
  and that you confirm it with `command -v`. The mechanism (a
  name clash, not a broken flag) and the `command -v` check are
  the durable points.
- version note: current as of 2026-07-06. CORRECTION (Codex
  round-1 blocker): an earlier draft claimed Debian 12 / Ubuntu
  23.04 moved `bat` back to `bat`. That was WRONG, based on a web
  search summary rather than the package contents; Codex checked
  the authoritative Debian file lists (`/usr/bin/batcat` in
  bookworm/trixie/sid), so the reversion claim was removed and
  the callout reworded to the release-independent, always-true
  form ("check with `command -v`").
- confirmable: yes (fd/bat READMEs + Debian package file lists)

### Internal cross-references (not externally pinned)
- chapter/section: Ch 16 throughout
- source: this book, Ch 5 (`ls -l`, `cd`), Ch 7 (`cat`), Ch 9
  (`fd`, `ripgrep`, already met), Ch 11 (fail-loudly scripting),
  Ch 12 (the Makefile / `make check`), Ch 14 (the bare server,
  `ncdu`
  routed here, `du`), Ch 2 (`command -v`); forward to Ch 18
  (startup files, aliases, the zoxide/fzf shell hooks)
- accessed: n/a
- verifies: the chapter frames each tool as an upgrade to a
  command already taught and does NOT re-teach `ls`/`cd`/`cat`/
  `fd`/`ripgrep`/`du` or install/PATH; it delivers Ch 14's ncdu
  routing and Ch 17's opening line ("Chapter 16 added a kit of
  faster, friendlier commands to the shell"); alias/dotfile
  persistence is deferred to Ch 18 with forward "will" language.
- note: the kickoff premise that Chapter 9 forward-promised
  bat/eza/delta ("viewing, not finding, Chapter 16") is FALSE:
  a grep of `09-finding-things.qmd` finds no mention of bat, eza,
  delta, "Chapter 16", or "viewing". Chapter 16 therefore
  cross-refs Ch 9 only for `fd`/`ripgrep` ("already met"), and
  makes NO back-reference claiming Ch 9 pointed here.
- version note: n/a
- confirmable: yes (internal)

## Gate confirmations

- **Version anchor: DONE (2026-07-06).** `capture-ch16-mac.sh`
  run on the Mac; all nine tools installed and stamped in
  `ch16-versions-mac.txt`. The chapter states versions in prose
  and in the provenance note (Ch 12 / Ch 17 style); no
  `--version` command block is shown (the `btop --version` line
  carries raw ANSI, another reason not to show it).
- **Captures reconciled byte-for-byte (2026-07-06)** over two
  runs. Run 1 surfaced two issues, both fixed in the capture
  script and re-run: bat emitted no line numbers when piped
  (fixed with `--decorations=always`), and the zoxide query
  resolved to the project's real absolute path, which is deep and
  specific to the author's checkout, so a capture-time mask
  collapses it to a clean, representative
  `/Users/[account]/projects/asset-pricing`, the form a reader's
  own project would take. This is an editorial choice for a
  cleaner block, not a mask requirement: the repo-location string
  itself is not treated as secret and already appears in other
  committed capture-script headers and transcripts. eza `--tree`
  confirmed Unicode-glyph (not shown); eza `-l --git` ASCII-safe
  (shown).
- **Validator 0/0** in the sandbox (`python3` with PyYAML). The
  canonical `uv run python tools/validate_book.py book` is a Mac
  step at the gate.
- **Render check is a Mac step at the gate.** The ANSI/glyph risk
  is real here (Ch 6 box-glyph, Ch 8 duckbox lessons): confirm in
  the Mac HTML+PDF render that the eza `-l --git`, bat numbered,
  zoxide/fzf, diff, and the markdown comparison table all render
  without overflow or dropped glyphs, and note the page range.
