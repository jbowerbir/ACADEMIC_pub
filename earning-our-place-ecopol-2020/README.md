# Replication package

Bower-Bir, J. S. (2021). Earning our place, more or less: Responsibility's flexible relationship with desert in socioeconomic standing. *Economia Politica* 38(1): 131–170. https://doi.org/10.1007/s40888-020-00201-9

## Summary

This package replicates every table and figure in the article from the survey data provided. The analysis is written twice, in R and in Python, and the two produce identical output. Each program compares its results with the published tables, cell by cell, and lists every cell that differs.

The article's findings hold. Every regression reproduces: all fifteen models in Tables 1 and 4, with their sample sizes and R² values, and every count in Table 2. The re-run found one error of interpretation and a handful of copying slips:

- **Neoliberals are a smaller share of the population than the article says.** The neoliberal index, as stored in the data, runs from neoliberal at its low end to anti-neoliberal at its high end. The regressions reverse it correctly, so every Neoliberal coefficient and every sentence interpreting them stands. Figure 7 and one sentence of Section 5, however, read the stored index the wrong way round: They treat its positive side as neoliberal, when it is the anti-neoliberal side. The 60% the article calls neoliberal-leaning are the opposite. The corrected shares: 32.5% lean neoliberal, 7.8% are neutral, 59.7% lean anti-neoliberal. A third of the sample is still a sizeable constituency, so the article's point that neoliberals are a substantial group of dissenters from the responsibility-desert link survives; the group is smaller than stated.
- **Copying slips.** Eight printed numbers differ from the re-run, most of them slips made when typing results into the manuscript. None touches a conclusion:
  - Table 1: two standard errors in Model 1b (Political party printed 0.0073 for 0.073; Female printed 0.023 for 0.027), and one significance star in Model 3b (Income, printed at the 1% level; its p-value is 0.0104, so it is significant at 5%).
  - Table 4: two standard errors off by one in the last digit (Model F, Neoliberal, 0.064 for 0.063; Model E, Constant, 0.035 for 0.036).
  - Figure 3: the correlations for health and state of the economy are swapped (0.32 and 0.33 for 0.33 and 0.32).
  - Figure 6: the mean correlation is 0.685, printed as 0.69.

Two further things, found in the 2014 data cleaning rather than in the article. The survey weight's lowest income group ends at $30,000 instead of the intended $25,000, and one respondent's record is in the data twice. The regressions already exclude the duplicate; the article's sample count of 992, in Section 3.1 and Table 2, includes it. The final tables, re-weighted with the $25,000 income line in the right place and counted on the 991 distinct respondents, change no finding; see [The survey weight](#the-survey-weight).

To reproduce everything, run `Rscript script_replication.R` (tables and figures) or `python3 script_replication.py` (tables) in this folder.

## Files

Files are named by what they are, then which version, then which program wrote them: `category_item_variant_program.ext`. Underscores separate those fields and hyphens join words inside one field, so a folder sorted by name groups into data, figures, scripts, and tables. Every file the R program writes carries `_R`; the Python program writes the same files with `_python`, and the pairs are identical. `README.pdf` is this document, typeset for readers who would rather not open a markdown file.

### Data

| File | What it is |
|---|---|
| `data_survey_ep-subset.csv` | The survey data: 992 respondents and the 54 variables the tables and figures use. No value was changed. The full survey is a separate deposit (see [The data](#the-data)). |
| `data_codebook.md` | The 54 columns: question wording, answer options, coding and rescaling, and the label each has in the article. |

### Scripts

| File | What it is |
|---|---|
| `script_replication.R` | The analysis in R: Tables 1, 2, and 4, the numbers in Figures 3 to 7, the weight check, the final tables, and the seven figures. Writes every `_R` file below and the figures, then prints every cell where the printed tables differ. Base R only. |
| `script_replication.py` | The same analysis in Python, without the figures. Writes `tables_typos-fixed_python.md` and `tables_final_python.md`, identical to the R files. |
| `script_original/` | The original code, as a record: the 2014 Stata analysis (`definitions_agency_ORIGINAL.do`, regressions; `factor-correlations_ORIGINAL.do`, the correlations behind Figures 3 to 6; `Appendices_demographics_ORIGINAL.do`, Table 2) and the 2018 R scripts that drew Figures 1 to 5. They read the full survey files, which are not included here. |

### Tables

| File | What it is |
|---|---|
| `tables_as-published.md` | Tables 1, 2, and 4 and the numbers printed in Figures 3, 4, and 6, and Section 5, copied cell by cell from the published PDF, stars included. |
| `tables_typos-fixed_R.md`, `tables_typos-fixed_python.md` | Every table and figure statistic as the data give it, the weight check, and the eight cells that differ from the printed article, beside their published values. |
| `tables_final_R.md`, `tables_final_python.md` | Tables 1 and 4 re-estimated with the corrected weight, Table 2 counted on the 991 distinct respondents, a summary of what moves, and every cell that differs from `tables_typos-fixed_R.md`, beside its value there. These are the replacement tables offered to the journal. |

### Figures

| File | What it is |
|---|---|
| `figure_1_R.png` … `figure_7_R.png` | The seven figures, redrawn by `script_replication.R` from the survey data (the Python program draws none). Figure 7 is the corrected version, with the neoliberal end of the index on the right. |

## Running it

Put the files in one folder. R needs base R only. Python needs pandas, numpy, and scipy.

- `Rscript script_replication.R` writes `tables_typos-fixed_R.md`, `tables_final_R.md`, and the seven figures, and prints the comparison with the published tables.
- `python3 script_replication.py` writes `tables_typos-fixed_python.md` and `tables_final_python.md` and prints the same comparison.
- To check the two programs against each other, compare `tables_typos-fixed_R.md` with `tables_typos-fixed_python.md`, and `tables_final_R.md` with `tables_final_python.md`. They are identical.

## What is reproduced, and how closely

- **Tables 1 and 4.** Every coefficient, standard error, N, and R² matches the printed value to the printed decimals, except the five regression cells listed in the Summary (the other three differing numbers are figure statistics). The table rows labeled "Adj-R²" hold plain R², which is what Stata's `svy: regress` reports; every printed value matches R² to four decimals.
- **Table 2.** Every count matches.
- **Figures 3 and 4.** All fifteen correlations in each figure match, except the swapped pair in Figure 3. Figure 4 merges the three "un-important" answers into one, leaving "neither important nor unimportant" separate; that is the reading that reproduces all fifteen of its values.
- **Figure 5** places each factor at a distance from the center equal to the mean of its Figure 3 and Figure 4 correlations. Which quadrant a factor sits in is the author's reading of Figures 1 and 2, as the article says in its footnote 13, not a computed quantity; the script takes the quadrants from the article.
- **Figure 6.** The median (0.74), the quartiles (0.62 and 0.82), the standard deviation (0.22), and the share of respondents between 0.44 and 0.98 (90%) match. The mean is 0.685 (0.68 at two decimals), printed as 0.69.
- **Figure 7.** See the Summary. The corrected figure puts the neoliberal end on the right; the mean of the index sits just on the anti-neoliberal side of the midpoint.
- **Figures 1 and 2** are drawn from the data, unweighted. They print no numbers to compare.
- **Sample.** Every regression and figure uses the 991 distinct respondents (see [The data](#the-data)). Table 2 describes all 992 rows, as the article's does.

## The survey weight

The weight (`post_weight`) was built in 2014 by raking: adjusting each respondent's weight until the sample matches population totals for gender, education, race, household income, and party. Repeating that raking from the 2014 script's groups and targets reproduces the weight in the file for every respondent.

The script's lowest income group, however, takes in incomes up to $29,999, while its target describes households earning less than $25,000: its cut-off sits one income bracket too high. The 54 respondents earning $25,000 to $29,999 were weighted as if they earned less than $25,000. The other income groups, and Table 2's own script, draw their lines correctly.

Both programs re-rake the weight with the line at $25,000 and re-estimate Tables 1 and 4, writing the result to `tables_final_R.md` and `tables_final_python.md` with every cell that changes. Across the 93 coefficients:

- No coefficient that is significant at any level changes sign. Five change sign, all within 0.014 of zero and none significant.
- The largest change in any coefficient is 0.022 (0.023 at the printed precision, Theology in Table 4 Model B).
- The neoliberal index stays significant at the 1% level in every model, and three of its four statements keep their signs (Profits, in Model 1b, moves from 0.011 to −0.000); Self help rises from the 10% level to the 5% level in all three models that enter it.
- Sixteen significance stars move by one level, eleven up and five down. Income rises a level in Models 1a, 3a, and 3b and in Table 4 Models D and I; Age falls a level in Models 1a and 2a and stays significant, and in Table 4 Model I falls from the 10% level to none.
- Ideology becomes significant at the 5% level in Model 1a (printed at 10%) and at the 10% level in Model 1b (printed as not significant). It stays insignificant in Model 2a and on its own in Table 4, Model A. The article's statement that ideology has no discernible influence therefore holds less firmly in the full models than the printed tables suggest.

The published tables use the 2014 weight, and the scripts reproduce them with it. `tables_final_R.md` also counts Table 2 on the 991 distinct respondents: five counts are one lower than the article's, and no percentage changes at two decimals.

## The data

SocialSci, an online survey panel company, fielded my Economic Justice Survey (version 7) between November 2013 and April 2014. My 2014 cleaning kept 992 respondents, and this file holds all of them. Of the survey's 241 columns, it keeps the 54 the tables and figures use. The full survey, with the cleaning scripts, questionnaire, and codebook, will be deposited separately; its DOI will be added to this record.

- `row` is the row number in the full survey file and the only column that identifies a respondent uniquely.
- `id` is the vendor's respondent number, kept for matching to the full survey. It is unreliable as a key:
  - 55 id values are each carried by two different respondents, because the vendor's numbering collided within one fielding batch.
  - One respondent's record is in the file twice, under ids 1115 and 1157, identical in every answer, so the 992 rows hold 991 people. The published regressions and figures leave out the second copy, and the scripts do the same. The 2018 figure code removes it explicitly; the 2014 regression code does not show where it was dropped, but only dropping that record reproduces the published sample sizes and R² values. The article's count of 992 respondents, in Section 3.1 and Table 2, includes the second copy; `tables_final_R.md` gives Table 2 on the 991.
- `corr_ideal_agency`, the dependent variable, is missing for 29 respondents, so Table 1's models have N = 953. Models 1a and 1b also include theology, which only respondents who identify with a religion were asked, and have N = 671.

## The regressions

Every regression in Tables 1 and 4 is one Stata command, `svy: regress corr_ideal_agency <predictors>`, after `svyset [pweight = post_weight]`: a linear regression weighted by the survey weight, with standard errors that remain valid when the spread of the errors differs across respondents. With only a weight declared, Stata's standard error is the robust (HC0) formula multiplied by n/(n−1), tested against a t distribution with n−1 degrees of freedom. The scripts compute exactly that.

- Models 1a to 3a include the neoliberal index; Models 1b to 3b replace it with its four statements. Models 2 and 3 are reduced versions with fewer predictors.
- Table 4 enters the predictors in smaller groups, to show that Table 1's results are not an artifact of correlated predictors.

## Three things to know before writing your own version

Each of these fails silently: you get plausible numbers, not an error.

**The dependent variable is stored rescaled.** The article reports it on its natural −1 to 1 scale, but the file holds it rescaled to 0 to 1. Convert it back (`corr_ideal_agency * 2 - 1`), or every coefficient comes out half the published value with the same t statistics.

**The neoliberal index runs backwards from its name.** The 2014 cleaning reversed the sign of the four statements before averaging them, so a high value of `neoliberal` means anti-neoliberal. The article's Neoliberal rows enter the index with its sign reversed, as do the four statements in Models 1b to 3b. Enter it as stored and the Neoliberal coefficient comes out +0.182 where the article prints −0.182, with the constant still matching. Figure 7's error is this one.

**Testing decimals for equality.** The 2014 code recodes variables by exact comparison or cut-off on the rescaled values (`(income_household * 18) < 7`). That works in Stata. In R or Python the stored values are 0.7999… rather than 0.8, and `income_household * 18` lands on a whole number for only 109 of the 992 rows. Round to the nearest whole code first. Both scripts do.

## Citation and license

Cite the article, and this package by the DOI on its record. Released under CC BY 4.0.
