
use msdb 
go 

select logical_name, physical_name db, page_size, backed_up_page_count, file_size, bf.backup_size --, *
, datediff(MINUTE, bs.backup_start_date, bs.backup_finish_date) bkp_duration, bs.backup_finish_date, *
from msdb.dbo.backupfile bf
join backupset bs on bs.backup_set_id = bf.backup_set_id
where logical_name like '%smtr%'
and bs.type='D'
order by physical_name , bs.backup_finish_date desc 
