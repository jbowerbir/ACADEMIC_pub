# Replication package

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

## Summary

This package allows users to replicate every table and figure in the article using the provided survey data. The original Stata script used to analyze the data has been translated into R and Python, and expanded to compare the tables it produces with the published tables. The R and Python scripts produce identical output; the Stata script is included as the original record. Findings:

- Twenty-one published cells differ from the output, all copying errors made when the results were typed into the manuscript. None contradicts the published prose. 
- One sentence of the published text misreads a coefficient sign. The coefficient on `age^2` is so small that it prints as 0.000. The offending sentence in the article calls it positive when it is negative, so support for government action rises with age to the late thirties and then falls rather than accelerating. 

A correction (journal DOI 10.1111/psj.70145) is included. None of the errors alters the article's substantive findings or interpretations.

## Files

| File | What it is |
|---|---|
| `economic_justice_v7_psj-replication.csv` | The survey data: 992 respondents and the 27 variables the tables and figures use. No value was changed. The full survey is a separate deposit (see "The data"). |
| `codebook.md` | The 27 columns: question wording, answer options, coding and rescaling, and the name each has in the tables. |
| `replicate.R` | The analysis in R: Tables 1, C1, C2 and D1 (32 regressions), Table A1, and Figures 1, 2, 3, 4, D1 and D2. Writes `tables_corrected.md` and the figures, then prints every cell where the printed tables differ. Base R only. |
| `replicate.py` | The same program in Python. Writes `tables_py.md` and `figure-*-py.png`, identical to the R output. |
| `tables_published.md` | The four regression tables as printed in the article, copied cell by cell from the published PDF, stars included. |
| `tables_corrected.md`, `.pdf` | The four regression tables as they should read, Table A1, the shares behind Figure 4, and the eight regressions behind Figures D1 and D2. Estimated on all 992 rows, as the article was. The output of either program. |
| `tables_deduplicated.md`, `.pdf` | The same tables estimated on the 991 distinct records, without the duplicated one, ending with a list of every cell that changes at the printed precision. These are the replacement tables offered to the journal. The output of either program. |
| `figure-1.png` … `figure-D2.png` | The figures, as drawn by `replicate.R`. |
| `PSJ_summary-of-corrections_Bower-Bir_v2.md`, `.pdf` | The correction: each wrong cell, what it should be, and why none of them changes a finding; plus the one corrected sentence. |
| `policy_taxation_2014_annotated.do` | The original Stata code that produced the article's tables and the D1 and D2 plots, commands untouched, with comment lines (`// [2026]`) saying which command makes which table or figure. A record, not a runnable script: it reads a file not included here. |

## Running it

Put the files in one folder. R needs base R only. Python needs pandas, numpy, scipy, statsmodels and matplotlib.

- `Rscript replicate.R` writes `tables_corrected.md`, `tables_deduplicated.md` and the six figures, and prints the comparison with the printed tables.
- `python3 replicate.py` writes the same files with a `_py` or `-py` suffix, and prints the same comparison.
- `diff tables_corrected.md tables_py.md` and `diff tables_deduplicated.md tables_deduplicated_py.md` print nothing.

## What is reproduced, and how closely

- **Tables 1, C1, C2, D1.** Every coefficient, standard error, N, R² and adjusted R² matches the printed value to the printed decimals, except the 21 corrected cells. The constant's standard error is an approximation of Stata's and is not compared.
- **Table A1.** Every count matches.
- **Figures 2, 3, 4.** Drawn from the same data with the same variables. Figure 2 matches the printed heights. The printed Figure 3 was smoothed more heavily than the default used here, and the smoothing it used is not recorded. Figure 4 drops the duplicated respondent record, as the 2014 plot did.
- **Figures D1, D2.** The marginal-effect lines and bands come from the eight regressions the 2014 plot code specifies (ordinary weighted regression without state effects, errors clustered by state). Their coefficients are not printed in the article; they are written to `tables_corrected.md`. The panels match the printed ones.
- **Figure 1** charts three percentages from the 2010 General Social Survey, not from this survey; the numbers are in the scripts.
- **Figure B1**, the heat maps of control against ideal importance, belongs to the companion article in *Economia Politica* and is reproduced in that article's package.

## The data

The Economic Justice Survey (version 7) was fielded by SocialSci in November 2013. 992 respondents remained after cleaning, and all are here. Of the survey's 241 columns, this file keeps the 27 the tables and figures use. The variables the regressions build from them (age squared, the married and unemployed indicators, the four-level tax outcome, the interaction terms) are computed by the R and Python scripts as the 2014 Stata code computed them. Some columns in the file were themselves calculated from the raw answers when the survey was cleaned in 2014: the four attitude measures that combine a direction with a strength (`gov_reducegap_str`, `agency_str`, `justice_str`, `gov_help_str`), the three deserve scores (`desert_rich_tot`, `desert_americans_tot`, `desert_poor_tot`) and the Definition correlation (`corr_ideal_agency`). Each was recomputed from the raw survey items and matches on every row. The full survey, with the cleaning scripts, questionnaire and codebook, will be deposited separately; its DOI will be added to this record.

A codebook for the relevant subset of data is provided. Additional notes on data:

- `row` is the row number in the full survey file and the only column that identifies a respondent uniquely.
- `id` is the vendor's respondent number, kept for matching to the full survey. Two things make it unreliable as a key. First, 55 id values are each carried by two different respondents: the vendor's numbering collided within one fielding batch, and the pairs are different people (different ages, genders and states). Second, one respondent's record is genuinely in the file twice, under ids 1115 and 1157, identical in every answer, so the 992 rows hold 991 people. The duplicate is kept because the published tables were estimated on all 992 rows; dropping it would change every estimate slightly. The one place the 2014 analysis dropped it was Figure 4, and the scripts do the same there. Both scripts also estimate every table a second time on the 991 distinct records and write the result to `tables_deduplicated.md`: coefficients move in the third decimal, three significance stars sitting on a threshold change (Definition in Table 1 Model 1 from 1% to 5%; two 10% stars on controls disappear), and no sign, finding or sentence of the article changes. Use `row`, not `id`, to refer to a respondent.
- `corr_ideal_agency` is missing for 29 respondents, so regressions that include it have N = 963 and regressions without it have N = 992.

## The regressions

Every regression in the tables is one Stata command, `areg <outcome> <predictors> [pw=post_weight], absorb(state)`: a linear regression weighted by the survey weight, with a separate intercept for each state (state fixed effects) and standard errors that remain valid when the spread of the errors differs across respondents (heteroskedasticity-robust, the formula known as HC1). The outcome is Y_gov_fix_gap or Y_prog_tax. The predictors are Definition, one measure of perceived economic justice (Agency in Model 1, Justice in Model 2, the three deserve variables in Model 3) and the same controls throughout. Table C1 drops Definition and enters each justice measure individually; Table C2 adds three controls; Table D1 adds the product of Definition and each justice measure (an interaction). The scripts fit the same regressions as weighted least squares with an indicator for each state.

## Two things to know before writing your own version

**Testing decimals for equality.** The 2014 code recodes variables by exact comparison (`if married == .8`, `if progtaxes2_str == 4`). That works in Stata. In R or Python it silently matches no rows, because the stored values are 0.7999… and 3.9999…; the tax outcome is then wrong and every coefficient moves by about 0.03, with no error. Round to the nearest integer first. Both scripts do.

**The interaction terms.** Lines 46–59 of the Stata code build the interaction variables from Definition rescaled to 0 to 1 but store them under the unscaled names. So every interaction term in Table D1 uses the rescaled Definition, and in two of the six D1 regressions (Y_gov Model 1, Y_prog_tax Model 3) the Definition variable itself is also the rescaled one. The fit is identical either way; only the printed coefficients differ, by a factor of two. The scripts reproduce what the article printed. Build the interactions from the unscaled Definition and you will get coefficients half as large and conclude, wrongly, that the table is wrong.

## Citation and license

Cite the article, and this package by the DOI on its record. Released under CC BY 4.0.
