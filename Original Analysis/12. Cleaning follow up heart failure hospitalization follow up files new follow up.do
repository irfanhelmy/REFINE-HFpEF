
*** STEP 1: Cleaning admission diagnosis with HF hospitalization file for SGLT2 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\sglt2_hfddhospinew.dta"
gen dof =dofc(SGLT2FillTime)
gen admission= dofc(AdmitDateTime)
rename ScrSSN scrssn
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn dof admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_sglt2_hf_admission_new.dta", replace 
*** 590 hospitalizations for HF

**** STEP 2: Cleaning admission diagnosis with HF hospitalization file for DPP4 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\dpp4_hfddhospinew.dta"
gen dof =dofc(dpp4filltime)
gen admission= dofc(AdmitDateTime)
drop if admission - dof < 8
by scrssn admission, sort: gen scrssn_n = _n
keep if scrssn_n == 1
duplicates drop scrssn, force
keep scrssn dof admission 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_hf_admission_new.dta", replace 
*** 507 hospitalizations for HF 



**** STEP 3: Merging SGLT2 and DPP4 discharge hospitalization files (only from admission files )
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_sglt2_hf_admission_new.dta",
gen treatment =1
merge 1:m scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_hf_admission_new.dta"
drop if _merge ==3
replace treatment = 0 if treatment ==.
drop _merge 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_sglt2_hf_discharge_new.dta", replace 
**1085 hospitalizations for HF

