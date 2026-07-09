# Source-verification log: Chapter 17 (AI in the Terminal)

Per PLAN.md Section 10. This chapter is principles-first and
**version-stamped**: every tool-specific claim carries a "current
as of 2026-07-01" note and is pinned to the tool's official docs,
because AI-CLI behavior is volatile. All three CLIs are installed
on the user's Mac and captured there; two of them (OpenAI Codex
CLI, Gemini CLI) are not present in this book's *Linux workspace
sandbox*, which is why the real capture is a Mac step, not a
sandbox one. The version anchor is
(`transcripts/ch16-versions-mac.txt`, from
`transcripts/capture-ch16-mac.sh`, run on the user's Mac); the
permission/sandbox flag names are additionally evidenced by
`transcripts/ch16-help-mac.txt`. The "review the diff" demo is a
real, AI-free sandbox capture (`transcripts/ch16-review-diff.txt`,
GNU diffutils 3.8). Access date for all web sources: 2026-07-01.

All three CLIs are treated as **document + quarantine**
(principles only, nothing run) by deliberate choice, because a
live agent session is non-deterministic and API-costing, not
because any tool is missing. Correction (2026-07-01): the kickoff
premise that Gemini CLI was not installed proved wrong; the Mac
capture found it at `/opt/homebrew/bin/gemini`
(`ch16-versions-mac.txt`). After the user logged Gemini in, the
capture was re-run for all three: Claude Code 2.1.197, OpenAI
Codex CLI 0.142.5, Gemini CLI 0.49.0, with permission flags
confirmed in `ch16-help-mac.txt`. None is run live in this
chapter.

### Claude Code permission modes: default / acceptEdits / plan / auto / dontAsk / bypassPermissions
- chapter/section: Ch 17, "Permission models"; DANGER
- source: "Choose a permission mode" - Claude Code Docs
  (https://code.claude.com/docs/en/permission-modes)
- accessed: 2026-07-01
- verifies: the six modes and what each runs without asking:
  `default` = reads only; `acceptEdits` = reads + file edits +
  common filesystem Bash commands (`mkdir`, `touch`, `rm`,
  `rmdir`, `mv`, `cp`, `sed`) but only inside the working
  directory / `additionalDirectories`; `plan` = reads only, no
  edits; `auto` = everything with a background classifier that
  blocks escalations (research preview, v2.1.83+); `dontAsk` =
  only pre-approved tools; `bypassPermissions`
  (`--dangerously-skip-permissions`) = everything. The mode is
  set by flag (`--permission-mode`), `Shift+Tab` cycle, or
  `settings.json` `defaultMode`, NOT by asking Claude in chat.
- version note: current as of 2026-07-01; mode set is
  version-volatile (`auto`/`dontAsk` are recent; doc cites
  v2.1.x). Stamp required.
- confirmable: yes (doc fetched clean 2026-07-01)

### Claude Code: protected paths, root refusal, and the rm -rf circuit breaker
- chapter/section: Ch 17, "The destructive-command boundary";
  "Review discipline"; DANGER
- source: "Choose a permission mode" - Claude Code Docs, sections
  "Protected paths" and "Skip all checks with bypassPermissions
  mode"
  (https://code.claude.com/docs/en/permission-modes)
- accessed: 2026-07-01
- verifies: writes to protected paths (`.git`, `.claude`, shell
  startup files such as `.zshrc`/`.bashrc`, `.gitconfig`, etc.)
  are never auto-approved in any mode except `bypassPermissions`;
  `bypassPermissions` refuses to start as root/`sudo` and still
  prompts on `rm -rf /` and `rm -rf ~` as a circuit breaker; the
  `auto`-mode classifier blocks `curl | bash`, mass cloud
  deletion, force-push to `main`, and similar by default. Backs
  the claim that an agent is bounded by the SAME shell dangers as
  Ch 7, plus tool guardrails that are real but not a substitute
  for review.
- version note: current as of 2026-07-01; guardrail lists are
  version-volatile.
- confirmable: yes

### OpenAI Codex CLI: sandbox modes (read-only / workspace-write / danger-full-access) and approval policy
- chapter/section: Ch 17, "Permission models"; "File and scope
  boundaries"; "Network access"
- source: "Agent approvals & security" - Codex, OpenAI Developers
  (https://developers.openai.com/codex/agent-approvals-security);
  "Command line options" and "Configuration Reference"
  (https://developers.openai.com/codex/cli/reference,
  https://developers.openai.com/codex/config-reference) for the
  approval_policy values, the `on-failure` deprecation, and the
  `--yolo` alias (re-verified 2026-07-01)
- accessed: 2026-07-01
- verifies: Codex separates a **sandbox mode** (what it can touch)
  from an **approval policy** (when it must ask). Sandbox modes:
  `read-only`, `workspace-write` (default; writes limited to the
  active workspace, network OFF unless
  `sandbox_workspace_write.network_access=true`), and
  `danger-full-access` (no filesystem/network boundary). Approval
  policy values are `untrusted`, `on-request`, and `never`, plus a
  `granular` policy; `on-failure` is DEPRECATED (prefer on-request
  interactive / never non-interactive). Auto preset =
  `--sandbox workspace-write --ask-for-approval on-request`. On
  launch Codex recommends Auto for version-controlled folders and
  `read-only` for non-version-controlled folders.
  `<writable_root>/.git`, `.agents`, and `.codex` stay read-only.
  Full bypass (no sandbox, no approvals) is the single flag
  `--dangerously-bypass-approvals-and-sandbox`, alias `--yolo`;
  turning off just one axis (`danger-full-access` OR `-a never`) is
  NOT full bypass.
- version note: current as of 2026-07-01; mode/flag names are
  version-volatile.
- confirmable: yes (doc fetched clean 2026-07-01)

### OpenAI Codex CLI: network off by default; prompt injection caution
- chapter/section: Ch 17, "Network access and the supply chain";
  DANGER
- source: "Agent approvals & security" - Codex, OpenAI Developers
  (https://developers.openai.com/codex/agent-approvals-security)
- accessed: 2026-07-01
- verifies: "By default, the agent runs with network access turned
  off"; enabling network access or web search exposes the agent to
  prompt injection ("Prompt injection can cause the agent to fetch
  and follow untrusted instructions"). Backs the cross-ref that an
  agent with network access can run exactly the Ch 7 `curl | sh`.
- version note: current as of 2026-07-01
- confirmable: yes

### Gemini CLI: approval modes (default / auto_edit / yolo / plan) and sandbox
- chapter/section: Ch 17, "Permission models"; "What an agent
  must never run unsupervised"; DIVERGENCE
- source: "Gemini CLI Configuration" - gemini-cli docs
  (https://google-gemini.github.io/gemini-cli/docs/get-started/configuration.html);
  and real `gemini --help` output, Gemini CLI 0.49.0, in
  `transcripts/ch16-help-mac.txt` (captured 2026-07-01)
- accessed: 2026-07-01
- verifies: `--approval-mode` takes `default` (prompt each tool
  call), `auto_edit` (auto-approve edit tools, prompt others),
  `yolo` (auto-approve ALL; `--yolo` / `-y`), and `plan`
  (read-only); sandboxing is DISABLED by default and enabled via
  `--sandbox`/`-s`, `GEMINI_SANDBOX`, or automatically under
  `--yolo` (Docker/podman, or macOS Seatbelt `sandbox-exec`);
  `tools.allowed` and `mcpServers.<name>.trust` bypass the
  confirmation dialog. This is the DIVERGENCE anchor: each tool has
  a one-flag "approve everything" switch, `bypassPermissions` in
  Claude Code, `--yolo` (alias for
  `--dangerously-bypass-approvals-and-sandbox`) in Codex, and
  `--yolo` / `yolo` in Gemini. Codex additionally exposes the two
  underlying axes (sandbox mode vs approval policy) separately, so
  there `-a never` alone still leaves the workspace sandbox in
  place (see the Codex sandbox/approval pin above). Documented, NOT
  run (quarantine by choice; API-costing live sessions).
- version note: current as of 2026-07-01, Gemini CLI 0.49.0. The
  real `--help` ADDS a `plan` approval mode not in the pinned doc
  (help is ground truth here), and marks the `--allowed-tools`
  FLAG deprecated in favor of a "Policy Engine", a live example of
  how fast this surface moves. Names are version-volatile.
- confirmable: yes (doc fetched clean 2026-07-01; the
  `--approval-mode` choices `default`/`auto_edit`/`yolo`/`plan`,
  `-y/--yolo`, and `-s/--sandbox` are confirmed in the captured
  `transcripts/ch16-help-mac.txt`)

### Gemini CLI: prompt logging and telemetry
- chapter/section: Ch 17, "Secrets in prompts"; PITFALL
- source: "Gemini CLI Configuration" - gemini-cli docs, sections
  "telemetry" and "Usage Statistics"
  (https://google-gemini.github.io/gemini-cli/docs/get-started/configuration.html)
- accessed: 2026-07-01
- verifies: `telemetry.logPrompts` (and `--telemetry-log-prompts`)
  controls whether the CONTENT of user prompts is written to logs;
  a per-project shell-command history is kept at
  `~/.gemini/tmp/<hash>/shell_history`. Backs the concrete claim
  that a prompt is not ephemeral: it can land in a local log or
  transcript. (Gemini's anonymized usage stats are documented as
  excluding prompt/response/file content and PII; the leak vector
  is `logPrompts`-style local logging and the shell history, plus
  whatever a provider retains.)
- version note: current as of 2026-07-01
- confirmable: yes

### Review-the-diff demo (AI-free) and the reproducibility tie
- chapter/section: Ch 17, "Review discipline"; "Reproducibility
  of agent-run commands"; REPRODUCIBILITY, RECOVERY
- source: real sandbox capture, no external claim
- accessed: n/a
- verifies: `diff -U 0` on a copy of the real pipeline script
  `scripts/02_portfolio.py` shows a one-line agent-style edit
  (`N_PORT = 10  # deciles` -> `N_PORT = 5  # quintiles`) that
  would silently change the locked long-short alpha. Demonstrates
  "review the diff before you accept" and ties agent edits to the
  G1 reproducibility invariant (a changed `N_PORT` would fail
  `make check`). Captured in `transcripts/ch16-review-diff.txt`
  (GNU diffutils 3.8, sandbox, /tmp).
- version note: n/a (stable tool behavior)
- confirmable: yes

### Internal cross-references (not externally pinned)
- chapter/section: Ch 17 throughout
- source: this book, Ch 7 (`curl | sh`, `rm -rf`, PATH-hijack)
  and Ch 10 (secrets, shell history, `HISTFILE`); companion Git
  book (review discipline, diffs, replication package)
- accessed: n/a
- verifies: the chapter cross-references, and does not re-teach,
  the Ch 7 danger material and the Ch 10 secrets material; an agent
  can run exactly the lines those chapters warn about.
- version note: n/a
- confirmable: yes (internal)

## Gate confirmations

- **Version anchor: DONE (2026-07-01).** `capture-ch16-mac.sh`
  was run on the Mac; `ch16-versions-mac.txt` records Claude Code
  2.1.197, OpenAI Codex CLI 0.142.5, and Gemini CLI 0.49.0, and
  `ch16-help-mac.txt` confirms MOST of the flag names the chapter
  uses: `--permission-mode <mode>` / `--dangerously-skip-permissions`
  (Claude Code); `-s, --sandbox <SANDBOX_MODE>`, `-a,
  --ask-for-approval <APPROVAL_POLICY>` with `on-request` / `never`,
  and `--dangerously-bypass-approvals-and-sandbox` ("EXTREMELY
  DANGEROUS. Intended solely for running in environments that are
  externally sandboxed") (Codex); and `-y, --yolo`, `-s,
  --sandbox`, and `--approval-mode` with choices
  `default`/`auto_edit`/`yolo`/`plan` (Gemini). **Codex `--yolo`
  provenance (round-5 audit, resolved):** `codex --help` prints
  only the long `--dangerously-bypass-approvals-and-sandbox` form
  (the widened `...|yolo` grep surfaced no `--yolo` help line), but
  the alias is real on two independent grounds, both captured in
  `ch16-help-mac.txt`: the official Codex CLI reference documents
  it, and a functional check `codex --yolo --version` returns
  `codex-cli 0.142.5` (the binary accepts the alias). So `--yolo`
  is docs-backed AND functionally capture-backed, just not printed
  in `--help`. The chapter states versions in prose (Ch 12 style);
  no `--version` command block is
  shown. The chapter's four-row axis is a deliberate simplification
  of finer-grained real values (e.g. Codex's `granular` approval
  policy and its deprecated `on-failure`); Gemini's `plan` mode,
  also from the real help, IS surfaced (the Gemini Read/plan cell).
- **Doc fetches: DONE (2026-07-01).** All three official docs
  (Claude Code permission-modes, Codex agent-approvals-security,
  Gemini CLI configuration) fetched clean and pinned above. No
  dead-host / Internet-Archive fallback was needed for Ch 17.
- **Gemini quarantine basis: CORRECTED and now fully captured
  (2026-07-01).** The kickoff premise that Gemini CLI was not
  installed was WRONG: the Mac capture found it at
  `/opt/homebrew/bin/gemini`. After the user logged Gemini in, the
  script was updated to capture `gemini --version` + `--help`
  identically to the other two and re-run, so `ch16-versions-mac.txt`
  (Gemini CLI 0.49.0) and `ch16-help-mac.txt` no longer contain any
  "expected absent" wording. Gemini is quarantined by the same
  deliberate choice as the other two (volatile, non-deterministic,
  API-costing live sessions), not because it is missing.
