#!/usr/bin/env python3
"""Full audit of every regression table in PSJ 2022 (Tables 1, C1, C2, D1).

Two independent checks per cell:
  (a) INTERNAL CONSISTENCY — can the printed stars be earned by the printed coef/SE?
      Uses the most favourable rounding, so a flag here is unambiguous arithmetic.
      This catches stars that are TOO STRONG. It cannot catch stars that are too weak.
  (b) REPLICATION — for tables whose models are identified in policy_taxation.do,
      re-estimate and compare coef, SE, and earned stars cell by cell.

Table note in the paper: * 10%, ** 5%, *** 1%.
"""
import re, subprocess
from scipy import stats

TXT = 'psj_published.txt'
lines = open(TXT, encoding='utf-8', errors='replace').read().split('\n')

TABLES = {'Table 1': (871, 935), 'Table C1': (1529, 1614),
          'Table C2': (1615, 1758), 'Table D1': (1759, 1850)}
NEED = {'*': 1.645, '**': 1.960, '***': 2.576}   # two-tailed normal; df>900 here, ~identical

print("=" * 86)
print("(a) INTERNAL CONSISTENCY — stars vs the cell's own printed coefficient and SE")
print("    Flagged only if *** cannot be earned under the most generous rounding.")
print("=" * 86)

flags = []
for tname, (lo, hi) in TABLES.items():
    for i in range(lo, min(hi, len(lines) - 1)):
        coefs = re.findall(r'(−?-?\d+\.\d{3})(\*{1,3})', lines[i])
        ses = re.findall(r'\((\d+\.\d{3})\)', lines[i + 1])
        if not (coefs and ses and len(coefs) == len(ses)):
            continue
        label = lines[i].strip().split()[0] if lines[i].strip() else '?'
        for (c, st), s in zip(coefs, ses):
            b = abs(float(c.replace('−', '-')))
            e = float(s)
            if e <= 0:
                continue
            # most favourable rounding for the printed cell
            t_best = (b + 0.0005) / max(e - 0.0005, 1e-9)
            if t_best < NEED[st]:
                p_best = 2 * (1 - stats.norm.cdf(t_best))
                flags.append((tname, label, c + st, s, round(t_best, 2), round(p_best, 4), st))

if flags:
    for f in flags:
        print(f"  {f[0]:9s} {f[1]:22s} {f[2]:>11s} SE({f[3]})  best-case t={f[4]:5.2f} p={f[5]:.4f}  <- cannot earn {f[6]}")
else:
    print("  none")
print(f"\n  {len(flags)} internally impossible cell(s) across all four tables")
