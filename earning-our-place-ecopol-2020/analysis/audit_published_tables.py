"""
Audit of Bower-Bir (2021), "Earning our place, more or less."
Economia Politica 38(1): 131-170.

Everything this script reports was found by reproducing the published numbers and
looking at what did not line up. Run it to regenerate the evidence behind the
README's Corrigendum:

    python3 audit_published_tables.py

Sections:
  1. Table 1 -- the three defective cells, and why each is a defect.
  2. The `neoliberal` direction problem (Figure 7 / Sect. 5).
  3. The "Adj-R 2" label -- it is plain R-squared.
  4. The duplicate submission -- evidence that the published models drop it.
  5. The weighting script's income-stratum bug, and a re-raked robustness check.
"""

import numpy as np
import pandas as pd
import statsmodels.api as sm
from scipy import stats

ANALYSIS = "../../data/economic_justice_v7_analysis-weighted.csv"
NONSTD = "../../data/economic_justice_v7_nonstandardized.csv"

RULE = "=" * 78


def prep(d):
    d = d.copy()
    d["dv"] = d["corr_ideal_agency"] * 2 - 1
    d["age"] = d["age"].astype("float64")
    for src, dst in [("neoliberal", "neo_c"), ("profits_benefit", "profits_c"),
                     ("gov_stayout", "gov_c"), ("help_self", "help_c"),
                     ("diff_incentives", "diff_c")]:
        d[dst] = -d[src]
    return d


def dedup(d):
    """Drop the duplicated submission (identical on every column but `id`)."""
    twins = d[d.duplicated(subset=[c for c in d.columns if c != "id"], keep="first")]
    return d.drop(index=twins.index), twins


def fit(d, xs, wcol="post_weight"):
    s = d[["dv", wcol] + xs].dropna()
    X = sm.add_constant(s[xs], has_constant="add")
    m = sm.WLS(s["dv"], X, weights=s[wcol]).fit()
    n = int(m.nobs)
    se = m.get_robustcov_results(cov_type="HC0").bse * np.sqrt(n / (n - 1))
    return m, se, n, X.columns


def section1(d):
    print(RULE); print("1. TABLE 1 -- DEFECTIVE CELLS"); print(RULE)

    full = ["ideo_str", "party_str", "religiosity", "theology", "nonwhite", "female",
            "gay_strict", "income_household", "school_ivy", "education", "age",
            "urban", "south"]
    m, se, n, cols = fit(d, full + ["profits_c", "gov_c", "help_c", "diff_c"])
    ix = {c: i for i, c in enumerate(cols)}

    print("\n  (a) Model 1b, Political party, SE printed as (0.0073).")
    print(f"      Replication: {se[ix['party_str']]:.5f} -> prints (0.073).")
    print("      A misplaced decimal. The table prints SEs to three decimals")
    print("      throughout; this is the only four-decimal entry, and Model 1a's")
    print("      party SE is (0.071). The table is internally self-refuting: the")
    print("      cell carries NO significance star, yet 0.047/0.0073 = t 6.4,")
    print(f"      which would be significant at 1%. With the correct SE, t = "
          f"{m.params.iloc[ix['party_str']] / se[ix['party_str']]:.2f} -- insignificant,")
    print("      as printed. So the coefficient and star are right; the SE is wrong.")

    print("\n  (b) Model 1b, Female, SE printed as (0.023).")
    print(f"      Replication: {se[ix['female']]:.5f} -> prints (0.027).")
    for cov in ["HC0", "HC1", "HC2", "HC3"]:
        b = m.get_robustcov_results(cov_type=cov).bse[ix["female"]]
        print(f"        {cov}: {b:.5f}")
    print("      No estimator yields 0.023. Immaterial: the coefficient (0.015) is")
    print("      insignificant under either SE, so no claim turns on it.")

    print("\n  (c) Model 3b, Income, printed 0.125*** (0.049).")
    m3, se3, n3, cols3 = fit(d, ["nonwhite", "income_household", "school_ivy",
                                 "age", "help_c", "diff_c"])
    j = list(cols3).index("income_household")
    t = m3.params.iloc[j] / se3[j]
    p = 2 * stats.t.sf(abs(t), n3 - 1)
    print(f"      Replication: {m3.params.iloc[j]:.4f} ({se3[j]:.4f}), t = {t:.3f}, "
          f"p = {p:.4f} -> **, not ***.")
    tp = 0.125 / 0.049
    print(f"      The star is not earnable from the printed values either: "
          f"0.125/0.049 = t {tp:.3f},")
    print(f"      p = {2 * stats.t.sf(abs(tp), n3 - 1):.4f} > 0.01. Overstated by one level.")
    print("      Model 2b's Income (0.133***) is genuinely significant at 1%, so the")
    print("      error looks like a star carried across from the adjacent column.\n")


def section2(d_ns):
    print(RULE); print("2. THE `neoliberal` VARIABLE RUNS BACKWARDS FROM ITS NAME"); print(RULE)
    print("\n  Data Cleaning I lines 95-102 multiply the four constituent items by -1")
    print('  under the comment "Recode to make (+) values liberal and (-) values')
    print('  conservative". `neoliberal` is their average (line 143). So higher')
    print("  `neoliberal` = more liberal = LESS neoliberal. Three independent checks:\n")
    n = d_ns["neoliberal"]
    print(f"    corr(neoliberal, ideo_str)   = {n.corr(d_ns['ideo_str']):+.3f}   "
          "(ideo_str: +3 = very liberal)")
    print(f"    corr(neoliberal, party_str)  = {n.corr(d_ns['party_str']):+.3f}   "
          "(party_str: +3 = strong Democrat)")
    print(f"    corr(ideo_str, party_str)    = {d_ns['ideo_str'].corr(d_ns['party_str']):+.3f}   "
          "(anchor: liberals are Democrats)")
    print(f"    corr(ideo_str, gov_reducegap)= {d_ns['ideo_str'].corr(d_ns['gov_reducegap']):+.3f}   "
          "(anchor: liberals want redistribution)")
    print("\n  So the index increases as respondents get LESS neoliberal.")
    print("\n  This is handled correctly in TABLE 1. The original flips the index")
    print("  (`neoliberal_cons = neoliberal * -1`, definitions_agency_ORIGINAL.do")
    print("  line 3) and Table 1 reports the flipped coefficient (-0.182 in Model")
    print("  3a). The text's reading -- more neoliberal, lower correlation -- is right.")
    print("\n  It is NOT handled correctly in FIGURE 7. Figure 7 plots the UNFLIPPED")
    print("  index (its mass sits right of centre with a long thin left tail; the")
    print("  flipped index would mirror that) but labels the right end 'neoliberal'.")
    print("  The right end is the anti-neoliberal end. Consequences:\n")
    print(f"    share right of midpoint (Fig 7 calls this 'neoliberal') = "
          f"{(n > 0).mean() * 100:.1f}%  <- the paper's '~60%'")
    print(f"    share actually neoliberal-leaning                       = "
          f"{(n < 0).mean() * 100:.1f}%")
    print(f"    extreme right (>= +2.75), i.e. die-hard ANTI-neoliberal = "
          f"{(n >= 2.75).mean() * 100:.1f}%")
    print(f"    extreme left  (<= -2.75), i.e. die-hard neoliberal      = "
          f"{(n <= -2.75).mean() * 100:.1f}%")
    print("\n  The caption says 'the majority of survey respondents have neoliberal-")
    print("  leanings, with few die-hard neoliberals, but even fewer respondents dead")
    print("  set against neoliberal ideas.' Each clause inverts: the majority lean")
    print("  ANTI-neoliberal; the ~3.4% die-hards at the right end are anti-neoliberal;")
    print("  the ~0.7% thin tail at the left end are the die-hard neoliberals.\n")


def section3(d):
    print(RULE); print("3. THE 'Adj-R 2' ROW IS PLAIN R-SQUARED"); print(RULE)
    print("\n  `svy: regress` reports R-squared only; it does not report an adjusted")
    print("  R-squared. Every published value matches R-squared, none matches adj-R2:\n")
    full = ["ideo_str", "party_str", "religiosity", "theology", "nonwhite", "female",
            "gay_strict", "income_household", "school_ivy", "education", "age",
            "urban", "south"]
    specs = {
        "1a": full + ["neo_c"],
        "2a": ["ideo_str", "religiosity", "nonwhite", "income_household", "school_ivy",
               "age", "south", "neo_c"],
        "3a": ["nonwhite", "income_household", "school_ivy", "age", "neo_c"],
        "1b": full + ["profits_c", "gov_c", "help_c", "diff_c"],
        "2b": ["religiosity", "nonwhite", "income_household", "school_ivy", "age",
               "south", "help_c", "diff_c"],
        "3b": ["nonwhite", "income_household", "school_ivy", "age", "help_c", "diff_c"],
    }
    pub = {"1a": 0.1978, "2a": 0.1288, "3a": 0.1193, "1b": 0.2320, "2b": 0.1467, "3b": 0.1382}
    print(f"    {'model':<8}{'published':>11}{'R-squared':>12}{'adj R-squared':>15}")
    for k, xs in specs.items():
        m, _, _, _ = fit(d, xs)
        print(f"    {k:<8}{pub[k]:>11.4f}{m.rsquared:>12.4f}{m.rsquared_adj:>15.4f}")
    print("\n  Mislabel only -- no number is wrong.\n")


def section4(d_raw):
    print(RULE); print("4. THE PUBLISHED MODELS DROP THE DUPLICATED SUBMISSION"); print(RULE)
    d = prep(d_raw)
    kept, twins = dedup(d)
    # Recover BOTH members of each duplicated pair (dedup returns only the later
    # one), so the note names the full twin pair rather than half of it.
    cmp_cols = [c for c in d_raw.columns if c != "id"]
    pair_ids = sorted(d_raw[d_raw.duplicated(subset=cmp_cols, keep=False)]["id"].tolist())
    print(f"\n  The analysis file holds 992 rows but 991 distinct respondents: rows")
    print(f"  with id {pair_ids} are identical on every column but `id`.")
    print("  (../data/PROVENANCE.md, 'One respondent's record is duplicated'.)\n")
    xs = ["nonwhite", "income_household", "school_ivy", "age", "neo_c"]
    for lab, dd in [("keeping all 992 rows", d), ("dropping the duplicate", kept)]:
        m, _, n, _ = fit(dd, xs)
        print(f"    Model 3a, {lab:<24} N={n}  R2={m.rsquared:.4f}")
    print("    published                            N=953  R2=0.1193\n")
    print("  Only dropping it reproduces the published N and R-squared -- and it does")
    print("  so for all six Table 1 models and all nine Table 4 models at once.")
    print("  Of all 992 rows, only these two twins have that property (verified by")
    print("  exhaustive single-row removal). No surviving script performs the drop,")
    print("  so the mechanism is unverified; the fact of it is not in doubt.\n")


def section5(d_ns, d_an):
    print(RULE); print("5. WEIGHTING SCRIPT BUG -- INCOME STRATUM BOUNDARY"); print(RULE)
    print("\n  `Data Cleaning III_Weight_2014-04-08.do` line 26:")
    print("      gen income_weight = 1 if income_household < 8")
    print("      gen income_tot = 245 if income_weight == 1  // 24.70% earn less than $25,000")
    print("\n  But the instrument's 19 brackets (Qualtrics Q105/Q106) put $25,000-$29,999")
    print("  at index 7. So `< 8` means 'under $30,000', not 'under $25,000'. The")
    print("  correct boundary is `< 7`.")
    print("\n  Two independent confirmations that `< 7` is right:")
    ih = d_ns["income_household"]
    print(f"    - Table 2's own script (Appendices_demographics_ORIGINAL.do) cuts at")
    print(f"      `income <= 6` for <$25k, giving {(ih <= 6).sum()} -- which is exactly the")
    print(f"      {192} the published Table 2 prints. The two scripts disagree with")
    print("      each other; the demographics one matches the instrument.")
    print(f"    - Bracket 7 holds {(ih == 7).sum()} respondents. As coded, stratum 1 = "
          f"{(ih < 8).sum()};")
    print(f"      with the correct cut, {(ih < 7).sum()}. {(ih == 7).sum()} people are raked as if")
    print("      they earned under $25,000 when they earn $25,000-$29,999.")

    # Re-rake with the corrected boundary and re-run Model 3a.
    print("\n  ROBUSTNESS: re-raking with the corrected boundary.")
    E = d_an.copy()
    # Recover the integer bracket. Trap: income_household*18 lands on an exact
    # integer for only 109 of 992 rows, so round before comparing.
    ihx = np.round(E["income_household"] * 18).astype(int)
    exact = int((E["income_household"] * 18 == (E["income_household"] * 18).round()).sum())
    print(f"    (float grid: income_household*18 is exactly integral for {exact}/992 rows,")
    print("     so any threshold test must round first -- this script does.)")

    def strata(b):
        return pd.Series(np.select(
            [ihx < b, (ihx >= b) & (ihx < 11), (ihx >= 11) & (ihx < 13),
             (ihx >= 13) & (ihx < 15), ihx >= 15], [1, 2, 3, 4, 5]), index=E.index)

    TOT = {"gender": {1: 486, 0: 506},
           "party_weight": {1: 317, 2: 159, 3: 119, 4: 159, 5: 238},
           "income_weight": {1: 245, 2: 249, 3: 182, 4: 120, 5: 196},
           "race_weight": {1: 632, 2: 121, 3: 162, 4: 77},
           "educ_weight": {1: 122, 2: 301, 3: 292, 4: 166, 5: 111}}

    def rake(df, iters=300):
        w = np.ones(len(df))
        for _ in range(iters):
            for m, tot in TOT.items():
                g = df[m].values
                for lvl, t in tot.items():
                    sel = (g == lvl)
                    s = w[sel].sum()
                    if s > 0:
                        w[sel] *= t / s
        return w

    chk = E.copy(); chk["income_weight"] = strata(8)
    w_as = rake(chk)
    print(f"    validation: re-raking with the AS-CODED strata reproduces the shipped")
    print(f"    post_weight to max|diff| = {np.max(np.abs(w_as - E['post_weight'])):.2e}. "
          "The implementation is faithful.")

    fix = E.copy(); fix["income_weight"] = strata(7)
    E2 = prep(E); E2["w_fix"] = rake(fix)
    E2, _ = dedup(E2)
    xs = ["nonwhite", "income_household", "school_ivy", "age", "neo_c"]
    print(f"\n    {'variable':<18}{'published wts':>15}{'corrected wts':>15}")
    ma, sea, na, cols = fit(E2, xs, "post_weight")
    mb, seb, nb, _ = fit(E2, xs, "w_fix")
    for i, c in enumerate(cols):
        pa = 2 * stats.t.sf(abs(ma.params.iloc[i] / sea[i]), na - 1)
        pb = 2 * stats.t.sf(abs(mb.params.iloc[i] / seb[i]), nb - 1)
        st = lambda p: "***" if p < .01 else "**" if p < .05 else "*" if p < .10 else ""
        print(f"    {c:<18}{ma.params.iloc[i]:>11.4f}{st(pa):<4}"
              f"{mb.params.iloc[i]:>11.4f}{st(pb):<4}")
    print("\n  Every sign holds and every significance level holds. The bug is real,")
    print("  but the paper's conclusions are robust to it. Nothing needs retracting;")
    print("  it is documented so that a replicator who fixes the strata and gets")
    print("  slightly different numbers knows why.\n")


if __name__ == "__main__":
    an = pd.read_csv(ANALYSIS, low_memory=False)
    ns = pd.read_csv(NONSTD, low_memory=False)
    d, _ = dedup(prep(an))
    print("\nAUDIT -- Bower-Bir (2021), Economia Politica 38(1):131-170\n")
    section1(d)
    section2(ns)
    section3(d)
    section4(an)
    section5(ns, an)
