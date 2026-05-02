*** cleaning comorbidity files in dpp4i


*** STEP 1: Identifying patients with AF
*** Cleaning AF 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_afrf1.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_af_new.dta", replace
*** 35 patients with AF


*** Cleaning patients with cardioversion 
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_cardiorf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_af_new.dta"
duplicates drop scrssn, force
keep scrssn
gen AF=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_af_new.dta", replace
*** 35 patients with AF including procedure and diagnosis codes 

*************************************************************************************************************************

*** STEP 2: Identifying patients with chronic lung disease (COPD)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_copdrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen copd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_copd_new.dta", replace
*** 52 patients with COPD

*************************************************************************************************************************

*** STEP 3: Identifying patients with depression 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_deprf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen depression=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_depression_new.dta", replace
*** 24 patients with depression 

*************************************************************************************************************************

*** STEP 4: Identifying patients with ESRD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_esrdrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen esrd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_esrd_new.dta", replace
*** 3 patients with ESRD  

*************************************************************************************************************************

*** STEP 5: Identifying patients with alcohol use disorder
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_alcoholrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen alcohol=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_alcoholabuse_new.dta", replace
*** 5 patients with alcohol abuse  

*************************************************************************************************************************

*** STEP 6: Identifying patients with hypothyroidism 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_hypothyrrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen hypothyroidism=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypothyroidism_new.dta", replace
*** 12 patients with hypothyroidism

*************************************************************************************************************************

*** STEP 7: Identifying patients with hypertension
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_hyperrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen hypertension=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypertension_new.dta", replace
*** 60 patients with hypertension

*************************************************************************************************************************

*** STEP 8: Identifying patients with CAD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_cadrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen CAD= 1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_cad_new.dta", replace
*** 57 patients with stable CAD 

*************************************************************************************************************************
*** STEP 9: Identifying patients with prior MI
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_mirf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen MI=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_mi_new.dta", replace
*** 15 patients with MI

*************************************************************************************************************************
*** STEP 11: Identifying patients with CKD 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_kdrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen ckd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_kidneydisease_new.dta", replace
*** 48 patients with ckd

*************************************************************************************************************************
*** STEP 12: Identifying patients with chronic liver disease 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_ldrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen cld=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_liverdisease_new.dta", replace
*** 8 patients with cld

*************************************************************************************************************************
*** STEP 13: Identifying patients with malignancy
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_malignancyrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen cancer=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_malignancy_new.dta", replace
*** 13 patients with malignancy


*************************************************************************************************************************
*** STEP 14: Identifying patients with PAD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_padrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen pad=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pad_new.dta", replace
*** 12 patients with pad


*************************************************************************************************************************
*** STEP 15: Identifying patients with polysubstance use disorder
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_polyabuserf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen polyabuse=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_polyabuse_new.dta", replace
*** 8 patients with polysubstance abuse

*************************************************************************************************************************
*** STEP 16: Identifying patients with prior pacemaker 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_priorpmdcrf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen ppm=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_priorpmdc_new.dta", replace
*** 6 patients with pacemaker 

*************************************************************************************************************************
*** STEP 17: Identifying patients with schizophrenia 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_schizorf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen schizo=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_schizodisorder_new.dta", replace
*** 13 patients with schizophrenia 


*************************************************************************************************************************
*** STEP 18: Identifying patients with stroke 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_strokerf1.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen stroke=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_stroke_new.dta", replace
*** 2 patients with stroke

*************************************************************************************************************************
*** STEP 19: Merging all comorbidities 

clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_af_new.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_copd_new.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_depression_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_esrd_new.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_alcoholabuse_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypothyroidism_new.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypertension_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_cad_new.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_mi_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_kidneydisease_new.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_liverdisease_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_malignancy_new.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pad_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_polyabuse_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_priorpmdc_new.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_schizodisorder_new.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_stroke_new.dta"
drop _merge 
replace AF=0 if AF==.
replace copd = 0 if copd==.
replace depression = 0 if depression==.
replace esrd = 0 if esrd ==.
replace alcohol = 0 if alcohol ==.
replace hypothyroidism = 0 if hypothyroidism ==.
replace hypertension = 0 if hypertension ==.
replace CAD = 0 if CAD ==.
replace MI = 0 if MI ==.
replace ckd = 0 if ckd ==.
replace cld = 0 if cld ==.
replace cancer = 0 if cancer ==.
replace pad = 0 if pad ==.
replace polyabuse = 0 if polyabuse ==.
replace ppm = 0 if ppm ==.
replace schizo = 0 if schizo ==.
replace stroke = 0 if stroke ==.
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_comorbidities_merged_new.dta", replace 