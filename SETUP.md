# SETUP: build environment and dependencies

This book is built across three machines, because no single one produces all of
its real output. Install dependencies **phase by phase**, not all at once: each
chapter pulls in only the tools it needs, and most are not required until their
chapter.

## The three machines

| Machine | Sudo? | Role | Install method |
|---|---|---|---|
| **Mac (Apple Silicon)** | yes | The hub: runs all R, the full pipeline and `make` graph, renders HTML + PDF, and is the macOS/BSD side of divergence callouts. | Homebrew |
| **SSH Linux box** | **no** | Remote target for the SSH / remote-compute chapters. Any Linux box you can reach (lab server, cloud VM, HPC login node, Runpod). | userspace only |
| **Workspace sandbox** | no | Linux/GNU witness for portable-command output and the Python half of the pipeline. Locked down: no apt; PyPI reachable; CRAN, quarto.org, and GitHub release CDNs blocked. | `uv` / `pip` (PyPI) |

Only the Mac has admin rights. Neither the sandbox nor the SSH box has root, so
there are no `sudo apt` steps for them. R, Quarto, and rendering live on the Mac.

## Install by phase

**Phase 0 (build gate):** nothing to add. The gate needs `pandoc`, `python3`,
and `uv`, already present on the Mac and the sandbox.

**Phase 1 (running-example pipeline), on the Mac:**

- Python deps, pinned and installed from the project (Phase 1 adds numpy,
  polars, matplotlib to `pyproject.toml`):

  ```bash
  uv sync          # reads pyproject.toml + uv.lock
  ```

- R itself globally, then project-local packages through renv (not a global
  `install.packages`):

  ```bash
  brew install --cask r            # only if R is missing
  # Phase 1 creates the renv project files and renv.lock; then:
  Rscript -e 'renv::restore()'     # fixest, modelsummary, tidyverse
  ```

  If `renv` itself is not available yet, Phase 1 should bootstrap it into the
  project before restoring the analysis packages.

- Confirm the rest of the pipeline toolchain: `make`, `quarto`, `uv`, `Rscript`,
  and a LaTeX engine Quarto can find (`quarto install tinytex` suffices).

**Later phases (install only when the chapter needs it):**

| Chapter | Tools to add |
|---|---|
| Ch 2 | `tldr` (tealdeer) |
| Ch 8 | `duckdb` |
| Ch 9 | `fd`, `ripgrep` (often already present) |
| Ch 11 | `shellcheck`, `shfmt` |
| Ch 14-15 | `tmux`, `ncdu` on the remote box (`ssh`/`rsync` are usually preinstalled) |
| Ch 16 | modern kit + TUIs: `eza`, `bat`, `zoxide`, `fzf`, `git-delta`, `btop`, `ncdu`, `lazygit` |
| Ch 17 | AI CLIs (Claude Code / Codex / Gemini), version-stamped |

These CLI tools are generally cross-platform, so routine output can be captured
on the Mac; a separate Linux capture is still required where behavior, version,
or packaging differs. Most expected divergences are BSD-vs-GNU coreutils, which
the sandbox already provides.

## Mac (Homebrew): install what is missing

Many tools are likely already present (`rg fd bat eza zoxide fzf delta jq make
pandoc uv quarto Rscript python3`). Install only what `command -v` reports as
missing, for example:

```bash
brew install tmux ncdu duckdb shellcheck shfmt tealdeer btop lazygit
brew install --cask r quarto     # if missing
quarto install tinytex           # LaTeX for PDF
```

Homebrew installs `delta` as `git-delta`, and the `tldr` client as `tealdeer`
(the binary is still `tldr`).

## SSH Linux box (no sudo): userspace installs

You only need a remote Linux box for the SSH / remote-compute chapters. Check
first: `ssh`, `rsync`, and usually `tmux` are already there. For anything
missing, install into your home directory without root:

- **Static binaries** to `~/.local/bin` (most modern tools ship one): download
  the Linux build for the box's architecture, `chmod +x`, place it in
  `~/.local/bin`, and put that on `PATH` (covered in Ch 18).
- **Python-based tools** via `uv tool install <tool>` (no root; uses PyPI).
- **HPC login nodes:** prefer the `module` system (`module avail`,
  `module load`) over installing anything.

There is no `apt` here; you do not have sudo.

## Workspace sandbox

Nothing to install by hand. It runs preinstalled GNU tools (pandoc, make, jq,
rg, ssh, rsync, tmux, screen, coreutils, tar, gzip) plus the Python pipeline
deps from `uv sync`. It cannot install R, Quarto, or apt/GitHub-binary tools.

## Installing uv without a blind pipe

This book teaches readers not to pipe an unseen script straight into a shell, so
model the safe pattern rather than `curl ... | sh`:

```bash
# Mac: use Homebrew
brew install uv

# No-sudo Linux: download, inspect, then run
curl -LsSf https://astral.sh/uv/install.sh -o uv-install.sh
less uv-install.sh        # read it before running
sh uv-install.sh          # installs into ~/.local/bin
```

## Verify (any machine)

```bash
check() { command -v "$1" >/dev/null 2>&1 \
  && printf "  OK   %-12s %s\n" "$1" "$($1 --version 2>&1 | head -1)" \
  || printf "  MISS %-12s -\n" "$1"; }
for t in uv python3 make pandoc Rscript quarto rg fd jq \
  tmux duckdb shellcheck shfmt; do check "$t"; done
```
