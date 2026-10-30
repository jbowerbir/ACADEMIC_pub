# REPO_INDEX.md --- ACADEMIC_pub

DocID: DOC-REPO-INDEX-ACADEMIC-PUB
Version: v0.3
Status: Active
Lifecycle: active (static archive; the PSJ corrigendum is live)
Last Updated: 2026-10-26
Scope: Archive guide and cross-repo routing table for ACADEMIC_pub.
Related: AI_CORE/NETWORK_MAP.md

---

## What This Repo Is

Published academic work (static archive). Replication data and analysis scripts for Jake's peer-reviewed papers. Licensed CC BY-NC-SA 4.0. No CLAUDE.md---this repo has no active AI governance. No WORKSPACE.md---nothing is in progress. This index is therefore the *only* orientation layer here; read it before touching anything.

## Reading Groups

Read these together. Reading one in isolation has produced wrong answers before.

- **Citing, quoting, or replicating a number from either published paper**: the paper directory's `README.md` **Corrigendum section first**, before the published PDF or any table. Both papers have documented defects in what was printed --- four Table 1 defects plus Tables C1/C2/D1 in the PSJ paper, eight printed cells plus an inverted neoliberal direction in Fig 7/§5 in the Economia Politica paper (that README's Summary). Citing the published cell without reading the corrigendum reproduces a known error. Then: the paper's `corrigendum_psj.md` (as sent to Wiley 2026-10-26) or, for EP, `ACADEMIC_deposit/earning-our-place-ecopol-2020/corrigendum/EP_corrigendum.md` (unsent), and AI_academic `docs/academic-ops-log.md` for submission state.
- **Re-running or porting an analysis**: the paper's original Stata script (`*_ORIGINAL.do`) + its `analysis/` ports + the audit script. The Stata file is the reference implementation; the ports are bit-exact against it, and that equivalence is what makes the corrigendum findings trustworthy.
- **Anything touching the survey data**: `data/README.md` only. The Economic Justice Survey (v7) itself is **not in this repo** --- it is held in private staging pending de-identification review and IU ScholarWorks deposit. Do not assume a file is missing in error.

## Exports (what other repos reference from here)

| What | Where | Referenced by |
|---|---|---|
| Published papers (writing samples) | paper directories | AI_academic (job-applications/06_writing-samples/) |
| Replication data (Economic Justice Survey v7) | data/ | AI_academic (desert papers, empirical analysis) |
| R analysis scripts | */analysis/ | AI_academic (methodological reference) |

## Imports (what this repo references from elsewhere)

| What | From | Why |
|---|---|---|
| Survey data, cleaning chain, instrument, provenance and codebook | **ACADEMIC_deposit** (private staging) | The Economic Justice Survey v7 is held there pending de-identification review and IU ScholarWorks deposit. It is not in this repo. |

## Published Papers

- `desert-redistribution-psj-2021/` --- PSJ **2022**, 50(4), 757--795. DOI 10.1111/psj.12439 (online 2021, print 2022; cite as 2022). The replication package as deposited in IU ScholarWorks, nothing else: the 27-column survey data and codebook (files named `category_item_variant_program`, 2026-10-29), `script_replication.R` and `script_replication.py` (every table and figure, identical output, each diffed against the printed tables), the tables as printed, as corrected, and final (duplicate removed, the 2014 weight's misplaced $25,000 income line corrected; 2026-10-26), the figures, the correction (`corrigendum_psj`; journal correction DOI 10.1111/psj.70145), and the annotated 2014 Stata. Its README is the package's.
  - `corrigendum_psj.md`, `.pdf` --- the correction as sent to Wiley production on 2026-10-26 (PSJ70145): the 22 mistyped cells (the copy sent to Wiley says 21 and seventeen; the 22nd, an adjusted R2 in Table C2, was found 2026-10-30), the two data-cleaning errors (duplicate, weighting), the one corrected sentence, and final Table 1 on 991 respondents with corrected weights. Three pages. Waiting only on the DataCORE DOI line.
- `earning-our-place-ecopol-2020/` --- Economia Politica 2021, 38(1), 131--170. DOI 10.1007/s40888-020-00201-9 (online 2020, print 2021; cite as 2021). The replication package for IU DataCORE (rebuilt 2026-10-26 on the PSJ model; this is the only copy): the 54-column, 992-row data subset and codebook (`data/build_ep_subset.py` in ACADEMIC_deposit cuts it), `script_replication.R` (tables, figure statistics, weight check, all seven figures) and `script_replication.py` (same numbers; output byte-identical), `tables_as-published.md`, `tables_typos-fixed_R.md`, `tables_final_R.md` (each with a `_python` twin) (corrected weight; Table 2 on 991), the redrawn figures (Figure 7 corrected), and the original 2014 Stata and 2018 R in `script_original/`. 305 printed cells compared, 8 differ (two Table 1 Model 1b SEs, the Model 3b Income star, two Table 4 last-digit SEs, the Figure 3 health/state-of-econ swap, the Figure 6 mean); plus the Figure 7/§5 neoliberal inversion (32.5% lean neoliberal, not 60%). README also reports the weighting script's off-by-one income stratum and a re-raked robustness check (no finding changes; ideology gains stars in Models 1a/1b). The journal correction is drafted in ACADEMIC_deposit `earning-our-place-ecopol-2020/corrigendum/`, unsent.

## Data

Economic Justice Survey (v7), fielded by SocialSci between November 2013 and April 2014. The shared dataset behind both published papers. **The data is being finalized for public deposit at IU ScholarWorks and is not in this repository yet** (de-identification under review; deposit planned for 2026). The staging work (raw through analysis layers, the instrument, the cleaning chain, and the provenance and codebook documentation) is held in a private repository until the deposit is reviewed and cleared; cleared files will be posted here with the complete replication package. `data/README.md` retains the dataset's schema for reference.
