#!/usr/bin/env Rscript
# =============================================================================
# Reproduces every table and figure in Bower-Bir (2021), "Earning our place,
# more or less: Responsibility's flexible relationship with desert in
# socioeconomic standing", Economia Politica 38(1): 131-170. Base R only.
# script_replication.py is the same program in Python, without the figures.
#
# Reads, from this folder:
#   data_survey_ep-subset.csv   992 respondents, the 54 survey variables the
#                               tables and figures use
#   tables_as-published.md      the tables as printed, for the comparison
#
# Writes, to this folder:
#   tables_corrected_R.md       Tables 1, 2, and 4, the numbers behind Figures
#                               3 to 7, the survey-weight check, and a list of
#                               every printed cell that differs from the re-run
#   tables_final_R.md           Tables 1 and 4 re-estimated with the weight's
#                               income line corrected, Table 2 on the 991
#                               distinct respondents, and every cell that
#                               changes
#   figure_1_R.png ... figure_7_R.png   the seven figures, redrawn
#
# Sections, in order:
#   1. The data and the duplicated record
#   2. Variables the regressions build
#   3. Tables 1 and 4: 15 weighted regressions (Stata: svy: reg, pweight only)
#   4. Table 2: the sample's composition
#   5. The numbers behind Figures 3, 4, and 5
#   6. The numbers behind Figures 6 and 7, and Section 5
#   7. The survey weight, re-derived by raking
#   8. The final tables and the list of cells that change
#   9. Comparison with the printed tables
#  10. The figures, drawn last
#
# Run from this folder:  Rscript script_replication.R
# Takes a few seconds.
#
# Three things carried over from the 2014 Stata code on purpose:
#   1. The data file holds every scale rescaled to 0-1, including the dependent
#      variable; the article reports it on its -1 to 1 scale, so it is rescaled
#      back.
#   2. The variable named `neoliberal` runs from neoliberal (0) to
#      anti-neoliberal (1); the article's Neoliberal rows use it with its sign
#      reversed, as do the four items.
#   3. One respondent's record is in the file twice; every analysis except
#      Table 2 drops the second copy, as the published regressions did.
# =============================================================================


# ---- 1. The data and the duplicated record -----------------------------------

OUT <- "tables_corrected_R.md"
PUB <- "tables_as-published.md"
d992 <- read.csv("data_survey_ep-subset.csv")

# The duplicate: two rows identical in every answer (ids 1115 and 1157).
dup <- duplicated(d992[, setdiff(names(d992), c("row", "id"))])
d <- d992[!dup, ]


# ---- 2. Variables the regressions build ---------------------------------------

# the dependent variable is stored 0-1; the article uses its -1 to 1 scale
d$dv <- d$corr_ideal_agency * 2 - 1

# the neoliberal index and its four items with their signs reversed, so that
# high means neoliberal, as the article's rows have them (header, point 2)
for (v in c("neoliberal", "profits_benefit", "gov_stayout", "help_self", "diff_incentives"))
  d[[paste0(v, "_r")]] <- -d[[v]]

# each variable's row label in the article

ROW <- c(ideo_str = "Ideology", party_str = "Political party", religiosity = "Religiosity",
         theology = "Theology", nonwhite = "Nonwhite", female = "Female", gay_strict = "Gay",
         income_household = "Income", school_ivy = "Ivy league", education = "Education",
         age = "Age", urban = "Urban", south = "Southern", neoliberal_r = "Neoliberal",
         profits_benefit_r = "Profits", gov_stayout_r = "Gov. stay out",
         help_self_r = "Self help", diff_incentives_r = "Disp. incentives",
         const = "Constant")
FULL <- c("ideo_str", "party_str", "religiosity", "theology", "nonwhite", "female",
          "gay_strict", "income_household", "school_ivy", "education", "age", "urban", "south")
ITEMS <- c("profits_benefit_r", "gov_stayout_r", "help_self_r", "diff_incentives_r")
T1 <- list("Model 1a" = c(FULL, "neoliberal_r"),
           "Model 2a" = c("ideo_str", "religiosity", "nonwhite", "income_household",
                          "school_ivy", "age", "south", "neoliberal_r"),
           "Model 3a" = c("nonwhite", "income_household", "school_ivy", "age", "neoliberal_r"),
           "Model 1b" = c(FULL, ITEMS),
           "Model 2b" = c("religiosity", "nonwhite", "income_household", "school_ivy", "age",
                          "south", "help_self_r", "diff_incentives_r"),
           "Model 3b" = c("nonwhite", "income_household", "school_ivy", "age",
                          "help_self_r", "diff_incentives_r"))
T4 <- list("Model A" = c("ideo_str", "religiosity"),
           "Model B" = c("party_str", "theology"),
           "Model C" = c("nonwhite", "female", "gay_strict"),
           "Model D" = c("income_household", "school_ivy"),
           "Model E" = c("education", "age", "urban", "south"),
           "Model F" = "neoliberal_r",
           "Model G" = ITEMS,
           "Model H" = c("nonwhite", "female", "gay_strict", "education", "age", "urban", "south"),
           "Model I" = c("party_str", "theology", "nonwhite", "female", "gay_strict",
                         "income_household", "education", "age", "urban", "south"))
ORDER <- c(FULL, "neoliberal_r", ITEMS, "const")


# ---- 3. Tables 1 and 4: 15 weighted regressions ---------------------------------

# Weighted least squares with Stata's `svy: reg` standard errors when only a
# pweight is declared: the HC0 sandwich times n/(n-1), t with n-1 df.
svyreg <- function(df, xs, w = "post_weight") {
  s <- na.omit(df[, c("dv", w, xs)])
  X <- cbind(as.matrix(s[, xs]), 1)
  y <- s$dv
  wt <- s[[w]]
  A <- solve(t(X * wt) %*% X)
  b <- drop(A %*% t(X * wt) %*% y)
  e <- drop(y - X %*% b)
  u <- X * (wt * e)
  n <- length(y)
  se <- sqrt(diag(A %*% crossprod(u) %*% A) * n / (n - 1))
  p <- 2 * pt(abs(b / se), n - 1, lower.tail = FALSE)
  ybar <- sum(wt * y) / sum(wt)
  r2 <- 1 - sum(wt * e^2) / sum(wt * (y - ybar)^2)
  names(b) <- names(se) <- names(p) <- c(xs, "const")
  list(b = b, se = se, p = p, n = n, r2 = r2)
}

stars <- function(p) ifelse(p < 0.01, "***", ifelse(p < 0.05, "**", ifelse(p < 0.10, "*", "")))
f3 <- function(x) sprintf("%.3f", x)

# one regression table as markdown: a coefficient row and a standard-error row
# for every variable in any of its models, then N and R2

regtable <- function(title, models, df, w = "post_weight") {
  fits <- lapply(models, function(xs) svyreg(df, xs, w))
  out <- c(paste0("## ", title), paste0("| Variable | ", paste(names(models), collapse = " | "), " |"),
           paste0(strrep("|---", length(models) + 1), "|"))
  for (v in ORDER) {
    has <- sapply(fits, function(f) v %in% names(f$b))
    if (!any(has)) next
    cc <- sapply(fits, function(f) if (v %in% names(f$b)) paste0(f3(f$b[[v]]), stars(f$p[[v]])) else "")
    ss <- sapply(fits, function(f) if (v %in% names(f$b)) paste0("(", f3(f$se[[v]]), ")") else "")
    out <- c(out, paste0("| ", ROW[[v]], " | ", paste(cc, collapse = " | "), " |"),
             paste0("| | ", paste(ss, collapse = " | "), " |"))
  }
  out <- c(out, paste0("| N | ", paste(sapply(fits, `[[`, "n"), collapse = " | "), " |"),
           paste0("| R2 | ", paste(sprintf("%.4f", sapply(fits, `[[`, "r2")), collapse = " | "), " |"))
  list(lines = out, fits = fits)
}

lines <- c("# Reproduced tables: Bower-Bir (2021), Economia Politica 38(1): 131-170", "",
           paste0("Written by script_replication.R (tables_corrected_R.md) and ",
                  "script_replication.py (tables_corrected_python.md); the two files are ",
                  "identical. Every regression and every figure statistic uses the 991 ",
                  "distinct respondents; Table 2 describes all 992 rows, as the article's ",
                  "does. The R2 row is the article's \"Adj-R2\" row: `svy: reg` reports ",
                  "plain R2, and the printed values are that."), "")

t1 <- regtable("Table 1", T1, d)
t4 <- regtable("Table 4", T4, d)


# ---- 4. Table 2: the sample's composition -------------------------------------
# Counted on all 992 rows, as the article's Table 2 was. Income and education
# back on their answer codes (nineteen and seven levels). Returns the lines and
# the counts.
table2 <- function(df) {
  i18 <- round(df$income_household * 18)
  edu <- round(df$education * 6)
  groups <- list("Female" = df$female == 1, "Male" = df$female == 0,
                 "White" = df$race == 0, "Black" = df$race == 1, "Latino" = df$race == 2,
                 "Asian" = df$race == 4, "Other" = df$race %in% c(3, 5, 6),
                 "High school or less" = edu <= 2, "Associate's or some college" = edu %in% c(3, 4),
                 "Bachelor's degree" = edu == 5, "Graduate degree" = edu == 6,
                 "<$25k" = i18 <= 6, "$25k-$49k" = i18 >= 7 & i18 <= 10,
                 "$50k-$74k" = i18 >= 11 & i18 <= 12, "$75k-$99k" = i18 >= 13 & i18 <= 14,
                 "$100k-$149k" = i18 >= 15 & i18 <= 16, "$150k+" = i18 >= 17,
                 "Republican" = df$party <= -2, "Lean Republican" = df$party == -1,
                 "Independent" = df$party == 0, "Lean Democrat" = df$party == 1,
                 "Democrat" = df$party >= 2)
  counts <- sapply(groups, sum)
  out <- c("## Table 2", "| Group | Sample N | Sample % |", "|---|---|---|",
           sprintf("| %s | %d | %.2f |", names(counts), counts, counts / nrow(df)))
  list(lines = out, counts = counts)
}
p2 <- table2(d992)
t2 <- p2$lines
cnt2_pub <- p2$counts


# ---- 5. The numbers behind Figures 3, 4, and 5 ----------------------------------
# For each of the fifteen factors, the correlation across respondents between
# how much control people have over it and how important it should be.
FAC <- c(iq = "intelligence", school = "schl. prestige", education = "education",
         creativity = "creativity", stablefam = "fam. stability", health = "health",
         econstate = "state of econ.", attitude = "attitude", parenteduc = "parents' educ.",
         hardwork = "hard work", gender = "gender", ambition = "ambition",
         connections = "connections", race = "race", wealth = "fam. wealth")
ctrl <- function(f) round(d[[paste0(f, "_agency")]] * 4)      # 0 no control ... 4 total control
imp  <- function(f) round(d[[paste0(f, "_ideal")]] * 6) - 3   # -3 very un-important ... 3 very important
r3 <- sapply(names(FAC), function(f) cor(ctrl(f), imp(f)))
# Figure 4 folds the three "un-important" answers into one before correlating
r4 <- sapply(names(FAC), function(f) cor(ctrl(f), pmax(imp(f), -1)))
o <- order(r3)
t34 <- c("## Figures 3 and 4",
         "Control-importance correlation by factor, in ascending order of the Figure 3 value; Figure 5 places each factor at the mean of the two.", "",
         "| Factor | Figure 3 | Figure 4 | Figure 5 |", "|---|---|---|---|",
         sprintf("| %s | %.2f | %.2f | %.2f |", FAC[o], r3[o], r4[o], (r3[o] + r4[o]) / 2))


# ---- 6. The numbers behind Figures 6 and 7, and Section 5 ----------------------
x <- na.omit(d$dv)
# the neoliberal index on its -3 to 3 scale, rounded to quarter points
neo <- round((d$neoliberal * 6 - 3) * 4) / 4
t6 <- c("## Figure 6 and Section 5", "| Statistic | Reproduced |", "|---|---|",
        sprintf("| Fig. 6, mean | %.2f |", mean(x)), sprintf("| Fig. 6, median | %.2f |", median(x)),
        sprintf("| Fig. 6, lower quartile | %.2f |", quantile(x, .25)),
        sprintf("| Fig. 6, upper quartile | %.2f |", quantile(x, .75)),
        sprintf("| Fig. 6, standard deviation | %.2f |", sd(x)),
        # the interval the article quotes for Figure 6
        sprintf("| Fig. 6, share between 0.44 and 0.98 | %.0f%% |", mean(x >= .44 & x <= .98) * 100),
        sprintf("| Sect. 5, share on the positive side of the neoliberal index | %.0f%% |", mean(neo > 0) * 100))
t7 <- c("## Figure 7",
        paste0("The neoliberal index as stored runs from -3 (most neoliberal) to 3 (least). ",
               "Its positive side, which Figure 7 labels neoliberal and Section 5 counts as neoliberal-leaning, is the anti-neoliberal side."), "",
        "| Respondents | Share |", "|---|---|",
        sprintf("| Lean neoliberal | %.1f%% |", mean(neo < 0) * 100),
        sprintf("| Exactly neutral | %.1f%% |", mean(neo == 0) * 100),
        sprintf("| Lean anti-neoliberal | %.1f%% |", mean(neo > 0) * 100),
        sprintf("| Mean of the index, -3 to 3 | %.2f |", mean(neo)))


# ---- 7. The survey weight, re-derived by raking ----------------------------------
# Raking (iterative proportional fitting) over the five margins and population
# targets of the 2014 weighting script. income_cut is the first income code of
# the second stratum: 8 in the script, 7 per the questionnaire.
rake <- function(df, income_cut) {
  i18 <- round(df$income_household * 18)
  e6 <- round(df$education * 6)
  strata <- list(
    list(g = 1 - df$female, tot = c("1" = 486, "0" = 506)),
    list(g = ifelse(df$party <= -2, 5, ifelse(df$party == -1, 4, ifelse(df$party == 0, 3,
                    ifelse(df$party == 1, 2, 1)))),
         tot = c("1" = 317, "2" = 159, "3" = 119, "4" = 159, "5" = 238)),
    list(g = ifelse(i18 < income_cut, 1, ifelse(i18 < 11, 2, ifelse(i18 < 13, 3, ifelse(i18 < 15, 4, 5)))),
         tot = c("1" = 245, "2" = 249, "3" = 182, "4" = 120, "5" = 196)),
    list(g = ifelse(df$race == 0, 1, ifelse(df$race == 1, 2, ifelse(df$race == 2, 3, 4))),
         tot = c("1" = 632, "2" = 121, "3" = 162, "4" = 77)),
    list(g = ifelse(e6 <= 1, 1, ifelse(e6 == 2, 2, ifelse(e6 <= 4, 3, ifelse(e6 == 5, 4, 5)))),
         tot = c("1" = 122, "2" = 301, "3" = 292, "4" = 166, "5" = 111)))
  w <- rep(1, nrow(df))
  for (it in 1:1000) {
    w0 <- w
    for (s in strata) for (k in names(s$tot)) {
      m <- s$g == as.numeric(k)
      w[m] <- w[m] * s$tot[[k]] / sum(w[m])
    }
    if (max(abs(w - w0)) < 1e-12) break
  }
  w
}

w2014 <- rake(d992, 8)
wfix <- rake(d992, 7)
d$w_fix <- wfix[!dup]
inc <- round(d992$income_household * 18)   # income on its 19 answer codes, all 992 rows
tw <- c("## The survey weight",
        paste0(sprintf("Raking with the 2014 script's strata and targets reproduces the weight in the file: largest difference %s. ",
                       sprintf("%.1e", max(abs(w2014 - d992$post_weight)))),
               "The script's lowest income stratum takes income codes 0-7 (under $30,000) for a target described as under $25,000; ",
               "Table 2's script, like the questionnaire, puts the $25,000 line at code 7. ",
               sprintf("Raking with the line at code 7 moves %d respondents into the second stratum. ", sum(inc == 7)),
               "Tables 1 and 4 re-estimated with that weight are in tables_final_R.md and ",
               "tables_final_python.md, with every cell that changes."))
lines <- c(lines, t1$lines, "", t2, "", t4$lines, "", t34, "", t6, "", t7, "", tw)


# ---- 8. The final tables and the list of cells that change ---------------------
# Tables 1 and 4 with the corrected weight, Table 2 on the 991 distinct
# respondents, then every cell that differs from the tables above, and a
# summary of how far coefficients and stars move.
f1 <- regtable("Table 1", T1, d, "w_fix")
f4 <- regtable("Table 4", T4, d, "w_fix")
p2f <- table2(d)
f2 <- p2f$lines
cnt2 <- p2f$counts
fmt <- function(b, se, p) sprintf("%s%s (%s)", f3(b), stars(p), f3(se))
changes <- c()      # cells that differ at the printed precision
moves <- c()        # absolute change in each coefficient
signs <- c()        # coefficients that change sign
starmoves <- c()    # coefficients whose stars change
up <- 0             # how many of those gain stars
for (pair in list(list("Table 1", t1$fits, f1$fits), list("Table 4", t4$fits, f4$fits))) {
  title <- pair[[1]]
  for (m in names(pair[[2]])) {
    a <- pair[[2]][[m]]
    z <- pair[[3]][[m]]
    for (v in names(a$b)) {
      fa <- fmt(a$b[[v]], a$se[[v]], a$p[[v]])
      fz <- fmt(z$b[[v]], z$se[[v]], z$p[[v]])
      if (fa != fz) changes <- c(changes, sprintf("| %s | %s | %s | %s | %s |", title, m, ROW[[v]], fa, fz))
      if (v == "const") next
      moves <- c(moves, abs(z$b[[v]] - a$b[[v]]))
      if (sign(a$b[[v]]) != sign(z$b[[v]]))
        signs <- c(signs, sprintf("%s, %s, %s: %s to %s", title, m, ROW[[v]], f3(a$b[[v]]), f3(z$b[[v]])))
      if (stars(a$p[[v]]) != stars(z$p[[v]])) {
        up <- up + (nchar(stars(z$p[[v]])) > nchar(stars(a$p[[v]])))
        starmoves <- c(starmoves, sprintf("%s, %s, %s: %s to %s (p = %.3f to %.3f)", title, m, ROW[[v]],
                                          ifelse(stars(a$p[[v]]) == "", "none", stars(a$p[[v]])),
                                          ifelse(stars(z$p[[v]]) == "", "none", stars(z$p[[v]])), a$p[[v]], z$p[[v]]))
      }
    }
    if (sprintf("%.4f", a$r2) != sprintf("%.4f", z$r2))
      changes <- c(changes, sprintf("| %s | %s | R2 | %.4f | %.4f |", title, m, a$r2, z$r2))
  }
  if (title == "Table 1") {
    ch <- names(cnt2)[cnt2 != cnt2_pub]
    changes <- c(changes, sprintf("| Table 2 | | %s | %d | %d |", ch, cnt2_pub[ch], cnt2[ch]))
  }
}
final <- c("# Final tables: Bower-Bir (2021), Economia Politica 38(1): 131-170", "",
           paste0("Written by script_replication.R (tables_final_R.md) and ",
                  "script_replication.py (tables_final_python.md); the two files are ",
                  "identical. Tables 1 and 4 are re-estimated on the 991 distinct ",
                  "respondents with the survey weight raked again with the $25,000 ",
                  "income line in the right place (the 2014 weight placed the 54 ",
                  "respondents earning $25,000 to $29,999 in the group below $25,000). ",
                  "Table 2 counts the 991 distinct respondents; the article's counts ",
                  "include one respondent's duplicated record. The last section lists ",
                  "every cell that differs from the corrected tables ",
                  "(tables_corrected_R.md)."), "",
           f1$lines, "", f2, "", f4$lines, "", "## What changes",
           sprintf("Across the %d coefficients of Tables 1 and 4:", length(moves)), "",
           sprintf("- Coefficients that change sign: %d.", length(signs)), paste0("  - ", signs),
           sprintf("- Largest change in a coefficient: %.3f.", max(moves)),
           sprintf("- Significance stars that change: %d, %d up and %d down.", length(starmoves), up, length(starmoves) - up),
           paste0("  - ", starmoves),
           "", "## Cells that change",
           "As published: the 2014 weight; Table 2 on all 992 rows. Final: the corrected weight; Table 2 on the 991 distinct respondents.", "",
           "| Table | Model | Row | As published | Final |", "|---|---|---|---|---|", changes)
writeLines(final, "tables_final_R.md", useBytes = TRUE)
cat(sprintf("wrote tables_final_R.md: %d cells change at the printed precision\n", length(changes)))


# ---- 9. Comparison with the printed tables ---------------------------------------
# Every printed cell of Tables 1, 2, and 4 and the figure statistics against
# tables_as-published.md, a transcription of the printed article. parse_md
# gives {section | row label | column} -> cell for every table in a markdown
# file; standard-error rows are keyed by the row above them plus " SE".
parse_md <- function(md) {
  cells <- list(); sec <- NULL; cols <- NULL; last <- NULL
  for (ln in md) {
    if (startsWith(ln, "## ")) { sec <- trimws(substring(ln, 4)); cols <- NULL; next }
    if (!startsWith(ln, "|") || startsWith(ln, "|---")) next
    parts <- trimws(strsplit(sub("^\\|", "", sub("\\|\\s*$", "", trimws(ln))), "|", fixed = TRUE)[[1]])
    if (is.null(cols)) { cols <- parts; next }
    lab <- if (parts[1] == "") paste(last, "SE") else parts[1]
    if (parts[1] != "") last <- parts[1]
    if (lab == "Adj-R2") lab <- "R2"
    for (j in seq_along(cols)[-1]) {
      v <- if (j <= length(parts)) parts[j] else ""
      if (v != "") cells[[paste(sec, lab, cols[j], sep = "\t")]] <- v
    }
  }
  cells
}

pub <- parse_md(readLines(PUB, encoding = "UTF-8"))
ours <- parse_md(lines)
diffs <- c()
for (k in names(pub)) {
  p <- strsplit(k, "\t", fixed = TRUE)[[1]]
  col <- if (p[1] == "Figure 6 and Section 5") "Reproduced" else p[3]
  if (p[1] == "Table 2" && col != "Sample N") next
  mine <- ours[[paste(p[1], p[2], col, sep = "\t")]]
  if (is.null(mine) || mine != pub[[k]])
    diffs <- c(diffs, sprintf("| %s | %s | %s | %s | %s |", p[1], col, p[2], pub[[k]],
                              if (is.null(mine)) "None" else mine))
}
lines <- c(lines, "", "## Cells that differ from the published tables",
           "| Table | Column | Row | Published | Reproduced |", "|---|---|---|---|---|", diffs)
writeLines(lines, OUT, useBytes = TRUE)
cat(sprintf("wrote %s\n%d printed cells compared; %d differ:\n", OUT, length(pub), length(diffs)))
cat(paste0("  ", diffs, "\n"), sep = "")



# ---- 10. The figures, drawn last ---------------------------------------------------
# Unweighted, on the 991 distinct respondents, as the published figures were
# drawn. Each factor's two ratings are plotted on the same 0-1 width: control
# from no control to total control, importance from very un-important to very
# important.
ink <- "gray15"
mid <- "gray55"
png_open <- function(f, w, h) {
  png(f, width = w, height = h, res = 150)
  par(family = "sans", col = ink, col.axis = ink, col.lab = ink, fg = ink)
}
cs    <- function(f) d[[paste0(f, "_agency")]]   # control, 0-1
ideal <- function(f) d[[paste0(f, "_ideal")]]    # ideal importance, 0-1
# the factors in rising order of mean ideal importance, the order the figures use
by_imp <- names(FAC)[order(sapply(names(FAC), function(f) mean(ideal(f))))]

# Figure 1: mean control and mean ideal importance, 95% intervals.
png_open("figure_1_R.png", 1300, 1100)
par(mar = c(6, 9, 1, 1))
k <- length(by_imp)
plot(NA, xlim = c(0, 1), ylim = c(0.5, k + 0.5), axes = FALSE, xlab = "", ylab = "")
axis(2, at = 1:k, labels = FAC[by_imp], las = 1, tick = FALSE)
axis(1, at = c(0, .5, 1), labels = c("very un-important\nno control", "neither un-/important\nsome control",
                                     "very important\ntotal control"), padj = 0.6, cex.axis = 0.8)
abline(v = c(0, .5, 1), col = "gray88")
for (i in seq_len(k)) {
  f <- by_imp[i]
  # control as an open circle a little below the line, importance as a filled
  # circle a little above
  for (s in list(list(v = cs(f), pch = 1, off = -0.15), list(v = ideal(f), pch = 19, off = 0.15))) {
    m <- mean(s$v)
    h <- 1.96 * sd(s$v) / sqrt(length(s$v))
    segments(m - h, i + s$off, m + h, i + s$off)
    points(m, i + s$off, pch = s$pch)
  }
}
legend("bottomright", c("control over", "ideal importance of"), pch = c(1, 19), bty = "n", cex = 0.85)
invisible(dev.off())

# Figure 2: densities of control (dashed) and ideal importance (solid).
png_open("figure_2_R.png", 1800, 1100)
par(mfrow = c(3, 5), mar = c(2, 1, 2, 1), oma = c(2, 0, 0, 0))
for (f in by_imp) {
  # a bandwidth wide enough to smooth over the 5 and 7 answer levels
  dc <- density(cs(f), bw = 0.08, from = 0, to = 1)
  di <- density(ideal(f), bw = 0.08, from = 0, to = 1)
  plot(di, main = FAC[[f]], xlab = "", ylab = "", yaxt = "n", xaxt = "n", lwd = 1.5,
       ylim = c(0, max(dc$y, di$y)), font.main = 1, cex.main = 1)
  lines(dc, lty = 2, lwd = 1.5)
  abline(v = 0.5, col = "gray80")
  axis(1, at = c(0, .5, 1), labels = c("low", "mid", "high"), cex.axis = 0.8)
}
mtext("solid: ideal importance of    dashed: control over", side = 1, outer = TRUE, line = 0.5, cex = 0.8)
invisible(dev.off())

# Figures 3 and 4: heat maps, share of respondents in each answer combination.
heat <- function(file, truncate) {
  r <- if (truncate) r4 else r3
  png_open(file, 1800, 1150)
  par(mfrow = c(3, 5), mar = c(2.5, 2.5, 2.5, 0.5), oma = c(2, 2, 0, 0))
  for (f in names(FAC)[order(r)]) {
    yv <- imp(f)
    if (truncate) yv <- pmax(yv, -1)
    lev_y <- if (truncate) -1:3 else -3:3
    tab <- table(factor(ctrl(f), levels = 0:4), factor(yv, levels = lev_y)) / length(yv)
    image(0:4, lev_y, tab, col = gray(seq(1, 0.1, length.out = 50)), zlim = c(0, 0.65),
          axes = FALSE, xlab = "", ylab = "")
    title(sprintf("%s\nr = %.2f", FAC[[f]], r[[f]]), font.main = 1, cex.main = 0.95)
    axis(1, at = c(0, 2, 4), labels = c("nc", "sc", "tc"), cex.axis = 0.8, tick = FALSE)
    axis(2, at = range(lev_y), labels = if (truncate) c("u", "vi") else c("vu", "vi"),
         las = 1, cex.axis = 0.8, tick = FALSE)
  }
  mtext("control over (nc no control, sc some control, tc total control)", side = 1, outer = TRUE, line = 0.5, cex = 0.8)
  mtext(if (truncate) "ideal importance of (u un-important, vi very important)" else
          "ideal importance of (vu very un-important, vi very important)", side = 2, outer = TRUE, line = 0.5, cex = 0.8)
  invisible(dev.off())
}
heat("figure_3_R.png", FALSE)
heat("figure_4_R.png", TRUE)

# Figure 5: quadrants as the article assigns them (Sect. 3.3; the assignment is
# the author's reading of Figures 1 and 2, not a computed quantity), distance
# from the origin the mean of the Figure 3 and Figure 4 correlations. Within a
# quadrant the factors are spread evenly by angle.
QUAD <- list(c(1, 1), c(-1, 1), c(-1, -1), c(1, -1))
INQ <- list(c("race", "wealth", "connections", "gender", "ambition", "hardwork", "attitude", "education"),
            c("creativity", "iq"), c("school", "health"), c("econstate", "stablefam", "parenteduc"))
png_open("figure_5_R.png", 1200, 1200)
par(mar = c(4, 4, 1, 1))
plot(NA, xlim = c(-0.65, 0.65), ylim = c(-0.65, 0.65), asp = 1, axes = FALSE,
     xlab = "control over factor", ylab = "ideal importance of factor")
abline(h = 0, v = 0, col = "gray70")
th <- seq(0, 2 * pi, length.out = 200)
lines(0.6 * cos(th), 0.6 * sin(th), lty = 3, col = mid)   # the r = 0.6 circle
text(0.6 * cos(pi / 4), 0.6 * sin(pi / 4) + 0.03, "r = 0.6", col = mid, cex = 0.8)
mtext(c("disagreement", "agreement"), side = 1, at = c(-0.35, 0.35), line = 0.3, cex = 0.8)
mtext(c("disagreement", "agreement"), side = 2, at = c(-0.35, 0.35), line = 0.3, cex = 0.8)
for (q in 1:4) {
  fs <- INQ[[q]]
  ang <- (if (length(fs) <= 3) seq(20, 70, length.out = length(fs))
          else seq(10, 80, length.out = length(fs) + 2)[-c(1, length(fs) + 2)]) * pi / 180
  for (j in seq_along(fs)) {
    rr <- (r3[[fs[j]]] + r4[[fs[j]]]) / 2
    xx <- QUAD[[q]][1] * rr * cos(ang[j])
    yy <- QUAD[[q]][2] * rr * sin(ang[j])
    points(xx, yy, pch = 19, cex = 0.7)
    side <- if (QUAD[[q]][1] < 0) 2 else if (j %% 2) 4 else 2
    text(xx, yy, sprintf("%s %.2f", FAC[[fs[j]]], rr), pos = side, cex = 0.75)
  }
}
invisible(dev.off())

# Figure 6: the by-respondent correlation.
png_open("figure_6_R.png", 1300, 800)
par(mar = c(4.5, 4.5, 1, 1))
plot(density(x), main = "", xlim = c(-1, 1), lwd = 1.5,
     xlab = "correlation b/w control over and ideal importance of factors", ylab = "density")
invisible(dev.off())

# Figure 7, corrected: the index with its sign reversed, so that the right end is
# neoliberal. The published figure plotted the index as stored and labeled its
# right end neoliberal; see tables_corrected_R.md, Figure 7.
png_open("figure_7_R.png", 1300, 800)
par(mar = c(4.5, 4.5, 1, 1))
nr <- -neo
plot(density(nr, adjust = 1.5, from = -3, to = 3), main = "", lwd = 1.5,
     xlab = "", ylab = "density", xaxt = "n")
axis(1, at = c(-3, 0, 3), labels = c("anti-neoliberal", "M", "neoliberal"))   # M marks the midpoint
abline(v = 0, col = mid)
abline(v = mean(nr), lty = 2)
text(mean(nr) - 0.05, par("usr")[4] * 0.95, sprintf("mean %.2f", mean(nr)), pos = 2, cex = 0.8)
text(-2.9, par("usr")[4] * 0.85, sprintf("lean anti-neoliberal %.1f%%", mean(nr < 0) * 100), pos = 4, cex = 0.8)
text(2.9, par("usr")[4] * 0.85, sprintf("lean neoliberal %.1f%%", mean(nr > 0) * 100), pos = 2, cex = 0.8)
invisible(dev.off())
cat("wrote figure_1_R.png ... figure_7_R.png\n")
