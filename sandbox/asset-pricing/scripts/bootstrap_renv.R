# Bootstrap the project R environment with renv. MAC ONLY.
#
# The sandbox cannot reach CRAN and has no R, so the R
# environment is created on the Mac. Run this once from the
# project root to produce renv.lock; thereafter
# `renv::restore()` rebuilds the exact package set:
#
#   Rscript scripts/bootstrap_renv.R
#
# It installs renv if missing, initializes a project-local
# library, installs the R packages used by the regression and
# Quarto report, and writes renv.lock. Commit renv.lock (not
# renv/library/).

if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos =
    "https://cloud.r-project.org")
}

# Bare init: a project library with no automatic snapshot,
# so we control exactly what gets pinned.
renv::init(bare = TRUE, restart = FALSE)

renv::install(c("fixest", "knitr", "rmarkdown"))

# Pin the packages used by the project and their dependencies
# to renv.lock. Avoid type = "all": it records unused base
# recommended packages and makes renv::status() noisy.
renv::snapshot(type = "implicit", prompt = FALSE)

cat("\nrenv.lock written. Verify with:",
    "\n  Rscript -e 'renv::status()'\n")
