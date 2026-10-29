svyset [pweight = post_weight]

gen neoliberal_cons = neoliberal * -1

gen class_change_abs = .
	replace class_change_abs = abs((class_change * 2) - 1)
	
gen income_quintile = .
	replace income_quintile = 1 if (income_household * 18) < 7
	replace income_quintile = 2 if (income_household * 18) >= 7 & (income_household * 18) < 11
	replace income_quintile = 3 if (income_household * 18) >= 11 & (income_household * 18) < 13
	replace income_quintile = 4 if (income_household * 18) >= 13 & (income_household * 18) < 15
	replace income_quintile = 5 if (income_household * 18) >= 15	
gen income_quintile_medDist = .
	replace income_quintile_medDist = (income_quintile - 3) /2
gen income_quintile_medDist_abs = .
	replace income_quintile_medDist_abs = abs(income_quintile_medDist)
	replace income_quintile = (income_quintile - 1) /4

gen income_hh_sqr = .
	replace income_hh_sqr = income_household * income_household
	
* FOR WHOM DOES JUSTICE REQUIRE AGENCY?
* Correltaion between ideal importance of factor and control over factor


svy: mean corr_ideal_agency

kdens corr_ideal_agency [pweight = post_weight], at(x_axis_100) gen(kCorrIdealAgencyY)
	drop x_axis_100 kCorrIdealAgencyY

svy: reg corr_ideal_agency ideo_str party_str religiosity theology class_change income_household education school_ivy unemployed divorce single_parent goodlife_future nonwhite female gay_strict age urban south neoliberal	// this one
svy: reg corr_ideal_agency ideo_str party_str religiosity theology class_change income_household education nonwhite female gay_strict age urban south neoliberal
svy: reg corr_ideal_agency ideo_str party_str religiosity theology class_change education nonwhite female gay_strict age urban south neoliberal	
svy: reg corr_ideal_agency ideo_str party_str religiosity theology income_household education nonwhite female gay_strict age urban south neoliberal	

svy: reg corr_ideal_agency ideo_str party_str religiosity theology nonwhite female gay_strict income_household education age urban south neoliberal	// this one
svy: reg corr_ideal_agency ideo_str religiosity nonwhite income_household age south neoliberal	// this one
svy: reg corr_ideal_agency nonwhite income_household age neoliberal	// this one












svy: reg corr_ideal_agency income_household class_change party_str ideo_str nonwhite female gay_strict divorce urban religiosity
svy: reg corr_ideal_agency income_household school_private class_change fulltime party_str ideo_str education nonwhite female gay_strict divorce single_parent urban south religiosity
svy: reg corr_ideal_agency income_household class_change unemployed party_str ideo_str neoliberal education nonwhite female gay_strict divorce single_parent urban south religiosity
svy: reg corr_ideal_agency income_household class_change unemployed neoliberal education nonwhite female gay_strict divorce single_parent urban south religiosity protestant
svy: reg corr_ideal_agency income_household class_change unemployed ideo_str education nonwhite female gay_strict divorce single_parent urban south religiosity


graph twoway scatter corr_ideal_agency income_household, jitter(8)
graph twoway scatter corr_ideal_agency income_household [w=post_weight]
graph twoway scatter corr_ideal_agency party_str [w=post_weight], jitter(8)

graph twoway scatter corr_ideal_agency theology, jitter(8)
graph twoway scatter corr_ideal_agency theology [w=post_weight]
graph twoway scatter corr_ideal_agency theology [w=post_weight], jitter(8)

graph twoway scatter corr_ideal_agency religiosity, jitter(8)
graph twoway scatter corr_ideal_agency religiosity [w=post_weight]
graph twoway scatter corr_ideal_agency religiosity [w=post_weight], jitter(8)
