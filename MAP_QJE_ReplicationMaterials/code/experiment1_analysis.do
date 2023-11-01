global maindir "/Users/jconlon/Dropbox/SBS/MAP_QJE_ReplicationMaterials"

global output "${maindir}/output"
global code "${maindir}/code"
global data "${maindir}/data"


use "${data}/experiment1_data.dta", clear

global col1 "gs1"
global col2 "gs5"
global col3 "gs9"
global col4 "gs13"

label define treatment_lab 1 "Animals + Names" 2 "Animals + Names (20/80)" 3 "Animals + Names (3 bins)" 4 "Land + Sea + Men" 5 "Animals + Random", modify
label values treatment treatment_lab

preserve
keep if inlist(treatment, 1, 2, 3, 5)

replace belief1 = belief1 - 20 if inlist(treatment, 2)
replace belief1 = belief1 - 40 if inlist(treatment, 1, 3, 5)
collapse (mean) m1 = belief1 m2 = frac_correct_land  (semean) se1 = belief1 se2 = frac_correct_land, by(treatment)

reshape long m se, i(treatment) j(var)


label define new_t_lab 1 "40% Animals" 2 "20% Animals" 3 "Split" 5 "Hetereogeneous"
label values treatment new_t_lab
gen lb = m - 1.96*se
gen ub = m + 1.96*se

gen pos = 1 if treatment == 2
replace pos = 2 if treatment == 1
replace pos = 3 if treatment == 5
replace pos = 4 if treatment == 3


twoway 	///
		(bar m pos if pos == 1 & var == 1, barw(0.6) fcolor(${col1}) lcolor(${col1}))	///
		(bar m pos if pos == 2 & var == 1, barw(0.6) fcolor(${col2}) lcolor(${col2}))	///
		(bar m pos if pos == 3 & var == 1, barw(0.6) fcolor(${col3}) lcolor(${col3}))	///
		(bar m pos if pos == 4 & var == 1, barw(0.6) fcolor(${col4}) lcolor(${col4}))	///
		(rcap ub lb pos if var == 1, lcolor(black)),	///
	graphregion(color(white) margin(1 1 10 1))	///
	xlabel(none, noticks )	///
	xtitle("") ytitle("")	///
	legend(order(1 "T1" 2 "T2"  3 "T3"  4  "T4") region(lcolor(white)) symxsize(*0.5) size(medium) rows(1))	scale(1.5)	///
	xscale(range(0.5 4.5)) title("A. Mean Belief of P(Animal) Minus Truth", size(medsmall))	///
	saving("${output}/Figure4_PanelA.gph", replace)	

twoway 	///
		(bar m pos if pos == 1 & var == 2, barw(0.6) fcolor(${col1}) lcolor(${col1}))	///
		(bar m pos if pos == 2 & var == 2, barw(0.6) fcolor(${col2}) lcolor(${col2}))	///
		(bar m pos if pos == 3 & var == 2, barw(0.6) fcolor(${col3}) lcolor(${col3}))	///
		(bar m pos if pos == 4 & var == 2, barw(0.6) fcolor(${col4}) lcolor(${col4}))	///
		(rcap ub lb pos if var == 2, lcolor(black)),	///
	graphregion(color(white) margin(1 1 10 1))	///
	xlabel(none, noticks )	///
	xtitle("") ytitle("")	///
	legend(order(1 "T1" 2 "T2"  3 "T3"  4  "T4") region(lcolor(white)) symxsize(*0.5) size(medium) rows(1))	scale(1.5)	///
	xscale(range(0.5 4.5))	title("B. Fraction Animals Recalled", size(medsmall)) ///
	saving("${output}/Figure4_PanelB.gph", replace)		///
	yscale(range(-0.25 0.75)) ylabel(0(0.25)0.75)

	

grc1leg  	"${output}/Figure4_PanelA.gph"	///
			"${output}/Figure4_PanelB.gph"	///
			, graphregion(color(white))  rows(1)	///
	saving("${output}/Figure4.gph", replace)	

graph combine "${output}/Figure4.gph"	///
		, graphregion(color(white)) imargin(none) xsize(20) ysize(10) scale(1.35)
graph export  "${output}/Figure4.png", replace
graph export  "${output}/Figure4.tif", replace

restore

		preserve
keep if inlist(treatment,1, 5)
	sum belief1
	local sd: display %3.2f `r(sd)'
	twoway hist belief1, start(-5) width(10) fcolor(${col3}) lcolor(${col1})	///
	xscale(range(-5 105)) xlabel(0(25)100)		///
	percent ///
	graphregion(color(white))	///
	xtitle(" " " ") ytitle("Percent")	///
	title("`title`t''", size(medsmall)) ///
	saving("${output}/Figure5_PanelA.gph", replace)	///
	title("A. Variation in Beliefs" "of P(Animal)", size(medium))
	
	restore
	
	preserve
keep if inlist(treatment,1, 5)
	sum belief1
	local sd: display %3.2f `r(sd)'
	twoway hist frac_correct_land, start(-0.05) width(0.1) fcolor(${col3}) lcolor(${col1})	///
	xscale(range(0 1)) xlabel(0(0.25)1)		///
	percent ///
	graphregion(color(white))	///
	xtitle(" " " ") ytitle("Percent")	///
	title("`title`t''", size(medsmall))	 ///
	saving("${output}/Figure5_PanelB.gph", replace)	///
	title("B. Variation in Animals Recalled / " "Total Words Recalled", size(medium))
	restore
	
	
	preserve
keep if inlist(treatment,1, 5)
xtile dec = frac_correct_land, n(10)
reg belief1 frac_correct_land 
local c = _b[_cons]
local b = _b[frac_correct_land]

collapse (mean) m1 = frac_correct_land m2 = belief1 (semean) se1 = frac_correct_land se2 = belief1, by(dec)

gen lb2 = m2 - 1.96*se2 
gen ub2 = m2 + 1.96*se2

twoway 	(scatter m2 m1, mcolor(${col2}))	///
		(rcap lb2 ub2 m1, color(${col2}))	///
		(function y = `c' + `b'*x, range(0.2 1) lcolor(black) lpattern(dash))	///
		, graphregion(color(white))		///
		xtitle("Animals Recalled / " "Total Words Recalled") 	///
		ytitle("Belief of  P(Animals)") 	///
		legend(off)	///
	saving("${output}/Figure5_PanelC.gph", replace)	///
		title("C. Linking Recall and Beliefs" " ", size(medium))

restore


graph combine 		///
	"${output}/Figure5_PanelA.gph"	///
    "${output}/Figure5_PanelB.gph"	///
	"${output}/Figure5_PanelC.gph"	///
	, graphregion(color(white)) rows(1) xsize(20) ysize(8) scale(1.5)
	
	graph export  "${output}/Figure5.png", replace
	graph export  "${output}/Figure5.tif", replace
	
	

	
	
preserve


replace belief1 = belief1/ 100
keep if inlist(treatment, 1, 5)
xtile entries_bins = total_correct, n(10)

gen abs_error = abs(belief1 - 40) if treatment != 2
replace abs_error = abs(belief1 - 20) if treatment == 2
gen sq_diff = .
gen sq_diff2 = .

levelsof treatment, local(ts)
levelsof entries_bins, local(es)
hetregress belief1 total_correct, het(total_correct)

local var_alpha = _b[lnsigma2:total_correct] 
local var_cons = _b[lnsigma2:_cons] 

hetregress frac_correct_land total_correct, het(total_correct)
local var2_alpha = _b[lnsigma2:total_correct] 
local var2_cons = _b[lnsigma2:_cons] 


predict predval
tempfile temp
save `temp'
collapse (mean) predval, by(total_correct)
drop if total_correct < 5
tempfile temp2
save `temp2'
use `temp', clear
foreach e in `es' {
	sum belief1 if entries_bins == `e'
	if `r(N)' != 0 {
		replace sq_diff = (belief1-`r(mean)')^2 if entries_bins == `e'	
	}
}

foreach e in `es' {
	sum frac_correct_land if entries_bins == `e'
	if `r(N)' != 0 {
		replace sq_diff2 = (frac_correct_land-`r(mean)')^2 if entries_bins == `e'
	}
}
collapse (mean) m = sq_diff m2 = belief1 total_correct m3=abs_error m4 = sq_diff2 (count) N = sq_diff, by(entries_bins)
replace m = m*N/(N-1)

append using `temp2'
gen v = exp(`var_cons'+`var_alpha'*total_correct) if !mi(predval)
gen v2 = exp(`var2_cons'+`var2_alpha'*total_correct) if !mi(predval)

twoway (scatter m total_correct, mcolor(${col2}))	///
	(line v total_correct, sort lcolor(black) lpattern(dash)),	///
	xtitle("Recalled Words") ///
	ytitle("")	///
	graphregion(color(white)) scale(1.5) yscale(range(0.01 0.035)) ylabel(0.01(0.01)0.03)	///
	saving("${output}/FigureB1_PanelB.gph", replace)	///
	legend(off) title("B. Belief of P(Animal)" " ", size(medsmall))


twoway (scatter m4 total_correct, mcolor(${col2}))	///
	(line v2 total_correct, sort  lcolor(black) lpattern(dash)),	///
	xtitle("Recalled Words") ///
	ytitle("Sample Variance")	///
	graphregion(color(white)) scale(1.5)	///
	saving("${output}/FigureB1_PanelA.gph", replace)	///
	legend(off) title("A. Animals Recalled / " "Total Words Recalled", size(medsmall))
	
restore
graph combine 		///
	"${output}/FigureB1_PanelA.gph"		///
	"${output}/FigureB1_PanelB.gph"		///
, graphregion(color(white)) xsize(20) ysize(9) scale(1.5) note("")
	

graph export  "${output}/FigureB1.png", replace
graph export  "${output}/FigureB1.tif", replace


local title1 "T2"
local title5 "T3"

foreach t in 1 5 {
	preserve
	keep if treatment == `t'
	sum frac_correct_land
	local m: display %3.2f `r(mean)'
	local sd: display %3.2f `r(sd)'
	twoway hist frac_correct_land, start(-0.05) width(0.1) fcolor(${col3}) lcolor(${col1})	///
	xscale(range(-0.05 1.05)) xlabel(0(.25)1)		///
	percent ylabel(0(25)50)  ///
	text(45 .85 "SD = `sd'", size(small))	///
	graphregion(color(white))	///
	xtitle("") ytitle("Percent")	///
	title("`title`t''", size(medsmall))	scale(1.5) ///
	saving("${output}/FigureB2_recall`t'.gph", replace)
	
	restore
}


local title1 "T2"
local title5 "T3"
foreach t in 1 5 {
	preserve
	keep if treatment == `t'
	sum belief1
	local m: display %3.2f `r(mean)'
	local sd: display %3.2f `r(sd)'
	twoway hist belief1, start(-5) width(10) fcolor(${col3}) lcolor(${col1})	///
	xscale(range(-5 105)) xlabel(0(25)100)		///
	percent ylabel(0(25)50)  ///
	text(45 85 "SD = `sd'", size(small))	///
	graphregion(color(white))	///
	xtitle("") ytitle("Percent")	///
	title("`title`t''", size(medsmall))	scale(1.5) ///
	saving("${output}/FigureB2_belief`t'.gph", replace)
	restore
}



graph combine ///
	"${output}/FigureB2_recall1.gph"	///
	"${output}/FigureB2_recall5.gph"	///
	, graphregion(color(white)) scale(0.9) ycommon note("", size(small))	 xsize(20) ysize(16)	///
	title("A. Animals Recalled / Total Words Recalled")	///
		saving("${output}/FigureB2_PanelA.gph", replace)
	
graph combine ///
	"${output}/FigureB2_belief1.gph"	///
	"${output}/FigureB2_belief5.gph"	///
	, graphregion(color(white)) scale(0.9) ycommon note("", size(small))	 xsize(20) ysize(16)	///
	title("B. Belief of P(Animal)")	///
		saving("${output}/FigureB2_PanelB.gph", replace)

graph combine 		///
	"${output}/FigureB2_PanelA.gph"	///
	"${output}/FigureB2_PanelB.gph"	///
	, graphregion(color(white)) rows(1) imargin(0)	///
	xsize(20) ysize(8) scale(1.5)
	
	
graph export  "${output}/FigureB2.png", replace
graph export  "${output}/FigureB2.tif", replace


preserve
keep if inlist(treatment, 1, 4)
collapse (mean) m1 = belief1 m2 = num_correct_land m3 = num_correct_nonland (semean) se1 = belief1 se2 = num_correct_land se3 = num_correct_nonland, by(treatment)

reshape long m se, i(treatment) j(var)
gen pos = 1 if treatment == 1 & var == 1
replace pos = 2 if treatment == 4 & var == 1

replace pos = 5 if treatment == 1 & var == 2
replace pos = 6 if treatment == 4 & var == 2

replace pos = 10 if treatment == 1 & var == 3
replace pos = 11 if treatment == 4 & var == 3

gen lb = m - 1.96*se
gen ub = m + 1.96*se




twoway (bar m pos if treatment == 1 & var == 1, barw(1) fcolor(${col1}) lcolor(${col1}))	///
		(bar m pos if treatment == 4 & var == 1,  barw(1) fcolor(${col3}) lcolor(${col3}))	///
		(rcap ub lb pos if var == 1, lcolor(black))	///
		, graphregion(color(white))	///
	xlabel(1.5  `""Mean Belief " "of P(Land Animal) "')	///
	xtitle("") ytitle("")	///
	legend(order(1 "T2" 2 "T5") region(lcolor(white)) symxsize(*0.5) size(medlarge) rows(1))	scale(1.5)		///
	yscale(range(30 60))ylabel(30(10)60) xscale(range(-0.5 3.5)) ///
	title("Panel A: Beliefs", size(medlarge) )		///
	saving("${output}/FigureC1_PanelA.gph", replace)	///
	fxsize(70) fysize(100)
	
	

	
	
twoway 	///
		(bar m pos if treatment == 1 & var != 1, barw(1) fcolor(${col1}) lcolor(${col1}))	///
		(bar m pos if treatment == 4 & var != 1, barw(1) fcolor(${col3}) lcolor(${col3}))	///
	(rcap ub lb pos if var != 1,  lcolor(black))	///
	, graphregion(color(white)) 	///
	xlabel(5.5 `" "Mean Land" "Animals Recalled" "' 10.5 `" "Mean Other" "Words Recalled" "',valuelabels )	///
	legend(order(1 "T2" 2 "T5") region(lcolor(white)) symxsize(*0.5) size(medlarge) rows(1))	scale(1.5)		///
	ytitle("")	///
	yscale(range(3 8))  xscale(range(4 12))  ///
	 title("Panel B: Recall", size(medlarge) )	 ///
	ylabel(3(1)8) 	xtitle("")	///
	saving("${output}/FigureC1_PanelB.gph", replace)	///
	fxsize(130)
	

restore
	
grc1leg 	///
"${output}/FigureC1_PanelA.gph"	///
"${output}/FigureC1_PanelB.gph"	///
	, graphregion(color(white))	///
	saving("${output}/FigureC1.gph", replace)
	

graph combine ///
	"${output}/FigureC1.gph"	///
, graphregion(color(white)) imargin(0) xsize(15) ysize(7) scale(1.5)

	
graph export  "${output}/FigureC1.png", replace
graph export  "${output}/FigureC1.tif", replace




preserve


replace belief1 = belief1/ 100
keep if inlist(treatment, 1, 5)
*keep if cheated == 0
xtile time_bins = time_cens, n(10)

gen abs_error = abs(belief1 - 40) if treatment != 2
replace abs_error = abs(belief1 - 20) if treatment == 2
gen sq_diff = .
gen sq_diff2 = .

levelsof treatment, local(ts)
levelsof time_bins, local(es)
hetregress belief1 time_cens, het(time_cens)

local var_alpha = _b[lnsigma2:time_cens] 
local var_cons = _b[lnsigma2:_cons] 

hetregress frac_correct_land time_cens, het(time_cens)
local var2_alpha = _b[lnsigma2:time_cens] 
local var2_cons = _b[lnsigma2:_cons] 


predict predvar
tempfile temp
save `temp'
clear 
set obs 100
gen time_cens = _n
*drop if total_correct < 5
tempfile temp2
save `temp2'
use `temp', clear
foreach e in `es' {
	sum belief1 if time_bins == `e'
	if `r(N)' != 0 {
		replace sq_diff = (belief1-`r(mean)')^2 if time_bins == `e'	
	}
}

foreach e in `es' {
	sum frac_correct_land if time_bins == `e'
	if `r(N)' != 0 {
		replace sq_diff2 = (frac_correct_land-`r(mean)')^2 if time_bins == `e'
	}
}
reg sq_diff time_bins
collapse (mean) m = sq_diff m2 = belief1 time_cens m3=abs_error m4 = sq_diff2 (count) N = sq_diff, by(time_bins)
replace m = m*N/(N-1)

append using `temp2'
gen v = exp(`var_cons'+`var_alpha'*time_cens) 
gen v2 = exp(`var2_cons'+`var2_alpha'*time_cens) 

twoway (scatter m time_cens, mcolor(${col2}))	///
	(line v time_cens, sort lcolor(black) lpattern(dash)),	///
	xtitle("Time for Beliefs Question") ///
	ytitle("")	///
	graphregion(color(white)) scale(1.5) yscale(range(0.01 0.035)) ylabel(0.01(0.01)0.03)	///
	saving("${output}/FigureC2_PanelB.gph", replace)	///
	legend(off) title("B. Belief of P(Animal)" " ", size(medsmall))
	
twoway (scatter m4 time_cens, mcolor(${col2}))	///
	(line v2 time_cens, sort  lcolor(black) lpattern(dash)),	///
	xtitle("Time for Beliefs Question") ///
	ytitle("Sample Variance")	///
	graphregion(color(white)) scale(1.5)	///
	saving("${output}/FigureC2_PanelA.gph", replace)	///
	legend(off) title("A. Animals Recalled / " "Total Words Recalled", size(medsmall))
	
restore
graph combine 	///
	"${output}/FigureC2_PanelA.gph"	///
	"${output}/FigureC2_PanelB.gph"	///
, graphregion(color(white)) xsize(20) ysize(9) scale(1.5) note("")

graph export  "${output}/FigureC2.png", replace
graph export  "${output}/FigureC2.tif", replace




preserve
keep if inlist(treatment, 1, 2, 3, 5)
keep id word_order*_recalled
rename word_order*_recalled word_recalled_order*
reshape long word_recalled_order, i(id) j(order)

collapse (mean) m=word_recalled_order (semean) se=word_recalled_order, by(order)

gen lb = m-1.96*se
gen ub = m+1.96*se

twoway (scatter m order, mcolor(${col1}))	///
			(rcap lb ub order, lcolor(${col1}) /*(navy%20) lwidth(none)*/) ///
, graphregion(color(white)) xtitle(Order Word Appeared) ytitle(Fraction recalling word) ///
	note("") title("") scale(1.5) legend(off)

graph export  "${output}/FigureC3.png", replace
graph export  "${output}/FigureC3.tif", replace



restore




estimates clear
eststo: reg belief1 i.treatment if !inlist(treatment, 2, 4), r
eststo: reghdfe belief1 i.treatment if !inlist(treatment, 2, 4), absorb(num_land_first1) vce(r)


eststo: reghdfe belief1 i.treatment if !inlist(treatment, 2, 4), vce(r) absorb(num_land_first5)
eststo: reghdfe belief1 i.treatment if !inlist(treatment, 2, 4), vce(r) absorb(num_land_first10)
eststo: reg frac_correct_land i.treatment if !inlist(treatment, 2, 4), r
eststo: reghdfe frac_correct_land i.treatment if !inlist(treatment, 2, 4), absorb(num_land_first1) vce(r)


eststo: reghdfe frac_correct_land i.treatment if !inlist(treatment, 2, 4), vce(r) absorb(num_land_first5)
eststo: reghdfe frac_correct_land i.treatment if !inlist(treatment, 2, 4), vce(r) absorb(num_land_first10)

esttab using "${output}/table_C1.csv", se(2) b(2) star("*" 0.1 "**" 0.05 "***" 0.01) drop(1.treatment) coeflabels(3.treatment "T4" 5.treatment "T3" _cons "Constant") order(5.treatment 3.treatment) nomtitles prehead("") posthead("") postfoot("") nomtitles nonumbers replace	

** Table C2
table treatment, stat(mean beginning middle end)


preserve
xtile dec = total_correct, n(10)
reg belief1_conf total_correct if !inlist(treatment, 4)
local c = _b[_cons]
local b = _b[total_correct]

collapse (mean) m1 = total_correct  m2 = belief1_conf (semean) se1 = total_correct se2 = belief1_conf  if !inlist(treatment, 4), by(dec)

gen lb2 = m2 - 1.96*se2 
gen ub2 = m2 + 1.96*se2

twoway 	(scatter m2 m1, mcolor(${col1}))	///
		(rcap lb2 ub2 m1, color(${col1}))	///
		(function y = `c' + `b'*x, range(5 30) lcolor(black) lpattern(dash))	///
		, graphregion(color(white))		///
		xtitle("Total Recall Words") 	///
		ytitle("Confidence in Belief") scale(1.25)	///
		legend(off)
		
graph export  "${output}/FigureC4.png", replace
graph export  "${output}/FigureC4.tif", replace

restore
