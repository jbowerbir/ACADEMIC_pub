# Replication Data and Code for “Earning Our Place, More or Less: Responsibility’s Flexible Relationship with Desert in Socioeconomic Standing” (Economia Politica, 2021)

Bower-Bir, J. S. (2021). Earning our place, more or less: Responsibility's flexible relationship with desert in socioeconomic standing. *Economia Politica* 38(1): 131–170. https://doi.org/10.1007/s40888-020-00201-9

## 1. About this record

- **Creator.** Jacob S. Bower-Bir, ORCID 0000-0002-4825-9850, jbowerbir@gmail.com.
- **Cite this package as.** Bower-Bir, J. Replication Data and Code for “Earning Our Place, More or Less: Responsibility’s Flexible Relationship with Desert in Socioeconomic Standing” (Economia Politica, 2021) [Data set]. Indiana University - DataCORE. DOI forthcoming.
- **Data coverage.** The survey was fielded between 2013-11-19 and 2014-04-08. The original analysis dates from 2014 and the replication from 2026.
- **Methodology.** Online survey. SocialSci, an online survey panel company, fielded my Economic Justice Survey (version 7) to adult U.S. residents. The 2014 cleaning kept 992 records, which hold 991 respondents. Survey weights were raked to 2012 Census Bureau projections for gender, race, education, and household income and to 2012 Pew Research Center figures for party identification. The article's regressions are survey-weighted least squares with linearized standard errors. For this package I rewrote the analysis in R and in Python. The two produce identical tables, and the R program also reproduces every figure in the article. Re-running the analysis found eight mistyped printed numbers, one figure drawn with its axis reversed, and two 2014 cleaning errors, all described below.
- **Funding.** The survey was funded by the Ostrom Workshop in Political Theory and Policy Analysis (Ostrom Research Grant, 2013–2014) and the Indiana University Social Science Research Commons (Research Grant, 2013–2014).
- **License.** CC BY 4.0.

## 2. Summary

This package replicates every table and figure in the article from the survey data provided. The analysis is written twice, in R and in Python, and the two produce identical output. Each program compares its results with the published tables, cell by cell, and lists every cell that differs.

The article's findings hold. Every regression reproduces from the data, up to the mistyped numbers listed below: all fifteen models in Tables 1 and 4, with their sample sizes and R² values, and every count in Table 2. The re-run found two errors of interpretation and a handful of copying slips:

- **Neoliberals are a smaller share of the sample than the article says.** The neoliberal index, as stored in the data, runs from neoliberal at its low end to anti-neoliberal at its high end. The regressions reverse it correctly, so every Neoliberal coefficient and every sentence interpreting them stands. Figure 7 and one sentence of Section 5, however, read the stored index the wrong way round: They treat its positive side as neoliberal, when it is the anti-neoliberal side. The 60% the article calls neoliberal-leaning are the opposite. The corrected shares: 32.5% lean neoliberal, 7.8% are neutral, 59.7% lean anti-neoliberal. A third of the sample is still a sizeable constituency, so the article's point that neoliberals are a substantial group of dissenters from the responsibility-desert link survives; the group is smaller than stated.
- **The abstract puts respondents from elite schools on the wrong side of a finding.** It lists them among those less insistent that economic standing rest on personal responsibility. Table 1 and Section 4.2.3 say the opposite: the Ivy league coefficient is positive and significant at the 1% level in every model (0.159 as printed in Model 1a, 0.164 on the corrected weights). The conclusion has it right ("un-pedigreed"); only the abstract sentence is wrong, and the corrigendum gives the corrected sentence.
- **Mistyped numbers.** Eight printed numbers differ from the re-run, most of them slips made when typing results into the manuscript. None touches a conclusion:
  - Table 1: two standard errors in Model 1b (Political party printed 0.0073 for 0.073; Female printed 0.023 for 0.027), and one significance star in Model 3b (Income, printed at the 1% level; its p-value is 0.0104, so it is significant at 5%).
  - Table 4: two standard errors off by one in the last digit (Model F, Neoliberal, 0.064 for 0.063; Model E, Constant, 0.035 for 0.036).
  - Figure 3: the correlations for health and state of the economy are swapped (health printed 0.32 for 0.33, state of the economy 0.33 for 0.32).
  - Figure 6: the mean correlation is 0.685, printed as 0.69.

Two further things, found in the 2014 data cleaning rather than in the article. The survey weight's lowest income group ends at $30,000 instead of the intended $25,000, and one respondent's record is in the data twice. The regressions already exclude the duplicate; the article's sample count of 992, in Section 3.1 and Table 2, includes it. The final tables, re-weighted with the $25,000 income line in the right place and counted on the 991 distinct respondents, change no finding, though ideology gains significance in two models; see [Section 6](#6-the-survey-weight).

The correction prepared for the journal is not part of this package. Variable and model names are defined in [Section 8](#8-the-regressions).

To reproduce everything, run `Rscript script_replication.R` (tables and figures) or `python3 script_replication.py` (tables) in this folder.

## 3. Files

Files are named by what they are, then which version, then which program wrote them: `category_item_variant_program.ext`. Underscores separate those fields and hyphens join words inside one field, so a folder sorted by name groups by kind. The tables are in `tables/` and the figures in `figures/`; everything else is in the top folder. Every file the R program writes carries `_R`; the Python program writes the same table files with `_python`, and the pairs are identical. `README.pdf` is this document, typeset for readers who would rather not open a markdown file. On DataCORE, the two folders come as `tables.zip` and `figures.zip`.

### 3.1 Data

| File | What it is |
|---|---|
| `data_survey_ep-subset.csv` | The survey data: 992 records (991 respondents) and 54 columns, two identifiers and the 52 variables the tables and figures use. No value was changed. The full survey is a separate deposit (see [Section 7](#7-the-data)). |
| `data_codebook.md` | The 54 columns: question wording, answer options, coding and rescaling, and the label each has in the article. |

### 3.2 Scripts

| File | What it is |
|---|---|
| `script_replication.R` | The analysis in R: Tables 1, 2, and 4, the numbers in Figures 3 to 7, the weight check, the final tables, and the seven figures. Writes every `_R` file below and the figures, then prints every cell where the printed tables differ. Base R only. |
| `script_replication.py` | The same analysis in Python, without the figures. Writes `tables/tables_typos-fixed_python.md` and `tables/tables_final_python.md`, identical to the R files. |
| `script_original/` | The original code, as a record: the 2014 Stata analysis (`definitions_agency_ORIGINAL.do`, regressions; `factor-correlations_ORIGINAL.do`, the correlations behind Figures 3 to 6; `Appendices_demographics_ORIGINAL.do`, Table 2) and the 2018 R scripts that drew Figures 1 to 5. They read the full survey files, which are not included here. |

### 3.3 Tables

| File | What it is |
|---|---|
| `tables/tables_as-published.md` | Tables 1, 2, and 4 and the numbers printed in Figures 3, 4, and 6, and Section 5, copied cell by cell from the published PDF, stars included. |
| `tables/tables_typos-fixed_R.md`, `tables_typos-fixed_python.md` | Every table and figure statistic as the data give it, the weight check, and the eight cells that differ from the printed article, beside their published values. |
| `tables/tables_final_R.md`, `tables_final_python.md` | Tables 1 and 4 re-estimated with the corrected weight, Table 2 counted on the 991 distinct respondents, a summary of what moves, and every cell that differs from `tables_typos-fixed_R.md`, beside its value there. These are the replacement tables offered to the journal. |

### 3.4 Figures

| File | What it is |
|---|---|
| `figures/figure_1_R.png` … `figure_7_R.png` | The seven figures, redrawn by `script_replication.R` from the survey data (the Python program draws none). Figure 7 is the corrected version, with the neoliberal end of the index on the right. |

## 4. Running it

Keep the layout as delivered, with the scripts and the data in one folder and `tables_as-published.md` in a `tables/` subfolder; from DataCORE, unzip `tables.zip` and `figures.zip` beside the other files. The scripts write to `tables/` and `figures/`, creating them if needed. R needs base R only. Python needs pandas, numpy, and scipy.

- `Rscript script_replication.R` writes `tables/tables_typos-fixed_R.md`, `tables/tables_final_R.md`, and the seven figures, and prints the comparison with the published tables.
- `python3 script_replication.py` writes `tables/tables_typos-fixed_python.md` and `tables/tables_final_python.md` and prints the same comparison.
- To check the two programs against each other, compare `tables/tables_typos-fixed_R.md` with `tables/tables_typos-fixed_python.md`, and `tables/tables_final_R.md` with `tables/tables_final_python.md`. They are identical.

## 5. What is reproduced, and how closely

- **Tables 1 and 4.** Every coefficient, standard error, N, and R² matches the printed value to the printed decimals, except the five regression cells listed in the Summary (the other three differing numbers are figure statistics). The table rows labeled "Adj-R²" hold plain R², which is what Stata's `svy: regress` reports; every printed value matches R² to four decimals.
- **Table 2.** Every count matches.
- **Figures 3 and 4.** All fifteen correlations in each figure match, except the swapped pair in Figure 3. Figure 4 merges the three "un-important" answers into one, leaving "neither important nor unimportant" separate; that is the reading that reproduces all fifteen of its values.
- **Figure 5** places each factor at a distance from the center equal to the mean of its Figure 3 and Figure 4 correlations. Which quadrant a factor sits in is my reading of Figures 1 and 2, as the article says in its footnote 13, not a computed quantity; the script takes the quadrants from the article.
- **Figure 6.** The median (0.74), the quartiles (0.62 and 0.82), the standard deviation (0.22), and the share of respondents between 0.44 and 0.98 (90%) match. The mean is 0.685 (0.68 at two decimals), printed as 0.69.
- **Figure 7.** See the Summary. The corrected figure puts the neoliberal end on the right; the mean of the index sits just on the anti-neoliberal side of the midpoint.
- **Figures 1 and 2** are drawn from the data, unweighted. They print no numbers to compare.
- **Sample.** Every regression and figure uses the 991 distinct respondents (see [Section 7](#7-the-data)). Table 2 describes all 992 records, as the article's does.

## 6. The survey weight

The weight (`post_weight`) was built in 2014 by raking: adjusting each respondent's weight until the sample matches population totals for gender, education, race, household income, and party. Repeating that raking from the 2014 script's groups and targets reproduces the weight in the file for every respondent.

The script's lowest income group, however, takes in incomes up to $29,999, while its target describes households earning less than $25,000: its cut-off sits one income bracket too high. The 54 respondents earning $25,000 to $29,999 were weighted as if they earned less than $25,000. The other income groups, and Table 2's own script, draw their lines correctly.

Both programs re-rake the weight with the line at $25,000 and re-estimate Tables 1 and 4, writing the result to `tables/tables_final_R.md` and `tables/tables_final_python.md` with every cell that changes. Across the 93 coefficients:

- No coefficient that is significant at any level changes sign. Five change sign, all within 0.014 of zero and none significant.
- The largest change in any coefficient is 0.022, which shows as 0.023 between the rounded values (Theology, Table 4 Model B).
- The neoliberal index stays significant at the 1% level in every model, and three of its four statements keep their signs (Profits, in Model 1b, moves from 0.011 to −0.000); Self help rises from the 10% level to the 5% level in all four models that enter it.
- Sixteen significance stars move by one level, eleven up and five down. Income rises a level in Models 1a, 3a, and 3b and in Table 4 Models D and I; Age falls a level in Models 1a and 2a and stays significant, and in Table 4 Model I falls from the 10% level to none.
- Ideology. Section 4.2.1 of the article says that ideology, political affiliation, religious observance, and theological persuasion "have statistically indiscernible influences on the degree to which respondents correlate agency and economic desert." With the corrected weight that sentence needs tempering for ideology: it is significant at the 5% level in Model 1a (printed at 10%), of questionable significance in Model 1b (the 10% level, printed as not significant), and of no discernible significance in Model 2a or on its own in Table 4, Model A. Party, religiosity, and theology stay insignificant throughout.

The published tables use the 2014 weight, and the scripts reproduce them with it. `tables/tables_final_R.md` also counts Table 2 on the 991 distinct respondents: five counts are one lower than the article's, and no percentage changes at two decimals.

## 7. The data

SocialSci, an online survey panel company, fielded my Economic Justice Survey (version 7) between November 2013 and April 2014. My 2014 cleaning kept 992 records, and this file holds all of them. Of the 233 columns in the full survey's analysis file, it keeps the 54 the tables and figures use. The full survey, with the cleaning scripts, questionnaire, and codebook, will be deposited separately; its DOI will be added to this record.

- `row` is the row number in the full survey file and the only column that identifies a respondent uniquely.
- `id` is the vendor's respondent number, kept for matching to the full survey. It is unreliable as a key:
  - 55 id values are each carried by two different respondents, because the vendor's numbering collided within one fielding batch.
  - One respondent's record is in the file twice, under ids 1115 and 1157, identical in every answer, so the 992 records hold 991 respondents. The published regressions and figures leave out the second copy, and the scripts do the same. The 2018 figure code removes it explicitly; the 2014 regression code does not show where it was dropped, but only dropping that record reproduces the published sample sizes and R² values. The article's count of 992 respondents, in Section 3.1 and Table 2, includes the second copy; `tables/tables_final_R.md` gives Table 2 on the 991.
- `corr_ideal_agency`, the dependent variable, is missing for 29 respondents, so Table 1's models have N = 953: the 991 respondents less those 29, less nine who are missing one of the other predictors. Models 1a and 1b also include theology, which only respondents who identify with a religion were asked, and have N = 671.

## 8. The regressions

Every regression in Tables 1 and 4 is one Stata command, `svy: regress corr_ideal_agency <predictors>`, after `svyset [pweight = post_weight]`: a linear regression weighted by the survey weight, with standard errors that remain valid when the spread of the errors differs across respondents. With only a weight declared, Stata's standard error is the robust (HC0) formula multiplied by n/(n−1), tested against a t distribution with n−1 degrees of freedom. The scripts compute exactly that.

- Models 1a to 3a include the neoliberal index; Models 1b to 3b replace it with its four statements. Models 2 and 3 are reduced versions with fewer predictors.
- Table 4 enters the predictors in smaller groups, to show that Table 1's results are not an artifact of correlated predictors.

## 9. Three things to know before writing your own version

Each of these fails silently: you get plausible numbers, not an error.

**The dependent variable is stored rescaled.** The article reports it on its natural −1 to 1 scale, but the file holds it rescaled to 0 to 1. Convert it back (`corr_ideal_agency * 2 - 1`), or every coefficient comes out half the published value with the same t statistics.

**The neoliberal index runs backwards from its name.** The 2014 cleaning reversed the sign of the four statements before averaging them, so a high value of `neoliberal` means anti-neoliberal. The article's Neoliberal rows enter the index with its sign reversed, as do the four statements in Models 1b to 3b. Enter it as stored and the Neoliberal coefficient comes out +0.182 where the article prints −0.182, with the constant still matching. Figure 7's error is this one.

**Testing decimals for equality.** The 2014 code recodes variables by exact comparison or cut-off on the rescaled values (`(income_household * 18) < 7`). That works in Stata. In R or Python the stored values are 0.7999… rather than 0.8, and `income_household * 18` lands on a whole number for only 109 of the 992 records. Round to the nearest whole code first. Both scripts do.

## 10. Citation and license

Cite the article, and this package by the DOI on its record. Released under CC BY 4.0.
