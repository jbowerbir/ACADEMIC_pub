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
areg progtaxes2_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + agency + ideo
areg progtaxes2_str agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + justice + ideo
areg progtaxes2_str justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert1 + ideo
areg progtaxes2_str desert_rich_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert2 + ideo
areg progtaxes2_str desert_americans_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert3 + ideo
areg progtaxes2_str desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert123 + ideo
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
areg gov_reducegap_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + agency + ideo
areg gov_reducegap_str agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + justice + ideo
areg gov_reducegap_str justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert1 + ideo
areg gov_reducegap_str desert_rich_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert2 + ideo
areg gov_reducegap_str desert_americans_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert3 + ideo
areg gov_reducegap_str desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + desert + ideo
areg gov_reducegap_str desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)	

	
//	DEFINITION OF JUSTICE

// + def
areg progtaxes2_str corr_ideal_agency age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + ideo
areg progtaxes2_str corr_ideal_agency ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + agency + ideo
areg progtaxes2_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice + ideo
areg progtaxes2_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + desert + ideo
areg progtaxes2_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)


// + def
areg gov_reducegap_str corr_ideal_agency age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + ideo
areg gov_reducegap_str corr_ideal_agency ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + agency + ideo
areg gov_reducegap_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice + ideo
areg gov_reducegap_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + desert + ideo
areg gov_reducegap_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)



//	ADDITIONAL CONTROLS
//	goodlife_future gov_stayout gov_help_str gov_efficient_str charity_str		VARIABLE CORRUPTED	econ_self_future econ_future

areg gov_reducegap_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg gov_reducegap_str corr_ideal_agency goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg gov_reducegap_str corr_ideal_agency agency_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg gov_reducegap_str corr_ideal_agency justice_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg gov_reducegap_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)



areg progtaxes2_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg progtaxes2_str corr_ideal_agency goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg progtaxes2_str corr_ideal_agency agency_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg progtaxes2_str corr_ideal_agency justice_str goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

areg progtaxes2_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot goodlife_future gov_help_str charity_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)



//	INTERACTIONS	

// + def + agency
areg progtaxes2_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + agency + interact
areg progtaxes2_str corr_ideal_agency agency_str interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice
areg progtaxes2_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + justice + interact
areg progtaxes2_str corr_ideal_agency justice_str interact_justice_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + desert
areg progtaxes2_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + desert + interact
areg progtaxes2_str corr_ideal_agency_scale desert_rich_tot desert_americans_tot desert_poor_tot interact_rich_def interact_americans_def interact_poor_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)


// + def + agency
areg gov_reducegap_str corr_ideal_agency agency_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + agency + interact
areg gov_reducegap_str corr_ideal_agency_scale agency_str interact_agency_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)

// + def + justice
areg gov_reducegap_str corr_ideal_agency justice_str ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + justice + interact
areg gov_reducegap_str corr_ideal_agency justice_str interact_justice_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
	
// + def + desert
areg gov_reducegap_str corr_ideal_agency desert_rich_tot desert_americans_tot desert_poor_tot ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)
// + def + desert + interact
areg gov_reducegap_str corr_ideal_agency desert_rich_tot interact_rich_def desert_americans_tot interact_americans_def desert_poor_tot interact_poor_def ideo_str age age_2 female nonwhite married_bin unemployed_now education income_household [pw=post_weight], absorb(state)


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
