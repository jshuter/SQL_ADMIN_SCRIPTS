-- SET DATES 

-- RUN SCRIPT 

-- COMMIT or ROLLBACK 

declare @YYYY1 int = 2018 
declare @YYYY2 int = @YYYY1 + 1

-- update start dates 

------------------------------------------------------------
-- FIND DATES That span more than 1 Year !!!!
------------------------------------------------------------

select *
from co_individual_x_organization
join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
left join client_scouts_experimental_registration on x13_ixo_key = ixo_key
where getdate() between ixo_start_date and ixo_end_date 
and DATEDIFF (DAY,ixo_start_date, ixo_end_date) > 365 
and ixo_delete_flag = 0
and ixo_status_ext = 'Active'
and ixo_end_date between  cast(@YYYY2 as varchar(4) ) + '-08-31' and cast(@YYYY2 as varchar(4) ) + '-09-01'

------------------------------------------------------------
-- review the results 
------------------------------------------------------------

begin transaction

UPDATE co_individual_x_organization
set ixo_start_date = cast(@YYYY1 as varchar(4) ) + '-09-01' 
, ixo_change_date = cast (getdate() as date) 
, ixo_change_user = 'sysadmin - datefix'
from co_individual_x_organization
	join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
	left join client_scouts_experimental_registration on x13_ixo_key = ixo_key
where getdate() between ixo_start_date and ixo_end_date 
	and DATEDIFF (DAY,ixo_start_date, ixo_end_date) > 365 
	and ixo_delete_flag = 0
	and ixo_status_ext = 'Active'
	and ixo_end_date between  cast(@YYYY2 as varchar(4) ) + '-08-31' and cast(@YYYY2 as varchar(4) ) + '-09-01'

------------------------------------------------------
-- check results 
------------------------------------------------------

select x13_type, * from co_individual_x_organization
join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
left join client_scouts_experimental_registration on x13_ixo_key = ixo_key
where ixo_change_date = cast(getdate() as date) 
	and ixo_change_user = 'sysadmin - datefix'
	and ixo_delete_flag = 0
	and ixo_status_ext = 'Active' 
order by ixo_start_date

-------------------------------------------
-- more ?
-------------------------------------------

select x13_type, * from co_individual_x_organization
join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
left join client_scouts_experimental_registration on x13_ixo_key = ixo_key
where getdate() between ixo_start_date and ixo_end_date 
and DATEDIFF (DAY,ixo_start_date, ixo_end_date) > 365 
and ixo_delete_flag = 0
and ixo_status_ext = 'Active' 
order by ixo_start_date

--- do one of the following after review

-- commit 
-- rollback
