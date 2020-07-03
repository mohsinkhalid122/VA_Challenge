DATABASE ADKCSV2_HEALTHCARE;
CREATE TABLE va_selected_observations as (

sel "date", patient, encounter, code, description, 

case 
when "value" ='9 by Automated count' then '9'
when "value" ='9 by Autoeated count' then '9'
when "value" ='9 Pressure' then '9'
else "value" end as "value",

units, 

CASE  
WHEN CODE IN ('6690-2') then 'WBC'
WHEN CODE IN ('718-7') then 'Hemoglobin'
WHEN CODE IN ('777-3') then 'Platelet'
WHEN CODE IN ('32207-3') then 'Platelet_Width'
WHEN CODE IN ('32623-1') then 'Platelet_Volume'
WHEN CODE IN ('1975-2') then 'Bilirubin'
WHEN CODE IN ('38483-4','2160-0') then 'Creatinine'
WHEN CODE IN ('2276-4') then 'Ferritin'
WHEN CODE IN ('14804-9') then 'LactateDehydrogenase'
WHEN CODE IN ('6301-6') then 'INR'
WHEN CODE IN ('8867-4') then 'HeartRate'
WHEN CODE IN ('8310-5') then 'Temperature'
WHEN CODE IN ('1988-5') then 'CRP'
WHEN CODE IN ('2708-6') then 'OxygenSaturation' -- spo2 and sa02
WHEN CODE IN ('48065-7') then 'D-Dimer'
WHEN CODE IN ('8480-6') then 'SysBP'
WHEN CODE IN ('8462-4') then 'DiasBP'
WHEN CODE IN ('9279-1') then 'RespRate'
WHEN CODE IN ('33914-3') then 'GFR'
--Lactic Acid missing
--PTT missing
END AS CS_LABEL

from va_observations obs 
WHERE CODE IN (
'6690-2',
'718-7'
'32207-3', '32623-1','777-3',
'1975-2',
'38483-4','2160-0',
'2276-4',
'14804-9',
'6301-6',
'8867-4',
'8310-5',
'1988-5',
'2708-6',
'48065-7',
'8480-6',
'8462-4',
'9279-1'
'33914-3')

) WITH DATA PRIMARY INDEX ("date","patient")
;



CREATE TABLE cs_scores as (
select  CAST ("date" as DATE FORMAT 'YYYY-MM-DD') as "date", patient, encounter, sum(flag) as cs_score from
(
select
"date", patient, encounter, code, description, CAST("value" AS FLOAT) as "value", 
 units,min_norm, max_norm, units_norm,
CASE WHEN "value" between min_norm and max_norm then 0 else 1 END  as flag
from  va_selected_observations obs LEFT JOIN cs_norms norms on norms.cs_label= obs.cs_label
) as df
group by 1,2,3
) WITH DATA PRIMARY INDEX ("date","patient");




-------------------------------------------------------------------------------------------------------------------------------------------------------------------


DATABASE ADKCSV2_HEALTHCARE;
DROP TABLE va_ads1;
CREATE TABLE va_ads1 as (
sel "date", patient, encounter, code, description,  --from va_obs_sample where description like '%inr%';
case 
when "value" ='9 by Automated count' then 9
when "value" ='9 by Autoeated count' then 9
when "value" ='9 Pressure' then 9
when "value"='Urine glucose test = ++ (finding)' then 1
else CAST("value" as FLOAT) end as "value" ,
units,
CASE  
WHEN CODE IN ('6690-2') then 'WBC'
WHEN CODE IN ('718-7') then 'Hemoglobin'
WHEN CODE IN ('32207-3', '32623-1') then 'Platelet_1'
WHEN CODE IN ('777-3') then 'Platelet_2'
WHEN CODE IN ('1975-2') then 'Bilirubin'
WHEN CODE IN ('38483-4','2160-0') then 'Creatinine'
WHEN CODE IN ('2276-4') then 'Ferritin'
WHEN CODE IN ('14804-9') then 'Lactate'
WHEN CODE IN ('6301-6') then 'INR'
WHEN CODE IN ('8867-4') then 'HeartRate'
WHEN CODE IN ('8310-5') then 'Temperature'
WHEN CODE IN ('1988-5') then 'CRP'
WHEN CODE IN ('2708-6','2703-7') then 'OxygenSaturation' -- spo2 and sa02
WHEN CODE IN ('48065-7') then 'Fibrinogen/D-Dimer' --?
WHEN CODE IN ('8480-6') then 'SysBP'
WHEN CODE IN ('8462-4') then 'DiasBP'
WHEN CODE IN ('9279-1') then 'RespRate'
WHEN CODE IN ('2339-0','2345-7','5792-7') then 'Glucose_1'
WHEN CODE IN ('25428-4') then 'Glucose_2'
WHEN CODE IN ('1751-7') then 'Albumin_1'
WHEN CODE IN ('14959-1') then 'Albumin_2'
WHEN CODE IN ('1960-4') then 'Bicarbonate'
WHEN CODE IN ('2075-0') then 'Chloride'
WHEN CODE IN ('20570-8','4544-3') then 'Hematocrit'
WHEN CODE IN ('6298-4','2823-3') then 'Potassium'
WHEN CODE IN ('2951-2','2947-0') then 'Sodium'
WHEN CODE IN ('5902-2') then 'PT'
WHEN CODE IN ('49765-1','17861-6') then 'Calcium'
WHEN CODE IN ('19994-3') then 'O2Flow'
WHEN CODE IN ('20565-8','2028-9') then 'CO2_1'
WHEN CODE IN ('2019-8') then 'CO2_2'
WHEN CODE IN ('2744-1','5803-2') then 'PH_1'
WHEN CODE IN ('6768-6') then 'PH_2'
WHEN CODE IN ('33037-3') then 'AnionGap'
WHEN CODE IN ('6299-2','3094-0') then 'BUN'
WHEN CODE IN ('33914-3') then 'GFR'

--Lactic Acid
--PTT
--PO2
 --REQUIREDO2
--TIDALVOLUME
--VENTILATIONRATE
--VENTILATOR
--AADO2
--PEEP
--BANDS
--BASEEXCESS
--CARBOXYHEMOGLOBIN
--METHEMOGLOBIN
END AS CS_LABEL

from va_observations obs 
WHERE CODE IN (
'6690-2',
'718-7', 
'32207-3', '32623-1','777-3',
'1975-2',
'38483-4','2160-0',
'2276-4',
'14804-9',
'6301-6',
'8867-4',
'8310-5',
'1988-5',
'2708-6',
'48065-7',
'8480-6',
'8462-4',
'9279-1'
'2339-0','2345-7','5792-7','25428-4',
'1751-7','14959-1',		
'1960-4',			
'2075-0',		
'20570-8','4544-3',		
'6298-4','2823-3',		
'2951-2','2947-0'		
'5902-2',		
'49765-1','17861-6',		
'19994-3',			
'2019-8','20565-8','2028-9',	
'2744-1','5803-2','6768-6',	
'33037-3',			
'6299-2','3094-0',
'33914-3'	
)

) WITH DATA PRIMARY INDEX ("date","patient")
;


DATABASE ADKCSV2_HEALTHCARE;
DROP TABLE va_ads2;
CREATE TABLE va_ads2 AS 
(
SELECT CAST("Date" as Date FORMAT 'YYYY-MM-DD') as "Date", Patient, Encounter,
MIN(CASE WHEN cs_label = 'WBC' THEN "VALUE" ELSE 0 END ) AS WBC_min,
MAX(CASE WHEN cs_label = 'WBC' THEN "VALUE" ELSE 0 END ) AS WBC_max,
MIN(CASE WHEN cs_label = 'Hemoglobin' THEN "VALUE" ELSE 0 END ) AS Hemoglobin_min,
MAX(CASE WHEN cs_label = 'Hemoglobin' THEN "VALUE" ELSE 0 END ) AS Hemoglobin_max,
MIN(CASE WHEN cs_label = 'Platelet_1' THEN "VALUE" ELSE 0 END ) AS Platelet_1_min,
MAX(CASE WHEN cs_label = 'Platelet_1' THEN "VALUE" ELSE 0 END ) AS Platelet_1_max,
MIN(CASE WHEN cs_label = 'Platelet_2' THEN "VALUE" ELSE 0 END ) AS Platelet_2_min,
MAX(CASE WHEN cs_label = 'Platelet_2' THEN "VALUE" ELSE 0 END ) AS Platelet_2_max,
MIN(CASE WHEN cs_label = 'Bilirubin' THEN "VALUE" ELSE 0 END ) AS Bilirubin_min,
MAX(CASE WHEN cs_label = 'Bilirubin' THEN "VALUE" ELSE 0 END ) AS Bilirubin_max,
MIN(CASE WHEN cs_label = 'Creatinine' THEN "VALUE" ELSE 0 END ) AS Creatinine_min,
MAX(CASE WHEN cs_label = 'Creatinine' THEN "VALUE" ELSE 0 END ) AS Creatinine_max,
MIN(CASE WHEN cs_label = 'Ferritin' THEN "VALUE" ELSE 0 END ) AS Ferritin_min,
MAX(CASE WHEN cs_label = 'Ferritin' THEN "VALUE" ELSE 0 END ) AS Ferritin_max,
MIN(CASE WHEN cs_label = 'Lactate' THEN "VALUE" ELSE 0 END ) AS Lactate_min,
MAX(CASE WHEN cs_label = 'Lactate' THEN "VALUE" ELSE 0 END ) AS Lactate_max,
MIN(CASE WHEN cs_label = 'INR' THEN "VALUE" ELSE 0 END ) AS INR_min,
MAX(CASE WHEN cs_label = 'INR' THEN "VALUE" ELSE 0 END ) AS INR_max,
MIN(CASE WHEN cs_label = 'HeartRate' THEN "VALUE" ELSE 0 END ) AS HeartRate_min,
MAX(CASE WHEN cs_label = 'HeartRate' THEN "VALUE" ELSE 0 END ) AS HeartRate_max,
MIN(CASE WHEN cs_label = 'Temperature' THEN "VALUE" ELSE 0 END ) AS Temperature_min,
MAX(CASE WHEN cs_label = 'Temperature' THEN "VALUE" ELSE 0 END ) AS Temperature_max,
MIN(CASE WHEN cs_label = 'CRP' THEN "VALUE" ELSE 0 END ) AS CRP_min,
MAX(CASE WHEN cs_label = 'CRP' THEN "VALUE" ELSE 0 END ) AS CRP_max,
MIN(CASE WHEN cs_label = 'OxygenSaturation'  THEN "VALUE" ELSE 0 END ) AS OxygenSaturation_min,
MAX(CASE WHEN cs_label = 'OxygenSaturation' THEN "VALUE" ELSE 0 END ) AS OxygenSaturation_max,
MIN(CASE WHEN cs_label = 'Fibrin_D-Dimer'  THEN "VALUE" ELSE 0 END ) AS Fibrin_DDimer_min,
MAX(CASE WHEN cs_label = 'Fibrin_D-Dimer' THEN "VALUE" ELSE 0 END ) AS Fibrin_DDimer_max,
MIN(CASE WHEN cs_label = 'SysBP' THEN "VALUE" ELSE 0 END ) AS SysBP_min,
MAX(CASE WHEN cs_label = 'SysBP' THEN "VALUE" ELSE 0 END ) AS SysBP_max,
MIN(CASE WHEN cs_label = 'DiasBP' THEN "VALUE" ELSE 0 END ) AS DiasBP_min,
MAX(CASE WHEN cs_label = 'DiasBP' THEN "VALUE" ELSE 0 END ) AS DiasBP_max,
MIN(CASE WHEN cs_label = 'RespRate' THEN "VALUE" ELSE 0 END ) AS RespRate_min,
MAX(CASE WHEN cs_label = 'RespRate' THEN "VALUE" ELSE 0 END ) AS RespRate_max,
MIN(CASE WHEN cs_label = 'Glucose_1' THEN "VALUE" ELSE 0 END ) AS Glucose_1_min,
MAX(CASE WHEN cs_label = 'Glucose_1' THEN "VALUE" ELSE 0 END ) AS Glucose_1_max,
MIN(CASE WHEN cs_label = 'Glucose_2' THEN "VALUE" ELSE 0 END ) AS Glucose_2_min,
MAX(CASE WHEN cs_label = 'Glucose_2' THEN "VALUE" ELSE 0 END ) AS Glucose_2_max,
MIN(CASE WHEN cs_label = 'Albumin_1' THEN "VALUE" ELSE 0 END ) AS Albumin_1_min,
MAX(CASE WHEN cs_label = 'Albumin_1' THEN "VALUE" ELSE 0 END ) AS Albumin_1_max,
MIN(CASE WHEN cs_label = 'Albumin_2' THEN "VALUE" ELSE 0 END ) AS Albumin_2_min,
MAX(CASE WHEN cs_label = 'Albumin_2' THEN "VALUE" ELSE 0 END ) AS Albumin_2_max,
MIN(CASE WHEN cs_label = 'Bicarbonate' THEN "VALUE" ELSE 0 END ) AS Bicarbonate_min,
MAX(CASE WHEN cs_label = 'Bicarbonate' THEN "VALUE" ELSE 0 END ) AS Bicarbonate_max,
MIN(CASE WHEN cs_label = 'Chloride' THEN "VALUE" ELSE 0 END ) AS Chloride_min,
MAX(CASE WHEN cs_label = 'Chloride' THEN "VALUE" ELSE 0 END ) AS Chloride_max,
MIN(CASE WHEN cs_label = 'Hematocrit' THEN "VALUE" ELSE 0 END ) AS Hematocrit_min,
MAX(CASE WHEN cs_label = 'Hematocrit' THEN "VALUE" ELSE 0 END ) AS Hematocrit_max,
MIN(CASE WHEN cs_label = 'Potassium' THEN "VALUE" ELSE 0 END ) AS Potassium_min,
MAX(CASE WHEN cs_label = 'Potassium' THEN "VALUE" ELSE 0 END ) AS Potassium_max,
MIN(CASE WHEN cs_label = 'Sodium' THEN "VALUE" ELSE 0 END ) AS Sodium_min,
MAX(CASE WHEN cs_label = 'Sodium' THEN "VALUE" ELSE 0 END ) AS Sodium_max,
MIN(CASE WHEN cs_label = 'PT' THEN "VALUE" ELSE 0 END ) AS PT_min,
MAX(CASE WHEN cs_label = 'PT' THEN "VALUE" ELSE 0 END ) AS PT_max,
MIN(CASE WHEN cs_label = 'Calcium' THEN "VALUE" ELSE 0 END ) AS Calcium_min,
MAX(CASE WHEN cs_label = 'Calcium' THEN "VALUE" ELSE 0 END ) AS Calcium_max,
MIN(CASE WHEN cs_label = 'O2Flow' THEN "VALUE" ELSE 0 END ) AS O2Flow_min,
MAX(CASE WHEN cs_label = 'O2Flow' THEN "VALUE" ELSE 0 END ) AS O2Flow_max,
MIN(CASE WHEN cs_label = 'CO2_1' THEN "VALUE" ELSE 0 END ) AS CO2_1_min,
MAX(CASE WHEN cs_label = 'CO2_1' THEN "VALUE" ELSE 0 END ) AS CO2_1_max,
MIN(CASE WHEN cs_label = 'CO2_2' THEN "VALUE" ELSE 0 END ) AS CO2_2_min,
MAX(CASE WHEN cs_label = 'CO2_2' THEN "VALUE" ELSE 0 END ) AS CO2_2_max,
MIN(CASE WHEN cs_label = 'PH_1' THEN "VALUE" ELSE 0 END ) AS PH_1_min,
MAX(CASE WHEN cs_label = 'PH_1' THEN "VALUE" ELSE 0 END ) AS PH_1_max,
MIN(CASE WHEN cs_label = 'PH_2' THEN "VALUE" ELSE 0 END ) AS PH_2_min,
MAX(CASE WHEN cs_label = 'PH_2' THEN "VALUE" ELSE 0 END ) AS PH_2_max,
MIN(CASE WHEN cs_label = 'AnionGap' THEN "VALUE" ELSE 0 END ) AS AnionGap_min,
MAX(CASE WHEN cs_label = 'AnionGap' THEN "VALUE" ELSE 0 END ) AS AnionGap_max,
MIN(CASE WHEN cs_label = 'BUN' THEN "VALUE" ELSE 0 END ) AS BUN_min,
MAX(CASE WHEN cs_label = 'BUN' THEN "VALUE" ELSE 0 END ) AS BUN_max,
MIN(CASE WHEN cs_label = 'GFR' THEN "VALUE" ELSE 0 END ) AS GF_minR,
MAX(CASE WHEN cs_label = 'GFR' THEN "VALUE" ELSE 0 END ) AS GF_maxR

FROM ( SELECT "date", patient, encounter, code, description,units,zeroifnull("value") as "value", cs_label FROM va_ads1) as va_ads1
GROUP BY 1,2,3
 )WITH DATA PRIMARY INDEX ("date","patient");

DATABASE ADKCSV2_HEALTHCARE;
DROP TABLE va_ads_with_labels;
CREATE TABLE va_ads_with_labels AS (
SELECT t1."date", t1.patient, t1.encounter, lab.cs_score,
t1.WBC_min, t2.WBC_min as WBC_min_1, 
t1.WBC_max, t2.WBC_max as WBC_max_1, 
t1.Hemoglobin_min, t2.Hemoglobin_min as Hemoglobin_min_1, 
t1.Hemoglobin_max, t2.Hemoglobin_max as Hemoglobin_max_1, 
t1.Platelet_1_min, t2.Platelet_1_min as Platelet_1_min_1, 
t1.Platelet_1_max, t2.Platelet_1_max as Platelet_1_max_1, 
t1.Platelet_2_min, t2.Platelet_2_min as Platelet_2_min_1, 
t1.Platelet_2_max, t2.Platelet_2_max as Platelet_2_max_1, 
t1.Bilirubin_min, t2.Bilirubin_min as Bilirubin_min_1, 
t1.Bilirubin_max, t2.Bilirubin_max as Bilirubin_max_1, 
t1.Creatinine_min, t2.Creatinine_min as Creatinine_min_1, 
t1.Creatinine_max, t2.Creatinine_max as Creatinine_max_1, 
t1.Ferritin_min, t2.Ferritin_min as Ferritin_min_1, 
t1.Ferritin_max, t2.Ferritin_max as Ferritin_max_1, 
t1.Lactate_min, t2.Lactate_min as Lactate_min_1, 
t1.Lactate_max, t2.Lactate_max as Lactate_max_1, 
t1.INR_min, t2.INR_min as INR_min_1, 
t1.INR_max, t2.INR_max as INR_max_1, 
t1.HeartRate_min, t2.HeartRate_min as HeartRate_min_1, 
t1.HeartRate_max, t2.HeartRate_max as HeartRate_max_1, 
t1.Temperature_min, t2.Temperature_min as Temperature_min_1, 
t1.Temperature_max, t2.Temperature_max as Temperature_max_1, 
t1.CRP_min, t2.CRP_min as CRP_min_1, 
t1.CRP_max, t2.CRP_max as CRP_max_1, 
t1.OxygenSaturation_min, t2.OxygenSaturation_min as OxygenSaturation_min_1, 
t1.OxygenSaturation_max, t2.OxygenSaturation_max as OxygenSaturation_max_1, 
t1.Fibrin_DDimer_min, t2.Fibrin_DDimer_min as Fibrin_DDimer_min_1, 
t1.Fibrin_DDimer_max, t2.Fibrin_DDimer_max as Fibrin_DDimer_max_1, 
t1.SysBP_min, t2.SysBP_min as SysBP_min_1, 
t1.SysBP_max, t2.SysBP_max as SysBP_max_1, 
t1.DiasBP_min, t2.DiasBP_min as DiasBP_min_1, 
t1.DiasBP_max, t2.DiasBP_max as DiasBP_max_1, 
t1.RespRate_min, t2.RespRate_min as RespRate_min_1, 
t1.RespRate_max, t2.RespRate_max as RespRate_max_1, 
t1.Glucose_1_min, t2.Glucose_1_min as Glucose_1_min_1, 
t1.Glucose_1_max, t2.Glucose_1_max as Glucose_1_max_1, 
t1.Glucose_2_min, t2.Glucose_2_min as Glucose_2_min_1, 
t1.Glucose_2_max, t2.Glucose_2_max as Glucose_2_max_1, 
t1.Albumin_1_min, t2.Albumin_1_min as Albumin_1_min_1, 
t1.Albumin_1_max, t2.Albumin_1_max as Albumin_1_max_1, 
t1.Albumin_2_min, t2.Albumin_2_min as Albumin_2_min_1, 
t1.Albumin_2_max, t2.Albumin_2_max as Albumin_2_max_1, 
t1.Bicarbonate_min, t2.Bicarbonate_min as Bicarbonate_min_1, 
t1.Bicarbonate_max, t2.Bicarbonate_max as Bicarbonate_max_1, 
t1.Chloride_min, t2.Chloride_min as Chloride_min_1, 
t1.Chloride_max, t2.Chloride_max as Chloride_max_1, 
t1.Hematocrit_min, t2.Hematocrit_min as Hematocrit_min_1, 
t1.Hematocrit_max, t2.Hematocrit_max as Hematocrit_max_1, 
t1.Potassium_min, t2.Potassium_min as Potassium_min_1, 
t1.Potassium_max, t2.Potassium_max as Potassium_max_1, 
t1.Sodium_min, t2.Sodium_min as Sodium_min_1, 
t1.Sodium_max, t2.Sodium_max as Sodium_max_1, 
t1.PT_min, t2.PT_min as PT_min_1, 
t1.PT_max, t2.PT_max as PT_max_1, 
t1.Calcium_min, t2.Calcium_min as Calcium_min_1, 
t1.Calcium_max, t2.Calcium_max as Calcium_max_1, 
t1.O2Flow_min, t2.O2Flow_min as O2Flow_min_1, 
t1.O2Flow_max, t2.O2Flow_max as O2Flow_max_1, 
t1.CO2_1_min, t2.CO2_1_min as CO2_1_min_1, 
t1.CO2_1_max, t2.CO2_1_max as CO2_1_max_1, 
t1.CO2_2_min, t2.CO2_2_min as CO2_2_min_1, 
t1.CO2_2_max, t2.CO2_2_max as CO2_2_max_1, 
t1.PH_1_min, t2.PH_1_min as PH_1_min_1, 
t1.PH_1_max, t2.PH_1_max as PH_1_max_1, 
t1.PH_2_min, t2.PH_2_min as PH_2_min_1, 
t1.PH_2_max, t2.PH_2_max as PH_2_max_1, 
t1.AnionGap_min, t2.AnionGap_min as AnionGap_min_1, 
t1.AnionGap_max, t2.AnionGap_max as AnionGap_max_1, 
t1.BUN_min, t2.BUN_min as BUN_min_1, 
t1.BUN_max, t2.BUN_max as BUN_max_1, 
t1.GF_minR, t2.GF_minR as GF_minR_1, 
t1.GF_maxR, t2.GF_maxR as GF_maxR_1
 
from va_ads2 t1
LEFT JOIN 
va_ads2 t2
ON t1.patient=t2.patient and t1.encounter=t2.encounter and t1."date"=(t2."date"+ INTERVAL '1' DAY)
LEFT JOIN cs_scores lab on lab.patient=t1.patient and lab.encounter=t1.encounter and lab."date"=t1."date"+ INTERVAL '1' DAY
)  WITH DATA PRIMARY INDEX ("Date","Patient", "Encounter")
; 





