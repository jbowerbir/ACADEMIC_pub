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

Both ports reproduce every cell of published Table 1 to three decimals (including all R² and N = 963) except the cells listed under Corrigendum below, which is how those were identified. The appendix tables (C1, C2, D1) reproduce in full on the same basis.

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

Reproducing the paper from the original data turned up a set of transcription slips between correct analytical results and the printed tables, in Table 1 and in the appendix tables. **The analysis, the estimates, and every substantive claim in the paper are unaffected**; the scripts here reproduce the correct values throughout, and every model reproduces exactly except the cells listed below, which is how they were found. All of these originate in the LaTeX manuscript I submitted, not in typesetting; they are mine. (An initial filing misattributed the Table 1 errors to production; that was corrected with the journal.)

### Table 1 (p. 18)

| Cell | Published | Correct |
|---|---|---|
| Definition, Model 3, Y_gov_fix_gap | `0.518***` | **`−0.518***`** (minus sign dropped) |
| Rich deserve, Model 3, Y_gov_fix_gap (SE) | `(1.056)` | **`(0.056)`** (spurious leading digit; as printed t ≈ 0.35, which cannot carry 1% significance) |
| Nonwhite, Model 1, Y_prog_tax (SE) | `(0.012)` | **`(0.031)`** (the coefficient value was duplicated into the SE slot) |
| Agency, Model 1, Y_prog_tax | `−0.133***` | **`−0.133**`** (t = −2.52, p = 0.012: significant at 5%, not 1%) |

The Definition cell is the one that matters: Definition is the paper's central variable, and §6.3 states in prose that it "always has a negative and statistically significant influence on Y_gov_fix_gap." A reader working from the table rather than the text would otherwise read the finding with the wrong sign.

### Appendix C (Tables C1, C2)

| Cell | Published | Correct |
|---|---|---|
| C1, Married, Y_prog_tax Model B | `0.320` | **`0.032`** (non-significant either way) |
| C1, Education, Y_gov_fix_gap Model D (SE) | `(0.56)` | **`(0.056)`** |
| C1, Education, Y_prog_tax Model D (SE) | `(0.55)` | **`(0.055)`** |
| C2, Income, Y_gov_fix_gap Model E | `0.136***` | **`−0.136***`** (minus sign dropped; magnitude and significance unchanged) |
| C2, N, Y_prog_tax Model A | `963` | **`992`** (Model A carries no Definition, so the 29 respondents missing that variable are not dropped; its N is the full 992) |

### Appendix D (Table D1, Y_prog_tax Model 3)

Six coefficients in the desert block were printed against the wrong row labels: the Stata output listed the block in one order, the table interleaved it in another, and the column was transcribed downward against the interleaved labels. The correct assignment, reproduced by the scripts here:

| Row | Correct value |
|---|---|
| Rich deserve | **`0.883`** (published `0.833`, also a digit slip) |
| Definition × Rich deserve | **`−1.300`** |
| Avg. deserve | **`−0.653`** |
| Definition × Avg. deserve | **`0.662`** |
| Poor deserve | **`−0.922`** |
| Definition × Poor deserve | `0.860`, SE **`(0.900)`** (the published SE `(0.926)` duplicated the row above) |

None of these six coefficients is statistically significant, so the conclusion in §D.2 (that the interaction is not supported) is unaffected. The Y_gov_fix_gap columns of Table D1 were printed correctly.

## Key Finding

Desert definitions and faith in economic justice predict redistributive preferences more strongly than income, education, or ideology. The public-opinion "puzzle" dissolves once you account for the fact that most Americans believe the economy already rewards desert — making redistribution feel unnecessary despite acknowledged inequality.
