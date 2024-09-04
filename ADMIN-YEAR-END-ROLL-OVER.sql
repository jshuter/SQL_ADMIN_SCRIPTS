
abort !
do not run this by mistake !
exit 
return 

/* =====================================================================================
RENEWED >>>> INACTIVE // BY FLAG 
======================================================================================*/

-- 73874 - renew-flag=0 
-- 1297 - renew-flag=1 

update  co_individual_x_organization_ext
set 	ixo_status_ext = 'Inactive'

-- Select COUNT(*) 

from    co_individual_x_organization 
	inner join  co_individual_x_organization_ext on ixo_key = ixo_key_ext
--	inner join  co_individual_ext on ixo_ind_cst_key = ind_cst_key_ext

where	ixo_renewed_flag_ext = 1
and		ixo_end_date between '2014-09-01 00:00:00' and '2015-08-31 23:59:59' 
and		ixo_delete_flag = 0
and		ixo_status_ext = 'Active'

/* =====================================================================================
RENEWED >>>> INACTIVE // DUPLICATE ROLE IN NEXT YEAR 
======================================================================================*/

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
	OLD_IXO.ixo_end_date between '09/01/2014' and '2015-08-31 23:59:29' 
and		NEW_IXO.ixo_end_date between '2015-09-01 00:00:00' and '2016-08-31 23:59:29' 
and		OLD_IXO.ixo_delete_flag = 0
and		NEW_IXO.ixo_delete_flag = 0
and		OLD_EXT.ixo_status_ext = 'Active'
and		NEW_EXT.ixo_status_ext = 'Active' 

/* =====================================================================================
ACTIVE >>>> NOT-RENEWED // NO (DUPLICATE ROLE IN NEXT YEAR) AND RENEW FLAG==0
======================================================================================*/


update  co_individual_x_organization_ext
set 	ixo_status_ext = 'Not Renewed'

-- Select COUNT(*) 

from    co_individual_x_organization 
	inner join  co_individual_x_organization_ext on ixo_key = ixo_key_ext
	inner join  co_individual_ext on ixo_ind_cst_key = ind_cst_key_ext

where	ixo_renewed_flag_ext = 0
and		ixo_end_date between '09/01/2014' and '2015-08-31 23:59:29' 
and		ixo_delete_flag = 0
and		ixo_status_ext = 'Active'



/*	=====================================================================================
PENDING > INACTIVE 
========================================================================================*/

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

where                ixo_end_date between '2014-09-01' and '2015-08-31 23:59:59' 
and                   ixo_delete_flag = 0
and                   ixo_status_ext = 'Pending'




------------------------------------------------------------------------
-- Next up is setting the organization capacity copy next year org capacity to this year 
------------------------------------------------------------------------

update co_organization_ext
set    	org_vol_capacity_current_ext = org_vol_capacity_next_ext, 
		org_youth_capacity_current_ext = org_youth_capacity_next_ext
where   org_status_ext = 'Active'

-- select top 100 * from co_organization_ext

------------------------------------------------------------------------
-- Close group batches in MyScouts, but leave open in iWeb (there are two close methods in the system)
------------------------------------------------------------------------

update ac_batch_ext
set    bat_drupal_inactive_flag_ext = 1
where  bat_drupal_inactive_flag_ext = 0 or bat_drupal_inactive_flag_ext is null

