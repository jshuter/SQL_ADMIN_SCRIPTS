
---- 
-- Metadata - Tables - Columns 
-- 

with 
 prod as ( SELECT * FROM [scoutssql02.tpca.ld].nfscouts.dbo.md_table pt ) 
,stage as ( SELECT * FROM dbo.md_table st) 

select * 
from stage 
	left join prod on stage.mdt_name = prod.mdt_name 
where prod.mdt_key is null 
order by prod.mdt_name desc

--- and same for columns

; 

with 
 prod as ( SELECT * FROM [scoutssql02.tpca.ld].nfscouts.dbo.md_column) 
,stage as ( SELECT * FROM dbo.md_column) 

select * 
from stage 
	left join prod on stage.mdc_name = prod.mdc_name 
where prod.mdc_key is null 
order by prod.mdc_name desc




