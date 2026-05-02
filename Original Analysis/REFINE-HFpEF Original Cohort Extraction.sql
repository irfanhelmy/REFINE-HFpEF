/* Diabetes HFpEF SGLT2 Study */

/* Run the below command to select the required database */
use ORD_Sundaram_202108013D
go

/* Diabetes patient population using ICD9 and ICD 10 diagnosis codes */
/* Making sure the codes are available in the CDWWork Dimension table */
select distinct scrssn from Dflt.Diabetes_final

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'E11%' 

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_final

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')	
and b.Dischargedatetime between '2000-01-01 00:00:00' and  '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.EventDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.EventDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.EventDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.PatientTransferDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.PatientTransferDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.SpecialtyTransferDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.SpecialtyTransferDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.AdmitDateTime, c.ICD9Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('250.00','250.10','250.20','250.30','250.40','250.50','250.60','250.70','250.80','250.90')
and b.AdmitDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

/*ICD10 Codes*/
select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.DischargeDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.Dischargedatetime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.EventDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.EventDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.EventDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.EventDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.PatientTransferDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.PatientTransferDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.SpecialtyTransferDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.SpecialtyTransferDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, a.Sta3n, b.AdmitDateTime, c.ICD10Code

from Src.CohortCrosswalk as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'E11%' 
and b.AdmitDateTime between '2000-01-01 00:00:00' and '2021-12-31 23:59:59' 

select distinct scrssn from Dflt.Diabetes_final--1,373,328

drop table Dflt.Diabetes_final

alter table Dflt.Diabetes_final rebuild with (data_compression=page)

/* Heart Failure */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')-- 150.00 is not available

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into #tempdiabetesHF

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.DischargeDateTime <= a.DischargeDateTime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.DischargeDateTime <= a.DischargeDateTime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.DischargeDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.EventDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.EventDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.EventDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.PatientTransferDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.SpecialtyTransferDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					--and b.AdmitDateTime <= a.Dischargedatetime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.DischargeDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.DischargeDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.DischargeDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.EventDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.EventDateTime <= a.Dischargedatetime
union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.EventDateTime <= a.Dischargedatetime

union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.PatientTransferDateTime <= a.Dischargedatetime

union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.SpecialtyTransferDateTime <= a.Dischargedatetime

union all

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
--and b.AdmitDateTime <= a.Dischargedatetime

select distinct scrssn from #tempdiabetesHF--590,005

select distinct scrssn from #tempdiabetesHF where comorbidity_Dischargedatetime is not Null

 
select scrssn , min (comorbidity_dischargedatetime) as FirstHF_DischargeDatetime
into #tempHFDate
from #tempdiabetesHF group by scrssn

select distinct scrssn from #tempHFDate where FirstHF_DischargeDatetime < '2021-12-31 00:00:00'

select distinct a.PatientSID,a.ScrSSN, a.Sta3n, a.DischargeDateTime, a.comorbidity_Dischargedatetime, a.comorbidity_ICD9Code,b.FirstHF_Dischargedatetime
into Dflt.Diabetes_HF
from #tempdiabetesHF as a with (NOLOCK) inner join
#tempHFDate as b with (NOLOCK) on a.scrssn = b.scrssn and a.comorbidity_Dischargedatetime= b.FirstHF_DischargeDatetime
and FirstHF_DischargeDatetime < '2021-12-31 00:00:00'

select distinct scrssn from Dflt.Diabetes_HF where FirstHF_DischargeDatetime >= '2021-12-31 00:00:00' --450,431

alter table Dflt.Diabetes_HF rebuild with (data_compression=page)

/* LVEF 50 and above */

select distinct a.*, b.Low_Value, b.ValueDateTime

into Dflt.Diabetes_HF_Above50
--into #tempAbove50

from Dflt.Diabetes_HF as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.Low_Value >= 50 and  b.ValueDateTime between dateadd(year, -1, a.FirstHF_DischargeDatetime) and dateadd(month, 6, a.FirstHF_DischargeDatetime)
--and  b.ValueDateTime between dateadd(year, -1, a.FirstHF_DischargeDatetime) and dateadd(year,1, a.FirstHF_DischargeDatetime)

select distinct scrssn from #tempAbove50 -- 253,996

select distinct scrssn from Dflt.Diabetes_HF_Above50 --242,469

select top 1000* from Dflt.Diabetes_HF_Above50

alter table Dflt.Diabetes_HF_Above50 rebuild with (data_compression=page)

drop table Dflt.Diabetes_HF_Above50

/* Select patients on Loop Diuretics */

select distinct a.PatientSID, a.ScrSSN, a.DischargeDateTime, a.FirstHF_dischargedatetime, b.FillDateTime, b.FillNumber, b.DaysSupply, b.Qty 

into #tempmedloop

from Dflt.Diabetes_HF_above50 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%' 
union all

select distinct a.PatientSID, a.ScrSSN, a.DischargeDateTime, a.FirstHF_dischargedatetime,b.FillDateTime, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_HF_above50 as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%' 

select *

into #Diabetes_HF_above50_loop

from #tempmedLoop where DaysSupply >= 90 
and FillDateTime between dateadd(month, -6, FirstHF_Dischargedatetime) and dateadd(month, 6, FirstHF_Dischargedatetime)

select distinct scrssn from #Diabetes_HF_above50_loop-- 122,930

--alter table Dflt.Diabetes_HF_above50_loop rebuild with (data_compression=page)

--drop table Dflt.Diabetes_HF_above50_loop

/* BNP and PBNP */

select distinct labchemtestname 
from CDWWork.Dim.LabChemTest
where 
 (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%' AND
	LabChemTestName not like 'BNP(N-TERMINAL)' and 
	LabChemTestName not like 'PB BNP' and 
	LabChemTestName not like 'PBNP' and 
	LabChemTestName not like 'PBNP (BRAIN NATRIURETIC PEPTIDE) SIEMENS' and 
	LabChemTestName not like 'NT-pBNP (BH/CN<3/25/21)' and 
	LabChemTestName not like 'pBNP THRU 6/26/06'

--create view Diabetes_BNP as
select distinct b.PatientSID, b.ScrSSN, b.DischargeDateTime, b.FirstHF_Dischargedatetime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue, c.LabChemTestName

into #Diabetes_BNP

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where 
 (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%' AND
	LabChemTestName not like 'BNP(N-TERMINAL)' and 
	LabChemTestName not like 'PB BNP' and 
	LabChemTestName not like 'PBNP' and 
	LabChemTestName not like 'PBNP (BRAIN NATRIURETIC PEPTIDE) SIEMENS' and 
	LabChemTestName not like 'NT-pBNP (BH/CN<3/25/21)' and 
	LabChemTestName not like 'pBNP THRU 6/26/06'

union all

select distinct b.PatientSID, b.ScrSSN, b.DischargeDateTime,b.FirstHF_Dischargedatetime,  a.LabChemCompleteDateTime, a.LabChemResultNumericValue, c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where 
 (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%' AND
	LabChemTestName not like 'BNP(N-TERMINAL)' and 
	LabChemTestName not like 'PB BNP' and 
	LabChemTestName not like 'PBNP' and 
	LabChemTestName not like 'PBNP (BRAIN NATRIURETIC PEPTIDE) SIEMENS' and 
	LabChemTestName not like 'NT-pBNP (BH/CN<3/25/21)' and 
	LabChemTestName not like 'pBNP THRU 6/26/06'

union all

select distinct b.PatientSID, b.ScrSSN, b.DischargeDateTime,b.FirstHF_Dischargedatetime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where 
 (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%' AND
	LabChemTestName not like 'BNP(N-TERMINAL)' and 
	LabChemTestName not like 'PB BNP' and 
	LabChemTestName not like 'PBNP' and 
	LabChemTestName not like 'PBNP (BRAIN NATRIURETIC PEPTIDE) SIEMENS' and 
	LabChemTestName not like 'NT-pBNP (BH/CN<3/25/21)' and 
	LabChemTestName not like 'pBNP THRU 6/26/06'

select distinct scrssn from #Diabetes_BNP --146,508

select distinct *

into #BNPAbove100

from #Diabetes_BNP where LabChemResultNumericValue > 100

select distinct scrssn from #BNPAbove100--123,609

/* PBNP */
--create view Diabetes_PBNP as

select distinct b.PatientSID, b.ScrSSN, b.DischargeDateTime, b.FirstHF_dischargedatetime,  a.LabChemCompleteDateTime, a.LabChemResultNumericValue, c.LabChemTestName

into #Diabetes_PBNP

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
( labchemtestname like 'BNP NT-PRO' or
labchemtestname like 'BNP(N-TERMINAL)'or
labchemtestname like 'BNP(proBNP)' or
labchemtestname like 'BNP, NT-PRO'or
labchemtestname like 'BNP, NT-PRO prior 18Nov2021'or
labchemtestname like 'BNP, NT-PRO prior 1Feb2022'or
labchemtestname like 'BNP-NT-pro' or
labchemtestname like 'CARDIO IQ NT-ProBNP'or
labchemtestname like 'N-TERMINAL TELOPEPTIDE CROSSLINKS'or
labchemtestname like 'NT pro BNP'or
labchemtestname like 'NT pro BNP (ARUP)'or
labchemtestname like 'NT PRO BNP (CLEVELAND CLINIC)'or
labchemtestname like 'NT PRO BNP(GUAM)'or
labchemtestname like 'NT PROBNP (11188)'or
labchemtestname like 'NT PROHORMONE BRAIN NATRIURETIC PEPTIDE'or
labchemtestname like 'NT-pBNP (BH/CN<3/25/21)'or
labchemtestname like 'NT-PRO BNP (SMMC)'or
labchemtestname like 'NT-PRO BNP(D/C,3/23/21@9AM)'or
labchemtestname like 'NT-PRO BNP%)'or
labchemtestname like 'NT-proBNP%'or
labchemtestname like'NT-PROBNP%'or
--labchemtestname like'NT-proBNP (d/c 8/17/2021)'or
--labchemtestname like'NT-proBNP (dc'd 8/31/2020)'or
--labchemtestname like 'NT-proBNP (DC'D 8/4/20)'or
--labchemtestname like'NT-proBNP (DCED 013119)'or
--labchemtestname like 'NT-proBNP (O)'or
--labchemtestname like'NT-proBNP (prior to 5/28/2019)'or
--labchemtestname like'NT-proBNP (proBNP N-TERMINAL)'or
--labchemtestname like 'NT-proBNP (QUEST)'or
--labchemtestname like 'NT-proBNP (Roche)' or
--labchemtestname like 'NT-proBNP (SL11188)'or
--labchemtestname like 'NT-PROBNP (SPL)'or
--labchemtestname like 'NT-PROBNP (TO 11-10-19)'or
--labchemtestname like 'NT-proBNP ~Q' or
--labchemtestname like 'NT-proBNP Entresto ONLY' or
--labchemtestname like 'NT-proBNP(..7/19)*ia' or
--labchemtestname like 'NT-proBNP(BEFORE 10/6/06)' or
--labchemtestname like 'NT-proBNP(DCd 4.13.21)' or
--labchemtestname like 'NT-proBNP*CI' or
--labchemtestname like 'NT-proBNP*NE' or
--labchemtestname like 'NT-PROBNP,BLOOD' or
--labchemtestname like 'NT-PROBNP,BODY FLUID' or
labchemtestname like 'PB BNP'or
labchemtestname like'PB PRO-BNP,N-TERMINAL' or
labchemtestname like'PBNP' or
labchemtestname like'PBNP (BRAIN NATRIURETIC PEPTIDE) SIEMENS' or
labchemtestname like'pBNP THRU 6/26/06' or
labchemtestname like 'PRO BNP'or
labchemtestname like 'PRO BNP%' or
--labchemtestname like 'PRO BNP(ACL-STAT)' or
labchemtestname like 'PRO-BNP%' or
--labchemtestname like'PRO-BNP (DC'D 8/20)' or
--labchemtestname like 'PRO-BNP (DC7/07)' or
--labchemtestname like'PRO-BNP (FOR OFF-TOUR ONLY) CDH' or
--labchemtestname like 'PRO-BNP (LabCorp)' or
--labchemtestname like 'PRO-BNP (LC)' or
--labchemtestname like 'pro-BNP (PRIOR. 2019)' or
--labchemtestname like 'PRO-BNP CARDIOASSESSR DC'D 10/02/2016' or
--labchemtestname like 'PRO-BNP(d'cd 4/13/20)' or
--labchemtestname like'PRO-BNP,N-TERMINAL (QU)' or
labchemtestname like 'proBNP'or
labchemtestname like 'PROBNP%' or
--labchemtestname like 'PROBNP (LABCORP)' or
labchemtestname like 'proBNP (SEND OUT)11188' or
labchemtestname like 'ProBNP/SEND OUT' or
labchemtestname like 'PROBRAIN NATRIURETIC PEPTIDE, NT  ' or
labchemtestname like 'PROCOLLAGEN 1 N-TERMINAL PROPEPTIDE' or
labchemtestname like 'RESEARCH PRO-BNP' or
labchemtestname like 'ZNT-proBNP' or
labchemtestname like 'ZZ BNP, NT-PRO' or
labchemtestname like 'ZZNT PRO-BNP' or
labchemtestname like 'ZZNT-PROBNP' or
labchemtestname like 'ZZpBNP' or
labchemtestname like 'ZZPBNP (AL<1/21/07)' or
labchemtestname like 'ZZPROBNP(63)' or
labchemtestname like 'ZZZ PROBNP (in-house)' or
labchemtestname like 'ZZZPRO-BNP%')

union all

select distinct  b.PatientSID, b.ScrSSN, b.DischargeDateTime, b.FirstHF_dischargedatetime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue, c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
( labchemtestname like 'BNP NT-PRO' or
labchemtestname like 'BNP(N-TERMINAL)'or
labchemtestname like 'BNP(proBNP)' or
labchemtestname like 'BNP, NT-PRO'or
labchemtestname like 'BNP, NT-PRO prior 18Nov2021'or
labchemtestname like 'BNP, NT-PRO prior 1Feb2022'or
labchemtestname like 'BNP-NT-pro' or
labchemtestname like 'CARDIO IQ NT-ProBNP'or
labchemtestname like 'N-TERMINAL TELOPEPTIDE CROSSLINKS'or
labchemtestname like 'NT pro BNP'or
labchemtestname like 'NT pro BNP (ARUP)'or
labchemtestname like 'NT PRO BNP (CLEVELAND CLINIC)'or
labchemtestname like 'NT PRO BNP(GUAM)'or
labchemtestname like 'NT PROBNP (11188)'or
labchemtestname like 'NT PROHORMONE BRAIN NATRIURETIC PEPTIDE'or
labchemtestname like 'NT-pBNP (BH/CN<3/25/21)'or
labchemtestname like 'NT-PRO BNP (SMMC)'or
labchemtestname like 'NT-PRO BNP(D/C,3/23/21@9AM)'or
labchemtestname like 'NT-PRO BNP%)'or
labchemtestname like 'NT-proBNP%'or
labchemtestname like'NT-PROBNP%'or
--labchemtestname like'NT-proBNP (d/c 8/17/2021)'or
--labchemtestname like'NT-proBNP (dc'd 8/31/2020)'or
--labchemtestname like 'NT-proBNP (DC'D 8/4/20)'or
--labchemtestname like'NT-proBNP (DCED 013119)'or
--labchemtestname like 'NT-proBNP (O)'or
--labchemtestname like'NT-proBNP (prior to 5/28/2019)'or
--labchemtestname like'NT-proBNP (proBNP N-TERMINAL)'or
--labchemtestname like 'NT-proBNP (QUEST)'or
--labchemtestname like 'NT-proBNP (Roche)' or
--labchemtestname like 'NT-proBNP (SL11188)'or
--labchemtestname like 'NT-PROBNP (SPL)'or
--labchemtestname like 'NT-PROBNP (TO 11-10-19)'or
--labchemtestname like 'NT-proBNP ~Q' or
--labchemtestname like 'NT-proBNP Entresto ONLY' or
--labchemtestname like 'NT-proBNP(..7/19)*ia' or
--labchemtestname like 'NT-proBNP(BEFORE 10/6/06)' or
--labchemtestname like 'NT-proBNP(DCd 4.13.21)' or
--labchemtestname like 'NT-proBNP*CI' or
--labchemtestname like 'NT-proBNP*NE' or
--labchemtestname like 'NT-PROBNP,BLOOD' or
--labchemtestname like 'NT-PROBNP,BODY FLUID' or
labchemtestname like 'PB BNP'or
labchemtestname like'PB PRO-BNP,N-TERMINAL' or
labchemtestname like'PBNP' or
labchemtestname like'PBNP (BRAIN NATRIURETIC PEPTIDE) SIEMENS' or
labchemtestname like'pBNP THRU 6/26/06' or
labchemtestname like 'PRO BNP'or
labchemtestname like 'PRO BNP%' or
--labchemtestname like 'PRO BNP(ACL-STAT)' or
labchemtestname like 'PRO-BNP%' or
--labchemtestname like'PRO-BNP (DC'D 8/20)' or
--labchemtestname like 'PRO-BNP (DC7/07)' or
--labchemtestname like'PRO-BNP (FOR OFF-TOUR ONLY) CDH' or
--labchemtestname like 'PRO-BNP (LabCorp)' or
--labchemtestname like 'PRO-BNP (LC)' or
--labchemtestname like 'pro-BNP (PRIOR. 2019)' or
--labchemtestname like 'PRO-BNP CARDIOASSESSR DC'D 10/02/2016' or
--labchemtestname like 'PRO-BNP(d'cd 4/13/20)' or
--labchemtestname like'PRO-BNP,N-TERMINAL (QU)' or
labchemtestname like 'proBNP'or
labchemtestname like 'PROBNP%' or
--labchemtestname like 'PROBNP (LABCORP)' or
labchemtestname like 'proBNP (SEND OUT)11188' or
labchemtestname like 'ProBNP/SEND OUT' or
labchemtestname like 'PROBRAIN NATRIURETIC PEPTIDE, NT  ' or
labchemtestname like 'PROCOLLAGEN 1 N-TERMINAL PROPEPTIDE' or
labchemtestname like 'RESEARCH PRO-BNP' or
labchemtestname like 'ZNT-proBNP' or
labchemtestname like 'ZZ BNP, NT-PRO' or
labchemtestname like 'ZZNT PRO-BNP' or
labchemtestname like 'ZZNT-PROBNP' or
labchemtestname like 'ZZpBNP' or
labchemtestname like 'ZZPBNP (AL<1/21/07)' or
labchemtestname like 'ZZPROBNP(63)' or
labchemtestname like 'ZZZ PROBNP (in-house)' or
labchemtestname like 'ZZZPRO-BNP%')

union all

select distinct  b.PatientSID, b.ScrSSN, b.DischargeDateTime,b.FirstHF_dischargedatetime, a.LabChemCompleteDateTime, a.LabChemResultNumericValue, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50 as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
( labchemtestname like 'BNP NT-PRO' or
labchemtestname like 'BNP(N-TERMINAL)'or
labchemtestname like 'BNP(proBNP)' or
labchemtestname like 'BNP, NT-PRO'or
labchemtestname like 'BNP, NT-PRO prior 18Nov2021'or
labchemtestname like 'BNP, NT-PRO prior 1Feb2022'or
labchemtestname like 'BNP-NT-pro' or
labchemtestname like 'CARDIO IQ NT-ProBNP'or
labchemtestname like 'N-TERMINAL TELOPEPTIDE CROSSLINKS'or
labchemtestname like 'NT pro BNP'or
labchemtestname like 'NT pro BNP (ARUP)'or
labchemtestname like 'NT PRO BNP (CLEVELAND CLINIC)'or
labchemtestname like 'NT PRO BNP(GUAM)'or
labchemtestname like 'NT PROBNP (11188)'or
labchemtestname like 'NT PROHORMONE BRAIN NATRIURETIC PEPTIDE'or
labchemtestname like 'NT-pBNP (BH/CN<3/25/21)'or
labchemtestname like 'NT-PRO BNP (SMMC)'or
labchemtestname like 'NT-PRO BNP(D/C,3/23/21@9AM)'or
labchemtestname like 'NT-PRO BNP%)'or
labchemtestname like 'NT-proBNP%'or
labchemtestname like'NT-PROBNP%'or
--labchemtestname like'NT-proBNP (d/c 8/17/2021)'or
--labchemtestname like'NT-proBNP (dc'd 8/31/2020)'or
--labchemtestname like 'NT-proBNP (DC'D 8/4/20)'or
--labchemtestname like'NT-proBNP (DCED 013119)'or
--labchemtestname like 'NT-proBNP (O)'or
--labchemtestname like'NT-proBNP (prior to 5/28/2019)'or
--labchemtestname like'NT-proBNP (proBNP N-TERMINAL)'or
--labchemtestname like 'NT-proBNP (QUEST)'or
--labchemtestname like 'NT-proBNP (Roche)' or
--labchemtestname like 'NT-proBNP (SL11188)'or
--labchemtestname like 'NT-PROBNP (SPL)'or
--labchemtestname like 'NT-PROBNP (TO 11-10-19)'or
--labchemtestname like 'NT-proBNP ~Q' or
--labchemtestname like 'NT-proBNP Entresto ONLY' or
--labchemtestname like 'NT-proBNP(..7/19)*ia' or
--labchemtestname like 'NT-proBNP(BEFORE 10/6/06)' or
--labchemtestname like 'NT-proBNP(DCd 4.13.21)' or
--labchemtestname like 'NT-proBNP*CI' or
--labchemtestname like 'NT-proBNP*NE' or
--labchemtestname like 'NT-PROBNP,BLOOD' or
--labchemtestname like 'NT-PROBNP,BODY FLUID' or
labchemtestname like 'PB BNP'or
labchemtestname like'PB PRO-BNP,N-TERMINAL' or
labchemtestname like'PBNP' or
labchemtestname like'PBNP (BRAIN NATRIURETIC PEPTIDE) SIEMENS' or
labchemtestname like'pBNP THRU 6/26/06' or
labchemtestname like 'PRO BNP'or
labchemtestname like 'PRO BNP%' or
--labchemtestname like 'PRO BNP(ACL-STAT)' or
labchemtestname like 'PRO-BNP%' or
--labchemtestname like'PRO-BNP (DC'D 8/20)' or
--labchemtestname like 'PRO-BNP (DC7/07)' or
--labchemtestname like'PRO-BNP (FOR OFF-TOUR ONLY) CDH' or
--labchemtestname like 'PRO-BNP (LabCorp)' or
--labchemtestname like 'PRO-BNP (LC)' or
--labchemtestname like 'pro-BNP (PRIOR. 2019)' or
--labchemtestname like 'PRO-BNP CARDIOASSESSR DC'D 10/02/2016' or
--labchemtestname like 'PRO-BNP(d'cd 4/13/20)' or
--labchemtestname like'PRO-BNP,N-TERMINAL (QU)' or
labchemtestname like 'proBNP'or
labchemtestname like 'PROBNP%' or
--labchemtestname like 'PROBNP (LABCORP)' or
labchemtestname like 'proBNP (SEND OUT)11188' or
labchemtestname like 'ProBNP/SEND OUT' or
labchemtestname like 'PROBRAIN NATRIURETIC PEPTIDE, NT  ' or
labchemtestname like 'PROCOLLAGEN 1 N-TERMINAL PROPEPTIDE' or
labchemtestname like 'RESEARCH PRO-BNP' or
labchemtestname like 'ZNT-proBNP' or
labchemtestname like 'ZZ BNP, NT-PRO' or
labchemtestname like 'ZZNT PRO-BNP' or
labchemtestname like 'ZZNT-PROBNP' or
labchemtestname like 'ZZpBNP' or
labchemtestname like 'ZZPBNP (AL<1/21/07)' or
labchemtestname like 'ZZPROBNP(63)' or
labchemtestname like 'ZZZ PROBNP (in-house)' or
labchemtestname like 'ZZZPRO-BNP%')

select distinct scrssn from #Diabetes_PBNP --64,961

--create view PBNPAbove300 as
select distinct *

into #PBNPAbove300

from #Diabetes_PBNP where LabChemResultNumericValue > 300

select distinct scrssn from #PBNPAbove300--57,037

--create view Diabetes_HF_above50_BNP_PBNP as
Select *

into Dflt.Diabetes_HF_above50_BNP_PBNP
--from Diabetes_BNP
from #BNPAbove100
where LabChemCompleteDateTime between dateadd(month, -6, FirstHF_dischargedatetime) and dateadd(month, 6, FirstHF_dischargedatetime)
union all

Select *
--from Diabetes_PBNP
from #PBNPAbove300
where LabChemCompleteDateTime between dateadd(month, -6, FirstHF_dischargedatetime) and dateadd(month, 6, FirstHF_dischargedatetime)

select distinct scrssn from Dflt.Diabetes_HF_above50_BNP_PBNP --123,567

alter table Dflt.Diabetes_HF_above50_BNP_PBNP rebuild with (data_compression=page)


/*Combining loop and BNP/PBNP cohort using date filter */
--create view Diabetes_HF_above50_Loop_BNP_PBNP as

select distinct a.PatientSID, a.ScrSSN, a.DischargeDateTime, a.FirstHF_dischargedatetime, a.FillDateTime

into Dflt.Diabetes_HF_above50_Loop_BNP_PBNP

from #Diabetes_HF_above50_loop as a where DaysSupply >=90 
and FillDateTime between dateadd(DAY, -180,  a.FirstHF_dischargedatetime) and dateadd(month, 6,  a.FirstHF_dischargedatetime)
union all

select a.PatientSID, a.ScrSSN, a.DischargeDateTime,  a.FirstHF_dischargedatetime,a.LabChemCompleteDateTime

from Dflt.Diabetes_HF_above50_BNP_PBNP as a
where LabChemCompleteDateTime between dateadd(DAY, -180,  a.FirstHF_dischargedatetime) and dateadd(month, 6,  a.FirstHF_dischargedatetime)

select distinct scrssn from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP--179,288

alter table Dflt.Diabetes_HF_above50_Loop_BNP_PBNP rebuild with (data_compression=page)

/* SGLT2 */

create view tempSGLT2 as
select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as SGLT2FillTime , b.FillNumber, b.DaysSupply, b.drugnamewithoutdose 

into #tempSGLT2

from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' --and b.FillDateTime between '2013-08-01 00:00:00' and '2021-01-31 23:59:59'
union all

select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as SGLT2FillTime , b.FillNumber, b.DaysSupply, b.DrugNameWithoutDose

from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%'

select top 1000* from #tempSGLT2

select *

into #tempSGLT2DateFilter

from #tempSGLT2 where SGLT2FillTime between '2013-08-01 00:00:00' and '2021-07-31 23:59:59'

select distinct scrssn from #tempSGLT2DateFilter


select scrssn, sum(FillNumber) as FillNumber 
into #tempfillnumber
from #tempSGLT2DateFilter group by scrssn 


select scrssn, min(SGLT2FillTime) as SGLT2FillTime
into #temp
from #tempSGLT2DateFilter group by scrssn


select distinct b.patientsid, b.scrssn, a.SGLT2FillTime, b.FillNumber
into #date
from #temp as a with (NOLOCK) left outer join 
#tempSGLT2DateFilter as b with (NOLOCK) on a.scrssn= b.scrssn and a.SGLT2FillTime= b.SGLT2FillTime


select distinct a.scrssn, a.SGLT2FillTime, a.PatientSID, b.FillDateTime

into #DPP4

from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.scrssn, a.SGLT2FillTime, a.PatientSID, b.FillDateTime
from #date as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from #DPP4

select distinct scrssn from #tempfillnumber

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into #SGLT2excludeDpp4

from #tempfillnumber as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #dpp4 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #SGLT2excludeDpp4

drop table #SGLT2excludeDpp4

select distinct a.scrssn, a.Fillnumber, b.SGLT2Filltime, b.PatientSID

into #temp_Diabetes_HF_SGLT2_1
from  #SGLT2excludeDpp4 as a with (NOLOCK) inner join
#date as b with (NOLOCK) on a.Scrssn= b.Scrssn 
where a.fillnumber >=4 and b.SGLT2FillTime between '2013-08-01 00:00:00' and '2020-06-30 23:59:59'

select distinct a.scrssn, a.Fillnumber, b.SGLT2Filltime, b.PatientSID

into #temp_Diabetes_HF_SGLT2_2
from  #SGLT2excludeDpp4 as a with (NOLOCK) inner join
#date as b with (NOLOCK) on a.Scrssn= b.Scrssn 
where a.fillnumber >=2 and b.SGLT2FillTime between '2020-07-01 00:00:00' and '2021-07-31 23:59:59'

/* Just with 2 refills */
select distinct a.scrssn, a.Fillnumber, b.SGLT2Filltime, b.PatientSID

into Dflt.temp_Diabetes_HF_SGLT2_2
from  #SGLT2excludeDpp4 as a with (NOLOCK) inner join
#date as b with (NOLOCK) on a.Scrssn= b.Scrssn 
where a.fillnumber >=2 --and b.SGLT2FillTime between '2020-07-01 00:00:00' and '2021-07-31 23:59:59'

select distinct a.*--, b.FillNumber, b.FillDateTime

into #tempDiabetes_HF_SGLT2_Final

from Dflt.temp_Diabetes_HF_SGLT2_2 as a with (NOLOCK) inner join
#tempmedLoop as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
and b.Fillnumber >1
union all

select distinct a.*--, b.LabChemCompleteDateTime, b.LabChemResultNumericValue, b.LabChemTestName 

from Dflt.temp_Diabetes_HF_SGLT2_2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50_BNP_PBNP as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.LabChemCompleteDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*--, b.DischargeDateTime, b.comorbidity_ICD9Code as HFICDCode

from Dflt.temp_Diabetes_HF_SGLT2_2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.comorbidity_Dischargedatetime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct a.*, b.High_Value

into #templess50

from #tempDiabetes_HF_SGLT2_Final as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.High_Value < 50 and b.ValueDateTime <=a.sglt2filltime

drop table #templess50

select distinct scrssn from #templess50

select distinct scrssn from #tempDiabetes_HF_SGLT2_Final where fillnumber >=4

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

--into Dflt.Diabetes_HF_SGLT2_Final_new
into Dflt.Diabetes_HF_SGLT2_Finalfill2

from #tempDiabetes_HF_SGLT2_Final as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #templess50 as b where a.ScrSSN = b.ScrSSN)

select distinct  scrssn from Dflt.Diabetes_HF_SGLT2_Finalfill2 where fillnumber < 2

/* Exclusion codes */
select distinct a.*,  b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/
into #exclusioncodesSGLT2
--into Dflt.Diabetes_HF_SGLT2_ExclusionCodes

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Finalfill2 as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

select distinct a.*

into Dflt.Diabetes_HF_SGLT2_FinalFill2ex

from dflt.Diabetes_HF_SGLT2_Finalfill2 as a where a.Fillnumber >=2
AND NOT EXISTS (Select * from #exclusioncodesSGLT2 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_FinalFill2ex

/*********/

select distinct scrssn from #temp_Diabetes_HF_SGLT2_2

drop table Dflt.Diabetes_HF_SGLT2

select distinct *

into Dflt.Diabetes_HF_SGLT2

from #temp_Diabetes_HF_SGLT2_1
union all

select distinct *
from #temp_Diabetes_HF_SGLT2_2

drop table Dflt.Diabetes_HF_SGLT2

select distinct scrssn from Dflt.Diabetes_HF_SGLT2

/* Patients on Loop diuretics with more than 1 refill 1 year preceding to the start of SGLT2 */
select distinct a.*, b.FillNumber as loopFillNumber, b.FillDateTime 

into #temploop

from Dflt.Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
tempmedLoop as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
and b.Fillnumber >1

select distinct scrssn from #temploop

drop table #temploop

/*Patients on elevated BNP/PBNP 1 year preceding to the start of SGLT2 */

select distinct a.*, b.LabChemCompleteDateTime, b.LabChemResultNumericValue
into #tempBNPPBNP

from Dflt.Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50_BNP_PBNP as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.LabChemCompleteDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from #tempBNPPBNP

/*Patients with HF ICD codes 1 year preceding to the start of SGLT2 */

select distinct a.*, b.DischargeDateTime, b.comorbidity_Dischargedatetime--, b.comorbidity_ICD9Code as HFICDCode

into #tempHF

from Dflt.Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.comorbidity_Dischargedatetime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from #tempHF

select distinct scrssn 

into #tempuniquesglt2
from #temploop
union all

select distinct scrssn
from #tempBNPPBNP
union all

select distinct scrssn
from #tempHF

select distinct scrssn from #tempuniquesglt2

/* combine all 3 to get the final cohort */
drop table #tempDiabetes_HF_SGLT2_Final

select distinct a.*--, b.FillNumber, b.FillDateTime

into #tempDiabetes_HF_SGLT2_Final

from Dflt.Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
#tempmedLoop as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
and b.Fillnumber >1
union all

select distinct a.*--, b.LabChemCompleteDateTime, b.LabChemResultNumericValue, b.LabChemTestName 

from Dflt.Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50_BNP_PBNP as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.LabChemCompleteDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*--, b.DischargeDateTime, b.comorbidity_ICD9Code as HFICDCode

from Dflt.Diabetes_HF_SGLT2 as a with (NOLOCK) inner join
Dflt.Diabetes_HF as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.comorbidity_Dischargedatetime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct a.*, b.High_Value

into #templess50

from #tempDiabetes_HF_SGLT2_Final as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.High_Value < 50 and b.ValueDateTime <=a.sglt2filltime

drop table #templess50

select distinct scrssn from #templess50

select distinct scrssn from #tempDiabetes_HF_SGLT2_Final where fillnumber >=4

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into Dflt.Diabetes_HF_SGLT2_Final_new

from #tempDiabetes_HF_SGLT2_Final as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #templess50 as b where a.ScrSSN = b.ScrSSN)

select distinct  scrssn from Dflt.Diabetes_HF_SGLT2_Final

drop table Dflt.Diabetes_HF_SGLT2_Final

/* DPP4 Control cohort */

select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as DPP4FillTime, b.FillNumber, b.DaysSupply, b.Qty

into #tempDPP4

from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime between '2013-08-01 00:00:00' and '2021-07-31 23:59:59' 
union all

select distinct a.PatientSID, a.ScrSSN, b.FillDateTime as DPP4FillTime, b.FillNumber, b.DaysSupply, b.Qty
from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime between '2013-08-01 00:00:00' and '2021-07-31 23:59:59'


select distinct scrssn from #tempDPP4 where DrugNameWithoutDose = '*Missing*'

drop table #date1

/* Find the DPP4 Fill time */

select scrssn, min(DPP4FillTime) as DPP4FillTime
into #temp1
from #tempDpp4 group by scrssn

select distinct b.patientsid, b.scrssn, a.DPP4FillTime, b.FillNumber
into #date1
from #temp1 as a with (NOLOCK) left outer join 
#tempDpp4 as b with (NOLOCK) on a.scrssn= b.scrssn and a.DPP4FillTime= b.DPP4FillTime

select distinct scrssn from #date1

select * from #date1

/* Add the refills for DPP4 */

select scrssn, sum(FillNumber) as FillNumber 
into #tempfillnumberDPP4
from #tempDPP4 group by scrssn 

select distinct scrssn from #tempfillnumberDPP4

drop table #tempfillnumberDPP4

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

select * 
into #SGLT21
from #SGLT2 where FillDateTime between dateadd(month, -12, DPP4FillTime) and dateadd(day, 1, DPP4FillTime) 

select distinct scrssn from #sglt21

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into #Dpp4excludeSGLT2

from #tempfillnumberDPP4 as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #sglt21 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from #Dpp4excludeSGLT2

select distinct a.scrssn, a.fillnumber, b.DPP4FillTime, b.Patientsid

into #temp_Diabetes_HF_DPP4_1

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
#date1 as b with (NOLOCK) on a.Scrssn= b.scrssn
where a.FillNumber>=4 and b.DPP4FillTime between '2013-08-01 00:00:00' and '2020-06-30 23:59:59' 

select distinct a.scrssn, a.fillnumber, b.DPP4FillTime, b.Patientsid

into #temp_Diabetes_HF_DPP4_2

from #Dpp4excludeSGLT2 as a with (NOLOCK) inner join
#date1 as b with (NOLOCK) on a.Scrssn= b.scrssn
where a.FillNumber>=2 and b.DPP4FillTime between '2020-07-01 00:00:00' and '2021-07-31 23:59:59' 

select distinct *

into Dflt.Diabetes_HF_DPP4
from #temp_Diabetes_HF_DPP4_1
union all

select distinct *
from #temp_Diabetes_HF_DPP4_2

drop table Dflt.Diabetes_HF_DPP4

select distinct scrssn from Dflt.Diabetes_HF_DPP4

/* Patients on Loop diuretics with more than 1 refill 1 year preceding to the start of DPP4 */
select distinct a.*, b.FillNumber as loopFillNumber, b.FillDateTime 

into #temploopDPP4

from Dflt.Diabetes_HF_DPP4 as a with (NOLOCK) inner join
tempmedLoop as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
and b.Fillnumber >1

select distinct scrssn from #temploopDPP4

/*Patients on elevated BNP/PBNP 1 year preceding to the start of SGLT2 */

select distinct a.*, b.LabChemCompleteDateTime, b.LabChemResultNumericValue

into #tempBNPPBNPDPP4

from Dflt.Diabetes_HF_DPP4 as a with (NOLOCK) inner join
Diabetes_HF_above50_BNP_PBNP as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.LabChemCompleteDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempBNPPBNPDPP4

/*Patients with HF ICD codes 1 year preceding to the start of SGLT2 */

select distinct a.*, b.comorbidity_Dischargedatetime, b.comorbidity_ICD9Code as HFICDCode

into #tempHFDPP4

from Dflt.Diabetes_HF_DPP4 as a with (NOLOCK) inner join
Dflt.Diabetes_HF as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.comorbidity_Dischargedatetime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempHFDPP4

select distinct scrssn 

into #tempuniquedpp4
from #temploopDPP4
union all

select distinct scrssn
from #tempBNPPBNPDPP4
union all

select distinct scrssn
from #tempHFDPP4

select distinct scrssn from #tempuniquedpp4

/* combine all 3 to get the final cohort */
drop table #tempDiabetes_HF_DPP4_Final
select distinct a.*--, b.FillNumber, b.FillDateTime

into #tempDiabetes_HF_DPP4_Final

from Dflt.Diabetes_HF_DPP4 as a with (NOLOCK) inner join
tempmedLoop as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
and b.Fillnumber >1
union all

select distinct a.*--, b.LabChemCompleteDateTime, b.LabChemResultNumericValue, b.LabChemTestName 

from Dflt.Diabetes_HF_DPP4 as a with (NOLOCK) inner join
Dflt.Diabetes_HF_above50_BNP_PBNP as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.LabChemCompleteDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*--, b.DischargeDateTime, b.comorbidity_ICD9Code as HFICDCode

from Dflt.Diabetes_HF_DPP4 as a with (NOLOCK) inner join
Dflt.Diabetes_HF as b with (NOLOCK) on a.Scrssn= b.Scrssn
where b.comorbidity_Dischargedatetime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from #tempDiabetes_HF_DPP4_Final

drop table #tempDiabetes_HF_DPP4_Final

select distinct a.*, b.High_Value

into #templess50DPP4

from #tempDiabetes_HF_DPP4_Final as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.High_Value < 50 and b.ValueDateTime <=a.dpp4filltime

drop table #templess50DPP4

select distinct scrssn from #templess50DPP4 where high_value < 15

select distinct a.*--, b.DischargeDateTime, c.ICD10ProcedureCode

into Dflt.Diabetes_HF_DPP4_Final

from #tempDiabetes_HF_DPP4_Final as a where a.fillnumber >=2
AND NOT EXISTS (Select * from #templess50DPP4 as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Final

drop table Dflt.Diabetes_HF_DPP4_Final

/* Total Number of HF hospitalization prior to SGLT2 initiation */

select distinct a.*, b.DischargeDateTime
/*ICD9 Codes*/

into Dflt.SGLT2_PriorHFHospitalization

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*,b.DischargeDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*, b.PatientTransferDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*, b.SpecialtyTransferDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*,b.DischargeDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*,b.PatientTransferDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

union all

select distinct a.*,b.SpecialtyTransferDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_PriorHFHospitalization
select * from Dflt.SGLT2_PriorHFHospitalization
drop table Dflt.SGLT2_PriorHFHospitalization

/* Total Number of HF hospitalization prior to SGLT2 initiation */

select distinct a.*, b.AdmitDateTime

into Dflt.SGLT2_priorHFDDHospi

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.SGLT2FillTime) and a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_priorHFDDHospi

/* Total Number of HF hospitalization prior to DPP4 initiation */

select distinct a.*,b.DischargeDateTime
/*ICD9 Codes*/

into Dflt.DPP4_PriorHFHospitalization

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.SpecialtyTransferDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*,b.AdmitDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.*,b.DischargeDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_PriorHFHospitalization
select * from Dflt.DPP4_PriorHFHospitalization

/* Total Number of HF hospitalization prior to DPP4 initiation using only discharge diagnosis table*/

select distinct a.*,b.AdmitDateTime

into Dflt.DPP4_PriorHFDDHospi

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime between dateadd(year, -10, a.DPP4FillTime) and a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_PriorHFDDHospi

/* EXCLUSION CODES SGLT2 */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

select distinct a.*,  b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/
into #exclusioncodesSGLT2
--into Dflt.Diabetes_HF_SGLT2_ExclusionCodes

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ExclusionCodes

/* Code for Aortic Stenosis */
select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('395.0', '395.2','396.2')
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I06.0', 'I35.0', 'I35.2')

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_AorticStenosis

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AorticStenosis

/*Code for Mitral Insufficiency */
select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('394.1','396.1')
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I05.0')

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_MitralInsufficiency

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_MitralInsufficiency

select distinct *

into Dflt.Diabetes_HF_SGLT2_ALLExclusionCodes
from Dflt.Diabetes_HF_SGLT2_ExclusionCodes
union all

select distinct *
from Dflt.Diabetes_HF_SGLT2_AorticStenosis
union all

select distinct *
from Dflt.Diabetes_HF_SGLT2_MitralInsufficiency

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ALLExclusionCodes

/* EXCLUSION CODES DPP4 */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
drop table Dflt.Diabetes_HF_DPP4_ExclusionCodes
select distinct a.*,  b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_ExclusionCodes

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*,  b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('277.30','135.','425.1', '425.18', '425.11','429.0',
						'395.1', '746.4','396.0','394.0','394.2','423.2','674.50')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('E85.9','D86.0','D86.1','D86.2','D86.3','D86.81','D86.82','D86.83',
'D86.84','D86.85','D86.86','D86.87','D86.89','D86.9','I42.2', 'I42.1','I51.4', 'I40.9','Q23.1',
'I06.1','I06.2','I06.8','I06.9','I35.1','I05.1','I05.2','I05.8','I05.9','I31.1','O90.3')

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ExclusionCodes

drop table Dflt.Diabetes_HF_DPP4_ExclusionCodes

/* Code for Aortic Stenosis */
select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('395.0', '395.2','396.2')
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I06.0', 'I35.0', 'I35.2')

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_AorticStenosis

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('395.0', '395.2','396.2')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I06.0', 'I35.0', 'I35.2')

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AorticStenosis

/*Code for Mitral Insufficiency */
select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('394.1','396.1')
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I05.0')

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_MitralInsufficiency

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('394.1','396.1')
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_Final as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I05.0')

select distinct scrssn from Dflt.Diabetes_HF_DPP4_MitralInsufficiency

select distinct *

into Dflt.Diabetes_HF_DPP4_ALLExclusionCodes
from Dflt.Diabetes_HF_DPP4_ExclusionCodes
union all

select distinct *
from Dflt.Diabetes_HF_DPP4_AorticStenosis
union all

select distinct *
from Dflt.Diabetes_HF_DPP4_MitralInsufficiency

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ExclusionCodes

drop table  Dflt.Diabetes_HF_DPP4_ExclusionCodes

/* Final SGLT2 cohort after exclusions */

select distinct a.*

into Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions

from dflt.Diabetes_HF_SGLT2_Final as a where a.Fillnumber >=2
AND NOT EXISTS (Select * from Dflt.Diabetes_HF_SGLT2_ExclusionCodes as b where a.ScrSSN = b.ScrSSN)
--AND NOT EXISTS (Select * from #exclusioncodesSGLT2 as b where a.ScrSSN = b.ScrSSN)

select * 
into Dflt.Diabetes_HF_SGLT2_Final1
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions

select * from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions

/*select distinct a.scrssn
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions_new as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.scrssn= b.scrssn*/

drop table Dflt.Diabetes_HF_SGLT2_Final1

/* Final DPP4 cohort after exclusions */

select distinct a.*

into Dflt.Diabetes_HF_DPP4_FinalAfterExclusions

from dflt.Diabetes_HF_DPP4_Final as a where a.Fillnumber >=2
AND NOT EXISTS (Select * from Dflt.Diabetes_HF_DPP4_ExclusionCodes as b where a.ScrSSN = b.ScrSSN)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions

drop table Dflt.Diabetes_HF_DPP4_Final1

select *
into Dflt.Diabetes_HF_DPP4_Final1
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions

/* Baseline Measurements for SGLT2 Cohort */
/* Demographics */
/* Age */
drop table Dflt.Diabetes_HF_SGLT2_Age

select a.ScrSSN, a.sglt2Filltime, b.DOB,b.SEX
into Dflt.Diabetes_HF_SGLT2_DOB
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, sglt2Filltime) as age
into Dflt.Diabetes_HF_SGLT2_Age
from Dflt.Diabetes_HF_SGLT2_DOB

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Age where SEX ='F'

/* Date of Death */

select distinct a.ScrSSN,  b.DOD
--into Dflt.Diabetes_HF_SGLT2_DOD
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn
where b.DOD is not null

select distinct * from Dflt.Diabetes_HF_SGLT2_DOD where DOD > '2021-12-31'
select distinct * from #tempdodsglt2 where DOD > '2021-12-31'

drop table Dflt.Diabetes_HF_SGLT2_DOD

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_Hypertension

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Hypertension

/* Chronic Kidney Disease */
/*Making sure the ICD9 and ICD10 codes relevant to Kidney Disease are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8', '585.3')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_KidneyDisease

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_KidneyDisease
select distinct scrssn, comorbidity_ICD9Code from  Dflt.Diabetes_HF_SGLT2_KidneyDisease
order by comorbidity_ICD9Code

/*Include full CKD3 ICD10 codes (Irfan)*/


select distinct a.patientsid, a.scrssn, a.SGLT2Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_KidneyDisease2

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_KidneyDisease
select distinct scrssn, comorbidity_ICD9Code from  Dflt.Diabetes_HF_SGLT2_KidneyDisease2
order by comorbidity_ICD9Code

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_KidneyDisease2
select distinct scrssn from Dflt.Diabetes_HF_SGLT2_KidneyDisease

select top 10 * from Dflt.Diabetes_HF_SGLT2_KidneyDisease2

/*including ICD9 codes for CKD4 + 5 (Irfan) */


select distinct a.patientsid, a.scrssn, a.SGLT2Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_KidneyDisease3

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3','585.4','585.5')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_KidneyDisease3
select top 100 * from Dflt.Diabetes_HF_SGLT2_KidneyDisease3

drop table Dflt.Diabetes_HF_SGLT2_KidneyDisease3 --No difference in number of patients when CKD4 + 5 ICD-9 codes added (i.e. no difference between KidneyDisase 2 vs. KidneyDisease3)


/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_ESRD

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ESRD

/* Alcohol Abuse */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_AlcoholAbuse

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AlcoholAbuse

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

into Dflt.Diabetes_HF_SGLT2_PolyAbuse

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

Select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PolyAbuse

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_Malignancy

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(day, 1, a.SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Malignancy

/* Hypothyroidism */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like ('244.%')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like ('E03.%')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_Hypothyroidism

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Hypothyroidism

/*Smoking */

select distinct a.*, b.SMOKE

into #tempsmokestatus

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select * from #tempsmokestatus
select distinct scrssn from #tempsmokestatus where smoke = '1'
 
/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_Stroke

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Stroke

/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_MI

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.SGLT2FillTime

Select distinct scrssn from Dflt.Diabetes_HF_SGLT2_MI

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_HF_SGLT2_Ablation

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all 

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.visitdatetime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.SGLT2Filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.SGLT2Filltime

select * from Src.distinct_CPTCodes where ProcCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Ablation

drop table Dflt.Diabetes_HF_SGLT2_Ablation

/* CAD */
 
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_CAD_DiagnosisCodes

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_CAD_DiagnosisCodes

select *
into Dflt.Diabetes_HF_SGLT2_CAD
from Dflt.Diabetes_HF_SGLT2_CAD_DiagnosisCodes

/* PAD */

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_PAD_DiagnosisCodes

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PAD_DiagnosisCodes

select *
into Dflt.Diabetes_HF_SGLT2_PAD
from Dflt.Diabetes_HF_SGLT2_PAD_DiagnosisCodes


/*Cardioversion*/
/*Making sure the CPT codes relevant to Cardioversion are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92960','92961')

select distinct a.*

into Dflt.Diabetes_HF_SGLT2_Cardioversion

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all 

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')
union all

select distinct a.*
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92960','92961')

select * from Src.distinct_CPTCodes where ProcCode in ('92960','92961')

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Cardioversion

drop table Dflt.Diabetes_HF_SGLT2_Cardioversion

/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_HF_SGLT2_Cardioversion_ProcCodes

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.SGLT2Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.SGLT2Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.SGLT2Filltime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Cardioversion_ProcCodes

/* Atrial Fibrillation */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('427.31')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'I48.%'

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_AF

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AF


/* Schizoprenic Disorder */
/*Making sure the ICD9 and ICD10 codes relevant to Schizoprenic Disorder are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like '295.%'

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_SchizoDisorder

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_SchizoDisorder

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_Depression

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Depression

/* COPD Chronic Obstructive Pulmonary Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_COPD

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_COPD

/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_LiverDisease

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_LiverDisease

/* Prior Pacemaker */
/*Making sure the ICD9 and ICD10 codes relevant to Prior Pacemaker are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('V45.01','V45.02')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('Z95.0','Z95.810')

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('33210','33206','33207','33216','33217')

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_PriorPMDC

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.PatientTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.SpecialtyTransferDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.AdmitDateTime <= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.SGLT2FillTime
union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.PatientTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.SpecialtyTransferDateTime <= a.SGLT2FillTime

union all

select distinct a.patientsid, a.scrssn, a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.AdmitDateTime <= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PriorPMDC

/*BMI*/
/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals
select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitals

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(DAY, 1, b.SGLT2FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.SGLT2FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime <= b.SGLT2FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitals

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

select distinct scrssn from #tempweightfinal

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

select distinct scrssn from #tempheightfinal

/* Combine data from table weight and height to obtain the bmi for individual patient */
drop table  Dflt.Diabetes_HF_SGLT2_BMI

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_HF_SGLT2_BMI

from #tempheightfinal as a with (NOLOCK) inner join
#tempweightfinal as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.SGLT2FillTime=b.SGLT2FillTime and

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI where bmi between 35 and 40

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI where bmi > 40

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI where bmi < 30 

/* HBA1C */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
where LabChemTestName like '%A1C%' AND
	LabChemTestName not like '%ZZ%' AND
	LabChemTestName not like '%XX%'

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_HF_SGLT2_hba1c

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_hba1c

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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_SGLT2_Creatinine
from #tempCreatinine
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Creatinine

/* Albumin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempAlbumin

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select *
into Dflt.Diabetes_HF_SGLT2_Albumin
from #tempAlbumin
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Albumin

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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_SGLT2_Hematocrit
from #temphematocrit
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Hematocrit

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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_SGLT2_Hemoglobin
from #temphemoglobin
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Hemoglobin

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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_HF_SGLT2_BUN
from #tempBUN
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BUN

/* Alkaline Phosphatase */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Alkaline Phosphatase%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_SGLT2_AlkalinePhosphatase

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AlkalinePhosphatase

select *
into Dflt.Diabetes_HF_SGLT2_Alpho
from Dflt.Diabetes_HF_SGLT2_AlkalinePhosphatase

drop table Dflt.Diabetes_HF_SGLT2_AlkalinePhosphatase

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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_SGLT2_AST
from #tempAST
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AST

/* Bilirubin*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Bilirubin%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_SGLT2_Bilirubin

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

Select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Bilirubin

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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'
	
select *
into Dflt.Diabetes_HF_SGLT2_BNP
from #tempBNP
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BNP

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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_SGLT2_PBNP
from #tempPBNP
where LabChemCompleteDateTime between dateadd(month, -6, SGLT2FillTime) and dateadd(day, 1, SGLT2FillTime)

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PBNP

drop table Dflt.Diabetes_HF_SGLT2_PBNP

/* Other Medications */
select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedications

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.SGLT2FillTime) and a.SGLT2FillTime and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.SGLT2FillTime) and a.SGLT2FillTime and 
b.FillNumber > '1'

select top 1000* from #tempMedications

/*Aspirin */
/* Check for the LocalDrugNameWithDose in the dimension table */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Aspirin%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_Aspirin 

from #tempMedications where LocalDrugNameWithDose like '%Aspirin%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Aspirin  

/*Statin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%atorvastatin%' 
or LocalDrugNameWithDose like '%lovastatin%' 
or LocalDrugNameWithDose like '%pravastatin%' 
or LocalDrugNameWithDose like '%rosuvastatin%' 
or LocalDrugNameWithDose like '%simvastatin%' 
or LocalDrugNameWithDose like '%Fluvastatin%'

drop table Dflt.Diabetes_HF_SGLT2_Statin

select distinct *

into Dflt.Diabetes_HF_SGLT2_Statin

from #tempMedicationsloop where LocalDrugNameWithDose like '%atorvastatin%' 
or LocalDrugNameWithDose like '%lovastatin%' 
or LocalDrugNameWithDose like '%pravastatin%' 
or LocalDrugNameWithDose like '%rosuvastatin%' 
or LocalDrugNameWithDose like '%simvastatin%' 
or LocalDrugNameWithDose like '%Fluvastatin%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Statin

/* Beta Blockers */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_BB

from #tempMedications where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BB

drop table Dflt.Diabetes_HF_SGLT2_BB

/* ACE Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_ACE

from #tempMedications where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ACE

/*ARB Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct *

into Dflt.Diabetes_HF_SGLT2_ARB

from #tempMedications where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ARB

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_HF_SGLT2_ACEARB

from Dflt.Diabetes_HF_SGLT2_ACE 
union all

select distinct *

from Dflt.Diabetes_HF_SGLT2_ARB

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_ACEARB 

/* Spironolactone/Eplerenone */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_SpiroEp

from #tempMedications where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_SpiroEp

/* Loop Diuretic */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsLoop

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(month, 12, a.SGLT2FillTime) and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.SGLT2FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.SGLT2FillTime) and dateadd(month, 12, a.SGLT2FillTime) and 
b.FillNumber > '1'

select distinct *

into Dflt.Diabetes_HF_SGLT2_LoopDiuretic

from #tempMedicationsloop where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_LoopDiuretic

drop table Dflt.Diabetes_HF_SGLT2_LoopDiuretic

/* Insulin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%insulin%' 

select distinct *

into Dflt.Diabetes_HF_SGLT2_Insulin

from #tempMedications where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Insulin

drop table Dflt.Diabetes_HF_SGLT2_Insulin

/* GLP1 Analogue */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_GLP1

from #tempMedications where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_GLP1

/* DPP4 I */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%gliptin%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_DPP4

from #tempMedications where LocalDrugNameWithDose like '%gliptin%'

drop table  Dflt.Diabetes_HF_SGLT2_DPP4

/* Metformin */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metformin%' 

select distinct *

into Dflt.Diabetes_HF_SGLT2_Metformin

from #tempMedications where LocalDrugNameWithDose like '%metformin%' 

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Metformin

/* Sulfonylurea */
select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_HF_SGLT2_Sulfonylurea

from #tempMedications where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Sulfonylurea



/* Thiazoldiandione- check */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_Thiazol

from #tempMedications where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Thiazol

/* Anti-Arrythmia Drugs */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct *

into Dflt.Diabetes_HF_SGLT2_AntiArrythmiaDrugs

from #tempMedications where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AntiArrythmiaDrugs

select *
into Dflt.Diabetes_HF_SGLT2_AntiArr
from Dflt.Diabetes_HF_SGLT2_AntiArrythmiaDrugs

/* Blood Pressure */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

into Dflt.Diabetes_HF_SGLT2_BP

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(DAY, 1, b.SGLT2FillTime)) AND
c.VitalType in ('%Blood pressure%')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND 
c.VitalType like ('%Blood pressure%')

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BP

/* DPP4 Cohort Comorbidity Extraction */

/* Baseline Measurements for DPP4 Cohort */
/* Demographics */
/* Age */
drop table Dflt.Diabetes_HF_DPP4_Age

select a.ScrSSN, a.DPP4Filltime, b.DOB,b.SEX
into Dflt.Diabetes_HF_DPP4_DOB
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn

select *, datediff( year, DOB, DPP4Filltime) as age
into Dflt.Diabetes_HF_DPP4_Age
from Dflt.Diabetes_HF_DPP4_DOB

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Age where SEX ='F'

/* Date of Death */

select distinct a.ScrSSN,  b.DOD
--into Dflt.Diabetes_HF_DPP4_DOD
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.VitalStatus_Mini as b with (NOLOCK) on a.scrssn= b.scrssn
where b.DOD is not null

select distinct scrssn from Dflt.Diabetes_HF_DPP4_DOD

drop table Dflt.Diabetes_HF_DPP4_DOD

/* Hypertension */

select distinct a.*, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_Hypertension

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('401.1','401.0','401.9','402.00','402.01','402.90','402.91','403.00','403.01','403.10','403.11','403.90','403.91','404.00','404.01','404.02','404.03','404.10',
					'404.11','404.12','404.13','404.90','404.91','404.92','404.93','405.01','405.09','405.11','405.99','642.00','642.01','642.02','642.03','642.04','642.10','642.11',
					'642.12','642.13','642.14','642.20','642.21','642.22','642.23','642.24','642.70','642.71','642.72','642.73','642.74','642.90','642.91','642.92','642.93','642.94')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.*, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I10.', 'I16.9', 'I11.9','I11.0', 'I12.9', 'I12.0','I13.10', 'I13.0', 'I13.11', 'I13.2', 'I15.0', 'I15.8', 
					'O10.019','O10.919', 'O10.011', 'O10.012', 'O10.013', 'O10.02', 'O10.911', 'O10.912', 'O10.913', 'O10.92', 'O10.03', 'O10.93', 
					'O10.419', 'O10.411', 'O10.412', 'O10.413', 'O10.42', 'O10.43','O10.119', 'O10.219', 'O10.319', 'O10.111', 'O10.112', 'O10.113', 'O10.12', 
					'O10.211', 'O10.212', 'O10.213','O10.22', 'O10.311', 'O10.312', 'O10.313', 'O10.32', 'O10.13', 'O10.23', 'O10.33', 'O11.9', 'O11.1', 'O11.2', 
					'O11.3', 'O11.4','O11.5', 'O16.9', 'O16.1', 'O16.2', 'O16.3', 'O16.4', 'O16.5')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Hypertension

/* Chronic Kidney Disease */
/*Making sure the ICD9 and ICD10 codes relevant to Kidney Disease are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
													'V56.0','V56.1','V56.2','V56.8','585.3')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'

select distinct a.patientsid, a.scrssn, a.DPP4Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_KidneyDisease

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_KidneyDisease

/*Adding complete ICD10 codes for CKD 3 (Irfan) */

select distinct a.patientsid, a.scrssn, a.DPP4Filltime ,b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_KidneyDisease2

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('403.01','403.11','403.91','404.02','404.03','404.12','404.92','404.93','585.5','585.6','V42.0','V45.11',
				'V56.0','V56.1','V56.2','V56.8','585.3')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I12.0','I13.11','I13.2','N18.5','N18.6','Z94.0','Z99.2','N18.3','N18.30','N18.31','N18.32') or ICD10Code like 'Z49.%'
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_KidneyDisease2

/* End Stage Renal Disease - ESRD */
/*Making sure the ICD9 and ICD10 codes relevant to ESRD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('585.6')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('N18.6')

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_ESRD

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('585.6')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4Filltime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('N18.6')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ESRD

/* Alcohol Abuse */
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_AlcoholAbuse

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('290.0','291.1','291.2','291.3','291.5','291.81','291.82','291.89','291.9',
			    '303.00','303.01','303.02','303.03','303.90','303.91','303.92','303.93','305.00','305.01','305.02','305.03','V11.3')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.231', 'F10.96', 'F10.27','F10.951','F10.950', 'F10.239', 'F10.182', 'F10.282', 'F10.982', 'F10.159', 'F10.180', 
					'F10.181', 'F10.188','F10.259', 'F10.280', 'F10.281', 'F10.288', 'F10.959', 'F10.980', 'F10.99','F10.229', 'F10.20', 'F10.21','F10.10','F10.11','Z65.8 ')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AlcoholAbuse

/*Polysubstance Abuse */
/*Making sure the ICD9 and ICD10 codes relevant to Polysubstance Abuse are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
																	'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
																	'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
																	'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
															'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10',
															'305.70','304.40','304.6')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_PolyAbuse

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('303.00','305.00','303.90','304.00','292.89','292.0','292.9','304.10','305.40','304.20','305.60',
					'304.30','305.20','304.50','305.30','305.90','304.60','304.80','304.90','305.10','305.70','304.40','304.6')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F10.129','F10.229','F10.929','F10.10','F10.20','F11.10',
					'F11.10','F11.20','F11.129','F11.229','F11.929','F11.122','F11.222','F11.922','F11.23','F11.99',
					'F13.10','F13.20','F14.10','F14.20','F12.10','F12.20','F16.10','F16.20','F18.10','F18.20',
					'F19.10','F19.20','Z72.0','F17.200','F15.10','F15.20','F15.929')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

Select distinct scrssn from Dflt.Diabetes_HF_DPP4_PolyAbuse

/* Malignancy */
/*Making sure the ICD9 and ICD10 codes relevant to Malignancy are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_Malignancy

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('196.0','196.1','196.2','196.3','196.5','196.6','196.8','196.9','197.0','197.1','197.2','197.3','197.4','197.5',
					'197.6','197.7','197.8','198.0','198.1','198.2','198.3','198.4','198.5','198.6','198.7','198.81','198.82','198.89','199.0','199.1')
					and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1') 
and b.DischargeDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.EventDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.PatientTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.SpecialtyTransferDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('C77.0','C77.1','C77.2','C77.3','C77.4','C77.5','C77.8','C77.9','C78.0','C78.1','C78.2','C78.3',
					'C78.4', 'C78.5','C78.6', 'C78.7', 'C78.89','C79.9','C79.11','C79.2','C79.31','C79.32','C79.49',
					'C79.51','C79.52','C79.60','C79.70','C79.81','C79.82','C79.89','C80.0','C80.1')
and b.AdmitDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(day, 1, a.DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Malignancy

/* Hypothyroidism */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_Hypothyroidism

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like ('244.%')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like ('E03.%')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Hypothyroidism

/*Smoking */

select distinct a.*, b.SMOKE

into #tempsmokestatus

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.VASQIP_nso_noncardiac as b with (NOLOCK) on a.scrssn= b.scrssn 

select * from #tempsmokestatus
select distinct scrssn from #tempsmokestatus where smoke = '1'
 
/*Prior Stroke */
/*Making sure the ICD9 and ICD10 codes relevant to Stroke are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_Stroke

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('433.21','433.11','433.91','433.01','434.01','434.11','434.91','433.31','433.81')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I63.019','I63.119','I63.139','I63.20','I63.219','I63.22','I63.239','I63.30','I63.40','I63.50','I63.59')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Stroke

/* Prior Myocardial Infarction */
/*Making sure the ICD9 and ICD10 codes relevant to Myocardial Infarction are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
																	'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_MI

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime , c.ICD9Code 

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
														'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
														'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
				and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('410.00','410.01','410.02','410.10','410.11','410.12','410.30','410.31','410.32','410.20','410.21','410.22',
					'410.40','410.41','410.42','410.50','410.51','410.52','410.60','410.61','410.62','410.80','410.81','410.82',
					'410.90','410.91','410.92','410.70','410.71','410.72','429.79','411.81','411.0','411.89')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I21.01','I21.02','I21.19','I21.29','I21.3','I21.4','I21.9','I22.0','I22.1','I22.8','I22.9',
					'I23.0','I23.1','I23.2','I23.3','I23.4','I23.5','I23.6','I23.7','I23.8','I24.0','I24.1','I24.8')
and b.AdmitDateTime <= a.DPP4FillTime

Select distinct scrssn from Dflt.Diabetes_HF_DPP4_MI

/*Ablation*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct a.*

into Dflt.Diabetes_HF_DPP4_Ablation

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.AdmitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all 

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266') 
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.VisitDateTime <= a.dpp4filltime

select * from Src.distinct_CPTCodes where ProcCode in ('93656','93657','93662','33254','33255','33258','33265','33266')

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Ablation

/* CAD */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_CAD

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('411.00''411.10','411.81','411.89','413.00','413.90','414.00','414.01','414.02','414.03','414.04',
'414.05','414.06','414.20','414.30','414.40','414.80','414.90','V45.81','V45.82')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I24.1','I20.0','I24.0','I24.8','I28.0','I20.8','I20.9','I25.0','I25.10','I25.810','I25.811',
'I25.82','I25.83','I25.84','I25.5','I25.9','I25.89','Z95.1','Z98.61')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_CAD

select *
into Dflt.Diabetes_HF_DPP4_CAD
from Dflt.Diabetes_HF_DPP4_CAD_DiagnosisCodes

/*PAD */

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_PAD

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('440.0','440.0','440.1','440.2','440.20','440.21','440.22','440.23','440.24','440.29','440.30',
                    '440.31','440.32','440.4','440.8','440.9','441.0','441.00','441.01','441.02','441.03','441.1','441.2',
					'441.3','441.4','441.5','441.6','441.7','441.9','442.0','442.1','442.2','442.3','442.81','442.82',
					'442.83','442.84','442.89','442.9','443.0','443.1','443.21','443.22','443.23','443.24','443.29')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
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

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I70.0','I70.1','I70.209','I70.219','I70.229','I70.25','I70.269','I70.299','I70.399','I70.499','I70.599','I70.92','I70.8','I70.90',
                    'I71.00','I71.01','I71.02','I71.03','I71.1','I71.2','I71.3','I71.4','I71.5','I71.6','I71.8','I71.9','I72.0','I72.1','I72.2','I72.3',
					'I72.4','I72.5','I72.6','I72.8','I72.9','I73.00','I73.01','I73.1','I73.81','I73.89','I73.9','I77.1','I77.71','I77.72','I77.73','I77.74',
					'I77.75','I77.76','I77.77','I77.79','I79.8','K55.1','K55.9','Z95.828')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_PAD

select *
into Dflt.Diabetes_HF_DPP4_PAD
from Dflt.Diabetes_HF_DPP4_PAD_DiagnosisCodes

/*Cardioversion*/
/*Making sure the CPT codes relevant to Ablation are present in the Dimension table under CDWWork*/

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('92961','92962')

select distinct a.*

into Dflt.Diabetes_HF_DPP4_Cardioversion

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientCPTProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.AdmitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_Vprocedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all 

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedure_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
Src.Cohort_CPT as c with (NOLOCK) on c.CPTSID=b.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryPrincipalAssociatedProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.OtherProcedureCPTSID=c.cptSID 
where c.cptcode in ('92961','92962') 
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Surg_SurgeryProcedureDiagnosisCode as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.PrincipalCPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.SurgeryDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.VisitDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VProcedureDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('93656','93657','93662','33254','33255','33258','33265','33266')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.EventDateTime <= a.dpp4filltime
union all

select distinct a.*
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVProcedureCPTModifier as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join
Src.Cohort_CPT as c with (NOLOCK) on  b.CPTSID=c.cptSID 
where c.cptcode in ('92961','92962')
and b.VisitDateTime <= a.dpp4filltime

select * from Src.distinct_CPTCodes where ProcCode in ('92961','92962')

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Cardioversion

/* Cardioversion Proc codes */

select distinct ICD9ProcedureCode from CDWWork.Dim.ICD9Procedure where ICD9ProcedureCode in ('99.61','99.62') 
select distinct ICD10ProcedureCode from CDWWork.Dim.ICD10Procedure where ICD10ProcedureCode in ('5A2204Z') 

select distinct a.*, b.ICDProcedureDateTime, c.ICD9ProcedureCode
/*ICD9Procedure Codes*/

into Dflt.Diabetes_HF_DPP4_Cardioversion_ProcCodes

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9ProcedureCode

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9Procedure as c with (NOLOCK) on b.ICD9ProcedureSID=c.ICD9ProcedureSID 
where ICD9ProcedureCode in ('99.61','99.62')
					and b.DischargeDateTime <= a.DPP4Filltime
union all

/*ICD10Procedure Codes*/
select distinct a.*, b.ICDProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.ICDProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.SurgicalProcedureDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_CensusSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.SurgicalProcedureDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientICDProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10ProcedureCode

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientSurgicalProcedure as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10Procedure as c with (NOLOCK) on b.ICD10ProcedureSID=c.ICD10ProcedureSID 
where ICD10ProcedureCode in ('5A2204Z')
and b.DischargeDateTime <= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Cardioversion_ProcCodes

/* Atrial Fibrillation */
/* Making sure the codes are available in the CDWWork Dimension table */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('427.31')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'I48.%'

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_AF

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AF


/* Schizoprenic Disorder */
/*Making sure the ICD9 and ICD10 codes relevant to Schizoprenic Disorder are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like '295.%'

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_SchizoDisorder

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code like '295.%'
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_SchizoDisorder

/*Depression */
/*Making sure the ICD9 and ICD10 codes relevant to depression are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_Depression

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('296.20','296.22','296.23','296.30','296.32','296.33','300.00','311.','300.4','301.12','309.0','309.1')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F32.9','F32.1','F32.2','F33.1','F33.2','F41.9','F34.1','F43.21') 
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Depression

/* COPD Chronic Obstructive Pulmonary Disease*/
/*Making sure the ICD9 and ICD10 codes relevant to COPD are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_COPD

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('490.','491.0','491.1','491.2','491.20','491.21','491.22','491.8','491.9','492.0','492.8',
'493.00','493.01','493.02','493.10','493.11','493.12','493.20','493.21','493.22','493.81','493.82','493.90','493.91','493.92',
'494.','494.0','494.1','495.0','495.1','495.2','495.3','495.4','495.5','495.6','495.7','495.8','495.9','496.')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('F20.0','F20.1','F20.2','F20.3','F20.81','F20.89','F20.9','F25.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('J40.','J41.0','J41.1','J41.8','J42.','J43.9','J44.0','J44.1','J44.9',
'J45.20','J45.22','J45.21','J45.990','J45.991','J45.909','J45.998','J45.902','J45.901','J47.9','J47.1',
'J67.0','J67.1','J67.2','J67.3','J67.4','J67.5','J67.6','J67.7','J67.8','J67.9')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_COPD

/* Chronic Liver Disease */
/*Making sure the ICD9 and ICD10 codes relevant to CLD are present in the Dimension table under CDWWork*/

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
													'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
												'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_LiverDisease

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('070.22','070.32','070.23','070.33','070.44','070.54','456.1','456.0','456.21','456.20','571.0','571.2','571.3',
					'571.41','571.49','571.40','571.42','571.5','571.9','571.6','571.8','572.3','572.8','V42.7')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4') 
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('B18.0','B18.1','B18.2','I85.00','I85.01','I85.10','I85.11','K70.0','K70.30','K70.9','K73.0','K73.2','K73.8','K73.9',
					'K75.4','K74.0','K74.60','K74.69','K74.3','K74.4','K74.5','K74.1','K76.0','K76.89','K76.9','K76.6','K72.10','K72.90','Z94.4')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_LiverDisease

/* Prior Pacemaker */
/*Making sure the ICD9 and ICD10 codes relevant to Prior Pacemaker are present in the Dimension table under CDWWork*/

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in ('V45.01','V45.02')

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in ('Z95.0','Z95.810')

select distinct CPTCode from CDWWork.Dim.CPT where CPTCode in ('33210','33206','33207','33216','33217')

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatettime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_PriorPMDC

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.PatientTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.SpecialtyTransferDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('V45.01','V45.02')
					and b.AdmitDateTime <= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.DischargeDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.DPP4FillTime
union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.EventDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.PatientTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.SpecialtyTransferDateTime <= a.DPP4FillTime

union all

select distinct a.patientsid, a.scrssn, a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('Z95.0','Z95.810')
and b.AdmitDateTime <= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_PriorPMDC

/*BMI*/
/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitals

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(DAY, 1, b.DPP4FillTime)) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime <= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitals

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

select distinct scrssn from #tempweightfinal

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

select distinct scrssn from #tempheightfinal

/* Combine data from table weight and height to obtain the bmi for individual patient */
drop table  Dflt.Diabetes_HF_DPP4_BMI

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_HF_DPP4_BMI

from #tempheightfinal as a with (NOLOCK) inner join
#tempweightfinal as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
--where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.DPP4FillTime=b.DPP4FillTime and

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI where bmi between 35 and 40

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI where bmi > 40

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI where bmi < 30 

/* HBA1C */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
where LabChemTestName like '%A1C%' AND
	LabChemTestName not like '%ZZ%' AND
	LabChemTestName not like '%XX%'

/* Current VA phenomics library is updated and shows only %A1C% */

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime,c.LabChemTestName

into Dflt.Diabetes_HF_DPP4_hba1c

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime)                                
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue,a.LabChemCompleteDateTime,c.LabChemTestName

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime)  
union all

select b.*, a.LabChemResultValue, a.LabChemResultNumericValue, a.LabChemCompleteDateTime, c.LabChemTestName

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
where c.LabChemTestName like '%A1C%' AND
	c.LabChemTestName not like '%ZZ%' AND
	c.LabChemTestName not like '%XX%'
and a.LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_hba1c

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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_DPP4_Creatinine
from #tempCreatinineDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Creatinine

drop table Dflt.Diabetes_HF_DPP4_Creatinine
/* Albumin */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into #tempAlbuminDPP4

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Albu%' AND
	LabChemTestName not like '%Prealbumin%' AND
	LabChemTestName not like '%pre-albumin%'

select *
into Dflt.Diabetes_HF_DPP4_Albumin
from #tempAlbuminDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Albumin

drop table Dflt.Diabetes_HF_DPP4_Albumin

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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_DPP4_Hematocrit
from #temphematocritDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Hematocrit

drop table Dflt.Diabetes_HF_DPP4_Hematocrit

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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_DPP4_Hemoglobin
from #tempHemoglobinDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Hemoglobin

drop table Dflt.Diabetes_HF_DPP4_Hemoglobin

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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

union all

select distinct b.*, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE (LabChemTestName like '%[^a-z]bun[^a-z]%' OR 
		LabChemTestName like '%urea%nit%' OR
		LabChemTestName like '%blood%urea%nitro%' ) AND
		LabChemTestName not like '%Pylori%' AND
		LabChemTestName not like '%ratio%'

select *
into Dflt.Diabetes_HF_DPP4_BUN
from #tempBUNDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BUN

drop table Dflt.Diabetes_HF_DPP4_BUN

/* Alkaline Phosphatase */
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Alkaline Phosphatase%'

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_DPP4_Alpho

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Alkaline Phosphatase%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Alpho

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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_DPP4_AST
from #tempASTDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AST

drop table Dflt.Diabetes_HF_DPP4_AST

/* Bilirubin*/
/* Check for the labchemtestname in the dimension table */
select distinct labchemtestname from CDWWork.Dim.Labchemtest 
WHERE LabChemTestName like '%Bilirubin%'
drop table Dflt.Diabetes_HF_DPP4_Bilirubin
select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

into Dflt.Diabetes_HF_DPP4_Bilirubin

from Src.Chem_LabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_LabChem_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)
union all

select distinct b.*, a.LabChemResultValue,c.LabChemTestName, a.LabChemCompleteDateTime, a.LabChemResultNumericValue

from Src.Chem_PatientLabChem as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE LabChemTestName like '%Bilirubin%'
and LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

Select distinct scrssn from Dflt.Diabetes_HF_DPP4_Bilirubin

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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.LabChemTest as c with (NOLOCK) on a.LabChemTestSID=c.LabChemTestSID
WHERE 
   (labchemtestname like '%BNP%' or  
	labchemtestname  like '%brain natriuretic peptide%' or 
	labchemtestname  like '%natriu%pept%') and
	LabChemTestName not like '%ratio%' AND
	LabChemTestName not like '%pro%'

select *
into Dflt.Diabetes_HF_DPP4_BNP
from #tempBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BNP

drop table Dflt.Diabetes_HF_DPP4_BNP

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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
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
into Dflt.Diabetes_HF_DPP4_PBNP
from #tempPBNPDPP4
where LabChemCompleteDateTime between dateadd(month, -6, DPP4FillTime) and dateadd(day, 1, DPP4FillTime)

select distinct scrssn from Dflt.Diabetes_HF_DPP4_PBNP

drop table Dflt.Diabetes_HF_DPP4_PBNP

/* Other Medications */
select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsDPP4

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.DPP4FillTime) and a.DPP4FillTime and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -6, a.DPP4FillTime) and a.DPP4FillTime and 
b.FillNumber > '1'

select top 1000* from #tempMedications

/*Aspirin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Aspirin%'

select distinct *

into Dflt.Diabetes_HF_DPP4_Aspirin 

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%Aspirin%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Aspirin  
drop table Dflt.Diabetes_HF_DPP4_Aspirin  
/*Statin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%atorvastatin%' 
or LocalDrugNameWithDose like '%lovastatin%' 
or LocalDrugNameWithDose like '%pravastatin%' 
or LocalDrugNameWithDose like '%rosuvastatin%' 
or LocalDrugNameWithDose like '%simvastatin%' 
or LocalDrugNameWithDose like '%Fluvastatin%'
drop table Dflt.Diabetes_HF_DPP4_Statin
select distinct *

into Dflt.Diabetes_HF_DPP4_Statin

from #tempMedicationsDPP4loop where LocalDrugNameWithDose like '%atorvastatin%' 
or LocalDrugNameWithDose like '%lovastatin%' 
or LocalDrugNameWithDose like '%pravastatin%' 
or LocalDrugNameWithDose like '%rosuvastatin%' 
or LocalDrugNameWithDose like '%simvastatin%' 
or LocalDrugNameWithDose like '%Fluvastatin%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Statin

/* Beta Blockers */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'
drop table Dflt.Diabetes_HF_DPP4_BB
select distinct *

into Dflt.Diabetes_HF_DPP4_BB

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%metoprolol%' or LocalDrugNameWithDose like '%carvedilol%' or LocalDrugNameWithDose like '%bisoprolol%' or
		LocalDrugNameWithDose like '%nebivolol%' or LocalDrugNameWithDose like '%atenolol%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BB

/* ACE Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'
drop table Dflt.Diabetes_HF_DPP4_ACE
select distinct *

into Dflt.Diabetes_HF_DPP4_ACE

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%lisinopril%' or LocalDrugNameWithDose like '%Fosinopril%' or LocalDrugNameWithDose like '%ramipril%' or
		LocalDrugNameWithDose like '%quinapril%' or LocalDrugNameWithDose like '%benazepril%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ACE

/*ARB Inhibitor */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 
drop table Dflt.Diabetes_HF_DPP4_ARB 
select distinct *

into Dflt.Diabetes_HF_DPP4_ARB

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%valsartan%' or LocalDrugNameWithDose like '%losartan%' or LocalDrugNameWithDose like '%candesartan%' or
		LocalDrugNameWithDose like '%Olmesartan%' or LocalDrugNameWithDose like '%telmisartan%' or LocalDrugNameWithDose like '%irbesartan%' 

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ARB

/* ACE and ARB */

select distinct * 

into Dflt.Diabetes_HF_DPP4_ACEARB

from Dflt.Diabetes_HF_DPP4_ACE 
union all

select distinct *

from Dflt.Diabetes_HF_DPP4_ARB

select distinct scrssn from Dflt.Diabetes_HF_DPP4_ACEARB 

/* Spironolactone/Eplerenone */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'
drop table Dflt.Diabetes_HF_DPP4_SpiroEp
select distinct *

into Dflt.Diabetes_HF_DPP4_SpiroEp

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%spironolactone%' or LocalDrugNameWithDose like '%Eplerenone%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_SpiroEp

/* Loop Diuretic */
/* Check for the LocalDrugNameWithDose in the dimension table */
select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

into #tempMedicationsDPP4loop

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(month, 12, a.DPP4FillTime) and 
b.FillNumber > '1'
union all

select distinct a.PatientSID, a.ScrSSN, a.DPP4FillTime, b.FillDateTime, b.LocalDrugNameWithDose, b.FillNumber, b.DaysSupply, b.Qty

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.FillDateTime between dateadd(month, -12, a.DPP4FillTime) and dateadd(month, 12, a.DPP4FillTime) and 
b.FillNumber > '1'

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct *

into Dflt.Diabetes_HF_DPP4_LoopDiuretic

from #tempMedicationsDPP4loop where LocalDrugNameWithDose like '%furosemide%' or LocalDrugNameWithDose like '%torsemide%' or LocalDrugNameWithDose like '%bumetanide%' or
		LocalDrugNameWithDose like '%Ethacrynic acid%' or LocalDrugNameWithDose like '%lasix%' or LocalDrugNameWithDose like '%bumex%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_LoopDiuretic

/* Insulin */
/* Check for the LocalDrugNameWithDose in the dimension table */
select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%insulin%' 
drop table Dflt.Diabetes_HF_DPP4_Insulin
select distinct *

into Dflt.Diabetes_HF_DPP4_Insulin

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%insulin%' 

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Insulin

/* GLP1 Analogue */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct *

into Dflt.Diabetes_HF_DPP4_GLP1

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_GLP1

/* DPP4 I */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%gliptin%'

select distinct *

into Dflt.Diabetes_HF_DPP4_DPP4

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%gliptin%'

drop table  Dflt.Diabetes_HF_DPP4_DPP4

/* Metformin */

select * from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%metformin%' 

select distinct *

into Dflt.Diabetes_HF_DPP4_Metformin

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%metformin%' 

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Metformin

drop table Dflt.Diabetes_HF_DPP4_Metformin

/* Sulfonylurea */
select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct *

into Dflt.Diabetes_HF_DPP4_Sulfonylurea

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%Glipizide%' or
			  LocalDrugNameWithDose like '%Glimepiride%' or
			  LocalDrugNameWithDose like '%Glyburide%' or
			  LocalDrugNameWithDose like '%Tolbutamide%' 

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Sulfonylurea

drop table Dflt.Diabetes_HF_DPP4_Sulfonylurea

/* Thiazoldiandione */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct *

into Dflt.Diabetes_HF_DPP4_Thiazol

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%pioglitazone%' 
or LocalDrugNameWithDose like '%rosiglitazone%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Thiazol

drop table Dflt.Diabetes_HF_DPP4_Thiazol

/* Anti-Arrythmia Drugs */

select distinct LocalDrugNameWithDose from CDWWork.Dim.LocalDrug where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct *

into Dflt.Diabetes_HF_DPP4_AntiArr

from #tempMedicationsDPP4 where LocalDrugNameWithDose like '%soltalol%' 
or LocalDrugNameWithDose like '%Dofetilide%' 
or LocalDrugNameWithDose like '%flecainide%' 
or LocalDrugNameWithDose like '%propafenone%' 
or LocalDrugNameWithDose like '%amiodarone%' 
or LocalDrugNameWithDose like '%dronaderone%'
or LocalDrugNameWithDose like '%digoxin%'

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AntiArr


/* Blood Pressure */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

into Dflt.Diabetes_HF_DPP4_BP

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(DAY, 1, b.DPP4FillTime)) AND
c.VitalType in ('%Blood pressure%')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where (a.VitalSignTakenDateTime between dateadd(month, -6, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND 
c.VitalType like ('%Blood pressure%')

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BP

select distinct scrssn from Dflt.Diabetes_HF_above50_Loop_BNP_PBNP

//** After the drug initiation - Extraction **//

/* All HF hospitalization after SGLT2 initiation */

select distinct a.*, b.DischargeDateTime,c.ICD9Code
/*ICD9 Codes*/

into Dflt.SGLT2_HFHospitalization

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime >= a.SGLT2FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_HFHospitalization
select * from Dflt.SGLT2_HFHospitalization

/* All HF hospitalization after DPP4 initiation */

select distinct a.*, b.DischargeDateTime, c.ICD9Code
/*ICD9 Codes*/

into Dflt.DPP4_HFHospitalization

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.PatientTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*,b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.SpecialtyTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime,c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.PatientTransferDateTime >= a.DPP4FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.SpecialtyTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_HFHospitalization
select * from Dflt.DPP4_HFHospitalization


/* Use only Discharge diagnosis table to identify HF hospitalization events - SGLT2 */

select distinct a.*, b.AdmitDateTime

into Dflt.SGLT2_HFDDHospi

/*ICD9 Code */

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime >= a.SGLT2FillTime
union all
/*ICD10 Code */

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_HFDDHospi

/* Use only Discharge diagnosis table to identify the HF hospitalization events - DPP4*/

select distinct a.*,b.AdmitDateTime

into Dflt.DPP4_HFDDHospi

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('398.91','428.0','428.1','428.20','428.21','428.22','428.23','428.30',
						'428.31','428.32','428.33','428.40','428.41','428.42','428.43','428.9')
					and b.AdmitDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code in ('I50.00','I50.1','I50.20','I50.30','I50.40','I50.9',
									'I11.0','I13.0','I13.2','I25.5')
and b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_HFDDHospi

/* All hospitalization after SGLT2 initiation */

select distinct a.*, b.DischargeDateTime,c.ICD9Code
/*ICD9 Codes*/

into Dflt.SGLT2_AllHospitalization

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.PatientTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.SpecialtyTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.PatientTransferDateTime >= a.SGLT2FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.SpecialtyTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_AllHospitalization
select * from Dflt.SGLT2_AllHospitalization

/* All hospitalization after DPP4 initiation */

select distinct a.*, b.DischargeDateTime, c.ICD9Code
/*ICD9 Codes*/

into Dflt.DPP4_AllHospitalization

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.PatientTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*,b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.SpecialtyTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime,c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.PatientTransferDateTime >= a.DPP4FillTime

union all

select distinct a.*, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.SpecialtyTransferDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where  b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_AllHospitalization
select * from Dflt.DPP4_AllHospitalization
drop table Dflt.DPP4_AllHospitalization

/* Use only Discharge diagnosis table to identify all hospitalization events - SGLT2 */

select distinct a.*, b.AdmitDateTime,c.ICD9Code

into Dflt.SGLT2_AllDDHospi

/*ICD9 Code */

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.SGLT2FillTime

union all
/*ICD10 Code */

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2_AllDDHospi

/* Use only Discharge diagnosis table to identify the All hospitalization events - DPP4*/

select distinct a.*,b.AdmitDateTime, c.ICD9code

into Dflt.DPP4_AllDDHospi

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where b.AdmitDateTime >= a.DPP4FillTime
union all

select distinct a.*, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.DPP4_AllDDHospi

/* Patients that started on DPP4 after SGLT2 initiation */

select distinct a.*, b.FillDateTime, b.FillNumber as DPP4FillNumber

into Dflt.SGLT2DPP4

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime >= a.SGLT2FillTime
union all

select distinct a.*,b.FillDateTime, b.FillNumber as DPP4FillNumber

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.LocalDrugNameWithDose like '%gliptin%' 
and b.FillDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.SGLT2DPP4 where DPP4FillNumber >=3

drop table #SGLT2DPP4

/* Patients that started on DPP4 after SGLT2 initiation */

select distinct a.*, b.FillDateTime, b.FillNumber as SGLT2FillNumber

into #DPP4SGLT2

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%' 
--and b.FillDateTime >= a.DPP4FillTime
union all

select distinct a.*,b.FillDateTime, b.FillNumber as SGLT2FillNumber

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%empagliflozin%' 
or LocalDrugNameWithDose like '%dapagliflozin%' 
or LocalDrugNameWithDose like '%canagliflozin%' 
or LocalDrugNameWithDose like '%ertugliflozin%'
--and b.FillDateTime >= a.DPP4FillTime

select distinct *
into Dflt.DPP4SGLT2
from #DPP4SGLT2 where SGLT2FillNumber >=3
and FillDateTime >= DPP4FillTime

select distinct scrssn from Dflt.DPP4SGLT2

/* GLP1 after initiation of SGLT2 - refill at least 3 */

select distinct a.*, b.FillDateTime, b.FillNumber as GLP1FillNumber

into #SGLT2GLP1

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%' 
--and b.FillDateTime >= a.SGLT2FillTime
union all

select distinct a.*,b.FillDateTime, b.FillNumber as GLP1FillNumber

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.SGLT2FillTime

select distinct * 
into Dflt.SGLT2GLP1
from #SGLT2GLP1 where GLP1FillNumber >=3
and FillDateTime >= SGLT2FillTime

select distinct scrssn from Dflt.SGLT2GLP1
/* GLP1 after initiation of DPP4 - refill at least 3 */

select distinct a.*, b.FillDateTime, b.FillNumber as GLP1FillNumber

into #DPP4GLP1

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.DPP4FillTime
union all

select distinct a.*,b.FillDateTime, b.FillNumber as GLP1FillNumber

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.RxOut_RxOutpatFill_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where LocalDrugNameWithDose like '%semaglutide%' 
or LocalDrugNameWithDose like '%exenatide%' 
or LocalDrugNameWithDose like '%liraglutide%' 
or LocalDrugNameWithDose like '%lixisenatide%' 
or LocalDrugNameWithDose like '%dulaglutide%'
--and b.FillDateTime >= a.DPP4FillTime

select distinct *
into Dflt.DPP4GLP1
from #DPP4GLP1 where GLP1FillNumber >=3
and FillDateTime >= DPP4FillTime

select distinct scrssn from Dflt.DPP4GLP1

/* SGLT2 */
/* BMI 3 months after initiation */

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsAfter

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.SGLT2FillTime) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.SGLT2FillTime) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.SGLT2FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime > dateadd(month, 3, b.SGLT2FillTime) AND 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.SGLT2FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.SGLT2FillTime) and dateadd(day, 1, b.SGLT2FillTime))AND
where a.VitalSignTakenDateTime > dateadd(month, 3, b.SGLT2FillTime) AND
c.VitalType in ( 'HEIGHT')

/* Seperate weight records into a table */
select * 

into #tempweightafter

from #tempDiabetesVitalsAfter where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

/*select distinct scrssn from #tempweightafter

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1after
from #tempweightafter group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinalafter
from #tempweightafter as a with (NOLOCK) left outer join 
#tempweight1after as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinalafter*/

/* Seperate height records into a table */
select *  

into #tempheightafter

from #tempDiabetesVitalsafter where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

/*select distinct scrssn from #tempheight

select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1after
from #tempheightafter group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinalafter
from #tempheightafter as a with (NOLOCK) left outer join 
#tempheight1after as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinalafter*/

/* Combine data from table weight and height to obtain the bmi for individual patient */
drop table  Dflt.Diabetes_HF_SGLT2_BMI_After

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_HF_SGLT2_BMI_After

from #tempheightafter as a with (NOLOCK) inner join
#tempweightafter as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.SGLT2FillTime=b.SGLT2FillTime and

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI_After where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI_After where bmi between 35 and 40

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI_After where bmi > 40

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_BMI_After where bmi < 30 

/* Creatinine */

select *
into Dflt.Diabetes_HF_SGLT2_CreatAfter
from #tempCreatinine
where LabChemCompleteDateTime > SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_CreatAfter

drop table Dflt.Diabetes_HF_SGLT2_CreatAfter

/* Hematocrit */

select *
into Dflt.Diabetes_HF_SGLT2_hematoAfter
from #tempHematocrit
where LabChemCompleteDateTime > SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_hematoAfter

drop table Dflt.Diabetes_HF_SGLT2_hematoAfter


/* Hemoglobin */

select *
into Dflt.Diabetes_HF_SGLT2_hemoAfter
from #tempHemoglobin
where LabChemCompleteDateTime >  SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_hemoAfter

drop table Dflt.Diabetes_HF_SGLT2_hemoAfter

/* Atrial Fibrillation */

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_AFAfter

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.PatientTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.SpecialtyTransferDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.AdmitDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime >= a.SGLT2FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime >= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN, a.SGLT2FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime >= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime >= a.SGLT2FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.SGLT2FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_AFAfter

/* After EF value */

select distinct a.*, b.High_Value, b.ValueDateTime

into Dflt.Diabetes_HF_SGLT2_EFAfter

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime >= a.SGLT2Filltime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_EFAfter

/* Drop out rate */

select  scrssn, max (sglt2filltime) as sglt2filltimemax
into #tempsglt2drop
from #tempSGLT2DateFilter group by scrssn

select distinct scrssn from #tempsglt2drop

select distinct a.sglt2filltimemax, b.*

from #tempsglt2drop as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_Finalafterexclusions as b with (NOLOCK) on a.scrssn= b.scrssn
where a.sglt2filltimemax between dateadd(day,1,b.sglt2filltime) and dateadd (year,2,b.sglt2filltime)

select max(sglt2filltimemax) from #tempsglt2drop

/* DPP4 - After */

/*BMI*/
/* Select height and weight values from vital signs view to calculate bmi */
drop table #tempDiabetesVitals

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

into #tempDiabetesVitalsDPP4

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.DPP4FillTime) AND
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
where a.VitalSignTakenDateTime > dateadd(month, 3, b.DPP4FillTime) AND 
c.VitalType in ( 'WEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
 b.DPP4FillTime, b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime >= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')
union all

select distinct a.PatientSID, a.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric,
b.DPP4FillTime,b.ScrSSN, 
c.VitalType

from Src.Vital_VitalSign_Recent as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.VitalType as c with (NOLOCK) on a.VitalTypeSID=c.VitalTypeSID 
--where (a.VitalSignTakenDateTime between dateadd(month, -12, b.DPP4FillTime) and dateadd(day, 1, b.DPP4FillTime))AND
where a.VitalSignTakenDateTime >= b.DPP4FillTime and 
c.VitalType in ( 'HEIGHT')

select distinct scrssn from #tempDiabetesVitalsDPP4

/* Seperate weight records into a table */
select * 

into #tempweightDPP4After

from #tempDiabetesVitalsDPP4 where vitaltype = 'WEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempweightDPP4After

/*select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempweight1DPP4After
from #tempweightDPP4After group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempweightfinalDPP4After
from #tempweightDPP4After as a with (NOLOCK) left outer join 
#tempweight1DPP4After as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempweightfinalDPP4After*/

/* Seperate height records into a table */
select *  

into #tempheightDPP4After

from #tempDiabetesVitalsDPP4 where vitaltype = 'HEIGHT' and VitalResultNumeric != '0'

select distinct scrssn from #tempheightDPP4After

/*select scrssn, max (VitalSignTakenDateTime) as VitalSignTakenDateTime
into #tempheight1DPP4After
from #tempheightDPP4After group by scrssn

select distinct a.patientsid, b.scrssn, b.VitalSignTakenDateTime, a.VitalResult, a.VitalResultNumeric
into #tempheightfinalDPP4After
from #tempheightDPP4After as a with (NOLOCK) left outer join 
#tempheight1DPP4After as b with (NOLOCK) on a.scrssn= b.scrssn and a.VitalSignTakenDateTime= b.VitalSignTakenDateTime

select distinct scrssn from #tempheightfinalDPP4After*/

/* Combine data from table weight and height to obtain the bmi for individual patient */

select distinct a.patientsid, a.ScrSSN, cast(a.VitalSignTakenDateTime as date) as HeightTime, a.VitalResultNumeric as heightresult, 
cast(b.VitalSignTakenDateTime as date) as WeightTime,b.VitalResultNumeric as weightresult, ((b.VitalResultNumeric*703)/(a.VitalResultNumeric*a.VitalResultNumeric)) as bmi

into Dflt.Diabetes_HF_DPP4_BMI_After

from #tempheightDPP4After as a with (NOLOCK) inner join
#tempweightDPP4After as b with (NOLOCK) on a.ScrSSN = b.ScrSSN
where a.VitalSignTakenDateTime=b.VitalSignTakenDateTime --a.DPP4FillTime=b.DPP4FillTime and

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI_After where bmi between 30 and 35

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI_After where bmi between 35 and 40

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI_After where bmi > 40

select distinct scrssn from Dflt.Diabetes_HF_DPP4_BMI_After where bmi < 30 

/* Creatinine */

select *
into Dflt.Diabetes_HF_DPP4_CreatAfter
from #tempCreatinineDPP4
where LabChemCompleteDateTime > DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_CreatAfter

/* Hematocrit */

select *
into Dflt.Diabetes_HF_DPP4_HematocritAfter
from #temphematocritDPP4
where LabChemCompleteDateTime >  DPP4FillTime 

select distinct scrssn from Dflt.Diabetes_HF_DPP4_HematocritAfter

drop table Dflt.Diabetes_HF_DPP4_HematocritAfter

/* Hemoglobin */
select *
into Dflt.Diabetes_HF_DPP4_HemoglobinAfter
from #tempHemoglobinDPP4
where LabChemCompleteDateTime >  DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_HemoglobinAfter

drop table Dflt.Diabetes_HF_DPP4_HemoglobinAfter

/* Atrial Fibrillation */

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime as comorbidity_Dischargedatetime, c.ICD9Code as comorbidity_ICD9Code
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_AFAfter

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.EventDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.PatientTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.PatientTransferDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.SpecialtyTransferDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, c.ICD9Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.ICD9SID=c.ICD9SID 
where c.ICD9Code in ('427.31')
					and b.AdmitDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.DischargeDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatientFeeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.DischargeDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_VDiagnosis_Recent as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime >= a.DPP4FillTime
union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.EventDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Outpat_WorkloadVDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.EventDateTime >= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN, a.DPP4FillTime, b.PatientTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_PatientTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.PatientTransferDateTime >= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.SpecialtyTransferDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_SpecialtyTransferDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.SpecialtyTransferDateTime >= a.DPP4FillTime

union all

select distinct a.PatientSID,a.ScrSSN,  a.DPP4FillTime, b.AdmitDateTime, c.ICD10Code

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_InpatDischargeDiagnosis as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.ICD10SID=c.ICD10SID 
where ICD10Code like 'I48.%'
and b.AdmitDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_AFAfter

/* After EF value */

select distinct a.*, b.High_Value, b.ValueDateTime

into Dflt.Diabetes_HF_DPP4_EFAfter

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join 
Src.VINCI_TIU_NLP_LVEF as b with (NOLOCK) on a.PatientSID= b.PatientSID 
where b.ValueDateTime >= a.DPP4Filltime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_EFAfter

/* Race SGLT2 */

select b.*, cast(a.race as varchar) as race
into #temprace
from src.VASQIP_nso_noncardiac as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.scrssn= b.scrssn

select a.*,  b.Race
into #temprace1
from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select  *

into #temprace2
from #temprace
union all

select  *
from #temprace1

select distinct scrssn from #temprace2

/* Race DPP4 */

select b.*, cast(a.race as varchar) as race
into #tempraceDPP4
from src.VASQIP_nso_noncardiac as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.scrssn= b.scrssn

select a.*,  b.Race
into #temprace1DPP4
from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.PatSub_PatientRace as b with (NOLOCK) on a.patientsid= b.patientsid

select  *

into #temprace2DPP4
from #tempraceDPP4
union all

select  *
from #temprace1DPP4

select distinct scrssn from #temprace2DPP4 

select distinct a.*, b.dpp4filltime
from Dflt.Diabetes_HF_DPP4_BMI as a with (NOLOCK) inner join
Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as b with (NOLOCK) on a.scrssn= b.scrssn

select distinct a.*, b.sglt2filltime
from Dflt.Diabetes_HF_SGLT2_BMI as a with (NOLOCK) inner join
Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as b with (NOLOCK) on a.scrssn= b.scrssn
select distinct scrssn from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions

/* Additional extraction for analyses */
/* SGLT2 Pneumonia */

select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code in (
            '480.0', '480.1', '480.2', '480.3', '480.8', '480.9',
            '481.',
            '482.0', '482.1', '482.2', '482.3', '482.4', '482.41', '482.42', '482.8', '482.9',
            '483.0', '483.1', '483.8',
            '484.1', '484.3', '484.5', '484.6', '484.7', '484.8',
            '485.', '486.',
            '487.0',
            '488.01', '488.11')
select distinct ICD9Code from CDWWork.Dim.ICD9 where ICD9Code like '481.%'
        

select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code in (
            'J09.X1', 'J10.00', 'J11.00',
            'J12.0', 'J12.1', 'J12.2', 'J12.3', 'J12.81', 'J12.82','J12.89','J12.9',
            'J13.', 'J14.',
            'J15.0', 'J15.1', 'J15.20', 'J15.211','J15.212','J15.29','J15.3', 'J15.4', 'J15.5', 'J15.6', 'J15.7', 'J15.8', 'J15.9',
            'J16.0', 'J16.8',
            'J17.',
            'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9',
            'J69.0', 'J69.1', 'J69.8')
        
select distinct ICD10Code from CDWWork.Dim.ICD10 where ICD10Code like 'J17.%'


select distinct a.*, b.DischargeDateTime,c.ICD9Code,b.AdmitDiagnosis
/*ICD9 Codes*/

into Dflt.Diabetes_HF_SGLT2_PneumoniaNew
--into Dflt.Diabetes_HF_SGLT2_Pneumonia

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('480.0', '480.1', '480.2', '480.3', '480.8', '480.9',
            '481.',
            '482.0', '482.1', '482.2', '482.3', '482.4', '482.41', '482.42', '482.8', '482.9',
            '483.0', '483.1', '483.8',
            '484.1', '484.3', '484.5', '484.6', '484.7', '484.8',
            '485.', '486.',
            '487.0',
            '488.01', '488.11')
					and b.DischargeDateTime >= a.SGLT2FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code, b.AdmitDiagnosis

from Dflt.Diabetes_HF_SGLT2_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('J09.X1', 'J10.00', 'J11.00',
            'J12.0', 'J12.1', 'J12.2', 'J12.3', 'J12.81', 'J12.82','J12.89','J12.9',
            'J13.', 'J14.',
            'J15.0', 'J15.1', 'J15.20', 'J15.211','J15.212','J15.29','J15.3', 'J15.4', 'J15.5', 'J15.6', 'J15.7', 'J15.8', 'J15.9',
            'J16.0', 'J16.8',
            'J17.',
            'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9',
            'J69.0', 'J69.1', 'J69.8')
and b.DischargeDateTime >= a.SGLT2FillTime

select distinct scrssn from Dflt.Diabetes_HF_SGLT2_Pneumonia --45
select distinct scrssn from Dflt.Diabetes_HF_SGLT2_PneumoniaNew --53
drop table Dflt.Diabetes_HFpEF_SGLT2_Pneumonia

/* DPP4/SU Pneumonia */

select distinct a.*, b.DischargeDateTime,c.ICD9Code,b.AdmitDiagnosis
/*ICD9 Codes*/

into Dflt.Diabetes_HF_DPP4_PneumoniaNew
--into Dflt.Diabetes_HF_DPP4_Pneumonia

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD9 as c with (NOLOCK) on b.PrincipalDiagnosisICD9SID=c.ICD9SID 
where c.ICD9Code in ('480.0', '480.1', '480.2', '480.3', '480.8', '480.9',
            '481.',
            '482.0', '482.1', '482.2', '482.3', '482.4', '482.41', '482.42', '482.8', '482.9',
            '483.0', '483.1', '483.8',
            '484.1', '484.3', '484.5', '484.6', '484.7', '484.8',
            '485.', '486.',
            '487.0',
            '488.01', '488.11')
					and b.DischargeDateTime >= a.DPP4FillTime
union all

/*ICD10 Codes*/
select distinct a.*, b.DischargeDateTime, c.ICD10Code, b.AdmitDiagnosis

from Dflt.Diabetes_HF_DPP4_FinalAfterExclusions as a with (NOLOCK) inner join
Src.Inpat_Inpatient as b with (NOLOCK) on a.PatientSID= b.PatientSID inner join 
CDWWork.Dim.ICD10 as c with (NOLOCK) on b.PrincipalDiagnosisICD10SID=c.ICD10SID 
where ICD10Code in ('J09.X1', 'J10.00', 'J11.00',
            'J12.0', 'J12.1', 'J12.2', 'J12.3', 'J12.81', 'J12.82','J12.89','J12.9',
            'J13.', 'J14.',
            'J15.0', 'J15.1', 'J15.20', 'J15.211','J15.212','J15.29','J15.3', 'J15.4', 'J15.5', 'J15.6', 'J15.7', 'J15.8', 'J15.9',
            'J16.0', 'J16.8',
            'J17.',
            'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9',
            'J69.0', 'J69.1', 'J69.8')
and b.DischargeDateTime >= a.DPP4FillTime

select distinct scrssn from Dflt.Diabetes_HF_DPP4_Pneumonia --79
select distinct scrssn from Dflt.Diabetes_HF_DPP4_PneumoniaNew --83

