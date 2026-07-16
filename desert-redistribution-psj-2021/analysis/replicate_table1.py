#!/usr/bin/env python3
"""Replicate PSJ 2022 Table 1 from source data, to test three suspected typesetting errors.

Ports policy_taxation.do (Box/Research/Dissertation/Data and methods/Surveys/Survey/Analysis/,
dated 2014-09-22) lines 142-164, which are the six models of published Table 1.

Stata:  areg <dv> corr_ideal_agency <Z...> ideo_str age age_2 female nonwhite married_bin
               unemployed_now education income_household [pw=post_weight], absorb(state)
Port:   WLS with state dummies (= absorb) + HC1 robust SEs (Stata's [pw=] implies a robust
        sandwich VCE). Point estimates are exactly WLS-with-those-weights; SEs should be
        very close, with small differences possible from dof conventions.

READ-ONLY on all source data. Writes nothing outside this scratchpad.
"""
import pandas as pd, numpy as np, statsmodels.api as sm

DATA = '../../data/economic_justice_v7_analysis-weighted.csv'
import os
if not os.path.exists(DATA):
    DATA = 'economic_justice_v7_analysis-weighted.csv'
d = pd.read_csv(DATA)

# ---- transforms, verbatim from policy_taxation.do lines 3-22 ----
d['age_2'] = d['age'] * d['age']

d['unemployed_now'] = np.nan
d.loc[d['employment'] == 0, 'unemployed_now'] = 1
d.loc[d['employment'].isin([3, 2, 1, -1, -2, -3, -4]), 'unemployed_now'] = 0

# FLOATING-POINT TRAP — see the note in replicate_table1.R. The Stata original tests
# float equality directly (`if married == .8`, `if progtaxes2_str == 4`). Transliterating
# that literally matches ZERO rows, because the stored floats are 0.7999999... and
# 3.9999999..., and the affected rows silently keep their raw values instead of being
# recoded. That corrupted the DV and shifted every coefficient (~0.03) until it was
# caught by diffing against the published table. Round onto the integer grid first.
m = (d['married'] * 5).round()          # married is a [0,1] scale in 0.2 steps
d['married_bin'] = np.nan
d.loc[m >= 4, 'married_bin'] = 1
d.loc[m <= 3, 'married_bin'] = 0

# progtaxes2_str: rescale to 0-3 (bottom categories collapsed), then to [0,1]
p = (d['progtaxes_str'] * 6).round()
p2 = p.copy()
p2[p <= 3] = 0
p2[p == 4] = 1
p2[p == 5] = 2
p2[p == 6] = 3
d['progtaxes2_str'] = p2 / 3

CTRL = ['ideo_str', 'age', 'age_2', 'female', 'nonwhite', 'married_bin',
        'unemployed_now', 'education', 'income_household']

MODELS = [
    # (label, dv, Z-block)  — .do lines 158/161/164 and 142/145/148
    ('gov_fix_gap M1', 'gov_reducegap_str', ['agency_str']),
    ('gov_fix_gap M2', 'gov_reducegap_str', ['justice_str']),
    ('gov_fix_gap M3', 'gov_reducegap_str', ['desert_rich_tot', 'desert_americans_tot', 'desert_poor_tot']),
    ('prog_tax M1',    'progtaxes2_str',    ['agency_str']),
    ('prog_tax M2',    'progtaxes2_str',    ['justice_str']),
    ('prog_tax M3',    'progtaxes2_str',    ['desert_rich_tot', 'desert_americans_tot', 'desert_poor_tot']),
]

# published Table 1 (read off the article, p.18) -> {model: {var: (coef, se)}}
PUBLISHED = {
    'gov_fix_gap M1': {'Definition': (-0.382, 0.148), 'agency_str': (-0.215, 0.051), 'ideo_str': (0.502, 0.052), 'income_household': (-0.196, 0.058), '_cons': (0.660, 0.195)},
    'gov_fix_gap M2': {'Definition': (-0.498, 0.126), 'justice_str': (-0.403, 0.048), 'ideo_str': (0.393, 0.051), 'income_household': (-0.129, 0.053), '_cons': (0.851, 0.182)},
    'gov_fix_gap M3': {'Definition': (0.518, 0.131), 'desert_rich_tot': (-0.366, 1.056), 'desert_americans_tot': (-0.126, 0.047), 'desert_poor_tot': (-0.277, 0.067), 'ideo_str': (0.310, 0.050), '_cons': (1.147, 0.170)},
    'prog_tax M1':    {'Definition': (0.139, 0.140), 'agency_str': (-0.133, 0.053), 'nonwhite': (0.012, 0.012), 'ideo_str': (0.565, 0.048)},
    'prog_tax M2':    {'Definition': (0.067, 0.128), 'justice_str': (-0.258, 0.056), 'nonwhite': (0.015, 0.032), 'ideo_str': (0.494, 0.054)},
    'prog_tax M3':    {'Definition': (0.044, 0.127), 'desert_rich_tot': (-0.308, 0.080), 'desert_poor_tot': (-0.132, 0.071), 'nonwhite': (0.022, 0.030), 'ideo_str': (0.432, 0.056)},
}

print("=" * 78)
print("PSJ 2022 Table 1 replication — source: E_WORKING.dta, spec: policy_taxation.do")
print("=" * 78)

for label, dv, zblock in MODELS:
    rhs = ['corr_ideal_agency'] + zblock + CTRL
    cols = [dv] + rhs + ['post_weight', 'state']
    sub = d[cols].dropna()
    X = pd.get_dummies(sub['state'].astype(int), prefix='st', drop_first=True).astype(float)
    X = pd.concat([sub[rhs].astype(float), X], axis=1)
    X = sm.add_constant(X)
    res = sm.WLS(sub[dv].astype(float), X, weights=sub['post_weight'].astype(float)).fit(cov_type='HC1')

    print(f"\n--- {label}   (N={int(res.nobs)})")
    print(f"    {'variable':22s} {'replicated':>20s}   {'published':>18s}   verdict")
    pub = PUBLISHED[label]
    for var in ['corr_ideal_agency'] + zblock + ['ideo_str', 'nonwhite', 'income_household', 'const']:
        if var not in res.params.index:
            continue
        name = 'Definition' if var == 'corr_ideal_agency' else ('_cons' if var == 'const' else var)
        if name not in pub:
            continue
        b, se = res.params[var], res.bse[var]
        pb, pse = pub[name]
        okb = abs(b - pb) < 0.02
        okb_sign = abs(b - (-pb)) < 0.02          # matches published magnitude but opposite sign
        okse = abs(se - pse) < 0.02
        okse_lead = abs(se - (pse - 1.0)) < 0.02  # published SE has a spurious leading 1
        okse_dup = abs(se - 0.031) < 0.02 and abs(pse - 0.012) < 0.001
        verdict = []
        if okb: verdict.append("coef OK")
        elif okb_sign: verdict.append("*** SIGN FLIP vs published ***")
        else: verdict.append(f"coef DIFFERS ({b:+.3f} vs {pb:+.3f})")
        if okse: verdict.append("se OK")
        elif okse_lead: verdict.append("*** published SE has spurious leading digit ***")
        elif okse_dup: verdict.append("*** published SE duplicates coef ***")
        else: verdict.append(f"se DIFFERS ({se:.3f} vs {pse:.3f})")
        print(f"    {name:22s} {b:+9.3f} ({se:6.3f})   {pb:+9.3f} ({pse:5.3f})   {' | '.join(verdict)}")
    print(f"    {'R2':22s} {res.rsquared:9.4f}")
