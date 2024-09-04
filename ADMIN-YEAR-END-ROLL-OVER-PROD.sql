
return 

-- DO NOT RUN THIS CODE -- 

-- EXECUTE 1 section at a time -- 

/* =====================================================================================
RENEWED >>>> INACTIVE // BY FLAG 
======================================================================================*/

/* 
E3E43A5D-88FE-4956-B494-5233BBBDE3D9	2015-08-31 10:19:00	2015-08-31 23:59:00
9DF1CE81-F9A2-4076-B38F-B8E387C53391	2015-08-31 00:00:00	2015-09-01 00:00:00
*/

-- 14/15 : 36,616 rows - pre-counted 
-- 15/16 : 41,909 rows - pre-counted 
-- 16/17 : ? not recordef
-- 17/18 : 20,171 rows - pre-counted  (70,000 not renewed) 

update  co_individual_x_organization_ext
set 	ixo_status_ext = 'Inactive'        
-- Select count(*) 
from    co_individual_x_organization 
	inner join  co_individual_x_organization_ext on ixo_key = ixo_key_ext
where	ixo_renewed_flag_ext = 1
and		ixo_end_date between '2017-09-01 00:00:00' and '2018-08-31 23:59:59' 
and		ixo_delete_flag = 0
and		ixo_status_ext = 'Active'

-- DONE -- 14/15 : 36,618 rows affected
-- DONE -- 15/16 : 41,909 rows affected
-- DONE -- 16/17 : 29,211 rows affected 
-- DONE -- 17/18 : 19,623 rows affected 

/* =====================================================================================
RENEWED >>>> INACTIVE // DUPLICATE ROLE IN NEXT YEAR 
======================================================================================*/

-- 45,741 -- but should decrease by 36,616 after the update above is done 
-- approx 10,976 expected  

-- 12,316 counted 


update  OLD_EXT
set 	OLD_EXT.ixo_status_ext = 'Inactive'
-- Select  top 100 OLD_IXO.* , NEW_IXO.* 
-- select count(*) 
from    co_individual_x_organization OLD_IXO
	inner join  co_individual_x_organization_ext OLD_EXT on OLD_IXO.ixo_key = OLD_EXT.ixo_key_ext
	inner join  co_individual_ext on OLD_IXO.ixo_ind_cst_key = ind_cst_key_ext
	inner join  co_individual_x_organization NEW_IXO
	
		on		OLD_IXO.ixo_ind_cst_key =	NEW_IXO.ixo_ind_cst_key 
			and OLD_IXO.ixo_org_cst_key =	NEW_IXO.ixo_org_cst_key
			and OLD_IXO.ixo_rlt_code =		NEW_IXO.ixo_rlt_code

	inner join  co_individual_x_organization_ext NEW_EXT on NEW_IXO.ixo_key = NEW_EXT.ixo_key_ext
	
where	--OLD_EXT.ixo_renewed_flag_ext = 1  --// DOES NOT MATTER WHA FLAG SAYS WHEN WE VERIFY RENEWAL ?		
		--and 
		OLD_IXO.ixo_end_date between '2017-09-01' and '2018-08-31 23:59:59' --<<< LAST YEAR !!!!
and		NEW_IXO.ixo_end_date between '2018-09-01' and '2019-08-31 23:59:59' --<<< NEXT YEAR !!!!
and		OLD_IXO.ixo_delete_flag = 0
and		NEW_IXO.ixo_delete_flag = 0
and		OLD_EXT.ixo_status_ext = 'Active'
and		NEW_EXT.ixo_status_ext in ('Active','Pending') 

-- DONE 14/15 : 10, 923 updated 
-- DONE 15/16 : 12, 276 updated (45 before step 1) 
-- DONE 16/17 : 19, 727 updated (29 before step 1) 
-- DONE 17/18 : 23, 840 updated   -- 17/18 -- -- 23,840 -- PRELIM COUNT (before step 1) -- 36,367/ACTIVATED --  5,624/PENDING 


/* =====================================================================================
ACTIVE >>>> NOT-RENEWED // NO (DUPLICATE ROLE IN NEXT YEAR) AND RENEW FLAG==0
======================================================================================*/

-- 60,208 
-- less 45,741 
-- approx 15,000 will be marked as Not-Renewed

update  co_individual_x_organization_ext
set 	ixo_status_ext = 'Not Renewed'
-- Select COUNT(*) 
from    co_individual_x_organization 
	inner join  co_individual_x_organization_ext on ixo_key = ixo_key_ext
	inner join  co_individual_ext on ixo_ind_cst_key = ind_cst_key_ext

where	ixo_renewed_flag_ext = 0
and		ixo_end_date between '2017-09-01' and '2018-08-31 23:59:59' 
and		ixo_delete_flag = 0
and		ixo_status_ext = 'Active'

-- 14/15 - 49,286 updated 
-- 15/16 - 41,589 updated 
-- 16/17 - 43,866 updated
-- 17/18 - 46,382 updated  -  46,382 expected 

/*	=====================================================================================
ALL PRIOR YEAR -- PENDING > INACTIVE 
========================================================================================*/

-- 2,539 Pending to become inactive 

------------------------------------------------------------------------
-- Set all 'Pending' Roles to 'Inactive' 
-- PJ pending roles for the outgoing year only (i.e. 14/15 pending roles get changed but not 15/16 pending roles 
------------------------------------------------------------------------

update               co_individual_x_organization_ext
set 	             ixo_status_ext = 'Inactive'
-- select count(*) 
from                 co_individual_x_organization
inner join             co_individual_x_organization_ext on ixo_key = ixo_key_ext
inner join             co_individual_ext on ixo_ind_cst_key = ind_cst_key_ext

where                ixo_end_date between '2017-09-01' and '2018-08-31 23:59:59' 
and                   ixo_delete_flag = 0
and                   ixo_status_ext = 'Pending'

-- select top 1000 * from  co_individual_x_organization_ext

-- 14/15 : 2539 updated 
-- 15/16 : 3353 updated 
-- 16/17 : 4066 updated 
-- 17/18 : 3259 updated 
 
------------------------------------------------------------------------
-- Next up is setting the organization capacity copy next year org capacity to this year 
------------------------------------------------------------------------

-- plan/review

select COUNT(*) from co_organization_ext 
where   org_status_ext = 'Active'
and org_vol_capacity_next_ext is not NULL 
and org_youth_capacity_next_ext is not NULL 
and (org_vol_capacity_current_ext <> org_vol_capacity_next_ext
	OR org_youth_capacity_current_ext <> org_youth_capacity_next_ext) 


update co_organization_ext
set    	org_vol_capacity_current_ext = org_vol_capacity_next_ext, 
		org_youth_capacity_current_ext = org_youth_capacity_next_ext
-- select * from co_organization_ext
where   org_status_ext = 'Active'
and org_vol_capacity_next_ext is not NULL 
and org_youth_capacity_next_ext is not NULL 
and (org_vol_capacity_current_ext <> org_vol_capacity_next_ext
	OR org_youth_capacity_current_ext <> org_youth_capacity_next_ext) 

-- 14/15 : 9707 rows affected 
-- 15/16 : 9508 rows affected 
-- 16/17 : 8831 rows affected 
-- 17/18 :  816 rows affacted -- NOW Limiting to where there are changes 

------------------------------------------------------------------------
-- Close group batches in MyScouts, but leave open in iWeb (there are two close methods in the system)
------------------------------------------------------------------------

update ac_batch_ext
set    bat_drupal_inactive_flag_ext = 1
-- select * from ac_batch_ext
where  bat_drupal_inactive_flag_ext = 0 or bat_drupal_inactive_flag_ext is null

-- 14/15 : 487 batches closed 
-- 15/16 : 349 batches closed 
-- 16/17 : 367 rows affected - closed 
-- 17/18 : 619 rows affacted 

-----------------------------------------------------------------------------------
----- added for Sept 1, 2016 -- updated Scouting Year Here (instead of from iWeb) 
-----------------------------------------------------------------------------------

-- On sept 1, 2016 changed value from 2016 to 2017 !!!! must get rid of this - and use proper function 

select fws_value from fw_system_option where fws_option = 'ScoutsRegistrationYear'

update fw_system_option set fws_value = '2019' where fws_option = 'ScoutsRegistrationYear'

select fws_value from fw_system_option where fws_option = 'ScoutsRegistrationYear'

-- DONE : 1 row affected 

-- DONE -- 2018/2019 -- change to 2019 

------------------------------------------
-- from nightly jobs -- Nightly Ind Status Rebuild 

-- step 1 
exec client_scouts_individual_status_rebuild 

-- step 2 
exec client_scouts_rebuild_primary_ixo 

-- WHEN ready - also do the NOT-Renewed update (TBD) 


------------------------------------------------------------
-- NEW FOR (2018) -- mar 2018 - added org_program_end_date_ext 

-- MUST ROLL OVER START & END DATES !!!

	begin transaction 

	declare @start datetime 
	declare @end datetime 

	select * from dbo.client_scouts_get_scouting_date_range()

	-- THIS SHOULD BE IMPROVED - a it overwrites data that may have been used to opt out of summer programm 
	-- NEEDS REVIEW ?

	set @start  = '2018-09-01'
	set @end  = '2019-08-01 23:59:59' 

	update co_organization_ext 
		set org_program_start_date_ext = @start
		, org_program_end_date_ext = @end 
	where org_status_ext = 'Active' 

	-- commit
	-- rollback 

	select org_cst_key_ext, org_program_start_date_ext, org_program_end_date_ext, org_inactive_flag_ext 
	from co_organization_ext 
	where org_status_ext = 'Active' 
	order by org_program_end_date_ext 




