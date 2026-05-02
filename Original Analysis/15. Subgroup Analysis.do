*Subgroup analysis

*STEP 1: repeat primary analysis
clear all
use "P:\ORD_Sundaram_202108013D\Padmini\Diabetes Stata Files\VS new files\final_survival_analysis_data_new.dta"
stset outcome, id(scrssn) origin(dof) failure(failure==1) exit(failure ==1 time td(31December2024)) scale(365.25)
stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year
stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year weight2

*STEP 2: subgroup analysis

*Age
gen elderly = 1 if age >=75
replace elderly = 0 if elderly ==.

stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if elderly==1

stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if elderly==0

stcox i.treatment##i.elderly agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

*CKD
stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if ckd==1

stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if ckd==0

stcox i.treatment##i.ckd agegp obesity sex AF copd depression alcohol hypertension  CAD MI cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

*BMI
gen obesity2 = bmi2
recode obesity2 (0/29.9=1) (30/39.9=2) (40/60=3)

stcox treatment agegp sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if obesity2==1

stcox treatment agegp sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if obesity2==2

stcox treatment agegp sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if obesity2==3

stcox treatment##i.obesity2 agegp sex AF copd depression alcohol hypertension  CAD MI cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

*CAD
stcox treatment agegp obesity sex AF copd depression alcohol hypertension MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if CAD==1

stcox treatment agegp obesity sex AF copd depression alcohol hypertension MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if CAD==0

stcox treatment##i.CAD agegp obesity sex AF copd depression alcohol hypertension MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

*AF
stcox treatment agegp obesity sex copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if AF==1

stcox treatment agegp obesity sex copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year if AF==0

stcox treatment##i.AF agegp obesity sex copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin HFH THFH year

*HFH
stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin THFH year if HFH==1

stcox treatment agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin THFH year if HFH==0

stcox treatment##i.HFH agegp obesity sex AF copd depression alcohol hypertension  CAD MI ckd cld cancer pad polyabuse ppm stroke hba1c ACE BB antiarr insulin LD metformin spiro TZD statin THFH year