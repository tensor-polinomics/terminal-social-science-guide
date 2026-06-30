# Canonical FF5 time-series regression + table.
#
# RUNS ON THE MAC, NOT THE SANDBOX. R, CRAN, and renv are
# unavailable in the locked-down workspace sandbox, so this
# step is executed on the Mac via the project renv (see
# renv.lock). It reads the long-short series produced by the
# Python half and writes the regression table the Quarto
# report embeds.
#
# Regress the self-financing long-short return on the five
# Fama-French factors. The intercept is the alpha: the part
# of the signal return the factors do not span. Default
# (iid) standard errors, matching the in-sandbox statsmodels
# cross-check used to lock the invariant.
#
#   ls_ret = alpha + b1 mkt_rf + b2 smb + b3 hml
#                  + b4 rmw + b5 cma + e
#
# Input:   data/clean/portfolio.csv  (git-ignored)
# Outputs: output/tables/ff5_alpha.tex
#          output/tables/ff5_alpha.txt

suppressPackageStartupMessages({
  library(fixest)
})

port <- read.csv("data/clean/portfolio.csv")

m <- feols(
  ls_ret ~ mkt_rf + smb + hml + rmw + cma,
  data = port
)

dir.create("output/tables", recursive = TRUE,
           showWarnings = FALSE)

labels <- c(
  "(Intercept)" = "Alpha (monthly)",
  "mkt_rf" = "Mkt-RF", "smb" = "SMB", "hml" = "HML",
  "rmw" = "RMW", "cma" = "CMA"
)

ct <- as.data.frame(coeftable(m))
ct$term <- labels[rownames(ct)]
names(ct)[1:4] <- c("estimate", "std_error", "t_stat", "p_value")
ct <- ct[, c("term", "estimate", "std_error", "t_stat", "p_value")]

stars <- function(p) {
  ifelse(p < 0.01, "***",
         ifelse(p < 0.05, "**",
                ifelse(p < 0.10, "*", "")))
}
fmt <- function(x) sprintf("%.4f", x)

txt_lines <- c(
  "FF5 regression of the long-short return",
  "",
  sprintf("%-16s %10s %10s %8s %8s",
          "Term", "Estimate", "Std.Err", "t", "p"),
  paste(rep("-", 58), collapse = "")
)
for (i in seq_len(nrow(ct))) {
  txt_lines <- c(txt_lines, sprintf(
    "%-16s %10s %10s %8.2f %8.3f",
    ct$term[i],
    paste0(fmt(ct$estimate[i]), stars(ct$p_value[i])),
    fmt(ct$std_error[i]),
    ct$t_stat[i],
    ct$p_value[i]
  ))
}
txt_lines <- c(
  txt_lines,
  "",
  sprintf("Observations: %d", nobs(m)),
  "SE type: iid"
)
writeLines(txt_lines, "output/tables/ff5_alpha.txt")

tex_rows <- sprintf(
  "%s & %s & %s & %.2f & %.3f \\\\",
  ct$term,
  paste0(fmt(ct$estimate), stars(ct$p_value)),
  fmt(ct$std_error),
  ct$t_stat,
  ct$p_value
)
tex_lines <- c(
  "\\begin{table}[!htbp]",
  "\\centering",
  "\\caption{FF5 regression of the long-short return}",
  "\\begin{tabular}{lrrrr}",
  "\\hline",
  "Term & Estimate & Std. Error & t & p \\\\",
  "\\hline",
  tex_rows,
  "\\hline",
  sprintf("\\multicolumn{5}{l}{Observations: %d; SE type: iid} \\\\",
          nobs(m)),
  "\\end{tabular}",
  "\\end{table}"
)
writeLines(tex_lines, "output/tables/ff5_alpha.tex")

# Echo the locked number for the Mac capture / invariant.
a <- coef(m)[["(Intercept)"]]
ta <- coef(m)[["(Intercept)"]] / se(m)[["(Intercept)"]]
cat(sprintf(
  "\nalpha (monthly) = %.4f   t = %.3f\n", a, ta))
cat(sprintf("alpha %%/mo = %.4f   nobs = %d\n",
            a * 100, nobs(m)))
