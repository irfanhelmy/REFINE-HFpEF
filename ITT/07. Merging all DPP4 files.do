
*** Merging all DPP4 files

******************************************************************************************************************************************
*** STEP 1: Merging all files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_comorbidities_merged_new.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_lab_merged_new.dta"
drop _merge
gen dpp4=1
order scrssn dpp4




******************************************************************************************************************************************
*** STEP 2: Replacing missed values in comorbidities to 0
replace AF = 0 if AF==.
replace copd = 0 if copd ==.
replace depression =0 if depression ==.
replace esrd =0 if esrd ==.
replace alcohol = 0 if alcohol ==.
replace hypothyroidism = 0 if hypothyroidism ==.
replace hypertension = 0 if hypertension ==.
replace CAD = 0 if CAD ==.
replace MI =0 if MI ==.
replace ckd =0 if ckd ==.
replace cld =0 if cld ==.
replace cancer =0 if cancer ==.
replace pad =0 if pad ==.
replace polyabuse = 0 if polyabuse ==.
replace ppm =0 if ppm ==.
replace schizo =0 if schizo ==.
replace stroke =0 if stroke ==.

******************************************************************************************************************************************
**** STEP 3: Merging with prior HFH files\dpp4\diabetes_hf_dpp4_final_comorbidities_merged
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_prior_HFH_new.dta", 
drop _merge patientsid
replace HFH=0 if HFH==.
replace THFH =0 if THFH==.
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_merged_new.dta", replace