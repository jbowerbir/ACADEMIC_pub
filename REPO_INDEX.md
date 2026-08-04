# REPO_INDEX.md --- ACADEMIC_pub

DocID: DOC-REPO-INDEX-ACADEMIC-PUB
Version: v0.2
Status: Active
Last Updated: 2026-07-16
Scope: Archive guide and cross-repo routing table for ACADEMIC_pub.
Related: AI_CORE/NETWORK_MAP.md

---

## What This Repo Is

Published academic work (static archive). Replication data and analysis scripts for Jake's peer-reviewed papers. Licensed CC BY-NC-SA 4.0. No CLAUDE.md---this repo has no active AI governance. No WORKSPACE.md---nothing is in progress.

## Exports (what other repos reference from here)

| What | Where | Referenced by |
|---|---|---|
| Published papers (writing samples) | paper directories | AI_academic (job-applications/06_writing-samples/) |
| Replication data (Economic Justice Survey v7) | data/ | AI_academic (desert papers, empirical analysis) |
| R analysis scripts | */analysis/ | AI_academic (methodological reference) |

## Imports (what this repo references from elsewhere)

| What | From | Why |
|---|---|---|
| None | --- | Static archive, no dependencies |

## Published Papers

- `desert-redistribution-psj-2021/` --- PSJ **2022**, 50(4), 757--795. DOI 10.1111/psj.12439 (online 2021, print 2022; cite as 2022). Original Stata analysis (`policy_taxation_ORIGINAL.do`), bit-exact R and Python ports of Table 1, an ordered-logit robustness reconstruction, a table audit script, and two original R plotting scripts. See the README Corrigendum: four Table 1 defects plus the appendix defects (Tables C1/C2/D1), all filed with the journal July 2026, with correct attribution (author's submitted LaTeX, not typesetting). `corrigendum/` (added 2026-08-04) archives the submitted summary + corrected tables and a capture of the Wiley proof (correction article PSJ70145, DOI 10.1111/psj.70145; proof open, submission parked until Sept; running narrative in AI_academic `docs/academic-ops-log.md`).
- `earning-our-place-ecopol-2020/` --- Economia Politica 2021, 38(1), 131--170. DOI 10.1007/s40888-020-00201-9 (online 2020, print 2021; cite as 2021). Three original Stata scripts (Table 1 regressions, factor correlations, Table 2 demographics), four Python/R replication ports, an audit script, and four original R plotting scripts. Ports reproduce Tables 1, 2 and 4 in full; see the README Corrigendum for five documented discrepancies (two Table 1 cells, an inverted neoliberal direction in Fig 7/§5, two transposed Fig 3 coefficients, the dropped duplicate behind N=953, and an off-by-one income stratum in the weighting script).

## Data

Economic Justice Survey (v7), fielded by SocialSci, November 2013. The shared dataset behind both published papers. **The data is being finalized for public deposit at IU ScholarWorks and is not in this repository yet** (de-identification under review; deposit planned for 2026). The staging work (raw through analysis layers, the instrument, the cleaning chain, and the provenance and codebook documentation) is held in a private repository until the deposit is reviewed and cleared; cleared files will be posted here with the complete replication package. `data/README.md` retains the dataset's schema for reference.
