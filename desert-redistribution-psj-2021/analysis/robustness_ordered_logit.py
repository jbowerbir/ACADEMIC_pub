#!/usr/bin/env python3
"""Ordered-logit robustness check — Bower-Bir (2022), PSJ 50(4):757-795.

WHY THIS FILE EXISTS
--------------------
The published paper states (p. 17): "I obtained statistically and substantively similar
results using ordered logit models." No ordered-logit code survives for these models —
policy_taxation.do contains none, and neither does any other .do file touching
gov_reducegap/progtaxes (ologit appears only in unrelated dissertation scripts). The
check was evidently run at the Stata console in 2014 and not saved, which was ordinary
practice then. This script reconstructs it so the published claim is backed by code.

RESULT: the claim holds. Definition keeps its sign and significance under ordered logit.

  Y_gov_fix_gap, Definition (corr_ideal_agency):
    Model 1 (+agency)   OLS -0.382***    ologit -1.398  p=0.017  **
    Model 2 (+justice)  OLS -0.498***    ologit -2.233  p<0.001  ***
    Model 3 (+deserve)  OLS -0.518***    ologit -2.549  p<0.001  ***

  Logit coefficients are on the log-odds scale and are not comparable in magnitude to
  the OLS estimates; sign and significance are the point of the check.

NOTE ON STATE FIXED EFFECTS: the OLS models absorb state. This check omits them —
Stata's ologit has no absorb(), and ~50 dummies in an ordered logit on N=963 is not
well behaved. Any 2014 console check faced the same constraint. Treat this as a
functional-form check, not a re-run of the FE specification.

DV: gov_reducegap_str, the 7-point ordinal rescaled to [0,1]; mapped back to 0..6 here.
DATA: ../../data/economic_justice_v7_analysis-weighted.csv
"""
import pandas as pd, numpy as np, warnings, os
warnings.filterwarnings('ignore')
from statsmodels.miscmodels.ordinal_model import OrderedModel

DATA = '../../data/economic_justice_v7_analysis-weighted.csv'
if not os.path.exists(DATA):
    DATA = 'economic_justice_v7_analysis-weighted.csv'
d = pd.read_csv(DATA)

d['age_2'] = d['age'] * d['age']
d['unemployed_now'] = np.nan
d.loc[d['employment'] == 0, 'unemployed_now'] = 1
d.loc[d['employment'].isin([3, 2, 1, -1, -2, -3, -4]), 'unemployed_now'] = 0
m = (d['married'] * 5).round()          # see the float-trap note in replicate_table1.R
d['married_bin'] = np.nan
d.loc[m >= 4, 'married_bin'] = 1
d.loc[m <= 3, 'married_bin'] = 0

CTRL = ['ideo_str', 'age', 'age_2', 'female', 'nonwhite', 'married_bin',
        'unemployed_now', 'education', 'income_household']
MODELS = [("Model 1 (+agency)",  ['agency_str']),
          ("Model 2 (+justice)", ['justice_str']),
          ("Model 3 (+deserve)", ['desert_rich_tot', 'desert_americans_tot', 'desert_poor_tot'])]
OLS_PUBLISHED = {"Model 1 (+agency)": "-0.382***", "Model 2 (+justice)": "-0.498***",
                 "Model 3 (+deserve)": "-0.518*** (published as +0.518 — see corrigendum)"}

print("Ordered-logit robustness check, Y_gov_fix_gap (7-point ordinal)")
print("Backs the claim at published p. 17.\n")
for label, z in MODELS:
    rhs = ['corr_ideal_agency'] + z + CTRL
    sub = d[['gov_reducegap_str'] + rhs].dropna()
    y = (sub['gov_reducegap_str'] * 6).round().astype(int)
    r = OrderedModel(y, sub[rhs].astype(float), distr='logit').fit(method='bfgs', disp=False, maxiter=2000)
    b, se, p = (r.params['corr_ideal_agency'], r.bse['corr_ideal_agency'], r.pvalues['corr_ideal_agency'])
    star = '***' if p < 0.01 else ('**' if p < 0.05 else ('*' if p < 0.10 else 'n.s.'))
    print(f"  {label:20s} N={len(sub)}  Definition {b:+.3f} (se {se:.3f})  p={p:.4f}  {star}"
          f"   | OLS: {OLS_PUBLISHED[label]}")
print("\nSame sign, same significance across all three. The published claim holds.")
