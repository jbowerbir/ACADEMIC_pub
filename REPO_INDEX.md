# REPO_INDEX.md --- ACADEMIC_pub

DocID: DOC-REPO-INDEX-ACADEMIC-PUB
Version: v0.3
Status: Active
Lifecycle: active (static archive; the PSJ corrigendum is live)
Last Updated: 2026-08-04
Scope: Archive guide and cross-repo routing table for ACADEMIC_pub.
Related: AI_CORE/NETWORK_MAP.md

---

## What This Repo Is

Published academic work (static archive). Replication data and analysis scripts for Jake's peer-reviewed papers. Licensed CC BY-NC-SA 4.0. No CLAUDE.md---this repo has no active AI governance. No WORKSPACE.md---nothing is in progress. This index is therefore the *only* orientation layer here; read it before touching anything.

## Reading Groups

Read these together. Reading one in isolation has produced wrong answers before.

- **Citing, quoting, or replicating a number from either published paper**: the paper directory's `README.md` **Corrigendum section first**, before the published PDF or any table. Both papers have documented defects in what was printed --- four Table 1 defects plus Tables C1/C2/D1 in the PSJ paper, five discrepancies in the Economia Politica paper including an inverted direction in Fig 7/§5. Citing the published cell without reading the corrigendum reproduces a known error. Then: `corrigendum/` (what was actually filed with the journal) and AI_academic `docs/academic-ops-log.md` (submission state --- the Wiley proof is open and the submission is parked until September).
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
| Economia Politica computational replication package | **ACADEMIC_deposit** (private staging) | Three original Stata scripts, four ports, audit script. Only the R plotting scripts are public here. |

## Published Papers

- `desert-redistribution-psj-2021/` --- PSJ **2022**, 50(4), 757--795. DOI 10.1111/psj.12439 (online 2021, print 2022; cite as 2022). Original Stata analysis (`policy_taxation_ORIGINAL.do`), bit-exact R and Python ports of Table 1, an ordered-logit robustness reconstruction, a table audit script, and two original R plotting scripts. See the README Corrigendum: four Table 1 defects plus the appendix defects (Tables C1/C2/D1), all filed with the journal July 2026, with correct attribution (author's submitted LaTeX, not typesetting). `corrigendum/` (added 2026-08-04) archives the submitted summary + corrected tables and a capture of the Wiley proof (correction article PSJ70145, DOI 10.1111/psj.70145; proof open, submission parked until Sept; running narrative in AI_academic `docs/academic-ops-log.md`). Its two documents:
  - `corrigendum/PSJ_summary-of-corrections_Bower-Bir.md` --- the filed correction record. Every model re-estimated independently in R and Python against the original 2014 Stata code; everything reproduced except the listed cells, which is how they were found. All are transcription slips originating in the submitted LaTeX, not in typesetting, and none touches an estimate, model, sample, or conclusion.
  - `corrigendum/PSJ_corrected-tables_Bower-Bir.md` --- drop-in replacement Tables 1, C1, C2, D1, every cell regenerated from the survey data. Notes two non-corrections to expect: adjusted R² differences ≤0.0003 and borderline Constant significance markers, both artifacts of Stata's degrees-of-freedom convention for absorbed fixed effects.
- `earning-our-place-ecopol-2020/` --- Economia Politica 2021, 38(1), 131--170. DOI 10.1007/s40888-020-00201-9 (online 2020, print 2021; cite as 2021). **Present in this repo: the four original R plotting scripts only.** The computational replication package for this paper (three original Stata scripts, four Python/R ports, the audit script) exists but is **staged in the private `ACADEMIC_deposit` repo**, not here, unlike the PSJ paper whose full set is public. Ports reproduce Tables 1, 2 and 4 in full; see the README Corrigendum for five documented discrepancies (two Table 1 cells, an inverted neoliberal direction in Fig 7/§5, two transposed Fig 3 coefficients, the dropped duplicate behind N=953, and an off-by-one income stratum in the weighting script).

## Data

Economic Justice Survey (v7), fielded by SocialSci, November 2013. The shared dataset behind both published papers. **The data is being finalized for public deposit at IU ScholarWorks and is not in this repository yet** (de-identification under review; deposit planned for 2026). The staging work (raw through analysis layers, the instrument, the cleaning chain, and the provenance and codebook documentation) is held in a private repository until the deposit is reviewed and cleared; cleared files will be posted here with the complete replication package. `data/README.md` retains the dataset's schema for reference.
