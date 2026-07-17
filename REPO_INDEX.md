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

- `desert-redistribution-psj-2021/` --- PSJ **2022**, 50(4), 757--795. DOI 10.1111/psj.12439 (online 2021, print 2022; cite as 2022). Original Stata analysis (`policy_taxation_ORIGINAL.do`), bit-exact R and Python ports of Table 1, an ordered-logit robustness reconstruction, a table audit script, and two original R plotting scripts. See the README Corrigendum: four Table 1 defects plus the appendix defects (Tables C1/C2/D1), all filed with the journal July 2026, with correct attribution (author's submitted LaTeX, not typesetting).
- `earning-our-place-ecopol-2020/` --- Economia Politica 2021, 38(1), 131--170. DOI 10.1007/s40888-020-00201-9 (online 2020, print 2021; cite as 2021). Three original Stata scripts (Table 1 regressions, factor correlations, Table 2 demographics), four Python/R replication ports, an audit script, and four original R plotting scripts. Ports reproduce Tables 1, 2 and 4 in full; see the README Corrigendum for five documented discrepancies (two Table 1 cells, an inverted neoliberal direction in Fig 7/§5, two transposed Fig 3 coefficients, the dropped duplicate behind N=953, and an off-by-one income stratum in the weighting script).

## Data

Economic Justice Survey (v7), fielded by SocialSci, November 2013. Shared dataset supports both published papers. Prepared for IU ScholarWorks deposit 2026-07-16.

### Standing References

- `data/PROVENANCE.md` --- DOC-EJS-PROVENANCE. Vendor delivery to analysis file: the exclusion rule (`drop if time_check <= 10`, 1,390 → 992), the three-script cleaning chain, raking method and targets, every layer's shape, and four verified data-quality defects. Read before using the data.
- `data/CODEBOOK.md` --- DOC-EJS-CODEBOOK. Variable-level documentation: question wording, coding, scaling, derivation keyed to script and line. Covers the 45 variables absent from the original codebook spreadsheet.

### Data files (all de-identified)

- `data/economic_justice_v7_raw.csv` --- Layer A. 1,390 x 181. Includes the 398 later-excluded responses.
- `data/economic_justice_v7_nonstandardized.csv` --- Layer B, cleaned. 992 x 229.
- `data/economic_justice_v7_standardized.csv` --- Layer C. 992 x 229. Defective on six econ variables; see PROVENANCE.md.
- `data/economic_justice_v7_nonstandardized-weighted.csv` --- Layer D. 992 x 240.
- `data/economic_justice_v7_standardized-weighted.csv` --- Layer E. 992 x 240.
- `data/economic_justice_v7_analysis-weighted.csv` --- Layer E_WORKING. 992 x 241. **The analysis file; replicates the published tables.**

### Scripts and source material

- `data/build_deposit_csvs.py` --- Builds all six CSVs from the source Stata files; verifies shapes, scans for PII.
- `data/build_analysis_csv.py` --- Builds the analysis layer alone. Superseded; kept for continuity.
- `data/cleaning-scripts/` --- The original 2014 Stata scripts: `Data Cleaning I_Generate` -> `II_Standardize` -> `III_Weight` (the chain), plus the superseded `Survey_recoding_v3.do`.
- `data/instrument/` --- Instrument as fielded (PDF), Qualtrics-authored version with numeric response codes (docx), quota design, and vendor quota reconciliation.
- `data/Survey_v7_codebook_2014-04-08.xlsx` --- The original codebook: 212 variables, with values and labels.
