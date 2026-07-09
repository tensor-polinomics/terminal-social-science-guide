# Source-verification log: Chapter 3 (Setup: the platform-specific zone)

Per PLAN.md Section 10. Chapter 3 is the platform-specific zone,
so its provenance is deliberately mixed and its quarantined
column is unusually large (justified below). Three provenance
classes:

- **Real, sandbox (Linux/GNU track):** Ubuntu 22.04.5 LTS,
  GNU bash 5.1.16, GNU coreutils 8.32, APT 2.4.14, dpkg 1.21.1,
  aarch64. Transcripts: `ch03-linux-id.txt`, `ch03-linux-pkg.txt`,
  `ch03-checksum-linux.txt`.
- **Real, user's Mac (macOS/BSD track), read-only:** produced by
  `transcripts/capture-ch03-mac.sh` (masks `$HOME` at capture;
  runs NO installer). Transcripts: `ch03-shell-mac.txt`,
  `ch03-brew-mac.txt`, `ch03-toolchain-mac.txt`. **RECONCILED
  (2026-07-01):** the user ran the script; the three `-mac.txt`
  files are its unedited output and every Mac block the chapter
  shows matches byte-for-byte (`echo $SHELL` -> `/bin/zsh`;
  `command -v brew` -> `/opt/homebrew/bin/brew`; `brew --prefix`
  -> `/opt/homebrew`; `printf 'hello\n' | shasum -a 256` ->
  the fixed SHA-256 of "hello\n"). Mac versions, now confirmed
  from the transcripts and stated in prose (not shown as
  `--version` blocks, Ch 17 precedent): macOS 26.5.1, zsh 5.9,
  `/bin/bash` 3.2.57(1)-release (arm64-apple-darwin25), Homebrew
  6.0.6, Apple git 2.53.0, Command Line Tools at
  `/Library/Developer/CommandLineTools`, tealdeer 1.8.1. Repo
  re-grepped for the personal home path after ingestion: clean
  (the script masks `$HOME`; its "captured ->" trailer prints to
  the terminal only, never into the transcripts).
- **Documented + quarantined (not run anywhere), version-stamped
  "current as of 2026-07-01" and pinned:** the WSL2 setup
  (`wsl --install`, `/mnt/c`), the `apt` install commands
  (sandbox has no root), the Homebrew install one-liner, and the
  PowerShell sidebar. Nothing here is executed; the chapter never
  runs an installer, on any machine, for the same reason Ch 7
  will not run `curl | sh`.

Access date for all web sources below: 2026-07-01.

Forward references: Ch 7, 12, 17 are drafted and cited in present
tense; Ch 5, 6, 11, 13, 14, 18 are stubs and every reference to
them is a scope statement ("Chapter 13's subject") or
forward-contract language ("will cover / will act on / will pin /
will make stick"), never a claim they already teach or verify
anything.

### Which shell you have: zsh (macOS) vs bash (Linux/WSL2); $ vs %
- chapter/section: "Which shell you have, and why it matters"
- source: live captures both sides: `ch03-shell-mac.txt`
  (`echo $SHELL` -> `/bin/zsh`) and `ch03-linux-id.txt`
  (`ps -p $$ -o comm=` -> `bash`; `bash --version` ->
  5.1.16). The zsh-default-on-macOS / bash-default-on-Linux fact
  is the platforms' documented defaults; the `$`/`%` prompt split
  was established in Ch 1/Ch 2.
- accessed: 2026-07-01 (capture date)
- verifies: exactly what is shown, plus the default-shell split
  the section states in prose
- version note: bash 5.1.16 (sandbox) captured; zsh 5.9 stated in
  prose (current as of 2026-07-01)
- confirmable: yes (transcripts both sides; Mac reconciled)

### macOS system /bin/bash is frozen at 3.2.57 (GPLv3 licensing)
- chapter/section: "Which shell you have"; DIVERGENCE (bash-3.2
  floor)
- source: live capture `ch03-shell-mac.txt` (`/bin/bash --version`
  -> `GNU bash, version 3.2.57...`); the reason (Apple does not
  ship GPLv3 bash) is the widely-documented explanation, stated in
  prose, not independently pinned; the *version* is capture-backed
- accessed: 2026-07-01 (capture date)
- verifies: the shown/cited version 3.2.57 on macOS vs bash 5.x on
  Linux (5.1.16 sandbox), and the practical consequence (bash-4+
  features fail on the Mac system bash). Chapter routes the
  scripting-target fix to Ch 11 (stub, "will").
- version note: current as of 2026-07-01; the licensing reason is
  the commonly-cited explanation, flagged as such, not a fresh pin
- confirmable: version yes (capture reconciled: 3.2.57 on macOS
  26.5.1, arm64-apple-darwin25); the
  GPLv3 rationale is stated as the usual explanation

### APT / dpkg are the Debian/Ubuntu package managers; sudo apt install
- chapter/section: "Package managers: how you install things";
  DIVERGENCE (package managers)
- source: live captures `ch03-linux-pkg.txt` (`apt --version` ->
  2.4.14; `dpkg --version` -> 1.21.1; `command -v apt-get git`);
  the install recipe from Ubuntu Server documentation, "Install
  and manage packages"
  (https://ubuntu.com/server/docs/how-to/software/package-management/):
  `sudo apt update`, then `sudo apt install <pkg>`; and the note
  that `apt` is for interactive use while `apt-get` is the stable
  scripting interface
- accessed: 2026-07-01 (page fetched and read; captures same day)
- verifies: APT/dpkg presence and versions (shown), the
  `sudo apt update && sudo apt install` recipe (quarantined,
  pinned), the apt-vs-apt-get scripting note routed to Ch 11, and
  `dnf`/`pacman` named (not taught) for other families
- version note: current as of 2026-07-01; apt 2.4.14 / dpkg
  1.21.1 captured
- confirmable: yes (captures + Ubuntu docs)

### Homebrew: prefix /opt/homebrew on Apple Silicon; brew shellenv fronts PATH
- chapter/section: "Package managers"; "The Apple Silicon PATH
  note"
- source: Homebrew documentation, "Installation"
  (https://docs.brew.sh/Installation): default prefix
  `/opt/homebrew` for Apple Silicon (`/usr/local` Intel,
  `/home/linuxbrew/.linuxbrew` Linux/WSL), and the post-install
  step to add `eval "$(<prefix>/bin/brew shellenv)"` to the shell
  config; live capture `ch03-brew-mac.txt`
  (`command -v brew` -> `/opt/homebrew/bin/brew`; `brew --prefix`
  -> `/opt/homebrew`; `brew shellenv`)
- accessed: 2026-07-01 (page fetched and read; capture same day)
- verifies: the prefix (shown + doc), the Homebrew-on-Linux prefix
  the DIVERGENCE mentions, and the `brew shellenv` PATH-fronting
  line; persistence routed to Ch 18 (stub, "will")
- version note: current as of 2026-07-01; the `eval "$(brew
  shellenv)"` line is presented as Homebrew's documented
  post-install step, not as captured output. **Accuracy fix on
  reconcile:** the captured `brew shellenv` on Homebrew 6.0.6
  (`ch03-brew-mac.txt`) does NOT literally prepend
  `/opt/homebrew/bin`; it exports the HOMEBREW_* vars and
  delegates PATH ordering to macOS `path_helper`
  (`PATH_HELPER_ROOT="/opt/homebrew" /usr/libexec/path_helper`).
  The observable RESULT is still `/opt/homebrew/bin` at the front
  of the login PATH (Ch 2's captured PATH began exactly
  `/opt/homebrew/bin:/opt/homebrew/sbin`). So the chapter's §5
  claim was softened from "prepends /opt/homebrew/bin and sbin"
  to the observed result, citing Ch 2's real capture, to avoid
  over-specifying a version-specific mechanism. The shellenv
  output is NOT shown in the chapter (the path_helper line is a
  Ch 18 rabbit hole).
- confirmable: yes (doc + capture reconciled 2026-07-01)

### tealdeer/tldr install recipe (delivers Ch 2's deferred install)
- chapter/section: "Package managers" (the tldr promise)
- source: install recipes `brew install tealdeer` (macOS) and
  `sudo apt install tldr` (Debian/Ubuntu), shown illustrative (not
  run); the installed client version is `ch03-toolchain-mac.txt`
  (`tldr --version` -> tealdeer 1.8.1), consistent with Ch 2's
  `ch02-help-mac.txt`
- accessed: 2026-07-01 (capture date)
- verifies: that Ch 2's "separate install (Chapter 3 will handle
  it)" is now handled, with the client version-stamped
- version note: tealdeer 1.8.1, current as of 2026-07-01
- confirmable: yes (recipes are standard package-manager form;
  end-state version capture-backed, reconciled: tealdeer 1.8.1)

### Checksum tools: GNU sha256sum (Linux) vs shasum -a 256 (macOS); same digest
- chapter/section: "Installing safely"; DIVERGENCE (checksum
  tools)
- source: live captures both sides for the identical input
  `printf 'hello\n'`: `ch03-checksum-linux.txt`
  (`sha256sum` -> 5891b5b5...be03, GNU coreutils 8.32) and
  `ch03-toolchain-mac.txt` (`shasum -a 256` -> the same digest).
  macOS ships `shasum` (a Perl tool) and not GNU `sha256sum` by
  default
- accessed: 2026-07-01 (capture date)
- verifies: the same-content-same-digest claim (both digests shown
  identical) and the tool-name divergence; the tie to Ch 12's
  `make check` hashing (Ch 12 drafted)
- version note: GNU coreutils 8.32 captured; shasum is macOS base
- confirmable: yes (both captures; Mac reconciled)

### Homebrew official installer is a curl-into-bash one-liner
- chapter/section: "Installing safely"; DANGER
- source: Homebrew homepage (https://brew.sh/), "Install
  Homebrew": the one-liner
  `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`;
  the docs note the installer "explains what it will do and then
  pauses before it does it" and requires `/bin/bash` (not zsh).
  Chapter shows it wrapped with shell `\` continuations to fit
  the page (reassembles to the single published line), labeled
  NOT run
- accessed: 2026-07-01 (page fetched and read)
- verifies: the exact one-liner, that it pipes a fetched script
  into bash (the Ch 7 pattern), and the mitigations that make it a
  defensible exception (official HTTPS source; a careful,
  pausing, confirmation-first script). Does NOT contradict Ch 7:
  the verify-first workflow (fetch, read, checksum, run) is taught
  as the safe general habit; Ch 7 owns the mechanics, Ch 17 the
  agent angle
- version note: current as of 2026-07-01 (the install URL and
  installer behavior are version-volatile)
- confirmable: yes (homepage + docs.brew.sh)

### WSL2: wsl --install (admin PowerShell); Ubuntu default; run from Windows Terminal
- chapter/section: "Opening a terminal"; "/mnt/c and the WSL2
  boundary"
- source: Microsoft Learn, "How to install Linux on Windows with
  WSL" (https://learn.microsoft.com/en-us/windows/wsl/install):
  `wsl --install` run in an Administrator PowerShell installs WSL
  and the Ubuntu distribution by default, WSL 2 is the default
  version, and distributions run from Windows Terminal or the
  Start menu
- accessed: 2026-07-01 (page fetched and read)
- verifies: the quarantined `wsl --install` block, "installs
  Ubuntu by default," and the "open the Ubuntu shell, not
  PowerShell" guidance. Documented, NOT run (no Windows machine)
- version note: current as of 2026-07-01
- confirmable: yes (doc)

### WSL2 /mnt/c: Windows C: mounted in one Unix tree; keep projects in the Linux fs
- chapter/section: "/mnt/c and the WSL2 boundary"; delivers Ch 2's
  "Chapter 3 will return to what /mnt/c means in practice"
- source: Microsoft Learn, "Working across Windows and Linux file
  systems"
  (https://learn.microsoft.com/en-us/windows/wsl/filesystems):
  the Windows `C:` drive appears at `/mnt/c`, and storing project
  files on the Linux filesystem is faster when working with Linux
  tools (same page pinned in Ch 2 for the /mnt/c mount fact)
- accessed: 2026-07-01
- verifies: the /mnt/c mount, the keep-your-project-in-`~`
  guidance, and the performance rationale; the CRLF line-ending
  hazard is routed to Ch 11 (stub, "will")
- version note: current as of 2026-07-01
- confirmable: yes (doc)

### PowerShell sidebar (the four PLAN Section 5 points)
- chapter/section: "The PowerShell sidebar"
- source, by point:
  - Objects not text: Microsoft Learn `about_Pipelines`
    (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines):
    "the objects that Command-1 emits are sent to Command-2";
    `Get-Process | Stop-Process` passes a process object
  - Fake-alias trap: Microsoft Learn `about_Aliases`
    (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_aliases):
    built-in aliases include `ls` (Get-ChildItem) and, e.g., `ac`
    (Add-Content); `cat` -> Get-Content is a built-in alias. The
    `curl`/`wget` -> `Invoke-WebRequest` aliases were in Windows
    PowerShell 5.1 and were REMOVED in PowerShell 7. Hard pin for
    the 5.1 aliasing: Microsoft Learn, `Invoke-WebRequest`
    (Windows PowerShell 5.1)
    (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-5.1),
    whose Notes state "Windows PowerShell includes the following
    aliases for Invoke-WebRequest: iwr, curl, wget" (fetched
    2026-07-01). Removal pin: the 7.6 `about_Aliases` built-in
    list no longer includes `curl`/`wget`
  - Execution policy: Microsoft Learn `about_Execution_Policies`
    (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies):
    default on Windows clients is `RemoteSigned`, which blocks
    unsigned scripts downloaded from the internet
  - Path separators: Windows `\` and `;` vs Unix `/` and `:`
    (general, long-stable platform fact)
- accessed: 2026-07-01 (all three PowerShell pages fetched)
- verifies: all four sidebar points; framed awareness-only, WSL2
  recommended (PLAN Section 5)
- version note: current as of 2026-07-01; the curl/wget alias
  point is explicitly version-stamped (5.1 had them, 7 removed
  them), because it is the most volatile claim in the sidebar
- confirmable: yes (three Microsoft Learn pages)

### Internal cross-references (not externally pinned)
- chapter/section: Ch 3 throughout
- source: this book, Ch 1 ($/% prompt, quarantine promise),
  Ch 2 (terminal vs shell, PATH first-match-wins, /mnt/c, tldr
  deferral), Ch 7 (curl|sh, checksums, PATH-hijack), Ch 12
  (`make check` hashing), Ch 17 (an agent can run the installer
  line); forward to Ch 11 (scripting target, locale/CRLF), Ch 13
  (uv/renv operational), Ch 14 (SSH), Ch 18 (PATH persistence)
- accessed: n/a
- verifies: the chapter delivers Ch 1/2/6's stated Ch-3
  commitments and does not re-teach the cross-referenced material
- version note: n/a
- confirmable: yes (internal)

## Gate confirmations

- **Validator: 0 errors / 0 warnings** in the sandbox (whole
  book and on `book/chapters/03-setup.qmd` alone, via a
  PyYAML-equipped `python3 tools/validate_book.py book`) AND in
  the canonical `uv run python tools/validate_book.py book` on
  the Mac (Codex, 2026-07-01). **Render: DONE** - Codex ran
  `quarto render book` (success, 94-page PDF) and inspected the
  PDF pages with the quarantined `text` blocks, the wrapped
  Homebrew one-liner, the `apt` / verify-first / checksum blocks,
  and the PowerShell sidebar: no overflow.
- **Mac captures RECONCILED (2026-07-01).** The user ran
  `transcripts/capture-ch03-mac.sh` (read-only, masks `$HOME`,
  ran no installer); the three `ch03-*-mac.txt` files are its
  unedited output. All four shown Mac blocks match byte-for-byte
  and every prose version resolved (macOS 26.5.1, zsh 5.9,
  `/bin/bash` 3.2.57, Homebrew 6.0.6, git 2.53.0, tealdeer 1.8.1).
  Repo re-grepped for the personal home path: clean. One accuracy
  fix landed on reconcile: §5's `brew shellenv` description was
  softened to the observed front-of-PATH result (Homebrew 6.0.6
  routes PATH through `path_helper`, not a literal prepend); see
  the Homebrew entry above. Validator re-run after the edit: 0/0
  (sandbox and canonical Mac `uv run`); `quarto render` passed on
  the Mac (Codex). Remaining before commit: a final human read.
- **Counts:** 7 numbered content sections (5 beginner, 2
  advanced) + unnumbered Try-it; callouts 3 DIVERGENCE, 1 DANGER,
  1 PITFALL (no RECOVERY/REPRODUCIBILITY, not forced). 0
  em-dashes; all 9 shown `$` command lines map to a `ch03-*`
  transcript.
- **Doc fetches: DONE (2026-07-01).** docs.brew.sh/Installation,
  brew.sh, learn.microsoft.com wsl/install, wsl/filesystems (from
  Ch 2), and the three PowerShell `about_*` pages, plus Ubuntu
  Server package-management, all fetched clean. No dead-host /
  Internet-Archive fallback needed.
