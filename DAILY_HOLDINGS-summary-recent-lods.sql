USE SMTR
GO 

with data as ( 
select top 30 AS_OF_DATE, Min(tools.utctolocal(ValidFromUtc)) mn, Max(tools.utctolocal(ValidFromUtc)) mx,count(*) c  from op.Holding_Master 
group by AS_OF_DATE, cast(ValidFromUtc as date)
order by AS_OF_DATE desc, cast(ValidFromUtc as date) DESC 
) 
SELECT d.FULL_DATE, D.Week_Day_Name_CHR, data.* from TOOLS.Date_Master D LEFT join data on AS_OF_DATE = D.FULL_DATE
where D.FULL_DATE between dateadd(d, -30,getdate()) and getdate()
and D.Week_Day_Name_CHR not in ('Saturday', 'Sunday')
order by D.FULL_DATE desc


USE Smtr_Staging SELECT distinct as_of_date, datecreated from SRC.Daily_Holdings where As_of_DATE > '2022-05-21' order by 
 as_of_date, DateCreated-- data created 06-03 17:24


