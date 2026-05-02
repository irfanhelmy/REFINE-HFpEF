**** STEP 1: Merging dod files of SGLT2 and DPP4
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_dodnew.dta"
duplicates drop scrssn MPI_DOD, force
merge 1:m scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_sglt2_dodnew.dta"
duplicates drop scrssn MPI_DOD, force
drop _merge
rename MPI_DOD dod
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4sglt2_dod_final_new.dta", replace

**** STEP 2:  Merging final SGLT-2 and DPP4 combined files to heart failure hospitalization file 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_final_sglt2_dpp4.dta"
gen year= year(dof)
drop dod
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4_sglt2_hf_discharge_new.dta"
drop if _merge==2
drop _merge


**** STEP 3:  Merging with death information file 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\diabetes_hf_dpp4sglt2_dod_final_new.dta"
drop if _merge ==2
drop _merge


**** STEP 4: IPTW 

*** Splitting continous variables (age and BMI) into categorical variables for regression 
gen bmi2 = round(bmi,1)
**rounding bmi values to nearest number 
replace bmi2=. if bmi2>60
*** 22 changes made
drop bmi

** Splitting age into clinically relevant groups
gen agegp=age
recode agegp (18/35=1) (36/45=2) (46/55=3) (56/65=4) (66/75=5) (76/85=6) (86/100=7)
tab agegp

** Splitting BMI into clinically relevant groups
gen obesity = bmi2
recode obesity (0/18.49=1) (18.5/24.99=2) (25.0/29.99=3) (30/34.99=4) (35.0/39.99=5) (40/60=6)

** STEP 4A: Checking standardized difference prior to matching 
pbalchk treatment age bmi sex AF copd depression alcohol hypertension CAD MI cld cancer pad polyabuse ppm schizo stroke creatinine hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

** STEP 4B: Calculating logistic regression, probability of treatment assignment for each patient (total observations ; some missing values)
logistic treatment i.agegp i.obesity sex AF copd depression alcohol hypertension CAD MI cld cancer pad polyabuse ppm schizo stroke creatinine hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

** Calculating p
predict p
gen q=1-p if treatment ==0
drop weight
gen weight=.

** Calculating inverse of probability 
replace weight =1/p if treatment==1
replace weight =1/q if treatment==0

** STEP 4C: Checking balance post matching 
pbalchk treatment age sex bmi2 AF copd depression alcohol hypertension CAD MI cld cancer pad polyabuse ppm schizo stroke creatinine hba1c ACE BB antiarr insulin LD metformin spiro TZD statin year HFH THFH, wt(weight)

** STEP 4D: Residual imbalance post matching; removing extreme weights
gen p2=p if p>0.1 & p<0.9
gen q2=q if q>0.1 & q <0.9

gen weight2=.

replace weight2=1/p2 if treatment ==1
replace weight2=1/q2 if treatment ==0

pbalchk treatment age bmi2  sex AF copd depression alcohol hypertension CAD MI ckd cld cancer pad polyabuse ppm schizo stroke creatinine hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year, wt(weight2)

*** STEP 5: gen outcome date variable (composite of HFH or mortality; whichever comes first)
gen follow_up =.
replace follow_up= mdy(12,31,2024)
gen outcome = min(admission, dod, follow_up)
gen failure = 1 if admission < follow_up | dod < follow_up
replace failure=0 if failure==.

*** STEP 6: Merging with file with entire age and dof information 
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\final_age_dof.dta"
keep if _merge ==3
drop _merge
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\final_survival_analysis_data_new.dta", replace

*** STEP 7: Survival analyses 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\final_survival_analysis_data_new.dta"
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time td(31December2024)) scale(365.25)

*descriptive analysis of (primary) outcome
sum _t, detail
tab _d
tab _d treatment, col

strate treatment, per(100)
stmh treatment

*survival analysis
*doubly robust IPTW-Cox
stcox treatment agegp obesity sex AF copd depression alcohol hypertension CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year weight2
*Cox proportional hazards model only
stcox treatment agegp obesity sex AF copd depression alcohol hypertension CAD MI ckd cld cancer pad polyabuse ppm stroke  hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

*Mortality only
drop outcome failure
gen outcome=min(dod, follow_up)
gen failure = 0 if dod > follow_up
replace failure=1 if failure==.
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time td(31December2024)) scale(365.25)

*descriptive analysis
tab _d
tab _d treatment, col

strate, per(100)
strate treatment, per(100)
stmh treatment

stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year weight2

stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year