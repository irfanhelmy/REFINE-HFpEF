*** cleaning comorbidity files in dpp4i


*** STEP 1: Cleaning age and sex files
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_agerf1.dta"
rename ScrSSN scrssn
gen dof= dofc(dpp4filltime)
gen sex = 1 if SEX=="M"
replace sex=2 if SEX=="F"
drop SEX
rename DOB dob
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_age_new.dta", replace
*****************************************************************************************************************************

*** STEP 2: Cleaning dob and dod files 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_dodrf1.dta"
rename Scrssn scrssn
by scrssn, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
rename MPI_DOD dod
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_dod_new.dta", replace
*** 80 patients who died during follow up
*****************************************************************************************************************************

*** STEP 3: Merging age,sex,dob and dod files
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_age_new.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_dod_new.dta"
gen survival = dod-dof
count if survival <0
drop if survival < 0
gen survival1 = dod -dob
count if survival1<0
drop _merge survival survival1
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_demograhics_new.dta", replace
*****************************************************************************************************************************

*** STEP 4: Cleaning BMI files (BMI AT BASELINE)
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_bmirf1.dta"
rename ScrSSN scrssn
duplicates drop scrssn, force
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_bmi_new.dta", replace

*****************************************************************************************************************************
*** STEP 5: Cleaning BNP files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_bnprf1.dta"
drop patientsid
drop if LabChemResultNumericValue > 20000
***51 observations deleted
*** bnp > 10000 is likely an error 
gen dof= dofc(dpp4filltime)
gen bnpdate = dofc(LabChemCompleteDateTime)
by scrssn bnpdate, sort: gen scrssn_n = _n
*** droping duplicate values of bnp

keep if scrssn_n==1
drop scrssn_n
by scrssn, sort: gen scrssn_n = _n
bysort scrssn bnpdate: keep if scrssn_n==_N
*** keeping only bnp value closest to the drug filling date

count if bnpdate > dof
*** doublechecking to make sure all bnp values are before durg initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue bnpvalue
keep scrssn dof bnpdate bnpvalue
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_bnp_new.dta", replace 
*** 35 patients with BNP value


*****************************************************************************************************************************
*** STEP 5: Cleaning proBNP files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_pbnprf1.dta"

drop if LabChemResultNumericValue > 100000
***51 observations deleted
*** proBNP > 100000 is likely an error 
gen dof= dofc(dpp4filltime)
gen pbnpdate = dofc(LabChemCompleteDateTime)
by scrssn pbnpdate, sort: gen scrssn_n = _n
*** droping duplicate values of pro bnp

keep if scrssn_n==1
drop scrssn_n
by scrssn, sort: gen scrssn_n = _n
bysort scrssn pbnpdate: keep if scrssn_n==_N
*** keeping only pro bnp value closest to the drug filling date

count if pbnpdate > dof
*** doublechecking to make sure all pro bnp values are before durg initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue pbnp
keep scrssn dof pbnpdate pbnp
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pbnp_new.dta", replace 
*** 49 patients with proBNP value

*****************************************************************************************************************************
*** STEP 6: Cleaning creatinine files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_creatrf1.dta"

gen creatdate = dofc(LabChemCompleteDateTime)
gen dof= dofc(DPP4Filltime)
rename ScrSSN scrssn

drop if LabChemResultNumericValue > 10
*** creatinine > 10 is likely an error 

by scrssn creatdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of creatinine

by scrssn, sort: gen scrssn_n = _n
bysort scrssn creatdate: keep if scrssn_n==_N
*** keeping only creatinine value closest to the drug filling date

count if creatdate > dof
*** doublechecking to make sure all creatinine values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue creatinine
keep scrssn dof creatdate creatinine
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_creatinine_new.dta", replace 
*** 90 patients with creatinine value

*****************************************************************************************************************************
*** STEP 7: Cleaning albumin files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_albuminrf1.dta"

gen albumindate = dofc(LabChemCompleteDateTime)
gen dof= dofc(dpp4filltime)

keep if LabChemTestName == "ALBUMIN" 
*** values included urine albumin, microalbumin and other irrelevant variables

drop if LabChemResultNumericValue > 5
*** albumin > 5 is likely an error 

by scrssn albumindate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of ALBUMIN 

by scrssn, sort: gen scrssn_n = _n
bysort scrssn albumindate: keep if scrssn_n==_N
*** keeping only albumin value closest to the drug filling date

count if albumindate > dof
*** doublechecking to make sure all albumin values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue albumin
keep scrssn dof albumindate albumin
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_albumin_new.dta", replace
***754 patients with albumin values 

*****************************************************************************************************************************
*** STEP 8: Cleaning hemoglobin files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_hemorf1.dta"

gen hemoglobindate = dofc(LabChemCompleteDateTime)
gen dof= dofc(dpp4filltime)

drop if LabChemResultNumericValue > 20 
drop if LabChemResultNumericValue < 4
*** cleaning erroneous values

drop if regexm( LabChemTestName, "GLYCATED")==1
**Some glycated HB values

by scrssn hemoglobindate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of Hb

by scrssn, sort: gen scrssn_n = _n
bysort scrssn hemoglobindate: keep if scrssn_n==_N
*** keeping only Hb value closest to the drug filling date

count if hemoglobindate > dof
*** doublechecking to make sure all Hb values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue hemoglobin
keep scrssn dof hemoglobindate hemoglobin
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hemoglobin_new.dta", replace
***88 patients with hemoglobin values 

*****************************************************************************************************************************
*** STEP 9: Cleaning hematocrit files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_hematorf1.dta"

gen hctdate = dofc(LabChemCompleteDateTime)
gen dof= dofc(dpp4filltime)

drop if LabChemResultNumericValue >70
*** cleaning erroneous values

by scrssn hctdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of Hct

by scrssn, sort: gen scrssn_n = _n
bysort scrssn hctdate: keep if scrssn_n==_N
*** keeping only hct value closest to the drug filling date

count if hctdate > dof
*** doublechecking to make sure all Hct values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue hct
keep scrssn dof hctdate hct
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hct_new.dta", replace
***87 patients with hct levels

*****************************************************************************************************************************
*** STEP 10: Cleaning ALP files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_alphorf1.dta"

gen alpdate = dofc(LabChemCompleteDateTime)
gen dof= dofc(dpp4filltime)

count if LabChemResultNumericValue <5
drop if LabChemResultNumericValue >3000
*** cleaning erroneous values

by scrssn alpdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of ALP

by scrssn, sort: gen scrssn_n = _n
bysort scrssn alpdate: keep if scrssn_n==_N
*** keeping only ALP value closest to the drug filling date

count if alpdate > dof
*** doublechecking to make sure all ALP values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue alp
keep scrssn dof alpdate alp
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_alp_new.dta", replace
**958 patients with ALP values 

*****************************************************************************************************************************
*** STEP 11: Cleaning AST files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_astrf1.dta"

gen astdate = dofc(LabChemCompleteDateTime)
gen dof= dofc(dpp4filltime)

count if LabChemResultNumericValue <5
drop if LabChemResultNumericValue >5000
*** cleaning erroneous values

by scrssn astdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of AST

by scrssn, sort: gen scrssn_n = _n
bysort scrssn astdate: keep if scrssn_n==_N
*** keeping only AST value closest to the drug filling date

count if astdate > dof
*** doublechecking to make sure all AST values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue ast
keep scrssn dof astdate ast
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_ast_new.dta", replace


*****************************************************************************************************************************
*** STEP 12: Cleaning bilirubin files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_bilirf1.dta"

gen bilirubindate = dofc(LabChemCompleteDateTime)
gen dof= dofc(dpp4filltime)

drop if regexm( LabChemTestName, "URINE")==1
drop if regexm( LabChemTestName, "DIRECT")==1
*** dropping urine bilirubin and values with only direct bilirubin

drop if LabChemResultNumericValue >50
*** cleaning erroneous values

by scrssn bilirubindate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of bilirubin

by scrssn, sort: gen scrssn_n = _n
bysort scrssn bilirubindate: keep if scrssn_n==_N
*** keeping only bilirubin value closest to the drug filling date

count if bilirubindate > dof
*** doublechecking to make sure all bilirubin values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue bilirubin
keep scrssn dof bilirubindate bilirubin
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_bilirubin_new.dta", replace

*** 76 patients with bilirubin values 


*****************************************************************************************************************************
*** STEP 13: Cleaning HBA1c files 

clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\diabetes_hf_dpp4_hba1crf1.dta",

gen hba1cdatedate = dofc(LabChemCompleteDateTime)
gen dof= dofc(dpp4filltime)

drop if LabChemResultNumericValue >15
*** cleaning erroneous values

by scrssn hba1cdate, sort: gen scrssn_n = _n
keep if scrssn_n==1
drop scrssn_n
*** droping duplicate values of hba1c

by scrssn, sort: gen scrssn_n = _n
bysort scrssn hba1cdate: keep if scrssn_n==_N
*** keeping only hba1c value closest to the drug filling date

count if hba1cdatedate > dof
*** doublechecking to make sure all hba1c values are before drug initiation

duplicates drop scrssn, force
rename LabChemResultNumericValue hba1c
keep scrssn dof hba1cdate hba1c
*** cleaning variables  

save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hba1c_new.dta", replace
*** 78 patients with HBA1C values 

*****************************************************************************************************************************
*** STEP 13: Merging all laboratory files 
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_demograhics_new.dta"
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_bmi_new.dta"
drop dpp4filltime HeightTime WeightTime _merge
rename heightresult height
rename weightresult weight
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_bnp_new.dta"
rename bnpvalue bnp
drop bnpdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_pbnp_new.dta"
drop pbnpdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_creatinine_new.dta"
drop creatdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_albumin_new.dta"
drop albumindate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hemoglobin_new.dta"
drop hemoglobindate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hct_new.dta"
drop hctdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_alp_new.dta"
drop alpdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_ast_new.dta"
drop astdate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_bilirubin_new.dta"
drop bilirubindate _merge
merge 1:1 scrssn using "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_hba1c_new.dta"
drop hba1cdate _merge
order scrssn age sex dob dof height weight bmi bnp pbnp creatinine hemoglobin hba1c hct albumin alp bilirubin ast
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_final_lab_merged_new.dta", replace
***91 patients with DPP4  and SU