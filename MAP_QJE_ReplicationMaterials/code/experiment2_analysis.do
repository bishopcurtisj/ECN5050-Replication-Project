global maindir "/Users/jconlon/Dropbox/SBS/MAP_QJE_ReplicationMaterials"

global output "${maindir}/output"
global code "${maindir}/code"
global data "${maindir}/data"

global col1 "gs1"
global col2 "gs6"
global col3 "gs12"

use "${data}/experiment2_data.dta", clear


preserve
keep if inlist(treatment, 1, 2, 3, 4, 5, 6, 7, 8)
reg posteriors1 ibn.treatment, nocons r
test 1.treatment = 3.treatment
test 4.treatment = 6.treatment
test 7.treatment = 8.treatment

collapse (mean) m=posteriors1 (semean) se = posteriors1 , by(treatment)


replace m = m - 50 if inlist(treatment, 1, 2, 3)
replace m = m - 55 if inlist(treatment, 7, 8)
replace m = m - 70 if inlist(treatment, 4, 5, 6)

gen lb = m - 1.96*se
gen ub = m + 1.96*se

gen blue_numbers = inlist(treatment, 1, 4, 7)
gen t = 1 if inlist(treatment, 1, 4, 7)
replace t = 2 if inlist(treatment, 2, 5)
replace t = 3 if inlist(treatment, 3, 6, 8)

cap drop pos
gen pos = 7 if treatment == 6
replace pos = 8 if treatment == 5
replace pos = 9 if treatment == 4

replace pos = 4.5 if treatment == 8
replace pos = 5.5 if treatment == 7

replace pos = 1 if treatment == 3
replace pos = 2 if treatment == 2
replace pos = 3 if treatment == 1

	twoway 	///
		(bar m pos if t == 1, fcolor("${col3}") lcolor("${col3}"*1.2) barw(0.8))	///
		(bar m pos if t == 2, fcolor("${col2}") lcolor("${col2}"*1.2) barw(0.8))	///
		(bar m pos if t == 3, fcolor("${col1}") lcolor("${col1}"*1.2) barw(0.8))	///
		(rcap ub lb pos, lcolor(black)) ///
		,legend( off order(3  "{it:Blue Numbers}" 2 "{it:Mirror}" 1  "{it:Blue Words}" 5 "True P(Word | Orange)" ) size(medsmall) rows(1) region(lcolor(white)) symxsize(*0.4))	///
		xlabel(1 "NL" 2 "NM" 3 "NH" 4.5 "IL" 5.5 "IH" 7 "CL" 8 "CM" 9 "CH", valuelabels) xtitle("") graphregion(color(white) margin(5 5 5 5 ))	///
		ytitle(" ", size(medsmall)) xsize(20) ysize(12) scale(1.35) ylabel(-15(5)10) yscale(range(-15 10)) title("A. Mean Belief of P(Word | Orange) Minus Truth", size(medium))	///
		saving("${output}/Figure6_PanelA.gph", replace)	

		
restore


preserve
keep if inlist(treatment, 1, 2, 3, 4, 5, 6, 7, 8)
reg posteriors1 ibn.treatment, nocons r
test 1.treatment = 3.treatment
test 4.treatment = 6.treatment
test 7.treatment = 8.treatment

collapse (mean) m=recall_num_orange  (semean) se = recall_num_orange , by(treatment)


gen lb = m - 1.96*se
gen ub = m + 1.96*se

gen blue_numbers = inlist(treatment, 1, 4, 7)
gen t = 1 if inlist(treatment, 1, 4, 7)
replace t = 2 if inlist(treatment, 2, 5)
replace t = 3 if inlist(treatment, 3, 6, 8)
cap drop pos
gen pos = 7 if treatment == 6
replace pos = 8 if treatment == 5
replace pos = 9 if treatment == 4

replace pos = 4.5 if treatment == 8
replace pos = 5.5 if treatment == 7

replace pos = 1 if treatment == 3
replace pos = 2 if treatment == 2
replace pos = 3 if treatment == 1

	twoway 	///
		(bar m pos if t == 1, fcolor("${col3}") lcolor("${col3}"*1.2) barw(0.8))	///
		(bar m pos if t == 2, fcolor("${col2}") lcolor("${col2}"*1.2) barw(0.8))	///
		(bar m pos if t == 3, fcolor("${col1}") lcolor("${col1}"*1.2) barw(0.8))	///
		(rcap ub lb pos, lcolor(black)) ///
		, xlabel(1 "NL" 2 "NM" 3 "NH" 4.5 "IL" 5.5 "IH" 7 "CL" 8 "CM" 9 "CH", valuelabels) xtitle("") graphregion(color(white) margin(5 5 5 5 ))	///
		legend(off) ytitle(" ", size(medsmall)) xsize(20) ysize(12) scale(1.35) ylabel(0(2)6) yscale(range(0 6)) title("B. Mean Orange Words Recalled", size(medlarge))	///
		saving("${output}/Figure6_PanelB.gph", replace)	

	
	restore
	
	
graph combine 	"${output}/Figure6_PanelA.gph"	///
	"${output}/Figure6_PanelB.gph"	///
	, graphregion(color(white))  ///
	xsize(20) ysize(7) scale(1.4) rows(1) 

graph export  "${output}/Figure6.png", replace

graph export  "${output}/Figure6.tif", replace





preserve
keep if inlist(treatment, 1, 2, 3, 4, 5, 6, 7, 8)
reg posteriors1 ibn.treatment, nocons r
test 1.treatment = 3.treatment
test 4.treatment = 6.treatment
test 7.treatment = 8.treatment

collapse (mean) m1=posteriors1 m2=posteriors2 m3=prior (semean) se1 = posteriors1 se2 = posteriors2 se3 = prior, by(treatment)


reshape long m se, i(treatment) j(stat)

keep if stat == 2

gen lb = m - 1.96*se
gen ub = m + 1.96*se

gen blue_numbers = inlist(treatment, 1, 4, 7)
gen t = 1 if inlist(treatment, 1, 4, 7)
replace t = 2 if inlist(treatment, 2, 5)
replace t = 3 if inlist(treatment, 3, 6, 8)

cap drop pos
gen pos = 1 if treatment == 4
replace pos = 2 if treatment == 5
replace pos = 3 if treatment == 6

replace pos = 5 if treatment == 7
replace pos = 6 if treatment == 8

replace pos = 8 if treatment == 1
replace pos = 9 if treatment == 2
replace pos = 10 if treatment == 3

	twoway 	///
		(bar m pos if t == 1, fcolor("${col1}") lcolor("${col1}") barw(0.6))	///
		(bar m pos if t == 2, fcolor("${col2}") lcolor("${col2}") barw(0.6))	///
		(bar m pos if t == 3, fcolor("${col3}") lcolor("${col3}") barw(0.6))	///
		(rcap ub lb pos, lcolor(black)) ///
		(function y = 100, range(0.7 1.3) lcolor(black) lpattern(dash))	///		
		(function y = 100, range(4.7 5.3) lcolor(black) lpattern(dash))	///		
		(function y = 100, range(7.7 8.3) lcolor(black) lpattern(dash))	///		
		(function y = 0, range(2.7 3.3) lcolor(black) lpattern(dash))	///		
		(function y = 0, range(5.7 6.3) lcolor(black) lpattern(dash))	///		
		(function y = 0, range(9.7 10.3) lcolor(black) lpattern(dash))	///		
		(function y = 30, range(1.7 2.3) lcolor(black) lpattern(dash))	///		
		(function y = 50, range(8.7 9.3) lcolor(black) lpattern(dash))	///		
		,legend(off rows(1) region(lcolor(white)) symxsize(*0.5))	///
		 xlabel(1 "NL" 2 "NM" 3 "NH" 5 "IL" 6 "IH" 8 "CL" 9 "CI" 10 "CH", valuelabels) xtitle("") graphregion(color(white) margin(5 5 5 5 ))	///
		ytitle(" ", size(medsmall)) xsize(20) ysize(12) scale(1.5) ylabel(0(25)100) yscale(range(-10 110)) title("A: Mean Belief of P(Word | Blue)", size(medium))	///
		saving("${output}/FigureC5_PanelA.gph", replace)	

		
restore




preserve
keep if inlist(treatment, 1, 2, 3, 4, 5, 6, 7, 8)
reg posteriors1 ibn.treatment, nocons r
test 1.treatment = 3.treatment
test 4.treatment = 6.treatment
test 7.treatment = 8.treatment

collapse (mean) m1=posteriors1 m2=posteriors2 m3=prior (semean) se1 = posteriors1 se2 = posteriors2 se3 = prior, by(treatment)


reshape long m se, i(treatment) j(stat)

keep if stat == 3
gen lb = m - 1.96*se
gen ub = m + 1.96*se

gen blue_numbers = inlist(treatment, 1, 4, 7)
gen t = 1 if inlist(treatment, 1, 4, 7)
replace t = 2 if inlist(treatment, 2, 5)
replace t = 3 if inlist(treatment, 3, 6, 8)

cap drop pos
gen pos = 1 if treatment == 4
replace pos = 2 if treatment == 5
replace pos = 3 if treatment == 6

replace pos = 5 if treatment == 7
replace pos = 6 if treatment == 8

replace pos = 8 if treatment == 1
replace pos = 9 if treatment == 2
replace pos = 10 if treatment == 3

twoway 	///
		(bar m pos if t == 1, fcolor("${col1}") lcolor("${col1}") barw(0.6))	///
		(bar m pos if t == 2, fcolor("${col2}") lcolor("${col2}") barw(0.6))	///
		(bar m pos if t == 3, fcolor("${col3}") lcolor("${col3}") barw(0.6))	///
		(rcap ub lb pos, lcolor(black)) ///
		(function y = 85, range(0.7 1.3) lcolor(black) lpattern(dash))	///		
		(function y = 50, range(1.7 2.3) lcolor(black) lpattern(dash))	///		
		(function y = 35, range(2.7 3.3) lcolor(black) lpattern(dash))	///		
		(function y = 77.5, range(4.7 5.3) lcolor(black) lpattern(dash))	///		
		(function y = 27.5, range(5.7 6.3) lcolor(black) lpattern(dash))	///		
		(function y = 75, range(7.7 8.3) lcolor(black) lpattern(dash))	///		
		(function y = 50, range(8.7 9.3) lcolor(black) lpattern(dash))	///		
		(function y = 25, range(9.7 10.3) lcolor(black) lpattern(dash))	///		
		,legend( off order(1 "{it:Blue Words}" 2 "{it:Mirror}" 3 "{it:Blue Numbers}" 5 "Truth" ) rows(1) region(lcolor(white)) symxsize(*0.5))	///
		 xlabel(1 "NL" 2 "NM" 3 "NH" 5 "IL" 6 "IH" 8 "CL" 9 "CI" 10 "CH", valuelabels) xtitle("") graphregion(color(white) margin(5 5 5 5 ))	///
		ytitle(" ", size(medsmall)) xsize(20) ysize(12) scale(1.5) ylabel(0(25)100) yscale(range(-10 110)) title(" " "B: Mean Belief of P(Word)", size(medium))	///
		saving("${output}/FigureC5_PanelB.gph", replace)	

		
restore

graph combine			///
	"${output}/FigureC5_PanelA.gph"	///
	"${output}/FigureC5_PanelB.gph"	///
	, graphregion(color(white)) ///
	xsize(20) ysize(20) scale(0.78) rows(2)
	
graph export  "${output}/FigureC5.png", replace
graph export  "${output}/FigureC5.tif", replace









preserve
keep if inlist(treatment, 1, 2, 3, 4, 5, 6, 7, 8)
reg posteriors1 ibn.treatment, nocons r
test 1.treatment = 3.treatment
test 4.treatment = 6.treatment
test 7.treatment = 8.treatment

collapse (mean) m1=num_misremember_orange  (semean) se1 = num_misremember_orange, by(treatment)


reshape long m se, i(treatment) j(stat)

keep if stat == 1
gen lb = m - 1.96*se
gen ub = m + 1.96*se

gen blue_numbers = inlist(treatment, 1, 4, 7)
gen t = 1 if inlist(treatment, 1, 4, 7)
replace t = 2 if inlist(treatment, 2, 5)
replace t = 3 if inlist(treatment, 3, 6, 8)

cap drop pos
gen pos = 1 if treatment == 4
replace pos = 2 if treatment == 5
replace pos = 3 if treatment == 6

replace pos = 5 if treatment == 7
replace pos = 6 if treatment == 8

replace pos = 8 if treatment == 1
replace pos = 9 if treatment == 2
replace pos = 10 if treatment == 3

	twoway 	///
		(bar m pos if t == 1, fcolor("${col1}") lcolor("${col1}") barw(0.6))	///
		(bar m pos if t == 2, fcolor("${col2}") lcolor("${col2}") barw(0.6))	///
		(bar m pos if t == 3, fcolor("${col3}") lcolor("${col3}") barw(0.6))	///
		(rcap ub lb pos, lcolor(black)) ///
		,legend( off order(1 "{it:Blue Words}" 2 "{it:Mirror}" 3 "{it:Blue Numbers}" ) rows(1) region(lcolor(white)) symxsize(*0.5))	///
		 xlabel(1 "NL" 2 "NM" 3 "NH" 5 "IL" 6 "IH" 8 "CL" 9 "CI" 10 "CH", valuelabels) xtitle("") graphregion(color(white) margin(5 5 5 5 ))	///
		ytitle(" ", size(medsmall)) xsize(20) ysize(15) scale(1.5) ylabel(0(0.4)1.2) yscale(range(0 1.2)) title(" " "A. Mean Orange Words Mis-Recognized", size(medlarge))	///
		saving("${output}/FigureC6_PanelA.gph", replace)	

		
restore




preserve
keep if inlist(treatment, 1, 2, 3, 4, 5, 6, 7, 8)
reg posteriors1 ibn.treatment, nocons r
test 1.treatment = 3.treatment
test 4.treatment = 6.treatment
test 7.treatment = 8.treatment

collapse (mean) m1=num_misremember_blue  (semean) se1 = num_misremember_blue, by(treatment)


reshape long m se, i(treatment) j(stat)

keep if stat == 1
gen lb = m - 1.96*se
gen ub = m + 1.96*se

gen blue_numbers = inlist(treatment, 1, 4, 7)
gen t = 1 if inlist(treatment, 1, 4, 7)
replace t = 2 if inlist(treatment, 2, 5)
replace t = 3 if inlist(treatment, 3, 6, 8)

cap drop pos
gen pos = 1 if treatment == 4
replace pos = 2 if treatment == 5
replace pos = 3 if treatment == 6

replace pos = 5 if treatment == 7
replace pos = 6 if treatment == 8

replace pos = 8 if treatment == 1
replace pos = 9 if treatment == 2
replace pos = 10 if treatment == 3


	twoway 	///
		(bar m pos if t == 1, fcolor("${col1}") lcolor("${col1}") barw(0.6))	///
		(bar m pos if t == 2, fcolor("${col2}") lcolor("${col2}") barw(0.6))	///
		(bar m pos if t == 3, fcolor("${col3}") lcolor("${col3}") barw(0.6))	///
		(rcap ub lb pos, lcolor(black)) ///
		,legend(off order(1 "{it:Blue Words}" 2 "{it:Mirror}" 3 "{it:Blue Numbers}" ) rows(1) region(lcolor(white)) symxsize(*0.5))	///
		 xlabel(1 "NL" 2 "NM" 3 "NH" 5 "IL" 6 "IH" 8 "CL" 9 "CI" 10 "CH", valuelabels) xtitle("") graphregion(color(white) margin(5 5 5 5 ))	///
		ytitle(" ", size(medsmall)) xsize(20) ysize(15) scale(1.5) ylabel(0(0.4)1.2) yscale(range(0 1.2)) title(" " "B. Mean Blue Words Mis-Recognized", size(medlarge))	///
		saving("${output}/FigureC6_PanelB.gph", replace)	


restore

graph combine	"${output}/FigureC6_PanelA.gph"	///
				"${output}/FigureC6_PanelB.gph"	///
	,	///
	graphregion(color(white)) imargin(0) ///
	xsize(20) ysize(20) scale(0.78) rows(2)



graph export  "${output}/FigureC6.png", replace
graph export  "${output}/FigureC6.tif", replace




