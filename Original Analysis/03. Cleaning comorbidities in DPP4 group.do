*** cleaning comorbidity files in dpp4i


*** STEP 1: Identifying patients with AF
*** Cleaning AF 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_af.dta"
rename ScrSSN scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_af.dta", replace
*** 439 patients with AF

*** Cleaning patients with ablation for AF
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_ablation.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_ablation.dta", replace
*** 3 patients with AF ablation 

*** Merging AF diagnosis codes with ablation 
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_ablation.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_af.dta"
duplicates drop scrssn, force
keep scrssn
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_af.dta", replace
*** 440 patients with AF including procedure and diagnosis codes 

*** Cleaning patients with cardioversion 
clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_cardioversion.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_af.dta"
duplicates drop scrssn, force
keep scrssn
gen AF=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_af_1.dta", replace
*** 443 patients with AF including procedure and diagnosis codes 

*************************************************************************************************************************

*** STEP 2: Identifying patients with chronic lung disease (COPD)
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_copd.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen copd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_copd.dta", replace
*** 582 patients with COPD

*************************************************************************************************************************

*** STEP 3: Identifying patients with depression 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_depression.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen depression=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_depression.dta", replace
*** 393 patients with depression 

*************************************************************************************************************************

*** STEP 4: Identifying patients with ESRD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_esrd.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen esrd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_esrd.dta", replace
*** 12 patients with ESRD  

*************************************************************************************************************************

*** STEP 5: Identifying patients with alcohol use disorder
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_alcoholabuse.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen alcohol=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_alcoholabuse.dta", replace
*** 44 patients with alcohol use disorder  

*************************************************************************************************************************

*** STEP 6: Identifying patients with hypothyroidism 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_hypothyroidism.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen hypothyroidism=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypothyroidism.dta", replace
*** 158 patients with hypothyroidism

*************************************************************************************************************************

*** STEP 7: Identifying patients with hypertension
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_hypertension.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen hypertension=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypertension.dta", replace
*** 589 patients with hypertension

*************************************************************************************************************************

*** STEP 8: Identifying patients with CAD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_cad.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen CAD= 1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_cad.dta", replace
*** 599 patients with stable CAD 

*************************************************************************************************************************
*** STEP 9: Identifying patients with prior MI
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_mi.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen MI=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_mi.dta", replace
*** 143 patients with MI

*************************************************************************************************************************
*** STEP 11: Identifying patients with CKD 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_kidneydisease.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen ckd=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_kidneydisease.dta", replace
*** 461 patients with ckd

*************************************************************************************************************************
*** STEP 12: Identifying patients with chronic liver disease 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_liverdisease.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen cld=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_liverdisease.dta", replace
*** 117 patients with cld

*************************************************************************************************************************
*** STEP 13: Identifying patients with malignancy
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_malignancy.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen cancer=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_malignancy.dta", replace
*** 8 patients with malignancy


*************************************************************************************************************************
*** STEP 14: Identifying patients with PAD
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_pad.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen pad=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pad.dta", replace
*** 142 patients with pad


*************************************************************************************************************************
*** STEP 15: Identifying patients with polysubstance use disorder
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_polyabuse.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen polyabuse=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_polyabuse.dta", replace
*** 72 patients with polysubstance use disorder

*************************************************************************************************************************
*** STEP 16: Identifying patients with prior pacemaker 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_priorpmdc.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen ppm=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_priorpmdc.dta", replace
*** 70 patients with pacemaker 

*************************************************************************************************************************
*** STEP 17: Identifying patients with schizophrenia 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_schizodisorder.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen schizo=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_schizodisorder.dta", replace
*** 24 patients with schizophrenia 


*************************************************************************************************************************
*** STEP 18: Identifying patients with stroke 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_stroke.dta"
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
keep scrssn
gen stroke=1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_stroke.dta", replace
*** 42 patients with stroke

*************************************************************************************************************************
*** STEP 19: Merging all comorbidities 

clear 
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_af_1.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_copd.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_depression.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_esrd.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_alcoholabuse.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypothyroidism.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hypertension.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_cad.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_mi.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_kidneydisease.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_liverdisease.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_malignancy.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pad.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_polyabuse.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_priorpmdc.dta"
drop _merge 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_schizodisorder.dta"
drop _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_stroke.dta"
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
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_comorbidities_merged.dta", replace 