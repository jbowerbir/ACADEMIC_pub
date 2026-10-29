#!/usr/bin/env python3
"""
Reproduces every table and figure in Bower-Bir (2022), "Desert and
redistribution: Justice as a remedy for, and cause of, economic inequality",
Policy Studies Journal 50(4): 757-795. The same program as
script_replication.R, in Python.

Reads, from this folder:
  data_survey_psj-subset.csv   992 respondents, the 27 survey variables the
                               tables and figures use
  tables_as-published.md       the tables as printed, for the comparison
                               at the end (skipped if the file is absent)

Writes, to this folder:
  tables_corrected_python.md        Tables 1, A1, C1, C2, D1, and the eight
                                    regressions behind Figures D1 and D2, on
                                    the published sample (992 rows, 2014
                                    weight), with a list of every printed cell
                                    that differs appended at the end
  tables_final_python.md            the same tables on the 991 distinct
                                    respondents with the survey weight
                                    corrected, ending with every cell that
                                    changes at the printed precision
  tables_corrected-cells_python.md  the printed cells that differ from the
                                    re-run, one line each (written only when
                                    tables_as-published.md is present)
  figure_1_python.png, figure_*_published-sample_python.png,
  figure_*_final-data_python.png    the six figures: Figure 1 once, the other
                                    five from each data set

Sections, in order:
  1. The data and the two corrections it needs
  2. Variables the regressions build
  3. The 32 table regressions and Table A1
  4. The survey weight, re-raked
  5. Figures
  6. The final tables and the list of cells that change
  7. Comparison with the printed tables

Run from this folder:  python3 script_replication.py
Needs pandas, numpy, scipy, statsmodels, and matplotlib. Takes under a minute.

Two things carried over from the 2014 Stata code on purpose:
  - The Stata code recodes by exact comparison (`married == .8`). Here the
    values are rounded to the integer grid first, because 0.8 is stored as
    0.7999... and an exact test matches no rows.
  - The interaction terms are built on Definition rescaled to 0-1 (the Stata
    stored them under the unscaled names), and the Definition main effect is
    the rescaled variable in two of the six Table D1 regressions (Y_gov
    Model 1, Y_prog_tax Model 3) and the raw one in the other four. That is
    how the article's tables were estimated.
"""
import os
import re

import numpy as np
import pandas as pd
import statsmodels.api as sm
from scipy import stats
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


# ---- 1. The data and the two corrections it needs ----------------------------

OUT = "tables_corrected_python.md"
d = pd.read_csv("data_survey_psj-subset.csv")

# One respondent's record is in the file twice (rows identical in every
# answer). The published tables were estimated with it, and with a survey
# weight whose lowest income stratum was drawn one bracket too high (see
# rake() below). Every table is therefore estimated twice: on all 992 rows
# with the 2014 weight, which reproduces the published tables, and on the 991
# rows without the duplicate with the weight re-raked on the corrected strata,
# written to a second file with a list of every cell that changes at the
# printed precision.
dup_mask = d.drop(columns=["row", "id"]).duplicated()


# ---- 2. Variables the regressions build ---------------------------------------
# Every scale in the file is stored on a 0-1 grid. Where a recode needs the
# original answer codes, the scale is multiplied back and rounded first.

d["age_2"] = d["age"] * d["age"]

# employment: 0 is unemployed; the other seven codes are the employed, retired,
# student, homemaker, and other categories
d["unemployed_now"] = np.where(
    d["employment"] == 0, 1.0,
    np.where(d["employment"].isin([3, 2, 1, -1, -2, -3, -4]), 0.0, np.nan),
)

# married: six codes 0-5; 4 (living with partner) and 5 (married) count as married
d["married_bin"] = np.where((d["married"] * 5).round() >= 4, 1.0, 0.0)

# progressive taxation: seven codes 0-6; the four lowest collapse into one, so
# the outcome has four levels, 0, 1/3, 2/3, 1
p = (d["progtaxes_str"] * 6).round()
d["progtaxes2_str"] = np.where(p <= 3, 0, p - 3) / 3

# Definition (a correlation, -1 to 1) rescaled to 0-1 for the interaction terms
d["def_scaled"] = (d["corr_ideal_agency"] + 1) / 2
for z in ["agency_str", "justice_str", "desert_rich_tot", "desert_americans_tot", "desert_poor_tot"]:
    d["x_" + z] = d[z] * d["def_scaled"]

CTRL = ["ideo_str", "age", "age_2", "female", "nonwhite", "married_bin",
        "unemployed_now", "education", "income_household"]
EXTRA = ["goodlife_future", "gov_help_str", "charity_str"]
DES = ["desert_rich_tot", "desert_americans_tot", "desert_poor_tot"]
DEF = "corr_ideal_agency"
DEFS = "def_scaled"
GOV = "gov_reducegap_str"
TAX = "progtaxes2_str"

# the full desert block with its three interactions, as the .do orders it
DES_X = ["desert_rich_tot", "x_desert_rich_tot",
         "desert_americans_tot", "x_desert_americans_tot",
         "desert_poor_tot", "x_desert_poor_tot"]

# each variable's row label in the article; raw and rescaled Definition share
# one row
ROW = {DEF: "Definition", DEFS: "Definition",
       "agency_str": "Agency", "justice_str": "Justice",
       "desert_rich_tot": "Rich deserve",
       "desert_americans_tot": "Avg. deserve",
       "desert_poor_tot": "Poor deserve",
       "x_agency_str": "Def. x Agency", "x_justice_str": "Def. x Justice",
       "x_desert_rich_tot": "Def. x Rich",
       "x_desert_americans_tot": "Def. x Avg.",
       "x_desert_poor_tot": "Def. x Poor",
       "goodlife_future": "Good life", "gov_help_str": "Gov. help",
       "charity_str": "Charity", "ideo_str": "Ideology",
       "age": "Age", "age_2": "Age^2",
       "female": "Female", "nonwhite": "Nonwhite",
       "married_bin": "Married", "unemployed_now": "Unemployed",
       "education": "Education", "income_household": "Income"}

# the order the rows take in every table
ORDER = ["Definition", "Agency", "Def. x Agency", "Justice", "Def. x Justice",
         "Rich deserve", "Def. x Rich", "Avg. deserve", "Def. x Avg.",
         "Poor deserve", "Def. x Poor", "Good life", "Gov. help", "Charity",
         "Ideology", "Age", "Age^2", "Female", "Nonwhite", "Married",
         "Unemployed", "Education", "Income", "Constant"]


def stars(pv):
    return "***" if pv < 0.01 else "**" if pv < 0.05 else "*" if pv < 0.10 else ""


# ---- 3. The 32 table regressions and Table A1 ---------------------------------
# (table, column, outcome, predictors)

M = [
    ("Table 1", "Y_gov Model 1", GOV, [DEF, "agency_str"] + CTRL),
    ("Table 1", "Y_gov Model 2", GOV, [DEF, "justice_str"] + CTRL),
    ("Table 1", "Y_gov Model 3", GOV, [DEF] + DES + CTRL),
    ("Table 1", "Y_tax Model 1", TAX, [DEF, "agency_str"] + CTRL),
    ("Table 1", "Y_tax Model 2", TAX, [DEF, "justice_str"] + CTRL),
    ("Table 1", "Y_tax Model 3", TAX, [DEF] + DES + CTRL),

    ("Table C1: Y_gov_fix_gap", "gov Model A", GOV, CTRL),
    ("Table C1: Y_gov_fix_gap", "gov Model B", GOV, [DEF] + CTRL),
    ("Table C1: Y_gov_fix_gap", "gov Model C", GOV, ["agency_str"] + CTRL),
    ("Table C1: Y_gov_fix_gap", "gov Model D", GOV, ["justice_str"] + CTRL),
    ("Table C1: Y_gov_fix_gap", "gov Model E", GOV, DES + CTRL),
    ("Table C1: Y_prog_tax", "tax Model A", TAX, CTRL),
    ("Table C1: Y_prog_tax", "tax Model B", TAX, [DEF] + CTRL),
    ("Table C1: Y_prog_tax", "tax Model C", TAX, ["agency_str"] + CTRL),
    ("Table C1: Y_prog_tax", "tax Model D", TAX, ["justice_str"] + CTRL),
    ("Table C1: Y_prog_tax", "tax Model E", TAX, DES + CTRL),

    ("Table C2: Y_gov_fix_gap", "gov Model A", GOV, EXTRA + CTRL),
    ("Table C2: Y_gov_fix_gap", "gov Model B", GOV, [DEF] + EXTRA + CTRL),
    ("Table C2: Y_gov_fix_gap", "gov Model C", GOV, [DEF, "agency_str"] + EXTRA + CTRL),
    ("Table C2: Y_gov_fix_gap", "gov Model D", GOV, [DEF, "justice_str"] + EXTRA + CTRL),
    ("Table C2: Y_gov_fix_gap", "gov Model E", GOV, [DEF] + DES + EXTRA + CTRL),
    ("Table C2: Y_prog_tax", "tax Model A", TAX, EXTRA + CTRL),
    ("Table C2: Y_prog_tax", "tax Model B", TAX, [DEF] + EXTRA + CTRL),
    ("Table C2: Y_prog_tax", "tax Model C", TAX, [DEF, "agency_str"] + EXTRA + CTRL),
    ("Table C2: Y_prog_tax", "tax Model D", TAX, [DEF, "justice_str"] + EXTRA + CTRL),
    ("Table C2: Y_prog_tax", "tax Model E", TAX, [DEF] + DES + EXTRA + CTRL),

    ("Table D1: Y_gov_fix_gap", "gov Model 1", GOV, [DEFS, "agency_str", "x_agency_str"] + CTRL),
    ("Table D1: Y_gov_fix_gap", "gov Model 2", GOV, [DEF, "justice_str", "x_justice_str"] + CTRL),
    ("Table D1: Y_gov_fix_gap", "gov Model 3", GOV, [DEF] + DES_X + CTRL),
    ("Table D1: Y_prog_tax", "tax Model 1", TAX, [DEF, "agency_str", "x_agency_str"] + CTRL),
    ("Table D1: Y_prog_tax", "tax Model 2", TAX, [DEF, "justice_str", "x_justice_str"] + CTRL),
    ("Table D1: Y_prog_tax", "tax Model 3", TAX,
     [DEFS] + DES + ["x_desert_rich_tot", "x_desert_americans_tot", "x_desert_poor_tot"] + CTRL),
]


def design(sub, rhs, fe=True):
    """The regressors as a matrix: the predictors, a constant and, unless fe is
    False, an indicator for every state but one (the state fixed effects)."""
    X = sub[rhs].astype(float)
    if fe:
        dummies = pd.get_dummies(sub["state"].astype(int), prefix="st", drop_first=True)
        X = pd.concat([X, dummies.astype(float)], axis=1)
    return sm.add_constant(X)


def fit_table(dv, rhs, data):
    """One table regression: weighted least squares with state fixed effects and
    HC1 standard errors (Stata: areg ..., absorb(state) [pw=post_weight]).
    Returns each predictor's coefficient, standard error, and p-value, with N,
    R2, and adjusted R2."""
    sub = data[[dv] + rhs + ["post_weight", "state"]].dropna()
    X = design(sub, rhs)
    w = sub["post_weight"].astype(float)
    y = sub[dv].astype(float)
    r = sm.WLS(y, X, weights=w).fit(cov_type="HC1")
    n = int(r.nobs)
    k = X.shape[1]
    dfr = n - k
    pv = 2 * stats.t.sf(np.abs(r.params / r.bse), dfr)
    names = list(r.params.index)
    cells = {ROW[v]: (r.params[v], r.bse[v], pv[names.index(v)]) for v in rhs}
    # the constant as areg reports it: ybar - xbar'beta, with a delta-method
    # standard error
    xbar = np.average(sub[rhs].astype(float), axis=0, weights=w)
    V = r.cov_params().loc[rhs, rhs].values
    cons = np.average(y, weights=w) - xbar @ r.params[rhs].values
    cse = float(np.sqrt(xbar @ V @ xbar))
    cells["Constant"] = (cons, cse, 2 * stats.t.sf(abs(cons / cse), dfr))
    return {"cells": cells, "N": n, "R2": r.rsquared, "AdjR2": r.rsquared_adj}


def cell_text(e, r, what):
    """One table cell: the coefficient with its stars, or the standard error in
    parentheses; empty if the variable is not in this model."""
    if r not in e["cells"]:
        return ""
    c = e["cells"][r]
    if what == "coef":
        return f"{c[0]:.3f}{stars(c[2])}"
    return f"({c[1]:.3f})"


def tables_md(data):
    """Estimate the 32 regressions and Table A1 on one data set; return the
    results and their markdown."""
    res = [(t, c, fit_table(dv, rhs, data)) for t, c, dv, rhs in M]

    # the regression tables
    md = []
    for tb in dict.fromkeys(t for t, _, _ in res):
        rs = [(c, e) for t, c, e in res if t == tb]
        cols = [c for c, _ in rs]
        md += ["", f"## {tb}",
               "| Variable | " + " | ".join(cols) + " |",
               "|---" * (len(rs) + 1) + "|"]
        present = [r for r in ORDER if any(r in e["cells"] for _, e in rs)]
        for r in present:
            md.append(f"| {r} | " + " | ".join(cell_text(e, r, "coef") for _, e in rs) + " |")
            md.append("| | " + " | ".join(cell_text(e, r, "se") for _, e in rs) + " |")
        md.append("| N | " + " | ".join(str(e["N"]) for _, e in rs) + " |")
        md.append("| R2 | " + " | ".join(f"{e['R2']:.4f}" for _, e in rs) + " |")
        md.append("| Adj-R2 | " + " | ".join(f"{e['AdjR2']:.4f}" for _, e in rs) + " |")

    # Table A1, the sample's composition; education and income back on their
    # answer codes (seven and nineteen levels)
    edu = (data["education"] * 6).round()
    inc = (data["income_household"] * 18).round()
    A1 = [
        ("Gender", [("Female", data["gender"] == 0),
                    ("Male", data["gender"] == 1)]),
        ("Race", [("White", data["race"] == 0),
                  ("Black", data["race"] == 1),
                  ("Latino", data["race"] == 2),
                  ("Asian", data["race"] == 4),
                  ("Other", data["race"].isin([3, 5, 6]))]),
        ("Education", [("High school or less", edu <= 2),
                       ("Associate's or some college", edu.isin([3, 4])),
                       ("Bachelor's degree", edu == 5),
                       ("Graduate degree", edu == 6)]),
        ("Household income", [("< $25k", inc <= 6),
                              ("$25k-$49k", inc.between(7, 10)),
                              ("$50k-$74k", inc.between(11, 12)),
                              ("$75k-$99k", inc.between(13, 14)),
                              ("$100k-$149k", inc.between(15, 16)),
                              ("$150k+", inc >= 17)]),
        ("Political party", [("Republican", data["party"] <= -2),
                             ("Lean Republican", data["party"] == -1),
                             ("Independent", data["party"] == 0),
                             ("Lean Democrat", data["party"] == 1),
                             ("Democrat", data["party"] >= 2)]),
    ]
    a1 = ["", "## Table A1", "| Group | Sample N | Sample share |", "|---|---|---|"]
    for g, rows in A1:
        for lab, mask in rows:
            n = int(mask.sum())
            a1.append(f"| {g}: {lab} | {n} | {n / len(data):.2f} |")

    # the article's order is Table 1, then A1, then C1: insert A1 before the
    # blank line that precedes the C1 heading
    i = md.index("## Table C1: Y_gov_fix_gap") - 1
    return res, md[:i] + a1 + md[i:]


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
# the $25,000 line is code 7. With income_cut=8 the function reproduces the
# shipped weight; the final tables use income_cut=7.

def rake(x, income_cut=8):
    inc = (x["income_household"] * 18).round()
    edu = (x["education"] * 6).round()
    strata = {
        "gender": x["gender"].values,
        "party": np.select([x.party >= 2, x.party == 1, x.party == 0, x.party == -1, x.party <= -2],
                           [1, 2, 3, 4, 5]),
        "income": np.select([inc < income_cut, inc < 11, inc < 13, inc < 15, inc >= 15],
                            [1, 2, 3, 4, 5]),
        "race": np.select([x.race == 0, x.race == 1, x.race == 2, x.race >= 3], [1, 2, 3, 4]),
        "educ": np.select([edu <= 1, edu == 2, edu.isin([3, 4]), edu == 5, edu == 6],
                          [1, 2, 3, 4, 5]),
    }
    targets = {
        "gender": {1: 486, 0: 506},
        "party": {1: 317, 2: 159, 3: 119, 4: 159, 5: 238},
        "income": {1: 245, 2: 249, 3: 182, 4: 120, 5: 196},
        "race": {1: 632, 2: 121, 3: 162, 4: 77},
        "educ": {1: 122, 2: 301, 3: 292, 4: 166, 5: 111},
    }
    w = np.ones(len(x))
    for _ in range(500):
        w0 = w.copy()
        for g, t in targets.items():
            for lvl, tot in t.items():
                m = strata[g] == lvl
                w[m] *= (tot * len(x) / 992) / w[m].sum()
        if np.abs(w - w0).max() < 1e-12:
            break
    return w


# check: raked on all 992 rows, the method reproduces the shipped weight
assert np.abs(rake(d) - d["post_weight"].values).max() < 1e-4

PREAMBLE_CORRECTED = (
    "The published tables with their typos corrected, estimated on the published sample of 992 "
    "observations with the 2014 weight. Written by script_replication.R (tables_corrected_R.md) "
    "and script_replication.py (tables_corrected_python.md); the two files are identical. The "
    "last section lists every cell that differs from the published tables."
)
PREAMBLE_FINAL = (
    "The same tables estimated on the 991 distinct respondents, without the duplicated row and "
    "with the survey weight corrected. Written by script_replication.R (tables_final_R.md) and "
    "script_replication.py (tables_final_python.md); the two files are identical. The last "
    "section lists every cell that differs from the corrected tables (tables_corrected_R.md)."
)

res, md = tables_md(d)
md = ["# Corrected tables", "", PREAMBLE_CORRECTED] + md
d991 = d[~dup_mask].reset_index(drop=True)
d991["post_weight"] = rake(d991, income_cut=7)
res_dedup, md_dedup = tables_md(d991)
md_dedup = ["# Final tables", "", PREAMBLE_FINAL] + md_dedup


# ---- 5. Figures ------------------------------------------------------------------
# Drawn twice: from the published sample (992 rows, 2014 weight), which
# reproduces the printed figures, and from the final data (991 rows, corrected
# weight) as figure_*_final-data_python.png. Returns the rows of the D1 and D2
# regressions for the tables file.

plt.rcParams.update({"font.family": "serif", "font.size": 9})


def silverman(x):
    """Silverman's rule-of-thumb bandwidth, the default in R's density() and
    Stata's kdensity."""
    x = x[~np.isnan(x)]
    iqr = np.subtract(*np.percentile(x, [75, 25]))
    return 0.9 * min(x.std(ddof=1), iqr / 1.34) * len(x) ** -0.2


def dens(v, grid):
    """A Gaussian kernel density of v, evaluated at each point of grid."""
    x = v[~np.isnan(v)]
    h = silverman(x)
    return np.array([stats.norm.pdf((g - x) / h).sum() / (len(x) * h) for g in grid])


def scale_back(v):
    """A 0-1 score back to its original -1 to 1 scale."""
    return 2 * v - 1


def hide_spines(ax, sides):
    for s in sides:
        ax.spines[s].set_visible(False)


def save(fig, name):
    fig.tight_layout()
    fig.savefig(name, dpi=200)
    plt.close(fig)


def draw_figures(d, sfx):
    rows = []

    if sfx == "_published-sample":
        # Figure 1: the General Social Survey percentages the article charts
        # (not from this survey), so it is drawn once
        agree = [0.45, 0.5916, 0.6653]
        disagree = [0.52, 0.4084, 0.1647]
        unsure = [1 - a - b for a, b in zip(agree, disagree)]
        labels = ["the income gap is a\nproblem that needs fixing",
                  "there are strong conflicts\nbetween the rich and poor",
                  "differences in income\nare too large"]
        fig, ax = plt.subplots(figsize=(6.5, 2.4))
        left = np.zeros(3)
        for vals, col, lab in [(disagree, "0.85", "disagree"),
                               (unsure, "0.6", "unsure"),
                               (agree, "0.3", "agree")]:
            ax.barh(labels, vals, left=left, color=col, label=lab)
            left += np.array(vals)
        ax.axvline(0.5, ls=":", color="k")
        ax.set_xlim(0, 1)
        ax.legend(ncol=3, frameon=False, loc="lower right", bbox_to_anchor=(1, 1))
        hide_spines(ax, ["top", "right", "left"])
        save(fig, "figure_1_python.png")

    # Figures 2 and 3: kernel densities (Gaussian kernel, Silverman's default
    # bandwidth, as Stata's kdensity default). Figure 2 is computed on the 0-1
    # standardized scores and labeled on their original -1 to 1 scale, which is
    # how the 2014 plot was drawn; its heights match the printed figure. Figure 3
    # is the raw correlation; the printed figure is more heavily smoothed than
    # the default here, and the smoothing it used is not recorded. The grids run
    # a little past the data's range so the curves reach the axis.
    grid = np.linspace(-0.15, 1.15, 512)
    fig, ax = plt.subplots(figsize=(6.5, 4))
    for v, ls, lab in [("desert_rich_tot", "-", "rich"),
                       ("desert_americans_tot", ":", "average"),
                       ("desert_poor_tot", "--", "poor")]:
        ax.plot(scale_back(grid), dens(d[v].values, grid), ls=ls, color="k", lw=2, label=lab)
    ax.set_xlim(-1, 1)
    ax.set_ylim(0, 2.8)
    ax.set_xlabel("Deservingness")
    ax.legend(frameon=False)
    hide_spines(ax, ["top", "right"])
    save(fig, f"figure_2{sfx}_python.png")

    grid3 = np.linspace(-1.1, 1.1, 512)
    fig, ax = plt.subplots(figsize=(6.5, 4))
    ax.plot(grid3, dens(d["corr_ideal_agency"].values, grid3), color="k", lw=2)
    ax.set_xlim(-1, 1)
    ax.set_xlabel("Control-Ideal Importance correlation")
    hide_spines(ax, ["top", "right"])
    save(fig, f"figure_3{sfx}_python.png")

    # Figure 4: share of respondents in each cell of (rich deserve their wealth)
    # x (income differences are too large). The 2014 figure dropped the
    # duplicated respondent record (two rows identical in every answer; the
    # second is dropped). Each axis is put back on its answer codes: 13 columns
    # from -6 to 6, 7 rows from -3 to 3.
    d4 = d[~d.drop(columns=["row", "id"]).duplicated()]
    ix = scale_back(d4["desert_rich_tot"]).mul(6).round().astype(int)
    iy = scale_back(d4["diff_large"]).mul(3).round().astype(int)
    tab = pd.crosstab(iy, ix).reindex(index=range(-3, 4), columns=range(-6, 7), fill_value=0)
    tab = tab / len(d4)
    fig, ax = plt.subplots(figsize=(6.5, 4.2))
    ax.imshow(tab.values, origin="lower", cmap="Greys", aspect="auto",
              extent=(-6.5, 6.5, -3.5, 3.5))
    ax.set_xticks([-6, 0, 6])
    ax.set_xticklabels(["VC, VU", "NC, ND/U", "VC, VD"])
    ax.set_yticks([-3, 0, 3])
    ax.set_yticklabels(["SD", "N", "SA"])
    ax.set_xlabel("Do the rich deserve their wealth?")
    ax.set_ylabel("Are income differences too large?")
    save(fig, f"figure_4{sfx}_python.png")

    # Figures D1 and D2: marginal-effect plots. Each panel: an ordinary weighted
    # regression with the interaction, errors clustered by state (Stata:
    # reg ... [pw=post_weight], cluster(state)); the marginal effect of X at each
    # value of the moderator Z, b1 + b3*Z, with a 95% band, over a histogram of Z.
    # D2 reverses the roles: the marginal effect of Z at each value of Definition.

    def cluster_fit(dv, rhs):
        sub = d[[dv] + rhs + ["post_weight", "state"]].dropna()
        X = design(sub, rhs, fe=False)
        w = sub["post_weight"].astype(float)
        groups = sub["state"].astype(int).values
        r = sm.WLS(sub[dv].astype(float), X, weights=w).fit(
            cov_type="cluster",
            cov_kwds={"groups": groups, "use_correction": True, "df_correction": True},
        )
        return r, sub

    # the right-hand side of each plot regression: the first term (rescaled
    # Definition for the D1 panels, the moderator for D2), the moderator and its
    # product with rescaled Definition, and the controls; for the rich-deserve
    # panels all three deserve variables and their products enter together
    def plot_rhs(first, zvar):
        block = DES_X if zvar == "desert_rich_tot" else [zvar, "x_" + zvar]
        return [first] + block + CTRL

    def me_panel(ax, dv, xvar, zvar, rhs, xlab, ylab, ylim, zhist, bins, title, rug=False):
        r, sub = cluster_fit(dv, rhs)
        ix = "x_" + zvar
        V = r.cov_params()
        b1, b3 = r.params[xvar], r.params[ix]
        v1, v3, c13 = V.loc[xvar, xvar], V.loc[ix, ix], V.loc[xvar, ix]
        zz = np.linspace(0, 1, 101)
        me = b1 + b3 * zz
        band = 1.96 * np.sqrt(v1 + v3 * zz ** 2 + 2 * c13 * zz)
        # the histogram of Z on a second axis, behind the lines
        ax2 = ax.twinx()
        cnt, edges = np.histogram(sub[zhist], bins=bins)
        width = (edges[1] - edges[0]) * (0.5 if rug else 0.6)
        ax2.bar((edges[:-1] + edges[1:]) / 2, 100 * cnt / cnt.sum(), width=width,
                color="0.8", zorder=0)
        ax2.set_ylabel("Percentage of observations", fontsize=7)
        ax2.tick_params(labelsize=7)
        ax.set_zorder(ax2.get_zorder() + 1)
        ax.patch.set_visible(False)
        ax.plot(zz, me, "k", lw=2)
        ax.plot(zz, me + band, "k--", lw=1)
        ax.plot(zz, me - band, "k--", lw=1)
        ax.axhline(0, color="k", lw=1)
        if rug:
            ax.plot(sub[zhist], np.full(len(sub), ylim[0]), "|", color="0.3", ms=6)
        ax.set_xlim(0, 1)
        ax.set_ylim(*ylim)
        ax.set_xlabel(xlab, fontsize=7)
        ax.set_ylabel(ylab, fontsize=7)
        ax.set_title(title, fontsize=8)
        ax.tick_params(labelsize=7)
        return (f"| {title} | {dv} | {zvar} | {b1:.3f} | {np.sqrt(v1):.3f} | {b3:.3f} | "
                f"{np.sqrt(v3):.3f} | {int(r.nobs)} |")

    rows += ["", "## Figure D1 and D2 regressions",
             "| Panel | Outcome | Z | b(X) | SE | b(X x Z) | SE | N |",
             "|---|---|---|---|---|---|---|---|"]

    X_LAB = "Marginal effect of definition"
    AGENCY = "Belief that peoples' economic standing is within their control"
    JUST = "Belief that economic desert is rewarded"
    RICH = "Belief that rich Americans deserve their wealth"
    # 24 bins of width 1/24, offset half a bin so each answer level sits in the
    # middle of a bar
    bins24 = np.arange(-1 / 48, 1 + 1 / 48 + 1e-9, 1 / 24)

    fig, axes = plt.subplots(2, 2, figsize=(7, 6))
    rows.append(me_panel(axes[0, 0], GOV, DEFS, "agency_str", plot_rhs(DEFS, "agency_str"),
                         AGENCY, X_LAB, (-3, 1), "agency_str", bins24,
                         "D1(a) X given Z_agency, on Y_gov_fix_gap"))
    rows.append(me_panel(axes[0, 1], GOV, DEFS, "justice_str", plot_rhs(DEFS, "justice_str"),
                         JUST, X_LAB, (-3, 1), "justice_str", bins24,
                         "D1(b) X given Z_justice, on Y_gov_fix_gap"))
    rows.append(me_panel(axes[1, 0], GOV, DEFS, "desert_rich_tot", plot_rhs(DEFS, "desert_rich_tot"),
                         RICH, X_LAB, (-3, 1), "desert_rich_tot", bins24,
                         "D1(c) X given Z_rich_deserve, on Y_gov_fix_gap"))
    rows.append(me_panel(axes[1, 1], TAX, DEFS, "agency_str", plot_rhs(DEFS, "agency_str"),
                         AGENCY, X_LAB, (-3, 1), "agency_str", bins24,
                         "D1(d) X given Z_agency, on Y_prog_tax"))
    save(fig, f"figure_D1{sfx}_python.png")

    Z_LAB = "Importance of agency to definition of desert"
    bins100 = np.linspace(0, 1, 101)

    fig, axes = plt.subplots(2, 2, figsize=(7, 6))
    rows.append(me_panel(axes[0, 0], GOV, "agency_str", "agency_str",
                         ["agency_str", DEFS, "x_agency_str"] + CTRL,
                         Z_LAB, "Marginal effect of belief in economic agency",
                         (-2, 7), DEFS, bins100,
                         "D2(a) Z_agency given X, on Y_gov_fix_gap", rug=True))
    rows.append(me_panel(axes[0, 1], GOV, "justice_str", "justice_str",
                         ["justice_str", DEFS, "x_justice_str"] + CTRL,
                         Z_LAB, "Marginal effect of belief that economic desert is rewarded",
                         (-2, 7), DEFS, bins100,
                         "D2(b) Z_justice given X, on Y_gov_fix_gap", rug=True))
    rows.append(me_panel(axes[1, 0], GOV, "desert_rich_tot", "desert_rich_tot",
                         ["desert_rich_tot", DEFS, "x_desert_rich_tot", "desert_americans_tot",
                          "x_desert_americans_tot", "desert_poor_tot", "x_desert_poor_tot"] + CTRL,
                         Z_LAB, "Marginal effect of belief that rich Americans deserve their wealth",
                         (-2, 7), DEFS, bins100,
                         "D2(c) Z_rich_deserve given X, on Y_gov_fix_gap", rug=True))
    rows.append(me_panel(axes[1, 1], TAX, "agency_str", "agency_str",
                         ["agency_str", DEFS, "x_agency_str"] + CTRL,
                         Z_LAB, "Marginal effect of belief in economic agency",
                         (-2, 7), DEFS, bins100,
                         "D2(d) Z_agency given X, on Y_prog_tax", rug=True))
    save(fig, f"figure_D2{sfx}_python.png")
    return rows


md += draw_figures(d, "_published-sample")
md_dedup += draw_figures(d991, "_final-data")
open(OUT, "w", encoding="utf-8").write("\n".join(md) + "\n")


# ---- 6. The final tables and the list of cells that change ------------------------
# Same layout, 991 rows, followed by every regression cell whose coefficient,
# standard error, or stars differ from the as-published tables above.

def fmt(c):
    """A cell as printed: the coefficient with its stars, and the standard error."""
    return f"{c[0]:.3f}{stars(c[2])}", f"({c[1]:.3f})"


def where(t, c):
    """A regression's place in the article, named as printed:
    ('Table C1: Y_gov_fix_gap', 'gov Model A') -> 'Table C1 | Y_gov_fix_gap | Model A'."""
    pre, model = c.split(" ", 1)
    outcome = {"gov": "Y_gov_fix_gap", "tax": "Y_prog_tax"}[pre.replace("Y_", "")]
    return f"{t.split(':')[0]} | {outcome} | {model}"


changes = []
for (t, c, e), (_, _, e2) in zip(res, res_dedup):
    for r in e["cells"]:
        fa, fb = fmt(e["cells"][r]), fmt(e2["cells"][r])
        if fa != fb:
            changes.append(f"| {where(t, c)} | {r} | {fa[0]} {fa[1]} | {fb[0]} {fb[1]} |")


# Table A1 too: the duplicated respondent is counted once fewer in each of
# their groups
def a1_rows(lines):
    i = lines.index("## Table A1")
    rows = (l.strip("|").split("|") for l in lines[i + 3:])
    return [cells for cells in rows if len(cells) == 3]


a1_before = a1_rows(md[:md.index("## Table C1: Y_gov_fix_gap")])
a1_after = a1_rows(md_dedup[:md_dedup.index("## Table C1: Y_gov_fix_gap")])
for (g, n1, s1), (_, n2, s2) in zip(a1_before, a1_after):
    if (n1, s1) != (n2, s2):
        # table order: after Table 1 and any A1 rows already placed
        k = sum(ch.startswith("| Table 1 |") for ch in changes)
        k += sum(ch.startswith("| Table A1 |") for ch in changes)
        changes.insert(k, f"| Table A1 | | | {g.strip()} | {n1.strip()} ({s1.strip()}) | "
                          f"{n2.strip()} ({s2.strip()}) |")

dd = md_dedup + [
    "", "## Cells that change with the two data fixes",
    "As published: 992 rows, the 2014 weight. Final: 991 rows, the duplicate removed, the weight corrected.",
    "",
    "| Table | Outcome | Model | Row | As published | Final |",
    "|---|---|---|---|---|---|",
] + changes
open("tables_final_python.md", "w", encoding="utf-8").write("\n".join(dd) + "\n")
n_changed = sum(not ch.startswith("| Table A1") for ch in changes)
n_cells = sum(len(e["cells"]) for _, _, e in res)
print(f"wrote tables_final_python.md: {n_changed} of {n_cells} regression cells change "
      "at the printed precision")
print(f"wrote {OUT} and the figures, figure_*_python.png")


# ---- 7. Comparison with the printed tables -------------------------------------
# Every cell of Tables 1, C1, C2, and D1 against tables_as-published.md, a
# transcription of the printed article. Cells agree when they match to the
# printed decimals; the tolerances below are half a unit in the last printed
# digit, except adjusted R2, which is allowed 0.0004 because one printed
# adjusted R2 sits 0.0002 from the re-estimate.

PUB = "tables_as-published.md"
if os.path.exists(PUB):

    def parse_md(path):
        """{section: {column: {row: {'coef': ..., 'se': ...}}}} for a markdown
        file of tables; a standard-error row belongs to the row above it."""
        tables, cur, cols, last = {}, None, None, None
        for line in open(path, encoding="utf-8"):
            line = line.rstrip("\n")
            if line.startswith("## "):
                cur = line[3:].strip()
                tables[cur] = {}
                cols = None
                continue
            if cur is None or not line.startswith("|") or set(line) <= set("|- "):
                continue
            cells = [c.strip() for c in line.strip("|").split("|")]
            if cols is None:
                cols = cells[1:]
                continue
            name, vals = cells[0], cells[1:]
            if name:
                last = name
                for c, v in zip(cols, vals):
                    if v:
                        tables[cur].setdefault(c, {})[name] = {"coef": v}
            else:
                for c, v in zip(cols, vals):
                    if v:
                        tables[cur][c][last]["se"] = v
        return tables

    def num(s):
        """A printed cell as a number; the published file uses a Unicode minus
        sign, and stars and parentheses are dropped."""
        return float(s.replace("−", "-").replace("*", "").strip("()"))

    pub = parse_md(PUB)
    mism = []
    side = []
    ncell = 0
    for t, c, e in res:
        for row, cell in pub.get(t, {}).get(c, {}).items():
            ncell += 1
            tag = f"{where(t, c)} | {row}"
            if row in ("N", "R2", "Adj-R2"):
                got = {"N": e["N"], "R2": e["R2"], "Adj-R2": e["AdjR2"]}[row]
                tol = {"N": 0.5, "R2": 0.00005, "Adj-R2": 0.0004}[row]
                if abs(got - num(cell["coef"])) > tol:
                    mism.append(f"{tag}: printed {cell['coef']}, re-estimated {got:g}")
                    side.append(f"| {tag} | {cell['coef']} | {got:g} |")
                continue
            if row not in e["cells"]:
                mism.append(f"{tag}: printed but not in this model")
                continue
            b, se, pv = e["cells"][row]
            probs = []
            if abs(b - num(cell["coef"])) > 0.0005:
                probs.append(f"coef printed {cell['coef'].replace('*', '')}, re-estimated {b:.3f}")
            if row != "Constant" and "se" in cell and abs(se - num(cell["se"])) > 0.0005:
                probs.append(f"SE printed {cell['se']}, re-estimated ({se:.3f})")
            ps = re.sub(r"[^*]", "", cell["coef"])
            if row != "Constant" and ps != stars(pv):
                probs.append(f"stars printed {ps or 'none'}, earned {stars(pv) or 'none'}")
            if probs:
                mism.append(f"{tag}: " + "; ".join(probs))
                side.append(f"| {tag} | {cell['coef']} {cell.get('se', '')} | "
                            f"{' '.join(fmt(e['cells'][row]))} |")

    print(f"\nCompared {ncell} cells with {PUB} (the constant's SE and stars are not compared).")
    if not mism:
        print("Every cell matches.")
    else:
        print(f"{len(mism)} cells differ between the printed tables and the re-run:")
        for m in mism:
            print("  " + m)

    # the same list as a file: the cell-by-cell record of the transcription
    # errors (stars escaped so a markdown viewer shows them)
    open("tables_corrected-cells_python.md", "w", encoding="utf-8").write("\n".join(
        ["# Cells where the printed tables differ from the re-run", "(992 observations)", "",
         "Each line: table | outcome | model | row: what was printed, what the re-run gives.", ""]
        + ["- " + m.replace("*", r"\*") for m in mism]) + "\n")

    # and side by side at the end of the corrected tables: each printed cell
    # beside its corrected value
    open(OUT, "a", encoding="utf-8").write("\n".join(
        ["", "## Cells that differ from the published tables",
         "| Table | Outcome | Model | Row | Published | Corrected |",
         "|---|---|---|---|---|---|"] + side) + "\n")
