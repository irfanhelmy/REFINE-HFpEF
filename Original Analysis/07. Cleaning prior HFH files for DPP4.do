


**** Cleaning DPP4 prior HF hospitalization files 

**** STEP 1: Identifying those with HF hospitalization 12 months prior to DPP4 initiation 
clear
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\dpp4_priorhfddhospi.dta"

gen dof= dofc(dpp4filltime)
gen admin= dofc(AdmitDateTime)
gen HFH = 1 if dof - admin <365
replace HFH = 0 if HFH==.
keep scrssn dof admin HFH
**** 555 patients with HFH within 12 months prior to DPP4 initiation 


**** STEP 2: Identifying total number of HFH for each patient on DPP4 
by scrssn, sort: gen scrssn_n = _n
bysort scrssn:egen THFH = max(scrssn_n)
bysort scrssn(scrssn_n):keep if _n==_N
keep scrssn HFH THFH
summarize THFH, detail
histogram THFH, normal
gen dpp4 =1 
replace dpp4 = 0 if dpp4==.
save "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\dpp4\diabetes_hf_dpp4_prior_HFH.dta", replace 