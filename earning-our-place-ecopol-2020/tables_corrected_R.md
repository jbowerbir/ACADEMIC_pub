# Reproduced tables: Bower-Bir (2021), Economia Politica 38(1): 131-170

Written by script_replication.R (tables_corrected_R.md) and script_replication.py (tables_corrected_python.md); the two files are identical. Every regression and every figure statistic uses the 991 distinct respondents; Table 2 describes all 992 rows, as the article's does. The R2 row is the article's "Adj-R2" row: `svy: reg` reports plain R2, and the printed values are that.

## Table 1
| Variable | Model 1a | Model 2a | Model 3a | Model 1b | Model 2b | Model 3b |
|---|---|---|---|---|---|---|
| Ideology | -0.166* | -0.043 |  | -0.137 |  |  |
| | (0.093) | (0.062) |  | (0.091) |  |  |
| Political party | 0.007 |  |  | 0.047 |  |  |
| | (0.071) |  |  | (0.073) |  |  |
| Religiosity | -0.079* | -0.039 |  | -0.076* | -0.033 |  |
| | (0.045) | (0.043) |  | (0.046) | (0.035) |  |
| Theology | 0.020 |  |  | 0.032 |  |  |
| | (0.060) |  |  | (0.060) |  |  |
| Nonwhite | -0.098*** | -0.066** | -0.070** | -0.092*** | -0.061** | -0.065** |
| | (0.032) | (0.029) | (0.031) | (0.030) | (0.026) | (0.028) |
| Female | 0.005 |  |  | 0.015 |  |  |
| | (0.031) |  |  | (0.027) |  |  |
| Gay | 0.047 |  |  | 0.028 |  |  |
| | (0.031) |  |  | (0.031) |  |  |
| Income | 0.108* | 0.123** | 0.119** | 0.121** | 0.133*** | 0.125** |
| | (0.055) | (0.051) | (0.049) | (0.052) | (0.049) | (0.049) |
| Ivy league | 0.159*** | 0.125*** | 0.114*** | 0.162*** | 0.121*** | 0.120*** |
| | (0.051) | (0.041) | (0.042) | (0.053) | (0.042) | (0.043) |
| Education | 0.028 |  |  | 0.014 |  |  |
| | (0.058) |  |  | (0.050) |  |  |
| Age | -0.003** | -0.003*** | -0.003** | -0.003** | -0.003*** | -0.003*** |
| | (0.001) | (0.001) | (0.001) | (0.001) | (0.001) | (0.001) |
| Urban | 0.018 |  |  | 0.024 |  |  |
| | (0.039) |  |  | (0.037) |  |  |
| Southern | 0.073** | 0.039 |  | 0.073*** | 0.038 |  |
| | (0.029) | (0.027) |  | (0.026) | (0.027) |  |
| Neoliberal | -0.269*** | -0.201*** | -0.182*** |  |  |  |
| | (0.091) | (0.077) | (0.058) |  |  |  |
| Profits |  |  |  | 0.011 |  |  |
| |  |  |  | (0.052) |  |  |
| Gov. stay out |  |  |  | 0.039 |  |  |
| |  |  |  | (0.057) |  |  |
| Self help |  |  |  | -0.097* | -0.085* | -0.085* |
| |  |  |  | (0.052) | (0.045) | (0.045) |
| Disp. incentives |  |  |  | -0.193*** | -0.121** | -0.122*** |
| |  |  |  | (0.056) | (0.048) | (0.047) |
| Constant | 0.643*** | 0.635*** | 0.623*** | 0.611*** | 0.601*** | 0.610*** |
| | (0.073) | (0.058) | (0.058) | (0.076) | (0.056) | (0.055) |
| N | 671 | 953 | 953 | 671 | 953 | 953 |
| R2 | 0.1978 | 0.1288 | 0.1193 | 0.2320 | 0.1467 | 0.1382 |

## Table 2
| Group | Sample N | Sample % |
|---|---|---|
| Female | 586 | 0.59 |
| Male | 406 | 0.41 |
| White | 701 | 0.71 |
| Black | 93 | 0.09 |
| Latino | 52 | 0.05 |
| Asian | 111 | 0.11 |
| Other | 35 | 0.04 |
| High school or less | 118 | 0.12 |
| Associate's or some college | 330 | 0.33 |
| Bachelor's degree | 351 | 0.35 |
| Graduate degree | 193 | 0.19 |
| <$25k | 192 | 0.19 |
| $25k-$49k | 247 | 0.25 |
| $50k-$74k | 210 | 0.21 |
| $75k-$99k | 141 | 0.14 |
| $100k-$149k | 137 | 0.14 |
| $150k+ | 65 | 0.07 |
| Republican | 68 | 0.07 |
| Lean Republican | 79 | 0.08 |
| Independent | 264 | 0.27 |
| Lean Democrat | 284 | 0.29 |
| Democrat | 297 | 0.30 |

## Table 4
| Variable | Model A | Model B | Model C | Model D | Model E | Model F | Model G | Model H | Model I |
|---|---|---|---|---|---|---|---|---|---|
| Ideology | 0.006 |  |  |  |  |  |  |  |  |
| | (0.058) |  |  |  |  |  |  |  |  |
| Political party |  | -0.049 |  |  |  |  |  |  | -0.019 |
| |  | (0.057) |  |  |  |  |  |  | (0.055) |
| Religiosity | -0.069 |  |  |  |  |  |  |  |  |
| | (0.053) |  |  |  |  |  |  |  |  |
| Theology |  | 0.106 |  |  |  |  |  |  | 0.014 |
| |  | (0.070) |  |  |  |  |  |  | (0.055) |
| Nonwhite |  |  | -0.093** |  |  |  |  | -0.084*** | -0.104*** |
| |  |  | (0.038) |  |  |  |  | (0.030) | (0.033) |
| Female |  |  | 0.005 |  |  |  |  | 0.013 | 0.004 |
| |  |  | (0.030) |  |  |  |  | (0.027) | (0.033) |
| Gay |  |  | 0.081*** |  |  |  |  | 0.058*** | 0.061** |
| |  |  | (0.027) |  |  |  |  | (0.022) | (0.030) |
| Income |  |  |  | 0.125** |  |  |  |  | 0.083 |
| |  |  |  | (0.049) |  |  |  |  | (0.058) |
| Ivy league |  |  |  | 0.097*** |  |  |  |  |  |
| |  |  |  | (0.032) |  |  |  |  |  |
| Education |  |  |  |  | 0.080 |  |  | 0.056 | 0.048 |
| |  |  |  |  | (0.058) |  |  | (0.053) | (0.055) |
| Age |  |  |  |  | -0.003** |  |  | -0.003** | -0.002* |
| |  |  |  |  | (0.001) |  |  | (0.001) | (0.001) |
| Urban |  |  |  |  | -0.039 |  |  | 0.007 | 0.030 |
| |  |  |  |  | (0.033) |  |  | (0.035) | (0.042) |
| Southern |  |  |  |  | 0.040 |  |  | 0.035 | 0.069** |
| |  |  |  |  | (0.027) |  |  | (0.028) | (0.029) |
| Neoliberal |  |  |  |  |  | -0.185*** |  |  |  |
| |  |  |  |  |  | (0.063) |  |  |  |
| Profits |  |  |  |  |  |  | 0.053 |  |  |
| |  |  |  |  |  |  | (0.042) |  |  |
| Gov. stay out |  |  |  |  |  |  | -0.040 |  |  |
| |  |  |  |  |  |  | (0.036) |  |  |
| Self help |  |  |  |  |  |  | -0.089* |  |  |
| |  |  |  |  |  |  | (0.047) |  |  |
| Disp. incentives |  |  |  |  |  |  | -0.132*** |  |  |
| |  |  |  |  |  |  | (0.051) |  |  |
| Constant | 0.698*** | 0.628*** | 0.695*** | 0.599*** | 0.748*** | 0.575*** | 0.559*** | 0.738*** | 0.671*** |
| | (0.046) | (0.066) | (0.020) | (0.036) | (0.036) | (0.045) | (0.047) | (0.040) | (0.061) |
| N | 962 | 709 | 916 | 953 | 962 | 962 | 962 | 916 | 679 |
| R2 | 0.0145 | 0.0183 | 0.0540 | 0.0211 | 0.0613 | 0.0297 | 0.0501 | 0.0964 | 0.1337 |

## Figures 3 and 4
Control-importance correlation by factor, in ascending order of the Figure 3 value; Figure 5 places each factor at the mean of the two.

| Factor | Figure 3 | Figure 4 | Figure 5 |
|---|---|---|---|
| intelligence | 0.21 | 0.21 | 0.21 |
| schl. prestige | 0.24 | 0.25 | 0.24 |
| education | 0.25 | 0.26 | 0.25 |
| creativity | 0.30 | 0.30 | 0.30 |
| fam. stability | 0.31 | 0.31 | 0.31 |
| state of econ. | 0.32 | 0.32 | 0.32 |
| attitude | 0.33 | 0.35 | 0.34 |
| health | 0.33 | 0.32 | 0.33 |
| parents' educ. | 0.34 | 0.36 | 0.35 |
| hard work | 0.39 | 0.41 | 0.40 |
| gender | 0.41 | 0.44 | 0.42 |
| ambition | 0.43 | 0.45 | 0.44 |
| connections | 0.48 | 0.50 | 0.49 |
| fam. wealth | 0.49 | 0.52 | 0.50 |
| race | 0.49 | 0.54 | 0.51 |

## Figure 6 and Section 5
| Statistic | Reproduced |
|---|---|
| Fig. 6, mean | 0.68 |
| Fig. 6, median | 0.74 |
| Fig. 6, lower quartile | 0.62 |
| Fig. 6, upper quartile | 0.82 |
| Fig. 6, standard deviation | 0.22 |
| Fig. 6, share between 0.44 and 0.98 | 90% |
| Sect. 5, share on the positive side of the neoliberal index | 60% |

## Figure 7
The neoliberal index as stored runs from -3 (most neoliberal) to 3 (least). Its positive side, which Figure 7 labels neoliberal and Section 5 counts as neoliberal-leaning, is the anti-neoliberal side.

| Respondents | Share |
|---|---|
| Lean neoliberal | 32.5% |
| Exactly neutral | 7.8% |
| Lean anti-neoliberal | 59.7% |
| Mean of the index, -3 to 3 | 0.41 |

## The survey weight
Raking with the 2014 script's strata and targets reproduces the weight in the file: largest difference 1.4e-05. The script's lowest income stratum takes income codes 0-7 (under $30,000) for a target described as under $25,000; Table 2's script, like the questionnaire, puts the $25,000 line at code 7. Raking with the line at code 7 moves 54 respondents into the second stratum. Tables 1 and 4 re-estimated with that weight are in tables_final_R.md and tables_final_python.md, with every cell that changes.

## Cells that differ from the published tables
| Table | Column | Row | Published | Reproduced |
|---|---|---|---|---|
| Table 1 | Model 1b | Political party SE | (0.0073) | (0.073) |
| Table 1 | Model 1b | Female SE | (0.023) | (0.027) |
| Table 1 | Model 3b | Income | 0.125*** | 0.125** |
| Table 4 | Model F | Neoliberal SE | (0.064) | (0.063) |
| Table 4 | Model E | Constant SE | (0.035) | (0.036) |
| Figures 3 and 4 | Figure 3 | health | 0.32 | 0.33 |
| Figures 3 and 4 | Figure 3 | state of econ. | 0.33 | 0.32 |
| Figure 6 and Section 5 | Reproduced | Fig. 6, mean | 0.69 | 0.68 |
