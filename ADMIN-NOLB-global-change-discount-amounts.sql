
-- *** NOTE *** 

-- select * from client_scouts_discount where z80_date_used > '2015-12-31 23:00:00'

--- DURING TESTING 150 needed to be written as 150.0  as  FLOAT was not compareable to INT !

-- CHANGING from NOLB1	150 -> 120 
-- CHANGING from NOLB2	 90 -> 75
-- CHANGING from NOLB3	 40 -> 35 

declare @start_date as date = '2016-01-01'

-- DISPLAY current distribution of values 
select COUNT(*) , z80_discount_amount 
from client_scouts_discount 
where z80_date_used is null 
and z80_expiry_date > @start_date 
and z80_cancelled_flag = 0 
and z80_delete_flag = 0 
group by z80_discount_amount

-------------------------------------------------------------------
begin transaction 

-- 150 to 120 
update client_scouts_discount set z80_discount_amount = 120 
where z80_discount_amount = 150 and z80_date_used is null 
and z80_expiry_date > @start_date and z80_cancelled_flag = 0 and z80_delete_flag = 0 

-- 90 to 75 
update client_scouts_discount set z80_discount_amount = 75 
where z80_discount_amount = 90 and z80_date_used is null 
and z80_expiry_date > @start_date and z80_cancelled_flag = 0 and z80_delete_flag = 0 

-- 40 to 35 
update client_scouts_discount set z80_discount_amount = 35 
where z80_discount_amount = 40 and z80_date_used is null 
and z80_expiry_date > @start_date and z80_cancelled_flag = 0 and z80_delete_flag = 0 

------------------------------------------------------------------------

-- DISPLAY NEW distribution of values 
select COUNT(*) , z80_discount_amount 
from client_scouts_discount 
where z80_date_used is null 
and z80_expiry_date > @start_date 
and z80_cancelled_flag = 0 
and z80_delete_flag = 0 
group by z80_discount_amount

-- commit




