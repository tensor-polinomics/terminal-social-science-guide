#!/usr/bin/env python3
"""Validation gate for the Terminal & Shell book source.

This does NOT replace a real `quarto render` (run that on a
machine with Quarto). It catches the structural and
style problems we can detect without Quarto, so a chapter
is not handed over with a broken table or a stray em-dash.

Checks, per file and book-wide:
  1. _quarto.yml parses and every referenced doc exists.
  2. YAML front matter (if present) parses.
  3. pandoc lint: markdown body parses without warnings
     (Quarto code-chunk syntax is normalised first).
  4. Callout / fenced-div fences are balanced (::: pairs).
  5. No em-dashes (style rule).
  6. Typed command lines and authored code listings wrapped
     to ~64 chars (advisory). Verbatim tool output inside a
     terminal-session block is exempt (it must stay
     byte-faithful and the reader never types it).

Exit code is nonzero if any ERROR is found. WARN does not
fail the gate.

Usage:
  python tools/validate_book.py book
  python tools/validate_book.py book/chapters/07-pipes-redirection-danger.qmd
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

import yaml

CODE_WIDTH = 64
EMDASH = "—"
errors: list[str] = []
warns: list[str] = []


def err(f: str, msg: str) -> None:
    errors.append(f"ERROR  {f}: {msg}")


def warn(f: str, msg: str) -> None:
    warns.append(f"WARN   {f}: {msg}")


def split_front_matter(text: str) -> tuple[str, str]:
    """Return (yaml_text, body). yaml_text is '' if none."""
    if text.startswith("---\n"):
        end = text.find("\n---", 4)
        if end != -1:
            nl = text.find("\n", end + 1)
            return text[4:end], text[nl + 1:] if nl != -1 else ""
    return "", text


def check_quarto_yml(book: Path) -> list[Path]:
    cfg_path = book / "_quarto.yml"
    if not cfg_path.exists():
        err(str(cfg_path), "missing _quarto.yml")
        return []
    cfg = yaml.safe_load(cfg_path.read_text())
    files: list[str] = []

    def walk(chs):
        for c in chs:
            if isinstance(c, str):
                files.append(c)
            elif isinstance(c, dict) and "chapters" in c:
                walk(c["chapters"])

    walk(cfg.get("book", {}).get("chapters", []))
    out = []
    for f in files:
        p = book / f
        if not p.exists():
            err("_quarto.yml", f"references missing file: {f}")
        else:
            out.append(p)
    return out


def check_fences(f: str, body: str) -> None:
    # balanced ``` code fences
    ticks = len(re.findall(r"^```", body, flags=re.M))
    if ticks % 2 != 0:
        err(f, f"unbalanced ``` code fences ({ticks} markers)")
    # balanced ::: divs (each ::: toggles; must be even)
    colon = len(re.findall(r"^:::", body, flags=re.M))
    if colon % 2 != 0:
        err(f, f"unbalanced ::: fenced divs ({colon} markers)")


def check_emdash(f: str, text: str) -> None:
    n = text.count(EMDASH)
    if n:
        lines = [i + 1 for i, ln in enumerate(text.splitlines())
                 if EMDASH in ln]
        err(f, f"{n} em-dash(es) on line(s) {lines[:10]}")


def _is_prompt(ln: str) -> bool:
    # A typed command line in a terminal session.
    return ln.startswith("$ ") or ln.startswith("> ")


def check_code_width(f: str, body: str) -> None:
    """Width-check what the reader types, not machine output.

    The ~64 target exists so a reader can copy a command
    without horizontal scroll and so PDF code stays in the
    margin. That applies to typed commands and to authored
    code listings (Makefiles, scripts), which a reader may
    copy. It does NOT apply to verbatim tool output, which the
    reader never types and which must stay byte-faithful to
    the "real output only" rule. So: in a terminal-session
    block (one that contains a `$ ` or `> ` prompt), only the
    prompt lines are checked; output lines are exempt. A code
    block with no prompt is treated as an authored listing and
    every line is checked.
    """
    long_lines = []
    in_code = False
    block: list[tuple[int, str]] = []

    def flush() -> None:
        if not block:
            return
        is_session = any(_is_prompt(ln) for _, ln in block)
        for i, ln in block:
            if len(ln) <= CODE_WIDTH:
                continue
            if is_session and not _is_prompt(ln):
                continue  # verbatim tool output: exempt
            long_lines.append((i, len(ln)))

    for i, ln in enumerate(body.splitlines(), 1):
        if ln.startswith("```"):
            if in_code:
                flush()
                block.clear()
            in_code = not in_code
            continue
        if in_code:
            block.append((i, ln))
    if in_code:  # unterminated fence; check_fences reports it
        flush()

    if long_lines:
        preview = ", ".join(f"L{n}({w})" for n, w in long_lines[:8])
        warn(f, f"{len(long_lines)} code line(s) > {CODE_WIDTH} "
                f"chars: {preview}")


def pandoc_lint(f: str, body: str) -> None:
    # normalise Quarto chunk syntax: ```{python ...} -> ```python
    norm = re.sub(r"^```\{=?(\w+)[^}]*\}", r"```\1", body,
                  flags=re.M)
    try:
        proc = subprocess.run(
            # No --quiet: we WANT pandoc warnings on stderr so the
            # check below can surface them (header promises this).
            ["pandoc", "--from",
             "markdown+fenced_divs+pipe_tables",
             "--to", "native"],
            input=norm, capture_output=True, text=True,
            timeout=30,
        )
    except FileNotFoundError:
        warn(f, "pandoc not found; skipped markdown lint")
        return
    if proc.returncode != 0:
        msg = proc.stderr.strip().splitlines()
        err(f, "pandoc failed: " + (msg[0] if msg else "?"))
    elif proc.stderr.strip():
        warn(f, "pandoc: " + proc.stderr.strip().splitlines()[0])


def check_file(p: Path) -> None:
    f = p.name
    text = p.read_text()
    ytext, body = split_front_matter(text)
    if ytext:
        try:
            yaml.safe_load(ytext)
        except yaml.YAMLError as e:
            err(f, f"front matter YAML error: {e}")
    check_fences(f, body)
    check_emdash(f, text)
    check_code_width(f, body)
    pandoc_lint(f, body)


def main() -> int:
    target = Path(sys.argv[1] if len(sys.argv) > 1 else "book")
    if target.is_dir():
        docs = check_quarto_yml(target)
        for p in docs:
            check_file(p)
    else:
        check_file(target)

    for w in warns:
        print(w)
    for e in errors:
        print(e)
    print(f"\n{len(errors)} error(s), {len(warns)} warning(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
