# Summary of corrections: Bower-Bir, "Desert and redistribution" (PSJ 50(4):757-795)

**Desert and redistribution: Justice as a remedy for, and cause of, economic inequality**
Jacob S. Bower-Bir · *Policy Studies Journal* 50(4): 757-795 · DOI 10.1111/psj.12439

Every model in the paper was re-estimated from the original survey data, independently in R and in Python, against the original 2014 Stata code. Every coefficient, standard error, sample size, R² and adjusted R² in Tables 1, C1, C2 and D1 reproduces exactly, as does every row of Table A1. The cells listed below are the only ones that did not reproduce, which is how they were found. All are transcription slips between a correct result and the printed page, and all originate in the submitted LaTeX manuscript, not in typesetting. None touches an estimate, a model, a sample, or a conclusion.

## Table 1 (p. 18)

| Row | Column | Published | Correct |
|---|---|---|---|
| Definition | Y_gov, Model 3 | `0.518***` | **−0.518\*\*\*** |
| Rich deserve (SE) | Y_gov, Model 3 | `(1.056)` | **(0.056)** |
| Nonwhite (SE) | Y_prog_tax, Model 1 | `(0.012)` | **(0.031)** |
| Agency | Y_prog_tax, Model 1 | `−0.133***` | **−0.133\*\*** |

**Why none of it matters.** *Definition:* the minus sign was dropped; Section 6.3 already states the correct result in words ("definition of desert always has a negative and statistically significant influence on Y_gov"). As printed it was the only sign reversal in an otherwise uniformly negative row, so the corrected value restores the pattern the text describes. *Rich deserve SE:* as printed, −0.366 over an SE of 1.056 gives t ≈ 0.35, which cannot carry the three stars shown; the correct SE gives t ≈ 6.5, consistent with the significance. *Nonwhite SE:* a decimal slip; the coefficient is non-significant either way. *Agency:* t = −2.52, p = 0.012, significant at 5% rather than 1%; the coefficient stays negative and significant, only the star count changes.

## Appendix C, Table C1

| Row | Column | Published | Correct |
|---|---|---|---|
| Married | Y_prog_tax, Model B | `0.320` | **0.032** |
| Education (SE) | Y_gov, Model D | `(0.56)` | **(0.056)** |
| Education (SE) | Y_prog_tax, Model D | `(0.55)` | **(0.055)** |

**Why none of it matters.** Married is non-significant either way; the two Education cells are decimal slips in the standard error that leave every significance verdict unchanged.

## Appendix C, Table C2

| Row | Column | Published | Correct |
|---|---|---|---|
| Income | Y_gov, Model E | `0.136***` | **−0.136\*\*\*** |
| N | Y_prog_tax, Model A | `963` | **992** |

**Why none of it matters.** *Income:* the minus sign was dropped; the magnitude and significance are unchanged and the corrected sign matches the negative income relationship throughout the paper. *N:* a label, not an estimate. Models containing `Definition` have N = 963, because 29 respondents have no value for that variable; models without it have N = 992. Model A (Y_prog_tax) carries no `Definition`, so its N is 992.

## Appendix D, Table D1 (Y_prog_tax, Model 3)

Six coefficients in the desert block were printed against the wrong row labels. The Stata output listed the block in one order; the table interleaved it in another; the column was transcribed downward against the interleaved labels. The correct assignment:

| Printed row label | Published value | Belongs to |
|---|---|---|
| Rich deserve | `0.833` | **Rich deserve, corrected to 0.883** (also a digit slip) |
| Definition × Rich deserve | `−0.653` | **Avg. deserve** |
| Avg. deserve | `−0.922` | **Poor deserve** |
| Definition × Avg. deserve | `−1.300` | **Definition × Rich deserve** |
| Poor deserve | `0.662` | **Definition × Avg. deserve** |
| Definition × Poor deserve | `0.860` | correct row; its SE `(0.926)` was a duplication of the row above and should read **(0.900)** |

**Why none of it matters.** None of these six coefficients is statistically significant, so the conclusion drawn in Section D.2, that the interaction is not supported, is unchanged. The Y_gov columns of Table D1 were printed correctly and are unchanged.

---

Every item above is a slip of transcription between a correct analytical result and the printed page. The paper's findings, its argument, and its interpretation are unaffected. A public replication package (the survey data, the original Stata code, and independent R and Python ports that reproduce every table) is in preparation and can be supplied on request.
