# Summary of corrections

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

The article as published contains three types of error:

- **Mistyped cells**, four in Table 1 and eighteen in the appendix tables. I mistyped them when entering the results into the manuscript. The most visible is in Table 1, Y_gov_fix_gap Model 3, where the coefficient on Definition is printed as positive when it is negative, as the prose in Section 6.3 correctly states. None of the typos bears on the article’s conclusions.
- **A misread control variable.** Two sentences in Section 6.1 misread the coefficient on Age², a control. The coefficient is so small that it prints as 0.000. The article reads it as positive and says that support for government action to reduce the income gap (Y_gov_fix_gap) accelerates with age. The coefficient is negative: support rises with age up to about age 34 and then falls. The turning point comes from Y_gov_fix_gap Model 1 in Table 1, the one Table 1 model where Age² is significant.
- **Two figures drawn on mixed scales.** Figures D1 and D2 in Appendix D mix two scalings of Definition. Redrawn on one scale, the lines in Figure D1 are about half as steep as printed: the interaction between Definition and faith in economic justice is weaker than the printed figure suggests, and the article’s verdict that the evidence for it is meager stands. In Figure D2, the printed panel showed a sizeable group of respondents for whom faith in economic justice raised support for redistribution; the corrected panel shows almost none, so the article’s finding that faith in economic justice lowers support holds for nearly the whole sample. The replication package carries the corrected figures.

The data behind the article also carry two errors, both in my 2014 cleaning. First, the survey panel vendor delivered one respondent’s answers under two different ids, and my cleaning script did not catch the duplicate, so the published sample of 992 records holds 991 respondents. Second, my original weighting script placed the 54 respondents earning $25,000 to $29,999 per year in the under-$25,000 income group. I have re-estimated every table and figure with both errors corrected. In Table 1, coefficients move by a few hundredths of a unit (every variable save Age and its square runs from 0 to 1), and the figures are visibly unchanged. The key independent variables---Definition, Agency, Justice, Rich deserve, Avg. deserve, and Poor deserve---all keep their signs and, with two exceptions, their significance levels: Definition drops from the 1% level to the 5% level in one model, and Agency rises from the 5% level to the 1% level in another.

With the data corrected, the main text’s findings and interpretation stand. The corrected Table 1, estimated on the 991 distinct respondents with the corrected weights, follows. The replication package, deposited in IU DataCORE, Indiana University’s data repository (DOI forthcoming), documents the data cleaning and its two corrections, re-estimates every table and figure in the article, draws Figures D1 and D2 on one scale, and shows each corrected cell beside its published value.

## Table 1 (corrected, 991 respondents, corrected weights)

| Variable | Y_gov Model 1 | Y_gov Model 2 | Y_gov Model 3 | Y_tax Model 1 | Y_tax Model 2 | Y_tax Model 3 |
|---|---|---|---|---|---|---|
| Definition | −0.350** | −0.462*** | −0.471*** | 0.163 | 0.093 | 0.074 |
| | (0.139) | (0.121) | (0.125) | (0.135) | (0.124) | (0.123) |
| Agency | −0.216*** |  |  | −0.134*** |  |  |
| | (0.049) |  |  | (0.052) |  |  |
| Justice |  | −0.397*** |  |  | −0.259*** |  |
| |  | (0.047) |  |  | (0.055) |  |
| Rich deserve |  |  | −0.350*** |  |  | −0.315*** |
| |  |  | (0.056) |  |  | (0.076) |
| Avg. deserve |  |  | −0.129*** |  |  | −0.052 |
| |  |  | (0.047) |  |  | (0.055) |
| Poor deserve |  |  | −0.282*** |  |  | −0.124* |
| |  |  | (0.065) |  |  | (0.069) |
| Ideology | 0.501*** | 0.396*** | 0.316*** | 0.560*** | 0.490*** | 0.429*** |
| | (0.052) | (0.050) | (0.050) | (0.048) | (0.053) | (0.056) |
| Age | 0.011 | 0.009 | 0.004 | 0.009 | 0.009 | 0.007 |
| | (0.007) | (0.007) | (0.006) | (0.007) | (0.007) | (0.006) |
| Age² | −0.000** | −0.000 | −0.000 | −0.000 | −0.000 | −0.000 |
| | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) |
| Female | 0.022 | 0.001 | 0.027 | −0.018 | −0.032 | −0.014 |
| | (0.027) | (0.026) | (0.023) | (0.027) | (0.025) | (0.025) |
| Nonwhite | 0.051* | 0.054* | 0.050* | 0.013 | 0.015 | 0.022 |
| | (0.031) | (0.028) | (0.028) | (0.031) | (0.031) | (0.029) |
| Married | 0.007 | −0.004 | −0.012 | 0.036 | 0.029 | 0.020 |
| | (0.031) | (0.027) | (0.027) | (0.035) | (0.033) | (0.033) |
| Unemployed | −0.014 | −0.005 | −0.020 | −0.071 | −0.066 | −0.078 |
| | (0.045) | (0.039) | (0.037) | (0.058) | (0.057) | (0.058) |
| Education | 0.026 | 0.009 | 0.074 | 0.109** | 0.097* | 0.123** |
| | (0.057) | (0.053) | (0.049) | (0.055) | (0.055) | (0.055) |
| Income | −0.190*** | −0.124** | −0.118** | −0.104* | −0.061 | −0.053 |
| | (0.057) | (0.052) | (0.051) | (0.061) | (0.057) | (0.061) |
| Constant | 0.628*** | 0.817*** | 1.093*** | −0.004 | 0.122 | 0.303* |
| | (0.180) | (0.172) | (0.160) | (0.174) | (0.171) | (0.165) |
| N | 962 | 962 | 962 | 962 | 962 | 962 |
| R² | 0.4998 | 0.5525 | 0.5937 | 0.4202 | 0.4454 | 0.4728 |
| Adj. R² | 0.4671 | 0.5232 | 0.5661 | 0.3822 | 0.4091 | 0.4370 |

Coefficients with robust standard errors in parentheses; \* p < 0.10, \*\* p < 0.05, \*\*\* p < 0.01. Y_gov is Y_gov_fix_gap and Y_tax is Y_prog_tax. Coefficients that round to zero keep their sign. N is 962 because 29 respondents have no Definition score.
