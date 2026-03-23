# Economic Justice Survey (v7)

Survey data from the Economic Justice survey fielded via Qualtrics in November 2013. N=992 respondents, nationally representative sample (weighted). This dataset supports multiple published papers:

- Bower-Bir (2020) "Earning Our Place, More or Less" *Economia Politica*
- Bower-Bir (2021) "Desert and Redistribution: Justice as Remedy for, and Cause of, Inequality" *Policy Studies Journal*

## Files

- `economic_justice_v7_nonstandardized.csv` — De-identified survey responses. 992 rows, 229 columns. Original (non-standardized) scale values.
- `Survey_v7_codebook_2014-04-08.xlsx` — Full codebook with variable names, question text, and response options.

## De-identification

The following columns were removed from the public release: `participant_id` (Qualtrics panel ID), `startdate`, `enddate`, `starttime`, `endtime` (survey timestamps), `pagesequence`, `visitedpages`, `pageprogression` (survey navigation metadata). The anonymous `id` column and `timetaken` (for data quality checks) are retained.

## Citation

If you use this data, please cite the relevant paper(s):

> Bower-Bir, J.S. (2021). Desert and redistribution: Justice as a remedy for, and cause of, inequality. *Policy Studies Journal*, 49(3), 820-844.

> Bower-Bir, J.S. (2020). Earning our place, more or less: How Americans define what the rich and poor deserve. *Economia Politica*, 37(3), 861-878.

## Survey Design

The survey contains experimental conditions for multiple research questions:
- 15 factors rated for importance in determining wealth/poverty (the desert definitions battery)
- Redistributive policy preferences (income differences, government responsibility, tax progressivity)
- Perceptions of rich and poor deservingness
- Demographics, political ideology, religiosity, economic assessments
- "Amanda" vignette conditions (sympathetic/neutral/unsympathetic framing for rich/poor characters)

See the codebook for full details on all variables and experimental conditions.
