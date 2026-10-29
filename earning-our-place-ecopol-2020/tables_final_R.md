# Final tables: Bower-Bir (2021), Economia Politica 38(1): 131-170

Written by script_replication.R (tables_final_R.md) and script_replication.py (tables_final_python.md); the two files are identical. Tables 1 and 4 are re-estimated on the 991 distinct respondents with the survey weight raked again with the $25,000 income line in the right place (the 2014 weight placed the 54 respondents earning $25,000 to $29,999 in the group below $25,000). Table 2 counts the 991 distinct respondents; the article's counts include one respondent's duplicated record. The last section lists every cell that differs from the corrected tables (tables_corrected_R.md).

## Table 1
| Variable | Model 1a | Model 2a | Model 3a | Model 1b | Model 2b | Model 3b |
|---|---|---|---|---|---|---|
| Ideology | -0.178** | -0.054 |  | -0.148* |  |  |
| | (0.085) | (0.061) |  | (0.082) |  |  |
| Political party | 0.016 |  |  | 0.063 |  |  |
| | (0.066) |  |  | (0.067) |  |  |
| Religiosity | -0.079* | -0.037 |  | -0.078* | -0.027 |  |
| | (0.042) | (0.042) |  | (0.042) | (0.034) |  |
| Theology | 0.012 |  |  | 0.027 |  |  |
| | (0.058) |  |  | (0.058) |  |  |
| Nonwhite | -0.094*** | -0.060** | -0.064** | -0.091*** | -0.057** | -0.060** |
| | (0.031) | (0.028) | (0.030) | (0.029) | (0.025) | (0.027) |
| Female | 0.008 |  |  | 0.021 |  |  |
| | (0.031) |  |  | (0.027) |  |  |
| Gay | 0.049 |  |  | 0.028 |  |  |
| | (0.030) |  |  | (0.031) |  |  |
| Income | 0.114** | 0.126** | 0.124*** | 0.130** | 0.137*** | 0.130*** |
| | (0.054) | (0.049) | (0.047) | (0.050) | (0.048) | (0.047) |
| Ivy league | 0.164*** | 0.122*** | 0.108*** | 0.169*** | 0.116*** | 0.114*** |
| | (0.053) | (0.043) | (0.042) | (0.054) | (0.043) | (0.043) |
| Education | 0.010 |  |  | -0.002 |  |  |
| | (0.058) |  |  | (0.051) |  |  |
| Age | -0.002* | -0.003** | -0.003** | -0.002** | -0.003*** | -0.003*** |
| | (0.001) | (0.001) | (0.001) | (0.001) | (0.001) | (0.001) |
| Urban | 0.010 |  |  | 0.017 |  |  |
| | (0.037) |  |  | (0.035) |  |  |
| Southern | 0.072** | 0.035 |  | 0.075*** | 0.035 |  |
| | (0.029) | (0.027) |  | (0.026) | (0.027) |  |
| Neoliberal | -0.268*** | -0.204*** | -0.177*** |  |  |  |
| | (0.091) | (0.078) | (0.060) |  |  |  |
| Profits |  |  |  | -0.000 |  |  |
| |  |  |  | (0.048) |  |  |
| Gov. stay out |  |  |  | 0.061 |  |  |
| |  |  |  | (0.055) |  |  |
| Self help |  |  |  | -0.101** | -0.089** | -0.089** |
| |  |  |  | (0.048) | (0.043) | (0.043) |
| Disp. incentives |  |  |  | -0.188*** | -0.115** | -0.115*** |
| |  |  |  | (0.051) | (0.045) | (0.044) |
| Constant | 0.649*** | 0.630*** | 0.612*** | 0.613*** | 0.590*** | 0.599*** |
| | (0.070) | (0.057) | (0.058) | (0.071) | (0.054) | (0.053) |
| N | 671 | 953 | 953 | 671 | 953 | 953 |
| R2 | 0.1833 | 0.1185 | 0.1087 | 0.2212 | 0.1355 | 0.1285 |

## Table 2
| Group | Sample N | Sample % |
|---|---|---|
| Female | 585 | 0.59 |
| Male | 406 | 0.41 |
| White | 700 | 0.71 |
| Black | 93 | 0.09 |
| Latino | 52 | 0.05 |
| Asian | 111 | 0.11 |
| Other | 35 | 0.04 |
| High school or less | 118 | 0.12 |
| Associate's or some college | 329 | 0.33 |
| Bachelor's degree | 351 | 0.35 |
| Graduate degree | 193 | 0.19 |
| <$25k | 192 | 0.19 |
| $25k-$49k | 247 | 0.25 |
| $50k-$74k | 210 | 0.21 |
| $75k-$99k | 140 | 0.14 |
| $100k-$149k | 137 | 0.14 |
| $150k+ | 65 | 0.07 |
| Republican | 68 | 0.07 |
| Lean Republican | 79 | 0.08 |
| Independent | 264 | 0.27 |
| Lean Democrat | 283 | 0.29 |
| Democrat | 297 | 0.30 |

## Table 4
| Variable | Model A | Model B | Model C | Model D | Model E | Model F | Model G | Model H | Model I |
|---|---|---|---|---|---|---|---|---|---|
| Ideology | -0.008 |  |  |  |  |  |  |  |  |
| | (0.055) |  |  |  |  |  |  |  |  |
| Political party |  | -0.048 |  |  |  |  |  |  | -0.016 |
| |  | (0.054) |  |  |  |  |  |  | (0.054) |
| Religiosity | -0.066 |  |  |  |  |  |  |  |  |
| | (0.051) |  |  |  |  |  |  |  |  |
| Theology |  | 0.083 |  |  |  |  |  |  | -0.001 |
| |  | (0.065) |  |  |  |  |  |  | (0.053) |
| Nonwhite |  |  | -0.085** |  |  |  |  | -0.077*** | -0.100*** |
| |  |  | (0.035) |  |  |  |  | (0.030) | (0.032) |
| Female |  |  | 0.008 |  |  |  |  | 0.015 | 0.006 |
| |  |  | (0.028) |  |  |  |  | (0.027) | (0.033) |
| Gay |  |  | 0.074*** |  |  |  |  | 0.053** | 0.063** |
| |  |  | (0.025) |  |  |  |  | (0.022) | (0.030) |
| Income |  |  |  | 0.126*** |  |  |  |  | 0.093* |
| |  |  |  | (0.047) |  |  |  |  | (0.056) |
| Ivy league |  |  |  | 0.092*** |  |  |  |  |  |
| |  |  |  | (0.032) |  |  |  |  |  |
| Education |  |  |  |  | 0.061 |  |  | 0.040 | 0.030 |
| |  |  |  |  | (0.057) |  |  | (0.053) | (0.057) |
| Age |  |  |  |  | -0.003** |  |  | -0.003** | -0.002 |
| |  |  |  |  | (0.001) |  |  | (0.001) | (0.001) |
| Urban |  |  |  |  | -0.044 |  |  | -0.002 | 0.023 |
| |  |  |  |  | (0.033) |  |  | (0.034) | (0.041) |
| Southern |  |  |  |  | 0.035 |  |  | 0.032 | 0.068** |
| |  |  |  |  | (0.027) |  |  | (0.028) | (0.029) |
| Neoliberal |  |  |  |  |  | -0.174*** |  |  |  |
| |  |  |  |  |  | (0.064) |  |  |  |
| Profits |  |  |  |  |  |  | 0.041 |  |  |
| |  |  |  |  |  |  | (0.039) |  |  |
| Gov. stay out |  |  |  |  |  |  | -0.023 |  |  |
| |  |  |  |  |  |  | (0.034) |  |  |
| Self help |  |  |  |  |  |  | -0.088** |  |  |
| |  |  |  |  |  |  | (0.045) |  |  |
| Disp. incentives |  |  |  |  |  |  | -0.123** |  |  |
| |  |  |  |  |  |  | (0.049) |  |  |
| Constant | 0.705*** | 0.641*** | 0.692*** | 0.600*** | 0.752*** | 0.581*** | 0.569*** | 0.742*** | 0.674*** |
| | (0.044) | (0.061) | (0.020) | (0.034) | (0.035) | (0.044) | (0.045) | (0.040) | (0.059) |
| N | 962 | 709 | 916 | 953 | 962 | 962 | 962 | 916 | 679 |
| R2 | 0.0108 | 0.0104 | 0.0468 | 0.0230 | 0.0494 | 0.0274 | 0.0458 | 0.0801 | 0.1160 |

## What changes
Across the 93 coefficients of Tables 1 and 4:

- Coefficients that change sign: 5.
  - Table 1, Model 1b, Education: 0.014 to -0.002
  - Table 1, Model 1b, Profits: 0.011 to -0.000
  - Table 4, Model A, Ideology: 0.006 to -0.008
  - Table 4, Model H, Urban: 0.007 to -0.002
  - Table 4, Model I, Theology: 0.014 to -0.001
- Largest change in a coefficient: 0.022.
- Significance stars that change: 16, 11 up and 5 down.
  - Table 1, Model 1a, Ideology: * to ** (p = 0.075 to 0.037)
  - Table 1, Model 1a, Income: * to ** (p = 0.051 to 0.034)
  - Table 1, Model 1a, Age: ** to * (p = 0.044 to 0.081)
  - Table 1, Model 2a, Age: *** to ** (p = 0.007 to 0.011)
  - Table 1, Model 3a, Income: ** to *** (p = 0.015 to 0.009)
  - Table 1, Model 1b, Ideology: none to * (p = 0.132 to 0.070)
  - Table 1, Model 1b, Self help: * to ** (p = 0.064 to 0.037)
  - Table 1, Model 2b, Self help: * to ** (p = 0.059 to 0.041)
  - Table 1, Model 3b, Income: ** to *** (p = 0.010 to 0.006)
  - Table 1, Model 3b, Self help: * to ** (p = 0.059 to 0.041)
  - Table 4, Model D, Income: ** to *** (p = 0.011 to 0.008)
  - Table 4, Model G, Self help: * to ** (p = 0.057 to 0.050)
  - Table 4, Model G, Disp. incentives: *** to ** (p = 0.009 to 0.011)
  - Table 4, Model H, Gay: *** to ** (p = 0.009 to 0.016)
  - Table 4, Model I, Income: none to * (p = 0.155 to 0.096)
  - Table 4, Model I, Age: * to none (p = 0.083 to 0.147)

## Cells that change
As published: the 2014 weight; Table 2 on all 992 rows. Final: the corrected weight; Table 2 on the 991 distinct respondents.

| Table | Model | Row | As published | Final |
|---|---|---|---|---|
| Table 1 | Model 1a | Ideology | -0.166* (0.093) | -0.178** (0.085) |
| Table 1 | Model 1a | Political party | 0.007 (0.071) | 0.016 (0.066) |
| Table 1 | Model 1a | Religiosity | -0.079* (0.045) | -0.079* (0.042) |
| Table 1 | Model 1a | Theology | 0.020 (0.060) | 0.012 (0.058) |
| Table 1 | Model 1a | Nonwhite | -0.098*** (0.032) | -0.094*** (0.031) |
| Table 1 | Model 1a | Female | 0.005 (0.031) | 0.008 (0.031) |
| Table 1 | Model 1a | Gay | 0.047 (0.031) | 0.049 (0.030) |
| Table 1 | Model 1a | Income | 0.108* (0.055) | 0.114** (0.054) |
| Table 1 | Model 1a | Ivy league | 0.159*** (0.051) | 0.164*** (0.053) |
| Table 1 | Model 1a | Education | 0.028 (0.058) | 0.010 (0.058) |
| Table 1 | Model 1a | Age | -0.003** (0.001) | -0.002* (0.001) |
| Table 1 | Model 1a | Urban | 0.018 (0.039) | 0.010 (0.037) |
| Table 1 | Model 1a | Southern | 0.073** (0.029) | 0.072** (0.029) |
| Table 1 | Model 1a | Neoliberal | -0.269*** (0.091) | -0.268*** (0.091) |
| Table 1 | Model 1a | Constant | 0.643*** (0.073) | 0.649*** (0.070) |
| Table 1 | Model 1a | R2 | 0.1978 | 0.1833 |
| Table 1 | Model 2a | Ideology | -0.043 (0.062) | -0.054 (0.061) |
| Table 1 | Model 2a | Religiosity | -0.039 (0.043) | -0.037 (0.042) |
| Table 1 | Model 2a | Nonwhite | -0.066** (0.029) | -0.060** (0.028) |
| Table 1 | Model 2a | Income | 0.123** (0.051) | 0.126** (0.049) |
| Table 1 | Model 2a | Ivy league | 0.125*** (0.041) | 0.122*** (0.043) |
| Table 1 | Model 2a | Age | -0.003*** (0.001) | -0.003** (0.001) |
| Table 1 | Model 2a | Southern | 0.039 (0.027) | 0.035 (0.027) |
| Table 1 | Model 2a | Neoliberal | -0.201*** (0.077) | -0.204*** (0.078) |
| Table 1 | Model 2a | Constant | 0.635*** (0.058) | 0.630*** (0.057) |
| Table 1 | Model 2a | R2 | 0.1288 | 0.1185 |
| Table 1 | Model 3a | Nonwhite | -0.070** (0.031) | -0.064** (0.030) |
| Table 1 | Model 3a | Income | 0.119** (0.049) | 0.124*** (0.047) |
| Table 1 | Model 3a | Ivy league | 0.114*** (0.042) | 0.108*** (0.042) |
| Table 1 | Model 3a | Neoliberal | -0.182*** (0.058) | -0.177*** (0.060) |
| Table 1 | Model 3a | Constant | 0.623*** (0.058) | 0.612*** (0.058) |
| Table 1 | Model 3a | R2 | 0.1193 | 0.1087 |
| Table 1 | Model 1b | Ideology | -0.137 (0.091) | -0.148* (0.082) |
| Table 1 | Model 1b | Political party | 0.047 (0.073) | 0.063 (0.067) |
| Table 1 | Model 1b | Religiosity | -0.076* (0.046) | -0.078* (0.042) |
| Table 1 | Model 1b | Theology | 0.032 (0.060) | 0.027 (0.058) |
| Table 1 | Model 1b | Nonwhite | -0.092*** (0.030) | -0.091*** (0.029) |
| Table 1 | Model 1b | Female | 0.015 (0.027) | 0.021 (0.027) |
| Table 1 | Model 1b | Income | 0.121** (0.052) | 0.130** (0.050) |
| Table 1 | Model 1b | Ivy league | 0.162*** (0.053) | 0.169*** (0.054) |
| Table 1 | Model 1b | Education | 0.014 (0.050) | -0.002 (0.051) |
| Table 1 | Model 1b | Age | -0.003** (0.001) | -0.002** (0.001) |
| Table 1 | Model 1b | Urban | 0.024 (0.037) | 0.017 (0.035) |
| Table 1 | Model 1b | Southern | 0.073*** (0.026) | 0.075*** (0.026) |
| Table 1 | Model 1b | Profits | 0.011 (0.052) | -0.000 (0.048) |
| Table 1 | Model 1b | Gov. stay out | 0.039 (0.057) | 0.061 (0.055) |
| Table 1 | Model 1b | Self help | -0.097* (0.052) | -0.101** (0.048) |
| Table 1 | Model 1b | Disp. incentives | -0.193*** (0.056) | -0.188*** (0.051) |
| Table 1 | Model 1b | Constant | 0.611*** (0.076) | 0.613*** (0.071) |
| Table 1 | Model 1b | R2 | 0.2320 | 0.2212 |
| Table 1 | Model 2b | Religiosity | -0.033 (0.035) | -0.027 (0.034) |
| Table 1 | Model 2b | Nonwhite | -0.061** (0.026) | -0.057** (0.025) |
| Table 1 | Model 2b | Income | 0.133*** (0.049) | 0.137*** (0.048) |
| Table 1 | Model 2b | Ivy league | 0.121*** (0.042) | 0.116*** (0.043) |
| Table 1 | Model 2b | Southern | 0.038 (0.027) | 0.035 (0.027) |
| Table 1 | Model 2b | Self help | -0.085* (0.045) | -0.089** (0.043) |
| Table 1 | Model 2b | Disp. incentives | -0.121** (0.048) | -0.115** (0.045) |
| Table 1 | Model 2b | Constant | 0.601*** (0.056) | 0.590*** (0.054) |
| Table 1 | Model 2b | R2 | 0.1467 | 0.1355 |
| Table 1 | Model 3b | Nonwhite | -0.065** (0.028) | -0.060** (0.027) |
| Table 1 | Model 3b | Income | 0.125** (0.049) | 0.130*** (0.047) |
| Table 1 | Model 3b | Ivy league | 0.120*** (0.043) | 0.114*** (0.043) |
| Table 1 | Model 3b | Self help | -0.085* (0.045) | -0.089** (0.043) |
| Table 1 | Model 3b | Disp. incentives | -0.122*** (0.047) | -0.115*** (0.044) |
| Table 1 | Model 3b | Constant | 0.610*** (0.055) | 0.599*** (0.053) |
| Table 1 | Model 3b | R2 | 0.1382 | 0.1285 |
| Table 2 | | Female | 586 | 585 |
| Table 2 | | White | 701 | 700 |
| Table 2 | | Associate's or some college | 330 | 329 |
| Table 2 | | $75k-$99k | 141 | 140 |
| Table 2 | | Lean Democrat | 284 | 283 |
| Table 4 | Model A | Ideology | 0.006 (0.058) | -0.008 (0.055) |
| Table 4 | Model A | Religiosity | -0.069 (0.053) | -0.066 (0.051) |
| Table 4 | Model A | Constant | 0.698*** (0.046) | 0.705*** (0.044) |
| Table 4 | Model A | R2 | 0.0145 | 0.0108 |
| Table 4 | Model B | Political party | -0.049 (0.057) | -0.048 (0.054) |
| Table 4 | Model B | Theology | 0.106 (0.070) | 0.083 (0.065) |
| Table 4 | Model B | Constant | 0.628*** (0.066) | 0.641*** (0.061) |
| Table 4 | Model B | R2 | 0.0183 | 0.0104 |
| Table 4 | Model C | Nonwhite | -0.093** (0.038) | -0.085** (0.035) |
| Table 4 | Model C | Female | 0.005 (0.030) | 0.008 (0.028) |
| Table 4 | Model C | Gay | 0.081*** (0.027) | 0.074*** (0.025) |
| Table 4 | Model C | Constant | 0.695*** (0.020) | 0.692*** (0.020) |
| Table 4 | Model C | R2 | 0.0540 | 0.0468 |
| Table 4 | Model D | Income | 0.125** (0.049) | 0.126*** (0.047) |
| Table 4 | Model D | Ivy league | 0.097*** (0.032) | 0.092*** (0.032) |
| Table 4 | Model D | Constant | 0.599*** (0.036) | 0.600*** (0.034) |
| Table 4 | Model D | R2 | 0.0211 | 0.0230 |
| Table 4 | Model E | Education | 0.080 (0.058) | 0.061 (0.057) |
| Table 4 | Model E | Urban | -0.039 (0.033) | -0.044 (0.033) |
| Table 4 | Model E | Southern | 0.040 (0.027) | 0.035 (0.027) |
| Table 4 | Model E | Constant | 0.748*** (0.036) | 0.752*** (0.035) |
| Table 4 | Model E | R2 | 0.0613 | 0.0494 |
| Table 4 | Model F | Neoliberal | -0.185*** (0.063) | -0.174*** (0.064) |
| Table 4 | Model F | Constant | 0.575*** (0.045) | 0.581*** (0.044) |
| Table 4 | Model F | R2 | 0.0297 | 0.0274 |
| Table 4 | Model G | Profits | 0.053 (0.042) | 0.041 (0.039) |
| Table 4 | Model G | Gov. stay out | -0.040 (0.036) | -0.023 (0.034) |
| Table 4 | Model G | Self help | -0.089* (0.047) | -0.088** (0.045) |
| Table 4 | Model G | Disp. incentives | -0.132*** (0.051) | -0.123** (0.049) |
| Table 4 | Model G | Constant | 0.559*** (0.047) | 0.569*** (0.045) |
| Table 4 | Model G | R2 | 0.0501 | 0.0458 |
| Table 4 | Model H | Nonwhite | -0.084*** (0.030) | -0.077*** (0.030) |
| Table 4 | Model H | Female | 0.013 (0.027) | 0.015 (0.027) |
| Table 4 | Model H | Gay | 0.058*** (0.022) | 0.053** (0.022) |
| Table 4 | Model H | Education | 0.056 (0.053) | 0.040 (0.053) |
| Table 4 | Model H | Urban | 0.007 (0.035) | -0.002 (0.034) |
| Table 4 | Model H | Southern | 0.035 (0.028) | 0.032 (0.028) |
| Table 4 | Model H | Constant | 0.738*** (0.040) | 0.742*** (0.040) |
| Table 4 | Model H | R2 | 0.0964 | 0.0801 |
| Table 4 | Model I | Political party | -0.019 (0.055) | -0.016 (0.054) |
| Table 4 | Model I | Theology | 0.014 (0.055) | -0.001 (0.053) |
| Table 4 | Model I | Nonwhite | -0.104*** (0.033) | -0.100*** (0.032) |
| Table 4 | Model I | Female | 0.004 (0.033) | 0.006 (0.033) |
| Table 4 | Model I | Gay | 0.061** (0.030) | 0.063** (0.030) |
| Table 4 | Model I | Income | 0.083 (0.058) | 0.093* (0.056) |
| Table 4 | Model I | Education | 0.048 (0.055) | 0.030 (0.057) |
| Table 4 | Model I | Age | -0.002* (0.001) | -0.002 (0.001) |
| Table 4 | Model I | Urban | 0.030 (0.042) | 0.023 (0.041) |
| Table 4 | Model I | Southern | 0.069** (0.029) | 0.068** (0.029) |
| Table 4 | Model I | Constant | 0.671*** (0.061) | 0.674*** (0.059) |
| Table 4 | Model I | R2 | 0.1337 | 0.1160 |
