# Replication Data and Code for “Desert and Redistribution: Justice as a Remedy for, and Cause of, Economic Inequality” (Policy Studies Journal, 2022)

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

## 1. About this record

- **Creator.** Jacob S. Bower-Bir, ORCID 0000-0002-4825-9850, jbowerbir@gmail.com.
- **Cite this package as.** Bower-Bir, J. Replication Data and Code for “Desert and Redistribution: Justice as a Remedy for, and Cause of, Economic Inequality” (Policy Studies Journal, 2022) [Data set]. Indiana University - DataCORE. DOI forthcoming.
- **Data coverage.** The survey was fielded between 2013-11-19 and 2014-04-08. The original analysis dates from 2014 and the replication from 2026.
- **Methodology.** Online survey. SocialSci, an online survey panel company, fielded my Economic Justice Survey (version 7) to adult U.S. residents. The 2014 cleaning kept 992 responses. Survey weights were raked to 2012 Census Bureau projections for gender, race, education, and household income and to 2012 Pew Research Center figures for party identification. The article's regressions are weighted least squares with a fixed effect for each state and heteroskedasticity-robust standard errors. For this package I rewrote the analysis in R and in Python. The two produce identical tables and reproduce every table and figure in the article. Re-running the analysis found 22 transcription errors in the published tables, two 2014 cleaning errors, and two figures drawn on mixed scales, all described below.
- **Funding.** The survey was funded by the Ostrom Workshop in Political Theory and Policy Analysis (Ostrom Research Grant, 2013–2014) and the Indiana University Social Science Research Commons (Research Grant, 2013–2014).
- **License.** CC BY 4.0.

## 2. Summary

This package allows users to replicate every table and figure in the article using the provided survey data (Figure B1 excepted; see [Section 5](#5-what-is-reproduced-and-how-closely-the-published-sample-992-observations)). In addition to the original Stata script used to analyze the data---included in this package---I translated the analysis into R and Python, and expanded the analysis to compare the tables it produces with the published tables. The R and Python scripts produce identical tables, and both reproduce the results the Stata code gave in 2014. I found, however, a few typos in the published tables and a small error in the appendix figures, none of which alter the paper’s conclusions. Below is a summary of discrepancies between the verified output and the published article:

- Twenty-two published cells differ from the re-run, all copying errors I made when typing the tables into the manuscript: mostly digits mistyped or transposed, a decimal point in the wrong place, significance stars off by a level (in one case two), plus three dropped minus signs, two sample sizes, and one adjusted R². Four of those are in Table 1, the most visible on the Definition variable, printed as positive when it is negative, as the article's prose correctly states. Correcting these typos does not contradict the published prose.
- Two sentences of the published text misread the coefficient on Age². It is so small that it prints as 0.000. The article calls it positive when it is negative, such that support for government action to reduce the income gap (Y_gov_fix_gap) rises with age up to about age 34 and then falls, rather than accelerating. That turning point comes from Y_gov_fix_gap Model 1 in Table 1, the one Table 1 model where Age² is significant.
- Figures D1 and D2 in Appendix D mix two scalings of the definition variable. The package draws them correctly, and the main text's assessment of the interaction is unaffected.

While re-running the analysis, I also found two errors in my 2014 data cleaning. First, a duplicate row. One respondent’s submission appears twice in the dataset provided by the online survey panel vendor, under two different survey ids. My 2014 cleaning removed every other duplicated submission in the delivered data but missed this one. Second, a weighting error. My original weighting script put the 54 respondents earning $25,000 to $29,999 per year in the under-$25,000 income group, one bracket off. Every table has been re-estimated on the 991 distinct observations, rather than the original 992, with the weights recomputed with every respondent in the correct income group; I call this the “final data” below. The tables on the original 992 rows (the published sample), with only the typos fixed, I call the “typos-fixed” tables. The figures have also been redrawn from the final data, and they change little from the published-sample versions. As before, nothing contradicts the published conclusions or the main text. A summary of the changes, with the details in [Section 6](#6-what-changes-with-the-two-data-fixes-991-observations-corrected-weights):

- Coefficients move by a few hundredths of a unit (every variable save age runs from 0 to 1). In Table 1 the largest move is 0.047, on Definition; the largest move anywhere is 0.15, in one Table D1 model. In Table 1, coefficients for the other key independent variables---Agency, Justice, Rich deserve, Avg. deserve, and Poor deserve---move by 0.016 or less.
- Twenty-eight coefficients whose p-values sit near a significance threshold cross it, twenty-four gaining a star and four losing one. In Table 1 the key independent variables---Definition, Agency, Justice, Rich deserve, Avg. deserve, and Poor deserve---all keep their signs and their significance. 

The dataset provided in this package includes the 27 columns (two identifiers and 25 survey variables) used to generate the paper’s tables and figures, for all 992 observations as delivered by the panel vendor, with a codebook. The scripts produce both the 992-observation tables (the published analysis with the typos corrected) and the final tables (991 observations, corrected weights). Additional details below.

The correction, `corrigendum_psj.md` (journal DOI 10.1111/psj.70145), is included. None of the errors alters the main text’s findings or interpretations. Variable and model names are defined in [Section 8](#8-the-regressions).

To reproduce everything, run `Rscript script_replication.R` or `python3 script_replication.py` in this folder.

## 3. Files

Files are named by what they are, then which version, then which program wrote them: `category_item_variant_program.ext`. Underscores separate those fields and hyphens join words inside one field, so a folder sorted by name groups by kind. The tables are in `tables/` and the figures in `figures/`; everything else is in the top folder. Every file the R program writes carries `_R`, and the Python program writes the same files with `_python`. The table pairs are identical. The figure pairs plot the same values, each in its program's own style. `README.pdf` is this document, typeset for readers who would rather not open a markdown file. On DataCORE, the two folders come as `tables.zip` and `figures.zip`.

### 3.1 Data

| File | What it is |
|---|---|
| `data_survey_psj-subset.csv` | The survey data: 992 records (991 respondents) and 27 columns, two identifiers and the 25 variables the tables and figures use. No value was changed. The full survey is a separate deposit (see [Section 7](#7-the-data)). |
| `data_codebook.md` | The 27 columns: question wording, answer options, coding and rescaling, and the label each has in the article. |

### 3.2 Scripts

| File | What it is |
|---|---|
| `script_replication.R` | The analysis in R: Tables 1, C1, C2, and D1 (32 regressions), Table A1, and Figures 1, 2, 3, 4, D1, and D2, on the published sample and on the final data. Writes every `_R` file below, then prints every cell where the printed tables differ. Base R only. |
| `script_replication.py` | The same program in Python. Writes the same files with `_python` in place of `_R`, with tables identical to the R output. |
| `script_original_stata-2014.do` | The original Stata code that produced the article's tables and the D1 and D2 plots, commands untouched apart from the directory paths stripped from the log and use lines, with comment lines (`// [2026]`) saying which command makes which table or figure. A record, not a runnable script: it reads a file not included here. |

### 3.3 Tables

| File | What it is |
|---|---|
| `tables/tables_as-published.md` | The four regression tables as printed in the article, copied cell by cell from the published PDF, stars included. |
| `tables/tables_typos-fixed_R.md`, `tables_typos-fixed_python.md`, `tables_typos-fixed.pdf` | The four regression tables with the typos corrected, on the published 992 rows (duplicate included), plus Table A1 and the marginal effects plotted in Figures D1 and D2. Ends with the 22 corrected cells beside their published values. The PDF is a typeset reader copy of the R file. |
| `tables/tables_final_R.md`, `tables_final_python.md`, `tables_final.pdf` | The same tables estimated on the 991 distinct records, without the duplicated row and with the survey weight corrected, ending with a list of every cell that changes at the printed precision. These are the replacement tables offered to the journal. The PDF is a typeset reader copy of the R file. |

### 3.4 Figures

| File | What it is |
|---|---|
| `figures/figure_1_R.png`, `figure_1_python.png` | Figure 1 charts three percentages from other surveys, written into the scripts. It is not derived from this survey and is drawn once by each program. |
| `figures/figure_2_published-sample_R.png` … `figure_D2_published-sample_R.png`, and `_python` | Figures 2, 3, 4, D1, and D2, redrawn by each program from the published sample (992 rows, 2014 weight), not copied from the article. |
| `figures/figure_2_final-data_R.png` … `figure_D2_final-data_R.png`, and `_python` | The same figures drawn from the final data (991 respondents, corrected weights). |

### 3.5 Corrigendum

| File | What it is |
|---|---|
| `corrigendum_psj.md`, `corrigendum_psj.pdf` | The correction as proposed to the journal: the two kinds of error, the two corrected sentences on Age², a note on Figures D1 and D2, and corrected Table 1 (991 observations, corrected weights). It refers to this package for every other table. |

## 4. Running it

Keep the layout as delivered, with the scripts and the data in one folder and `tables_as-published.md` in a `tables/` subfolder; from DataCORE, unzip `tables.zip` and `figures.zip` beside the other files. The scripts write to `tables/` and `figures/`, creating them if needed. R needs base R only. Python needs pandas, numpy, scipy, statsmodels, and matplotlib.

- `Rscript script_replication.R` writes `tables/tables_typos-fixed_R.md`, `tables/tables_final_R.md`, and the figures, and prints the comparison with the printed tables.
- `python3 script_replication.py` writes the same files with `_python` in place of `_R`, and prints the same comparison.
- To check the two programs against each other, compare `tables/tables_typos-fixed_R.md` with `tables/tables_typos-fixed_python.md`, and `tables/tables_final_R.md` with `tables/tables_final_python.md`. They are identical.

## 5. What is reproduced, and how closely: the published sample (992 observations)

- **Tables 1, C1, C2, D1.** Every coefficient, standard error, N, R², and adjusted R² matches the printed value to the printed decimals, except the 22 corrected cells (a cell is a coefficient with its standard error, a sample size, or an R²). The constant's standard error is an approximation of Stata's and is not compared.
- **Table A1**, the sample's composition by gender, race, education, and so on: every group count and share matches.
- **Figure 1** charts three percentages from other surveys, not from this one. As the article's caption says, two come from the 2010 General Social Survey (n = 1,512) and one from a Gallup poll of 2011-11-28 to 2011-12-01 (n = 1,012). The numbers are in the scripts.
- **Figures 2 and 3** match the printed figures. The printed curves are a little more smoothed, and the 2014 smoothing setting was not recorded.
- **Figure 4** drops the duplicated respondent record, as the published figure did. I found the duplicate while drawing that figure, in 2018, and dropped it there, but the regressions dated from 2014 and I failed to rerun them at the time.
- **Figures D1 and D2** are drawn correctly here, so they differ from the printed panels. The printed figures mix two scalings of the definition variable. Their regressions entered Definition as it stands in the file but built the interaction terms from (Definition + 1) / 2, and the lines were drawn as if the two were one. The scripts draw each panel from the Table D1 model the appendix names, with Definition on one scale and, in D1(c), the other two deserve scores at their means rather than zero. Both table files list each line's endpoints. Drawn consistently, the lines in Figure D1 are at most about half as steep as in print, so faith in economic justice moderates the definition's effect less than the printed figure shows. In Figure D2, faith in economic justice reduces support for redistribution for nearly all respondents, and the positive effect at low values of the definition applies to almost none. The main text's assessment of the interaction stands.
- **Figure B1**, the heat maps in Appendix B, needs the 30 factor ratings this file leaves out. The companion package for Bower-Bir (2021), *Economia Politica* 38(1): 131–170, reproduces them as its Figure 3 from the same survey (IU DataCORE, DOI forthcoming, and https://github.com/jbowerbir/ACADEMIC_pub/tree/main/earning-our-place-ecopol-2020). Table B1 uses no data.

## 6. What changes with the two data fixes (991 observations, corrected weights)

`tables/tables_final_R.md` and `tables/tables_final_python.md` re-estimate Tables 1, C1, C2, and D1 on the 991 distinct observations, with the survey weights re-raked on those observations and with every respondent in the right income group. The published 2014 weights were originally raked with the duplicate present and with 54 respondents in the wrong income group. The replication scripts repeat the 2014 raking, whose method they first confirm by reproducing the shipped weight on all 992 rows, and then correct the income groups. The file ends with a list of every cell whose printed value changes. Across the 422 coefficients (each with its standard error) in those tables:

- Coefficients move by a few hundredths of a unit.
  - In Table 1 the largest move among the predictors is on Definition in Y_gov_fix_gap Model 3, from −0.518 to −0.471. Its other two Y_gov_fix_gap coefficients shrink by about 0.03 in magnitude.
  - Agency, Justice, Rich deserve, Avg. deserve, and Poor deserve move by 0.016 or less.
  - The largest moves anywhere, up to 0.15, are on the two Poor deserve terms of Table D1, Y_prog_tax Model 3, whose standard errors are 0.8 to 0.9 and which were not significant before and are not now.
- Twenty-eight coefficients whose p-values sit near a significance threshold cross it, so their stars change: twenty-four increasing in statistical significance and four decreasing; three constants, not counted here, do the same. Six of the twenty-eight are on the key independent variables and the rest on controls.
  - Definition, in Table 1, Y_gov_fix_gap Model 1, drops from the 1% significance level to the 5% level (p = 0.0099 to 0.012) and stays at 1% in the other two Y_gov_fix_gap models. In Table D1, Y_gov_fix_gap Model 1, its main effect (as opposed to its interaction effect) gains a star (p = 0.108 to 0.062).
  - Agency, in Table 1, Y_prog_tax Model 1, rises from the 5% significance level to the 1% level (p = 0.0119 to 0.00998).
  - Rich deserve, in Table D1, Y_gov_fix_gap Model 3, rises from the 5% significance level to the 1% level (p = 0.015 to 0.008).
  - Poor deserve on Y_prog_tax, the one effect the article already calls statistically questionable, loses a star in two appendix models. In Table C1 Model E, it moves from the 10% significance level to none (p = 0.096 to 0.108), and in Table C2 Model E, it moves from 5% to 10% (p = 0.041 to 0.0500). In Table 1 it keeps its one star.
- R² values move by at most 0.009, and adjusted R² by at most 0.010.
- Every claim in the main text holds. In Appendix D, Definition's main effect in Table D1's Y_gov_fix_gap Model 1 reaches the 10% level on the final data, where the appendix calls it not significant, and the remarks on Figures D1 and D2 change as described in [Section 5](#5-what-is-reproduced-and-how-closely-the-published-sample-992-observations).

The figures redrawn from the final data (`figures/figure_*_final-data_R.png` and `_python.png`) change little. The density curves of Figures 2 and 3 move by less than 0.02 on peaks of 1.5 to 3. The marginal-effect lines of Figures D1 and D2 move by at most 0.04, well inside their confidence bands. Figure 4 already excludes the duplicate, and Figure 1 is not from this survey.

## 7. The data

SocialSci, an online survey panel company, fielded my Economic Justice Survey (version 7) between November 2013 and April 2014. My 2014 cleaning kept 992 records, and this file holds all of them. The first section of either script finds the duplicate observation, and the final tables are estimated without it. Of the 233 columns in the full survey's analysis file, the dataset provided here keeps the 27 columns the tables and figures use. The R and Python scripts build the variables the regressions need from them (age squared, the married and unemployed indicators, the four-level tax outcome, and the interaction terms), as the 2014 Stata code did.

The 2014 cleaning built some of the columns in the file from the raw answers: the four attitude measures that combine a direction with a strength (`gov_reducegap_str`, `agency_str`, `justice_str`, `gov_help_str`), the three Deserve scores (`desert_rich_tot`, `desert_americans_tot`, `desert_poor_tot`), and the Definition correlation (`corr_ideal_agency`, computed in a separate step before the Stata code ran). I recomputed each from the raw survey items, and each matches on every row. I also recomputed the survey weight (`post_weight`) using the 2014 script's method and population targets. It matches the published weight for every respondent to four decimal places (the largest difference is 0.000014). That re-derivation is how the weighting error came to light. The original script's lowest income group, meant for households earning under $25,000, also took in those earning $25,000 to $29,999. That is the only income group affected. Table A1's income counts come from a different script and were correct as published.

The full survey, with the cleaning scripts, questionnaire, and codebook, will be deposited separately; its DOI will be added to this record.

A codebook for the relevant subset of data is provided. Additional notes on data:

- `row` is the row number in the full survey file and the only column that identifies a respondent uniquely.
- `id` is the vendor's respondent number, kept for matching to the full survey. Use `row`, not `id`, to refer to a respondent. Two things make `id` unreliable as a key:
  - 55 id values are each carried by two different respondents. The vendor's numbering collided within one fielding batch, and the pairs are different people.
  - One respondent's record is genuinely in the file twice, under ids 1115 and 1157, identical in every answer, so the 992 rows hold 991 people. The duplicate is kept because the published tables were estimated on all 992 rows; dropping it would change every estimate slightly. The one place the published analysis dropped it was Figure 4 (redrawn in 2018), and the scripts do the same there. Both scripts also estimate every table a second time on the 991 distinct records, with the weight corrected. See [Section 6](#6-what-changes-with-the-two-data-fixes-991-observations-corrected-weights) and `tables/tables_final_R.md`.
- `corr_ideal_agency` is missing for 29 respondents, so regressions that include it have N = 963 and regressions without it have N = 992 (or 962 and 991, respectively, in the final data).

## 8. The regressions

Every regression in the tables is one Stata command, `areg <outcome> <predictors> [pw=post_weight], absorb(state)`: a linear regression weighted by the survey weight, with a separate intercept for each state (state fixed effects) and standard errors that remain valid when the spread of the errors differs across respondents (heteroskedasticity-robust, the formula known as HC1).

- The outcome is Y_gov_fix_gap (`gov_reducegap_str`) or Y_prog_tax (built from `progtaxes_str`).
- The predictors are Definition (`corr_ideal_agency`), one measure of perceived economic justice, and the same controls throughout. The justice measure is Agency (`agency_str`) in Model 1, Justice (`justice_str`) in Model 2, and the three deserve scores (`desert_rich_tot`, `desert_americans_tot`, `desert_poor_tot`) in Model 3.
- Table C1 drops Definition and enters each justice measure individually. Table C2 adds three controls. Table D1 adds the product of Definition and each justice measure (an interaction).
- The scripts fit the same regressions as weighted least squares with an indicator for each state.

## 9. Two things to know before writing your own version

**Testing decimals for equality.** The 2014 code recodes variables by exact comparison (`if progtaxes2_str == 4`). That works in Stata. In R or Python the test silently matches no rows, because the rescaled values come out a hair off (4.0000000002, not 4). The tax outcome is then wrong and every coefficient in the tax models moves, with no error. Round to the nearest integer first. Both scripts do.

**The interaction terms.** Lines 96–109 of `script_original_stata-2014.do` (lines 46–59 before the 2026 annotations were added) build the interaction variables from (Definition + 1) / 2, a second rescaling of a column already on 0 to 1, but store them under the unscaled names. So every interaction term in Table D1 uses this rescaled Definition, and in two of the six D1 regressions (Y_gov_fix_gap Model 1, Y_prog_tax Model 3) the Definition variable itself is also the rescaled one. The fit is identical either way; only the printed coefficients differ. The scripts reproduce what the article printed. Build the interactions from Definition as it stands in the file and you will get different coefficients and conclude, wrongly, that the table is wrong.

Each of these fails silently: you get plausible numbers, not an error.

## 10. Citation and license

Cite the article, and this package by the DOI on its record. Released under CC BY 4.0.
