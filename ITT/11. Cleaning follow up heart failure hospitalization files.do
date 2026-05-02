**** STEP 1: Cleaning discharge diagnosis with HF hospitalization file for DPP4 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\dpp4_hfddhospirf1.dta"
gen discharge= dofc(AdmitDateTime)
gen dof= dofc(DPP4FillTime)
drop if discharge - dof < 8
*** blanking period of 1 week post drug initiation
rename ScrSSN scrssn
by scrssn discharge, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn ICD9Code discharge dof
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_fhfh_itt.dta", replace
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_hf_admission_new.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_fhfh_new.dta", replace 

**** STEP 2: Cleaning discharge diagnosis with HF hospitalization file for SGLT2 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\sglt2_hfddhospirf1.dta"
gen discharge= dofc(AdmitDateTime)
gen dof= dofc(SGLT2FillTime)
drop if discharge - dof < 8
rename ScrSSN scrssn
by scrssn discharge, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn ICD9Code discharge dof
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_sglt2_fhfh_itt.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_sglt2_hf_admission_new.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_sglt2_fhfh_new.dta", replace 

**** STEP 3: Merging SGLT2 and DPP4 admission/discharge hospitalization files (only from admission files )
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_fhfh_new.dta",
gen treatment =0
drop _merge
merge 1:m scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_sglt2_fhfh_new.dta"
drop if _merge ==3
drop _merge
replace treatment = 1 if treatment ==.
replace admission=discharge if admission==.
drop discharge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_sglt2_hf_discharge_new.dta", replace 

