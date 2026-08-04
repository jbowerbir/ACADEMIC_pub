svyset [pweight = post_weight]


* WHAT FACTORS _DO_ MATTER TO ECONOMIC STANDING?

// create variable "x_axis_5" with values 0, .25, .5, .75, 1
// create variable "x_axis_7" with values 0, .1666667, .3333333, .5, .6666667, .8333333, 1

svy: mean ambition_real
svy: mean attitude_real
svy: mean connections_real
svy: mean creativity_real
svy: mean education_real
svy: mean stablefam_real
svy: mean wealth_real
svy: mean gender_real
svy: mean hardwork_real
svy: mean health_real
svy: mean iq_real
svy: mean parenteduc_real
svy: mean race_real
svy: mean school_real
svy: mean econstate_real

kdensity attitude_real, at(x_axis) gen(kAttitudeX kAttitudeY)
kdensity ambition_real, at(x_axis) gen(kAmbitionX kAmbitionY)
kdensity hardwork_real, at(x_axis) gen(kHarworkX kHardworkY)
kdensity education_real, at(x_axis) gen(kEducationX kEducationY)
kdensity iq_real, at(x_axis) gen(kIqX kIqY)
kdensity health_real, at(x_axis) gen(kHealthX kHealthY)
kdensity wealth_real, at(x_axis) gen(kWealthX kWealthY)
kdensity econstate_real, at(x_axis) gen(kEconstateX kEconstateY)
kdensity connections_real, at(x_axis) gen(kConnectionsX kConnectionsY)
kdensity creativity_real, at(x_axis) gen(kCreativityX kCreativityY)
kdensity parenteduc_real, at(x_axis) gen(kParenteducX kParenteducY)
kdensity stablefam_real, at(x_axis) gen(kStablefamX kStablefamY)
kdensity school_real, at(x_axis) gen(kSchoolX kSchoolY)
kdensity race_real, at(x_axis) gen(kRaceX kRaceY)
kdensity gender_real, at(x_axis) gen(kGenderX kGenderY)
	drop kAttitudeX kAttitudeY kAmbitionX kAmbitionY kHarworkX kHardworkY kHealthX kHealthY kEducationX kEducationY kSchoolX kSchoolY kIqX kIqY kCreativityX kCreativityY kWealthX kWealthY kParenteducX kParenteducY kRaceX kRaceY kStablefamX kStablefamY kGenderX kGenderY kEconstateX kEconstateY kConnectionsX kConnectionsY

kdens ambition_real [pweight = post_weight], at(x_axis_7) gen(kAmbitionY)
kdens attitude_real [pweight = post_weight], at(x_axis_7) gen(kAttitudeY)
kdens connections_real [pweight = post_weight], at(x_axis_7) gen(kConnectionsY)
kdens creativity_real [pweight = post_weight], at(x_axis_7) gen(kCreativityY)
kdens education_real [pweight = post_weight], at(x_axis_7) gen(kEducationY)
kdens stablefam_real [pweight = post_weight], at(x_axis_7) gen(kFamStabY)
kdens wealth_real [pweight = post_weight], at(x_axis_7) gen(kFamWealthY)
kdens gender_real [pweight = post_weight], at(x_axis_7) gen(kGenderY)
kdens hardwork_real [pweight = post_weight], at(x_axis_7) gen(kHardWorkY)
kdens health_real [pweight = post_weight], at(x_axis_7) gen(kHealthY)
kdens iq_real [pweight = post_weight], at(x_axis_7) gen(kIntelligenceY)
kdens parenteduc_real [pweight = post_weight], at(x_axis_7) gen(kParentEducY)
kdens race_real [pweight = post_weight], at(x_axis_7) gen(kRaceY)
kdens school_real [pweight = post_weight], at(x_axis_7) gen(kSchoolY)
kdens econstate_real [pweight = post_weight], at(x_axis_7) gen(kStateEconY)
	drop kAmbitionY kAttitudeY kConnectionsY kCreativityY kEducationY kFamStabY kFamWealthY kGenderY kHardWorkY kHealthY kIntelligenceY kParentEducY kRaceY kSchoolY kStateEconY


svy: mean corr_ideal_real

kdens corr_ideal_real [pweight = post_weight], at(x_axis_10) gen(kCorrIdealRealY)
	drop kCorrIdealRealY


* WHAT FACTORS _SHOULD_ MATTER TO ECONOMIC STANDING?

// create variable "x_axis_5" with values 0, .25, .5, .75, 1
// create variable "x_axis_7" with values 0, .1666667, .3333333, .5, .6666667, .8333333, 1

svy: mean ambition_ideal
svy: mean attitude_ideal
svy: mean connections_ideal
svy: mean creativity_ideal
svy: mean education_ideal
svy: mean stablefam_ideal
svy: mean wealth_ideal
svy: mean gender_ideal
svy: mean hardwork_ideal
svy: mean health_ideal
svy: mean iq_ideal
svy: mean parenteduc_ideal
svy: mean race_ideal
svy: mean school_ideal
svy: mean econstate_ideal

kdensity attitude_ideal, at(x_axis) gen(kAttitudeX kAttitudeY)
kdensity ambition_ideal, at(x_axis) gen(kAmbitionX kAmbitionY)
kdensity hardwork_ideal, at(x_axis) gen(kHarworkX kHardworkY)
kdensity health_ideal, at(x_axis) gen(kHealthX kHealthY)
kdensity education_ideal, at(x_axis) gen(kEducationX kEducationY)
kdensity school_ideal, at(x_axis) gen(kSchoolX kSchoolY)
kdensity iq_ideal, at(x_axis) gen(kIqX kIqY)
kdensity creativity_ideal, at(x_axis) gen(kCreativityX kCreativityY)
kdensity wealth_ideal, at(x_axis) gen(kWealthX kWealthY)
kdensity parenteduc_ideal, at(x_axis) gen(kParenteducX kParenteducY)
kdensity race_ideal, at(x_axis) gen(kRaceX kRaceY)
kdensity stablefam_ideal, at(x_axis) gen(kStablefamX kStablefamY)
kdensity gender_ideal, at(x_axis) gen(kGenderX kGenderY)
kdensity econstate_ideal, at(x_axis) gen(kEconstateX kEconstateY)
kdensity connections_ideal, at(x_axis) gen(kConnectionsX kConnectionsY)
	drop kAttitudeX kAttitudeY kAmbitionX kAmbitionY kHarworkX kHardworkY kHealthX kHealthY kEducationX kEducationY kSchoolX kSchoolY kIqX kIqY kCreativityX kCreativityY kWealthX kWealthY kParenteducX kParenteducY kRaceX kRaceY kStablefamX kStablefamY kGenderX kGenderY kEconstateX kEconstateY kConnectionsX kConnectionsY

kdens ambition_ideal [pweight = post_weight], at(x_axis_7) gen(kAmbitionY)
kdens attitude_ideal [pweight = post_weight], at(x_axis_7) gen(kAttitudeY)
kdens connections_ideal [pweight = post_weight], at(x_axis_7) gen(kConnectionsY)
kdens creativity_ideal [pweight = post_weight], at(x_axis_7) gen(kCreativityY)
kdens education_ideal [pweight = post_weight], at(x_axis_7) gen(kEducationY)
kdens stablefam_ideal [pweight = post_weight], at(x_axis_7) gen(kFamStabY)
kdens wealth_ideal [pweight = post_weight], at(x_axis_7) gen(kFamWealthY)
kdens gender_ideal [pweight = post_weight], at(x_axis_7) gen(kGenderY)
kdens hardwork_ideal [pweight = post_weight], at(x_axis_7) gen(kHardWorkY)
kdens health_ideal [pweight = post_weight], at(x_axis_7) gen(kHealthY)
kdens iq_ideal [pweight = post_weight], at(x_axis_7) gen(kIntelligenceY)
kdens parenteduc_ideal [pweight = post_weight], at(x_axis_7) gen(kParentEducY)
kdens race_ideal [pweight = post_weight], at(x_axis_7) gen(kRaceY)
kdens school_ideal [pweight = post_weight], at(x_axis_7) gen(kSchoolY)
kdens econstate_ideal [pweight = post_weight], at(x_axis_7) gen(kStateEconY)
	drop kAmbitionY kAttitudeY kConnectionsY kCreativityY kEducationY kFamStabY kFamWealthY kGenderY kHardWorkY kHealthY kIntelligenceY kParentEducY kRaceY kSchoolY kStateEconY



* OVER WHAT FACTORS DO WE HAVE CONTROL?

// create variable "x_axis_5" with values 0, .25, .5, .75, 1

svy: mean ambition_agency
svy: mean attitude_agency
svy: mean connections_agency
svy: mean creativity_agency
svy: mean education_agency
svy: mean stablefam_agency
svy: mean wealth_agency
svy: mean gender_agency
svy: mean hardwork_agency
svy: mean health_agency
svy: mean iq_agency
svy: mean parenteduc_agency
svy: mean race_agency
svy: mean school_agency
svy: mean econstate_agency

kdensity attitude_agency, at(x_axis) gen(kAttitudeX kAttitudeY)
kdensity ambition_agency, at(x_axis) gen(kAmbitionX kAmbitionY)
kdensity hardwork_agency, at(x_axis) gen(kHarworkX kHardworkY)
kdensity health_agency, at(x_axis) gen(kHealthX kHealthY)
kdensity education_agency, at(x_axis) gen(kEducationX kEducationY)
kdensity school_agency, at(x_axis) gen(kSchoolX kSchoolY)
kdensity iq_agency, at(x_axis) gen(kIqX kIqY)
kdensity creativity_agency, at(x_axis) gen(kCreativityX kCreativityY)
kdensity wealth_agency, at(x_axis) gen(kWealthX kWealthY)
kdensity parenteduc_agency, at(x_axis) gen(kParenteducX kParenteducY)
kdensity race_agency, at(x_axis) gen(kRaceX kRaceY)
kdensity stablefam_agency, at(x_axis) gen(kStablefamX kStablefamY)
kdensity gender_agency, at(x_axis) gen(kGenderX kGenderY)
kdensity econstate_agency, at(x_axis) gen(kEconstateX kEconstateY)
kdensity connections_agency, at(x_axis) gen(kConnectionsX kConnectionsY)
	drop kAttitudeX kAttitudeY kAmbitionX kAmbitionY kHarworkX kHardworkY kHealthX kHealthY kEducationX kEducationY kSchoolX kSchoolY kIqX kIqY kCreativityX kCreativityY kWealthX kWealthY kParenteducX kParenteducY kRaceX kRaceY kStablefamX kStablefamY kGenderX kGenderY kEconstateX kEconstateY kConnectionsX kConnectionsY

kdens ambition_agency [pweight = post_weight], at(x_axis_5) gen(kAmbitionY)
kdens attitude_agency [pweight = post_weight], at(x_axis_5) gen(kAttitudeY)
kdens connections_agency [pweight = post_weight], at(x_axis_5) gen(kConnectionsY)
kdens creativity_agency [pweight = post_weight], at(x_axis_5) gen(kCreativityY)
kdens education_agency [pweight = post_weight], at(x_axis_5) gen(kEducationY)
kdens stablefam_agency [pweight = post_weight], at(x_axis_5) gen(kFamStabY)
kdens wealth_agency [pweight = post_weight], at(x_axis_5) gen(kFamWealthY)
kdens gender_agency [pweight = post_weight], at(x_axis_5) gen(kGenderY)
kdens hardwork_agency [pweight = post_weight], at(x_axis_5) gen(kHardWorkY)
kdens health_agency [pweight = post_weight], at(x_axis_5) gen(kHealthY)
kdens iq_agency [pweight = post_weight], at(x_axis_5) gen(kIntelligenceY)
kdens parenteduc_agency [pweight = post_weight], at(x_axis_5) gen(kParentEducY)
kdens race_agency [pweight = post_weight], at(x_axis_5) gen(kRaceY)
kdens school_agency [pweight = post_weight], at(x_axis_5) gen(kSchoolY)
kdens econstate_agency [pweight = post_weight], at(x_axis_5) gen(kStateEconY)
	drop kAmbitionY kAttitudeY kConnectionsY kCreativityY kEducationY kFamStabY kFamWealthY kGenderY kHardWorkY kHealthY kIntelligenceY kParentEducY kRaceY kSchoolY kStateEconY


svy: mean corr_ideal_agency

kdens corr_ideal_agency [pweight = post_weight], at(x_axis_10) gen(kCorrIdealAgencyY)
	drop kCorrIdealAgencyY



* FOR WHOM DOES JUSTICE REQUIRE AGENCY?
* Correltaion between ideal importance of factor and control over factor

gen class_change_abs = .
	replace class_change_abs = (class_change * 2) - 1
	replace class_change_abs = abs(class_change_abs)

svy: mean corr_ideal_agency

kdens corr_ideal_agency [pweight = post_weight], at(x_axis_100) gen(kCorrIdealAgencyY)
	drop x_axis_100 kCorrIdealAgencyY

svy: reg corr_ideal_agency party_str ideo_str income_household class_change unemployed school_private nonwhite female gay_strict divorce single_parent age education urban south religiosity
svy: reg corr_ideal_agency party_str ideo_str income_household education school_ivy unemployed divorce single_parent class_change nonwhite female gay_strict age urban south religiosity theology	// this one
svy: reg corr_ideal_agency income_household school_ivy nonwhite age south

	// add neoliberal and goodlife_future
	gen neoliberal_cons = neoliberal * -1
	
svy: reg corr_ideal_agency party_str ideo_str income_household education school_ivy unemployed divorce single_parent class_change goodlife_future nonwhite female gay_strict age urban south religiosity theology neoliberal	// this one
svy: reg corr_ideal_agency ideo_str income_household school_ivy goodlife_future nonwhite age south religiosity neoliberal_cons 
svy: reg corr_ideal_agency income_household school_ivy nonwhite age neoliberal_cons 


svy: reg corr_ideal_agency ideo_str party_str religiosity theology class_change income_household education school_ivy unemployed divorce single_parent goodlife_future nonwhite female gay_strict age urban south neoliberal	// this one
svy: reg corr_ideal_agency ideo_str party_str religiosity theology class_change_abs income_household education school_ivy goodlife_future nonwhite female gay_strict age urban south neoliberal	// this one





svy: reg corr_ideal_agency income_household class_change party_str ideo_str nonwhite female gay_strict divorce urban religiosity
svy: reg corr_ideal_agency income_household school_private class_change fulltime party_str ideo_str education nonwhite female gay_strict divorce single_parent urban south religiosity
svy: reg corr_ideal_agency income_household class_change unemployed party_str ideo_str neoliberal education nonwhite female gay_strict divorce single_parent urban south religiosity
svy: reg corr_ideal_agency income_household class_change unemployed neoliberal education nonwhite female gay_strict divorce single_parent urban south religiosity protestant
svy: reg corr_ideal_agency income_household class_change unemployed ideo_str education nonwhite female gay_strict divorce single_parent urban south religiosity


graph twoway scatter corr_ideal_agency income_household, jitter(8)
graph twoway scatter corr_ideal_agency income_household [w=post_weight]
graph twoway scatter corr_ideal_agency party_str [w=post_weight], jitter(8)






// TEMPLATES AND MISC

graph twoway scatter agency_within income_household, jitter(8)
graph twoway scatter agency_within income_household [w=post_weight]
graph twoway scatter agency_within income_household [w=post_weight], jitter(8)



* bottom half
kdensity agency_str if class_change < .5, gen(kd_class_lowhalf_x0 kd_class_lowhalf_y0)
kdensity agency_within if class_change < .5, gen(kdincomex0 kdincomey0)
* top half
kdensity agency_str if class_change > .5, gen(kd_class_highhalf_x0 kd_class_highhalf_y0)
kdensity agency_within if class_change > .5

histogram income if class_change < .5, fraction normal


* GENDER

svy: mean agency_within, over(female)
lincom [agency_within]0 - [agency_within]1
svy: regress agency_within female


* SEXUAL ORIENTATION

svy: mean agency_within, over(gay_strict)
lincom [agency_within]0 - [agency_within]1
svy: regress agency_within gay_strict


* RACE

svy: mean agency_within, over(nonwhite)
lincom [agency_within]0 - [agency_within]1
svy: regress agency_within nonwhite

