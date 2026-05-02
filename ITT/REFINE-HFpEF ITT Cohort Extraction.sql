/* SGLT2i HFpEF Study: Intention-to-treat-like analysis (i.e., removing three consecutive refill prescription requirement; only requiring 1 refill for cohort entry; start follow-up time from date of first prescription */

/* Run the below command to select the required database */
use ORD_Sundaram_202108013D
go

/* Extract patients on SGLT2 with 1 or more refill */

/* SGLT2 */
/* Extract all the patients that are on SGLT2 */

select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as SGLT2FillTime , b.FillNumber, b.DaysSupply, b.drugnamewithoutdose, a.FirstHF_dischargedatetime 

into #tempSGLT2

from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
union all

select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as SGLT2FillTime , b.FillNumber, b.DaysSupply, b.DrugNameWithoutDose, a.FirstHF_dischargedatetime 

from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%'

select distinct scrssn from #tempsglt2 -- 26,880

/* FInd the total number of refills for each patient */

select scrssn, sum(FillNumber) as FillNumber 
into #tempfillnumber
from #tempSGLT2 group by scrssn 

drop table #tempfillnumber

/* Find the date of medication intiation */

select scrssn, min(SGLT2FillTime) as SGLT2FillTime
into #temp
from #tempSGLT2 group by scrssn

/* Combine the above two tables */

select distinct b.scrssn, b.SGLT2FillTime, a.FillNumber
into #tempfilldate
from #tempfillnumber as a with (NOLOCK) inner join 
#temp as b with (NOLOCK) on a.scrssn= b.scrssn 

select distinct a.patientsid, b.scrssn, b.SGLT2FillTime, b.FillNumber, a.FirstHF_dischargedatetime
into #date
from #tempsglt2 as a with (NOLOCK) inner join 
#tempfilldate as b with (NOLOCK) on a.scrssn= b.scrssn and a.SGLT2FillTime= b.SGLT2FillTime
where b.SGLT2Filltime between '2014-01-01 00:00:00' and '2021-12-31 23:59:59'
and b.SGLT2Filltime >= dateadd(day, 30, a.FirstHF_Dischargedatetime)


select distinct scrssn from #date --9959

/* Find the patients that were on DPP4 1 year prior to SGLT2 initiation */
select distinct a.scrssn, a.SGLT2FillTime, a.PatientSID, b.FillDateTime

into #DPP4

from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or 
      LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 
--and b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.scrssn, a.SGLT2FillTime, a.PatientSID, b.FillDateTime
from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

Select *

into #DPP4Date 

from #DPP4 where FillDateTime between dateadd(month, -12, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from #DPP4Date --3756

/* Exclude the patients that were on DPP4 1 year prior to SGLT2 initiation */

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into #SGLT2excludeDpp4

from #date as a where a.fillnumber >=1
AND NOT EXISTS (Select * from #dpp4Date as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #SGLT2excludeDpp4 --6,203    
select distinct scrssn from #SGLT2excludeDpp4 where fillnumber <2 --439
/* Find patients with 2 refills and above */
select distinct a.scrssn, a.Fillnumber, b.SGLT2Filltime, b.PatientSID

into #temp_Diabetes_HF_SGLT2

from  #SGLT2excludeDpp4 as a with (NOLOCK) inner join
#date as b with (NOLOCK) on a.Scrssn= b.Scrssn 
where a.fillnumber >=1 

select distinct scrssn from #temp_Diabetes_HF_SGLT2 --6,203
select distinct * from #date

/* Combine patients that were on either on loop refill>1 or elevated bnp/pbnp or HF ICD9/10 hospitalization 1 year prior to the drug initiation */
select distinct a.*

into #tempDiabetes_HF_SGLT2_Final

from #temp_Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
#tempmedLoop as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
and b.Fillnumber >1
union all

select distinct a.*

from #temp_Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50_BNP_PBNP as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.LabChemCompleteDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*

from #temp_Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.comorbidity_Dischargedatetime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from #tempDiabetes_HF_SGLT2_Final --3,916

/* Find patients that had Ejection Fraction less than 50 prior to the drug initiation */
select distinct a.*, b.Low_Value

into #templess50

from #tempDiabetes_HF_SGLT2_Final as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
--where b.Low_Value between 10 and 49 and b.ValueDateTime between dateadd(year, -1, a.SGLT2FillTime) and a.SGLT2FillTime
where b.Low_Value < 50 and b.ValueDateTime between dateadd(year, -1, a.SGLT2FillTime) and a.SGLT2FillTime

select distinct scrssn from #templess50 --2631

/* Exclude patients that had EF less than 50 prior to the drug initiation */ 
select distinct a.*

into Dflt.Diabetes_HF_SGLT2_Finalrefill1

from #tempDiabetes_HF_SGLT2_Final as a where a.fillnumber >=1
AND NOT EXISTS (Select * from #templess50 as b where a.ScrSSN = b.ScrSSN)

select distinct  scrssn from Dflt.Diabetes_HF_SGLT2_Finalrefill1 --1,285

/* Exclusion codes */

select distinct a.*,  b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/
into #exclusioncodesSGLT2

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')

union all

select distinct a.*,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

select distinct scrssn from #exclusioncodesSGLT2 --150

select * from #exclusioncodesSGLT2

drop table #exclusioncodesSGLT2final 

select *

into #exclusioncodesSGLT2final

from #exclusioncodesSGLT2 where comorbidity_Dischargedatetime <= '2021-01-01 23:59:59' or comorbidity_Dischargedatetime is Null

select distinct scrssn from #exclusioncodesSGLT2final --47

/* Exclude patients with the above exclusion code to get the final cohort */
select distinct a.*

into Dflt.Diabetes_HF_SGLT2_Final11refill1

from dflt.Diabetes_HF_SGLT2_Finalrefill1 as a where a.Fillnumber >=1
AND NOT EXISTS (Select * from #exclusioncodesSGLT2final as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Final11refill1 --1,135 
select distinct a.scrssn, a.sglt2filltime, a.fillnumber, b.patientsid

into Dflt.Diabetes_HF_SGLT2_FinalRF1

from Dflt.Diabetes_HF_SGLT2_Final11refill1 as a with (NOLOCK) inner join
Src.CohortCrosswalk as b with (NOLOCK) on a.scrssn= b.scrssn 

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_FinalRF1 --1,135

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_FinalRF1 where fillnumber=1

select distinct a.scrssn
from Dflt.Diabetes_HF_SGLT2_Final1 as a with (NOLOCK) inner join
dflt.Diabetes_HF_SGLT2_FinalRF1 as b with (NOLOCK) on a.scrssn= b.scrssn --where fillnumber <2

select * from Dflt.Diabetes_HF_SGLT2_Final1 where scrssn=016201867
select * from dflt.Diabetes_HF_SGLT2_FinalRF1 where scrssn=016201867
select * from #tempsglt2 where scrssn=016201867
select distinct scrssn from dflt.Diabetes_HF_SGLT2_FinalRF1 where fillnumber=1


select distinct a.scrssn

into #tempoverlapsglt2

from Dflt.Diabetes_HF_SGLT2_Final1 as a with (NOLOCK) inner join
dflt.Diabetes_HF_SGLT2_FinalRF1 as b with (NOLOCK) on a.scrssn= b.scrssn where b.fillnumber =1

Select distinct a.*

into dflt.Diabetes_HF_SGLT2_RF1

from dflt.Diabetes_HF_SGLT2_FinalRF1 as a where a.fillnumber =1
AND NOT EXISTS (Select * from #tempoverlapsglt2 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from dflt.Diabetes_HF_SGLT2_RF1 --17


/* DPP4 cohort extraction usinf refill >=1 */

select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as DPP4FillTime, b.FillNumber, b.DaysSupply, b.Qty, b.DrugNameWithoutDose, a.FirstHF_dischargedatetime

into #tempDPP4

from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%'

union all

select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as DPP4FillTime, b.FillNumber, b.DaysSupply, b.Qty, b.DrugNameWithoutDose, a.FirstHF_dischargedatetime
from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' or
 LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%'


select distinct scrssn from #tempDPP4 --111,895

/* Find the DPP4 Fill time */

select scrssn, min(DPP4FillTime) as DPP4FillTime
into #temp1
from #tempDpp4 group by scrssn

select * from #temp1

/* Add the refills for DPP4 */

select scrssn, sum(FillNumber) as FillNumber 
into #tempfillnumberDPP4
from #tempDPP4 group by scrssn 

select * from #tempfillnumberDPP4

select distinct  b.scrssn, a.DPP4FillTime, b.FillNumber
into #temp2
from #temp1 as a with (NOLOCK) left outer join 
#tempfillnumberDPP4 as b with (NOLOCK) on a.scrssn= b.scrssn --and a.DPP4FillTime= b.DPP4FillTime

select distinct scrssn from #temp2

select distinct b.scrssn, b.DPP4FillTime, b.FillNumber,a.patientsid, a.FirstHF_Dischargedatetime
into #date1
from #tempdpp4 as a with (NOLOCK) left outer join 
#temp2 as b with (NOLOCK) on a.scrssn= b.scrssn and b.DPP4FillTime=a.DPP4FillTime
where b.DPP4FillTime between '2014-01-01 00:00:00' and '2021-12-31 23:59:59'
and b.DPP4FillTime >= dateadd(day, 30, a.FirstHF_Dischargedatetime)

select distinct scrssn from #date1--4907


/* Remove SGLT2 from DPP4 */

select distinct a.scrssn, a.DPP4FillTime, a.PatientSID, b.FillDateTime

into #SGLT2

from #date1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
union all

select distinct a.scrssn, a.DPP4FillTime, a.PatientSID, b.FillDateTime
from #date1 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 

select distinct scrssn from #SGLT2 --1501

select * 
into #SGLT21
from #SGLT2 where FillDateTime between dateadd(month, -12, DPP4FillTime) and dateadd(day, 1, DPP4FillTime) 

select distinct scrssn from #sglt21 --229

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into #Dpp4excludeSGLT2

from #date1 as a where a.fillnumber >=1
AND NOT EXISTS (Select * from #sglt21 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #Dpp4excludeSGLT2--4677 --->=2 is 4303

select distinct a.scrssn, b.fillnumber, a.DPP4FillTime, a.Patientsid

into #temp_Diabetes_HF_DPP4

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
#tempfillnumberDPP4 as b with (NOLOCK) on a.Scrssn= b.scrssn
where b.FillNumber>=1 

select distinct scrssn from #temp_Diabetes_HF_DPP4 -- 4677

/* combine all 3 to get the final cohort */

select distinct a.*--, b.FillNumber, b.FillDateTime

into #tempDiabetes_HF_DPP4_Final

from #temp_Diabetes_HF_DPP4 as a with (NOLOCK) inner join
#tempmedLoop as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
and b.Fillnumber >1
union all

select distinct a.*--, b.LabChemCompleteDateTime, b.LabChemResultNumericValue, b.LabChemTestName 

from #temp_Diabetes_HF_DPP4 as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50_BNP_PBNP as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.LabChemCompleteDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*--, b.DischargeDateTime, b.comorbidity_ICD9Code as HFICDCode

from #temp_Diabetes_HF_DPP4 as a with (NOLOCK) inner join
Dflt.Diabetes_HF as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.comorbidity_Dischargedatetime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempDiabetes_HF_DPP4_Final -- 2951

select distinct a.*, b.Low_Value

into #templess50DPP4

from #tempDiabetes_HF_DPP4_Final as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.Low_Value <50 and b.ValueDateTime between dateadd(year, -1, a.DPP4FillTime) and a.dpp4filltime

select distinct scrssn from #templess50DPP4-- 1679

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into Dflt.Diabetes_HF_DPP4_Finalrefill1

from #tempDiabetes_HF_DPP4_Final as a where a.fillnumber >=1
AND NOT EXISTS (Select * from #templess50DPP4 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Finalrefill1 --1272

drop table Dflt.Diabetes_HF_DPP4_Final

/* EXCLUSION CODES DPP4 */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

select distinct a.*,  b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into #exclusioncodesDPP4

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

select distinct scrssn from #ExclusionCodesdpp4 -- 132

/* Final DPP4 cohort after exclusions */

select distinct a.*

into Dflt.Diabetes_HF_DPP4_Final11refill1

from Dflt.Diabetes_HF_DPP4_Finalrefill1 as a where a.Fillnumber >=1
AND NOT EXISTS (Select * from #ExclusionCodesdpp4 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Final11refill1--1140 

/* Add patientsid from cohortcrosswalk for each scrssn */

select distinct a.scrssn, a.dpp4filltime, a.fillnumber, b.patientsid
into Dflt.Diabetes_HF_DPP4_FinalRF1
from Dflt.Diabetes_HF_DPP4_Final11refill1 as a with (NOLOCK) inner join
Src.CohortCrosswalk as b with (NOLOCK) on a.scrssn= b.scrssn 

select distinct scrssn from Dflt.Diabetes_HF_DPP4_FinalRF1--1140

select distinct scrssn from Dflt.Diabetes_HF_DPP4_FinalRF1 where fillnumber=1 --137

select distinct a.scrssn 

from Dflt.Diabetes_HF_DPP4_Final1 as a with (NOLOCK) inner join
dflt.Diabetes_HF_DPP4_FinalRF1 as b with (NOLOCK) on a.scrssn= b.scrssn where b.fillnumber =1 --46

select distinct a.scrssn
into #tempoverlapdpp4

from Dflt.Diabetes_HF_DPP4_Final1 as a with (NOLOCK) inner join
dflt.Diabetes_HF_DPP4_FinalRF1 as b with (NOLOCK) on a.scrssn= b.scrssn where b.fillnumber =1 

Select distinct a.*

into dflt.Diabetes_HF_DPP4_RF1

from dflt.Diabetes_HF_DPP4_FinalRF1 as a where a.fillnumber =1
AND NOT EXISTS (Select * from #tempoverlapdpp4 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from dflt.Diabetes_HF_DPP4_RF1 --91

/* SGLT2 Refill 1 extraction */

/* Demographics */
/* Age */

select a.ScrSSN, a.sglt2Filltime, b.DOB,b.SEX
into Dflt.Diabetes_HF_SGLT2_DOBRF1
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, sglt2Filltime) as age
into Dflt.Diabetes_HF_SGLT2_AgeRF1
from Dflt.Diabetes_HF_SGLT2_DOBRF1

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AgeRF1 where SEX ='F' --0

/* Date of Death */

select a.Scrssn, b.MPI_DOD

into Dflt.Diabetes_HF_SGLT2_DODRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.SDAF_DAFMaster as b with (NOLOCK) on a.scrssn= b.MPI_scrssn
where b.MPI_DOD is not null 

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_DODRF1 --13

/* Race */

select a.*,  b.Race
into Dflt.Diabetes_HF_SGLT2_RaceRF1
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_RaceRF1 --17

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_HypertensionRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_HypertensionRF1 --12
select * into Dflt.Diabetes_HF_SGLT2_HyperRF1 from Dflt.Diabetes_HF_SGLT2_HypertensionRF1


/*including ICD9 codes for CKD4 + 5 (Irfan) */

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_KidneyDiseaseRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_KidneyDiseaseRF1 --14

select * into Dflt.Diabetes_HF_SGLT2_KDRF1 from Dflt.Diabetes_HF_SGLT2_KidneyDiseaseRF1

/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_ESRDRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ESRDRF1 --0

/* Alcohol Abuse */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_AlcoholAbuseRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AlcoholAbuseRF1--0

/*Polysubstance Abuse */
/*Making sure the ICD9 and ICD10 codes relevant to Polysubstance Abuse are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
																	'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
																	'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
																	'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
															'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10',
															'305.70','304.40','304.6')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_PolyAbuseRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

Select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PolyAbuseRF1 --0

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
drop table Dflt.Diabetes_HF_SGLT2_Malignancy

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_MalignancyRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_MalignancyRF1--0


/* Hypothyroidism */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like ('244.%')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like ('E03.%')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_HypothyroidRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_HypothyroidRF1 --1


/*Smoking */

select distinct a.*, b.SMOKE

into Dflt.Diabetes_HF_SGLT2_SmokeRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select * from Dflt.Diabetes_HF_SGLT2_SmokeRF1
select distinct scrssn from Dflt.Diabetes_HF_SGLT2_SmokeRF1 where smoke = '1' --3
 
/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_StrokeRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_StrokeRF1--1

/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_MIRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.SGLT2FillTime

Select distinct scrssn from Dflt.Diabetes_HF_SGLT2_MIRF1 --3

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_HF_SGLT2_AblationRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all 

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.visitdatetime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.SGLT2Filltime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AblationRF1 --0

/* CAD */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_CADRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_CADRF1--14

/* CAD- PCI & CABG */

select a.*, b.SURGDATE

into #tempCABGSGLT2

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
src.VASQIP_nso_cardiac as b with (NOLOCK) on a.scrssn= b.scrssn
where b.cpt01 in ('33533','33534','33535','33536','33542','33545','33548')
and b.SURGDATE <= a.SGLT2filltime /* Check the dates */

select * from #tempCABGSGLT2

select a.*, b.ProcedureDateTime

into #tempPCISGLT2

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.CART_PCI as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.ProcedureDateTime <= a.SGLT2filltime /* Check the dates */

Select distinct patientsid, scrssn, SGLT2FillTime, surgdate

into Dflt.Diabetes_HF_SGLT2_cadCabgpciRF1

from #tempCABGSGLT2
union all

select distinct patientsid, scrssn, SGLT2FillTime, ProcedureDateTime
from #tempPCISGLT2
union all 

select distinct patientsid, scrssn, SGLT2FillTime, comorbidity_Dischargedatettime
from Dflt.Diabetes_HF_SGLT2_CADRF1

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_cadCabgpciRF1 --14

/* PAD */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_PADRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PADRF1--1

/*Cardioversion*/

/*Making sure the CPT codes relevant to Cardioversion are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92960','92961')

select distinct a.*

into Dflt.Diabetes_HF_SGLT2_CardioRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all 

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')


select distinct scrssn from Dflt.Diabetes_HF_SGLT2_CardioRF1

drop table Dflt.Diabetes_HF_SGLT2_CardioRF1

/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_HF_SGLT2_CardioRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.SGLT2Filltime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_CardioRF1--0

/* Atrial Fibrillation */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('427.31')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'I48.%'

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_AFRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AFRF1 --4

/*ICD9 and 10 Procedure codes for Ablation */

/* Ablation Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_HF_SGLT2_AbProcRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.SGLT2Filltime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AbProcRF1 --0

/* Schizoprenic Disorder */
/*Making sure the ICD9 and ICD10 codes relevant to Schizoprenic Disorder are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like '295.%'

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_SchizoRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_SchizoRF1--1

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_DepRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_DepRF1--6

/* COPD Chronic Lung Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_COPDRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_COPDRF1--11

/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_LDRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_LDRF1--4

/* Prior Pacemaker */
/*Making sure the ICD9 and ICD10 codes relevant to Prior Pacemaker are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('V45.01','V45.02')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('Z95.0','Z95.810')

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('33210','33206','33207','33216','33217')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_PriorPMRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PriorPMRF1--2

/*BMI*/
/* Select height and weight values from vital signs view to calculate bmi */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitals

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(DAY, 1, b.SGLT2FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.SGLT2FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.SGLT2FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitals --17

/* Seperate weight records into a table */
select * 

into #tempweight

from #tempDiabetesVitals where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweight --17

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1
from #tempweight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinal
from #tempweight as a with (NOLOCK) left outer join 
#tempweight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinal --17

/* Seperate height records into a table */
select *  

into #tempheight

from #tempDiabetesVitals where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheight --17

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1
from #tempheight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinal
from #tempheight as a with (NOLOCK) left outer join 
#tempheight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinal --17

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_HF_SGLT2_BMIRF1

from #tempheightfinal as a with (NOLOCK) inner join
#tempweightfinal as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.SGLT2FillTime=b.SGLT2FillTime and

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMIRF1 where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMIRF1 where bmi between 35 and 40

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMIRF1 where bmi > 40

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMIRF1 where bmi < 30 --3

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMIRF1 where bmi >= 30  --14

/* HBA1C */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
where LabChemTestName like '%A1C%' AND
	LabChemTestName not like '%ZZ%' AND
	LabChemTestName not like '%XX%'

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_HF_SGLT2_hba1cRF1

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_hba1cRF1 --16

/* Creatinine */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  -- removed in latest update 14 June 2021 
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%' -- removed in latest update 14 June 2021
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select distinct b.PatientSID, b.ScrSSN, b.SGLT2Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempCreatinine

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.SGLT2Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.SGLT2Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select *
into Dflt.Diabetes_HF_SGLT2_CreatRF1
from #tempCreatinine
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_CreatRF1 --17

/* Albumin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempAlbumin

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select *
into Dflt.Diabetes_HF_SGLT2_AlbuminRF1
from #tempAlbumin
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AlbuminRF1 --15

/* Hematocrit */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempHematocrit

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

select *
into Dflt.Diabetes_HF_SGLT2_HematoRF1
from #temphematocrit
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_HematoRF1 --15

/* Hemoglobin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempHemoglobin

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select *
into Dflt.Diabetes_HF_SGLT2_HemoRF1
from #temphemoglobin
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_HemoRF1 --15

/* Blood Urea Nitrogen BUN*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempBUN

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_HF_SGLT2_BUNRF1
from #tempBUN
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BUNRF1 --15

/* Alkaline Phosphatase */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Alkaline Phosphatase%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_SGLT2_AlphoRF1

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AlphoRF1--13

/* Aspartate Transaminase AST*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempAST

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

select *
into Dflt.Diabetes_HF_SGLT2_ASTRF1
from #tempAST
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ASTRF1 --7

/* ALT (Alanine Aminotransferase) */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempALT

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'

select *
into Dflt.Diabetes_HF_SGLT2_ALTRF1
from #tempALT
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ALTRF1 --15

/* Bilirubin*/
/* Check for the labchemtestname in the dimension table */

select distinct labchemtestname from CDWWork.Dim.Labchemtest 

WHERE LabChemTestName like '%Bilirubin%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_SGLT2_BiliRF1

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

Select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BiliRF1-- 16

/* Brain Natriuretic Peptide (BNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempBNP

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'
	
select *
into Dflt.Diabetes_HF_SGLT2_BNPRF1
from #tempBNP
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BNPRF1 --5

/* Pro Brain Natriuretic Peptide (PBNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempPBNP

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_HF_SGLT2_PBNPRF1
from #tempPBNP
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PBNPRF1 --7

/* Total Number of HF hospitalization prior to SGLT2 initiation */

select distinct a.*, b.AdmitDateTime

into Dflt.SGLT2_priorHFDDHospiRF1

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_priorHFDDHospiRF1 --15

/* After HF Hispitalization using discharge diagnosis table */

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

into Dflt.SGLT2_HFDDHospiRF1
--into Dflt.SGLT2_HFHospitalizationNew

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime,  c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_HFDDHospiRF1 --11

/* DPP4 Refill 1 extraction */

/* Demographics */
/* Age */

select a.ScrSSN, a.dpp4filltime, b.DOB,b.SEX
into Dflt.Diabetes_HF_DPP4_DOBRF1
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, dpp4filltime) as age
into Dflt.Diabetes_HF_DPP4_AgeRF1
from Dflt.Diabetes_HF_DPP4_DOBRF1

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AgeRF1 where SEX ='F' --3

/* Date of Death */

select a.Scrssn, b.MPI_DOD

into Dflt.Diabetes_HF_DPP4_DODRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.SDAF_DAFMaster as b with (NOLOCK) on a.scrssn= b.MPI_scrssn
where b.MPI_DOD is not null 

select distinct scrssn from Dflt.Diabetes_HF_DPP4_DODRF1 --80

/* Race */

select a.*,  b.Race
into Dflt.Diabetes_HF_DPP4_RaceRF1
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select distinct scrssn from Dflt.Diabetes_HF_DPP4_RaceRF1 --90

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_HyperRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_HyperRF1 --60


/*including ICD9 codes for CKD4 + 5 (Irfan) */

select distinct a.patientsid, a.scrssn, a.dpp4filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_KDRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_KDRF1 --14

/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_ESRDRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ESRDRF1 --3

/* Alcohol Abuse */

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_AlcoholRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AlcoholRF1--5

/*Polysubstance Abuse */
/*Making sure the ICD9 and ICD10 codes relevant to Polysubstance Abuse are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
																	'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
																	'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
																	'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
															'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10',
															'305.70','304.40','304.6')

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_PolyAbuseRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

Select distinct scrssn from Dflt.Diabetes_HF_DPP4_PolyAbuseRF1 --8

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
drop table Dflt.Diabetes_HF_DPP4_Malignancy

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_MalignancyRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.dpp4filltime) and dateadd(day, 1, a.dpp4filltime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_MalignancyRF1--1


/* Hypothyroidism */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like ('244.%')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like ('E03.%')

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_HypothyrRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.dpp4filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.dpp4filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_HypothyrRF1 --12


/*Smoking */

select distinct a.*, b.SMOKE

into Dflt.Diabetes_HF_DPP4_SmokeRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select * from Dflt.Diabetes_HF_DPP4_SmokeRF1
select distinct scrssn from Dflt.Diabetes_HF_DPP4_SmokeRF1 where smoke = '1' --15
 
/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_StrokeRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.dpp4filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.dpp4filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_StrokeRF1--2

/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_MIRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.dpp4filltime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.dpp4filltime

union all

select distinct a.patientsid, a.scrssn, a.dpp4filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.dpp4filltime

Select distinct scrssn from Dflt.Diabetes_HF_DPP4_MIRF1 --15

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_HF_DPP4_AblationRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all 

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.visitdatetime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.dpp4filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AblationRF1 --0

/* CAD */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_CADRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_CADRF1--57

/* CAD- PCI & CABG */

select a.*, b.SURGDATE

into #tempCABGDPP4

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
src.VASQIP_nso_cardiac as b with (NOLOCK) on a.scrssn= b.scrssn
where b.cpt01 in ('33533','33534','33535','33536','33542','33545','33548')
and b.SURGDATE <= a.dpp4filltime /* Check the dates */

select * from #tempCABGDPP4

select a.*, b.ProcedureDateTime

into #tempPCIDPP4

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.CART_PCI as b with (NOLOCK) on a.PatientSID= b.PatientSID
where b.ProcedureDateTime <= a.dpp4filltime /* Check the dates */

Select distinct patientsid, scrssn, DPP4FillTime, surgdate

into Dflt.Diabetes_HF_DPP4_ccpRF1

from #tempCABGDPP4
union all

select distinct patientsid, scrssn, DPP4FillTime, ProcedureDateTime
from #tempPCIDPP4
union all 

select distinct patientsid, scrssn, DPP4FillTime, comorbidity_Dischargedatettime
from Dflt.Diabetes_HF_DPP4_CADRF1

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ccpRF1--57

/*PAD */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_PADRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_PADRF1--12


/*Cardioversion*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92961','92962')

select distinct a.*

into Dflt.Diabetes_HF_DPP4_CardioRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.AdmitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all 

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92961','92962') 
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.VisitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.VisitDateTime <= a.dpp4filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_CardioRF1--0
drop table Dflt.Diabetes_HF_DPP4_CardioRF1
/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_HF_DPP4_CardioRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_CardioRF1 --2

/* Atrial Fibrillation */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('427.31')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'I48.%'

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_AFRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AFRF1 --35

/* Ablation Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_HF_DPP4_AbProcRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('37.33','37.34','37.37','37.80','38.65')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('02560ZZ','02563ZZ','02564ZZ',
'02570ZZ','02573ZZ','02574ZZ','02580ZZ','02583ZZ','02584ZZ','025S0ZZ','025S3ZZ','025S4ZZ','025T0ZZ','025T3ZZ','025T4ZZ')
and b.DischargeDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AbProcRF1 --16

/* Schizoprenic Disorder */
/*Making sure the ICD9 and ICD10 codes relevant to Schizoprenic Disorder are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like '295.%'

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_SchizoRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_SchizoRF1 --1

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_DepRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_DepRF1 --24

/* COPD Chronic Lung Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_COPDRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_COPDRF1 --52

/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_LDRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_LDRF1 --8

/* Prior Pacemaker */
/*Making sure the ICD9 and ICD10 codes relevant to Prior Pacemaker are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('V45.01','V45.02')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('Z95.0','Z95.810')

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('33210','33206','33207','33216','33217')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_PriorPMDCRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_PriorPMDCRF1 --6

/*BMI*/
/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitals

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(DAY, 1, b.DPP4FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitals --91

/* Seperate weight records into a table */
select * 

into #tempweight

from #tempDiabetesVitals where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweight

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1
from #tempweight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinal
from #tempweight as a with (NOLOCK) left outer join 
#tempweight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinal --91

/* Seperate height records into a table */
select *  

into #tempheight

from #tempDiabetesVitals where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheight

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1
from #tempheight group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinal
from #tempheight as a with (NOLOCK) left outer join 
#tempheight1 as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinal --91

/* Combine data from table weight and height to obtain the bmi for individual patient */
drop table  Dflt.Diabetes_HF_DPP4_BMI

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_HF_DPP4_BMIRF1

from #tempheightfinal as a with (NOLOCK) inner join
#tempweightfinal as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.DPP4FillTime=b.DPP4FillTime and

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMIRF1 where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMIRF1 where bmi between 35 and 40

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMIRF1 where bmi >= 30

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMIRF1 where bmi < 30 

/* HBA1C */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
where LabChemTestName like '%A1C%' AND
	LabChemTestName not like '%ZZ%' AND
	LabChemTestName not like '%XX%'

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_HF_DPP4_hba1cRF1

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_hba1cRF1 --78
select * from Dflt.Diabetes_HF_DPP4_hba1c

/* Creatinine */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  -- removed in latest update 14 June 2021 
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%' -- removed in latest update 14 June 2021
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select distinct b.PatientSID, b.ScrSSN, b.DPP4Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempCreatinineDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.DPP4Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

union all

select distinct b.PatientSID, b.ScrSSN, b.DPP4Filltime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Creat%' 
	--and	LabChemTestName not like '%ZZ%'  
	and LabChemTestName not like '%ratio%'
	and LabChemTestName not like '%DO NOT USE%'
	--and LabChemTestName not like 'XX%'
	and LabChemTestName not in ('Beryllium (Creatinine Corrected)', 'ERROR IN CREATION', 'PANCREATIC AMYLASE(q',
'PANCREATIC ELASTASE 1','PANCREATIC ELASTASE-1 STOOL','PANCREATIC ELASTASE-1(Q)',
'PANCREATIC ELASTASE-1,STOOL (QU)','PANCREATIC ELASTASE1',
'Pancreatic Fraction','PANCREATIC ISOAMYLASE (PRE-',
'PANCREATIC POLYPEPTIDE','PANCREATIC POLYPEPTIDE  (before 9/22/98)',
'PANCREATIC POLYPEPTIDE (QU)','PANCREATIC POLYPEPTIDE(QU)(bef.4/26/04)',
'PANCREATIC POLYPEPTIDE~prior to 4/26/04','PANCREATITIS PANEL NGS(PG)', 'THALLIUM (ug/g Creat)')

select *
into Dflt.Diabetes_HF_DPP4_CreatRF1
from #tempCreatinineDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_CreatRF1 --90

/* Albumin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempAlbuminDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select *
into Dflt.Diabetes_HF_DPP4_AlbuminRF1
from #tempAlbuminDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AlbuminRF1 --80


/* Hematocrit */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempHematocritDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%hematocrit%' OR 
	LabChemTestName like '%hem%crit%' OR
	LabChemTestName like '%packed%cell%' OR
	LabChemTestName like '%PCV%' OR
	LabChemTestName like '%VPRC%' OR 
	LabChemTestName like '%EVF%' OR
	LabChemTestName like '%erythrocy%vol%' or
	LabChemTestName like '%haemto%' or
	LabChemTestName like '%hct%' or
	LabChemTestName like '%crit%' or
	LabChemTestName like '%h%&%h%')
	AND
	LabChemTestName not like '%serotype%' AND
	LabChemTestName not like '%PCV [0-9]%' AND
	LabChemTestName not like '%HPCV%' AND
	LabChemTestName not like '%cryocrit%' AND
	LabChemTestName not like '%dna%' and
	LabChemTestName not like '%hiv%' and
	LabChemTestName not like '%critical%' and
	LabChemTestName not like '%A.%' and
	LabChemTestName not like '%homocys%' and
	LabChemTestName not like '%alpha%' and
	LabChemTestName not like '%alcohol%' and
	LabChemTestName not like '%amphetamine%' and
	LabChemTestName not like '%amino%' and
	LabChemTestName not like '%phago%' and
	LabChemTestName not like '%gonorr%' and
	LabChemTestName not like '%criteria%' and
	LabChemTestName not like '%trig%' and
	LabChemTestName not like '%catecholam%' and
	LabChemTestName not like '%catheter%' and
	LabChemTestName not like '%ch[0-9]%' and
	LabChemTestName not like '%2hr%glu%' and
	LabChemTestName not like '%chlamydia%' and 
	LabChemTestName not like '%chlor%' and
	LabChemTestName not like '%chromi%' and
	LabChemTestName not like '%LDH%' and
	LabChemTestName not like '%LDL%' and
	LabChemTestName not like '%FSH%' and
	LabChemTestName not like '%lymph%' and
	LabChemTestName not like '%meth%' and
	LabChemTestName not like '%MLH1%' and
	LabChemTestName not like '%thyro%' and
	LabChemTestName not like '%thalas%'

select *
into Dflt.Diabetes_HF_DPP4_HematoRF1
from #temphematocritDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_HematoRF1 --87


/* Hemoglobin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempHemoglobinDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%hemoglob%' or 
    labchemtestname like '%HB%' or 
	LabChemTestName like '%HGB%') and
	labchemtestname not like 'z%' AND
	labchemtestname not like 'x%' AND
	LabChemTestName not like '%ratio%' AND 
	LabChemTestName not like '%HBV%' AND
	LabChemTestName not like '%Anti-HB%' AND 
	LabChemTestName not like '%Hepatitis%' AND
	LabChemTestName not like '%ELECTROPHORESIS%' AND
	LabChemTestName not like '%HBSAG%' AND
	LabChemTestName not like '%HC1 ESTERASE%' AND
	LabChemTestName not like '%Testoster%' AND
	LabChemTestName not like '%SDHB%' AND
	LabChemTestName not like '%HBsAb%' AND
	LabChemTestName not like '%GHB%' AND
	LabChemTestName NOT LIKE '%A1C%'
	AND LabChemTestName NOT LIKE '%CELL%'
	AND LabChemTestName not like '%RATE%'
	AND LabChemTestName not like '%/100wbc%'
	AND LabChemTestName not like '%sperm%'
	AND LabChemTestName not like '%HBV%'
	AND LabChemTestName not like '%hbc%'
	AND LabChemTestName not like '%hiv%'
	AND LabChemTestName not like '%anti%'
	AND LabChemTestName not like '%hep%'
	AND LabChemTestName not like '%butyl%'
	AND LabChemTestName not like '%VITROS%'
	AND LabChemTestName not like '%hormone%'
	AND LabChemTestName not like '%hbs%'

select *
into Dflt.Diabetes_HF_DPP4_HemoRF1
from #tempHemoglobinDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_HemoRF1 --88

/* Blood Urea Nitrogen BUN*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempBUNDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_HF_DPP4_BUNRF1
from #tempBUNDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BUNRF1 --80

/* Alkaline Phosphatase */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Alkaline Phosphatase%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_DPP4_AlphoRF1

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AlphoRF1 --65

/* Aspartate Transaminase AST*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempASTDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%[^a-z]AST%' or
  LabChemTestName like '%GOT%' or
  LabChemTestName like '%transaminase%' or
  LabChemTestName like '%aspartate%' or
  LabChemTestName like  '%aminotransferase%') 
	AND LabChemTestName not like '%astra%'
	AND LabChemTestName not like '%ergotamine%'
	AND LabChemTestName not like '%dermatophag%'
	AND LabChemTestName not like '%escargot%' 
	AND LabChemTestName not like '%oligotyping%'
	AND LabChemTestName not like '%gote%'

select *
into Dflt.Diabetes_HF_DPP4_ASTRF1
from #tempASTDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ASTRF1 --33

/* ALT (Alanine Aminotransferase) */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempALTDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE
(LabChemTestName like '%ALT%' OR 
LabChemTestName like '%alanine%' OR
LabChemTestName like '%aminotransferase%' OR
LabChemTestName like '%SGPT%' OR
LabChemTestName like '%SGOT%' OR
LabChemTestName like '%transaminase%' OR
LabChemTestName like '%GPT%' ) 
AND LabChemTestName not like '%ALTER%'
AND LabChemTestName not like '%HEALTH%'
AND LabChemTestName not like '%Hepatitis%'
AND LabChemTestName not like '%Naltrex%'
AND LabChemTestName not like '%Kilodalton%'
AND LabChemTestName not like '%Malt%'
AND LabChemTestName not like '%Specialty%'
AND LabChemTestName not like '%Salt%'
AND LabChemTestName not like '%balt%'
AND LabChemTestName not like '%alto%'
AND LabChemTestName not like '%ralt%'

select *
into Dflt.Diabetes_HF_DPP4_ALTRF1
from #tempALTDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ALTRF1 --84

/* Bilirubin*/
/* Check for the labchemtestname in the dimension table */

select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Bilirubin%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_DPP4_BiliRF1

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

Select distinct scrssn from Dflt.Diabetes_HF_DPP4_BiliRF1 --82

/* Brain Natriuretic Peptide (BNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempBNPDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select *
into Dflt.Diabetes_HF_DPP4_BNPRF1
from #tempBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BNPRF1 --35

/* Pro Brain Natriuretic Peptide (PBNP)*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempPBNPDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_RF1 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or 
    labchemtestname like '%terminal%pep%' or
	labchemtestname  like '%proBNP%' or 
	labchemtestname  like '%pro[- /_]BNP%' or 
	labchemtestname  like '%pro brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_HF_DPP4_PBNPRF1
from #tempPBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_PBNPRF1 --51

/* Total Number of HF hospitalization prior to DPP4 initiation */

select distinct a.*, b.AdmitDateTime

into Dflt.DPP4_priorHFDDHospiRF1

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime

union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_priorHFDDHospiRF1 --71

/* After HF Hispitalization using discharge diagnosis table */

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

into Dflt.DPP4_HFDDHospiRF1
--into Dflt.DPP4_HFHospitalizationNew

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime,  c.ICD10Code

from Dflt.Diabetes_HF_DPP4_RF1 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_HFDDHospiRF1 --39
