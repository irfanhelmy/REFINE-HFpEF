



*** Merging both SGLT2 and DPP4 files
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_merged_new.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_final_merged_new.dta"
drop if _merge ==3
order scrssn dpp4 sglt2
gen treatment =1 if sglt2==1
replace treatment =0 if dpp4==1
order scrssn dpp4 sglt2 treatment
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_final_sglt2_dpp4_new.dta", replace