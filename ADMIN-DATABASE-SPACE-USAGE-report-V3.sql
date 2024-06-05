use msdb 
go 
 
select
Year(bs.backup_start_date) y, month(bs.backup_start_date) m,
min(file_size) fs1, max(file_size) fs2, 
max(file_size) - min(file_size) month_growth,
min(bs.backup_start_date) sd1, 
max(bs.backup_start_date) sd2, 
logical_name, physical_name  
from backupfile bf join backupset bs on bs.backup_set_id = bf.backup_set_id
where logical_name not in (
	'EWB',	'EWB_log',	'INVESTMENTS_DW',	'INVESTMENTS_DW_log',	'Investments_Operations',	'Investments_Operations_log',
	'Investments_Performance',	'Investments_Performance_log',	'SMTR_Audit',	'SMTR_Audit_log')
group by logical_name, physical_name, Year(bs.backup_start_date), month(bs.backup_start_date)
order by logical_name, 1 desc , 2 desc 


