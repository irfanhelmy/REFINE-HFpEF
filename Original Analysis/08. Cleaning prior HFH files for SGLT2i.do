
**** Cleaning glp1 prior HF hospitalization files 

**** STEP 1: Identifying those with HF hospitalization 12 months prior to sglt2 initiation 
clear
cd "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files"
use sglt2_priorhfddhospi.dta

gen dof= dofc(sglt2filltime)
gen admin= dofc(AdmitDateTime)
gen HFH = 1 if dof - admin <365
replace HFH = 0 if HFH==.
keep scrssn dof admin HFH


**** STEP 2: Identifying total number of HFH for each patient on sglt2 
by scrssn, sort: gen scrssn_n = _n
bysort scrssn:egen THFH = max(scrssn_n)
bysort scrssn(scrssn_n):keep if _n==_N
keep scrssn HFH THFH
summarize THFH, detail
histogram THFH, normal
gen sglt2 =1 
replace sglt2 = 0 if sglt2==.
count if HFH==1
**** 859 patients with prior HFH
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\sglt2\diabetes_hf_sglt2_prior_HFH.dta", replace