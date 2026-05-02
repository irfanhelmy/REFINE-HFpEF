
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_age.dta"
rename ScrSSN scrssn
gen dof= dofc(DPP4Filltime)
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_age_new.dta"
drop DPP4Filltime
drop DOB _merge
duplicates drop scrssn, force
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_age_new_final.dta", replace

clear all
use  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_age.dta"
rename ScrSSN scrssn
gen dof= dofc(sglt2Filltime)
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_age_new.dta"
duplicates drop scrssn, force
count if dof==.
count if age ==.
keep scrssn age dof
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_age_new_final.dta", replace

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_age_new_final.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_age_new_final.dta",
drop _merge 
duplicates drop scrssn, force 
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\final_age_dof_new_itt.dta", replace
