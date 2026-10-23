#!/usr/bin/env python3
"""Reproduces every table and figure in Bower-Bir (2022), "Desert and redistribution", Policy
Studies Journal 50(4): 757-795, from economic_justice_v7_psj-replication.csv. The same program
as replicate.R, in Python (pandas, numpy, scipy, statsmodels, matplotlib).

  Tables 1, C1, C2, D1   32 weighted regressions with state fixed effects and HC1 robust standard
                         errors (Stata: areg ..., absorb(state) [pw=post_weight])
  Table A1               sample demographics
  Figures 2, 3, 4        densities and the response grid
  Figures D1, D2         marginal-effect plots from the eight interaction regressions the 2014
                         plot code specifies (ordinary weighted regression, no state effects,
                         errors clustered by state)
  Figure 1               the three General Social Survey percentages the article charts

Usage:  python3 replicate.py                writes tables_py.md and figure-*-py.png, then compares
                                            Tables 1, C1, C2, D1 with tables_published.md
        diff tables_corrected.md tables_py.md   checks this program against the R one

Two things carried over from the 2014 Stata code on purpose. (1) The code recodes by exact
comparison (`married == .8`); here the values are rounded to the integer grid first, because 0.8
is stored as 0.7999... and an exact test matches no rows. (2) The interaction terms are built on
Definition rescaled to 0-1 (the Stata stored them under the unscaled names), and the Definition
main effect is the rescaled variable in two of the six Table D1 regressions (Y_gov Model 1,
Y_prog_tax Model 3) and the raw one in the other four. That is how the article's tables were
estimated.
"""
import os, re, sys
import numpy as np, pandas as pd, statsmodels.api as sm
from scipy import stats
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

OUT = 'tables_py.md'
d = pd.read_csv('economic_justice_v7_psj-replication.csv')

# One respondent's record is in the file twice (rows identical in every answer). The published
# tables were estimated with it. Every table is therefore estimated twice below: on all 992 rows,
# which reproduces the published tables, and on the 991 rows without the duplicate, written to a
# second file with a list of every cell that changes at the printed precision.
dup_mask = d.drop(columns=['row', 'id']).duplicated()

# ---- variables the regressions build ----------------------------------------------------------
d['age_2'] = d['age'] * d['age']
d['unemployed_now'] = np.where(d['employment'] == 0, 1.0, np.where(d['employment'].isin([3, 2, 1, -1, -2, -3, -4]), 0.0, np.nan))
d['married_bin'] = np.where((d['married'] * 5).round() >= 4, 1.0, 0.0)
p = (d['progtaxes_str'] * 6).round()
d['progtaxes2_str'] = np.where(p <= 3, 0, p - 3) / 3
d['def_scaled'] = (d['corr_ideal_agency'] + 1) / 2
for z in ['agency_str', 'justice_str', 'desert_rich_tot', 'desert_americans_tot', 'desert_poor_tot']:
    d['x_' + z] = d[z] * d['def_scaled']

CTRL = ['ideo_str', 'age', 'age_2', 'female', 'nonwhite', 'married_bin', 'unemployed_now', 'education', 'income_household']
EXTRA = ['goodlife_future', 'gov_help_str', 'charity_str']
DEF, DEFS = 'corr_ideal_agency', 'def_scaled'
DES = ['desert_rich_tot', 'desert_americans_tot', 'desert_poor_tot']
GOV, TAX = 'gov_reducegap_str', 'progtaxes2_str'
ROW = {DEF: 'Definition', DEFS: 'Definition', 'agency_str': 'Agency', 'justice_str': 'Justice',
       'desert_rich_tot': 'Rich deserve', 'desert_americans_tot': 'Avg. deserve', 'desert_poor_tot': 'Poor deserve',
       'x_agency_str': 'Def. x Agency', 'x_justice_str': 'Def. x Justice', 'x_desert_rich_tot': 'Def. x Rich',
       'x_desert_americans_tot': 'Def. x Avg.', 'x_desert_poor_tot': 'Def. x Poor',
       'goodlife_future': 'Good life', 'gov_help_str': 'Gov. help', 'charity_str': 'Charity', 'ideo_str': 'Ideology',
       'age': 'Age', 'age_2': 'Age^2', 'female': 'Female', 'nonwhite': 'Nonwhite', 'married_bin': 'Married',
       'unemployed_now': 'Unemployed', 'education': 'Education', 'income_household': 'Income'}
ORDER = ['Definition', 'Agency', 'Def. x Agency', 'Justice', 'Def. x Justice', 'Rich deserve', 'Def. x Rich',
         'Avg. deserve', 'Def. x Avg.', 'Poor deserve', 'Def. x Poor', 'Good life', 'Gov. help', 'Charity',
         'Ideology', 'Age', 'Age^2', 'Female', 'Nonwhite', 'Married', 'Unemployed', 'Education', 'Income', 'Constant']
stars = lambda pv: '***' if pv < 0.01 else '**' if pv < 0.05 else '*' if pv < 0.10 else ''

# ---- the 32 table regressions -------------------------------------------------------------------
M = [
    ('Table 1', 'Y_gov Model 1', GOV, [DEF, 'agency_str'] + CTRL),
    ('Table 1', 'Y_gov Model 2', GOV, [DEF, 'justice_str'] + CTRL),
    ('Table 1', 'Y_gov Model 3', GOV, [DEF] + DES + CTRL),
    ('Table 1', 'Y_tax Model 1', TAX, [DEF, 'agency_str'] + CTRL),
    ('Table 1', 'Y_tax Model 2', TAX, [DEF, 'justice_str'] + CTRL),
    ('Table 1', 'Y_tax Model 3', TAX, [DEF] + DES + CTRL),
    ('Table C1: Y_gov_fix_gap', 'gov Model A', GOV, CTRL),
    ('Table C1: Y_gov_fix_gap', 'gov Model B', GOV, [DEF] + CTRL),
    ('Table C1: Y_gov_fix_gap', 'gov Model C', GOV, ['agency_str'] + CTRL),
    ('Table C1: Y_gov_fix_gap', 'gov Model D', GOV, ['justice_str'] + CTRL),
    ('Table C1: Y_gov_fix_gap', 'gov Model E', GOV, DES + CTRL),
    ('Table C1: Y_prog_tax', 'tax Model A', TAX, CTRL),
    ('Table C1: Y_prog_tax', 'tax Model B', TAX, [DEF] + CTRL),
    ('Table C1: Y_prog_tax', 'tax Model C', TAX, ['agency_str'] + CTRL),
    ('Table C1: Y_prog_tax', 'tax Model D', TAX, ['justice_str'] + CTRL),
    ('Table C1: Y_prog_tax', 'tax Model E', TAX, DES + CTRL),
    ('Table C2: Y_gov_fix_gap', 'gov Model A', GOV, EXTRA + CTRL),
    ('Table C2: Y_gov_fix_gap', 'gov Model B', GOV, [DEF] + EXTRA + CTRL),
    ('Table C2: Y_gov_fix_gap', 'gov Model C', GOV, [DEF, 'agency_str'] + EXTRA + CTRL),
    ('Table C2: Y_gov_fix_gap', 'gov Model D', GOV, [DEF, 'justice_str'] + EXTRA + CTRL),
    ('Table C2: Y_gov_fix_gap', 'gov Model E', GOV, [DEF] + DES + EXTRA + CTRL),
    ('Table C2: Y_prog_tax', 'tax Model A', TAX, EXTRA + CTRL),
    ('Table C2: Y_prog_tax', 'tax Model B', TAX, [DEF] + EXTRA + CTRL),
    ('Table C2: Y_prog_tax', 'tax Model C', TAX, [DEF, 'agency_str'] + EXTRA + CTRL),
    ('Table C2: Y_prog_tax', 'tax Model D', TAX, [DEF, 'justice_str'] + EXTRA + CTRL),
    ('Table C2: Y_prog_tax', 'tax Model E', TAX, [DEF] + DES + EXTRA + CTRL),
    ('Table D1: Y_gov_fix_gap', 'gov Model 1', GOV, [DEFS, 'agency_str', 'x_agency_str'] + CTRL),
    ('Table D1: Y_gov_fix_gap', 'gov Model 2', GOV, [DEF, 'justice_str', 'x_justice_str'] + CTRL),
    ('Table D1: Y_gov_fix_gap', 'gov Model 3', GOV, [DEF, 'desert_rich_tot', 'x_desert_rich_tot', 'desert_americans_tot',
                                                     'x_desert_americans_tot', 'desert_poor_tot', 'x_desert_poor_tot'] + CTRL),
    ('Table D1: Y_prog_tax', 'tax Model 1', TAX, [DEF, 'agency_str', 'x_agency_str'] + CTRL),
    ('Table D1: Y_prog_tax', 'tax Model 2', TAX, [DEF, 'justice_str', 'x_justice_str'] + CTRL),
    ('Table D1: Y_prog_tax', 'tax Model 3', TAX, [DEFS] + DES + ['x_desert_rich_tot', 'x_desert_americans_tot', 'x_desert_poor_tot'] + CTRL),
]

def design(sub, rhs, fe=True):
    X = sub[rhs].astype(float)
    if fe:
        X = pd.concat([X, pd.get_dummies(sub['state'].astype(int), prefix='st', drop_first=True).astype(float)], axis=1)
    return sm.add_constant(X)

def fit_table(dv, rhs, data):
    sub = data[[dv] + rhs + ['post_weight', 'state']].dropna()
    X = design(sub, rhs); w = sub['post_weight'].astype(float); y = sub[dv].astype(float)
    r = sm.WLS(y, X, weights=w).fit(cov_type='HC1')
    n, k = int(r.nobs), X.shape[1]; dfr = n - k
    pv = 2 * stats.t.sf(np.abs(r.params / r.bse), dfr)
    cells = {ROW[v]: (r.params[v], r.bse[v], pv[list(r.params.index).index(v)]) for v in rhs}
    # the constant as areg reports it: ybar - xbar'beta; delta-method standard error
    xbar = np.average(sub[rhs].astype(float), axis=0, weights=w); V = r.cov_params().loc[rhs, rhs].values
    cons = np.average(y, weights=w) - xbar @ r.params[rhs].values; cse = float(np.sqrt(xbar @ V @ xbar))
    cells['Constant'] = (cons, cse, 2 * stats.t.sf(abs(cons / cse), dfr))
    return {'cells': cells, 'N': n, 'R2': r.rsquared, 'AdjR2': r.rsquared_adj}

def tables_md(data):
    """Estimate the 32 regressions and Table A1 on one data set; return the results and their markdown."""
    res = [(t, c, fit_table(dv, rhs, data)) for t, c, dv, rhs in M]
    md = []
    for tb in dict.fromkeys(t for t, _, _ in res):
        rs = [(c, e) for t, c, e in res if t == tb]
        md += ['', f'## {tb}', '| Variable | ' + ' | '.join(c for c, _ in rs) + ' |', '|---' * (len(rs) + 1) + '|']
        for r in [r for r in ORDER if any(r in e['cells'] for _, e in rs)]:
            md.append(f'| {r} | ' + ' | '.join(f"{e['cells'][r][0]:.3f}{stars(e['cells'][r][2])}" if r in e['cells'] else '' for _, e in rs) + ' |')
            md.append('| | ' + ' | '.join(f"({e['cells'][r][1]:.3f})" if r in e['cells'] else '' for _, e in rs) + ' |')
        md.append('| N | ' + ' | '.join(str(e['N']) for _, e in rs) + ' |')
        md.append('| R2 | ' + ' | '.join(f"{e['R2']:.4f}" for _, e in rs) + ' |')
        md.append('| Adj-R2 | ' + ' | '.join(f"{e['AdjR2']:.4f}" for _, e in rs) + ' |')

    # ---- Table A1: sample demographics ---------------------------------------------------------------
    edu = (data['education'] * 6).round(); inc = (data['income_household'] * 18).round()
    A1 = [('Gender', [('Female', data['gender'] == 0), ('Male', data['gender'] == 1)]),
          ('Race', [('White', data['race'] == 0), ('Black', data['race'] == 1), ('Latino', data['race'] == 2), ('Asian', data['race'] == 4), ('Other', data['race'].isin([3, 5, 6]))]),
          ('Education', [('High school or less', edu <= 2), ("Associate's or some college", edu.isin([3, 4])), ("Bachelor's degree", edu == 5), ('Graduate degree', edu == 6)]),
          ('Household income', [('< $25k', inc <= 6), ('$25k-$49k', inc.between(7, 10)), ('$50k-$74k', inc.between(11, 12)), ('$75k-$99k', inc.between(13, 14)), ('$100k-$149k', inc.between(15, 16)), ('$150k+', inc >= 17)]),
          ('Political party', [('Republican', data['party'] <= -2), ('Lean Republican', data['party'] == -1), ('Independent', data['party'] == 0), ('Lean Democrat', data['party'] == 1), ('Democrat', data['party'] >= 2)])]
    a1 = ['', '## Table A1', '| Group | Sample N | Sample share |', '|---|---|---|']
    for g, rows in A1:
        for lab, mask in rows:
            n = int(mask.sum()); a1.append(f'| {g}: {lab} | {n} | {n / len(data):.2f} |')
    i = md.index('## Table C1: Y_gov_fix_gap') - 1      # the article's order: Table 1, then A1, then C1
    return res, md[:i] + a1 + md[i:]

# The survey weight was raked on all 992 rows in 2014 (iterative proportional fitting to population
# totals on gender, party, income, race and education). Raking the same way on the 991 distinct rows
# gives the weight those tables should carry. Strata and targets are the 2014 script's; the targets
# are scaled from 992 to the rows present.
def rake(x):
    inc = (x['income_household'] * 18).round(); edu = (x['education'] * 6).round()
    strata = {'gender': x['gender'].values,
              'party': np.select([x.party >= 2, x.party == 1, x.party == 0, x.party == -1, x.party <= -2], [1, 2, 3, 4, 5]),
              'income': np.select([inc < 8, inc < 11, inc < 13, inc < 15, inc >= 15], [1, 2, 3, 4, 5]),
              'race': np.select([x.race == 0, x.race == 1, x.race == 2, x.race >= 3], [1, 2, 3, 4]),
              'educ': np.select([edu <= 1, edu == 2, edu.isin([3, 4]), edu == 5, edu == 6], [1, 2, 3, 4, 5])}
    targets = {'gender': {1: 486, 0: 506}, 'party': {1: 317, 2: 159, 3: 119, 4: 159, 5: 238},
               'income': {1: 245, 2: 249, 3: 182, 4: 120, 5: 196}, 'race': {1: 632, 2: 121, 3: 162, 4: 77},
               'educ': {1: 122, 2: 301, 3: 292, 4: 166, 5: 111}}
    w = np.ones(len(x))
    for _ in range(500):
        w0 = w.copy()
        for g, t in targets.items():
            for lvl, tot in t.items():
                m = strata[g] == lvl; w[m] *= (tot * len(x) / 992) / w[m].sum()
        if np.abs(w - w0).max() < 1e-12: break
    return w
# check: raked on all 992 rows, the method reproduces the shipped weight
assert np.abs(rake(d) - d['post_weight'].values).max() < 1e-4

res, md = tables_md(d)
d991 = d[~dup_mask].reset_index(drop=True)
d991['post_weight'] = rake(d991)
res_dedup, md_dedup = tables_md(d991)


# ---- Figures --------------------------------------------------------------------------------------
plt.rcParams.update({'font.family': 'serif', 'font.size': 9})

# Figure 1: the General Social Survey percentages the article charts (not from this survey)
agree = [0.45, 0.5916, 0.6653]; disagree = [0.52, 0.4084, 0.1647]
labels = ['the income gap is a\nproblem that needs fixing', 'there are strong conflicts\nbetween the rich and poor', 'differences in income\nare too large']
fig, ax = plt.subplots(figsize=(6.5, 2.4))
left = np.zeros(3)
for vals, col, lab in [(disagree, '0.85', 'disagree'), ([1 - a - b for a, b in zip(agree, disagree)], '0.6', 'unsure'), (agree, '0.3', 'agree')]:
    ax.barh(labels, vals, left=left, color=col, label=lab); left += np.array(vals)
ax.axvline(0.5, ls=':', color='k'); ax.set_xlim(0, 1); ax.legend(ncol=3, frameon=False, loc='lower right', bbox_to_anchor=(1, 1))
for s in ['top', 'right', 'left']: ax.spines[s].set_visible(False)
fig.tight_layout(); fig.savefig('figure-1-py.png', dpi=200); plt.close(fig)

# Figures 2 and 3: kernel densities (Gaussian kernel, Silverman's default bandwidth). Figure 2 is
# computed on the 0-1 standardized scores and labeled on their original -1 to 1 scale, as the
# 2014 plot was. Figure 3 is the raw correlation.
def silverman(x): x = x[~np.isnan(x)]; iqr = np.subtract(*np.percentile(x, [75, 25])); return 0.9 * min(x.std(ddof=1), iqr / 1.34) * len(x) ** -0.2
def dens(v, grid):
    x = v[~np.isnan(v)]; h = silverman(x)
    return np.array([stats.norm.pdf((g - x) / h).sum() / (len(x) * h) for g in grid])
grid = np.linspace(-0.15, 1.15, 512)
fig, ax = plt.subplots(figsize=(6.5, 4))
for v, ls, lab in [('desert_rich_tot', '-', 'rich'), ('desert_americans_tot', ':', 'average'), ('desert_poor_tot', '--', 'poor')]:
    ax.plot(2 * grid - 1, dens(d[v].values, grid), ls=ls, color='k', lw=2, label=lab)
ax.set_xlim(-1, 1); ax.set_ylim(0, 2.8); ax.set_xlabel('Deservingness'); ax.legend(frameon=False)
for s in ['top', 'right']: ax.spines[s].set_visible(False)
fig.tight_layout(); fig.savefig('figure-2-py.png', dpi=200); plt.close(fig)
grid3 = np.linspace(-1.1, 1.1, 512)
fig, ax = plt.subplots(figsize=(6.5, 4))
ax.plot(grid3, dens(d['corr_ideal_agency'].values, grid3), color='k', lw=2); ax.set_xlim(-1, 1); ax.set_xlabel('Control-Ideal Importance correlation')
for s in ['top', 'right']: ax.spines[s].set_visible(False)
fig.tight_layout(); fig.savefig('figure-3-py.png', dpi=200); plt.close(fig)

# Figure 4: share of respondents in each cell of (rich deserve their wealth) x (income differences are too large).
# The 2014 figure dropped the duplicated respondent record (two rows identical in every answer; the second is dropped).
d4 = d[~dup_mask]
ix = (2 * d4['desert_rich_tot'] - 1).mul(6).round().astype(int); iy = (2 * d4['diff_large'] - 1).mul(3).round().astype(int)
tab = pd.crosstab(iy, ix).reindex(index=range(-3, 4), columns=range(-6, 7), fill_value=0) / len(d4)
fig, ax = plt.subplots(figsize=(6.5, 4.2))
ax.imshow(tab.values, origin='lower', cmap='Greys', aspect='auto', extent=(-6.5, 6.5, -3.5, 3.5))
ax.set_xticks([-6, 0, 6]); ax.set_xticklabels(['VC, VU', 'NC, ND/U', 'VC, VD']); ax.set_yticks([-3, 0, 3]); ax.set_yticklabels(['SD', 'N', 'SA'])
ax.set_xlabel('Do the rich deserve their wealth?'); ax.set_ylabel('Are income differences too large?')
fig.tight_layout(); fig.savefig('figure-4-py.png', dpi=200); plt.close(fig)

# Figures D1 and D2: marginal-effect plots. Each panel: an ordinary weighted regression with the interaction,
# errors clustered by state (Stata: reg ... [pw=post_weight], cluster(state)); the marginal effect of X at each
# value of the moderator Z, b1 + b3*Z, with a 95% band, over a histogram of Z.
def cluster_fit(dv, rhs):
    sub = d[[dv] + rhs + ['post_weight', 'state']].dropna()
    X = design(sub, rhs, fe=False); w = sub['post_weight'].astype(float)
    r = sm.WLS(sub[dv].astype(float), X, weights=w).fit(cov_type='cluster', cov_kwds={'groups': sub['state'].astype(int).values, 'use_correction': True, 'df_correction': True})
    return r, sub
def me_panel(ax, dv, xvar, zvar, rhs, xlab, ylab, ylim, zhist, bins, title, rug=False):
    r, sub = cluster_fit(dv, rhs); ix = 'x_' + zvar; V = r.cov_params()
    b1, b3 = r.params[xvar], r.params[ix]; v1, v3, c13 = V.loc[xvar, xvar], V.loc[ix, ix], V.loc[xvar, ix]
    zz = np.linspace(0, 1, 101); me = b1 + b3 * zz; band = 1.96 * np.sqrt(v1 + v3 * zz ** 2 + 2 * c13 * zz)
    ax2 = ax.twinx(); cnt, edges = np.histogram(sub[zhist], bins=bins); ax2.bar((edges[:-1] + edges[1:]) / 2, 100 * cnt / cnt.sum(), width=(edges[1] - edges[0]) * (0.5 if rug else 0.6), color='0.8', zorder=0)
    ax2.set_ylabel('Percentage of observations', fontsize=7); ax2.tick_params(labelsize=7)
    ax.set_zorder(ax2.get_zorder() + 1); ax.patch.set_visible(False)
    ax.plot(zz, me, 'k', lw=2); ax.plot(zz, me + band, 'k--', lw=1); ax.plot(zz, me - band, 'k--', lw=1); ax.axhline(0, color='k', lw=1)
    if rug: ax.plot(sub[zhist], np.full(len(sub), ylim[0]), '|', color='0.3', ms=6)
    ax.set_xlim(0, 1); ax.set_ylim(*ylim); ax.set_xlabel(xlab, fontsize=7); ax.set_ylabel(ylab, fontsize=7); ax.set_title(title, fontsize=8); ax.tick_params(labelsize=7)
    return f'| {title} | {dv} | {zvar} | {b1:.3f} | {np.sqrt(v1):.3f} | {b3:.3f} | {np.sqrt(v3):.3f} | {int(r.nobs)} |'
md += ['', '## Figure D1 and D2 regressions', '| Panel | Outcome | Z | b(X) | SE | b(X x Z) | SE | N |', '|---|---|---|---|---|---|---|---|']
rich_rhs = lambda first: [first, 'desert_rich_tot', 'x_desert_rich_tot', 'desert_americans_tot', 'x_desert_americans_tot', 'desert_poor_tot', 'x_desert_poor_tot'] + CTRL
bins24 = np.arange(-1 / 48, 1 + 1 / 48 + 1e-9, 1 / 24)
fig, axes = plt.subplots(2, 2, figsize=(7, 6))
md.append(me_panel(axes[0, 0], GOV, DEFS, 'agency_str', [DEFS, 'agency_str', 'x_agency_str'] + CTRL, "Belief that peoples' economic standing is within their control", 'Marginal effect of definition', (-3, 1), 'agency_str', bins24, 'D1(a) X given Z_agency, on Y_gov_fix_gap'))
md.append(me_panel(axes[0, 1], GOV, DEFS, 'justice_str', [DEFS, 'justice_str', 'x_justice_str'] + CTRL, 'Belief that economic desert is rewarded', 'Marginal effect of definition', (-3, 1), 'justice_str', bins24, 'D1(b) X given Z_justice, on Y_gov_fix_gap'))
md.append(me_panel(axes[1, 0], GOV, DEFS, 'desert_rich_tot', rich_rhs(DEFS), 'Belief that rich Americans deserve their wealth', 'Marginal effect of definition', (-3, 1), 'desert_rich_tot', bins24, 'D1(c) X given Z_rich_deserve, on Y_gov_fix_gap'))
md.append(me_panel(axes[1, 1], TAX, DEFS, 'agency_str', [DEFS, 'agency_str', 'x_agency_str'] + CTRL, "Belief that peoples' economic standing is within their control", 'Marginal effect of definition', (-3, 1), 'agency_str', bins24, 'D1(d) X given Z_agency, on Y_prog_tax'))
fig.tight_layout(); fig.savefig('figure-D1-py.png', dpi=200); plt.close(fig)
bins100 = np.linspace(0, 1, 101)
fig, axes = plt.subplots(2, 2, figsize=(7, 6))
md.append(me_panel(axes[0, 0], GOV, 'agency_str', 'agency_str', ['agency_str', DEFS, 'x_agency_str'] + CTRL, 'Importance of agency to definition of desert', 'Marginal effect of belief in economic agency', (-2, 7), DEFS, bins100, 'D2(a) Z_agency given X, on Y_gov_fix_gap', rug=True))
md.append(me_panel(axes[0, 1], GOV, 'justice_str', 'justice_str', ['justice_str', DEFS, 'x_justice_str'] + CTRL, 'Importance of agency to definition of desert', 'Marginal effect of belief that economic desert is rewarded', (-2, 7), DEFS, bins100, 'D2(b) Z_justice given X, on Y_gov_fix_gap', rug=True))
md.append(me_panel(axes[1, 0], GOV, 'desert_rich_tot', 'desert_rich_tot', ['desert_rich_tot', DEFS, 'x_desert_rich_tot', 'desert_americans_tot', 'x_desert_americans_tot', 'desert_poor_tot', 'x_desert_poor_tot'] + CTRL, 'Importance of agency to definition of desert', 'Marginal effect of belief that rich Americans deserve their wealth', (-2, 7), DEFS, bins100, 'D2(c) Z_rich_deserve given X, on Y_gov_fix_gap', rug=True))
md.append(me_panel(axes[1, 1], TAX, 'agency_str', 'agency_str', ['agency_str', DEFS, 'x_agency_str'] + CTRL, 'Importance of agency to definition of desert', 'Marginal effect of belief in economic agency', (-2, 7), DEFS, bins100, 'D2(d) Z_agency given X, on Y_prog_tax', rug=True))
fig.tight_layout(); fig.savefig('figure-D2-py.png', dpi=200); plt.close(fig)

open(OUT, 'w', encoding='utf-8').write('\n'.join(md) + '\n')

# ---- the tables without the duplicated record ----------------------------------------------------
# Same layout, 991 rows, followed by every regression cell whose printed coefficient, standard
# error or stars differ from the 992-row tables.
fmt = lambda c: (f'{c[0]:.3f}{stars(c[2])}', f'({c[1]:.3f})')
# a regression's place in the article, named as printed: ('Table C1: Y_gov_fix_gap', 'gov Model A')
# -> 'Table C1 | Y_gov_fix_gap | Model A'
def where(t, c):
    pre, model = c.split(' ', 1)
    return f"{t.split(':')[0]} | {dict(gov='Y_gov_fix_gap', tax='Y_prog_tax')[pre.replace('Y_', '')]} | {model}"
changes = []
for (t, c, e), (_, _, e2) in zip(res, res_dedup):
    for r in e['cells']:
        fa, fb = fmt(e['cells'][r]), fmt(e2['cells'][r])
        if fa != fb: changes.append(f'| {where(t, c)} | {r} | {fa[0]} {fa[1]} | {fb[0]} {fb[1]} |')
# Table A1 too: the duplicated respondent is counted once fewer in each of their groups
def a1_rows(lines):
    i = lines.index('## Table A1')
    return [cells for cells in (l.strip('|').split('|') for l in lines[i + 3:]) if len(cells) == 3] if i >= 0 else []
for (g, n1, s1), (_, n2, s2) in zip(a1_rows(md[:md.index('## Table C1: Y_gov_fix_gap')]), a1_rows(md_dedup[:md_dedup.index('## Table C1: Y_gov_fix_gap')])):
    if (n1, s1) != (n2, s2):
        k = sum(ch.startswith('| Table 1 |') for ch in changes)     # table order: after Table 1
        changes.insert(k + sum(ch.startswith('| Table A1 |') for ch in changes), f'| Table A1 | | | {g.strip()} | {n1.strip()} ({s1.strip()}) | {n2.strip()} ({s2.strip()}) |')
dd = md_dedup + ['', '## Cells that change when the duplicated record is dropped',
                 '| Table | Outcome | Model | Row | With (992 rows) | Without (991 rows) |', '|---|---|---|---|---|---|'] + changes
open('tables_deduplicated_py.md', 'w', encoding='utf-8').write('\n'.join(dd) + '\n')
print(f"wrote tables_deduplicated_py.md: {sum(not ch.startswith('| Table A1') for ch in changes)} of {sum(len(e['cells']) for _, _, e in res)} regression cells change at the printed precision")
print(f'wrote {OUT} and figure-1-py.png ... figure-D2-py.png')

# ---- compare Tables 1, C1, C2, D1 with the printed page ------------------------------------------
PUB = 'tables_published.md'
if os.path.exists(PUB):
    def parse_md(path):
        tables, cur, cols, last = {}, None, None, None
        for line in open(path, encoding='utf-8'):
            line = line.rstrip('\n')
            if line.startswith('## '): cur = line[3:].strip(); tables[cur] = {}; cols = None; continue
            if cur is None or not line.startswith('|') or set(line) <= set('|- '): continue
            cells = [c.strip() for c in line.strip('|').split('|')]
            if cols is None: cols = cells[1:]; continue
            name, vals = cells[0], cells[1:]
            if name:
                last = name
                for c, v in zip(cols, vals):
                    if v: tables[cur].setdefault(c, {})[name] = {'coef': v}
            else:
                for c, v in zip(cols, vals):
                    if v: tables[cur][c][last]['se'] = v
        return tables
    num = lambda s: float(s.replace('−', '-').replace('*', '').strip('()'))
    pub = parse_md(PUB); mism = []; side = []; ncell = 0
    for t, c, e in res:
        for row, cell in pub.get(t, {}).get(c, {}).items():
            ncell += 1; tag = f'{where(t, c)} | {row}'
            if row in ('N', 'R2', 'Adj-R2'):
                got = {'N': e['N'], 'R2': e['R2'], 'Adj-R2': e['AdjR2']}[row]; tol = {'N': 0.5, 'R2': 0.00005, 'Adj-R2': 0.0004}[row]
                if abs(got - num(cell['coef'])) > tol:
                    mism.append(f"{tag}: printed {cell['coef']}, re-estimated {got:g}"); side.append(f"| {tag} | {cell['coef']} | {got:g} |")
                continue
            if row not in e['cells']: mism.append(f'{tag}: printed but not in this model'); continue
            b, se, pv = e['cells'][row]; probs = []
            if abs(b - num(cell['coef'])) > 0.0005: probs.append(f"coef printed {cell['coef'].replace('*', '')}, re-estimated {b:.3f}")
            if row != 'Constant' and 'se' in cell and abs(se - num(cell['se'])) > 0.0005: probs.append(f"SE printed {cell['se']}, re-estimated ({se:.3f})")
            ps = re.sub(r'[^*]', '', cell['coef'])
            if row != 'Constant' and ps != stars(pv): probs.append(f"stars printed {ps or 'none'}, earned {stars(pv) or 'none'}")
            if probs:
                mism.append(f"{tag}: " + '; '.join(probs))
                side.append(f"| {tag} | {cell['coef']} {cell.get('se', '')} | {' '.join(fmt(e['cells'][row]))} |")
    print(f"\nCompared {ncell} cells with {PUB} (the constant's SE and stars are not compared).")
    print('Every cell matches.' if not mism else f'{len(mism)} cells differ between the printed tables and the re-run:\n' + '\n'.join('  ' + m for m in mism))
    # the same list, as a file: the cell-by-cell record of the transcription errors (stars escaped so markdown shows them)
    open('cells_corrected_py.md', 'w', encoding='utf-8').write('\n'.join(
        ['# Cells where the printed tables differ from the re-run', '(992 observations)', '',
         'Each line: table | outcome | model | row: what was printed, what the re-run gives.', ''] + ['- ' + m.replace('*', r'\*') for m in mism]) + '\n')
    # and side by side at the end of the corrected tables: each printed cell beside its corrected value
    open(OUT, 'a', encoding='utf-8').write('\n'.join(
        ['', '## Cells that differ from the published tables', '| Table | Outcome | Model | Row | Published | Corrected |',
         '|---|---|---|---|---|---|'] + side) + '\n')
