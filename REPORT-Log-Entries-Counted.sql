USE SMTR 

select datepart(YEAR, Occurred_On_DNT), count(*) from CTRL.Session_Log 
group by datepart(YEAR, Occurred_On_DNT) 
order by datepart(YEAR, Occurred_On_DNT)
