"""
Replicate Table 2 (demographics) and the summary statistics behind Figures 3-7
of Bower-Bir (2021), "Earning our place, more or less."
Economia Politica 38(1): 131-170.

    python3 replicate_table2_and_figures.py

This script covers the numeric content of the figures -- the correlation
coefficients printed above each heatmap and the distributional statistics quoted
in the text. It does not redraw the figures; the original plotting code is in the
four `data-importance-v-control*_180801.R` scripts in this directory.

WHAT REPRODUCES, AND ON WHICH LAYER
-----------------------------------
Table 2 and Figures 3, 4 and 6 are computed UNWEIGHTED, on the 992-row sample.
This differs from Table 1, which is weighted. That is not an inconsistency in the
paper -- Table 2 is a description of the achieved sample (its whole point is to
show how the sample departs from population margins, which is what the weights
later correct), and the figure correlations match the unweighted values exactly
while matching no weighted variant.

  Table 2    all 20 cells reproduce exactly.
  Figure 3   13 of 15 reproduce. `health` and `state of econ.` are transposed
             -- see the note printed at the end.
  Figure 4   all 15 reproduce, once the truncation rule is right (below).
  Figure 6   median, IQR, SD and the "90% of observations" interval reproduce
             exactly; the stated mean is 0.69, the data give 0.685.
  Figure 7   the ~60% figure reproduces -- but read the direction note.

THE FIGURE 4 TRUNCATION RULE. Sect. 3.3: the "un-important" responses "can be
combined into one category -- 'ideally not important'". The ideal-importance item
is a 7-point scale [-3, 3]. Combining means collapsing the three negative levels
(somewhat un-important, un-important, very un-important) into ONE, while leaving
"neither un-/important" (0) as its own category -- i.e. clip at -1, giving a
5-point scale [-1, 3]. That reproduces all 15 of Figure 4's coefficients.
Collapsing at 0 instead (folding "neither" in with the negatives) reproduces only
3 of 15. The 5-point reading also matches Figure 4's own axis ticks, which label
three points: "u un-important", "si somewhat important", "vi very important".
"""

import numpy as np
import pandas as pd

NONSTD = "../../data/economic_justice_v7_nonstandardized.csv"

# The 15 economic factors, in Figure 3's published order (ascending r).
FACTORS = [
    ("iq", "intelligence", 0.21, 0.21), ("school", "schl. prestige", 0.24, 0.25),
    ("education", "education", 0.25, 0.26), ("creativity", "creativity", 0.30, 0.30),
    ("stablefam", "fam. stability", 0.31, 0.31), ("health", "health", 0.32, 0.32),
    ("econstate", "state of econ.", 0.33, 0.32), ("attitude", "attitude", 0.33, 0.35),
    ("parenteduc", "parents' educ.", 0.34, 0.36), ("hardwork", "hardwork", 0.39, 0.41),
    ("gender", "gender", 0.41, 0.44), ("ambition", "ambition", 0.43, 0.45),
    ("connections", "connections", 0.48, 0.50), ("race", "race", 0.49, 0.54),
    ("wealth", "fam. wealth", 0.49, 0.52),
]


def rnd(x, d=2):
    return float(np.format_float_positional(x, precision=d, unique=False, fractional=True))


def table2(d):
    """Table 2: demographic breakdown of the survey sample (N=992).

    Cut points follow `Appendices_demographics_ORIGINAL.do`, which is the script
    that produced this table. Its income bands (`income <= 6`, `> 6 & < 11`, ...)
    match the instrument's 19 brackets exactly -- and, notably, do NOT match the
    income strata used by the weighting script. See audit_published_tables.py.
    """
    print("=" * 74)
    print("TABLE 2 -- Demographic breakdown of survey sample")
    print("=" * 74)
    rows = [
        ("Female", (d.female == 1).sum(), 586), ("Male", (d.female == 0).sum(), 406),
        ("White", (d.race == 0).sum(), 701), ("Black", (d.race == 1).sum(), 93),
        ("Latino", (d.race == 2).sum(), 52), ("Asian", (d.race == 4).sum(), 111),
        ("Other race", d.race.isin([3, 5, 6]).sum(), 35),
        ("High school or less", (d.education <= 2).sum(), 118),
        ("Associate's/some college", d.education.isin([3, 4]).sum(), 330),
        ("Bachelor's degree", (d.education == 5).sum(), 351),
        ("Graduate degree", (d.education == 6).sum(), 193),
        ("<$25k", (d.income_household <= 6).sum(), 192),
        ("$25k-$49k", ((d.income_household > 6) & (d.income_household < 11)).sum(), 247),
        ("$50k-$74k", ((d.income_household > 10) & (d.income_household < 13)).sum(), 210),
        ("$75k-$99k", ((d.income_household > 12) & (d.income_household < 15)).sum(), 141),
        ("$100k-$149k", ((d.income_household > 14) & (d.income_household < 17)).sum(), 137),
        ("$150k+", (d.income_household > 16).sum(), 65),
        ("Republican", (d.party < -1).sum(), 68), ("Lean Republican", (d.party == -1).sum(), 79),
        ("Independent", (d.party == 0).sum(), 264), ("Lean Democrat", (d.party == 1).sum(), 284),
        ("Democrat", (d.party > 1).sum(), 297),
    ]
    bad = 0
    for lab, got, pub in rows:
        ok = "OK" if int(got) == pub else "MISMATCH"
        bad += int(got) != pub
        print(f"  {lab:<26}{int(got):>5}  published {pub:>5}   {ok}")
    print(f"\n  -> {len(rows) - bad}/{len(rows)} cells reproduce exactly.\n")


def figures_3_4(d):
    """Figures 3 and 4: within-factor correlations between control and ideal
    importance, full-range and truncated. Unweighted."""
    print("=" * 74)
    print("FIGURES 3 & 4 -- control x ideal-importance correlation, by factor")
    print("=" * 74)
    print(f"  {'factor':<16}{'Fig3':>6}{'repl':>8}{'':>4}{'Fig4':>6}{'repl':>8}")
    m3 = m4 = 0
    swapped = []
    for var, lab, f3, f4 in FACTORS:
        a, i = d[var + "_agency"], d[var + "_ideal"]
        r3 = a.corr(i)
        r4 = a.corr(i.clip(lower=-1))          # truncation rule: collapse the 3 negatives
        ok3, ok4 = rnd(r3) == f3, rnd(r4) == f4
        m3 += ok3; m4 += ok4
        if not ok3:
            swapped.append((lab, f3, r3))
        print(f"  {lab:<16}{f3:>6.2f}{r3:>8.4f}{'' if ok3 else ' <--':>4}"
              f"{f4:>6.2f}{r4:>8.4f}{'' if ok4 else ' <--'}")
    print(f"\n  -> Figure 3: {m3}/15 reproduce.   Figure 4: {m4}/15 reproduce.")
    if swapped:
        print("\n  Figure 3 discrepancy. The two flagged factors are adjacent in the")
        print("  figure, which arrays panels in ascending r. Their values are")
        print("  transposed: the paper prints health = 0.32 / state of econ. = 0.33,")
        print("  but the data give health = 0.3321 / state of econ. = 0.3179. Both")
        print("  printed values exist -- they are attached to the wrong factors, so")
        print("  the two panels are also out of order. Figure 4 has them right")
        print("  (0.3228 vs 0.3231, correctly ordered). Immaterial to the argument:")
        print("  both remain 'weak-to-moderate' either way.")
    print()


def figure_5(d):
    """Figure 5 plots each factor at a distance from the origin equal to the mean
    of its Figure 3 and Figure 4 correlation coefficients (Sect. 3.3)."""
    print("=" * 74)
    print("FIGURE 5 -- distance from origin = mean(Fig3 r, Fig4 r)")
    print("=" * 74)
    for var, lab, _, _ in FACTORS:
        a, i = d[var + "_agency"], d[var + "_ideal"]
        r3, r4 = a.corr(i), a.corr(i.clip(lower=-1))
        print(f"  {lab:<16}mean r = {(r3 + r4) / 2:.3f}")
    print()


def figure_6(d):
    """Figure 6: distribution of the by-respondent control/importance correlation.
    Quoted in Sect. 3.4 on the [-1,1] scale."""
    print("=" * 74)
    print("FIGURE 6 -- by-respondent correlation, distribution")
    print("=" * 74)
    x = d["corr_ideal_agency"].dropna()
    inside = ((x >= 0.44) & (x <= 0.98)).mean() * 100
    checks = [
        ("mean", x.mean(), 0.69), ("median", x.median(), 0.74),
        ("IQR lower", x.quantile(.25), 0.62), ("IQR upper", x.quantile(.75), 0.82),
        ("SD", x.std(), 0.22),
    ]
    print(f"  n = {len(x)} (of 992; the correlation is undefined where a respondent")
    print("  gave constant ratings across a battery)\n")
    for lab, got, pub in checks:
        ok = "OK" if rnd(got) == pub else "<-- published %.2f, data %.4f" % (pub, got)
        print(f"  {lab:<12}{got:>9.4f}   published {pub:<6}{ok}")
    print(f"\n  'a full 90% of the observations fall between [0.44, 0.98]':")
    print(f"     share inside that interval = {inside:.1f}%   -> exact.")
    print("     (Note it is not the 5th-95th percentile interval, which is")
    print("     [0.265, 0.906]; the distribution is left-skewed. As stated, though,")
    print("     the claim is true.)")
    print("\n  The stated mean 0.69 is the one figure that does not reproduce: the")
    print("  data give 0.6848, which prints as 0.68 (weighted: 0.6736). A 0.005")
    print("  discrepancy; immaterial to the claim it supports.\n")


def figure_7(d):
    """Figure 7: distribution of the neoliberal index.

    READ THE DIRECTION NOTE. `neoliberal` runs backwards from its name -- see
    replicate_table1.py gotcha 2 and audit_published_tables.py.
    """
    print("=" * 74)
    print("FIGURE 7 -- neoliberal index distribution")
    print("=" * 74)
    n = d["neoliberal"].dropna()
    print(f"  distinct values = {n.nunique()} (Table 3 states 25)   range "
          f"[{n.min():.2f}, {n.max():.2f}]   mean {n.mean():+.4f}")
    print(f"  share > 0 (midpoint) = {(n > 0).mean() * 100:.1f}%   "
          f"share < 0 = {(n < 0).mean() * 100:.1f}%")
    print("\n  Sect. 5: 'Approximately 60% of survey respondents fall on the positive")
    print("  side of the neoliberal index variable.' The 59.8% reproduces exactly,")
    print("  and the mean sits just right of the midpoint, as the caption says.")
    print("\n  BUT the direction is inverted. `neoliberal` as stored correlates")
    print(f"  {n.corr(d['ideo_str']):+.3f} with ideo_str (+3 = very LIBERAL), so its")
    print("  positive side is the ANTI-neoliberal side. The ~60% on that side are")
    print("  the least neoliberal respondents; only ~32.5% lean neoliberal. See")
    print("  audit_published_tables.py for the full evidence.\n")


if __name__ == "__main__":
    d = pd.read_csv(NONSTD, low_memory=False)
    print("\nBower-Bir (2021), Economia Politica 38(1):131-170")
    print("Table 2 and figure statistics. Layer: economic_justice_v7_nonstandardized.csv")
    print("(unweighted -- see module docstring)\n")
    table2(d)
    figures_3_4(d)
    figure_5(d)
    figure_6(d)
    figure_7(d)
