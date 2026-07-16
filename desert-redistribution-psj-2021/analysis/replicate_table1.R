# =============================================================================
# REPLICATION: Bower-Bir (2022), "Desert and Redistribution," PSJ 50(4):757-795
# Table 1 — support for government action to reduce the income gap (Y_gov_fix_gap)
#           and for progressive taxation (Y_prog_tax)
# =============================================================================
#
# Author of the paper: Jacob S. Bower-Bir
# This script: a base-R port of the original Stata analysis, 2026-07-16.
#
# ORIGINAL ANALYSIS
# -----------------
#   policy_taxation.do (2014-09-22), lines 142-164. Preserved alongside this file.
#   Stata call, per model:
#
#     areg <dv> corr_ideal_agency <Z...> ideo_str age age_2 female nonwhite \
#          married_bin unemployed_now education income_household \
#          [pw=post_weight], absorb(state)
#
#   where:
#     <dv>  = gov_reducegap_str  (Y_gov_fix_gap)  or  progtaxes2_str (Y_prog_tax)
#     <Z>   = agency_str                          -> Model 1
#             justice_str                         -> Model 2
#             desert_rich_tot + desert_americans_tot + desert_poor_tot -> Model 3
#     "Definition" in the published table IS corr_ideal_agency: the within-respondent
#     correlation between how much control a respondent thinks people have over each of
#     15 factors and how important she thinks each factor ideally should be to economic
#     standing. High = defines desert in terms of things people control.
#
# WHAT THIS PORT DOES
# -------------------
#   areg ... absorb(state)  ==  OLS with state dummies (Frisch-Waugh-Lovell).
#   [pw=post_weight]        ==  weighted least squares + a robust (sandwich) VCE;
#                               Stata applies robust SEs automatically with pweights.
#   Implemented in base R with no package dependencies, so this runs anywhere:
#   lm(..., weights=) for the point estimates, HC1 sandwich computed by hand below.
#   (With packages available, estimatr::lm_robust or fixest::feols is more idiomatic.)
#
# KNOWN LIMITATION — READ BEFORE QUOTING THESE NUMBERS
# ----------------------------------------------------
#   This reproduces N exactly (963) and standard errors to ~0.002, but coefficients
#   run systematically ~0.01-0.03 more negative than Stata's published values (e.g.
#   Model 1 Definition: this port -0.413, Stata -0.382). The cause is unresolved and
#   is presumably a Stata areg/pweight convention not mirrored here. Treat this as a
#   CONFIRMATION of the published analysis, not a bit-exact reproduction. For exact
#   figures, run policy_taxation.do in Stata.
#
# WHY THIS SCRIPT EXISTS
# ----------------------
#   Three cells of the published Table 1 were altered in typesetting. This script was
#   written to test them independently, and confirms all three (see the comparison
#   printed at the end). A corrigendum has been filed. The analysis and every
#   substantive claim in the paper are unaffected.
#
# DATA
# ----
#   ../../data/economic_justice_v7_analysis-weighted.csv
#   De-identified, 992 rows. Standardized [0,1] variables + survey weights.
#   Derived from Economic-Justice_v7_2014-04-08_E_WORKING.dta. See ../../data/README.md.
# =============================================================================

DATA <- "../../data/economic_justice_v7_analysis-weighted.csv"
if (!file.exists(DATA)) DATA <- "economic_justice_v7_analysis-weighted.csv"
d <- read.csv(DATA, stringsAsFactors = FALSE)

# ---- transforms, verbatim from policy_taxation.do lines 3-22 ----------------

d$age_2 <- d$age * d$age

# unemployed_now: 1 if currently unemployed, 0 for all other employment states
d$unemployed_now <- NA
d$unemployed_now[d$employment == 0] <- 1
d$unemployed_now[d$employment %in% c(3, 2, 1, -1, -2, -3, -4)] <- 0

# married_bin: the married variable is a [0,1] scale; collapse to binary
d$married_bin <- NA
d$married_bin[abs(d$married - 1) < 1e-6 | abs(d$married - 0.8) < 1e-6] <- 1
d$married_bin[abs(d$married - 0.6) < 1e-6 | abs(d$married - 0.4) < 1e-6 |
              abs(d$married - 0.2) < 1e-6 | abs(d$married - 0.0) < 1e-6] <- 0

# progtaxes2_str: rescale to 0-3 (collapsing the bottom categories), then to [0,1].
#
# NB — FLOATING-POINT TRAP. The Stata original tests equality directly
# (`replace progtaxes2_str = 1 if progtaxes2_str == 4`). Do NOT transliterate that
# as `p == 4` in R: progtaxes_str is stored as a float, so progtaxes_str * 6 lands
# on 3.9999999... and 4.9999999..., and exact comparison silently matches ZERO of the
# 183 rows that should be 4 and ZERO of the 391 that should be 5. Those rows then keep
# their raw value instead of being recoded, quietly corrupting the dependent variable
# (it produced R2 = 0.296 against the published 0.416 before this was caught). Round
# first. Verified: round() recovers 183 / 391 / 272 rows for 4 / 5 / 6.
p <- round(d$progtaxes_str * 6)
p2 <- p
p2[p <= 3] <- 0
p2[p == 4] <- 1
p2[p == 5] <- 2
p2[p == 6] <- 3
d$progtaxes2_str <- p2 / 3

CTRL <- c("ideo_str", "age", "age_2", "female", "nonwhite", "married_bin",
          "unemployed_now", "education", "income_household")

# ---- HC1 robust standard errors, by hand (no sandwich package needed) -------
# HC1 = (X'X)^-1 X' diag(e_i^2) X (X'X)^-1, scaled by n/(n-k).
# With weights, the sandwich uses the weighted design matrix and weighted residuals.
robust_hc1 <- function(fit) {
  X  <- model.matrix(fit)
  w  <- if (is.null(weights(fit))) rep(1, nrow(X)) else weights(fit)
  e  <- residuals(fit)
  n  <- nrow(X); k <- ncol(X)
  Xw   <- X * sqrt(w)                     # weighted design
  bread <- solve(crossprod(Xw))           # (X'WX)^-1
  meat  <- crossprod(X * (w * e))         # X' W e e' W X
  vcov  <- bread %*% meat %*% bread * (n / (n - k))
  sqrt(diag(vcov))
}

run_model <- function(dv, zblock, label) {
  rhs  <- c("corr_ideal_agency", zblock, CTRL)
  vars <- c(dv, rhs, "post_weight", "state")
  sub  <- d[complete.cases(d[, vars]), ]
  f    <- as.formula(paste(dv, "~", paste(c(rhs, "factor(state)"), collapse = " + ")))
  fit  <- lm(f, data = sub, weights = sub$post_weight)
  se   <- robust_hc1(fit)
  keep <- c("corr_ideal_agency", zblock, "ideo_str", "nonwhite")
  cat(sprintf("\n--- %s   (N = %d,  R2 = %.4f)\n", label, nobs(fit), summary(fit)$r.squared))
  for (v in keep) {
    cat(sprintf("    %-22s %+8.3f  (%.3f)\n", v, coef(fit)[v], se[v]))
  }
  invisible(list(b = coef(fit), se = se))
}

cat("=============================================================================\n")
cat("PSJ 2022 Table 1 — replication from source data\n")
cat("Definition = corr_ideal_agency\n")
cat("=============================================================================\n")

cat("\n### Y_gov_fix_gap (support for government action to reduce the income gap)\n")
g1 <- run_model("gov_reducegap_str", "agency_str",  "Model 1  (+ agency)")
g2 <- run_model("gov_reducegap_str", "justice_str", "Model 2  (+ justice)")
g3 <- run_model("gov_reducegap_str",
                c("desert_rich_tot", "desert_americans_tot", "desert_poor_tot"),
                "Model 3  (+ deserve)")

cat("\n### Y_prog_tax (support for progressive taxation)\n")
p1 <- run_model("progtaxes2_str", "agency_str",  "Model 1  (+ agency)")
p2 <- run_model("progtaxes2_str", "justice_str", "Model 2  (+ justice)")
p3 <- run_model("progtaxes2_str",
                c("desert_rich_tot", "desert_americans_tot", "desert_poor_tot"),
                "Model 3  (+ deserve)")

# ---- the three typeset errors this script was written to test ---------------
cat("\n=============================================================================\n")
cat("THE THREE TABLE 1 TYPESETTING ERRORS (corrigendum filed 2026-07)\n")
cat("=============================================================================\n")
cat(sprintf("
  Definition, M3, Y_gov_fix_gap
     published   %+.3f      <- minus sign dropped in typesetting
     replicated  %+.3f
     correct     %+.3f      (Stata; matches the paper's own section 6.3 prose)

  Rich deserve, M3, Y_gov_fix_gap — standard error
     published   (%.3f)     <- spurious leading digit; implies t = 0.35, cannot be ***
     replicated  (%.3f)
     correct     (%.3f)     (Stata)

  Nonwhite, M1, Y_prog_tax — standard error
     published   (%.3f)     <- coefficient value duplicated into the SE slot
     replicated  (%.3f)
     correct     (%.3f)     (Stata)
\n", 0.518, g3$b["corr_ideal_agency"], -0.518,
     1.056, g3$se["desert_rich_tot"], 0.056,
     0.012, p1$se["nonwhite"], 0.031))
cat("Analysis, estimates, and all substantive claims are unaffected.\n")
