# REPO_INDEX.md --- ACADEMIC_pub

DocID: DOC-REPO-INDEX-ACADEMIC-PUB
Version: v0.4
Status: Active
Lifecycle: active (static archive; the two journal corrections are live)
Last Updated: 2026-11-09
Scope: Archive guide and cross-repo routing table for ACADEMIC_pub.
Related: AI_CORE/NETWORK_MAP.md, ACADEMIC_deposit/REPO_INDEX.md

---

## What This Repo Is

Published academic work (static archive). Replication packages for Jake's peer-reviewed papers, as deposited in IU DataCORE. Licensed CC BY-NC-SA 4.0 as a whole; each package CC BY 4.0. No CLAUDE.md---this repo has no active AI governance. No WORKSPACE.md---nothing is in progress. This index is therefore the *only* orientation layer here; read it before touching anything. Pushes to this repo are gated: Jake approves each one (AI_CORE CLAUDE.md, Commit Policy).

## Reading Groups

Read these together. Reading one in isolation has produced wrong answers before.

- **Citing, quoting, or replicating a number from either published paper**: the paper directory's `README.md` **Summary first**, before the published PDF or any table. Both papers have documented defects in what was printed --- 22 mistyped cells, two misread sentences on Age², and two appendix figures on mixed scales in the PSJ paper; eight mistyped numbers and an inverted neoliberal axis in Figure 7 and Section 5 of the Economia Politica paper. Citing the published cell without reading the README reproduces a known error. Then: the paper's correction (`corrigendum_psj.md` in the PSJ package, as sent to Wiley; for Economia Politica, `ACADEMIC_deposit/earning-our-place-ecopol-2020/corrigendum/EP_corrigendum.md`, unsent), and AI_academic `docs/academic-ops-log.md` for submission state.
- **Re-running or porting an analysis**: the package's `script_replication.R` and `script_replication.py` (identical output, each diffed against `tables/tables_as-published.md`) with the original Stata in the package (`script_original_stata-2014.do` for PSJ, `script_original/` for Economia Politica) as the reference implementation. After any edit to a README or the correction, run `ACADEMIC_deposit/checks/check_claims.py` from the package folder: it recomputes every count and named cell the prose asserts.
- **Anything touching the survey data**: `data/README.md`, then `ACADEMIC_deposit/data/PROVENANCE.md` and `CODEBOOK.md`. The full Economic Justice Survey (v7) is **not in this repo**; it is staged privately in ACADEMIC_deposit for the IU DataCORE deposit. Do not assume a file is missing in error.

## Exports (what other repos reference from here)

| What | Where | Referenced by |
|---|---|---|
| Published papers (writing samples) | paper directories | AI_academic (job-applications/06_writing-samples/) |
| Replication data subsets (Economic Justice Survey v7) | `*/data_survey_*-subset.csv` | AI_academic (desert papers, empirical analysis) |
| Replication scripts | `*/script_replication.R`, `.py` | AI_academic (methodological reference) |

## Imports (what this repo references from elsewhere)

| What | From | Why |
|---|---|---|
| Survey data, cleaning chain, instrument, provenance and codebook | **ACADEMIC_deposit** (private staging) | The Economic Justice Survey v7 is held there pending the IU DataCORE deposit. `data/build_psj_subset.py` and `data/build_ep_subset.py` there cut the two packages' data files. |
| PDF build, claims check | **ACADEMIC_deposit** `desert-redistribution-psj-2021/pdf-build/`, `checks/` | `README.pdf` and the table PDFs are rendered there (needs AI_CORE's md2pdf); `check_claims.py` verifies the READMEs' numbers. |

## Published Papers

- `desert-redistribution-psj-2021/` --- PSJ **2022**, 50(4), 757--795. DOI 10.1111/psj.12439 (online 2021, print 2022; cite as 2022). The replication package as deposited in IU DataCORE (record 1 of 4; DOI pending as of 2026-11-09), nothing else: the 27-column survey data and codebook (files named `category_item_variant_program`), `script_replication.R` and `script_replication.py` (every table and figure, identical output, each diffed against the printed tables), the tables as printed, typos fixed, and final (duplicate removed, the 2014 weight's misplaced $25,000 income line corrected) in `tables/`, the figures in `figures/`, the correction (`corrigendum_psj`; journal correction DOI 10.1111/psj.70145), and the annotated 2014 Stata. Its README is the package's, titled as the DataCORE record with an "About this record" section and numbered sections. On DataCORE the two folders travel as `tables.zip` and `figures.zip` (gitignored here; on the shared Drive folder) and everything else is loose. Figures D1 and D2 are drawn correctly from the Table D1 models; the printed ones mix two scalings of Definition, and the README says how they differ. Figure B1 is not reproduced, since it needs the factor ratings the subset lacks.
  - `corrigendum_psj.md`, `.pdf` --- the correction as sent to Wiley production on 2026-10-26 (PSJ70145), revised since in the package: the 22 mistyped cells (the copy at Wiley says 21 and seventeen), the two data-cleaning errors, the two Section 6.1 sentences on Age² (turning point about 34), the note on Figures D1 and D2, and final Table 1 on 991 respondents with corrected weights. Two pages. The proof is open at Wiley; Jake edits it in the portal to match this file (`ACADEMIC_deposit/desert-redistribution-psj-2021/corrigendum/proof-changes_2611.md`). "DOI forthcoming" stays until DataCORE mints the DOI, then goes to Wiley as a one-line follow-up.
- `earning-our-place-ecopol-2020/` --- Economia Politica 2021, 38(1), 131--170. DOI 10.1007/s40888-020-00201-9 (online 2020, print 2021; cite as 2021). The replication package for IU DataCORE (record 2 of 4; stub record and DOI requested in the reply drafted 2026-11-06), rebuilt 2026-10-26 on the PSJ model and brought to the same layout 2026-11-09: the 54-column, 992-record data subset and codebook, `script_replication.R` (tables, figure statistics, weight check, all seven figures) and `script_replication.py` (same tables; output byte-identical), `tables/` (`tables_as-published.md`, `tables_typos-fixed_R.md`, `tables_final_R.md`, each with a `_python` twin; the final tables on the corrected weight, Table 2 on 991), `figures/` (the seven figures, Figure 7 corrected), the original 2014 Stata and 2018 R in `script_original/`, and a README in the PSJ form. 305 printed cells compared, 8 differ (two Table 1 Model 1b SEs, the Model 3b Income star, two Table 4 last-digit SEs, the Figure 3 health/state-of-econ swap, the Figure 6 mean), plus the Figure 7/§5 neoliberal inversion (32.5% lean neoliberal, not 60%). The README also reports the weighting script's off-by-one income stratum and the re-raked robustness check (no finding changes; ideology gains stars in Models 1a/1b). The journal correction is drafted in ACADEMIC_deposit `earning-our-place-ecopol-2020/corrigendum/`, unsent; it needs the journal's editorial address.

## Data

Economic Justice Survey (v7), fielded by SocialSci between November 2013 and April 2014: 992 records, 991 respondents. The shared dataset behind both published papers. **The full survey is being deposited at IU DataCORE (record 3 of 4) and is not in this repository**; it is staged in ACADEMIC_deposit `data/` (raw file, `clean.R`/`clean.py`, four cleaned layers, instrument, codebook, provenance). `data/README.md` describes the deposit and what is public now. The endowment experiment (record 4 of 4) is a separate deposit, staged in AI_academic `papers/endowment-experiments/`; nothing of it is here yet.
