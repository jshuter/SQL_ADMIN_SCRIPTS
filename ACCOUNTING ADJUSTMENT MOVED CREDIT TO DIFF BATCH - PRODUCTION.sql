
select top 10 * from ac_batch where bat_code = '05101600-000101'
select top 10 * from ac_batch where bat_code = '05191600-000101'

select * from ac_credit where cdt_code = '23726'
select * from ac_credit where cdt_code = '23727'

begin transaction 
-- update ac_credit set cdt_bat_key = '3457D656-6610-40BD-9094-11B18B655D4D' where cdt_code in ('23726', '23727') 
-- UNDO 

update ac_credit set cdt_bat_key = '00FB06B6-1594-410C-9FE4-D98FB5B340B0' where cdt_code in ('23726', '23727') 

select * from ac_credit where cdt_code = '23726'
select * from ac_credit where cdt_code = '23727'

-- commit 