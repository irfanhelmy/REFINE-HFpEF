*** Cleaning medication files in SGLT2i group

*** STEP 1: Identifying patients on ACEI and or ARB
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_ace.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_ace.dta", replace
*** 221 patients on ACEI

*** ARB
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_arb.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_arb.dta", replace
*** 211 patients on ARB

*** Merging ACEI and ARB
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_ace.dta",
unique scrssn
drop _merge
duplicates drop scrssn, force
keep scrssn 
gen ACE=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_ace_arb.dta", replace
*** 432 patients on ACEI or ARB
***********************************************************************************************************************************

*** STEP 2: Identifying patients on Betablockers
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_bb.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
keep scrssn
gen BB=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_bb.dta", replace
*** 463 patients on BB

***********************************************************************************************************************************

*** STEP 3: Identifying patients on Antiarryhtmics
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_antiarr.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen antiarr=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_antiarr.dta", replace
*** 41 patients 


***********************************************************************************************************************************

*** STEP 4: Identifying patients on GLP-1 analogs
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_glp1.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen GLP=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_glp1.dta", replace
***123 patients 



***********************************************************************************************************************************

*** STEP 5: Identifying patients on insulin
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_insulin.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen insulin=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_insulin.dta", replace
***565 patients 


***********************************************************************************************************************************

*** STEP 6: Identifying patients on loop diuretic
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_loopdiuretic.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen LD=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_loopdiuretic.dta", replace
***989 patients 

***********************************************************************************************************************************

*** STEP 7: Identifying patients on metformin
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_metformin.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen metformin=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_metformin.dta", replace
***325 patients 


***********************************************************************************************************************************

*** STEP 8: Identifying patients on MRA
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_spiroep.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen spiro=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_spiroep.dta", replace
***121 patients 


***********************************************************************************************************************************

*** STEP 9: Identifying patients on TZD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_thiazol.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen TZD=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_thiazol.dta", replace
***13 patients 



***********************************************************************************************************************************

*** STEP 10: Identifying patients on statins
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_statin.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen statin=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_statin.dta", replace
***980 patients 

***********************************************************************************************************************************

*** STEP 11: Merging all medications 

clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_ace_arb.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_bb.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_antiarr.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_glp1.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_insulin.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_loopdiuretic.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_metformin.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_spiroep.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_thiazol.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_statin.dta"
drop _merge
replace ACE =0 if ACE==.
replace BB =0 if BB==.
replace antiarr =2 if antiarr==.
replace GLP =0 if GLP==.
replace insulin=2 if insulin==.
replace LD=0 if LD==.
replace metformin=0 if metformin==.
replace spiro=0 if spiro==.
replace TZD=0 if TZD==.
replace statin=0 if statin==.
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_final_med_merged.dta", replace
** 1113 patients on SGLT2i



