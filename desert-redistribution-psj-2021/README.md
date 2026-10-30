# Replication package

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

## Summary

This package allows users to replicate every table and figure in the article using the provided survey data. In addition to the original Stata script used to analyze the data---included in this package---I translated the analysis into R and Python, and expanded the analysis to compare the tables it produces with the published tables. The R and Python scripts produce identical output, and both reproduce the results the Stata code gave in 2014. I found, however, a few typos in the published tables, none of which alter the paper’s conclusions. Below is a summary of discrepancies between the verified output and the published tables:

- Twenty-two published cells differ from the re-run, all copying errors I made when typing the tables into the manuscript: mostly digits mistyped or transposed, a decimal point in the wrong place, significance stars off by a level (in one case two), plus three dropped minus signs, two sample sizes, and one adjusted R². Four of those are in Table 1, the most visible on Definition, printed positive where the text already states the correct, negative coefficient. Correcting these typos does not contradict the published prose.
- One sentence of the published text misreads a coefficient sign. The coefficient on Age² is so small that it prints as 0.000. The offending sentence in the article calls it positive when it is negative, such that support for government action to reduce the income gap (Y_gov_fix_gap) rises with age into the late thirties and then falls rather than accelerating.

In the course of re-engaging with the data, I also found two errors in my 2014 data cleaning. First, a duplicate row. One respondent’s submission appears twice in the dataset provided by the online survey panel vendor, under two different survey ids. My 2014 cleaning removed all other duplicates in the delivered data but missed this one. Second, a weighting error. My original weighting script put the 54 respondents earning $25,000 to $29,999 per year in the under-$25,000 income group, one bracket off. Every table has been re-estimated on the 991 distinct observations, rather than the original 992, with the weights recomputed with every respondent in the correct income group; I call this the final data below. The tables on the original 992 rows, with only the typos fixed, I call the typos-fixed tables. The figures have also been redrawn from the final data, though they are essentially the same as the published ones. As before, nothing contradicts the published conclusions or the prose. A summary of the changes:

- Coefficients move by a few hundredths of a unit in Table 1, where the largest move is 0.047, on Definition; the largest move anywhere is 0.15, in one Table D1 model. Coefficients for the other key independent variables---Agency, Justice, Rich deserve, Avg. deserve, and Poor deserve---move by 0.016 or less.
- Twenty-eight coefficients whose p-values sit near a significance threshold cross it, so their stars move by one level, twenty-four up and four down; three constants, not counted here, do the same. In Table 1 the key independent variables---Definition, Agency, Justice, Rich deserve, Avg. deserve, and Poor deserve---all keep their signs and their significance. Definition moves from the 1% significance level to the 5% level in one of its three Y_gov_fix_gap models, and Agency from the 5% level to the 1% level in one model. In the appendix tables, Rich deserve and Definition each gain a star in one Table D1 model, and Poor deserve's already marginal effect on Y_prog_tax loses a star in two models. The remaining changes are on control variables.

The dataset here provided includes the 27 columns (two identifiers and 25 survey variables) used to generate the paper’s tables and figures, for all 992 observations as delivered by the panel vendor, with a codebook. The scripts produce both the 992-observation tables (the published analysis with the typos corrected) and the final tables (991 observations, corrected weights). Additional details below.

A correction (journal DOI 10.1111/psj.70145) is included. Again, none of the errors alters the article’s substantive findings or interpretations.

To reproduce everything, run `Rscript script_replication.R` or `python3 script_replication.py` in this folder.

## Files

Files are named by what they are, then which version, then which program wrote them: `category_item_variant_program.ext`. Underscores separate those fields and hyphens join words inside one field, so a folder sorted by name groups into corrigendum, data, figures, scripts, and tables. Every file the R program writes carries `_R`; the Python program writes the same files with `_python`, and the pairs are identical. `README.pdf` is this document, typeset for readers who would rather not open a markdown file.

### Data

| File | What it is |
|---|---|
| `data_survey_psj-subset.csv` | The survey data: 992 respondents and 27 columns, two identifiers and the 25 variables the tables and figures use. No value was changed. The full survey is a separate deposit (see [The data](#the-data)). |
| `data_codebook.md` | The 27 columns: question wording, answer options, coding and rescaling, and the label each has in the article. |

### Scripts

| File | What it is |
|---|---|
| `script_replication.R` | The analysis in R: Tables 1, C1, C2, and D1 (32 regressions), Table A1, and Figures 1, 2, 3, 4, D1, and D2, on the published sample and on the final data. Writes every `_R` file below, then prints every cell where the printed tables differ. Base R only. |
| `script_replication.py` | The same program in Python. Writes the same files with `_python` in place of `_R`, identical to the R output. |
| `script_original_stata-2014.do` | The original Stata code that produced the article's tables and the D1 and D2 plots, commands untouched, with comment lines (`// [2026]`) saying which command makes which table or figure. A record, not a runnable script: it reads a file not included here. |

### Tables

| File | What it is |
|---|---|
| `tables_as-published.md` | The four regression tables as printed in the article, copied cell by cell from the published PDF, stars included. |
| `tables_typos-fixed_R.md`, `tables_typos-fixed_python.md`, `tables_typos-fixed.pdf` | The four regression tables with the typos corrected, on the published 992 rows (duplicate included), plus Table A1 and the eight regressions behind Figures D1 and D2. Ends with the 22 corrected cells beside their published values. The PDF is a typeset reader copy of the R file. |
| `tables_final_R.md`, `tables_final_python.md`, `tables_final.pdf` | The same tables estimated on the 991 distinct records, without the duplicated row and with the survey weight corrected, ending with a list of every cell that changes at the printed precision. These are the replacement tables offered to the journal. The PDF is a typeset reader copy of the R file. |

### Figures

| File | What it is |
|---|---|
| `figure_1_R.png`, `figure_1_python.png` | Figure 1 charts three General Social Survey percentages written into the scripts. It is not derived from this survey and is drawn once by each program. |
| `figure_2_published-sample_R.png` … `figure_D2_published-sample_R.png`, and `_python` | Figures 2, 3, 4, D1, and D2, redrawn by each program from the published sample (992 rows, 2014 weight), not copied from the article. |
| `figure_2_final-data_R.png` … `figure_D2_final-data_R.png`, and `_python` | The same figures drawn from the final data (991 respondents, corrected weights). |

### Corrigendum

| File | What it is |
|---|---|
| `corrigendum_psj.md`, `corrigendum_psj.pdf` | The correction as proposed to the journal: the two kinds of error, the one corrected sentence, and corrected Table 1 (991 observations, corrected weights). It points here for every other table. |

## Running it

Put the files in one folder. R needs base R only. Python needs pandas, numpy, scipy, statsmodels, and matplotlib.

- `Rscript script_replication.R` writes `tables_typos-fixed_R.md`, `tables_final_R.md`, and the figures, and prints the comparison with the printed tables.
- `python3 script_replication.py` writes the same files with `_python` in place of `_R`, and prints the same comparison.
- To check the two programs against each other, compare `tables_typos-fixed_R.md` with `tables_typos-fixed_python.md`, and `tables_final_R.md` with `tables_final_python.md`. They are identical.

## What is reproduced, and how closely: the published sample (992 observations)

- **Tables 1, C1, C2, D1.** Every coefficient, standard error, N, R², and adjusted R² matches the printed value to the printed decimals, except the 22 corrected cells (a cell is a coefficient with its standard error, a sample size, or an R²). The constant's standard error is an approximation of Stata's and is not compared.
- **Table A1**, the sample's composition by gender, race, education, and so on: every group count and share matches.
- **Figure 2** matches the printed figure: the same curves, the same heights.
- **Figure 3** is drawn here with R's and Python's default smoothing. The printed figure is smoother because Stata drew it in 2014 with a wider smoothing bandwidth, and that setting was not recorded.
- **Figure 4** drops the duplicated respondent record, as the published figure did. I found the duplicate while drawing that figure, in 2018, and dropped it there, but the regressions dated from 2014 and I failed to rerun them at the time.
- **Figure 1** charts three percentages from the 2010 General Social Survey, not from this survey. The numbers are in the scripts.
- **Figures D1, D2** match the printed panels. The marginal-effect lines and bands come from the eight regressions the 2014 plot code specifies (ordinary weighted regression without state effects, errors clustered by state). The article does not print those regressions, but the scripts nonetheless write them to `tables_typos-fixed_R.md` and `tables_typos-fixed_python.md`.
- **Figure B1**, the heat maps of Control against Ideal importance, is not in this article. It appears in the companion article, Bower-Bir (2021), *Economia Politica* 38(1): 131–170, https://doi.org/10.1007/s40888-020-00201-9, and is reproduced in that article's replication package.

## What changes with the two data fixes (991 observations, corrected weights)

`tables_final_R.md` and `tables_final_python.md` re-estimate Tables 1, C1, C2, and D1 on the 991 distinct observations, with the survey weights re-raked on those observations and with every respondent in the right income group. The published 2014 weights were originally raked with the duplicate present and with 54 respondents in the wrong income group. The replication scripts repeat the 2014 raking, whose method they first confirm by reproducing the shipped weight on all 992 rows, and then correct the income groups. The file ends with a list of every cell whose printed value changes. Across the 422 coefficients (each with its standard error) in those tables:

- Coefficients move by a few hundredths of a unit.
  - In Table 1 the largest move is on Definition in Y_gov_fix_gap Model 3, from −0.518 to −0.471. Its other two Y_gov_fix_gap coefficients shrink by about 0.03 in magnitude.
  - Agency, Justice, Rich deserve, Avg. deserve, and Poor deserve move by 0.016 or less.
  - The largest moves anywhere, up to 0.15, are on the two Poor deserve terms of Table D1, Y_prog_tax Model 3, whose standard errors are 0.8 to 0.9 and which were not significant before and are not now.
- Twenty-eight coefficients whose p-values sit near a significance threshold cross it, so their stars change: twenty-four increasing in statistical significance and four decreasing; three constants, not counted here, do the same. Six cross the 5% line, five of them gaining in significance.
  - Six of the twenty-eight affected coefficients are on Definition, Agency, Rich deserve, or Poor deserve; the other twenty-two are on control variables, of which seventeen gain or lose significance at the 10% level, and five move between the 10% and 5% levels.
  - Definition, in Table 1, Y_gov_fix_gap Model 1, drops from the 1% significance level to the 5% level (p = 0.0099 to 0.012) and stays at 1% in the other two Y_gov_fix_gap models. In Table D1, Y_gov_fix_gap Model 1, its main effect (as opposed to its interaction effect) gains a star (p = 0.108 to 0.062).
  - Agency, in Table 1, Y_prog_tax Model 1, rises from the 5% significance level to the 1% level (p = 0.0119 to 0.0100).
  - Rich deserve, in Table D1, Y_gov_fix_gap Model 3, rises from the 5% significance level to the 1% level (p = 0.015 to 0.008).
  - Poor deserve on Y_prog_tax, the one effect the article already calls statistically questionable, loses a star in two appendix models. In Table C1 Model E, it moves from the 10% significance level to none (p = 0.096 to 0.108), and in Table C2 Model E, it moves from 5% to 10% (p = 0.041 to 0.050). In Table 1 it keeps its one star.
- R² values move by at most 0.009, and adjusted R² by at most 0.010.
- Every written claim in the text holds.

The figures are redrawn from the final data as `figure_*_final-data_R.png` and `figure_*_final-data_python.png` and are essentially the same as the published ones. The density curves of Figures 2 and 3 are unweighted, so only the duplicate observation affects them. They move by less than 0.01 and 0.03 on the density axis, where the peaks stand at 1.5 to 6. The marginal-effect lines of Figures D1 and D2 move by at most 0.10 on axes spanning 4 to 9 units, well inside their confidence bands. Figure 4 already excludes the duplicate, and Figure 1 is not from this survey.

## The data

SocialSci, an online survey panel company, fielded my Economic Justice Survey (version 7) between November 2013 and April 2014. My 2014 cleaning kept 992 respondents, and this file holds all of them. The duplicate observation is removed in section 1 of either script. Of the survey dataset's 241 columns, the dataset provided here keeps the 27 columns the tables and figures use. The R and Python scripts build the variables the regressions need from them (age squared, the married and unemployed indicators, the four-level tax outcome, and the interaction terms), as the 2014 Stata code did.

The 2014 cleaning script built some of the columns in the file from the raw answers: the four attitude measures that combine a direction with a strength (`gov_reducegap_str`, `agency_str`, `justice_str`, `gov_help_str`), the three Deserve scores (`desert_rich_tot`, `desert_americans_tot`, `desert_poor_tot`), and the Definition correlation (`corr_ideal_agency`). I recomputed each from the raw survey items, and each matches on every row. I also recomputed the survey weight (`post_weight`) using the 2014 script's method and population targets. It matches the published weight for every respondent to four decimal places (the largest difference is 0.000014). That re-derivation is how the weighting error came to light. The original script's lowest income group, meant for households earning under $25,000, also took in those earning $25,000 to $29,999. That is the only income group affected. Table A1's income counts come from a different script and were correct as published.

The full survey, with the cleaning scripts, questionnaire, and codebook, will be deposited separately; its DOI will be added to this record.

A codebook for the relevant subset of data is provided. Additional notes on data:

- `row` is the row number in the full survey file and the only column that identifies a respondent uniquely.
- `id` is the vendor's respondent number, kept for matching to the full survey. Two things make it unreliable as a key:
  - 55 id values are each carried by two different respondents. The vendor's numbering collided within one fielding batch, and the pairs are different people (different ages, genders, and states). 
  - One respondent's record is genuinely in the file twice, under ids 1115 and 1157, identical in every answer, so the 992 rows hold 991 people. The duplicate is kept because the published tables were estimated on all 992 rows; dropping it would change every estimate slightly. The one place the published analysis dropped it was Figure 4 (redrawn in 2018), and the scripts do the same there. Both scripts also estimate every table a second time on the 991 distinct records, with the weight corrected; see [What changes with the two data fixes](#what-changes-with-the-two-data-fixes-991-observations-corrected-weights) and `tables_final_R.md`.
  - Use `row`, not `id`, to refer to a respondent.
- `corr_ideal_agency` is missing for 29 respondents, so regressions that include it have N = 963 and regressions without it have N = 992 (or 962 and 991, respectively, in the final data).

## The regressions

Every regression in the tables is one Stata command, `areg <outcome> <predictors> [pw=post_weight], absorb(state)`: a linear regression weighted by the survey weight, with a separate intercept for each state (state fixed effects) and standard errors that remain valid when the spread of the errors differs across respondents (heteroskedasticity-robust, the formula known as HC1).

- The outcome is Y_gov_fix_gap (`gov_reducegap_str`) or Y_prog_tax (built from `progtaxes_str`).
- The predictors are Definition (`corr_ideal_agency`), one measure of perceived economic justice, and the same controls throughout. The justice measure is Agency (`agency_str`) in Model 1, Justice (`justice_str`) in Model 2, and the three deserve scores (`desert_rich_tot`, `desert_americans_tot`, `desert_poor_tot`) in Model 3.
- Table C1 drops Definition and enters each justice measure individually. Table C2 adds three controls. Table D1 adds the product of Definition and each justice measure (an interaction).
- The scripts fit the same regressions as weighted least squares with an indicator for each state.

## Two things to know before writing your own version

**Testing decimals for equality.** The 2014 code recodes variables by exact comparison (`if married == .8`, `if progtaxes2_str == 4`). That works in Stata. In R or Python it silently matches no rows, because the stored values are 0.7999… and 3.9999…; the tax outcome is then wrong and every coefficient moves by about 0.03, with no error. Round to the nearest integer first. Both scripts do.

**The interaction terms.** Lines 93–106 of `script_original_stata-2014.do` (lines 46–59 before the 2026 annotations were added) build the interaction variables from Definition rescaled to 0 to 1 but store them under the unscaled names. So every interaction term in Table D1 uses the rescaled Definition, and in two of the six D1 regressions (Y_gov_fix_gap Model 1, Y_prog_tax Model 3) the Definition variable itself is also the rescaled one. The fit is identical either way; only the printed coefficients differ, by a factor of two. The scripts reproduce what the article printed. To match the table, build the interactions from Definition rescaled to 0 to 1, as the scripts do. Build them from the unscaled Definition and you will get coefficients half as large and conclude, wrongly, that the table is wrong.

Each of these fails silently: you get plausible numbers, not an error.

## Citation and license

Cite the article, and this package by the DOI on its record. Released under CC BY 4.0.
