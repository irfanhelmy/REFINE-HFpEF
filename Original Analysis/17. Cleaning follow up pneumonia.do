***Cleaning follow up Pneumonia hospitalization***
**** STEP 1: Cleaning pneumonia file for DPP4 patients
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_pneumonia.dta"
gen admission_pneumonia = dofc( DischargeDateTime )
keep scrssn admission_pneumonia
gen pneumonia_after=1
by scrssn admission_pneumonia, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
duplicates drop scrssn, force
gen treatment=0
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pneumoniaafter.dta", replace 


**** STEP 2: Cleaning pneumonia file for SGLT2 patients
clear all
 use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\Diabetes_hf_sglt2_pneumonia.dta"
gen admission_pneumonia = dofc( DischargeDateTime )
keep scrssn admission_pneumonia
gen pneumonia_after=1
by scrssn admission_pneumonia, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
duplicates drop scrssn, force
gen treatment=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_pneumoniaafter.dta", replace 


**** STEP 3: Merging SGLT2 and DPP4 files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pneumoniaafter.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_pneumoniaafter.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_sglt2_dpp4_pneumonia_after.dta",replace
