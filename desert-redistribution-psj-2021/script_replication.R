#!/usr/bin/env Rscript
# =============================================================================
# Reproduces every table and figure in Bower-Bir (2022), "Desert and
# redistribution: Justice as a remedy for, and cause of, economic inequality",
# Policy Studies Journal 50(4): 757-795. Base R only. script_replication.py is
# the same program in Python.
#
# Reads, from this folder:
#   data_survey_psj-subset.csv   992 respondents, the 27 survey variables the
#                                tables and figures use
#   tables_as-published.md       the tables as printed, for the comparison at
#                                the end (skipped if the file is absent)
#
# Writes, to this folder:
#   tables_corrected_R.md        Tables 1, A1, C1, C2, D1, and the eight
#                                regressions behind Figures D1 and D2, on the
#                                published sample (992 rows, 2014 weight), with
#                                a list of every printed cell that differs
#                                appended at the end
#   tables_final_R.md            the same tables on the 991 distinct
#                                respondents with the survey weight corrected,
#                                ending with every cell that changes at the
#                                printed precision
#   tables_corrected-cells_R.md  the printed cells that differ from the re-run,
#                                one line each (written only when
#                                tables_as-published.md is present)
#   figure_1_R.png, figure_*_published-sample_R.png, figure_*_final-data_R.png
#                                the six figures: Figure 1 once, the other
#                                five from each data set
#
# Sections, in order:
#   1. The data and the two corrections it needs
#   2. Variables the regressions build
#   3. The 32 table regressions and Table A1
#   4. The survey weight, re-raked
#   5. Figures
#   6. The final tables and the list of cells that change
#   7. Comparison with the printed tables
#
# Run from this folder:  Rscript script_replication.R
# Takes under a minute.
#
# Two things carried over from the 2014 Stata code on purpose:
#   - The Stata code recodes by exact comparison (`married == .8`). Here the
#     values are rounded to the integer grid first, because 0.8 is stored as
#     0.7999... and an exact test matches no rows.
#   - The interaction terms are built on Definition rescaled to 0-1 (the Stata
#     stored them under the unscaled names), and the Definition main effect is
#     the rescaled variable in two of the six Table D1 regressions (Y_gov
#     Model 1, Y_prog_tax Model 3) and the raw one in the other four. That is
#     how the article's tables were estimated.
# =============================================================================


# ---- 1. The data and the two corrections it needs ----------------------------

OUT <- "tables_corrected_R.md"
d   <- read.csv("data_survey_psj-subset.csv")

# One respondent's record is in the file twice (rows identical in every
# answer). The published tables were estimated with it, and with a survey
# weight whose lowest income stratum was drawn one bracket too high (see
# rake() below). Every table is therefore estimated twice: on all 992 rows
# with the 2014 weight, which reproduces the published tables, and on the 991
# rows without the duplicate with the weight re-raked on the corrected strata,
# written to a second file with a list of every cell that changes at the
# printed precision.
dup_row <- which(duplicated(d[, setdiff(names(d), c("row", "id"))]))


# ---- 2. Variables the regressions build ---------------------------------------
# Every scale in the file is stored on a 0-1 grid. Where a recode needs the
# original answer codes, the scale is multiplied back and rounded first.

d$age_2 <- d$age * d$age

# employment: 0 is unemployed; the other seven codes are the employed, retired,
# student, homemaker, and other categories
d$unemployed_now <- ifelse(d$employment == 0, 1,
                    ifelse(d$employment %in% c(3, 2, 1, -1, -2, -3, -4), 0, NA))

# married: six codes 0-5; 4 (living with partner) and 5 (married) count as married
m <- round(d$married * 5)
d$married_bin <- ifelse(m >= 4, 1, 0)

# progressive taxation: seven codes 0-6; the four lowest collapse into one, so
# the outcome has four levels, 0, 1/3, 2/3, 1
p <- round(d$progtaxes_str * 6)
d$progtaxes2_str <- ifelse(p <= 3, 0, p - 3) / 3

# Definition (a correlation, -1 to 1) rescaled to 0-1 for the interaction terms
d$def_scaled <- (d$corr_ideal_agency + 1) / 2

Z_ALL <- c("agency_str", "justice_str",
           "desert_rich_tot", "desert_americans_tot", "desert_poor_tot")
for (z in Z_ALL) d[[paste0("x_", z)]] <- d[[z]] * d$def_scaled

CTRL  <- c("ideo_str", "age", "age_2", "female", "nonwhite", "married_bin",
           "unemployed_now", "education", "income_household")
EXTRA <- c("goodlife_future", "gov_help_str", "charity_str")
DES   <- c("desert_rich_tot", "desert_americans_tot", "desert_poor_tot")
DEF   <- "corr_ideal_agency"
DEFS  <- "def_scaled"
GOV   <- "gov_reducegap_str"
TAX   <- "progtaxes2_str"

# the full desert block with its three interactions, as the .do orders it
DES_X <- c("desert_rich_tot", "x_desert_rich_tot",
           "desert_americans_tot", "x_desert_americans_tot",
           "desert_poor_tot", "x_desert_poor_tot")

# each variable's row label in the article; raw and rescaled Definition share
# one row
ROW <- c(corr_ideal_agency = "Definition",     def_scaled = "Definition",
         agency_str = "Agency",                justice_str = "Justice",
         desert_rich_tot = "Rich deserve",
         desert_americans_tot = "Avg. deserve",
         desert_poor_tot = "Poor deserve",
         x_agency_str = "Def. x Agency",       x_justice_str = "Def. x Justice",
         x_desert_rich_tot = "Def. x Rich",
         x_desert_americans_tot = "Def. x Avg.",
         x_desert_poor_tot = "Def. x Poor",
         goodlife_future = "Good life",        gov_help_str = "Gov. help",
         charity_str = "Charity",              ideo_str = "Ideology",
         age = "Age",                          age_2 = "Age^2",
         female = "Female",                    nonwhite = "Nonwhite",
         married_bin = "Married",              unemployed_now = "Unemployed",
         education = "Education",              income_household = "Income")

# the order the rows take in every table
ORDER <- c("Definition", "Agency", "Def. x Agency", "Justice", "Def. x Justice",
           "Rich deserve", "Def. x Rich", "Avg. deserve", "Def. x Avg.",
           "Poor deserve", "Def. x Poor", "Good life", "Gov. help", "Charity",
           "Ideology", "Age", "Age^2", "Female", "Nonwhite", "Married",
           "Unemployed", "Education", "Income", "Constant")

stars <- function(p) {
  ifelse(p < 0.01, "***", ifelse(p < 0.05, "**", ifelse(p < 0.10, "*", "")))
}


# ---- 3. The 32 table regressions and Table A1 ---------------------------------
# (table, column, outcome, predictors)

M <- list(
  list("Table 1", "Y_gov Model 1", GOV, c(DEF, "agency_str", CTRL)),
  list("Table 1", "Y_gov Model 2", GOV, c(DEF, "justice_str", CTRL)),
  list("Table 1", "Y_gov Model 3", GOV, c(DEF, DES, CTRL)),
  list("Table 1", "Y_tax Model 1", TAX, c(DEF, "agency_str", CTRL)),
  list("Table 1", "Y_tax Model 2", TAX, c(DEF, "justice_str", CTRL)),
  list("Table 1", "Y_tax Model 3", TAX, c(DEF, DES, CTRL)),

  list("Table C1: Y_gov_fix_gap", "gov Model A", GOV, CTRL),
  list("Table C1: Y_gov_fix_gap", "gov Model B", GOV, c(DEF, CTRL)),
  list("Table C1: Y_gov_fix_gap", "gov Model C", GOV, c("agency_str", CTRL)),
  list("Table C1: Y_gov_fix_gap", "gov Model D", GOV, c("justice_str", CTRL)),
  list("Table C1: Y_gov_fix_gap", "gov Model E", GOV, c(DES, CTRL)),
  list("Table C1: Y_prog_tax",    "tax Model A", TAX, CTRL),
  list("Table C1: Y_prog_tax",    "tax Model B", TAX, c(DEF, CTRL)),
  list("Table C1: Y_prog_tax",    "tax Model C", TAX, c("agency_str", CTRL)),
  list("Table C1: Y_prog_tax",    "tax Model D", TAX, c("justice_str", CTRL)),
  list("Table C1: Y_prog_tax",    "tax Model E", TAX, c(DES, CTRL)),

  list("Table C2: Y_gov_fix_gap", "gov Model A", GOV, c(EXTRA, CTRL)),
  list("Table C2: Y_gov_fix_gap", "gov Model B", GOV, c(DEF, EXTRA, CTRL)),
  list("Table C2: Y_gov_fix_gap", "gov Model C", GOV,
       c(DEF, "agency_str", EXTRA, CTRL)),
  list("Table C2: Y_gov_fix_gap", "gov Model D", GOV,
       c(DEF, "justice_str", EXTRA, CTRL)),
  list("Table C2: Y_gov_fix_gap", "gov Model E", GOV, c(DEF, DES, EXTRA, CTRL)),
  list("Table C2: Y_prog_tax",    "tax Model A", TAX, c(EXTRA, CTRL)),
  list("Table C2: Y_prog_tax",    "tax Model B", TAX, c(DEF, EXTRA, CTRL)),
  list("Table C2: Y_prog_tax",    "tax Model C", TAX,
       c(DEF, "agency_str", EXTRA, CTRL)),
  list("Table C2: Y_prog_tax",    "tax Model D", TAX,
       c(DEF, "justice_str", EXTRA, CTRL)),
  list("Table C2: Y_prog_tax",    "tax Model E", TAX, c(DEF, DES, EXTRA, CTRL)),

  list("Table D1: Y_gov_fix_gap", "gov Model 1", GOV,
       c(DEFS, "agency_str", "x_agency_str", CTRL)),
  list("Table D1: Y_gov_fix_gap", "gov Model 2", GOV,
       c(DEF, "justice_str", "x_justice_str", CTRL)),
  list("Table D1: Y_gov_fix_gap", "gov Model 3", GOV, c(DEF, DES_X, CTRL)),
  list("Table D1: Y_prog_tax",    "tax Model 1", TAX,
       c(DEF, "agency_str", "x_agency_str", CTRL)),
  list("Table D1: Y_prog_tax",    "tax Model 2", TAX,
       c(DEF, "justice_str", "x_justice_str", CTRL)),
  list("Table D1: Y_prog_tax",    "tax Model 3", TAX,
       c(DEFS, DES, "x_desert_rich_tot", "x_desert_americans_tot",
         "x_desert_poor_tot", CTRL))
)

# Standard errors that stay valid when the error variance differs across
# respondents (heteroskedasticity-robust, Stata's default for areg), computed
# for a weighted fit: the HC1 sandwich
# (X'WX)^-1 X'W diag(e^2) W X (X'WX)^-1, times n/(n-k).
hc1 <- function(fit) {
  X <- model.matrix(fit)
  w <- weights(fit)
  e <- residuals(fit)
  n <- nrow(X)
  k <- ncol(X)
  bread <- solve(crossprod(X * sqrt(w)))
  meat  <- crossprod(X * (w * e))
  bread %*% meat %*% bread * (n / (n - k))
}

# One table regression: weighted least squares with a separate intercept for
# each state (the state fixed effects) and HC1 standard errors. Returns each
# predictor's coefficient, standard error, and p-value, with N, R2, and
# adjusted R2.
fit_table <- function(dv, rhs, data) {
  sub <- data[complete.cases(data[, c(dv, rhs, "post_weight", "state")]), ]
  f   <- as.formula(paste(dv, "~",
                          paste(c(rhs, "factor(state)"), collapse = " + ")))
  fit <- lm(f, data = sub, weights = sub$post_weight)
  V   <- hc1(fit)
  b   <- coef(fit)
  se  <- sqrt(diag(V))
  n   <- nobs(fit)
  dfr <- n - length(b)
  pv  <- 2 * pt(abs(b / se), dfr, lower.tail = FALSE)
  cells <- list()
  for (v in rhs) cells[[ROW[[v]]]] <- c(b[[v]], se[[v]], pv[[v]])
  # the constant as areg reports it: ybar - xbar'beta, with a delta-method
  # standard error
  w    <- sub$post_weight
  xbar <- apply(sub[, rhs, drop = FALSE], 2, weighted.mean, w = w)
  cons <- weighted.mean(sub[[dv]], w) - sum(xbar * b[rhs])
  cse  <- sqrt(as.numeric(t(xbar) %*% V[rhs, rhs] %*% xbar))
  cells[["Constant"]] <- c(cons, cse,
                           2 * pt(abs(cons / cse), dfr, lower.tail = FALSE))
  list(cells = cells, N = n,
       R2 = summary(fit)$r.squared, AdjR2 = summary(fit)$adj.r.squared)
}

# Estimate the 32 regressions and Table A1 on one data set; return the
# results and their markdown.
tables_md <- function(data) {
  res <- lapply(M, function(m) {
    list(table = m[[1]], col = m[[2]], est = fit_table(m[[3]], m[[4]], data))
  })

  # the regression tables
  cell_text <- function(x, r, what) {
    c <- x$est$cells[[r]]
    if (is.null(c)) return("")
    if (what == "coef") sprintf("%.3f%s", c[1], stars(c[3]))
    else sprintf("(%.3f)", c[2])
  }

  md <- character(0)
  for (tb in unique(sapply(res, `[[`, "table"))) {
    rs   <- Filter(function(r) r$table == tb, res)
    cols <- sapply(rs, `[[`, "col")
    md <- c(md, "", paste0("## ", tb),
            paste0("| Variable | ", paste(cols, collapse = " | "), " |"),
            paste0(strrep("|---", length(cols) + 1), "|"))
    present <- ORDER[sapply(ORDER, function(r) {
      any(sapply(rs, function(x) !is.null(x$est$cells[[r]])))
    })]
    row_line <- function(label, vals) {
      paste0("| ", if (nzchar(label)) paste0(label, " ") else "",
             "| ", paste(vals, collapse = " | "), " |")
    }
    for (r in present) {
      md <- c(md, row_line(r, sapply(rs, cell_text, r, "coef")),
                  row_line("", sapply(rs, cell_text, r, "se")))
    }
    md <- c(md,
      row_line("N",      sapply(rs, function(x) x$est$N)),
      row_line("R2",     sapply(rs, function(x) sprintf("%.4f", x$est$R2))),
      row_line("Adj-R2", sapply(rs, function(x) sprintf("%.4f", x$est$AdjR2))))
  }

  # Table A1, the sample's composition; education and income back on their
  # answer codes (seven and nineteen levels)
  edu <- round(data$education * 6)
  inc <- round(data$income_household * 18)
  A1 <- list(
    Gender = list(Female = data$gender == 0, Male = data$gender == 1),
    Race = list(White = data$race == 0, Black = data$race == 1,
                Latino = data$race == 2, Asian = data$race == 4,
                Other = data$race %in% c(3, 5, 6)),
    Education = list(`High school or less` = edu <= 2,
                     `Associate's or some college` = edu %in% c(3, 4),
                     `Bachelor's degree` = edu == 5,
                     `Graduate degree` = edu == 6),
    `Household income` = list(`< $25k` = inc <= 6,
                              `$25k-$49k` = inc %in% 7:10,
                              `$50k-$74k` = inc %in% 11:12,
                              `$75k-$99k` = inc %in% 13:14,
                              `$100k-$149k` = inc %in% 15:16,
                              `$150k+` = inc >= 17),
    `Political party` = list(Republican = data$party <= -2,
                             `Lean Republican` = data$party == -1,
                             Independent = data$party == 0,
                             `Lean Democrat` = data$party == 1,
                             Democrat = data$party >= 2)
  )
  a1 <- c("", "## Table A1", "| Group | Sample N | Sample share |", "|---|---|---|")
  for (g in names(A1)) {
    for (lab in names(A1[[g]])) {
      n  <- sum(A1[[g]][[lab]])
      a1 <- c(a1, sprintf("| %s: %s | %d | %.2f |", g, lab, n, n / nrow(data)))
    }
  }
  # the article's order is Table 1, then A1, then C1: insert A1 before the
  # blank line that precedes the C1 heading
  i  <- match("## Table C1: Y_gov_fix_gap", md) - 1
  md <- append(md, a1, after = i - 1)
  list(res = res, md = md)
}

# ---- 4. The survey weight, re-raked --------------------------------------------
# The survey weight was raked on all 992 rows in 2014 (iterative proportional
# fitting to population totals on gender, party, income, race, and education).
# Raking the same way on the 991 distinct rows gives the weight those tables
# should carry. Strata and targets are the 2014 script's; the targets are
# scaled from 992 to the rows present.
#
# One stratum is corrected. The 2014 script's lowest income group took income
# codes 0-7, that is households under $30,000 (`income_household < 8` on the
# 19-bracket code), against a population target for households under $25,000;
# the $25,000 line is code 7. With income_cut = 8 the function reproduces the
# shipped weight; the final tables use income_cut = 7.
rake <- function(x, income_cut = 8) {
  inc <- round(x$income_household * 18)
  edu <- round(x$education * 6)
  strata <- list(
    gender = x$gender,
    party  = ifelse(x$party >= 2, 1, ifelse(x$party == 1, 2,
             ifelse(x$party == 0, 3, ifelse(x$party == -1, 4, 5)))),
    income = ifelse(inc < income_cut, 1, ifelse(inc < 11, 2, ifelse(inc < 13, 3,
             ifelse(inc < 15, 4, 5)))),
    race   = ifelse(x$race == 0, 1, ifelse(x$race == 1, 2,
             ifelse(x$race == 2, 3, 4))),
    educ   = ifelse(edu <= 1, 1, ifelse(edu == 2, 2, ifelse(edu %in% c(3, 4), 3,
             ifelse(edu == 5, 4, 5)))))
  targets <- list(
    gender = c(`1` = 486, `0` = 506),
    party  = c(`1` = 317, `2` = 159, `3` = 119, `4` = 159, `5` = 238),
    income = c(`1` = 245, `2` = 249, `3` = 182, `4` = 120, `5` = 196),
    race   = c(`1` = 632, `2` = 121, `3` = 162, `4` = 77),
    educ   = c(`1` = 122, `2` = 301, `3` = 292, `4` = 166, `5` = 111))
  w <- rep(1, nrow(x))
  for (it in 1:500) {
    w0 <- w
    for (g in names(targets)) {
      for (lvl in names(targets[[g]])) {
        m <- strata[[g]] == as.numeric(lvl)
        w[m] <- w[m] * (targets[[g]][[lvl]] * nrow(x) / 992) / sum(w[m])
      }
    }
    if (max(abs(w - w0)) < 1e-12) break
  }
  w
}
# check: raked on all 992 rows, the method reproduces the shipped weight
stopifnot(max(abs(rake(d) - d$post_weight)) < 1e-4)

full  <- tables_md(d)
d991  <- d[-dup_row, ]
d991$post_weight <- rake(d991, income_cut = 7)
dedup <- tables_md(d991)
res   <- full$res
md    <- c("# Corrected tables", "",
           paste0("The published tables with their typos corrected, estimated on the ",
                  "published sample of 992 observations with the 2014 weight. Written by ",
                  "script_replication.R (tables_corrected_R.md) and script_replication.py ",
                  "(tables_corrected_python.md); the two files are identical. The last ",
                  "section lists every cell that differs from the published tables."),
           full$md)
dedup$md <- c("# Final tables", "",
              paste0("The same tables estimated on the 991 distinct respondents, without ",
                     "the duplicated row and with the survey weight corrected. Written by ",
                     "script_replication.R (tables_final_R.md) and script_replication.py ",
                     "(tables_final_python.md); the two files are identical. The last ",
                     "section lists every cell that differs from the corrected tables ",
                     "(tables_corrected_R.md)."),
              dedup$md)


# ---- 5. Figures ------------------------------------------------------------------
# Drawn twice: from the published sample (992 rows, 2014 weight), which
# reproduces the printed figures, and from the final data (991 rows,
# corrected weight) as figure_*_final-data_R.png. Returns the rows of the D1 and D2
# regressions for the tables file.
draw_figures <- function(d, sfx) {
  rows <- character(0)

  png_open <- function(f, w = 6.5, h = 4) {
    png(f, width = w, height = h, units = "in", res = 200)
  }
  sc <- function(v) 2 * v - 1          # a 0-1 score back to its -1 to 1 scale

  if (sfx == "_published-sample") {
    # Figure 1: the General Social Survey percentages the article charts
    # (not from this survey)
    png_open("figure_1_R.png", 6.5, 2.4)
    par(mar = c(3, 12, 2, 1), family = "serif")
    agree    <- c(0.45, 0.5916, 0.6653)
    disagree <- c(0.52, 0.4084, 0.1647)
    greys    <- c("grey85", "grey60", "grey30")
    barplot(rbind(disagree, 1 - agree - disagree, agree), horiz = TRUE,
            col = greys, border = NA, las = 1, cex.names = 0.8, cex.axis = 0.8,
            names.arg = c("the income gap is a\nproblem that needs fixing",
                          "there are strong conflicts\nbetween the rich and poor",
                          "differences in income\nare too large"))
    abline(v = 0.5, lty = 3)
    legend("topright", c("disagree", "unsure", "agree"), fill = greys, border = NA,
           bty = "n", cex = 0.8, horiz = TRUE, inset = c(0, -0.22), xpd = TRUE)
    invisible(dev.off())
  }

  # Figures 2 and 3: kernel densities (Gaussian kernel, Silverman's default
  # bandwidth, as Stata's kdensity default). Figure 2 is computed on the 0-1
  # standardized scores and labeled on their original -1 to 1 scale, which is
  # how the 2014 plot was drawn; its heights match the printed figure. Figure 3
  # is the raw correlation; the printed figure is more heavily smoothed than
  # the default here, and the smoothing it used is not recorded.
  dens <- function(v) {
    k <- density(v[!is.na(v)])
    list(x = sc(k$x), y = k$y)
  }
  png_open(sprintf("figure_2%s_R.png", sfx))
  par(mar = c(4, 4, 1, 1), family = "serif")
  plot(dens(d$desert_rich_tot), type = "l", lwd = 2, main = "", ylab = "",
       xlab = "Deservingness", xlim = c(-1, 1), ylim = c(0, 2.8), bty = "l")
  lines(dens(d$desert_americans_tot), lwd = 2, lty = 3)
  lines(dens(d$desert_poor_tot), lwd = 2, lty = 2)
  legend("topright", c("rich", "average", "poor"), lwd = 2, lty = c(1, 3, 2),
         bty = "n")
  invisible(dev.off())

  png_open(sprintf("figure_3%s_R.png", sfx))
  par(mar = c(4, 4, 1, 1), family = "serif")
  plot(density(d$corr_ideal_agency, na.rm = TRUE), lwd = 2, main = "", ylab = "",
       xlab = "Control-Ideal Importance correlation", xlim = c(-1, 1), bty = "l")
  invisible(dev.off())

  # Figure 4: share of respondents in each cell of (rich deserve their wealth)
  # x (income differences are too large). The 2014 figure dropped the
  # duplicated respondent record (two rows identical in every answer; the
  # second is dropped). Each axis is put back on its answer codes: 13 columns
  # from -6 to 6, 7 rows from -3 to 3.
  d4  <- d[!duplicated(d[, setdiff(names(d), c("row", "id"))]), ]
  ix  <- round(sc(d4$desert_rich_tot) * 6)     # 13 columns, -6 to 6
  iy  <- round(sc(d4$diff_large) * 3)          # 7 rows, -3 to 3
  tab <- table(factor(iy, levels = -3:3), factor(ix, levels = -6:6)) / nrow(d4)
  png_open(sprintf("figure_4%s_R.png", sfx), 6.5, 4.2)
  par(mar = c(5, 5, 1, 5), family = "serif")
  image(x = -6:6, y = -3:3, z = t(unclass(tab)),
        col = grey.colors(20, start = 0.95, end = 0.1), axes = FALSE,
        xlab = "Do the rich deserve their wealth?",
        ylab = "Are income differences too large?")
  axis(1, at = c(-6, 0, 6), labels = c("VC, VU", "NC, ND/U", "VC, VD"),
       cex.axis = 0.8)
  axis(2, at = c(-3, 0, 3), labels = c("SD", "N", "SA"), las = 1, cex.axis = 0.8)
  box()
  invisible(dev.off())

  # Figures D1 and D2: marginal-effect plots. Each panel: an ordinary weighted
  # regression with the interaction, errors clustered by state (Stata:
  # reg ... [pw=post_weight], cluster(state)); the marginal effect of X at each
  # value of the moderator Z, b1 + b3*Z, with a 95% band, over a histogram of Z.
  # D2 reverses the roles: the marginal effect of Z at each value of Definition.

  cluster_vcov <- function(fit, g) {
    X <- model.matrix(fit)
    w <- weights(fit)
    e <- residuals(fit)
    n <- nrow(X)
    k <- ncol(X)
    G <- length(unique(g))
    bread <- solve(crossprod(X * sqrt(w)))
    U     <- X * (w * e)
    meat  <- Reduce(`+`, lapply(split(seq_len(n), g), function(i) {
      s <- matrix(colSums(U[i, , drop = FALSE]), nrow = 1)
      crossprod(s)
    }))
    bread %*% meat %*% bread * (G / (G - 1)) * ((n - 1) / (n - k))
  }

  # the right-hand side of each plot regression: rescaled Definition, the
  # moderator, their product, and the controls; for the rich-deserve panels
  # all three deserve variables and their products enter together
  plot_rhs <- function(zvar) {
    block <- if (zvar == "desert_rich_tot") DES_X else c(zvar, paste0("x_", zvar))
    c(DEFS, block, CTRL)
  }

  me_panel <- function(dv, xvar, zvar, xlab, ylab, ylim, hist_var, breaks,
                       main, rug = FALSE) {
    rhs <- plot_rhs(zvar)
    sub <- d[complete.cases(d[, c(dv, rhs, "post_weight", "state")]), ]
    fit <- lm(as.formula(paste(dv, "~", paste(rhs, collapse = " + "))),
              data = sub, weights = sub$post_weight)
    V   <- cluster_vcov(fit, sub$state)
    b   <- coef(fit)
    ix  <- paste0("x_", zvar)
    b1  <- b[[xvar]]
    b3  <- b[[ix]]
    v1  <- V[xvar, xvar]
    v3  <- V[ix, ix]
    c13 <- V[xvar, ix]
    zz   <- seq(0, 1, by = 0.01)
    me   <- b1 + b3 * zz
    band <- 1.96 * sqrt(v1 + v3 * zz^2 + 2 * c13 * zz)
    h    <- hist(sub[[hist_var]], breaks = breaks, plot = FALSE)
    par(mar = c(4, 4, 2, 4), family = "serif")
    plot(h$mids, 100 * h$counts / sum(h$counts), type = "h", lend = 1,
         lwd = if (rug) 2 else 8, col = "grey80", axes = FALSE,
         xlab = "", ylab = "", xlim = c(0, 1))
    axis(4, cex.axis = 0.7)
    mtext("Percentage of observations", 4, line = 2.2, cex = 0.7)
    par(new = TRUE)
    plot(zz, me, type = "l", lwd = 2, ylim = ylim, xlim = c(0, 1), bty = "n",
         xlab = xlab, ylab = ylab, main = main,
         cex.lab = 0.75, cex.axis = 0.7, cex.main = 0.8)
    lines(zz, me + band, lty = 2)
    lines(zz, me - band, lty = 2)
    abline(h = 0)
    if (rug) rug(sub[[hist_var]], col = "grey40")
    sprintf("| %s | %s | %s | %.3f | %.3f | %.3f | %.3f | %d |",
            main, dv, zvar, b1, sqrt(v1), b3, sqrt(v3), nobs(fit))
  }

  rows <- c(rows, "", "## Figure D1 and D2 regressions",
          "| Panel | Outcome | Z | b(X) | SE | b(X x Z) | SE | N |",
          "|---|---|---|---|---|---|---|---|")

  X_LAB  <- "Marginal effect of definition"
  AGENCY <- "Belief that peoples' economic standing is within their control"
  JUST   <- "Belief that economic desert is rewarded"
  RICH   <- "Belief that rich Americans deserve their wealth"
  # 24 bins of width 1/24, offset half a bin so each answer level sits in the
  # middle of a bar
  br24   <- seq(-1 / 48, 1 + 1 / 48, by = 1 / 24)

  png_open(sprintf("figure_D1%s_R.png", sfx), 7, 6)
  par(mfrow = c(2, 2))
  rows <- c(rows,
    me_panel(GOV, DEFS, "agency_str", AGENCY, X_LAB, c(-3, 1), "agency_str", br24,
             "D1(a) X given Z_agency, on Y_gov_fix_gap"),
    me_panel(GOV, DEFS, "justice_str", JUST, X_LAB, c(-3, 1), "justice_str", br24,
             "D1(b) X given Z_justice, on Y_gov_fix_gap"),
    me_panel(GOV, DEFS, "desert_rich_tot", RICH, X_LAB, c(-3, 1),
             "desert_rich_tot", br24,
             "D1(c) X given Z_rich_deserve, on Y_gov_fix_gap"),
    me_panel(TAX, DEFS, "agency_str", AGENCY, X_LAB, c(-3, 1), "agency_str", br24,
             "D1(d) X given Z_agency, on Y_prog_tax"))
  invisible(dev.off())

  Z_LAB  <- "Importance of agency to definition of desert"
  br100  <- seq(0, 1, by = 0.01)

  png_open(sprintf("figure_D2%s_R.png", sfx), 7, 6)
  par(mfrow = c(2, 2))
  rows <- c(rows,
    me_panel(GOV, "agency_str", "agency_str", Z_LAB,
             "Marginal effect of belief in economic agency",
             c(-2, 7), DEFS, br100,
             "D2(a) Z_agency given X, on Y_gov_fix_gap", rug = TRUE),
    me_panel(GOV, "justice_str", "justice_str", Z_LAB,
             "Marginal effect of belief that economic desert is rewarded",
             c(-2, 7), DEFS, br100,
             "D2(b) Z_justice given X, on Y_gov_fix_gap", rug = TRUE),
    me_panel(GOV, "desert_rich_tot", "desert_rich_tot", Z_LAB,
             "Marginal effect of belief that rich Americans deserve their wealth",
             c(-2, 7), DEFS, br100,
             "D2(c) Z_rich_deserve given X, on Y_gov_fix_gap", rug = TRUE),
    me_panel(TAX, "agency_str", "agency_str", Z_LAB,
             "Marginal effect of belief in economic agency",
             c(-2, 7), DEFS, br100,
             "D2(d) Z_agency given X, on Y_prog_tax", rug = TRUE))
  invisible(dev.off())
  rows
}

md <- c(md, draw_figures(d, "_published-sample"))
dedup$md <- c(dedup$md, draw_figures(d991, "_final-data"))

writeLines(md, OUT)

# ---- 6. The final tables and the list of cells that change ------------------------
# Same layout, 991 rows, followed by every regression cell whose coefficient,
# standard error, or stars differ from the as-published tables above.
# a cell as printed: the coefficient with its stars, and the standard error
fmt <- function(c) {
  c(sprintf("%.3f%s", c[1], stars(c[3])), sprintf("(%.3f)", c[2]))
}
# a regression's place in the article, named as printed:
# ("Table C1: Y_gov_fix_gap", "gov Model A") -> "Table C1 | Y_gov_fix_gap | Model A"
where <- function(t, c) {
  pre <- sub("^Y_", "", sub(" .*", "", c))
  sprintf("%s | %s | %s", sub(":.*", "", t),
          c(gov = "Y_gov_fix_gap", tax = "Y_prog_tax")[[pre]], sub("^[^ ]+ ", "", c))
}
changes <- character(0)
for (k in seq_along(res)) {
  a <- res[[k]]$est$cells
  b <- dedup$res[[k]]$est$cells
  for (r in names(a)) {
    fa <- fmt(a[[r]])
    fb <- fmt(b[[r]])
    if (!identical(fa, fb)) {
      changes <- c(changes, sprintf("| %s | %s | %s %s | %s %s |",
                                    where(res[[k]]$table, res[[k]]$col), r,
                                    fa[1], fa[2], fb[1], fb[2]))
    }
  }
}
# Table A1 too: the duplicated respondent is counted once fewer in each of
# their groups
a1_rows <- function(m) {
  m <- m[(match("## Table A1", m) + 3):(match("## Table C1: Y_gov_fix_gap", m) - 1)]
  m <- m[startsWith(m, "|")]
  lapply(strsplit(sub("^\\|", "", sub("\\|$", "", m)), "|", fixed = TRUE), trimws)
}
for (x in Map(list, a1_rows(full$md), a1_rows(dedup$md))) {
  if (!identical(x[[1]], x[[2]])) {
    row <- sprintf("| Table A1 | | | %s | %s (%s) | %s (%s) |",
                   x[[1]][1], x[[1]][2], x[[1]][3], x[[2]][2], x[[2]][3])
    # table order: after Table 1 and any A1 rows already placed
    k <- sum(startsWith(changes, "| Table 1 |")) + sum(startsWith(changes, "| Table A1 |"))
    changes <- append(changes, row, after = k)
  }
}
dd <- c(dedup$md, "",
        "## Cells that change with the two data fixes",
        "As published: 992 rows, the 2014 weight. Final: 991 rows, the duplicate removed, the weight corrected.", "",
        "| Table | Outcome | Model | Row | As published | Final |",
        "|---|---|---|---|---|---|", changes)
writeLines(dd, "tables_final_R.md")
ncells <- sum(sapply(res, function(r) length(r$est$cells)))
cat(sprintf("wrote tables_final_R.md: %d of %d regression cells change",
            sum(!startsWith(changes, "| Table A1")), ncells), "at the printed precision\n")
cat(sprintf("wrote %s and the figures, figure_*_R.png\n", OUT))


# ---- 7. Comparison with the printed tables -------------------------------------
# Every cell of Tables 1, C1, C2, and D1 against tables_as-published.md, a
# transcription of the printed article. Cells agree when they match to the
# printed decimals; the tolerances below are half a unit in the last printed
# digit.

PUB <- "tables_as-published.md"
if (file.exists(PUB)) {

  # {section: {column: {row: coef, se}}} for a markdown file of tables; a
  # standard-error row belongs to the row above it
  parse_md <- function(path) {
    out <- list(); cur <- NULL; cols <- NULL; last <- NULL
    for (ln in readLines(path, warn = FALSE)) {
      if (startsWith(ln, "## ")) {
        cur <- trimws(substring(ln, 4)); out[[cur]] <- list(); cols <- NULL
        next
      }
      if (is.null(cur) || !startsWith(ln, "|") || grepl("^[-| ]*$", ln)) next
      body  <- sub("\\|$", "", sub("^\\|", "", ln))
      cells <- trimws(strsplit(body, "\\|")[[1]])
      if (is.null(cols)) { cols <- cells[-1]; next }
      cells <- c(cells, rep("", length(cols) + 1 - length(cells)))
      name <- cells[1]; vals <- cells[-1]
      if (nzchar(name)) {
        last <- name
        for (k in seq_along(cols)) {
          if (nzchar(vals[k])) {
            out[[cur]][[cols[k]]][[name]] <- list(coef = vals[k])
          }
        }
      } else {
        for (k in seq_along(cols)) {
          if (nzchar(vals[k])) out[[cur]][[cols[k]]][[last]]$se <- vals[k]
        }
      }
    }
    out
  }
  # a printed cell as a number; the published file uses a Unicode minus sign,
  # and stars and parentheses are dropped
  num <- function(s) as.numeric(gsub("[()*]", "", gsub("−", "-", s)))

  pub   <- parse_md(PUB)
  mism  <- character(0)
  side  <- character(0)
  ncell <- 0
  for (r in res) {
    pc <- pub[[r$table]][[r$col]]
    for (row in names(pc)) {
      ncell <- ncell + 1
      cell  <- pc[[row]]
      tag   <- sprintf("%s | %s", where(r$table, r$col), row)
      if (row %in% c("N", "R2", "Adj-R2")) {
        got <- switch(row, N = r$est$N, R2 = r$est$R2, `Adj-R2` = r$est$AdjR2)
        tol <- switch(row, N = 0.5, R2 = 0.00005, `Adj-R2` = 0.00005)
        if (abs(got - num(cell$coef)) > tol) {
          shown <- if (row == "N") sprintf("%d", got) else sprintf("%.4f", got)
          mism  <- c(mism, sprintf("%s: printed %s, re-estimated %s",
                                   tag, cell$coef, shown))
          side  <- c(side, sprintf("| %s | %s | %s |", tag, cell$coef, shown))
        }
        next
      }
      e <- r$est$cells[[row]]
      if (is.null(e)) {
        mism <- c(mism, sprintf("%s: printed but not in this model", tag))
        next
      }
      probs <- character(0)
      if (abs(e[1] - num(cell$coef)) > 0.0005) {
        probs <- c(probs, sprintf("coef printed %s, re-estimated %.3f",
                                  gsub("\\*", "", cell$coef), e[1]))
      }
      se_off <- !is.null(cell$se) && abs(e[2] - num(cell$se)) > 0.0005
      if (row != "Constant" && se_off) {
        probs <- c(probs, sprintf("SE printed %s, re-estimated (%.3f)",
                                  cell$se, e[2]))
      }
      ps <- gsub("[^*]", "", cell$coef)
      if (row != "Constant" && ps != stars(e[3])) {
        none  <- function(s) if (nzchar(s)) s else "none"
        probs <- c(probs, sprintf("stars printed %s, earned %s",
                                  none(ps), none(stars(e[3]))))
      }
      if (length(probs)) {
        mism <- c(mism, paste0(tag, ": ", paste(probs, collapse = "; ")))
        printed <- trimws(paste(cell$coef, if (is.null(cell$se)) "" else cell$se))
        side <- c(side, sprintf("| %s | %s | %s |", tag, printed,
                                paste(fmt(e), collapse = " ")))
      }
    }
  }

  cat(sprintf("\nCompared %d cells with %s", ncell, PUB),
      "(the constant's SE and stars are not compared).\n")
  if (!length(mism)) {
    cat("Every cell matches.\n")
  } else {
    cat(sprintf("%d cells differ between the printed tables and the re-run:",
                length(mism)), "\n")
    cat(paste0("  ", mism, "\n"), sep = "")
  }
  # the same list as a file: the cell-by-cell record of the errors
  # (stars escaped so a markdown viewer shows them)
  writeLines(c("# Cells where the printed tables differ from the re-run",
               "(992 observations)", "",
               paste("Each line: table | outcome | model | row: what was printed,",
                     "what the re-run gives."),
               "", paste0("- ", gsub("*", "\\*", mism, fixed = TRUE))),
             "tables_corrected-cells_R.md")
  # and side by side at the end of the corrected tables: each printed cell
  # beside its corrected value
  cat(c("", "## Cells that differ from the published tables",
        "| Table | Outcome | Model | Row | Published | Corrected |",
        "|---|---|---|---|---|---|", side), file = OUT, sep = "\n", append = TRUE)
}
