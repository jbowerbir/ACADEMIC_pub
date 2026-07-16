# Desert and Redistribution: Justice as a Remedy for, and Cause of, Economic Inequality

Jacob S. Bower-Bir (2022). *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

Published online 8 September 2021; print issue November 2022. **Cite as 2022.**

## Abstract

Americans simultaneously believe income differences are too large, perceive conflict between rich and poor, but do not think the gap needs fixing. This paper resolves the paradox. The answer is desert: Americans' definitions of what people deserve — and their faith that the economy delivers just outcomes — drive redistributive preferences more powerfully than self-interest, ideology, or economic assessments.

## Replication

**Data:** `../data/economic_justice_v7_analysis-weighted.csv` — use this one. The other release (`economic_justice_v7_nonstandardized.csv`) lacks the survey weights every published model needs. See `../data/README.md`.

**Codebook:** `../data/Survey_v7_codebook_2014-04-08.xlsx`

**Scripts** (`analysis/`):

| File | What it is |
|---|---|
| `policy_taxation_ORIGINAL.do` | **The original Stata analysis** (2014-09-22), as run for the paper. Table 1 is lines 142–164. This is the authority; the ports below were checked against it. |
| `replicate_table1.R` | Base-R port of Table 1. No package dependencies — `lm()` plus a hand-rolled HC1 sandwich, so it runs on a bare R install. |
| `replicate_table1.py` | Python port of Table 1 (pandas + statsmodels). |
| `public-opinion-puzzle_180817.R` | Figure 1 (the public-opinion puzzle). **Figures only — contains no regressions.** |
| `data-aesthetic-v-justice-mismatch_180604.R` | Aesthetic-vs-justice mismatch figure. **Figures only.** |

Both ports reproduce every cell of published Table 1 to three decimals — including all R² and N = 963 — except the three cells listed under Corrigendum below, which is how those were identified.

### The model

```stata
areg <dv> corr_ideal_agency <Z...> ideo_str age age_2 female nonwhite married_bin \
     unemployed_now education income_household [pw=post_weight], absorb(state)
```

- `<dv>` = `gov_reducegap_str` (support for government action to reduce the income gap) or the constructed `progtaxes2_str` (support for progressive taxation).
- **`corr_ideal_agency` is the variable printed as "Definition."** It is each respondent's within-person correlation between how much control she thinks people have over each of 15 factors and how important she thinks each factor *ideally* should be to economic standing. High = defines desert in terms of things people control.
- `<Z>` = `agency_str` (Model 1) | `justice_str` (Model 2) | `desert_rich_tot` + `desert_americans_tot` + `desert_poor_tot` (Model 3).
- `absorb(state)` = state fixed effects. `[pw=post_weight]` implies robust SEs in Stata; the ports use HC1 to match.

### Gotcha, if you write your own port

The Stata original tests float equality directly (`if married == .8`, `if progtaxes2_str == 4`). **Do not transliterate that literally.** The stored values are 0.7999999… and 3.9999999…, so exact comparison matches *zero* of the affected rows, which then silently keep their raw values instead of being recoded. That corrupts the dependent variable and shifts every coefficient by roughly 0.03 — with no error and no warning. Round onto the integer grid first. Both ports do, and both are commented at the trap.

## Corrigendum (filed July 2026)

Three cells of Table 1 (p. 18 of the published PDF) were altered in typesetting. **The analysis, the estimates, and every substantive claim in the paper are unaffected** — the article's own text reports the correct results in each case — and the scripts here reproduce the correct values.

| Cell | Published | Correct |
|---|---|---|
| Definition, Model 3, Y_gov_fix_gap | `0.518***` | **`−0.518***`** — minus sign dropped |
| Rich deserve, Model 3, Y_gov_fix_gap (SE) | `(1.056)` | **`(0.056)`** — spurious leading digit; as printed t ≈ 0.35, which cannot carry significance at 1% |
| Nonwhite, Model 1, Y_prog_tax (SE) | `(0.012)` | **`(0.031)`** — coefficient value duplicated into the SE slot |

The first is the one that matters: Definition is the paper's central variable, and §6.3 states in prose that it "always has a negative and statistically significant influence on Y_gov_fix_gap." A reader working from the table rather than the text would report the finding with the wrong sign.

## Key Finding

Desert definitions and faith in economic justice predict redistributive preferences more strongly than income, education, or ideology. The public-opinion "puzzle" dissolves once you account for the fact that most Americans believe the economy already rewards desert — making redistribution feel unnecessary despite acknowledged inequality.
