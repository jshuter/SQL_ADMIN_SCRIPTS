--SELECT * from pr.electrumpersistent.log.sqlerrorlog

	select min(datecreated) mindate, max(datecreated) maxdate , count(*) c, messagetext 
	from pr.ElectrumPersistent.log.SqlServerErrorLog
	where ProcessName = 'logon' and datecreated > dateadd(DAY,-14,getdate())
	group by messagetext  
	having count(*) > 7--order by 2 desc, messagetext

;
with logon_erros as (
	select min(datecreated) a, max(datecreated)b , count(*) c, messagetext 
	from pr.ElectrumPersistent.log.SqlServerErrorLog
	where ProcessName = 'logon' and datecreated > dateadd(DAY,-14,getdate())
	group by messagetext  
	having count(*) > 7--order by 2 desc, messagetext
) 
select * from pr.ElectrumPersistent.log.SqlServerErrorLog
where messagetext in ( select messagetext from logon_erros)
order by 3, 1 desc 


