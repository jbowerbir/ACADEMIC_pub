// =============================================================================
// script_original_stata-2014.do (the 2014 file policy_taxation.do, with 2026 annotations)
//
// The original Stata analysis for Bower-Bir (2022), "Desert and redistribution:
// Justice as a remedy for, and cause of, economic inequality", Policy Studies
// Journal 50(4): 757-795, as run in September 2014. Kept as a legacy record of
// the original analysis. The commands are exactly as they were; the only 2026
// additions are the comment lines that begin with "// [2026]", which name the
// published table each model feeds and explain two things a reader would
// otherwise have to discover.
//
// This file is not the way to reproduce the tables. It reads a Stata dataset
// that is not part of this package, and its plot blocks reference 2014 local
// paths. Use script_replication.R or script_replication.py, which rewrite
// every published model from this file and reproduce every printed cell.
//
// Structure
//   lines 1-106    variable construction (age squared, dummies, the collapsed
//                  tax outcome, interaction terms); 1-59 before the annotations
//   "BELIEF IN JUSTICE"      perceived justice without Definition: Table C1,
//                            plus unpublished variants
//   "DEFINITION OF JUSTICE"  Definition with each Z: Table 1 and Table C1
//                            Models B
//   "ADDITIONAL CONTROLS"    Table C2
//   "INTERACTIONS"           Table D1, then the marginal-effect plots of
//                            Figures D1(a)-(d) and D2(a)-(d) (the Brambor,
//                            Clark and Golder 2006 template)
//   the tail                 console scratch
//
// Two things to know
//   1. Lines 93-106 below (46-59 of the file as run in 2014) create variables named interact_*_scale but each `replace`
//      writes to the UNscaled name (interact_agency_def and so on). So every
//      interaction term below is Z * corr_ideal_agency_scale, where
//      corr_ideal_agency_scale = (corr_ideal_agency + 1)/2, while the main
//      effect of Definition is the scaled variable in two models (gov Model 1,
//      tax Model 3 of Table D1) and the raw one elsewhere. Both forms are the
//      same model; the article's Table D1 prints it as estimated here, and the
//      R and Python versions reproduce that exactly.
//   2. The float-equality tests (`married == float(.8)`, `progtaxes2_str == 4`)
//      work in Stata because Stata stores these as float and compares as float.
//      Copied into R or Python they match zero rows; see the two scripts.
//
// `svyset` on line 1 is not used by `areg`; the weighting enters through
// [pw=post_weight] on every command. "Definition" in the tables is
// corr_ideal_agency. Y_gov_fix_gap is gov_reducegap_str; Y_prog_tax is
// progtaxes2_str, built at lines 17-23.
// =============================================================================
svyset [pweight = post_weight]

gen age_2 = .
	replace age_2 = age * age

gen unemployed_now = .
	replace unemployed_now = 1 if employment == 0
	replace unemployed_now = 0 if employment == 3 | employment == 2 | employment == 1 | employment == -1 | employment == -2 | employment == -3 | employment == -4

gen married_bin = .
	replace married_bin = 1 if married == 1 | married == float(.8)
	replace married_bin = 0 if married == float(.6) | married == float(.4) | married == float(.2) | married == 0
	
gen black_latino = 0
	replace black_latino = 1 if race == 1 | race == 2

gen progtaxes2_str = .
	replace progtaxes2_str = progtaxes_str * 6
	replace progtaxes2_str = 0 if progtaxes2_str <= 3
	replace progtaxes2_str = 1 if progtaxes2_str == 4
	replace progtaxes2_str = 2 if progtaxes2_str == 5
	replace progtaxes2_str = 3 if progtaxes2_str == 6
	replace progtaxes2_str = progtaxes2_str / 3

gen interact_agency_def = .
	replace interact_agency_def =  agency_str * corr_ideal_agency

gen interact_justice_def = .
	replace interact_justice_def =  justice_str * corr_ideal_agency

gen interact_rich_def = .
	replace interact_rich_def =  desert_rich_tot * corr_ideal_agency

gen interact_americans_def = .
	replace interact_americans_def =  desert_americans_tot * corr_ideal_agency

gen interact_poor_def = .
	replace interact_poor_def =  desert_poor_tot * corr_ideal_agency

gen corr_ideal_real_scale = .
	replace corr_ideal_real_scale = (corr_ideal_real + 1) /2

gen corr_ideal_agency_scale = .
	replace corr_ideal_agency_scale = (corr_ideal_agency + 1) /2
	
gen interact_agency_def_scale = .
	replace interact_agency_def =  agency_str * corr_ideal_agency_scale

gen interact_justice_def_scale = .
	replace interact_justice_def =  justice_str * corr_ideal_agency_scale

gen interact_rich_def_scale = .
	replace interact_rich_def =  desert_rich_tot * corr_ideal_agency_scale

gen interact_americans_def_scale = .
	replace interact_americans_def =  desert_americans_tot * corr_ideal_agency_scale

gen interact_poor_def_scale = .
	replace interact_poor_def =  desert_poor_tot * corr_ideal_agency_scale

	
// [2026] Table C1 lives in this section. Of the models below, only the five
// [2026] with ideology and a single Z (or no Z) were published, as Table C1
// [2026] Models A, C, D, E; the rest were not printed.
//	BELIEF IN JUSTICE

// + controls
areg progtaxes2_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + agency
areg progtaxes2_str agency_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + justice
areg progtaxes2_str justice_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert
areg progtaxes2_str desert_rich_tot desert_americans_tot desert_poor_tot age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + controls + ideo
// [2026] -> Table C1, Y_prog_tax, Model A
areg progtaxes2_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + agency + ideo
// [2026] -> Table C1, Y_prog_tax, Model C
areg progtaxes2_str agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + justice + ideo
// [2026] -> Table C1, Y_prog_tax, Model D
areg progtaxes2_str justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert1 + ideo
areg progtaxes2_str desert_rich_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert2 + ideo
areg progtaxes2_str desert_americans_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert3 + ideo
areg progtaxes2_str desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert123 + ideo
// [2026] -> Table C1, Y_prog_tax, Model E
areg progtaxes2_str desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
	
	
// + controls
areg gov_reducegap_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + agency
areg gov_reducegap_str agency_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + justice
areg gov_reducegap_str justice_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert
areg gov_reducegap_str desert_rich_tot desert_americans_tot desert_poor_tot age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + controls + ideo
// [2026] -> Table C1, Y_gov_fix_gap, Model A
areg gov_reducegap_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + agency + ideo
// [2026] -> Table C1, Y_gov_fix_gap, Model C
areg gov_reducegap_str agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + justice + ideo
// [2026] -> Table C1, Y_gov_fix_gap, Model D
areg gov_reducegap_str justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert1 + ideo
areg gov_reducegap_str desert_rich_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert2 + ideo
areg gov_reducegap_str desert_americans_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert3 + ideo
areg gov_reducegap_str desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert + ideo
// [2026] -> Table C1, Y_gov_fix_gap, Model E
areg gov_reducegap_str desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)	

	
// [2026] Table 1 lives in this section (the models with Definition, one Z,
// [2026] and ideology), together with Table C1 Model B (Definition alone).
//	DEFINITION OF JUSTICE

// + def
areg progtaxes2_str corr_ideal_agency age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + ideo
// [2026] -> Table C1, Y_prog_tax, Model B
areg progtaxes2_str corr_ideal_agency ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + agency + ideo
// [2026] -> Table 1, Y_prog_tax, Model 1
areg progtaxes2_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice + ideo
// [2026] -> Table 1, Y_prog_tax, Model 2
areg progtaxes2_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + desert + ideo
// [2026] -> Table 1, Y_prog_tax, Model 3
areg progtaxes2_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)


// + def
areg gov_reducegap_str corr_ideal_agency age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + ideo
// [2026] -> Table C1, Y_gov_fix_gap, Model B
areg gov_reducegap_str corr_ideal_agency ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + agency + ideo
// [2026] -> Table 1, Y_gov_fix_gap, Model 1
areg gov_reducegap_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice + ideo
// [2026] -> Table 1, Y_gov_fix_gap, Model 2
areg gov_reducegap_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + desert + ideo
// [2026] -> Table 1, Y_gov_fix_gap, Model 3
areg gov_reducegap_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)



// [2026] Table C2: the Table 1 models plus three attitude controls
// [2026] (goodlife_future, gov_help_str, charity_str). The next comment is
// [2026] the 2014 note on which candidate controls were usable.
//	ADDITIONAL CONTROLS
//	goodlife_future gov_stayout gov_help_str gov_efficient_str charity_str		VARIABLE CORRUPTED	econ_self_future econ_future

// [2026] -> Table C2, Y_gov_fix_gap, Model A
areg gov_reducegap_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_gov_fix_gap, Model B
areg gov_reducegap_str corr_ideal_agency goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_gov_fix_gap, Model C
areg gov_reducegap_str corr_ideal_agency agency_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_gov_fix_gap, Model D
areg gov_reducegap_str corr_ideal_agency justice_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_gov_fix_gap, Model E
areg gov_reducegap_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)



// [2026] -> Table C2, Y_prog_tax, Model A
areg progtaxes2_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_prog_tax, Model B
areg progtaxes2_str corr_ideal_agency goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_prog_tax, Model C
areg progtaxes2_str corr_ideal_agency agency_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_prog_tax, Model D
areg progtaxes2_str corr_ideal_agency justice_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// [2026] -> Table C2, Y_prog_tax, Model E
areg progtaxes2_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)



// [2026] Table D1: each Table 1 model re-run as a baseline (not printed),
// [2026] then with the Definition x Z interaction added. See the header on
// [2026] which models carry the rescaled Definition.
//	INTERACTIONS	

// + def + agency
areg progtaxes2_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + agency + interact
// [2026] -> Table D1, Y_prog_tax, Model 1
areg progtaxes2_str corr_ideal_agency agency_str interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice
areg progtaxes2_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + justice + interact
// [2026] -> Table D1, Y_prog_tax, Model 2
areg progtaxes2_str corr_ideal_agency justice_str interact_justice_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + desert
areg progtaxes2_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + desert + interact
// [2026] -> Table D1, Y_prog_tax, Model 3 (Definition rescaled here)
areg progtaxes2_str corr_ideal_agency_scale desert_rich_tot desert_americans_tot desert_poor_tot interact_rich_def interact_americans_def interact_poor_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)


// + def + agency
areg gov_reducegap_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + agency + interact
// [2026] -> Table D1, Y_gov_fix_gap, Model 1 (Definition rescaled here)
areg gov_reducegap_str corr_ideal_agency_scale agency_str interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice
areg gov_reducegap_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + justice + interact
// [2026] -> Table D1, Y_gov_fix_gap, Model 2
areg gov_reducegap_str corr_ideal_agency justice_str interact_justice_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + def + desert
areg gov_reducegap_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + desert + interact
// [2026] -> Table D1, Y_gov_fix_gap, Model 3
areg gov_reducegap_str corr_ideal_agency desert_rich_tot interact_rich_def desert_americans_tot interact_americans_def desert_poor_tot interact_poor_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)


// [2026] Marginal-effect plots, Figures D1(a)-(d). Each block below is the
// [2026] Brambor-Clark-Golder template: it re-fits the interaction model with
// [2026] `reg ..., cluster(state)` (not areg: no state fixed effects, clustered
// [2026] rather than HC1 errors), reads a separate Working_interaction.dta, and
// [2026] writes a log and a graph to 2014 local paths. None of it runs as is.
// [2026] Figure D1(d): X | Z = agency -> Y_prog_tax (this block).
// X|Zagency => Yprog_tax
// GOLDER INTERACTION CODE - PROG TAX
// Def of Desert (X) => Support for Progessive Taxation (Y), depending on Perception of Agency (Z)

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg progtaxes2_str corr_ideal_agency agency_str interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-2.05;

gen pipe = "|";

egen tag_justice = tag(justice_str);

gen yline=0;

graph twoway hist agency_str, start(-.0208375) width(0.041675) percent color(gs14) yaxis(2)
	||	line conbx MVZ, clpattern(solid) clwidth(mediumthick) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .167 .333 .5 .667 .833 1, nogrid labsize(2.25))
		ylabel(-3 -2 -1 0 1, axis(1) nogrid labsize(2.25))
		ylabel(0 5 10 15 20 25, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Belief that peoples' economic standing is within their control", size(2.5))
		ytitle("Marginal effect of definition", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

	//	log close

	

// [2026] Figure D1(a): X | Z = agency -> Y_gov_fix_gap.
// X|Zagency => Ygov_fix_gap
// GOLDER INTERACTION CODE - PROG TAX
// Def of Desert (X) => Support for Intervention (Y), depending on Perception of Agency (Z)

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg gov_reducegap_str corr_ideal_agency agency_str interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-2.05;

gen pipe = "|";

egen tag_justice = tag(justice_str);

gen yline=0;

graph twoway hist agency_str, start(-.0208375) width(0.041675) percent color(gs14) yaxis(2)
	||	line conbx MVZ, clpattern(solid) clwidth(mediumthick) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .167 .333 .5 .667 .833 1, nogrid labsize(2.25))
		ylabel(-3 -2 -1 0 1, axis(1) nogrid labsize(2.25))
		ylabel(0 5 10 15 20 25, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Belief that peoples' economic standing is within their control", size(2.5))
		ytitle("Marginal effect of definition", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

	//	log close



// [2026] Figure D1(b): X | Z = justice -> Y_gov_fix_gap.
// X|Zjustice => Ygov_fix_gap
// GOLDER INTERACTION CODE - GOV INTERVENTION
// Def of Desert (X) => Support for Intervention (Y), depending on Perception of Justice (Z)

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg gov_reducegap_str corr_ideal_agency justice_str interact_justice_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-2.05;

gen pipe = "|";

egen tag_justice = tag(justice_str);

gen yline=0;

graph twoway hist justice_str, start(-.0208375) width(0.041675) percent color(gs14) yaxis(2)
	||	line conbx MVZ, clpattern(solid) clwidth(mediumthick) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .167 .333 .5 .667 .833 1, nogrid labsize(2.25))
		ylabel(-5 -4 -3 -2 -1 0 1, axis(1) nogrid labsize(2.25))
		ylabel(0 5 10 15 20 25, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Belief that economic desert is rewarded", size(2.5))
		ytitle("Marginal effect of definition", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

	//	log close

	

// [2026] Figure D1(c): X | Z = rich deserve -> Y_gov_fix_gap.
// X|Zrich_deserve => Ygov_fix_gap
// GOLDER INTERACTION CODE - GOV INTERVENTION
// Def of Desert (X) => Support for Intervention (Y), depending on Perception of Rich Deservingness (Z)

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg gov_reducegap_str corr_ideal_agency desert_rich_tot interact_rich_def desert_americans_tot interact_americans_def desert_poor_tot interact_poor_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-2.05;

gen pipe = "|";

egen tag_rich = tag(desert_rich_tot);

gen yline=0;

graph twoway hist desert_rich_tot, start(-.0208333333) width(0.0416666667) percent color(gs14) yaxis(2)
	||	line conbx MVZ, clpattern(solid) clwidth(mediumthick) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .167 .333 .5 .667 .833 1, nogrid labsize(2.25))
		ylabel(-8 -7 -6 -5 -4 -3 -2 -1 0 1, axis(1) nogrid labsize(2.25))
		ylabel(0 3 6 9 12 15, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Belief that rich Americans deserve their wealth", size(2.5))
		ytitle("Marginal effect of definition", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

		// log close

		

// [2026] The four blocks from here to the console scratch reverse the roles
// [2026] of X and Z (marginal effect of Z conditional on Definition): Figures
// [2026] D2(d), D2(a), D2(b), D2(c) in that order. The 2014 comments record
// [2026] the doubt the article voices about them in Appendix D.2.
// Zagency|X => Yprog_tax
// GOLDER INTERACTION CODE - GOV INTERVENTION
// Perception of Justice (Z) => Support for Intervention (Y), depending on Def of Desert (X)
// Doesn't make theoretical sense...

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg progtaxes2_str agency_str corr_ideal_agency interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-.9;

gen pipe = "|";

egen tag_corr_ideal_agency = tag(corr_ideal_agency);

gen yline=0;

graph twoway hist corr_ideal_agency, width(0.01) percent color(gs14) yaxis(2)
	||	scatter where corr_ideal_agency if tag_corr_ideal_agency,
		plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)
	||	line conbx MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, nogrid labsize(2.25))
		ylabel(-1 0 1 2 3, axis(1) nogrid labsize(2.25))
		ylabel(0 2 4 6 8, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Importance of agency to definition of desert", size(2.5))
		ytitle("Marginal effect of belief in economic agency", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

	//	log close

		

// Zagency|X => Ygov_fix_gap
// GOLDER INTERACTION CODE - PROG TAX
// depending on Perception of Agency (Z) => Support for Intervention (Y), Def of Desert (X)

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg gov_reducegap_str agency_str corr_ideal_agency interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-.9;

gen pipe = "|";

egen tag_corr_ideal_agency = tag(corr_ideal_agency);

gen yline=0;

graph twoway hist corr_ideal_agency, width(0.01) percent color(gs14) yaxis(2)
	||	scatter where corr_ideal_agency if tag_corr_ideal_agency,
		plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)
	||	line conbx MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, nogrid labsize(2.25))
		ylabel(-1 0 1 2 3, axis(1) nogrid labsize(2.25))
		ylabel(0 2 4 6 8, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Importance of agency to definition of desert", size(2.5))
		ytitle("Marginal effect of belief in economic agency", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

	// log close



// Zjustice|X => Ygov_fix_gap
// GOLDER INTERACTION CODE
// Perception of Justice (Z) => Support for Intervention (Y), depending on Def of Desert (X)
// Doesn't make theoretical sense...

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg gov_reducegap_str justice_str corr_ideal_agency interact_justice_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-.9;

gen pipe = "|";

egen tag_corr_ideal_agency = tag(corr_ideal_agency);

gen yline=0;

graph twoway hist corr_ideal_agency, width(0.01) percent color(gs14) yaxis(2)
	||	scatter where corr_ideal_agency if tag_corr_ideal_agency,
		plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)
	||	line conbx MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, nogrid labsize(2.25))
		ylabel(-1 0 1 2 3 4, axis(1) nogrid labsize(2.25))
		ylabel(0 2 4 6 8, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Importance of agency to definition of desert", size(2.5))
		ytitle("Marginal effect of belief that economic desert is rewarded", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

	//	log close

	

// Zrich_deserve|X => Ygov_fix_gap
// GOLDER INTERACTION CODE
// Perception of Rich Deserve (Z) => Support for Intervention (Y), depending on Def of Desert (X)
// Doesn't make theoretical sense...

* ***************************************************************** *;
* ***************************************************************** *;
* Purpose: Do-file to produce a marginal effect plot for *;
* X when the interaction model is: *;
* Y = b0 + b1X + b2Z + b3XZ + e *;
* Input File: working.dta *;
* Output File: interaction1.log *;
* **************************************************************** *;
* **************************************************************** *;

#delimit ;
log using "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Analysis\interaction1.log", replace;
set more off;

use "C:\Users\jbowerbi\Documents\My Box Files\Research\Dissertation\Data and methods\Surveys\Survey\Data\Working_interaction.dta";

set obs 10000;

reg gov_reducegap_str desert_rich_tot corr_ideal_agency interact_rich_def desert_americans_tot interact_americans_def desert_poor_tot interact_poor_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], cluster(state);

matrix b=e(b);
matrix V=e(V);

scalar b1=b[1,1];
scalar b3=b[1,3];

scalar varb1=V[1,1];
scalar varb3=V[3,3];

scalar covb1b3=V[1,3];

scalar list b1 b3 varb1 varb3 covb1b3;

* **************************************************************** *;
* Calculate data necessary for top marginal effect plot. *;
* **************************************************************** *;

generate MVZ=((_n-1)/100);

replace MVZ=. if _n>101;

gen conbx=b1+b3*MVZ if _n<101;

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101;

gen ax=1.96*consx;

gen upperx=conbx+ax;

gen lowerx=conbx-ax;

gen where=-.9;

gen pipe = "|";

egen tag_corr_ideal_agency = tag(corr_ideal_agency);

gen yline=0;

graph twoway hist corr_ideal_agency, width(0.01) percent color(gs14) yaxis(2)
	||	scatter where corr_ideal_agency if tag_corr_ideal_agency,
		plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)
	||	line conbx MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)
	||	line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black)
	||	line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid)
	||	,
		xlabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, nogrid labsize(2.25))
		ylabel(-1 0 1 2 3 4 5 6 7, axis(1) nogrid labsize(2.25))
		ylabel(0 2 4 6 8, axis(2) nogrid labsize(2.25))
		yscale(noline alt)
		yscale(noline alt axis(2))
		xscale(noline)
		legend(off)
		xtitle("Importance of agency to definition of desert", size(2.5))
		ytitle("Marginal effect of belief that rich Americans deserve their wealth", axis(1) size(2.5))
		ytitle("Percentage of observations", axis(2) size(2.5) orientation(rvertical))
		xsca(titlegap(2))
		ysca(titlegap(2))
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

	//	log close
	

// [2026] Console scratch from 2014: kernel densities, a command fragment,
// [2026] and four models repeated from above. Kept because nothing in this
// [2026] file has been removed; nothing here feeds a published table.
kdens corr_ideal_agency if party > 0 [pweight = post_weight]
kdens corr_ideal_agency if party < 0 [pweight = post_weight]
kdens corr_ideal_agency if ideo > 0 [pweight = post_weight]
kdens corr_ideal_agency if ideo < 0 [pweight = post_weight]

kdens justice_str if ideo > 0 [pweight = post_weight]
kdens justice_str if ideo < 0 [pweight = post_weight]

, at(x_axis_6) gen(kDemY)


areg gov_reducegap_str desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household diff_large goodlife_future children_sol stability_str gov_efficient gov_help_str charity [pw=post_weight], absorb(state)
areg gov_reducegap_str justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household diff_large goodlife_future children_sol stability_str gov_efficient gov_help_str charity [pw=post_weight], absorb(state)
areg gov_reducegap_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household diff_large goodlife_future children_sol stability_str gov_efficient gov_help_str charity [pw=post_weight], absorb(state)

areg progtaxes2_str desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household diff_large goodlife_future children_sol stability_str gov_efficient gov_help_str charity [pw=post_weight], absorb(state)
