/* this proc is run 2 times 

 - once for CURRENT Year (must be run after ON OR AFTER SEPT 1 !!!!)  (because it is Dependant on PRIOR Year) 
 - once for PRIOR year 

*/ 


-- ONLY USE TRANSACTION WHEN DOING ACTUAL UPDATES !!!!
-- ONLY USE TRANSACTION WHEN DOING ACTUAL UPDATES !!!!
-- ONLY USE TRANSACTION WHEN DOING ACTUAL UPDATES !!!!

BEGIN TRANSACTION 


declare @date date = dateadd(YEAR, -18, dateadd(DAY, -30, getdate() )) ; 

select @date ; 

-----------------------
with old as ( 

	select dbo.client_scouts_requires_PRC(ixo_key) as prc 
		, cst_key, ixo_key , cst_recno, ind_age_cp, ind_first_name, ind_last_name 
	from vw_client_scouts_member_roles 
		join co_individual on ind_cst_key = ixo_ind_cst_key 
	where ixo_status_ext = 'Active' -- ignore 'Pending' 
	and ixo_delete_flag = 0 
	and ( mbt_code not in ('Employee','Participant')  OR  ixo_rlt_code in ('Rover Scout','Rover Scout Participant') )  
	and ind_dob < @date
	and ixo_start_date < '2018-09-01' 

) 

-----------------------

, distinct_old as (select distinct PRC , cst_key , cst_recno, ind_age_cp, ind_first_name, ind_last_name from old) 

-----------------------


------------------------------------------------------------------------------------
-- STEP 1 -- Deactivate CURRENT Active Roles for those that had NO PRC last Year 
------------------------------------------------------------------------------------


/* pre test : PREVIEW : 

select ixo_key from distinct_old 
join co_individual_x_organization ixo on ixo.ixo_ind_cst_key = distinct_old.cst_key 
join co_individual_x_organization_ext on ixo.ixo_key = ixo_key_ext  
join mb_member_type on ixo_mbt_key_ext = mbt_key
where distinct_old.prc = 0 
and ixo_delete_flag = 0 
and ixo_status_ext = 'Active' 
and ixo_start_date >= '2018-09-01' 

*/ 


/** ----------------------------------------------------------------

-- !!! USE TRANSACTION AT TOP WHEN DOING THE UPDATES !!!!!

UPDATE co_individual_x_organization_ext 
SET ixo_status_ext = 'Inactive'
WHERE ixo_key_ext in ( 
select ixo_key from distinct_old 
join co_individual_x_organization ixo on ixo.ixo_ind_cst_key = distinct_old.cst_key 
join co_individual_x_organization_ext on ixo.ixo_key = ixo_key_ext  
join mb_member_type on ixo_mbt_key_ext = mbt_key
where distinct_old.prc = 0 
and ixo_delete_flag = 0 
and ixo_status_ext = 'Active' 
and ixo_start_date >= '2018-09-01' 
) 

-- commit
-- rollback 

**/ 

-- STEP 2 -- deactivate for these 

/** ----------------------------------------------------------------
PREVIEW DATA TO BE UPDATED 
/

select * -- ixo_key 
from distinct_old 
join co_individual_x_organization ixo on ixo.ixo_ind_cst_key = distinct_old.cst_key 
join co_individual_x_organization_ext on ixo.ixo_key = ixo_key_ext  
join mb_member_type on ixo_mbt_key_ext = mbt_key
where distinct_old.prc = 0 
and ixo_delete_flag = 0 
and ixo_status_ext = 'Active' 
and ixo_start_date < '2018-09-01' 
order by ixo_end_date

--*/

/** ----------------------------------------------------------------

-- !!! USE TRANSACTION AT TOP WHEN DOING THE UPDATES !!!!!
*/

UPDATE co_individual_x_organization_ext 
SET ixo_status_ext = 'Inactive'
WHERE ixo_key_ext in ( 
select ixo_key 
from distinct_old 
join co_individual_x_organization ixo on ixo.ixo_ind_cst_key = distinct_old.cst_key 
join co_individual_x_organization_ext on ixo.ixo_key = ixo_key_ext  
join mb_member_type on ixo_mbt_key_ext = mbt_key
where distinct_old.prc = 0 
and ixo_delete_flag = 0 
and ixo_status_ext = 'Active' 
and ixo_start_date < '2018-09-01' 
) 

-- 1481 expected - DONE 


-- commit
-- rollback 








