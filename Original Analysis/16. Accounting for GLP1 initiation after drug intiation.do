

*** STEP 1: Cleaning SGLT initiation after in DPP4 files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\dpp4glp1.dta", replace
gen treatment =0
gen glp1_after =1 
keep scrssn treatment glp1_after
duplicates drop scrssn, force
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_glp1_after_cleaned.dta", replace

*** STEP 2: Cleaning SGLT initiation after in SGLT2 files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\sglt2glp1.dta", replace
gen treatment =1
gen glp1_after = 1 
keep scrssn treatment glp1_after
duplicates drop scrssn, force
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_glp1_after_cleaned.dta", replace

*** STEP 3: Merging these two files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_glp1_after_cleaned.dta"
merge 1:1 scrssn using  "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_glp1_after_cleaned.dta"
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_glp1_after_cleaned.dta", replace 

*** STEP 4: Survival analysis 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\final_survival_analysis_data_new.dta",
merge m:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_glp1_after_cleaned.dta"
drop if _merge ==2
drop _merge
replace glp1_after = 0 if glp1_after==.

stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time td(31December2024)) scale(365.25)

stcox treatment agegp obesity sex AF copd depression alcohol hypertension CAD MI ckd cld cancer pad polyabuse ppm schizo stroke creatinine hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year glp1_after weight2

stcox treatment agegp obesity sex AF copd depression alcohol hypertension CAD MI ckd cld cancer pad polyabuse ppm schizo stroke creatinine hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year glp1_after

**** Interaction between SGLT2 and GLP1
stcox i.treatment##i.glp1_after agegp obesity sex AF copd depression alcohol hypertension CAD MI ckd cld cancer pad polyabuse ppm schizo stroke creatinine hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year weight2

