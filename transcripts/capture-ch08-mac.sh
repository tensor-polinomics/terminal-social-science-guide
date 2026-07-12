#!/usr/bin/env bash
# Capture the Ch 8 (Text and tabular data as data) macOS/BSD
# facts on the user's Mac.
#
# Ch 8's portable/GNU output is captured in the book's Linux
# sandbox (ch08-*.txt). This script captures the BSD divergences
# and the DuckDB CLI runs a real Mac shows, which the sandbox
# cannot (DuckDB's CLI binary is not installable there):
#   1. ch08-sed-mac.txt         - BSD `sed -i` REQUIRES a backup
#      suffix argument (GNU makes it optional): the bare GNU
#      form fails, `-i ''` and `-i.bak` work. Run on a COPY of
#      factors.csv in a mktemp scratch, never on the real file.
#   2. ch08-awk-mac.txt         - the macOS awk version line
#      (BWK awk, not gawk), the SAME filter and column sum the
#      sandbox ran (the data is deterministic, so the sum should
#      match byte-for-byte), and one gawk-only call (systime())
#      recorded honestly whether it fails or works.
#   3. ch08-sort-locale-mac.txt - BSD `sort` under LC_ALL=C vs
#      LC_ALL=en_US.UTF-8 on the same nine project-root names
#      (rebuilt in scratch). Collation is defined by each
#      platform's own locale data; whichever order appears is
#      recorded honestly and compared with the sandbox.
#      Checksums use `shasum -a 256` (Ch 3 DIVERGENCE; no
#      sha256sum).
#   4. ch08-duckdb-mac.txt      - DuckDB CLI (REAL Mac capture,
#      user decision 2026-07-02): version, a SELECT and a
#      DESCRIBE over the raw CSVs, a firm_panel x factors join,
#      and a Parquet count. Read-only SELECTs; no database file
#      is created.
#
# Run on the Mac, from the terminal repo root
# (source-private/terminal), the way ch02/ch03/ch05 were run:
#   bash transcripts/capture-ch08-mac.sh
# then review the four ch08-*-mac.txt files it writes and paste
# them back (or just say "done" and let the chapter be
# reconciled against them).
#
# Requirements: the running example's data files must exist
# (sandbox/asset-pricing/data/raw/*.csv and
# data/clean/portfolio.parquet; run `make` in
# sandbox/asset-pricing first if they do not), and `duckdb`
# must be on PATH. The script checks both and says what is
# missing. It works read-only against the project; the only
# writes are ONE mktemp scratch (removed on exit) and the
# transcripts/ folder.

# NOT set -e: a missing tool or a nonzero demo (the failing BSD
# `sed -i`) must be recorded, not fatal.
set -uo pipefail

# Quiet the recurring environment-noise lines (G2 convention).
unset VIRTUAL_ENV
export RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE

# PRIVACY MASK, applied AT CAPTURE TIME (public-repo scrub,
# transcripts/README.md; copied from capture-ch05-mac.sh incl.
# the $TMPDIR folder-hash scrub). These demos print no owner
# columns, but error messages and resolved paths can expose the
# home path, the account name, or the per-account $TMPDIR hash,
# so all three masks are applied to every captured line.
acct="$(id -un)"
mask() {
  sed -E \
    -e "s|${HOME}|/Users/[account]|g" \
    -e "s|(/private)?/var/folders/[^/]+/[^/]+|/private/var/folders/[tmpdir]|g" \
    -e "s|${acct}|[account]|g"
}

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/.." && pwd)"
proj="$root/sandbox/asset-pricing"

sout="$here/ch08-sed-mac.txt"
aout="$here/ch08-awk-mac.txt"
lout="$here/ch08-sort-locale-mac.txt"
dout="$here/ch08-duckdb-mac.txt"

os_name="$(sw_vers -productName 2>/dev/null || echo macOS)"
os_ver="$(sw_vers -productVersion 2>/dev/null || echo '?')"
zver="$(zsh --version 2>/dev/null || echo 'zsh: not found')"
today="$(date +%F)"

hdr() {
  # hdr <toolline> <noteline...>
  echo "# transcript"
  echo "chapter: 08"
  echo "os: ${os_name} ${os_ver} (Apple Silicon)"
  echo "shell: ${zver} (login default)"
  echo "tool: $1"
  echo "date: ${today}"
  echo "captured-by: user-mac"
  shift
  for ln in "$@"; do echo "note: ${ln}"; done
  echo "---"
}

# Preflight: data files and duckdb.
missing=0
for f in "$proj/data/raw/factors.csv" \
  "$proj/data/raw/firm_panel.csv" \
  "$proj/data/clean/portfolio.parquet"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f (run \`make\` in sandbox/asset-pricing)" >&2
    missing=1
  fi
done
if ! command -v duckdb >/dev/null 2>&1; then
  echo "MISSING: duckdb not on PATH (brew install duckdb)" >&2
  missing=1
fi
[ "$missing" -eq 1 ] && exit 1

# A scratch directory we fully own; removed on exit.
scratch="$(mktemp -d "${TMPDIR:-/tmp}/ch08mac.XXXXXX")"
cleanup() { rm -rf "$scratch"; }
trap cleanup EXIT

# --- 1. BSD sed -i: the backup suffix is REQUIRED -------------
{
  hdr "BSD sed (macOS base)" \
    "BSD \`sed -i\` requires a backup-suffix argument; GNU sed" \
    "makes it optional. The bare GNU form therefore FAILS on" \
    "macOS (recorded with its real error and exit status)," \
    "\`-i ''\` edits with no backup, and \`-i.bak\` keeps one." \
    "Run on a COPY of factors.csv in a mktemp scratch, never" \
    "on the project's raw file. No user data in these lines."
  cd "$scratch" || exit 1
  cp "$proj/data/raw/factors.csv" .
  echo ""
  echo "\$ head -1 factors.csv"
  head -1 factors.csv | mask
  echo ""
  echo "\$ sed -i 's/mkt_rf/mkt_excess/' factors.csv"
  # </dev/null guards against any stdin read; capture output
  # and status from the SAME run, then mask.
  out="$(sed -i 's/mkt_rf/mkt_excess/' factors.csv \
    </dev/null 2>&1)"
  st=$?
  printf '%s\n' "$out" | mask
  echo "\$ echo \$?"
  echo "$st"
  echo ""
  echo "\$ sed -i '' 's/mkt_rf/mkt_excess/' factors.csv"
  sed -i '' 's/mkt_rf/mkt_excess/' factors.csv 2>&1 | mask
  echo "\$ head -1 factors.csv"
  head -1 factors.csv | mask
  echo "\$ ls"
  ls | mask
  echo ""
  echo "\$ sed -i.bak 's/mkt_excess/mkt_rf/' factors.csv"
  sed -i.bak 's/mkt_excess/mkt_rf/' factors.csv 2>&1 | mask
  echo "\$ ls"
  ls | mask
  echo "\$ head -1 factors.csv"
  head -1 factors.csv | mask
} >"$sout"

# --- 2. macOS awk: BWK awk, same shallow subset, gawk-ism -----
{
  hdr "macOS awk (BWK awk, macOS base)" \
    "macOS ships BWK awk (the \"one true awk\"), not gawk. The" \
    "shallow subset Ch 8 teaches (fields, a filter, a sum) is" \
    "portable: the same commands on the same deterministic" \
    "factors.csv should print the same numbers as the sandbox" \
    "gawk run (ch08-awk.txt). A gawk-only extension" \
    "(systime()) is then run and recorded honestly, working or" \
    "failing. No user data in these lines."
  cd "$proj" || exit 1
  echo ""
  echo "\$ awk --version"
  awk --version 2>&1 | mask
  echo ""
  echo "\$ awk -F, 'NR > 1 && \$2 > 0.05' data/raw/factors.csv \\"
  echo "    | wc -l"
  awk -F, 'NR > 1 && $2 > 0.05' data/raw/factors.csv \
    | wc -l | mask
  echo ""
  echo "\$ awk -F, 'NR > 1 {s += \$2} END {print s/(NR-1)}' \\"
  echo "    data/raw/factors.csv"
  awk -F, 'NR > 1 {s += $2} END {print s/(NR-1)}' \
    data/raw/factors.csv | mask
  echo ""
  echo "\$ awk 'BEGIN {print systime()}'; echo \"exit=\$?\""
  out="$(awk 'BEGIN {print systime()}' </dev/null 2>&1)"
  st=$?
  printf '%s\n' "$out" | mask
  echo "exit=$st"
} >"$aout"

# --- 3. BSD sort under LC_ALL: locale and platform ------------
{
  hdr "BSD sort (macOS base); shasum -a 256" \
    "The same nine project-root names the sandbox sorted" \
    "(ch08-locale.txt), rebuilt in scratch, sorted under" \
    "LC_ALL=C and LC_ALL=en_US.UTF-8 on BSD sort. Collation" \
    "is defined by each platform's own locale data, so" \
    "whichever order appears is recorded honestly and" \
    "compared with the sandbox listing. Checksums" \
    "via \`shasum -a 256\` (macOS has no sha256sum, the Ch 3" \
    "DIVERGENCE). No user data in these lines."
  cd "$scratch" || exit 1
  mkdir -p rootnames
  cd rootnames || exit 1
  mkdir -p data output scripts
  touch Makefile README.md pyproject.toml renv.lock \
    report.qmd uv.lock
  echo ""
  echo "\$ ls | LC_ALL=C sort"
  ls | LC_ALL=C sort | mask
  echo ""
  echo "\$ ls | LC_ALL=en_US.UTF-8 sort"
  ls | LC_ALL=en_US.UTF-8 sort | mask
  echo ""
  echo "\$ ls | LC_ALL=C sort | shasum -a 256"
  ls | LC_ALL=C sort | shasum -a 256 | mask
  echo ""
  echo "\$ ls | LC_ALL=en_US.UTF-8 sort | shasum -a 256"
  ls | LC_ALL=en_US.UTF-8 sort | shasum -a 256 | mask
} >"$lout"

# --- 4. DuckDB CLI: SQL over the project's CSVs and Parquet ---
{
  hdr "DuckDB CLI ($(duckdb --version 2>/dev/null | head -1))" \
    "REAL Mac capture (user decision 2026-07-02): the DuckDB" \
    "CLI is not installable in the locked-down sandbox, so its" \
    "output comes from the user's Mac. All queries are" \
    "read-only SELECTs against the running example's raw CSVs" \
    "and cleaned Parquet; no database file is created. The" \
    "data is the deterministic generator output (hash-locked)," \
    "so counts and values should match the sandbox CSVs. No" \
    "user data in these lines."
  cd "$proj" || exit 1
  echo ""
  echo "\$ duckdb --version"
  duckdb --version 2>&1 | mask
  echo ""
  # -csv output: the CLI's default "duckbox" table draws
  # Unicode box glyphs, which the book's LaTeX PDF drops (the
  # Ch 6 render lesson), and CSV output composes with the rest
  # of the chapter's tools anyway.
  echo "\$ duckdb -csv -c \"SELECT month, mkt_rf \\"
  echo "    FROM 'data/raw/factors.csv' LIMIT 3;\""
  duckdb -csv -c "SELECT month, mkt_rf \
    FROM 'data/raw/factors.csv' LIMIT 3;" 2>&1 | mask
  echo ""
  echo "\$ duckdb -csv -c \"DESCRIBE SELECT * \\"
  echo "    FROM 'data/raw/firm_panel.csv';\""
  duckdb -csv -c "DESCRIBE SELECT * \
    FROM 'data/raw/firm_panel.csv';" 2>&1 | mask
  echo ""
  echo "\$ duckdb -csv -c \"SELECT count(*) AS n_rows, \\"
  echo "    count(DISTINCT firm) AS n_firms \\"
  echo "    FROM 'data/raw/firm_panel.csv';\""
  duckdb -csv -c "SELECT count(*) AS n_rows, \
    count(DISTINCT firm) AS n_firms \
    FROM 'data/raw/firm_panel.csv';" 2>&1 | mask
  echo ""
  echo "\$ duckdb -csv <<'SQL'"
  echo "SELECT p.month, avg(p.ret) AS mean_ret, f.mkt_rf"
  echo "FROM 'data/raw/firm_panel.csv' p"
  echo "JOIN 'data/raw/factors.csv' f USING (month)"
  echo "GROUP BY p.month, f.mkt_rf"
  echo "ORDER BY p.month"
  echo "LIMIT 3;"
  echo "SQL"
  duckdb -csv <<'SQL' 2>&1 | mask
SELECT p.month, avg(p.ret) AS mean_ret, f.mkt_rf
FROM 'data/raw/firm_panel.csv' p
JOIN 'data/raw/factors.csv' f USING (month)
GROUP BY p.month, f.mkt_rf
ORDER BY p.month
LIMIT 3;
SQL
  echo ""
  echo "\$ duckdb -csv -c \"SELECT count(*) AS n_months \\"
  echo "    FROM 'data/clean/portfolio.parquet';\""
  duckdb -csv -c "SELECT count(*) AS n_months \
    FROM 'data/clean/portfolio.parquet';" 2>&1 | mask
} >"$dout"

echo "captured -> $sout"
echo "captured -> $aout"
echo "captured -> $lout"
echo "captured -> $dout"
