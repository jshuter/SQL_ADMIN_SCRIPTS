/* =====================================================================================
RENEWED >>>> INACTIVE // BY FLAG 
======================================================================================*/

/* 
E3E43A5D-88FE-4956-B494-5233BBBDE3D9	2015-08-31 10:19:00	2015-08-31 23:59:00
9DF1CE81-F9A2-4076-B38F-B8E387C53391	2015-08-31 00:00:00	2015-09-01 00:00:00
*/

-- 14/15 : 36,616 rows - pre-counted 
-- 15/16 : 41,909 rows - pre-counted 

update  co_individual_x_organization_ext
set 	ixo_status_ext = 'Inactive'

-- Select count(*) 

from    co_individual_x_organization 
	inner join  co_individual_x_organization_ext on ixo_key = ixo_key_ext
--	inner join  co_individual_ext on ixo_ind_cst_key = ind_cst_key_ext

where	ixo_renewed_flag_ext = 1
and		ixo_end_date between '2015-09-01 00:00:00' and '2016-08-31 23:59:59' 
and		ixo_delete_flag = 0
and		ixo_status_ext = 'Active'

-- DONE -- 14/15 : 36,618 rows affected
-- DONE -- 15/16 : 41,909 rows affected
-- dev 46  
/* =====================================================================================
RENEWED >>>> INACTIVE // DUPLICATE ROLE IN NEXT YEAR 
======================================================================================*/

-- 45,741 -- but should decrease by 36,616 after the update above is done 
-- approx 10,976 expected  

-- 12316 counted 

update  OLD_EXT
set 	OLD_EXT.ixo_status_ext = 'Inactive'

-- Select COUNT(*) -- top 10 OLD_IXO.* , NEW_IXO.* 

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
		OLD_IXO.ixo_end_date between '2015-09-01' and '2016-08-31 23:59:59' --<<< LAST YEAR !!!!
and		NEW_IXO.ixo_end_date between '2016-09-01' and '2017-08-31 23:59:59' --<<< NEXT YEAR !!!!
and		OLD_IXO.ixo_delete_flag = 0
and		NEW_IXO.ixo_delete_flag = 0
and		OLD_EXT.ixo_status_ext = 'Active'
and		NEW_EXT.ixo_status_ext = 'Active' 

-- 14/15 : 10, 923 updated 
-- 15/16 : 12, 276 updated 
 -- 33 on dev 
 
/* =====================================================================================
ACTIVE >>>> NOT-RENEWED // NO (DUPLICATE ROLE IN NEXT YEAR) AND RENEW FLAG==0
======================================================================================*/

-- 60,208 
-- less 45,741 
-- approx 15,000 will be marked as Not-Renewed

-- 14/15 - 49,286 updated 
-- 15/16 - 41,589 updated 
-- dev 78500 

update  co_individual_x_organization_ext
set 	ixo_status_ext = 'Not Renewed'

-- Select COUNT(*) 

from    co_individual_x_organization 
	inner join  co_individual_x_organization_ext on ixo_key = ixo_key_ext
	inner join  co_individual_ext on ixo_ind_cst_key = ind_cst_key_ext

where	ixo_renewed_flag_ext = 0
and		ixo_end_date between '2015-09-01' and '2016-08-31 23:59:59' 
and		ixo_delete_flag = 0
and		ixo_status_ext = 'Active'

/*	=====================================================================================
PENDING > INACTIVE 
========================================================================================*/

-- 2,539 Pending to become inactive 

-- 14/15 : 2539 updated 
-- 15/16 : 3353 updated 
-- dev 6700 
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

where                ixo_end_date between '2015-09-01' and '2016-08-31 23:59:59' 
and                   ixo_delete_flag = 0
and                   ixo_status_ext = 'Pending'

-- select top 1000 * from  co_individual_x_organization_ext

------------------------------------------------------------------------
-- Next up is setting the organization capacity copy next year org capacity to this year 
------------------------------------------------------------------------

-- plan/review

select COUNT(*) from co_organization_ext where   org_status_ext = 'Active'

select top 100 org_vol_capacity_current_ext, org_vol_capacity_next_ext, org_youth_capacity_current_ext, org_youth_capacity_next_ext 
from co_organization_ext 
where   org_status_ext = 'Active'
and (org_vol_capacity_current_ext <> org_vol_capacity_next_ext
	OR org_youth_capacity_current_ext <> org_youth_capacity_next_ext) 

---do---

update co_organization_ext
set    	org_vol_capacity_current_ext = org_vol_capacity_next_ext, 
		org_youth_capacity_current_ext = org_youth_capacity_next_ext
where   org_status_ext = 'Active'

-- 14/15 : 9707 rows affected 
-- 15/16 : 9508 rows affected 

------------------------------------------------------------------------
-- Close group batches in MyScouts, but leave open in iWeb (there are two close methods in the system)
------------------------------------------------------------------------

select COUNT(*) from ac_batch_ext where bat_drupal_inactive_flag_ext = 0 or bat_drupal_inactive_flag_ext is null

update ac_batch_ext
set    bat_drupal_inactive_flag_ext = 1
where  bat_drupal_inactive_flag_ext = 0 or bat_drupal_inactive_flag_ext is null

-- 14/15 : 487 batches closed 
-- 15/16 : 349 batches closed 
-- dev 1149 done 

-----------------------------------------------------------------------------------
----- added for Sept 1, 2016 -- updated Scouting Year Here (instead of from iWeb) 
-----------------------------------------------------------------------------------

-- On sept 1, 2016 changed value from 2016 to 2017 !!!! must get rid of this - and use proper function 

select fws_value from fw_system_option where fws_option = 'ScoutsRegistrationYear'

update fw_system_option set fws_value = '2017' where fws_option = 'ScoutsRegistrationYear'

select fws_value from fw_system_option where fws_option = 'ScoutsRegistrationYear'

-- DONE : 1 row affected 


------------------------------------------
-- from nightly jobs -- Nightly Ind Status Rebuild 
-- step 1 
exec client_scouts_individual_status_rebuild 
-- step 2 
exec client_scouts_rebuild_primary_ixo 

-----------------------------------------------------------------------------------
-- NEW - not used in SEPT 2015
-- NEEDED FOR SEPT 2016 

-- MUST ADD RECOGNITION RECORDS for Seasonal Assessments 

-- 1 -- Create new PQAYYYY 
-- 2 -- create 4 new PQS-YYYY-# 

-- ie INSERT - Manual or by script 'PQS-2017-1, PQS-2017-2, PQS-2017-3, PQS-2017-4'

select * from client_scouts_recognition_list where z04_recognition_code like 'PQ%'
order by z04_recognition_code

-- take the query above into the [client_scouts_recognition_list]->[edit top 200 rows] and create the new data ...

select NEWID()
select NEWID()
select NEWID()
select NEWID()
