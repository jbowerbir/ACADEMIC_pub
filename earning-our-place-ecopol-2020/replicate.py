#!/usr/bin/env python3
"""
Reproduces every table and the numbers in every figure of Bower-Bir (2021),
"Earning our place, more or less", Economia Politica 38(1): 131-170, from
economic_justice_v7_ep-replication.csv.

  Tables 1, 4    15 weighted regressions (Stata: svy: reg, pweight only)
  Table 2        the sample's composition
  Figures 3-7    the correlations, summary statistics and shares the figures
                 print or the text quotes
  Weight check   the survey weight re-derived by raking
  Final tables   Tables 1 and 4 re-estimated with the weight's income line
                 corrected, and Table 2 on the 991 distinct respondents,
                 with every cell that changes

Writes tables_py.md and tables_final_py.md, then compares the first with
tables_published.md and lists every cell that differs. replicate.R is the same
program in R and also draws the seven figures; `diff tables_corrected.md
tables_py.md` and `diff tables_final.md tables_final_py.md` check one against
the other.

Three things carried over from the 2014 Stata code on purpose. (1) The data
file holds every scale rescaled to 0-1, including the dependent variable; the
article reports it on its -1 to 1 scale, so it is rescaled back. (2) The
variable named `neoliberal` runs from neoliberal (0) to anti-neoliberal (1);
the article's Neoliberal rows use it with its sign reversed, as do the four
items. (3) One respondent's record is in the file twice; every analysis except
Table 2 drops the second copy, as the published regressions did.

Usage:  python3 replicate.py
Needs pandas, numpy and scipy.
"""
import re
import numpy as np
import pandas as pd
from scipy import stats

OUT = "tables_py.md"
PUB = "tables_published.md"
d992 = pd.read_csv("economic_justice_v7_ep-replication.csv")

# The duplicate: two rows identical in every answer (ids 1115 and 1157).
dup = d992.duplicated(subset=[c for c in d992.columns if c not in ("row", "id")])
d = d992[~dup].copy()

# ---- Variables the regressions build ----------------------------------------
d["dv"] = d["corr_ideal_agency"] * 2 - 1
for v in ["neoliberal", "profits_benefit", "gov_stayout", "help_self", "diff_incentives"]:
    d[v + "_r"] = -d[v]

ROW = {"ideo_str": "Ideology", "party_str": "Political party", "religiosity": "Religiosity",
       "theology": "Theology", "nonwhite": "Nonwhite", "female": "Female", "gay_strict": "Gay",
       "income_household": "Income", "school_ivy": "Ivy league", "education": "Education",
       "age": "Age", "urban": "Urban", "south": "Southern", "neoliberal_r": "Neoliberal",
       "profits_benefit_r": "Profits", "gov_stayout_r": "Gov. stay out",
       "help_self_r": "Self help", "diff_incentives_r": "Disp. incentives",
       "const": "Constant"}
FULL = ["ideo_str", "party_str", "religiosity", "theology", "nonwhite", "female",
        "gay_strict", "income_household", "school_ivy", "education", "age", "urban", "south"]
ITEMS = ["profits_benefit_r", "gov_stayout_r", "help_self_r", "diff_incentives_r"]
T1 = {"Model 1a": FULL + ["neoliberal_r"],
      "Model 2a": ["ideo_str", "religiosity", "nonwhite", "income_household", "school_ivy",
                   "age", "south", "neoliberal_r"],
      "Model 3a": ["nonwhite", "income_household", "school_ivy", "age", "neoliberal_r"],
      "Model 1b": FULL + ITEMS,
      "Model 2b": ["religiosity", "nonwhite", "income_household", "school_ivy", "age", "south",
                   "help_self_r", "diff_incentives_r"],
      "Model 3b": ["nonwhite", "income_household", "school_ivy", "age",
                   "help_self_r", "diff_incentives_r"]}
T4 = {"Model A": ["ideo_str", "religiosity"],
      "Model B": ["party_str", "theology"],
      "Model C": ["nonwhite", "female", "gay_strict"],
      "Model D": ["income_household", "school_ivy"],
      "Model E": ["education", "age", "urban", "south"],
      "Model F": ["neoliberal_r"],
      "Model G": ITEMS,
      "Model H": ["nonwhite", "female", "gay_strict", "education", "age", "urban", "south"],
      "Model I": ["party_str", "theology", "nonwhite", "female", "gay_strict",
                  "income_household", "education", "age", "urban", "south"]}
ORDER = ["ideo_str", "party_str", "religiosity", "theology", "nonwhite", "female", "gay_strict",
         "income_household", "school_ivy", "education", "age", "urban", "south",
         "neoliberal_r"] + ITEMS + ["const"]


def svyreg(df, xs, w="post_weight"):
    """Weighted least squares with Stata's `svy: reg` standard errors when only a
    pweight is declared: the HC0 sandwich times n/(n-1), t with n-1 df."""
    s = df[["dv", w] + xs].dropna()
    X = np.column_stack([s[xs].to_numpy(float), np.ones(len(s))])
    y = s["dv"].to_numpy(float)
    wt = s[w].to_numpy(float)
    XtW = X.T * wt
    A = np.linalg.inv(XtW @ X)
    b = A @ (XtW @ y)
    e = y - X @ b
    meat = (X * (wt * e)[:, None]).T @ (X * (wt * e)[:, None])
    n = len(y)
    se = np.sqrt(np.diag(A @ meat @ A) * n / (n - 1))
    p = 2 * stats.t.sf(np.abs(b / se), n - 1)
    ybar = np.sum(wt * y) / np.sum(wt)
    r2 = 1 - np.sum(wt * e ** 2) / np.sum(wt * (y - ybar) ** 2)
    names = xs + ["const"]
    return {k: (b[i], se[i], p[i]) for i, k in enumerate(names)}, n, r2


def stars(p):
    return "***" if p < 0.01 else "**" if p < 0.05 else "*" if p < 0.10 else ""


def regtable(title, models, df, w="post_weight"):
    fits = {m: svyreg(df, xs, w) for m, xs in models.items()}
    out = [f"## {title}", "| Variable | " + " | ".join(models) + " |",
           "|---" * (len(models) + 1) + "|"]
    for v in ORDER:
        if not any(v in f[0] for f in fits.values()):
            continue
        c = [f"{f[0][v][0]:.3f}{stars(f[0][v][2])}" if v in f[0] else "" for f in fits.values()]
        s = [f"({f[0][v][1]:.3f})" if v in f[0] else "" for f in fits.values()]
        out += [f"| {ROW[v]} | " + " | ".join(c) + " |", "| | " + " | ".join(s) + " |"]
    out.append("| N | " + " | ".join(str(f[1]) for f in fits.values()) + " |")
    out.append("| R2 | " + " | ".join(f"{f[2]:.4f}" for f in fits.values()) + " |")
    return out, fits


lines = ["# Reproduced tables: Bower-Bir (2021), Economia Politica 38(1): 131-170", "",
         "Written by replicate.R (tables_corrected.md) and replicate.py (tables_py.md); the two files are identical. "
         "Every regression and every figure statistic uses the 991 distinct respondents; Table 2 describes all 992 rows, "
         "as the article's does. The R2 row is the article's \"Adj-R2\" row: `svy: reg` reports plain R2, and the printed values are that.", ""]

t1, fits1 = regtable("Table 1", T1, d)
t4, fits4 = regtable("Table 4", T4, d)

# ---- Table 2 ------------------------------------------------------------------
inc = np.round(d992["income_household"] * 18)
def table2(df):
    """The sample's composition, as Table 2 prints it. Returns the lines and the counts."""
    i18 = np.round(df["income_household"] * 18)
    edu = np.round(df["education"] * 6)
    groups = [("Female", df.female == 1), ("Male", df.female == 0),
              ("White", df.race == 0), ("Black", df.race == 1), ("Latino", df.race == 2),
              ("Asian", df.race == 4), ("Other", df.race.isin([3, 5, 6])),
              ("High school or less", edu <= 2), ("Associate's or some college", edu.isin([3, 4])),
              ("Bachelor's degree", edu == 5), ("Graduate degree", edu == 6),
              ("<$25k", i18 <= 6), ("$25k-$49k", (i18 >= 7) & (i18 <= 10)),
              ("$50k-$74k", (i18 >= 11) & (i18 <= 12)), ("$75k-$99k", (i18 >= 13) & (i18 <= 14)),
              ("$100k-$149k", (i18 >= 15) & (i18 <= 16)), ("$150k+", i18 >= 17),
              ("Republican", df.party <= -2), ("Lean Republican", df.party == -1),
              ("Independent", df.party == 0), ("Lean Democrat", df.party == 1),
              ("Democrat", df.party >= 2)]
    counts = {g: int(m.sum()) for g, m in groups}
    out = ["## Table 2", "| Group | Sample N | Sample % |", "|---|---|---|"]
    out += [f"| {g} | {n} | {n / len(df):.2f} |" for g, n in counts.items()]
    return out, counts
t2, cnt2_pub = table2(d992)

# ---- Figures 3, 4, 5 -----------------------------------------------------------
FAC = {"iq": "intelligence", "school": "schl. prestige", "education": "education",
       "creativity": "creativity", "stablefam": "fam. stability", "health": "health",
       "econstate": "state of econ.", "attitude": "attitude", "parenteduc": "parents' educ.",
       "hardwork": "hard work", "gender": "gender", "ambition": "ambition",
       "connections": "connections", "race": "race", "wealth": "fam. wealth"}
r = []
for f, lab in FAC.items():
    ctrl = d[f + "_agency"]
    imp = d[f + "_ideal"] * 6 - 3              # back to the answer codes, -3 to 3
    r3 = ctrl.corr(imp)
    r4 = ctrl.corr(imp.clip(lower=-1))         # Figure 4: the three "un-important" answers as one
    r.append((lab, r3, r4))
r.sort(key=lambda x: x[1])
t34 = ["## Figures 3 and 4", "Control-importance correlation by factor, in ascending order of the Figure 3 value; "
       "Figure 5 places each factor at the mean of the two.", "",
       "| Factor | Figure 3 | Figure 4 | Figure 5 |", "|---|---|---|---|"]
t34 += [f"| {lab} | {a:.2f} | {b:.2f} | {(a + b) / 2:.2f} |" for lab, a, b in r]

# ---- Figure 6 and 7 --------------------------------------------------------------
x = d["dv"].dropna()
t6 = ["## Figure 6 and Section 5", "| Statistic | Reproduced |", "|---|---|",
      f"| Fig. 6, mean | {x.mean():.2f} |", f"| Fig. 6, median | {x.median():.2f} |",
      f"| Fig. 6, lower quartile | {x.quantile(.25):.2f} |",
      f"| Fig. 6, upper quartile | {x.quantile(.75):.2f} |",
      f"| Fig. 6, standard deviation | {x.std():.2f} |",
      f"| Fig. 6, share between 0.44 and 0.98 | {((x >= .44) & (x <= .98)).mean() * 100:.0f}% |"]
neo = np.round((d["neoliberal"] * 6 - 3) * 4) / 4       # the index on its -3 to 3 scale
t6.append(f"| Sect. 5, share on the positive side of the neoliberal index | {(neo > 0).mean() * 100:.0f}% |")
t7 = ["## Figure 7", "The neoliberal index as stored runs from -3 (most neoliberal) to 3 (least). "
      "Its positive side, which Figure 7 labels neoliberal and Section 5 counts as neoliberal-leaning, is the anti-neoliberal side.", "",
      "| Respondents | Share |", "|---|---|",
      f"| Lean neoliberal | {(neo < 0).mean() * 100:.1f}% |",
      f"| Exactly neutral | {(neo == 0).mean() * 100:.1f}% |",
      f"| Lean anti-neoliberal | {(neo > 0).mean() * 100:.1f}% |",
      f"| Mean of the index, -3 to 3 | {neo.mean():.2f} |"]

# ---- The survey weight -------------------------------------------------------------
def rake(df, income_cut):
    """Raking (iterative proportional fitting) over the five margins and population
    targets of the 2014 weighting script. income_cut is the first income code of
    the second stratum: 8 in the script, 7 per the questionnaire."""
    i18 = np.round(df["income_household"] * 18)
    e6 = np.round(df["education"] * 6)
    strata = {
        "gender": (df["female"].map({0: 1, 1: 0}), {1: 486, 0: 506}),
        "party": (pd.cut(df["party"], [-9, -2, -1, 0, 1, 9], labels=[5, 4, 3, 2, 1]).astype(int),
                  {1: 317, 2: 159, 3: 119, 4: 159, 5: 238}),
        "income": (np.select([i18 < income_cut, i18 < 11, i18 < 13, i18 < 15], [1, 2, 3, 4], 5),
                   {1: 245, 2: 249, 3: 182, 4: 120, 5: 196}),
        "race": (df["race"].map({0: 1, 1: 2, 2: 3}).fillna(4).astype(int),
                 {1: 632, 2: 121, 3: 162, 4: 77}),
        "educ": (np.select([e6 <= 1, e6 == 2, e6 <= 4, e6 == 5], [1, 2, 3, 4], 5),
                 {1: 122, 2: 301, 3: 292, 4: 166, 5: 111}),
    }
    w = np.ones(len(df))
    for _ in range(1000):
        w0 = w.copy()
        for g, tot in strata.values():
            g = np.asarray(g)
            for k, t in tot.items():
                m = g == k
                w[m] *= t / w[m].sum()
        if np.max(np.abs(w - w0)) < 1e-12:
            break
    return w

w2014 = rake(d992, 8)
wfix = rake(d992, 7)
d["w_fix"] = wfix[~dup.to_numpy()]
tw = ["## The survey weight",
      f"Raking with the 2014 script's strata and targets reproduces the weight in the file: largest difference {np.max(np.abs(w2014 - d992['post_weight'])):.1e}. "
      "The script's lowest income stratum takes income codes 0-7 (under $30,000) for a target described as under $25,000; "
      "Table 2's script, like the questionnaire, puts the $25,000 line at code 7. "
      f"Raking with the line at code 7 moves {int((inc == 7).sum())} respondents into the second stratum. "
      "Tables 1 and 4 re-estimated with that weight are in tables_final.md, with every cell that changes."]
lines += t1 + [""] + t2 + [""] + t4 + [""] + t34 + [""] + t6 + [""] + t7 + [""] + tw

# ---- The final tables: corrected weight; Table 2 on the 991 distinct respondents ----
f1, fix1 = regtable("Table 1", T1, d, "w_fix")
f4, fix4 = regtable("Table 4", T4, d, "w_fix")
f2, cnt2 = table2(d)
fmt = lambda c: f"{c[0]:.3f}{stars(c[2])} ({c[1]:.3f})"
changes, moves, signs, starmoves, up = [], [], [], [], 0
for title, base, fin in [("Table 1", fits1, fix1), ("Table 4", fits4, fix4)]:
    for m in base:
        for v, c in base[m][0].items():
            z = fin[m][0][v]
            if fmt(c) != fmt(z):
                changes.append(f"| {title} | {m} | {ROW[v]} | {fmt(c)} | {fmt(z)} |")
            if v == "const":
                continue
            moves.append(abs(z[0] - c[0]))
            if np.sign(c[0]) != np.sign(z[0]):
                signs.append(f"{title}, {m}, {ROW[v]}: {c[0]:.3f} to {z[0]:.3f}")
            if stars(c[2]) != stars(z[2]):
                up += len(stars(z[2])) > len(stars(c[2]))
                starmoves.append(f"{title}, {m}, {ROW[v]}: {stars(c[2]) or 'none'} to {stars(z[2]) or 'none'} (p = {c[2]:.3f} to {z[2]:.3f})")
        if f"{base[m][2]:.4f}" != f"{fin[m][2]:.4f}":
            changes.append(f"| {title} | {m} | R2 | {base[m][2]:.4f} | {fin[m][2]:.4f} |")
    if title == "Table 1":
        changes += [f"| Table 2 | | {g} | {cnt2_pub[g]} | {cnt2[g]} |" for g in cnt2 if cnt2[g] != cnt2_pub[g]]
final = ["# Final tables: Bower-Bir (2021), Economia Politica 38(1): 131-170", "",
         "Written by replicate.R (tables_final.md) and replicate.py (tables_final_py.md); the two files are identical. "
         "Tables 1 and 4 are re-estimated on the 991 distinct respondents with the survey weight raked again with the $25,000 income line in the right place "
         "(the 2014 weight placed the 54 respondents earning $25,000 to $29,999 in the group below $25,000). "
         "Table 2 counts the 991 distinct respondents; the article's counts include one respondent's duplicated record. "
         "The last section lists every cell that differs from the tables as published (tables_corrected.md).", ""]
final += f1 + [""] + f2 + [""] + f4 + ["", "## What changes",
          f"Across the {len(moves)} coefficients of Tables 1 and 4:", "",
          f"- Coefficients that change sign: {len(signs)}."] + [f"  - {x}" for x in signs] + [
          f"- Largest change in a coefficient: {max(moves):.3f}.",
          f"- Significance stars that change: {len(starmoves)}, {up} up and {len(starmoves) - up} down."] + [f"  - {x}" for x in starmoves] + [
          "", "## Cells that change",
          "As published: the 2014 weight; Table 2 on all 992 rows. Final: the corrected weight; Table 2 on the 991 distinct respondents.", "",
          "| Table | Model | Row | As published | Final |", "|---|---|---|---|---|"] + changes
open("tables_final_py.md", "w", encoding="utf-8").write("\n".join(final) + "\n")
print(f"wrote tables_final_py.md: {len(changes)} cells change at the printed precision")

# ---- Compare with the printed tables ------------------------------------------------
def parse(md_lines):
    """{(section, row label, column): cell} for every table in a markdown file;
    standard-error rows are keyed by the row above them plus ' SE'."""
    cells, sec, cols, last = {}, None, None, None
    for ln in md_lines:
        if ln.startswith("## "):
            sec, cols = ln[3:].strip(), None
        elif ln.startswith("|") and not ln.startswith("|---"):
            parts = [p.strip() for p in ln.strip().strip("|").split("|")]
            if cols is None:
                cols = parts
                continue
            lab = parts[0] or (last + " SE")
            if parts[0]:
                last = parts[0]
            lab = "R2" if lab == "Adj-R2" else lab
            for c, v in zip(cols[1:], parts[1:]):
                if v:
                    cells[(sec, lab, c)] = v
    return cells

pub = parse(open(PUB, encoding="utf-8").read().splitlines())
ours = parse(lines)
alias = {("Figures 3 and 4", "Figure 3"), ("Figures 3 and 4", "Figure 4")}
diff = []
for (sec, lab, col), v in pub.items():
    if sec == "Figure 6 and Section 5":
        col = "Reproduced"
    if sec == "Table 2" and col != "Sample N":
        continue
    mine = ours.get((sec, lab, col))
    if mine != v:
        diff.append(f"| {sec} | {col} | {lab} | {v} | {mine} |")
lines += ["", "## Cells that differ from the published tables",
          "| Table | Column | Row | Published | Reproduced |", "|---|---|---|---|---|"] + diff

open(OUT, "w", encoding="utf-8").write("\n".join(lines) + "\n")
print(f"wrote {OUT}")
print(f"{len(pub)} printed cells compared; {len(diff)} differ:")
for x in diff:
    print("  " + x)
