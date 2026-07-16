# Economic Justice Survey (v7)

Survey data from the Economic Justice survey fielded via Qualtrics in November 2013. N=992 respondents, nationally representative sample (weighted). This dataset supports multiple published papers:

- Bower-Bir (2021) "Earning Our Place, More or Less" *Economia Politica* 38(1)
- Bower-Bir (2022) "Desert and Redistribution" *Policy Studies Journal* 50(4)

## Files

- `economic_justice_v7_nonstandardized.csv` — De-identified survey responses. 992 rows, 229 columns. Original (non-standardized) scale values. Good for descriptive work; **cannot reproduce the published regression tables** (no survey weights, unstandardized scales).
- `economic_justice_v7_analysis-weighted.csv` — **The analysis file. Use this to replicate published tables.** De-identified. 992 rows, 241 columns. Variables standardized to [0,1] as the papers describe, and carries the six survey-weight columns — including `post_weight`, which every published regression uses (`[pw=post_weight]`). Derived from `Economic-Justice_v7_2014-04-08_E_WORKING.dta` by `build_analysis_csv.py`; added 2026-07-16 after it emerged that the tables could not be reproduced from the non-standardized release alone.
- `build_analysis_csv.py` — Builds the above from the source Stata file. Documents exactly which columns are dropped for de-identification.
- `Survey_v7_codebook_2014-04-08.xlsx` — Full codebook with variable names, question text, and response options.

## De-identification

The following columns were removed from the public release: `participant_id` (Qualtrics panel ID), `startdate`, `enddate`, `starttime`, `endtime` (survey timestamps), `pagesequence`, `visitedpages`, `pageprogression` (survey navigation metadata). The anonymous `id` column and `timetaken` (for data quality checks) are retained.

## Citation

If you use this data, please cite the relevant paper(s):

> Bower-Bir, J.S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal*, 50(4), 757-795. https://doi.org/10.1111/psj.12439

> Bower-Bir, J.S. (2021). Earning our place, more or less: Responsibility's flexible relationship with desert in socioeconomic standing. *Economia Politica*, 38(1), 131-170. https://doi.org/10.1007/s40888-020-00201-9

## Survey Design

The survey contains experimental conditions for multiple research questions:
- 15 factors rated for importance in determining wealth/poverty (the desert definitions battery)
- Redistributive policy preferences (income differences, government responsibility, tax progressivity)
- Perceptions of rich and poor deservingness
- Demographics, political ideology, religiosity, economic assessments
- "Amanda" vignette conditions (sympathetic/neutral/unsympathetic framing for rich/poor characters)

See the codebook for full details on all variables and experimental conditions.
