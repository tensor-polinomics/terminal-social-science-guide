# Source-verification log: Chapter 7 (Pipes, Redirection, Danger)

Per PLAN.md Section 10. Command behavior is verified by running
it and capturing real output (see the `ch06-*` transcripts);
this log pins the external/version-volatile claims to
authoritative sources. Access date for all web sources below:
2026-06-30. The macOS/BSD divergence claims are confirmed
empirically by `transcripts/ch06-divergence-mac.txt` (captured
2026-06-30 on macOS 26.5.1, Apple Silicon, zsh 5.9 + system
bash 3.2.57, via `transcripts/capture-ch06-mac.sh`). Captured
results: zsh unmatched glob = `zsh: no matches found` (exit 1);
bash 3.2.57 unmatched glob = literal pass-through (`ls: *.xyz:
No such file or directory`); noclobber refusal = `zsh: file
exists` vs `/bin/bash: f: cannot overwrite existing file`; BSD
`find -print0 | xargs -0` returns intact spaced names while the
naive pipe breaks (BSD `wc: ./fy: open: No such file`); and
`2>&1 > file` does NOT merge on either Mac shell (order rule
holds). The Mac-capture OPEN flag is now CLEARED.

### Streams 0/1/2: stdin=0, stdout=1, stderr=2
- chapter/section: Ch 7, "Three streams"
- source: POSIX.1-2017 (IEEE Std 1003.1) "Base Definitions",
  Section 3 (Standard Input/Output/Error) and `<unistd.h>`
  STDIN_FILENO=0 / STDOUT_FILENO=1 / STDERR_FILENO=2
  (https://pubs.opengroup.org/onlinepubs/9699919799/)
- accessed: 2026-06-30
- verifies: the three streams and their file-descriptor numbers
- demonstrated live: `transcripts/ch06-streams.txt`
  (GNU coreutils 8.32, sandbox)
- confirmable: yes

### `>` truncates, `>>` appends; `set -o noclobber` refuses, `>|` overrides
- chapter/section: Ch 7, "Redirecting output to files"; DANGER
- source: Bash Reference Manual, "Redirections" (Redirecting
  Output `>`, Appending `>>`, and the `noclobber` option / `>|`)
  (https://www.gnu.org/software/bash/manual/html_node/Redirections.html);
  Bash Reference Manual, "The Set Builtin" (`noclobber` via
  `set -C` / `set -o noclobber`)
  (https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
- accessed: 2026-06-30
- verifies: `>` truncates an existing file before writing; `>>`
  appends; `noclobber` makes `>` refuse to overwrite an existing
  regular file; `>|` forces the overwrite anyway
- demonstrated live: `transcripts/ch06-redirect.txt` (bash 5.1,
  sandbox). Interactive refusal message `bash: note.txt: cannot
  overwrite existing file` confirmed via `bash -i` in the same
  sandbox. The run-to-log provenance block (`{ ...; } > run.log
  2>&1`; the REPRODUCIBILITY callout) is captured separately in
  `transcripts/ch06-provenance.txt`.
- version note: n/a (stable bash feature)
- confirmable: yes

### `2>&1` redirects stderr to stdout's CURRENT target; order matters
- chapter/section: Ch 7, "Separating errors from results"
- source: Bash Reference Manual, "Redirections" (Redirecting
  Standard Output and Standard Error; "the order of redirections
  is significant")
  (https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
- accessed: 2026-06-30
- verifies: `> file 2>&1` merges both into file; `2>&1 > file`
  does not, because `2>&1` duplicates stdout's destination at the
  point it appears
- demonstrated live: `transcripts/ch06-stderr.txt` (bash 5.1,
  sandbox)
- confirmable: yes

### `&>` is a bash/zsh shorthand, not POSIX; portable form is `> file 2>&1`
- chapter/section: Ch 7, "Separating errors from results";
  DIVERGENCE
- source: Bash Reference Manual, "Redirections" (`&>file`
  documented as equivalent to `>file 2>&1`, noted as preferred
  bash form but non-standard); POSIX.1-2017 Shell Command
  Language, "Redirection" (no `&>` operator)
  (https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
- accessed: 2026-06-30
- verifies: `&>` is undefined in POSIX `sh`; `> file 2>&1` is the
  portable spelling across Bourne-family shells
- version note: current; `&>` behavior stable in bash and zsh
- confirmable: yes; Mac side confirmed in
  `ch06-divergence-mac.txt` (zsh 5.9 + bash 3.2.57): `2>&1 > file`
  does not merge on either shell (order rule holds)

### A pipeline's exit status is the last command's; `set -o pipefail` makes any failure win
- chapter/section: Ch 7, "Pipes and exit status"
- source: Bash Reference Manual, "Pipelines" (exit status is that
  of the last command unless `pipefail` is set, in which case it
  is the last nonzero)
  (https://www.gnu.org/software/bash/manual/html_node/Pipelines.html)
- accessed: 2026-06-30
- verifies: default last-stage status; `pipefail` returns the
  rightmost nonzero status
- demonstrated live: `transcripts/ch06-pipefail.txt` (bash 5.1,
  sandbox)
- version note: `pipefail` is bash/zsh/ksh; not in POSIX `sh`
  (consistent with the book's bash-target rule, CLAUDE.md)
- confirmable: yes

### Word-splitting: an unquoted `$var` is split on `IFS`; `"$var"` is one field
- chapter/section: Ch 7, "Quoting"; PITFALL
- source: Bash Reference Manual, "Word Splitting" and "Shell
  Parameter Expansion" (`${parameter}` brace form)
  (https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html)
- accessed: 2026-06-30
- verifies: unquoted expansions undergo word splitting on `IFS`
  (default space/tab/newline); double-quoting suppresses it; the
  brace form delimits the name
- demonstrated live: `transcripts/ch06-quoting.txt` (bash 5.1,
  sandbox)
- confirmable: yes

### An unmatched glob: bash passes it literally; `nullglob` makes it expand to nothing
- chapter/section: Ch 7, "Globs are not regular expressions";
  DIVERGENCE
- source: Bash Reference Manual, "Filename Expansion" (unmatched
  pattern left unchanged unless `nullglob`/`failglob` set)
  (https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html);
  zsh manual, "Filename Generation" / `NOMATCH` option (unmatched
  glob is an error by default; "no matches found")
  (https://zsh.sourceforge.io/Doc/Release/Expansion.html)
- accessed: 2026-06-30
- verifies: bash default = literal pass-through; `shopt -s
  nullglob` = empty expansion; zsh default (`NOMATCH` on) = hard
  error with "no matches found"
- demonstrated live: bash side in `transcripts/ch06-globs.txt`
  (bash 5.1, sandbox); zsh side confirmed in
  `ch06-divergence-mac.txt` (`zsh: no matches found`, exit 1) and
  bash 3.2.57 literal pass-through
- version note: zsh `NOMATCH` is the long-standing default
- confirmable: yes (bash and zsh both captured)

### Null-safe lists: `find -print0` + `xargs -0`; null is the only separator a path cannot contain
- chapter/section: Ch 7, "Null-safe file lists"; DIVERGENCE
- source: GNU findutils manual, `find` "-print0" and `xargs`
  "-0 / --null"
  (https://www.gnu.org/software/findutils/manual/html_node/find_html/);
  POSIX "pathname" definition (a path may contain any byte except
  NUL and `/`), Base Definitions Section 3.271
  (https://pubs.opengroup.org/onlinepubs/9699919799/)
- accessed: 2026-06-30
- verifies: `-print0`/`-0` use the NUL byte as the separator;
  NUL and `/` are the only bytes excluded from a filename, so NUL
  is the only fully safe delimiter; newlines are legal in names,
  so `IFS=$'\n'` is insufficient. BSD (macOS) `find`/`xargs` also
  provide `-print0`/`-0`.
- demonstrated live: `transcripts/ch06-nullsafe.txt` (GNU
  findutils 4.8, sandbox); BSD parity confirmed in
  `ch06-divergence-mac.txt` (intact spaced names; naive pipe
  breaks with BSD `wc: ./fy: open: No such file`)
- version note: `-print0`/`-0` present on GNU and BSD
- confirmable: yes (GNU and BSD both captured)

### `rm -rf` is recursive+forced and irreversible; preserve-root guards literal `/` only; `${VAR:?word}` aborts on empty/unset
- chapter/section: Ch 7, "rm -rf and the shell with no undo";
  DANGER, RECOVERY
- source: GNU coreutils manual, `rm` invocation (`-r` recursive,
  `-f` force; "removed files cannot be recovered"; `rm` refuses to
  recursively operate on `/` unless `--no-preserve-root` is given,
  the default since coreutils 6.4/2006)
  (https://www.gnu.org/software/coreutils/manual/html_node/rm-invocation.html);
  BSD/macOS `rm` man page (recursive delete of `/` is disallowed
  by default); Bash Reference Manual, "Shell Parameter Expansion"
  (`${parameter:?word}`: if null or unset, the expansion of word
  is written to stderr and a non-interactive shell exits)
  (https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
- accessed: 2026-06-30
- verifies: `rm -rf` semantics and non-recoverability; that a
  bare `rm -rf /` is refused by modern GNU/BSD `rm` (preserve-root)
  but this does NOT cover `rm -rf /*` (glob expands to non-`/`
  names) nor deletion of a wrong non-root path, so the chapter no
  longer claims a bare `rm -rf /` "deletes the whole filesystem";
  the `:?` guard aborts the command when the variable is
  empty/unset.
  Note for honesty: `:?` causes a NON-interactive shell to exit;
  interactively it aborts the current command and the shell
  survives. The transcript runs the empty-var case in a subshell
  `( ... )` so the captured behavior matches the interactive
  prompt (command aborts, shell lives, tree intact).
- demonstrated live: `transcripts/ch06-rm-rf.txt` (bash 5.1,
  sandbox, all in /tmp); interactive `:?` form re-confirmed via
  `bash -i`.
- confirmable: yes

### `curl | sh` runs unreviewed remote code; servers can detect piping; verify-then-run is the mitigation
- chapter/section: Ch 7, "Never pipe a stranger into your shell";
  DANGER (quarantined; NOT executed)
- source: the server-side detection technique. The live host for
  the original writeup no longer resolves (confirmed in the Codex
  audit, 2026-06-30), so cite the Internet Archive capture of
  "Detecting the use of 'curl | bash' server side"
  (https://web.archive.org/web/https://www.idontplaydarts.com/2016/04/detecting-curl-pipe-bash-server-side/)
  and the independent, reachable proof-of-concept
  (https://github.com/Stijn-K/curlbash_detect); `type`/`command
  -v` behavior, Bash Reference Manual "Bourne Shell Builtins"
  (`type -a`, `command -v`)
  (https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html)
- accessed: 2026-06-30
- verifies: the pattern executes unread code with user privileges;
  a server CAN serve different bytes to a piped client because a
  shell consumes the stream line by line and pauses to execute,
  a TCP-buffer/timing side channel (NOT a difference in the HTTP
  request itself; the chapter wording was corrected to say so);
  no integrity check unless the user adds one; `type -a` lists
  all PATH matches in order and `command -v` resolves what runs
  (the PATH-hijack check)
- demonstrated live (the SAFE parts only): `type -a sort`,
  `command -v sha256sum`, and `sha256sum` are captured in
  `transcripts/ch06-path-hijack.txt` (bash 5.1, sandbox). The
  `curl | sh` line itself is NEVER executed (shown in a
  non-runnable `text` block); the verify-then-run block is
  labeled an illustrative template (`example.com` placeholder).
- version note: version-stamped "current as of 2026"; the
  server-side-detection claim is a demonstrated technique, not a
  universal guarantee, and is phrased as "can," not "does."
- confirmable: yes, via the Internet Archive capture plus the
  reachable PoC repo. NOTE: the original live host
  (idontplaydarts.com) no longer resolves (Codex audit,
  2026-06-30); the claim is corroborated by the archived article,
  the PoC repo, and multiple independent write-ups found by web
  search. The GNU `type -a` / `command -v` behavior is captured
  in `transcripts/ch06-path-hijack.txt`.

## Gate confirmations

- **Mac divergence transcript: DONE (2026-06-30).**
  `capture-ch06-mac.sh` was run on the Mac and produced
  `ch06-divergence-mac.txt` (macOS 26.5.1, zsh 5.9, bash
  3.2.57), empirically confirming all four divergence claims:
  (a) zsh `no matches found` on an unmatched glob vs bash
  literal pass-through; (b) the noclobber refusal wording
  (`zsh: file exists` vs `/bin/bash: ... cannot overwrite
  existing file`); (c) BSD `find -print0`/`xargs -0` parity and
  the naive-pipe breakage; (d) `2>&1 > file` order on zsh and
  bash 3.2.57. The three DIVERGENCE callouts now cite captured
  output, not documented behavior alone.
- **`curl | sh` citation: RESOLVED (2026-06-30).** The
  from-memory Daniel Stenberg URL was dropped. The live
  idontplaydarts host no longer resolves, so the source pin is
  now the Internet Archive capture of the 2016 idontplaydarts
  article plus the independent PoC repo. The chapter's mechanism
  wording was also corrected: detection is a TCP-buffer/timing
  side channel (a shell consumes the stream line by line), NOT
  "the request looks different." The claim is corroborated by
  the archived article, the PoC repo, and multiple independent
  search hits.

## Review-response Session 2 (2026-07-09): forward pointers to the Ch 11 primer

No behavior claim changed and no transcript was touched. Two
prose parentheticals were added so the constructs the chapter
*uses* are pointed at their single teaching home, the scripting
primer added to Chapter 11 ("Reading a script: tests, branches,
and loops"), instead of being explained here:

- **Quoting section, the `for w in $f` word-splitting demo:** a
  note that the `for` loop is taught in Chapter 11's primer and
  here only illustrates word-splitting. The two `for` blocks and
  their output are unchanged (still backed by
  `transcripts/ch06-quoting.txt`).
- **Redirecting-to-files / REPRODUCIBILITY, the
  `{ ...; } > run.log 2>&1` block:** a note that the `{ ...; }`
  grouping is explained in Chapter 11's primer. The block itself
  is unchanged (still backed by `transcripts/ch06-provenance.txt`).

The review memo's point 13 flagged relocating a `[ ]`-spacing
lesson "from the pipes chapter," but there is no `[ ]` test in
this chapter to relocate (the `nullglob` demo is the literal
`echo "matches:[" *.xyz "]"`, not a `test`); the `[ ]`-vs-`[[ ]]`
spacing lesson is authored fresh in the Chapter 11 primer, as
the memo's own correction anticipated. Cross-references into the
primer already use the current numbering (Chapter 11).
