# Source-verification log: Chapter 12 (Make)

Per PLAN.md Section 10. Command behavior is verified by running
it and capturing real output (see the `ch11-*` transcripts);
this log pins the external/version-volatile claims to
authoritative sources. Access date for all web sources below:
2026-06-30.

### Automatic variables: $@ is the target, $< the first prereq, $^ all prereqs
- chapter/section: Ch 12, "Automatic variables"
- source: GNU Make manual, "Automatic Variables"
  (https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html)
- accessed: 2026-06-30
- verifies: the meaning of `$@`, `$<`, `$^`; also demonstrated
  live in `transcripts/ch11-automatic-vars.txt` (GNU Make 4.3)
- version note: n/a (stable feature)
- confirmable: yes

### .PHONY marks targets that are not files so their recipes always run
- chapter/section: Ch 12, ".PHONY: targets that are not files"
- source: GNU Make manual, "Phony Targets"
  (https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html)
- accessed: 2026-06-30
- verifies: a phony target's recipe runs even if a like-named
  file exists; used for all/check/clean/help
- version note: n/a (stable feature)
- confirmable: yes

### Make decides "out of date" by mtime, and low-resolution timestamps cause same-second ties
- chapter/section: Ch 12, "When timestamps lie"
- source: GNU Make manual, "Special Targets" (`.LOW_RESOLUTION_TIME`)
  (https://www.gnu.org/software/make/manual/html_node/Special-Targets.html);
  GNU Make 4.0 release news
  (https://savannah.gnu.org/forum/forum.php?forum_id=7749);
  bug-make "High resolution file timestamp support for Mac OSX"
  (https://lists.gnu.org/archive/html/bug-make/2011-10/msg00030.html)
- accessed: 2026-06-30
- verifies: the manual states make treats a target as up to date
  if its timestamp falls "at the start of the same second" as the
  prerequisite's, i.e. one-second-resolution comparison. High-
  resolution timestamp support postdates 3.81 (the 2011 patch and
  the 4.0 release), so macOS's bundled Make 3.81 exhibits the
  same-second tie while the sandbox's 4.3 does not. The tie was
  also observed empirically (the R-only incremental rebuild
  sometimes skipped the report render on the Mac; the diagnostic
  mtimes are noted in the build state). The general mtime rule
  is shown deterministically in
  `transcripts/ch11-timestamp-mac.txt` (equal `touch -t` mtimes
  -> skip; one second newer -> rebuild).
- version note: 3.81 = one-second behavior; 4.x = sub-second.
  Empirically confirmed on macOS Make 3.81 and Linux Make 4.3.
- confirmable: yes

### Recipe lines require a TAB; the "did you mean TAB" hint is the same on Make 3.81 and 4.3
- chapter/section: Ch 12, "Anatomy of a rule, and the TAB trap";
  DIVERGENCE callout
- source: captured output `transcripts/ch11-tab-trap.txt`
  (GNU Make 4.3, sandbox) and `transcripts/ch11-tab-trap-mac.txt`
  (GNU Make 3.81, macOS); GNU Make manual, "Rule Syntax" for the
  TAB requirement
  (https://www.gnu.org/software/make/manual/html_node/Rule-Syntax.html)
- accessed: 2026-06-30
- verifies: the TAB requirement and the EXACT error string
  "Makefile:2: *** missing separator (did you mean TAB instead
  of 8 spaces?).  Stop." Both 3.81 (macOS) and 4.3 (sandbox)
  print it identically. CORRECTION: an earlier draft asserted
  3.81 prints a terser form with no hint; the Mac capture
  disproves that, and the chapter was fixed.
- version note: message identical across 3.81 and 4.3
- confirmable: yes (both versions captured)

### `cat -A` is GNU-only; macOS (BSD) cat uses `cat -et` for the same view
- chapter/section: Ch 12, TAB-trap PITFALL + DIVERGENCE callout
- source: captured `transcripts/ch11-tab-trap-mac.txt` (cat -et
  on macOS); BSD cat man page (no -A option) vs GNU coreutils
  cat (-A = -vET)
- accessed: 2026-06-30
- verifies: macOS cat has no -A; -et yields the same TAB/line-end
  rendering used in the TAB-trap example
- version note: n/a (stable BSD/GNU divergence)
- confirmable: yes

### macOS ships GNU Make 3.81; `brew install make` provides gmake 4.x
- chapter/section: Ch 12, two DIVERGENCE callouts
- source: transcript headers (Mac = GNU Make 3.81 in
  `ch11-make-mac.txt`; sandbox = 4.3); Homebrew `make` formula
  (https://formulae.brew.sh/formula/make), which installs GNU
  Make as `gmake`
- accessed: 2026-06-30
- verifies: the macOS-vs-Linux version gap (both transcript-real)
  and the gmake remedy
- version note: current as of 2026-06-30
- confirmable: yes

### Stata batch mode: `stata -b do file` runs non-interactively and writes file.log
- chapter/section: Ch 12, "Stata and EViews in the graph"
  (illustrative recipe)
- source: Stata FAQ, "Running Stata for Unix in batch mode"
  (https://www.stata.com/support/faqs/unix/batch-mode/)
- accessed: 2026-06-30
- verifies: `stata -b do filename` executes the do-file in batch
  and saves output to filename.log
- version note: stable, vendor-documented
- confirmable: yes (recipe is illustrative; not executed)

### EViews is Windows-centric and program-run/interactive; treat its output as a committed upstream input
- chapter/section: Ch 12, "Stata and EViews in the graph";
  DIVERGENCE callout
- source: EViews Command and Programming Reference (run/exec
  program model)
  (https://eviews.com/EViews14/ev14command.html)
- accessed: 2026-06-30
- verifies: EViews runs programs via Run/exec/run on Windows; it
  is not a Unix-shell batch tool, supporting the "upstream manual
  Windows step consumed as a prerequisite" framing
- version note: current as of 2026-06-30
- confirmable: yes (recipe is illustrative; not executed)
