-- ADMIN-DATABASE-SPACE-USAGE-report-V3 

use msdb 
go 

; 
WITH data1 as ( 
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
) 
SELECT * FROM data1 
where y >2023
order by logical_name, 1 desc , 2 desc 

;
with x as( 
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
) 
select * from x
where y=2024 and m> 6
order by 5 desc -- logical_name, 1 desc , 2 desc 

