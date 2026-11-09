# Economic Justice Survey (version 7)

A national survey of American adults on economic desert, justice, and redistribution, fielded for me by SocialSci, an online survey panel company, between November 2013 and April 2014. The 2014 cleaning kept 992 records, which hold 991 respondents, weighted by raking to 2012 Census Bureau and Pew Research Center totals. The data behind two published articles and my dissertation:

- Bower-Bir, J. S. (2021). Earning our place, more or less: Responsibility's flexible relationship with desert in socioeconomic standing. *Economia Politica* 38(1): 131–170. https://doi.org/10.1007/s40888-020-00201-9
- Bower-Bir, J. S. (2022). Desert and redistribution: Justice as a remedy for, and cause of, economic inequality. *Policy Studies Journal* 50(4): 757–795. https://doi.org/10.1111/psj.12439

## What is public now

Each article's replication package holds the columns that article uses, cut unaltered from the survey's analysis file, with a codebook: 27 columns in [`desert-redistribution-psj-2021/`](../desert-redistribution-psj-2021/) and 54 in [`earning-our-place-ecopol-2020/`](../earning-our-place-ecopol-2020/). Row numbers (`row`) mean the same respondent in both.

## The full survey

The full survey is being deposited at IU DataCORE and is not in this repository; its DOI will be added here and to both packages when it is issued. The deposit holds the raw data as delivered (1,390 responses, de-identified), the cleaning programs in R and Python (the 2014 Stata chain written out statement by statement, with identical output), the cleaned data after each step (cleaned; weighted; scaled; scaled and weighted, the analysis file), the 2014 survey weight as published and a corrected one, the instrument as fielded with its Qualtrics source, the quota design, a codebook, and a provenance record.

## De-identification

Removed from the raw data and everything built from it: the vendor's panel ID, four timestamps, and three survey-navigation fields. Kept: the vendor's anonymous `id` (not a unique key; use `row`), the completion time used by the exclusion rule, `state`, and three open-text fields that hold descriptors only.

## Citation and license

Cite the article you use, and the deposit by the DOI on its record. The packages and the deposit are released under CC BY 4.0.
