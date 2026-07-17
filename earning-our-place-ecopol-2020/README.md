# Earning Our Place, More or Less: Responsibility's Flexible Relationship with Desert in Socioeconomic Standing

Jacob S. Bower-Bir (2021). *Economia Politica* 38(1): 131–170. https://doi.org/10.1007/s40888-020-00201-9

Published online 6 October 2020; print issue February 2021. **Cite as 2021.**

## Abstract

A nationally representative survey (N = 992) asks whether and which Americans associate personal responsibility with economic desert. Respondents generally want their economic fates to rest on criteria they are — or appear — personally responsible for, but they hold that belief with varying conviction and two notable exceptions. First, they are divided over how much control people have over their intelligence, creativity, health, and educational pedigree, yet are largely comfortable letting the first two shape economic standing. Second, neoliberals — those most concerned with economic growth — are significantly less insistent that people be personally responsible for where they land; so, to a lesser degree, are non-white, lower-income, older, and Ivy-educated respondents. Even at their strongest, the correlations between perceived control over a factor and its ideal importance are only moderate.

## Replication

**Data:** The replication dataset (Economic Justice Survey v7) is being finalized for public deposit at IU ScholarWorks and is not in this repository yet; it will be posted with the complete replication package (in preparation, 2026). See `../data/README.md` for the schema. The scripts below run against `economic_justice_v7_analysis-weighted.csv` (the weighted layer every regression uses) and `economic_justice_v7_nonstandardized.csv` (Table 2 and the figure statistics) once the data is in place.

**Codebook:** `../data/Survey_v7_codebook_2014-04-08.xlsx`

**Scripts** (`analysis/`):

| File | What it is |
|---|---|
| `definitions_agency_ORIGINAL.do` | **The original Stata analysis** (2014-06-26) for the Table 1 regressions. Defines `neoliberal_cons` at line 3 — the key to the sign convention. The published specifications are near-relatives of lines 32–39, not verbatim copies of them; they were matched by numbers, not by name. |
| `factor-correlations_ORIGINAL.do` | Original Stata (2014-06-26) for the by-factor and by-respondent correlation work behind Figures 3–6. Line 206 (`income_household school_ivy nonwhite age neoliberal_cons`) is **exactly** published Model 3a. |
| `Appendices_demographics_ORIGINAL.do` | Original Stata (2014-08-14). **Produces Table 2.** Its income cut points are the authority on the bracket mapping — and they contradict the weighting script (see Corrigendum item 5). |
| `replicate_table1.py` | Python port of Table 1, all six models (pandas + statsmodels). |
| `replicate_table1.R` | Base-R port of Table 1. No package dependencies — `lm()` plus a hand-rolled sandwich, so it runs on a bare R install. |
| `replicate_table4.py` | Python port of Table 4 (Appendix 3), all nine piecemeal models. |
| `replicate_table2_and_figures.py` | Table 2 and the numeric content of Figures 3–7. |
| `audit_published_tables.py` | Regenerates the evidence for every item in the Corrigendum below, including the re-raked robustness check. |
| `data-importance-v-control_180801.R` and the three `…-densities` / `-dot-plots` / `-heatmaps` scripts | Original R plotting code for Figures 1–5. **Figures only — no regressions.** |

**What reproduces.** All six Table 1 models and all nine Table 4 models — 216 coefficient and SE cells, plus every N and every R² — to the printed precision, except the cells listed under Corrigendum, which is how those were found. All 22 cells of Table 2 reproduce exactly. Figure 4 reproduces 15/15; Figure 3 reproduces 13/15.

### The model

```stata
svyset [pweight = post_weight]
gen neoliberal_cons = neoliberal * -1
svy: reg corr_ideal_agency <predictors> neoliberal_cons
```

- **The dependent variable is `corr_ideal_agency`**, each respondent's within-person correlation, across the 15 economic factors, between how much control she thinks people have over a factor and how important she thinks it *ideally should be* to economic standing. High = she wants economic standing to track things people control.
- Models **1a/2a/3a** use the `neoliberal` index; **1b/2b/3b** substitute its four constituent items. Models 2 and 3 are reduced forms dropping insignificant predictors.
- `class_change` is introduced in Table 3 and discussed in Appendix 4.3 but is **not** in any published model — including it does not reproduce the published N or R².

### Four gotchas, if you write your own port

Each of these fails *silently* — you get plausible numbers, not an error.

1. **The dependent variable ships rescaled.** Table 1's note says the DV is on [−1, 1], but the analysis file holds `corr_ideal_agency` already standardized to [0, 1] (`Data Cleaning II` line 297 applies `(x+1)/2`). Undo it: `dv = corr_ideal_agency * 2 - 1`. Skip this and every coefficient is exactly **half** the published value, with the *t*-statistics unchanged — so nothing looks wrong.

2. **The variable named `neoliberal` runs backwards from its name.** `Data Cleaning I` lines 95–102 multiply the four constituent items by −1 under the comment *"Recode to make (+) values liberal and (−) values conservative"*; `neoliberal` is their average (line 143). So **higher `neoliberal` = less neoliberal**. It correlates **+0.41** with `ideo_str` (+3 = very liberal). Table 1's "Neoliberal" row is the coefficient on the *flipped* index (`neoliberal_cons`). Regress on the unflipped column and you get **+0.182** where the paper prints **−0.182** — same magnitude, wrong sign, and the constant still matches exactly, so the error survives a casual check. The same flip applies to the four constituents in models 1b/2b/3b.

3. **The duplicated submission is dropped.** The file has 992 rows but 991 distinct respondents: two rows are identical on every column except `id` (1115 and 1157). Keep it and you get N = 954/672 against the published 953/671. See Corrigendum item 4.

4. **Float equality / the integer grid.** The Stata originals test float equality directly (`if condition == float(2.1)` in `Appendices_demographics_ORIGINAL.do`; `(income_household * 18) < 7` in `definitions_agency_ORIGINAL.do`). **Do not transliterate that literally.** Standardized values are stored as `0.7999999…`; `income_household * 18` lands on an exact integer for only **109 of 992** rows. A naive `== 7` matches almost nothing and silently leaves values un-recoded. Round onto the integer grid first.

**Standard errors.** `svy: reg` with only a pweight declared (no strata, no PSUs) gives the HC0 sandwich scaled by *n*/(*n*−1), with *df* = *n*−1. Both ports do this. Across Tables 1 and 4 that is 108 SE cells, of which 104 match the printed value exactly; the other four are the two Table 1 defects and the two Table 4 rounding-boundary cells, all listed below. statsmodels' HC1 scales by *n*/(*n*−*k*) instead and is marginally off on some cells.

## Corrigendum (filed July 2026)

Reproducing the paper turned up five discrepancies. **None changes a substantive conclusion**, and the scripts here print the correct values throughout.

### 1. Table 1 — two defective cells (p. 22)

| Cell | Published | Correct |
|---|---|---|
| Political party, Model 1b (SE) | `(0.0073)` | **`(0.073)`** — misplaced decimal |
| Female, Model 1b (SE) | `(0.023)` | **`(0.027)`** |

The first is self-evident from the table alone: it is the only four-decimal SE in a table printed to three, and the cell carries **no** significance star, yet `0.047/0.0073` would be *t* ≈ 6.4. With the correct SE, *t* = 0.65, which matches the absent star. The second (Female) is not earnable from the printed values, but is insignificant under either SE. Neither affects a claim in the text. (An earlier reading of this table also flagged the Model 3b Income star as over-stated; that claim is withdrawn as unsupportable, and is documented at the end of this section.)

### 2. Figure 7 and §5 — the neoliberal direction is inverted

This is the one worth reading carefully, though it leaves the paper's central finding intact.

Figure 7 plots the **unflipped** `neoliberal` index — its mass sits right of centre with a long thin left tail, and x̄ sits just right of *M*, exactly as the data do; the flipped index would mirror that. But the figure labels its right end **"neoliberal"**, when the right end is the *anti*-neoliberal end (gotcha 2). Consequently:

- §5: *"Approximately 60% of survey respondents fall on the positive side of the neoliberal index variable."* The **59.8%** is exactly right for the variable as coded — but that 60% is the share leaning **anti**-neoliberal. Only **32.5%** lean neoliberal.
- The caption's *"the majority of survey respondents have neoliberal-leanings, with few die-hard neoliberals, but even fewer respondents dead set against neoliberal ideas"* inverts in each clause. The majority lean anti-neoliberal; the ~3.4% die-hards at the right end are anti-neoliberal; the ~0.7% thin tail at the left end are the die-hard neoliberals.

**Table 1 is unaffected**, and so is the paper's argument. The regressions use `neoliberal_cons`, are correctly signed, and the text reads them correctly ("moving a respondent from a steadfast anti-neoliberal position to a staunch neoliberal position will produce a decrease of about 0.20 units"). What is wrong is the *prevalence* claim: neoliberals are a smaller minority of the sample than §5 states, which slightly weakens the framing of them as a large "heretical group" without touching the finding that they *are* one.

### 3. Figure 3 — two coefficients transposed

Figure 3 prints `health` r = 0.32 and `state of econ.` r = 0.33. The data give **health = 0.3321** and **state of econ. = 0.3179** — the two values are attached to the wrong factors. Since Figure 3 arrays its panels in ascending *r*, the two panels are also out of order. Figure 4 has the same pair right (0.3228 vs 0.3231, correctly ordered). Immaterial: both are "weak-to-moderate" on the paper's own reading either way.

### 4. N = 953 — the duplicate is dropped, by no surviving script

The published models run on 991 distinct respondents, not 992: the duplicated submission (`id` 1115/1157) is excluded. This is established, not guessed — dropping it reproduces the N *and* the R² of all six Table 1 models and all nine Table 4 models simultaneously, and of all 992 rows only these two twins do that (verified by exhaustive single-row removal). **What is unverified is the mechanism**: no script in the deposit performs the drop, and `PROVENANCE.md` correctly reports that nothing in the cleaning chain removes duplicates. A user running the shipped data as-is will get N = 954 and must drop the duplicate to match the paper.

### 5. Weighting script — income stratum boundary is off by one bracket

`Data Cleaning III_Weight_2014-04-08.do` line 26 sets `income_weight = 1 if income_household < 8` and targets it at *"24.70% earn less than $25,000"*. But the instrument's 19 brackets put **$25,000–$29,999 at index 7**, so `< 8` means "under $30,000". The correct cut is `< 7`. Confirmed two ways: the instrument itself (Qualtrics Q105/Q106), and Table 2's own script (`Appendices_demographics_ORIGINAL.do`), which cuts at `income <= 6` and yields exactly the 192 the published Table 2 prints. The two scripts disagree with each other; the demographics one is right.

Effect: **54 respondents** earning $25,000–$29,999 are raked as if they earned under $25,000, so `post_weight` mis-corrects the income margin. The other four margins (gender, race, education, party) are correctly specified.

**This does not overturn anything.** Re-raking with the corrected boundary (`audit_published_tables.py` §5, which first validates its own raking against the shipped `post_weight` to 1.4e-05) leaves every sign and every significance level in Model 3a intact; coefficients move by roughly 5–10% relative. It is documented so that a replicator who fixes the strata and gets slightly different numbers knows why.

### Minor, noted for completeness

- **The "Adj-R²" row is plain R².** `svy: regress` reports only R-squared. All six Table 1 values and all nine Table 4 values match R² exactly to four decimals; none matches the true adjusted R². A mislabel — no number is wrong.
- **§3.4 states the mean by-respondent correlation is 0.69**; the data give 0.685 (which prints as 0.68). Median, IQR, SD, and the "90% of the observations fall between [0.44, 0.98]" claim all reproduce exactly — that last one at exactly 90.0%.
- **§4.2.2 says the nonwhite effect is "between 0.07 and 0.10 units."** Across the six models it runs 0.061–0.098, so the low end is slightly overstated.
- Table 4 Model E's constant SE (published 0.035, replication 0.03596) and Model F's Neoliberal SE (published 0.064, replication 0.06349) each differ in the last printed digit. Both sit within 0.0005 of a rounding boundary; these are **not** established defects.

## Key Finding

Americans mostly want economic standing to track things people control — but they hold that belief far more loosely than either the philosophical literature or the effort-luck dichotomy in economics assumes. The by-factor correlations between perceived control and ideal importance never exceed the "moderate" range, and respondents happily let intelligence and creativity shape economic fortunes while disputing that anyone controls them. Desert is a social institution, not a fixed formula: its dependence on personal responsibility varies systematically across the population, most sharply with a respondent's commitment to economic growth.

### Withdrawn: the Model 3b income star

An earlier version of this README listed Table 1's Model 3b Income cell (`0.125***`, SE 0.049) as an over-starred defect, on the basis that re-estimation returns *p* = 0.0104 — just over the 1% threshold. **That claim is withdrawn: it is not supportable.**

The printed cell fixes the coefficient and SE only to three decimals, so the values it is consistent with admit *p* anywhere in **[0.0097, 0.0118]**. The 0.01 threshold sits inside that interval. A single point estimate from a port whose degrees-of-freedom convention may differ from Stata's cannot adjudicate a call that close, and `***` is therefore not refutable from the published table.

Recorded because the distinction matters for anyone auditing tables this way: the same test applied to the sibling PSJ paper's Agency cell (`−0.133***`, SE 0.053) gives a best case of *p* = 0.0112, which **cannot** reach 0.01 by any rounding — so that one is a genuine defect and this one is not. Bounds, not point estimates, decide it.
