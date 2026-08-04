# Replicate Table 1 of Bower-Bir (2021), "Earning our place, more or less."
# Economia Politica 38(1): 131-170. https://doi.org/10.1007/s40888-020-00201-9
#
# Base R only -- no packages. lm() with weights, plus a hand-rolled sandwich
# estimator, so this runs on a bare R install.
#   Rscript replicate_table1.R
#
# See replicate_table1.py for the full commentary. The four traps in brief:
#
#  1. The DV ships standardized to [0,1] (Data Cleaning II line 297 applies
#     (x+1)/2), but Table 1 reports it on [-1,1]. Undo it: dv = x * 2 - 1.
#     Skip this and every coefficient is exactly half the published value.
#
#  2. The variable named `neoliberal` runs BACKWARDS from its name. Data
#     Cleaning I lines 95-102 flip the four constituent items so that "(+)
#     values [are] liberal"; `neoliberal` is their average. So higher
#     `neoliberal` = LESS neoliberal. Table 1's "Neoliberal" row is the
#     coefficient on the flipped index (`neoliberal_cons` in the original,
#     definitions_agency_ORIGINAL.do line 3). Unflipped you get +0.182 where
#     the paper prints -0.182 -- and the constant still matches, so it is easy
#     to miss. Same flip for the four constituents in models 1b/2b/3b.
#
#  3. The duplicated submission (id 1115/1157, identical on all but `id`) is
#     dropped by the published models: keeping it gives N=954/672 vs the
#     published 953/671. See ../data/PROVENANCE.md.
#
#  4. Stata `svy: reg` with only a pweight = HC0 sandwich scaled by n/(n-1).
#     The published "Adj-R 2" row is plain R-squared, not adjusted.

DATA <- "../../data/economic_justice_v7_analysis-weighted.csv"

d <- read.csv(DATA, stringsAsFactors = FALSE)

# --- Trap 1: recover the published [-1,1] dependent variable -----------------
d$dv <- d$corr_ideal_agency * 2 - 1

# --- Trap 2: flip the neoliberal index and its constituents ------------------
# so that HIGHER = MORE neoliberal, the orientation Table 1 reports.
d$neo_c     <- -d$neoliberal
d$profits_c <- -d$profits_benefit
d$gov_c     <- -d$gov_stayout
d$help_c    <- -d$help_self
d$diff_c    <- -d$diff_incentives

# --- Trap 3: drop the duplicated submission ---------------------------------
# Identify it by content (every column except `id`), not by row position.
cmp <- d[, setdiff(names(d), "id")]
d <- d[!duplicated(cmp), ]

FULL <- c("ideo_str", "party_str", "religiosity", "theology", "nonwhite",
          "female", "gay_strict", "income_household", "school_ivy",
          "education", "age", "urban", "south")
models <- list(
  "1a" = c(FULL, "neo_c"),
  "2a" = c("ideo_str", "religiosity", "nonwhite", "income_household",
           "school_ivy", "age", "south", "neo_c"),
  "3a" = c("nonwhite", "income_household", "school_ivy", "age", "neo_c"),
  "1b" = c(FULL, "profits_c", "gov_c", "help_c", "diff_c"),
  "2b" = c("religiosity", "nonwhite", "income_household", "school_ivy", "age",
           "south", "help_c", "diff_c"),
  "3b" = c("nonwhite", "income_household", "school_ivy", "age", "help_c",
           "diff_c")
)
pub_n  <- c("1a" = 671, "2a" = 953, "3a" = 953, "1b" = 671, "2b" = 953, "3b" = 953)
pub_r2 <- c("1a" = 0.1978, "2a" = 0.1288, "3a" = 0.1193,
            "1b" = 0.2320, "2b" = 0.1467, "3b" = 0.1382)

# Stata `svy: reg` linearized SE: HC0 sandwich, scaled by n/(n-1).
# With pweights, lm(weights=w) gives the same point estimates as Stata's [pw=w];
# only the variance needs building by hand.
svy_se <- function(fit, X, w, resid) {
  n <- nrow(X)
  bread <- solve(t(X) %*% (X * w))            # (X' W X)^-1
  meat <- t(X) %*% (X * (w^2 * resid^2))      # X' W^2 e^2 X
  V <- bread %*% meat %*% bread
  sqrt(diag(V) * n / (n - 1))
}

stars <- function(p) {
  if (p < 0.01) "***" else if (p < 0.05) "**" else if (p < 0.10) "*" else ""
}

cat("Table 1 -- Bower-Bir (2021), Economia Politica 38(1):131-170\n")
cat("Base-R replication. DV = corr_ideal_agency rescaled to [-1,1].\n")
cat("'Neoliberal'/constituent rows are the sign-flipped (_cons) variables.\n\n")

for (nm in names(models)) {
  xs <- models[[nm]]
  s <- d[, c("dv", "post_weight", xs)]
  s <- s[complete.cases(s), ]                 # listwise deletion, as Stata does

  f <- as.formula(paste("dv ~", paste(xs, collapse = " + ")))
  fit <- lm(f, data = s, weights = s$post_weight)

  X <- model.matrix(fit)
  se <- svy_se(fit, X, s$post_weight, residuals(fit))
  n <- nrow(s)
  b <- coef(fit)
  p <- 2 * pt(abs(b / se), df = n - 1, lower.tail = FALSE)  # svy df = n - 1

  # Weighted R-squared, centred on the weighted mean -- this is the quantity the
  # published table prints in its (mislabelled) "Adj-R 2" row.
  yhat <- fitted(fit); w <- s$post_weight; y <- s$dv
  mw <- sum(w * y) / sum(w)
  r2 <- 1 - sum(w * (y - yhat)^2) / sum(w * (y - mw)^2)

  cat(sprintf("=== Model %s   N=%d (published %d) %s   R2=%.4f (published %.4f) %s\n",
              nm, n, pub_n[[nm]], ifelse(n == pub_n[[nm]], "OK", "MISMATCH"),
              r2, pub_r2[[nm]], ifelse(round(r2, 4) == pub_r2[[nm]], "OK", "MISMATCH")))
  for (i in seq_along(b)) {
    cat(sprintf("    %-18s %8.3f (%.3f) %s\n",
                names(b)[i], b[i], se[i], stars(p[i])))
  }
  cat("\n")
}

cat(paste(rep("-", 70), collapse = ""), "\n")
cat("Known published defects this script does NOT reproduce (it prints the\n")
cat("correct values; see README Corrigendum):\n")
cat("  Model 1b party_str SE  -- published (0.0073), correct (0.073)\n")
cat("  Model 1b female SE     -- published (0.023),  correct (0.027)\n")
cat("  Model 3b income stars  -- published ***,      correct ** (p=0.0104)\n")
