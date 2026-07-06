# Source-verification log: Chapter 2 (The mental model)

Per PLAN.md Section 10. Chapter 2 is the book's first real
technical chapter: every shown `$` block maps to a captured
transcript. Sandbox captures (Ubuntu 22.04.5, GNU bash 5.1.16,
GNU coreutils 8.32, aarch64): `ch02-process.txt`,
`ch02-filesystem.txt`, `ch02-env.txt`, `ch02-path.txt`,
`ch02-builtin.txt`, `ch02-which.txt`, `ch02-exit-codes.txt`,
`ch02-streams.txt`, `ch02-help.txt`. Mac captures (macOS
26.5.1, zsh 5.9, Apple Silicon; produced by
`capture-ch02-mac.sh`, run by the user 2026-07-01):
`ch02-divergence-mac.txt`, `ch02-filesystem-mac.txt`,
`ch02-help-mac.txt`. The exit-code and streams demos ran
inside `sandbox/asset-pricing/`; the filesystem demo ran in a
`/tmp` scratch directory. The chapter's one figure
(`book/assets/figures/ch02/fig-ch02-layers.{tex,pdf,svg}`) is
an authored diagram, not captured output; its source is
archived beside it.

Human-review addition (2026-07-02): the filesystem-root section
now pairs the real `ls /` capture with an annotated `/` tree (a
labeled, non-runnable `text` block giving the role of the common
system directories home/usr/etc/var/tmp/opt, no `$` prompts).
This is the annotated-structure-tree house device codified in
`CLAUDE.md` (introduced in Ch 5). The tree is a schematic, not
output; the real `ls /` block is unchanged and still matches
`ch02-filesystem-mac.txt`. Validator 0/0. **The first version
used Unicode box-drawing glyphs, which Codex's PDF render showed
dropping out on p.19; the tree was switched to ASCII connectors
(`|--`, `` `-- ``, `|`), which are font-independent.** This is a
post-gate edit to a committed chapter. Codex's Mac re-render
(2026-07-02, quarto 1.9.36, 118-page PDF) confirms the ASCII
tree renders correctly on Ch 2 PDF p.19; a commit is the only
step left.

Forward references: Ch 6, 11, 16 are drafted. Since Ch 2 was
committed, Ch 3 and Ch 4 have also been drafted and committed
and Ch 5 is drafted (in the G3 gate); Ch 9, 10, 12, 13, 14, 17
remain stubs. Ch 2's PROSE still uses forward-contract wording
for the chapters that were stubs when it was written ("will be
taught / will pin / will handle / will return"); the notes below
now flag which of those targets have since been drafted. All of
Ch 2's forward targets (Ch 3-13) are now committed and Ch 14 is
drafted, so its "will" pointers are reading-order narrative for a
reader at Ch 2, not claims the targets are unwritten; the Ch 1
present-tense re-finalize was completed with the Ch 14 closeout
(Part III complete at G5).
Either way, no Ch 2 reference claims a later chapter already
teaches, runs, or verifies anything.

Access date for all web sources below: 2026-07-01.

### Shell command search: PATH walked left to right, first match runs
- chapter/section: "How the shell finds a command: `PATH`";
  also "Why `cd` is not a program" (`type -a` order)
- source: Bash Reference Manual, section 3.7.2 "Command Search
  and Execution"
  (https://www.gnu.org/software/bash/manual/html_node/Command-Search-and-Execution.html);
  demonstrated live in `ch02-path.txt` (`echo $PATH`,
  `command -v python3`, `type -a sort`)
- accessed: 2026-07-01
- verifies: the shell searches the colon-separated PATH
  directories in order and executes the first match; builtins
  are checked before the PATH search
- version note: stable bash semantics (bash 5.1 captured)
- confirmable: yes (doc + transcript)

### `/usr/bin` and `/bin` hold the same files on the sandbox's Ubuntu
- chapter/section: "How the shell finds a command" (why
  `type -a sort` lists two entries)
- source: verified live in the sandbox: `readlink /bin` ->
  `usr/bin` (merged-/usr layout, Ubuntu 22.04); the chapter
  says "Ubuntu makes them point at the same files," which is
  this symlink
- accessed: 2026-07-01 (sandbox check)
- verifies: the duplicate `type -a sort` entries are one file
  reachable by two PATH directories, not two programs
- version note: merged-/usr is standard on Ubuntu since 20.04
- confirmable: yes (live check; not quoted in the chapter)

### `cd` and `export` must be builtins; `type`/`command -v` classify names
- chapter/section: "Why `cd` is not a program"
- source: Bash Reference Manual, "Bourne Shell Builtins"
  (https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html)
  and section 3.7.3 (command execution environment: children
  cannot alter the parent); demonstrated in `ch02-builtin.txt`
  (`type cd`, `type ls`, `type -a echo`)
- accessed: 2026-07-01
- verifies: cd is a builtin, ls external, echo both (builtin
  wins); the parent/child reasoning for why state-changing
  commands are builtins
- version note: stable
- confirmable: yes (doc + transcript)

### Environment inheritance: children get a copy; export required
- chapter/section: "The environment: what a process inherits"
  + PITFALL
- source: Bash Reference Manual, section 3.7.4 "Environment"
  (https://www.gnu.org/software/bash/manual/html_node/Environment.html);
  demonstrated in `ch02-env.txt` (unexported DATASET invisible
  to `bash -c` child; visible after `export`)
- accessed: 2026-07-01
- verifies: assignment alone does not place a variable in the
  environment; export does; children receive a copy at start,
  and changes never propagate back to the parent
- version note: stable
- confirmable: yes (doc + transcript)

### Exit status: $? holds the last command's status; 0 = success
- chapter/section: "Exit codes: how a command reports back" +
  PITFALL
- source: Bash Reference Manual, section 3.7.5 "Exit Status"
  (https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html);
  demonstrated in `ch02-exit-codes.txt` (0, then 2, then the
  consumed-status 0)
- accessed: 2026-07-01
- verifies: the zero/nonzero convention and that $? reports
  only the most recent command, so an intervening command
  overwrites it
- version note: stable
- confirmable: yes (doc + transcript)

### GNU ls exit status 2 = "serious trouble"
- chapter/section: "Exit codes" (reading the 2 from the failed
  `ls nope_dir`)
- source: GNU coreutils manual, "ls invocation", Exit status
  (https://www.gnu.org/software/coreutils/manual/html_node/ls-invocation.html):
  0 success, 1 minor problems, 2 serious trouble; captured
  exit 2 in `ch02-exit-codes.txt`
- accessed: 2026-07-01
- verifies: the specific meaning the chapter gives to ls's 2
  (and 1 as minor trouble), plus the caveat that codes beyond
  zero/nonzero are tool-specific
- version note: GNU coreutils 8.32 captured; doc current
- confirmable: yes (doc + transcript)

### The three standard streams are attached to every process
- chapter/section: "Three streams, in the abstract"
- source: POSIX.1-2017 (Single UNIX Specification), Base
  Definitions section 3 (stdin/stdout/stderr definitions) via
  https://pubs.opengroup.org/onlinepubs/9699919799/ ; the
  split demonstrated live in `ch02-streams.txt` (`wc -l` on
  one existing and one missing file, count to stdout,
  complaint to stderr)
- accessed: 2026-07-01
- verifies: the three channels exist per process, results and
  diagnostics are separate streams; mechanics of redirection
  deferred to Ch 6 (drafted)
- version note: stable (POSIX)
- confirmable: yes (doc + transcript)

### Homebrew's default prefix on Apple Silicon is /opt/homebrew, put early on PATH
- chapter/section: PATH DIVERGENCE callout
- source: Homebrew documentation, "Installation"
  (https://docs.brew.sh/Installation): the installer's default
  prefix is /opt/homebrew for Apple Silicon and /usr/local for
  Intel Macs; the post-install step adds `brew shellenv` to
  the shell startup, which is what fronts the PATH. Live
  evidence: the user's login PATH in
  `ch02-divergence-mac.txt` begins
  /opt/homebrew/bin:/opt/homebrew/sbin
- accessed: 2026-07-01 (page fetched and read)
- verifies: the prefix claim, the Intel contrast, and the
  front-of-PATH placement the callout describes
- version note: current as of 2026-07-01
- confirmable: yes (doc + transcript)

### which is a zsh builtin; on Linux it is an external program
- chapter/section: PATH DIVERGENCE callout
- source: zsh documentation, "Shell Builtin Commands"
  (https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html),
  which lists `which` (equivalent to `whence -c`); live
  evidence both sides: `ch02-divergence-mac.txt`
  (`zsh -c 'type -a which'` -> "which is a shell builtin")
  and `ch02-which.txt` (bash/Linux: /usr/bin/which external).
  `command -v` as the portable form: POSIX.1-2017 `command`
  utility
  (https://pubs.opengroup.org/onlinepubs/9699919799/utilities/command.html)
- accessed: 2026-07-01
- verifies: the callout's cross-platform which split and the
  command -v recommendation
- version note: zsh 5.9 captured; stable
- confirmable: yes (doc + transcripts)

### BSD (macOS) tools mostly do not implement --help
- chapter/section: help-section DIVERGENCE callout
- source: live capture, `ch02-divergence-mac.txt`
  (`/bin/ls --help` -> "unrecognized option" + usage, exit 1)
  on macOS 26.5.1. The chapter's claim is hedged ("mostly do
  not implement it") and is presented through this one real
  example rather than as a catalog; the GNU side (`ls --help`
  works) is `ch02-help.txt`
- accessed: 2026-07-01 (capture date)
- verifies: exactly what is shown: BSD ls rejects --help with
  exit 1 while GNU ls answers it; the general tendency is
  stated as a tendency, not a law
- version note: macOS 26.5.1 capture
- confirmable: yes (transcripts both sides)

### Minimized images can ship man without most man pages
- chapter/section: help section ("No manual entry for grep")
- source: live capture in the book's own sandbox,
  `ch02-help.txt` (`man grep` -> "No manual entry for grep"
  on Ubuntu 22.04 minimized image, which retains a real man
  binary and some pages, e.g. tar). The chapter states the
  fact for THIS image and hedges the generalization ("as
  slimmed-down server and container images often do")
- accessed: 2026-07-01 (capture date)
- verifies: the shown behavior; the generalization is
  deliberately soft and carries no external pin
- version note: n/a (self-captured)
- confirmable: yes (transcript)

### tldr is a community-maintained example collection; client tealdeer 1.8.1
- chapter/section: help section (third level of the ladder)
- source: tldr-pages project homepage (https://tldr.sh/),
  fetched 2026-07-01: "Simplified and community-driven man
  pages," MIT-licensed, community-edited pages; client and
  version from the user's Mac capture, `ch02-help-mac.txt`
  (`tldr --version` -> tealdeer 1.8.1; `tldr tar | head -14`)
- accessed: 2026-07-01
- verifies: the "community-maintained" description, the
  separate-install status, and the real shown output;
  version-stamped "current as of 2026-07-01" in the chapter
- version note: tealdeer 1.8.1, current as of 2026-07-01;
  install routing to Ch 3 is forward-contract (Ch 3 is now
  drafted + committed; Ch 2's prose keeps the "will install"
  wording pending the tracked forward-language pass)
- confirmable: yes (page + transcript)

### WSL2 mounts the Windows C: drive at /mnt/c (one Unix tree)
- chapter/section: "One tree of files" (the parenthetical on
  Windows drive letters; added at the post-gate human-review
  polish, 2026-07-01)
- source: Microsoft Learn, "Working across Windows and Linux
  file systems"
  (https://learn.microsoft.com/en-us/windows/wsl/filesystems):
  "the Windows file system C:\ drive ... will look like this
  when mounted in a WSL command line: /mnt/c/..."
- accessed: 2026-07-01 (page fetched and read)
- verifies: inside WSL2 the reader works in a single Unix tree
  with the Windows drive mounted at /mnt/c; drive letters are
  Windows-proper, not the book's platform
- version note: current as of 2026-07-01; details routed
  forward to Ch 3 (now drafted + committed; Ch 2's prose keeps
  the "will return" wording pending the forward-language pass)
- confirmable: yes

### man page section numbers; man is the per-system authority
- chapter/section: help section (the "(1)" note; BSD vs GNU
  documentation split)
- source: the captured BSD man page header itself
  (`ch02-help-mac.txt`: "LS(1) General Commands Manual") and
  the man-db/man-pages convention documented in man(1) on
  Linux (https://man7.org/linux/man-pages/man1/man.1.html:
  section 1 = executable programs or shell commands)
- accessed: 2026-07-01
- verifies: section 1 is ordinary commands; the shown page is
  the BSD ls page on macOS (its usage line differs from GNU),
  which is the chapter's "authority for YOUR system" point
- version note: stable convention
- confirmable: yes (doc + transcript)
