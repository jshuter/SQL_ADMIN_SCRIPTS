-- initially used when major change was made to ReportCard structure. 
-- Only incerting into 1/2 of the # of tables as before - so it's now twice as fast 
-- INVESTOPS-2072 

select as_of_date, min(effectivedate), max(EffectiveDate), datediff(MINUTE,min(effectivedate) ,max(effectivedate) ),  count(*) from investments_dw.FACT.PrivateReportCardMainFacts_WithLocal where cast(EffectiveDate as date)  = '2022-06-13'
group by As_Of_Date

select as_of_date, min(effectivedate), max(EffectiveDate), datediff(MINUTE,min(effectivedate) ,max(effectivedate) ),  count(*) from investments_dw.FACT.PrivateReportCardMainFacts_WithLocal where cast(EffectiveDate as date)  = '2022-06-14'
group by As_Of_Date
