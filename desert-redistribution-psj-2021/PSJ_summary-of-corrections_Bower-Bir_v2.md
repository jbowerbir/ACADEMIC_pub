# Summary of corrections

Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

## Summary

While preparing the survey data and analysis for public deposit, I found transcription errors in the printed tables, one misread coefficient sign in the text, and a duplicated survey record. None of these changes any finding, interpretation, or claim in the paper. To build the replication package, I translated the original 2014 Stata code into R and Python, verified the data cleaning, and checked every table in the paper against the output. The check found two kinds of problem: reporting errors, where the analysis itself was correct, and a problem in the data that required re-estimating the tables.

**Reporting errors: the printed tables and one sentence of text.** Twenty-one cells in the tables differ from the output: mostly digits mistyped or transposed, decimals slipped, and significance stars one level off, plus three dropped minus signs. One of those is in Table 1: the coefficient on Definition in Model 3 for Y_gov is printed as 0.518 and is −0.518, as Section 6.3 states and as the other two models in the row show. These errors are mine, made when I typed the results into the manuscript. Apart from the sentence corrected next, the text already states the correct results throughout. Each cell is listed in the replication package.

Section 6.1 says the coefficient on Age² is positive and that support for government action to reduce the income gap grows "with an increasing marginal effect." The coefficient is negative but tiny, because age is measured in years, so the table rounds it to 0.000 and its sign never appears there. Support for government action rises with age to the late thirties and then falls. "Concave," in the same sentence, was already right. Age is a control, and no finding rests on it.

**A duplicated record.** In correcting the tables I also found that one respondent's submission appears twice in the survey file as the vendor delivered it, under two different survey ids. My cleaning screened submissions by completion time, which removed every other duplicated row in the delivery; this pair passed, and the published tables count that respondent twice. I have therefore re-estimated every table on the 991 distinct observations, with the survey weight raked again on those rows. Tables that include Definition have N = 962, because 29 respondents have no value for that variable; that gap predates the duplicate. The updated tables follow.

- No coefficient changes sign.
- Most coefficients move by 0.001 to 0.002; the largest move is 0.014, in Table D1.
- At the 5% level nothing changes: every coefficient significant at 5% or better stays so, and none becomes so. Four markers that sit on a threshold move by one level: Definition in Table 1, Model 1 (p = 0.0099 to 0.0100, from 1% to 5%); Female in Table C1, Model B, and Good life in Table C2, Model A (from 10% to unmarked); and Income in Table 1, Y_prog_tax Model 1 (p = 0.102 to 0.100, from unmarked to 10%).
- Every claim in the text holds.

The replication package (survey data, the original Stata code, and R and Python versions of the analysis that reproduce every table and figure, with the cell-by-cell record of the errors above) is being deposited in Indiana University's ScholarWorks repository; its DOI is forthcoming.

## Updated tables (991 observations)

Coefficients with robust standard errors in parentheses; \* p < 0.10, \*\* p < 0.05, \*\*\* p < 0.01. Coefficients that round to zero keep their sign. The constant is the grand-mean intercept, as Stata reports it; its standard error is an approximation.


## Table 1
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

## Table C1, Y_gov_fix_gap
| Variable | gov Model A | gov Model B | gov Model C | gov Model D | gov Model E |
|---|---|---|---|---|---|
| Definition |  | −0.468*** |  |  |  |
| |  | (0.143) |  |  |  |
| Agency |  |  | −0.220*** |  |  |
| |  |  | (0.050) |  |  |
| Justice |  |  |  | −0.374*** |  |
| |  |  |  | (0.048) |  |
| Rich deserve |  |  |  |  | −0.337*** |
| |  |  |  |  | (0.055) |
| Avg. deserve |  |  |  |  | −0.136*** |
| |  |  |  |  | (0.049) |
| Poor deserve |  |  |  |  | −0.223*** |
| |  |  |  |  | (0.073) |
| Ideology | 0.571*** | 0.570*** | 0.505*** | 0.414*** | 0.345*** |
| | (0.053) | (0.051) | (0.054) | (0.052) | (0.053) |
| Age | 0.013** | 0.010 | 0.014** | 0.012* | 0.007 |
| | (0.006) | (0.007) | (0.007) | (0.007) | (0.005) |
| Age² | −0.000** | −0.000* | −0.000** | −0.000* | −0.000* |
| | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) |
| Female | 0.033 | 0.048 | 0.009 | −0.012 | 0.009 |
| | (0.029) | (0.029) | (0.028) | (0.026) | (0.023) |
| Nonwhite | 0.053 | 0.035 | 0.065** | 0.069** | 0.061** |
| | (0.033) | (0.032) | (0.032) | (0.031) | (0.029) |
| Married | −0.014 | −0.012 | 0.007 | −0.006 | −0.011 |
| | (0.032) | (0.032) | (0.032) | (0.029) | (0.028) |
| Unemployed | 0.020 | 0.003 | 0.004 | 0.006 | −0.005 |
| | (0.049) | (0.047) | (0.049) | (0.043) | (0.039) |
| Education | −0.001 | 0.027 | −0.008 | −0.022 | 0.026 |
| | (0.062) | (0.060) | (0.059) | (0.056) | (0.053) |
| Income | −0.210*** | −0.222*** | −0.177*** | −0.119** | −0.123** |
| | (0.060) | (0.061) | (0.058) | (0.054) | (0.053) |
| Constant | 0.137 | 0.584*** | 0.295** | 0.377*** | 0.640*** |
| | (0.121) | (0.189) | (0.127) | (0.124) | (0.117) |
| N | 991 | 962 | 991 | 991 | 991 |
| R² | 0.4472 | 0.4690 | 0.4720 | 0.5187 | 0.5574 |
| Adj. R² | 0.4134 | 0.4349 | 0.4391 | 0.4888 | 0.5289 |

## Table C1, Y_prog_tax
| Variable | tax Model A | tax Model B | tax Model C | tax Model D | tax Model E |
|---|---|---|---|---|---|
| Definition |  | 0.086 |  |  |  |
| |  | (0.137) |  |  |  |
| Agency |  |  | −0.129** |  |  |
| |  |  | (0.052) |  |  |
| Justice |  |  |  | −0.285*** |  |
| |  |  |  | (0.053) |  |
| Rich deserve |  |  |  |  | −0.336*** |
| |  |  |  |  | (0.078) |
| Avg. deserve |  |  |  |  | −0.050 |
| |  |  |  |  | (0.054) |
| Poor deserve |  |  |  |  | −0.116* |
| |  |  |  |  | (0.070) |
| Ideology | 0.589*** | 0.607*** | 0.550*** | 0.470*** | 0.415*** |
| | (0.044) | (0.044) | (0.047) | (0.052) | (0.054) |
| Age | 0.010 | 0.008 | 0.011 | 0.009 | 0.008 |
| | (0.007) | (0.007) | (0.007) | (0.007) | (0.006) |
| Age² | −0.000* | −0.000 | −0.000* | −0.000 | −0.000 |
| | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) |
| Female | 0.013 | 0.001 | −0.001 | −0.022 | −0.003 |
| | (0.028) | (0.027) | (0.028) | (0.026) | (0.026) |
| Nonwhite | 0.008 | 0.004 | 0.015 | 0.020 | 0.024 |
| | (0.031) | (0.032) | (0.032) | (0.031) | (0.029) |
| Married | 0.008 | 0.032 | 0.020 | 0.014 | 0.007 |
| | (0.036) | (0.036) | (0.036) | (0.033) | (0.033) |
| Unemployed | −0.089 | −0.052 | −0.098* | −0.099* | −0.106** |
| | (0.055) | (0.057) | (0.055) | (0.053) | (0.053) |
| Education | 0.105* | 0.109* | 0.100* | 0.088 | 0.110** |
| | (0.057) | (0.057) | (0.056) | (0.055) | (0.056) |
| Income | −0.176*** | −0.118* | −0.156*** | −0.107* | −0.109* |
| | (0.061) | (0.062) | (0.060) | (0.056) | (0.058) |
| Constant | 0.066 | −0.015 | 0.158 | 0.248* | 0.416*** |
| | (0.125) | (0.175) | (0.127) | (0.132) | (0.127) |
| N | 991 | 962 | 991 | 991 | 991 |
| R² | 0.3923 | 0.4059 | 0.4013 | 0.4361 | 0.4640 |
| Adj. R² | 0.3551 | 0.3677 | 0.3640 | 0.4010 | 0.4294 |

## Table C2, Y_gov_fix_gap
| Variable | gov Model A | gov Model B | gov Model C | gov Model D | gov Model E |
|---|---|---|---|---|---|
| Definition |  | −0.465*** | −0.384*** | −0.445*** | −0.481*** |
| |  | (0.136) | (0.141) | (0.117) | (0.129) |
| Agency |  |  | −0.201*** |  |  |
| |  |  | (0.052) |  |  |
| Justice |  |  |  | −0.419*** |  |
| |  |  |  | (0.050) |  |
| Rich deserve |  |  |  |  | −0.369*** |
| |  |  |  |  | (0.059) |
| Avg. deserve |  |  |  |  | −0.132*** |
| |  |  |  |  | (0.047) |
| Poor deserve |  |  |  |  | −0.284*** |
| |  |  |  |  | (0.062) |
| Good life | −0.052 | −0.016 | −0.002 | −0.001 | 0.016 |
| | (0.032) | (0.032) | (0.031) | (0.027) | (0.028) |
| Gov. help | 0.159*** | 0.114** | 0.107** | 0.167*** | 0.154*** |
| | (0.051) | (0.052) | (0.053) | (0.048) | (0.050) |
| Charity | −0.134 | −0.187** | −0.152* | −0.053 | −0.069 |
| | (0.086) | (0.085) | (0.084) | (0.073) | (0.083) |
| Ideology | 0.523*** | 0.535*** | 0.476*** | 0.345*** | 0.270*** |
| | (0.053) | (0.052) | (0.055) | (0.051) | (0.049) |
| Age | 0.014** | 0.012* | 0.013* | 0.011 | 0.006 |
| | (0.006) | (0.007) | (0.007) | (0.007) | (0.006) |
| Age² | −0.000** | −0.000** | −0.000** | −0.000 | −0.000 |
| | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) |
| Female | 0.024 | 0.041 | 0.022 | 0.000 | 0.029 |
| | (0.028) | (0.028) | (0.028) | (0.026) | (0.023) |
| Nonwhite | 0.059* | 0.042 | 0.052* | 0.055* | 0.051* |
| | (0.032) | (0.032) | (0.031) | (0.028) | (0.027) |
| Married | −0.020 | −0.027 | −0.010 | −0.019 | −0.027 |
| | (0.030) | (0.030) | (0.031) | (0.026) | (0.026) |
| Unemployed | −0.008 | −0.020 | −0.035 | −0.027 | −0.039 |
| | (0.050) | (0.048) | (0.048) | (0.041) | (0.039) |
| Education | −0.016 | 0.009 | 0.005 | −0.018 | 0.052 |
| | (0.060) | (0.059) | (0.057) | (0.052) | (0.049) |
| Income | −0.200*** | −0.208*** | −0.192*** | −0.143*** | −0.137*** |
| | (0.054) | (0.056) | (0.055) | (0.051) | (0.049) |
| Constant | 0.203 | 0.605*** | 0.654*** | 0.802*** | 1.091*** |
| | (0.130) | (0.190) | (0.193) | (0.175) | (0.168) |
| N | 991 | 962 | 962 | 962 | 962 |
| R² | 0.4632 | 0.4812 | 0.5008 | 0.5595 | 0.6018 |
| Adj. R² | 0.4285 | 0.4461 | 0.4663 | 0.5292 | 0.5734 |

## Table C2, Y_prog_tax
| Variable | tax Model A | tax Model B | tax Model C | tax Model D | tax Model E |
|---|---|---|---|---|---|
| Definition |  | 0.082 | 0.127 | 0.094 | 0.063 |
| |  | (0.136) | (0.139) | (0.129) | (0.132) |
| Agency |  |  | −0.110** |  |  |
| |  |  | (0.052) |  |  |
| Justice |  |  |  | −0.249*** |  |
| |  |  |  | (0.058) |  |
| Rich deserve |  |  |  |  | −0.289*** |
| |  |  |  |  | (0.076) |
| Avg. deserve |  |  |  |  | −0.055 |
| |  |  |  |  | (0.055) |
| Poor deserve |  |  |  |  | −0.138** |
| |  |  |  |  | (0.068) |
| Good life | −0.068* | −0.056 | −0.049 | −0.048 | −0.031 |
| | (0.040) | (0.040) | (0.040) | (0.038) | (0.037) |
| Gov. help | 0.101* | 0.085 | 0.082 | 0.117** | 0.109** |
| | (0.054) | (0.053) | (0.053) | (0.053) | (0.052) |
| Charity | −0.184** | −0.235*** | −0.216*** | −0.156** | −0.153** |
| | (0.080) | (0.080) | (0.080) | (0.076) | (0.076) |
| Ideology | 0.547*** | 0.572*** | 0.539*** | 0.459*** | 0.402*** |
| | (0.048) | (0.047) | (0.050) | (0.057) | (0.056) |
| Age | 0.011 | 0.010 | 0.010 | 0.009 | 0.007 |
| | (0.007) | (0.007) | (0.007) | (0.007) | (0.006) |
| Age² | −0.000* | −0.000 | −0.000* | −0.000 | −0.000 |
| | (0.000) | (0.000) | (0.000) | (0.000) | (0.000) |
| Female | 0.002 | −0.010 | −0.021 | −0.035 | −0.016 |
| | (0.029) | (0.028) | (0.028) | (0.027) | (0.026) |
| Nonwhite | 0.019 | 0.016 | 0.021 | 0.023 | 0.027 |
| | (0.030) | (0.031) | (0.031) | (0.031) | (0.030) |
| Married | 0.003 | 0.022 | 0.032 | 0.027 | 0.019 |
| | (0.034) | (0.034) | (0.034) | (0.032) | (0.033) |
| Unemployed | −0.117** | −0.084 | −0.092 | −0.088 | −0.095 |
| | (0.056) | (0.059) | (0.059) | (0.058) | (0.058) |
| Education | 0.090 | 0.092 | 0.089 | 0.076 | 0.107* |
| | (0.057) | (0.057) | (0.056) | (0.056) | (0.057) |
| Income | −0.152** | −0.082 | −0.074 | −0.044 | −0.039 |
| | (0.065) | (0.064) | (0.064) | (0.061) | (0.064) |
| Constant | 0.173 | 0.077 | 0.103 | 0.194 | 0.368** |
| | (0.140) | (0.180) | (0.181) | (0.175) | (0.171) |
| N | 991 | 962 | 962 | 962 | 962 |
| R² | 0.4068 | 0.4229 | 0.4292 | 0.4527 | 0.4773 |
| Adj. R² | 0.3685 | 0.3838 | 0.3899 | 0.4149 | 0.4400 |

## Table D1, Y_gov_fix_gap
| Variable | gov Model 1 | gov Model 2 | gov Model 3 |
|---|---|---|---|
| Definition | 0.862 | 0.218 | 0.551** |
| | (0.529) | (0.184) | (0.227) |
| Agency | 2.208*** |  |  |
| | (0.654) |  |  |
| Def. x Agency | −2.667*** |  |  |
| | (0.716) |  |  |
| Justice |  | 2.213*** |  |
| |  | (0.677) |  |
| Def. x Justice |  | −2.874*** |  |
| |  | (0.732) |  |
| Rich deserve |  |  | 2.523** |
| |  |  | (1.031) |
| Def. x Rich |  |  | −3.157*** |
| |  |  | (1.123) |
| Avg. deserve |  |  | 0.063 |
| |  |  | (0.966) |
| Def. x Avg. |  |  | −0.202 |
| |  |  | (1.049) |
| Poor deserve |  |  | 0.187 |
| |  |  | (0.865) |
| Def. x Poor |  |  | −0.542 |
| |  |  | (0.929) |
| Ideology | 0.469*** | 0.375*** | 0.279*** |
| | (0.051) | (0.050) | (0.049) |
| Age | 0.010 | 0.011 | 0.004 |
| | (0.007) | (0.007) | (0.006) |
| Age² | −0.000 | −0.000 | −0.000 |
| | (0.000) | (0.000) | (0.000) |
| Female | 0.022 | −0.009 | 0.024 |
| | (0.027) | (0.025) | (0.022) |
| Nonwhite | 0.051* | 0.049* | 0.042 |
| | (0.031) | (0.027) | (0.026) |
| Married | 0.012 | −0.025 | −0.019 |
| | (0.031) | (0.027) | (0.026) |
| Unemployed | −0.008 | −0.018 | −0.013 |
| | (0.044) | (0.037) | (0.035) |
| Education | 0.025 | 0.010 | 0.076 |
| | (0.057) | (0.051) | (0.048) |
| Income | −0.198*** | −0.115** | −0.108** |
| | (0.057) | (0.051) | (0.049) |
| Constant | −0.396 | 0.255 | 0.284 |
| | (0.504) | (0.215) | (0.231) |
| N | 962 | 962 | 962 |
| R² | 0.5078 | 0.5661 | 0.6101 |
| Adj. R² | 0.4750 | 0.5372 | 0.5822 |

## Table D1, Y_prog_tax
| Variable | tax Model 1 | tax Model 2 | tax Model 3 |
|---|---|---|---|
| Definition | 0.906*** | 0.106 | 0.246 |
| | (0.241) | (0.185) | (0.403) |
| Agency | 2.152*** |  |  |
| | (0.581) |  |  |
| Def. x Agency | −2.517*** |  |  |
| | (0.641) |  |  |
| Justice |  | −0.118 |  |
| |  | (0.551) |  |
| Def. x Justice |  | −0.154 |  |
| |  | (0.609) |  |
| Rich deserve |  |  | 0.885 |
| |  |  | (0.867) |
| Def. x Rich |  |  | −1.302 |
| |  |  | (0.959) |
| Avg. deserve |  |  | −0.652 |
| |  |  | (0.843) |
| Def. x Avg. |  |  | 0.661 |
| |  |  | (0.926) |
| Poor deserve |  |  | −0.922 |
| |  |  | (0.821) |
| Def. x Poor |  |  | 0.860 |
| |  |  | (0.900) |
| Ideology | 0.534*** | 0.492*** | 0.432*** |
| | (0.046) | (0.054) | (0.056) |
| Age | 0.007 | 0.008 | 0.005 |
| | (0.007) | (0.007) | (0.006) |
| Age² | −0.000 | −0.000 | −0.000 |
| | (0.000) | (0.000) | (0.000) |
| Female | −0.016 | −0.027 | −0.010 |
| | (0.027) | (0.026) | (0.026) |
| Nonwhite | 0.015 | 0.015 | 0.019 |
| | (0.030) | (0.032) | (0.030) |
| Married | 0.049 | 0.034 | 0.027 |
| | (0.035) | (0.034) | (0.034) |
| Unemployed | −0.056 | −0.064 | −0.070 |
| | (0.054) | (0.056) | (0.056) |
| Education | 0.109** | 0.093* | 0.126** |
| | (0.054) | (0.056) | (0.057) |
| Income | −0.103* | −0.058 | −0.047 |
| | (0.062) | (0.058) | (0.062) |
| Constant | −0.558** | 0.123 | 0.154 |
| | (0.232) | (0.208) | (0.386) |
| N | 962 | 962 | 962 |
| R² | 0.4309 | 0.4402 | 0.4694 |
| Adj. R² | 0.3930 | 0.4029 | 0.4315 |
