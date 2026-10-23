# Summary of corrections

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

The tables in the article contain two kinds of error:

- **Mistyped cells**, four in Table 1 and seventeen in the appendix tables. I mistyped them when entering the results into the manuscript. The most visible is in Table 1, Y_gov_fix_gap Model 3, where the Definition variable's coefficient is incorrectly printed as positive when it is negative, as the prose in Section 6.3 of the published article correctly states. None of the typos meaningfully bears on the paper's conclusions.
- **One respondent counted twice.** The online survey panel vendor SocialSci delivered one respondent's answers under two different ids, and my original data cleaning script failed to catch the duplication. I have re-estimated all models on the deduplicated dataset, which has 991 distinct respondents compared to the 992 observations in the original published data. As a result, coefficients move in the third decimal place and four significance markers move by one level. No key variable gains or loses significance: Definition, in one Table 1 model, moves from the 1% significance level to the 5% level, while the other three changes affect control variables.

The article's findings and interpretation stand. One sentence in Section 6.1 needs correcting. In that sentence I interpret the coefficient on Age², a control variable, as positive. The coefficient is negative, but so small in magnitude that the table prints it as 0.000. Support for government action to reduce the income gap rises with age into the late thirties and then falls, rather than accelerating.

The corrected Table 1, using the deduplicated dataset, follows. Every table in the article is reproduced in the freely available replication package, deposited in IU DataCORE, Indiana University's data repository (DOI forthcoming), with each corrected cell shown beside its published value.

## Table 1 (corrected, 991 observations)

| Variable | Y_gov Model 1 | Y_gov Model 2 | Y_gov Model 3 | Y_tax Model 1 | Y_tax Model 2 | Y_tax Model 3 |
|---|---|---|---|---|---|---|
| Definition | −0.381** | −0.497*** | −0.517*** | 0.139 | 0.067 | 0.044 |
| | (0.148) | (0.126) | (0.131) | (0.140) | (0.128) | (0.127) |
| Agency | −0.214*** |  |  | −0.132** |  |  |
| | (0.051) |  |  | (0.053) |  |  |
| Justice |  | −0.402*** |  |  | −0.257*** |  |
| |  | (0.048) |  |  | (0.056) |  |
| Rich deserve |  |  | −0.365*** |  |  | −0.308*** |
| |  |  | (0.056) |  |  | (0.080) |
| Avg. deserve |  |  | −0.126*** |  |  | −0.050 |
| |  |  | (0.047) |  |  | (0.055) |
| Poor deserve |  |  | −0.277*** |  |  | −0.132* |
| |  |  | (0.067) |  |  | (0.071) |
| Ideology | 0.502*** | 0.392*** | 0.309*** | 0.565*** | 0.493*** | 0.432*** |
| | (0.053) | (0.051) | (0.050) | (0.048) | (0.054) | (0.056) |
| Age | 0.011 | 0.010 | 0.004 | 0.008 | 0.008 | 0.006 |
| | (0.007) | (0.007) | (0.006) | (0.007) | (0.007) | (0.006) |
| Age² | −0.000* | −0.000 | −0.000 | −0.000 | −0.000 | −0.000 |
| | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) |
| Female | 0.025 | 0.005 | 0.030 | −0.013 | −0.026 | −0.009 |
| | (0.028) | (0.026) | (0.023) | (0.027) | (0.026) | (0.026) |
| Nonwhite | 0.048 | 0.052* | 0.050* | 0.012 | 0.015 | 0.022 |
| | (0.032) | (0.029) | (0.028) | (0.031) | (0.032) | (0.030) |
| Married | 0.006 | −0.009 | −0.013 | 0.044 | 0.035 | 0.028 |
| | (0.032) | (0.028) | (0.027) | (0.036) | (0.034) | (0.034) |
| Unemployed | −0.019 | −0.015 | −0.029 | −0.066 | −0.064 | −0.074 |
| | (0.046) | (0.039) | (0.038) | (0.056) | (0.056) | (0.057) |
| Education | 0.020 | 0.002 | 0.068 | 0.105* | 0.092* | 0.121** |
| | (0.058) | (0.054) | (0.050) | (0.055) | (0.056) | (0.056) |
| Income | −0.197*** | −0.131** | −0.122** | −0.102* | −0.059 | −0.051 |
| | (0.058) | (0.053) | (0.052) | (0.062) | (0.058) | (0.062) |
| Constant | 0.660*** | 0.851*** | 1.147*** | 0.031 | 0.155 | 0.345** |
| | (0.193) | (0.180) | (0.170) | (0.178) | (0.174) | (0.170) |
| N | 962 | 962 | 962 | 962 | 962 | 962 |
| R² | 0.4914 | 0.5462 | 0.5895 | 0.4152 | 0.4401 | 0.4667 |
| Adj. R² | 0.4582 | 0.5165 | 0.5617 | 0.3770 | 0.4035 | 0.4306 |

Coefficients with robust standard errors in parentheses; \* p < 0.10, \*\* p < 0.05, \*\*\* p < 0.01. Coefficients that round to zero keep their sign. The constant is the grand-mean intercept, as Stata reports it; its standard error is an approximation.
