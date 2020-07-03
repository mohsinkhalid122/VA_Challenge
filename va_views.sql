DATABASE ADKCSV2_HEALTHCARE;

replace view  ADKCSV2_Healthcare.va_mortality as

SELECT patient, CASE WHEN covid=1 and mortality=1 then 0 else 1 END as Mortality_Label FROM
(
SELECT id as patient,
CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
case when deathdate is not null then 1 else 0 end as Mortality
FROM ADKCSV2_Healthcare.va_patients pat
left join 
(select distinct patient as covid_patient from va_conditions_sample where code= 840539006
) cond on cond.covid_patient=pat.id
) df;


CREATE VIEW va_mortality_test AS
SELECT patient, CASE WHEN covid=1 and mortality=1 then 0 else 1 END as Mortality_Label FROM
(
SELECT id as patient,
CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
case when deathdate is not null then 1 else 0 end as Mortality
FROM ADKCSV2_Healthcare.va_patients_test pat
left join 
(select distinct patient as covid_patient from ADKCSV2_Healthcare.va_conditions_test where code= 840539006
) cond on cond.covid_patient=pat.id
) df;




CREATE VIEW va_covid_status as 
SELECT id as patient,

CASE WHEN tst.patient IS NULL or tst.detected = 0 then 0 else 1 end as test_result

FROM ADKCSV2_Healthcare.va_patients pat


left join

(
select distinct patient, "value" as "value" , 
CASE WHEN "value" like 'D%' or "value" like 'd%' then 1 else 0 end as detected
from va_observations where code='94531-1'
) tst on tst.patient = pat.id
;


CREATE VIEW va_covid_status_test as 
SELECT id as patient,

CASE WHEN tst.patient IS NULL or tst.detected = 0 then 0 else 1 end as test_result

FROM ADKCSV2_Healthcare.va_patients_test pat


left join

(
select distinct patient, "value" as "value" , 
CASE WHEN "value" like 'D%' or "value" like 'd%' then 1 else 0 end as detected
from va_observation_test where code='94531-1'
) tst on tst.patient = pat.id
;

DATABASE ADKCSV2_HEALTHCARE;

CREATE VIEW va_vent_status AS
SELECT patient, CASE WHEN covid=1 and vent=1 then 1 else 0 END as Vent_Status FROM

(

SELECT id as patient,

CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
CASE WHEN vent.vent_patient IS NULL then 0 else 1 end as vent


FROM ADKCSV2_Healthcare.va_patients pat

left join 

(select distinct patient as covid_patient from va_conditions_sample where code= 840539006

) cond on cond.covid_patient=pat.id

left join

(
select distinct patient as vent_patient
from va_procedures
where code='26763009'
) vent on vent.vent_patient=pat.id

) df;


CREATE VIEW va_vent_status_test AS
SELECT patient, CASE WHEN covid=1 and vent=1 then 1 else 0 END as Vent_Status FROM

(

SELECT id as patient,

CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
CASE WHEN vent.vent_patient IS NULL then 0 else 1 end as vent


FROM ADKCSV2_Healthcare.va_patients_test pat

left join 

(select distinct patient as covid_patient from va_conditions_test where code= 840539006

) cond on cond.covid_patient=pat.id

left join

(
select distinct patient as vent_patient
from va_procedures_test
where code='26763009'
) vent on vent.vent_patient=pat.id

) df;

 ------------------------------------------------------

 DATABASE ADKCSV2_HEALTHCARE;

CREATE VIEW va_hospitalization AS
SELECT patient, 
CASE WHEN covid=1 then dayz else 0 END as Days_Hospitalized

FROM
(

SELECT id as patient,

CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
CASE WHEN hosp.n_days IS NULL then 0 else EXTRACT( DAY from n_days) + EXTRACT( HOUR from n_days)/24.0  END as dayz

FROM ADKCSV2_Healthcare.va_patients pat

left join 

(select distinct patient as covid_patient from va_conditions_sample where code= 840539006

) cond on cond.covid_patient=pat.id

left join

(
SELECT patient, CAST("STOP" AS TIMESTAMP(0) WITH TIME ZONE) - CAST("START" AS TIMESTAMP(0) WITH TIME ZONE) DAY(4) to SECOND(4) as n_days
from va_encounters where code='1505002'

) hosp on hosp.patient=pat.id

) df ;


DATABASE ADKCSV2_HEALTHCARE;

CREATE VIEW va_hospitalization_test AS
SELECT patient, 
CASE WHEN covid=1 then dayz else 0 END as Days_Hospitalized

FROM
(

SELECT id as patient,

CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
CASE WHEN hosp.n_days IS NULL then 0 else EXTRACT( DAY from n_days) + EXTRACT( HOUR from n_days)/24.0  END as dayz

FROM ADKCSV2_Healthcare.va_patients_test pat

left join 

(select distinct patient as covid_patient from va_conditions_test where code= 840539006

) cond on cond.covid_patient=pat.id

left join

(
SELECT patient, CAST("STOP" AS TIMESTAMP(0) WITH TIME ZONE) - CAST("START" AS TIMESTAMP(0) WITH TIME ZONE) DAY(4) to SECOND(4) as n_days
from va_encounters_test where code='1505002'

) hosp on hosp.patient=pat.id

) df ;

------------------------------------------------------------------------------------------------------


DATABASE ADKCSV2_HEALTHCARE;

CREATE VIEW va_icuadmissions AS
SELECT patient, 
CASE WHEN covid=1 then dayz else 0 END as Days_In_ICU

FROM
(

SELECT id as patient,

CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
CASE WHEN hosp.n_days IS NULL then 0 else EXTRACT( DAY from n_days) + EXTRACT( HOUR from n_days)/24.0  END as dayz

FROM ADKCSV2_Healthcare.va_patients pat

left join 

(select distinct patient as covid_patient from va_conditions_sample where code= 840539006

) cond on cond.covid_patient=pat.id

left join

(
SELECT patient, CAST("STOP" AS TIMESTAMP(0) WITH TIME ZONE) - CAST("START" AS TIMESTAMP(0) WITH TIME ZONE) DAY(4) to SECOND(4) as n_days
from va_encounters where code='305351004'

) hosp on hosp.patient=pat.id

) df ;


DATABASE ADKCSV2_HEALTHCARE;

CREATE VIEW va_icuadmissions_test AS
SELECT patient, 
CASE WHEN covid=1 then dayz else 0 END as Days_In_ICU

FROM
(

SELECT id as patient,

CASE WHEN cond.covid_patient IS NULL then 0 else 1 end as covid,
CASE WHEN hosp.n_days IS NULL then 0 else EXTRACT( DAY from n_days) + EXTRACT( HOUR from n_days)/24.0  END as dayz

FROM ADKCSV2_Healthcare.va_patients_test pat

left join 

(select distinct patient as covid_patient from va_conditions_test where code= 840539006

) cond on cond.covid_patient=pat.id

left join

(
SELECT patient, CAST("STOP" AS TIMESTAMP(0) WITH TIME ZONE) - CAST("START" AS TIMESTAMP(0) WITH TIME ZONE) DAY(4) to SECOND(4) as n_days
from va_encounters_test where code='305351004'

) hosp on hosp.patient=pat.id

) df ;

----------------------------------------------------------- MODELLING ADS ---------------------------------------

CREATE TABLE va_mortality_model AS (
select mo.patient, mortality_label, COALESCE(cs_score,0) as cs_score
from
va_mortality mo
LEFT JOIN
(
SELECT patient, max(cs_score) as cs_score
from va_ads_with_labels_final
group by 1 
) ds on ds.patient=mo.patient
) WITH DATA PRIMARY INDEX ("patient");


CREATE TABLE va_covid_model AS (
select mo.patient, test_result, COALESCE(cs_score,0) as cs_score
from
va_covid_status mo
LEFT JOIN
(
SELECT patient, max(cs_score) as cs_score
from va_ads_with_labels_final
group by 1 
) ds on ds.patient=mo.patient
) WITH DATA PRIMARY INDEX ("patient");


CREATE TABLE va_ventstatus_model AS (
select mo.patient, vent_status, COALESCE(cs_score,0) as cs_score
from
va_vent_status mo
LEFT JOIN
(
SELECT patient, max(cs_score) as cs_score
from va_ads_with_labels_final
group by 1 
) ds on ds.patient=mo.patient
) WITH DATA PRIMARY INDEX ("patient");


CREATE TABLE va_hospitalizations_model AS (
select mo.patient, Days_Hospitalized, COALESCE(cs_score,0) as cs_score
from
va_hospitalization mo
LEFT JOIN
(
SELECT patient, max(cs_score) as cs_score
from va_ads_with_labels_final
group by 1 
) ds on ds.patient=mo.patient
) WITH DATA PRIMARY INDEX ("patient");


CREATE TABLE va_icu_model AS (
select mo.patient, Days_In_ICU, COALESCE(cs_score,0) as cs_score
from
va_icuadmissions mo
LEFT JOIN
(
SELECT patient, max(cs_score) as cs_score
from va_ads_with_labels_final
group by 1 
) ds on ds.patient=mo.patient
) WITH DATA PRIMARY INDEX ("patient");


 ----------------------------------------------------------------------------------------------------  FINAL VIEWS FOR CSV 








