#!/usr/bin/env python3
"""Build the de-identified, analysis-ready CSV for the PSJ replication package.

Source: Economic-Justice_v7_2014-04-08_E_WORKING.dta (the file policy_taxation.do runs
against: 992 rows, standardized [0,1] variables, survey weights attached).

Why this file is needed: the existing public release
(ACADEMIC_pub/data/economic_justice_v7_nonstandardized.csv) omits `post_weight`, and every
model in Table 1 is estimated `[pw=post_weight]`. Without the weights the published tables
cannot be reproduced from public data.

De-identification follows the same rule already applied to the non-standardized release
(see ACADEMIC_pub/data/README.md): drop the panel ID, timestamps, and survey navigation
metadata. Nothing else is altered — no recoding, no row filtering.

READ-ONLY on all source data.
"""
import pandas as pd

SRC = 'dta2/Economic-Justice_v7_2014-04-08_E_WORKING.dta'
OUT = 'economic_justice_v7_analysis-weighted.csv'

DROP = ['participant_id', 'startdate', 'enddate', 'starttime', 'endtime',
        'pagesequence', 'visitedpages', 'pageprogression']

d = pd.read_stata(SRC, convert_categoricals=False)
print(f"source: {len(d)} rows x {len(d.columns)} cols")

dropped = [c for c in DROP if c in d.columns]
d = d.drop(columns=dropped)
print(f"de-identified: dropped {len(dropped)} cols -> {dropped}")

# sanity: the columns the published analysis needs must survive
need = ['post_weight', 'corr_ideal_agency', 'gov_reducegap_str', 'progtaxes_str',
        'agency_str', 'justice_str', 'desert_rich_tot', 'desert_americans_tot',
        'desert_poor_tot', 'ideo_str', 'age', 'female', 'nonwhite', 'married',
        'employment', 'education', 'income_household', 'state']
missing = [c for c in need if c not in d.columns]
assert not missing, f"MISSING required columns: {missing}"
print(f"all {len(need)} analysis variables present")

# residual PII sweep — flag anything that looks identifying
import re
suspicious = [c for c in d.columns
              if re.search(r'name|email|ip_?addr|latitude|longitude|zip|phone|address', c, re.I)]
print(f"residual PII scan: {suspicious if suspicious else 'clean'}")

d.to_csv(OUT, index=False)
print(f"wrote {OUT}: {len(d)} rows x {len(d.columns)} cols")
