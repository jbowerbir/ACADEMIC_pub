# Codebook: `data_survey_ep-subset.csv`

A lookup reference for the data used to replicate the tables and figures in Bower-Bir (2021), *Economia Politica* 38(1): 131–170: an unaltered subset of the Economic Justice Survey (version 7, SocialSci, November 2013 to April 2014), 992 respondents by 54 variables. Question wording is quoted from the survey as fielded.

Every scale except `age`, `race`, `party`, and `post_weight` is rescaled to run from 0 to 1 by (x − min) / (max − min), so a −3 to 3 scale becomes (x + 3) / 6. The table gives the raw coding; the file holds the rescaled value. The second column gives each variable's label as the article prints it.

## The respondent and the weight

| Column | In the article | Question (verbatim) | Answer options and raw coding | In the file |
|---|---|---|---|---|
| `row` | | | Row number in the full survey file, 1 to 992. The only unique identifier. | 1–992 |
| `id` | | | The vendor's respondent number, kept for matching to the full survey. Not a reliable key: 55 values are each carried by two different respondents (a numbering collision within one fielding batch), and one respondent's record is in the file twice, as `id` 1115 and 1157, identical in every answer. Use `row`. | integer |
| `post_weight` | | | The survey weight, raked in 2014 to population totals for gender, education, race, household income, and party (Census Bureau 2012 projections; Pew Research Center 2012 for party). | 0.07–29.95 |

## The dependent variable

| Column | In the article | Question (verbatim) | Answer options and raw coding | In the file |
|---|---|---|---|---|
| `corr_ideal_agency` | The dependent variable of Tables 1 and 4; Figure 6 | Built from the two batteries below. | For each respondent, the Pearson correlation across the 15 factors between the control rating and the ideal-importance rating, −1 to 1. Undefined (missing) for 29 respondents who gave every factor the same rating on one battery. | 0–1: (r + 1) / 2. The scripts convert it back to −1 to 1, the scale the article reports. |

## The predictors (Tables 1 and 4)

| Column | In the article | Question (verbatim) | Answer options and raw coding | In the file |
|---|---|---|---|---|
| `ideo_str` | Ideology | "Would you say you are liberal or conservative? Overall, I am…" | Very liberal 3, Liberal 2, Moderate, lean liberal 1, Moderate 0, Moderate, lean conservative −1, Conservative −2, Very conservative −3. | 0–1; **high = liberal** |
| `party_str` | Political party | "With which political party do you most closely identify? I am a…" | Strong Democrat 3, Democrat 2, Independent, lean Dem 1, Independent 0, Independent, lean Rep −1, Republican −2, Strong Republican −3. | 0–1; **high = Democrat** |
| `religiosity` | Religiosity | "How religious or spiritual would you say you are?" | Very religious/spiritual 4, Religious/Spiritual 3, Somewhat 2, Not very 1, Not at all 0. | 0–1; high = religious |
| `theology` | Theology | "How would you describe your theological outlook?" Asked of respondents who identify with a religion. | Liberal 1, Moderate 0, Fundamentalist −1; "Don't know" is missing. | 0–1; high = liberal; 727 answers |
| `nonwhite` | Nonwhite | "What is your race/ethnicity?" | White 0; any other answer 1. | 0 or 1 |
| `female` | Female | "What is your gender?" | Female 1, Male 0. | 0 or 1 |
| `gay_strict` | Gay | "How would you identify your sexual orientation?" | Bisexual or Homosexual/Gay/Lesbian 1, Heterosexual/Straight 0; "Other" is missing. | 0 or 1; 945 answers |
| `income_household` | Income | "What is your household's approximate annual income?" Full-time students were asked instead for their parents' or guardians' income, which is used in its place. | 19 brackets: 0 Less than $5,000, 1 $5,000–$7,499, 2 $7,500–$9,999, 3 $10,000–$12,499, 4 $12,500–$14,999, 5 $15,000–$19,999, 6 $20,000–$24,999, 7 $25,000–$29,999, 8 $30,000–$34,999, 9 $35,000–$39,999, 10 $40,000–$49,999, 11 $50,000–$59,999, 12 $60,000–$74,999, 13 $75,000–$84,999, 14 $85,000–$99,999, 15 $100,000–$124,999, 16 $125,000–$149,999, 17 $150,000–$174,999, 18 $175,000 or more. | 0–1: code / 18 |
| `school_ivy` | Ivy league | "At what kind of school did you get your undergraduate education?" and "…your graduate or professional education?" | 1 if either answer is "Ivy League school", else 0. | 0 or 1; 983 answers |
| `education` | Education | "What is the highest level of schooling that you have received?" | 0 8th grade or less, 1 Attended high school, 2 Completed high school (or equivalent), 3 Attended college, 4 Associate's or vocational degree, 5 Bachelor's degree, 6 Graduate or professional degree. | 0–1: code / 6 |
| `age` | Age | "How old are you?" | Years. | years, not rescaled |
| `urban` | Urban | "In what kind of community do you live?" | Five options, from Large city 4 to Rural community 0. | 0–1; high = large city |
| `south` | Southern | "In which state do you currently reside?" | 1 for Alabama, Arkansas, Florida, Georgia, Kentucky, Louisiana, Mississippi, North Carolina, South Carolina, Tennessee, Texas, Virginia, and West Virginia; else 0. | 0 or 1 |
| `diff_incentives` | Disp. incentives | "How much do you agree or disagree with the following statements? Only if differences in income and social standing are large enough is there an incentive for individual effort." | Strongly agree 3, Agree 2, Somewhat agree 1, Neither agree nor disagree 0, Somewhat disagree −1, Disagree −2, Strongly disagree −3; the 2014 cleaning reversed the sign. | 0–1; **high = disagree (anti-neoliberal)** |
| `gov_stayout` | Gov. stay out | Same stem: "Government should not intervene in economic matters." | As above, sign reversed. | 0–1; **high = disagree** |
| `help_self` | Self help | Same stem: "You have to take care of yourself first, and help others only if you have any energy left over." | As above, sign reversed. | 0–1; **high = disagree** |
| `profits_benefit` | Profits | Same stem: "The economy can only run if businesspeople make good profits. That benefits everyone in the end." | As above, sign reversed. | 0–1; **high = disagree** |
| `neoliberal` | Neoliberal; Figure 7 | The four statements above. | The average of the four sign-reversed items: 25 values from −3 (strongly agrees with all four, the most neoliberal) to 3 (strongly disagrees with all four). | 0–1; **high = anti-neoliberal**. Tables 1 and 4 enter it, and the four items, with the sign reversed, so that their coefficients read in the neoliberal direction. |

## The sample (Table 2)

| Column | In the article | Question (verbatim) | Answer options and raw coding | In the file |
|---|---|---|---|---|
| `race` | Table 2 | "What is your race/ethnicity?" | White 0, Black or African American 1, Latino 2, American Indian or Alaskan Native 3, Asian 4, Pacific Islander 5, Other 6. Table 2's "Other" is 3, 5, and 6. | 0–6, not rescaled |
| `party` | Table 2 | The party question above. | As `party_str`. Table 2 counts −3 and −2 as Republican, 2 and 3 as Democrat. | −3 to 3, not rescaled |

`female`, `education`, and `income_household` complete Table 2. Its income bands are codes 0–6 (under $25,000), 7–10, 11–12, 13–14, 15–16, and 17–18.

## The 15 factors (Figures 1–5, and the dependent variable)

Each factor has two columns, `<factor>_agency` and `<factor>_ideal`.

- **`_agency`**, "control over" in the figures: "How much control do you think people generally have over the following factors?" Total control 4, A great deal of control 3, Some control 2, A little control 1, No control at all 0. In the file, code / 4.
- **`_ideal`**, "ideal importance of": "How important should each of the following factors be in determining whether people in the U.S. get ahead or fall behind economically? That is, how important would these factors be to economic standing in your ideal society?" Very important 3, Important 2, Somewhat important 1, Neither important nor unimportant 0, Somewhat unimportant −1, Unimportant −2, Very unimportant −3. In the file, (code + 3) / 6.

| Factor | In the article | Wording |
|---|---|---|
| `attitude` | attitude | Their attitude |
| `wealth` | fam. wealth; family wealth | Coming from a wealthy family |
| `ambition` | ambition | Their drive and ambition |
| `parenteduc` | parents' educ. | Having educated parents |
| `race` | race | Their race |
| `stablefam` | fam. stability; family stability | Growing up in a stable family |
| `gender` | gender | Their gender |
| `health` | health | Whether they are healthy or not |
| `hardwork` | hard work | Their willingness to work hard |
| `econstate` | state of econ. | The state of the economy during their prime working years |
| `education` | education | Their level of education |
| `school` | schl. prestige; school prestige | Where they went to school |
| `connections` | connections | Having family connections |
| `iq` | intelligence | Their intelligence |
| `creativity` | creativity | Their creativity |
