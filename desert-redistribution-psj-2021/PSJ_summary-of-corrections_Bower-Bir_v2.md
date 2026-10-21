# Summary of corrections

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

## Summary

I am preparing the survey data and analysis for deposit in a public repository, so that anyone can replicate the paper. For that, I translated the original 2014 Stata code into R and Python, verified the data cleaning, and checked every table in the paper against the output. The findings hold. The numbers hold. What the check found is a handful of transcription errors in the printed tables, made when I typed the results into the manuscript, and one survey record that the vendor delivered twice.

The transcription errors are a dropped minus sign, a few slipped decimals, a standard error copied from the wrong row, a few significance stars one level off, and one appendix column copied against the wrong row labels. Four are in Table 1 and are shown below. The rest are in the appendix tables and are listed at the end of this document. None of them changes a sign in the text, a finding, or an interpretation. The text already states the correct results.

The duplicated record is one respondent's submission that appears twice in the file as delivered. Removing it and re-estimating every table moves coefficients in the third decimal and no further. Updated tables, estimated on the 991 distinct records, are supplied with this correction. Apart from one sentence about a control variable, the paper's text stands as printed.

## Table 1

Four cells were transcribed wrongly.

| Row | Column | Published | Correct |
|---|---|---|---|
| Definition | Y_gov, Model 3 | `0.518***` | **−0.518\*\*\*** |
| Rich deserve (SE) | Y_gov, Model 3 | `(1.056)` | **(0.056)** |
| Nonwhite (SE) | Y_prog_tax, Model 1 | `(0.012)` | **(0.031)** |
| Agency | Y_prog_tax, Model 1 | `−0.133***` | **−0.133\*\*** |

The Definition cell lost its minus sign. Section 6.3 states the result correctly in words: "definition of desert always has a negative and statistically significant influence on Y_gov." As printed, this was the only positive number in a row that is negative throughout. The Rich deserve standard error gained a leading digit; as printed, −0.366 over 1.056 gives t = 0.35, which could not carry three stars, and with the correct standard error t = 6.5. The Nonwhite standard error is a slipped decimal on a coefficient that is not significant either way. Agency has one star too many: p = 0.012, significant at 5% rather than 1%. It stays negative and significant.

Twelve further cells in the appendix tables are listed at the end of this document. The updated tables supersede all of them.

## A duplicated record in the data

The survey's own id numbers are not unique: the vendor's numbering collided within one fielding batch, so 55 id values are each carried by two different respondents. That affects nothing; the analysis never uses the id.

Separately, one respondent's submission appears twice in the file as the vendor delivered it. The two rows share the same panel identifier, the same start and end time to the second, the same page-by-page timing, and the same answer to every question. They differ only in the id number the vendor assigned. The 2014 cleaning never removed duplicates. The published tables were therefore estimated on all 992 rows and count that respondent twice.

Re-estimating every table on the 991 distinct records moves coefficients by one or two units in the third decimal. The largest move is 0.014, in the large interaction coefficients of Table D1. No sign changes. Three significance markers that sit on a threshold change. Definition in Table 1, Model 1, for Y_gov becomes −0.381 with p = 0.010, significant at 5% rather than 1%. Female in Table C1 Model B and Good life in Table C2 Model A lose their 10% markers. The text is unaffected. Definition remains negative and significant in every model, as Section 6.3 says. Section 6.1 already describes gender and optimism about one's future standard of living as having little or no effect.

## Updated tables

Tables 1, C1, C2 and D1, re-estimated on the 991 distinct records, are supplied as replacements. They differ from the printed tables in two ways: in the transcription errors listed in this document, and elsewhere only in the third decimal, from the removal of the duplicated record. A second set, estimated on the published 992 rows with only the transcription errors corrected, is supplied as well, so that each listed cell can be checked against the page.

## One sentence of text

The sentence in Section 6.1 beginning "Age is not a consistently significant determinant" says the coefficient on age² is positive and that support for government action grows "with an increasing marginal effect." The coefficient is negative, between −0.00015 and −0.00019 in the Y_gov models. It prints as 0.000 because age is in years and was not rescaled, so the tables never showed its sign. The sentence should say that the negative coefficient on age² indicates a concave curve, and that support grows as a respondent ages until the late thirties and declines thereafter. "Concave," in the same sentence, was already right. Age is a control. No finding rests on it.

## Appendix: transcription errors in Tables C1, C2 and D1

Listed for the record. None bears on the paper's claims. The updated tables supersede them.

| Table | Row | Column | Published | Correct |
|---|---|---|---|---|
| C1 | Married | Y_prog_tax, Model B | `0.320` | **0.032** |
| C1 | Education (SE) | Y_gov, Model D | `(0.56)` | **(0.056)** |
| C1 | Education (SE) | Y_prog_tax, Model D | `(0.55)` | **(0.055)** |
| C1 | Age | Y_gov, Model D | `0.012***` | **0.012\*** |
| C1 | Age² | Y_gov, Model A | `0.000***` | **0.000\*\*** |
| C2 | Income | Y_gov, Model E | `0.136***` | **−0.136\*\*\*** |
| C2 | Income | Y_prog_tax, Model E | `0.039` | **−0.039** |
| C2 | N | Y_gov, Model D | `992` | **963** |
| C2 | N | Y_prog_tax, Model A | `963` | **992** |
| D1 | Married (SE) | Y_gov, Model 1 | `(0.036)` | **(0.031)** |
| D1 | Income | Y_gov, Model 2 | `−0.113***` | **−0.113\*\*** |
| D1 | Income | Y_prog_tax, Model 1 | `−0.103` | **−0.103\*** |

In Table D1, the Y_prog_tax Model 3 column also has six coefficients in the block of deserve variables printed against the wrong row labels: the numbers were copied down in Stata's order (three main effects, then three interactions) against the table's interleaved labels, each with its own standard error, and one digit was mistyped. The correct column is Rich deserve 0.883 (0.867), Definition × Rich deserve −1.300 (0.958), Avg. deserve −0.653 (0.843), Definition × Avg. deserve 0.662 (0.926), Poor deserve −0.922 (0.821), and Definition × Poor deserve 0.860 (0.900), unchanged. None of the six is statistically significant before or after, so the conclusion of Section D.2 stands.

## Replication package

The survey data the regressions use, the original Stata code, and R and Python versions of the analysis that reproduce every table and figure and list every cell corrected here are being deposited in IU ScholarWorks and can be supplied on request.
