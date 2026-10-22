# Replication package

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

## Summary

This package allows users to replicate every table and figure in the article using the provided survey data. In addition to the original Stata script used to analyze the data---included in this package---I translated the analysis into R and Python, and expanded the analysis to compare the tables it produces with the published tables. The R, Python, and Stata scripts produce identical output. I found, however, a few typos in the published tables, none of which alter the paper’s conclusions. Below is a summary of discrepancies between the verified output and the published tables:

- Twenty-one published cells differ from the output, all copying errors I made when typing the tables into the manuscript: mostly digits mistyped or transposed, a decimal point in the wrong place, and significance stars one level off, plus three dropped minus signs. One of those is in Table 1, on the paper's central variable, where the text already states the correct, negative coefficient. None contradicts the published prose.
- One sentence of the published text misreads a coefficient sign. The coefficient on Age^2 is so small that it prints as 0.000. The offending sentence in the article calls it positive when it is negative, such that support for government action to reduce the income gap (Y_gov_fix_gap) rises with age into the late thirties and then falls rather than accelerating.

In the course of re-engaging with the data, I also found a duplicate row that my 2014 data cleaning did not catch. One respondent’s submission appears twice in the dataset provided by the online survey panel vendor, under two different survey ids. My initial cleaning removed every other duplicated row in the delivered dataset, save the remaining offender. Every table has been re-estimated on the 991 distinct observations, rather than the original 992. The figures can also be re-rendered, though the changes are imperceptible. As before, nothing contradicts the published conclusions or the prose. A summary of the changes:

- Coefficients move by one or two units in the third decimal place, at most 0.014.
- Four coefficients whose p-values sit on a significance threshold cross it, so their stars move by one level. Definition, the paper's central variable, drops from the 1% level to the 5% level in one of the three Y_gov models of Table 1 and stays at 1% in the other two. The other three are control variables: two drop out of significance altogether, and one achieves significance at the 10% level.

The dataset here provided includes the 27 survey variables used to generate the paper’s tables and figures, for all 992 observations as delivered by the panel vendor, with a codebook. The scripts produce both the 992-observation tables (the published analysis with the typos corrected) and the 991-observation tables (the replacement tables). Additional details below.

A correction (journal DOI 10.1111/psj.70145) is included. Again, none of the errors alters the article’s substantive findings or interpretations.

## Files

| File | What it is |
|---|---|
| `economic_justice_v7_psj-replication.csv` | The survey data: 992 respondents and the 27 variables the tables and figures use. No value was changed. The full survey is a separate deposit (see "The data"). |
| `codebook.md` | The 27 columns: question wording, answer options, coding and rescaling, and the name each has in the tables. |
| `replicate.R` | The analysis in R: Tables 1, C1, C2 and D1 (32 regressions), Table A1, and Figures 1, 2, 3, 4, D1 and D2. Writes `tables_corrected.md` and the figures, then prints every cell where the printed tables differ. Base R only. |
| `replicate.py` | The same program in Python. Writes `tables_py.md` and `figure-*-py.png`, identical to the R output. |
| `tables_published.md` | The four regression tables as printed in the article, copied cell by cell from the published PDF, stars included. |
| `cells_corrected.md` | The 21 cells where the printed tables differ from the re-run, one line each: what was printed, what the re-run gives. Written by either program. |
| `tables_corrected.md`, `.pdf` | The four regression tables as they should read, Table A1, the shares behind Figure 4, and the eight regressions behind Figures D1 and D2. Estimated on all 992 rows, as the article was. The output of either program. |
| `tables_deduplicated.md`, `.pdf` | The same tables estimated on the 991 distinct records, without the duplicated one, ending with a list of every cell that changes at the printed precision. These are the replacement tables offered to the journal. The output of either program. |
| `figure-1.png` … `figure-D2.png` | The figures, as drawn by `replicate.R`. |
| `PSJ_summary-of-corrections_Bower-Bir_v2.md`, `.pdf` | The correction as proposed to the journal: a one-page summary of the transcription errors, the one corrected sentence and the duplicated record, followed by the updated tables on 991 observations. |
| `policy_taxation_2014_annotated.do` | The original Stata code that produced the article's tables and the D1 and D2 plots, commands untouched, with comment lines (`// [2026]`) saying which command makes which table or figure. A record, not a runnable script: it reads a file not included here. |

## Running it

Put the files in one folder. R needs base R only. Python needs pandas, numpy, scipy, statsmodels and matplotlib.

- `Rscript replicate.R` writes `tables_corrected.md`, `tables_deduplicated.md` and the six figures, and prints the comparison with the printed tables.
- `python3 replicate.py` writes the same files with a `_py` or `-py` suffix, and prints the same comparison.
- To check the two programs against each other, compare `tables_corrected.md` with `tables_py.md`, and `tables_deduplicated.md` with `tables_deduplicated_py.md`. They are identical.

## What is reproduced, and how closely: the published sample (992 observations)

- **Tables 1, C1, C2, D1.** Every coefficient, standard error, N, R² and adjusted R² matches the printed value to the printed decimals, except the 21 corrected cells. The constant's standard error is an approximation of Stata's and is not compared.
- **Table A1**, the sample's composition by gender, race, education and so on: every group count and share matches.
- **Figure 2** matches the printed figure: the same curves, the same heights.
- **Figure 3** is drawn here with R's and Python's default smoothing. The printed figure is smoother because Stata drew it in 2014 with a wider smoothing bandwidth, and that setting was not recorded.
- **Figure 4** drops the duplicated respondent record, as the 2014 plot did. I found the duplicate while drawing that figure, in 2018, and dropped it there, but the regressions dated from 2014 and I failed to rerun them at the time.
- **Figure 1** charts three percentages from the 2010 General Social Survey, not from this survey. The numbers are in the scripts.
- **Figures D1, D2** match the printed panels. The marginal-effect lines and bands come from the eight regressions the 2014 plot code specifies (ordinary weighted regression without state effects, errors clustered by state). The article does not print those regressions, but the scripts nonetheless write them to `tables_corrected.md`.
- **Figure B1**, the heat maps of control against ideal importance, is not in this article. It appears in the companion article in *Economia Politica* and is reproduced in that article's package.

## What changes without the duplicate (991 observations)

`tables_deduplicated.md` re-estimates Tables 1, C1, C2 and D1 on the 991 distinct observations, with the survey weight raked again on those 991 rows (the 2014 weights were raked with the duplicate present; the replication analysis scripts repeat the 2014 raking, whose method they first confirm by reproducing the shipped weight on all 992 rows). The file ends with a list of every cell whose printed value changes. Across the 422 coefficient and standard-error cells in those tables:

- No coefficient changes sign. Every negative stays negative and every positive stays positive.
- Coefficients move by one or two units in the third decimal place. The largest moves are in Table D1, Y_gov_fix_gap Model 1, where Agency rises from 2.194 to 2.208, and Def. x Agency falls from −2.654 to −2.667. Those two coefficients are the largest in the tables so the moves are small in proportion.
- R² values move by at most 0.0007.
- At the 5% level of statistical significance, nothing changes. Every coefficient with two or three stars keeps at least two, and no coefficient with fewer than two gains a second.
- Four coefficients whose p-values sit on a significance threshold cross it, so their stars change.
  - Definition, the paper's central variable, in Table 1, Y_gov Model 1 drops from three stars to two: significant at the 1% level before (p = 0.0099), at the 5% level now (p = 0.0100).
  - Two controls, Female in Table C1 Model B and Good life in Table C2 Model A, lose their one star: significant at the 10% level before (p = 0.096 and 0.098), not significant at any conventional level now (p = 0.101 and 0.108).
  - One control, Income in Table 1, Y_prog_tax Model 1, gains one star: not significant before (p = 0.102), significant at the 10% level now (p = 0.100).
- Every written claim in the text holds.

The figures are not redrawn because, with one fewer observation, they are indistinguishable from the published figures. The density curves of Figures 2 and 3 move by less than 0.01 and 0.03 on the density axis, where the peaks stand at 1.5 to 6. The marginal-effect lines of Figures D1 and D2 move by less than 0.005 on axes spanning 4 to 9 units, and Figure 4 already excludes the duplicate.

## The data

SocialSci, an online survey panel company, fielded my Economic Justice Survey (version 7) in November 2013. My 2014 cleaning kept 992 respondents, and this file holds all of them. To remove the single duplicate row, please run the corresponding lines of code in provided analysis scripts. Of the survey dataset's 241 columns, the dataset provided here keeps the 27 columns the tables and figures use. The R and Python scripts build the variables the regressions need from them (age squared, the married and unemployed indicators, the four-level tax outcome, the interaction terms), as the 2014 Stata code did.

The 2014 cleaning itself built some of the columns in the file from the raw answers: the four attitude measures that combine a direction with a strength (`gov_reducegap_str`, `agency_str`, `justice_str`, `gov_help_str`), the three deserve scores (`desert_rich_tot`, `desert_americans_tot`, `desert_poor_tot`) and the Definition correlation (`corr_ideal_agency`). I recomputed each from the raw survey items, and each matches on every row. I also re-derived the survey weight (`post_weight`) by raking from the 2014 script's strata and population targets; it matches the shipped weight for every respondent to five decimal places.

The full survey, with the cleaning scripts, questionnaire and codebook, will be deposited separately; its DOI will be added to this record.

A codebook for the relevant subset of data is provided. Additional notes on data:

- `row` is the row number in the full survey file and the only column that identifies a respondent uniquely.
- `id` is the vendor's respondent number, kept for matching to the full survey. Two things make it unreliable as a key:
  - 55 id values are each carried by two different respondents. The vendor's numbering collided within one fielding batch, and the pairs are different people (different ages, genders and states). 
  - One respondent's record is genuinely in the file twice, under ids 1115 and 1157, identical in every answer, so the 992 rows hold 991 people. The duplicate is kept because the published tables were estimated on all 992 rows; dropping it would change every estimate slightly. The one place the 2014 analysis dropped it was Figure 4, and the scripts do the same there. Both scripts also estimate every table a second time on the 991 distinct records, with the weight re-raked, and write the result to `tables_deduplicated.md`: coefficients move in the third decimal, four significance stars sitting on a threshold move by one level, and no sign, finding or sentence of the article changes. 
  - Use `row`, not `id`, to refer to a respondent.
- `corr_ideal_agency` is missing for 29 respondents, so regressions that include it have N = 963 and regressions without it have N = 992.

## The regressions

Every regression in the tables is one Stata command, `areg <outcome> <predictors> [pw=post_weight], absorb(state)`: a linear regression weighted by the survey weight, with a separate intercept for each state (state fixed effects) and standard errors that remain valid when the spread of the errors differs across respondents (heteroskedasticity-robust, the formula known as HC1).

- The outcome is Y_gov_fix_gap (`gov_reducegap_str`) or Y_prog_tax (built from `progtaxes_str`).
- The predictors are Definition (`corr_ideal_agency`), one measure of perceived economic justice, and the same controls throughout. The justice measure is Agency (`agency_str`) in Model 1, Justice (`justice_str`) in Model 2, and the three deserve scores (`desert_rich_tot`, `desert_americans_tot`, `desert_poor_tot`) in Model 3.
- Table C1 drops Definition and enters each justice measure individually. Table C2 adds three controls. Table D1 adds the product of Definition and each justice measure (an interaction).
- The scripts fit the same regressions as weighted least squares with an indicator for each state.

## Two things to know before writing your own version

**Testing decimals for equality.** The 2014 code recodes variables by exact comparison (`if married == .8`, `if progtaxes2_str == 4`). That works in Stata. In R or Python it silently matches no rows, because the stored values are 0.7999… and 3.9999…; the tax outcome is then wrong and every coefficient moves by about 0.03, with no error. Round to the nearest integer first. Both scripts do.

**The interaction terms.** Lines 46–59 of the Stata code build the interaction variables from Definition rescaled to 0 to 1 but store them under the unscaled names. So every interaction term in Table D1 uses the rescaled Definition, and in two of the six D1 regressions (Y_gov Model 1, Y_prog_tax Model 3) the Definition variable itself is also the rescaled one. The fit is identical either way; only the printed coefficients differ, by a factor of two. The scripts reproduce what the article printed. Build the interactions from the unscaled Definition and you will get coefficients half as large and conclude, wrongly, that the table is wrong.

## Citation and license

Cite the article, and this package by the DOI on its record. Released under CC BY 4.0.
