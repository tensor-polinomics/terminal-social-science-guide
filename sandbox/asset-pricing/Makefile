# Build the whole synthetic asset-pricing study as one
# dependency graph: a single `make` regenerates the data,
# forms the portfolio, draws the figure, runs the
# regression, and renders the report. This is the
# reproducibility showcase (PLAN.md Section 7, Chapter 12).
#
# Toolchain split: the Python steps (00-03) run anywhere,
# including the locked-down sandbox. The R step (04) and the
# Quarto render run on the Mac only (no R / Quarto in the
# sandbox). So `make $(FIG)` works in the sandbox, while a
# full `make` is a Mac target.
#
# Recipe lines are indented with a TAB, never spaces (the
# classic Make trap). Targets that share one recipe use the
# empty-rule idiom (a prerequisite with a bare `;`) so the
# generator runs once, not once per output.

PY      := uv run python
RSCRIPT := Rscript
QUARTO  := quarto

RAW_PANEL := data/raw/firm_panel.csv
RAW_FAC   := data/raw/factors.csv
ANALYSIS  := data/clean/analysis.parquet
PORT      := data/clean/portfolio.parquet
PORT_CSV  := data/clean/portfolio.csv
FIG       := output/figures/cumret.png
TAB       := output/tables/ff5_alpha.tex
TAB_TXT   := output/tables/ff5_alpha.txt
REPORT    := report.html
REPORT_PDF := report.pdf
REPORT_TEX := report.tex
REPORT_KNIT := report.knit.md

.PHONY: all check clean help

all: $(REPORT)

# 1. Seeded generator -> raw panel + factors. One recipe,
#    two outputs: factors.csv rides along with firm_panel.csv.
$(RAW_PANEL): scripts/00_make_data.py
	$(PY) scripts/00_make_data.py
$(RAW_FAC): $(RAW_PANEL) ;

# 2. Clean and rebuild the lagged signal -> analysis sample.
$(ANALYSIS): scripts/01_clean.py $(RAW_PANEL)
	$(PY) scripts/01_clean.py

# 3. Form the long-short portfolio. Two outputs again:
#    the .csv rides along with the .parquet.
$(PORT): scripts/02_portfolio.py $(ANALYSIS) $(RAW_FAC)
	$(PY) scripts/02_portfolio.py
$(PORT_CSV): $(PORT) ;

# 4. Figure (Python; runs in the sandbox).
$(FIG): scripts/03_figure.py $(PORT)
	$(PY) scripts/03_figure.py

# 5. Regression + table (R; MAC ONLY).
$(TAB): scripts/04_regression.R $(PORT_CSV)
	$(RSCRIPT) scripts/04_regression.R

# 6. Render the report (Quarto; MAC ONLY).
$(REPORT): report.qmd $(FIG) $(TAB)
	$(QUARTO) render report.qmd --to html

# Smoke checks: re-derive the hash + alpha, confirm outputs.
check: $(FIG) $(TAB)
	$(PY) scripts/check.py

clean:
	rm -f $(RAW_PANEL) $(RAW_FAC) $(ANALYSIS) $(PORT) \
	      $(PORT_CSV) $(FIG) $(TAB) $(TAB_TXT) \
	      $(REPORT) $(REPORT_PDF) $(REPORT_TEX) \
	      $(REPORT_KNIT)
	rm -rf report_files

help:
	@echo "make        build the study (-> report.html)"
	@echo "make check  re-derive hash + alpha, check files"
	@echo "make clean  remove generated files"
