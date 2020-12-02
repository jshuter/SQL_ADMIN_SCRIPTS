-- todo - add change by date and user to the ixo_ext record

declare @do_update integer 

set @do_update = 0 -- use 9 for UPDATE ALL  

declare @start_date_ty smalldatetime 

select @start_date_ty = scouting_start_date 
from client_scouts_get_scouting_date_range()

-- "NOT RENEWED" can and should only exist as the status of a role in a prior year !!!!
-- by the middle of the Scouting Year, all "Not Renewed"s will have been removed 

-- 35,536 not renewed on Sept 6 at 1:45 PM 
select 'ALL NOT RENEWED : COUNT=', count(*) from co_individual_x_organization_ext where ixo_status_ext = 'Not Renewed'

select @start_date_ty as 'START DATE - CURRENT SCOUTING YEAR'

IF @do_update > 0 begin 
	BEGIN TRANSACTION 
end 


/**********************************************************************************
-- STEP 1 -- Review and Update PARTICIPANTS - if NOT Renewed has now Renewed 
-- 
-- Change (ROVER OR VENTURE) (NOT Renewed > Inactive) only if ROVER>ROVER or VENTURE>VENTURE 
-- all other Role Types / Beaver, Scout, Cub, etc assumes 1 Participant Role 
-- 
***********************************************************************************/

Select
count(*)
-- top 100 OLD_ROLE.ixo_start_date , NEW_ROLE.ixo_start_date, OLD_ROLE_EXT.ixo_status_ext, NEW_ROLE_EXT.ixo_status_ext, OLD_ROLE.ixo_rlt_code, NEW_ROLE.ixo_rlt_code 
from
	-- OLD ROLE 
	co_individual_x_organization OLD_ROLE
	inner join  co_individual_x_organization_ext OLD_ROLE_EXT	on OLD_ROLE.ixo_key = OLD_ROLE_EXT.ixo_key_ext
	inner join  co_individual_ext OLD_IND						on OLD_ROLE.ixo_ind_cst_key = OLD_IND.ind_cst_key_ext
	inner join  mb_member_type OLD_MBT							on OLD_ROLE_EXT.ixo_mbt_key_ext = OLD_MBT.mbt_key 
		
	-- RENEWED ROLE 
	inner join  co_individual_x_organization NEW_ROLE			on OLD_ROLE.ixo_ind_cst_key = NEW_ROLE.ixo_ind_cst_key	-- same INDIVIDUAL ...
	inner join  co_individual_x_organization_ext NEW_ROLE_EXT	on NEW_ROLE.ixo_key = NEW_ROLE_EXT.ixo_key_ext			-- Has a NEW ...
	inner join  mb_member_type NEW_MBT							on NEW_ROLE_EXT.ixo_mbt_key_ext = NEW_mbt.mbt_key		-- Participant Role  

where	OLD_ROLE.ixo_end_date < @start_date_ty		--<<< LAST YEARS ROLES  !!!!
	and	NEW_ROLE.ixo_end_date > @start_date_ty		--<<< CURRENT YEARS ROLES !!!!
	and	NEW_ROLE.ixo_start_date >= @start_date_ty	--<<< CURRENT YEARS ROLES !!!!

	and	OLD_ROLE.ixo_delete_flag = 0
	and	NEW_ROLE.ixo_delete_flag = 0

	and	OLD_ROLE_EXT.ixo_status_ext = 'Not Renewed'
	and	NEW_ROLE_EXT.ixo_status_ext = 'Active'     -- ignoring Pending roles !

	and OLD_MBT.mbt_code = 'Participant' 
	and NEW_MBT.mbt_code = 'Participant' 

	and OLD_ROLE.ixo_rlt_code NOT in ('Venturer Scout', 'Rover Scout Participant') -- doing these separately - see below 



---- 

if (@do_update = 1 or @do_update = 9) BEGIN 

		UPDATE OLD_ROLE_EXT 
		set OLD_ROLE_EXT.ixo_status_ext = 'Inactive' 

		from
			-- OLD ROLE 
			co_individual_x_organization OLD_ROLE
			inner join  co_individual_x_organization_ext OLD_ROLE_EXT	on OLD_ROLE.ixo_key = OLD_ROLE_EXT.ixo_key_ext
			inner join  co_individual_ext OLD_IND						on OLD_ROLE.ixo_ind_cst_key = OLD_IND.ind_cst_key_ext
			inner join  mb_member_type OLD_MBT							on OLD_ROLE_EXT.ixo_mbt_key_ext = OLD_MBT.mbt_key 
		
			-- RENEWED ROLE 
			inner join  co_individual_x_organization NEW_ROLE			on OLD_ROLE.ixo_ind_cst_key = NEW_ROLE.ixo_ind_cst_key	-- same INDIVIDUAL ...
			inner join  co_individual_x_organization_ext NEW_ROLE_EXT	on NEW_ROLE.ixo_key = NEW_ROLE_EXT.ixo_key_ext			-- Has a NEW ...
			inner join  mb_member_type NEW_MBT							on NEW_ROLE_EXT.ixo_mbt_key_ext = NEW_mbt.mbt_key		-- Participant Role  

		where	OLD_ROLE.ixo_end_date < @start_date_ty		--<<< LAST YEARS ROLES  !!!!
			and	NEW_ROLE.ixo_end_date > @start_date_ty		--<<< CURRENT YEARS ROLES !!!!
			and	NEW_ROLE.ixo_start_date >= @start_date_ty	--<<< CURRENT YEARS ROLES !!!!

			and	OLD_ROLE.ixo_delete_flag = 0
			and	NEW_ROLE.ixo_delete_flag = 0

			and	OLD_ROLE_EXT.ixo_status_ext = 'Not Renewed'
			and	NEW_ROLE_EXT.ixo_status_ext = 'Active'     -- ignoring Pending roles !

			and OLD_MBT.mbt_code = 'Participant' 
			and NEW_MBT.mbt_code = 'Participant' 

			and OLD_ROLE.ixo_rlt_code NOT in ('Venturer Scout', 'Rover Scout Participant') -- doing these separately - see below 
		
		print 'updated UPDATE TYPE = 1 ... CHECK and COMMIT '		

		if @do_update = 1
			return 

		--commit
		--rollback

END 

/**********************************************************************************
-- STEP 2 -- Review and Update PARTICIPANTS - ROVER and VENTURE 
*/ 

Select 
 count(*)
-- top 100 OLD_ROLE.ixo_start_date , NEW_ROLE.ixo_start_date, OLD_ROLE_EXT.ixo_status_ext, NEW_ROLE_EXT.ixo_status_ext, OLD_ROLE.ixo_rlt_code, NEW_ROLE.ixo_rlt_code 
from
	-- OLD ROLE 
	co_individual_x_organization OLD_ROLE
	inner join  co_individual_x_organization_ext OLD_ROLE_EXT	on OLD_ROLE.ixo_key = OLD_ROLE_EXT.ixo_key_ext
	inner join  co_individual_ext OLD_IND						on OLD_ROLE.ixo_ind_cst_key = OLD_IND.ind_cst_key_ext
	inner join  mb_member_type OLD_MBT							on OLD_ROLE_EXT.ixo_mbt_key_ext = OLD_MBT.mbt_key 
		
	-- RENEWED ROLE 
	inner join  co_individual_x_organization NEW_ROLE			on OLD_ROLE.ixo_ind_cst_key = NEW_ROLE.ixo_ind_cst_key	-- same INDIVIDUAL ...
	inner join  co_individual_x_organization_ext NEW_ROLE_EXT	on NEW_ROLE.ixo_key = NEW_ROLE_EXT.ixo_key_ext			-- Has a NEW ...
	inner join  mb_member_type NEW_MBT							on NEW_ROLE_EXT.ixo_mbt_key_ext = NEW_mbt.mbt_key		-- Participant Role  

where	OLD_ROLE.ixo_end_date < @start_date_ty		--<<< LAST YEARS ROLES  !!!!
	and	NEW_ROLE.ixo_end_date > @start_date_ty		--<<< CURRENT YEARS ROLES !!!!
	and	NEW_ROLE.ixo_start_date >= @start_date_ty	--<<< CURRENT YEARS ROLES !!!!

	and	OLD_ROLE.ixo_delete_flag = 0
	and	NEW_ROLE.ixo_delete_flag = 0

	and	OLD_ROLE_EXT.ixo_status_ext = 'Not Renewed'
	and	NEW_ROLE_EXT.ixo_status_ext = 'Active'     -- ignoring Pending roles !

	and OLD_MBT.mbt_code = 'Participant' 
	and NEW_MBT.mbt_code = 'Participant' 

	and OLD_ROLE.ixo_rlt_code in ('Venturer Scout', 'Rover Scout Participant') 

	and OLD_ROLE.ixo_rlt_code = NEW_ROLE.ixo_rlt_code   -- Venture > Venture || Rover > Rover 


if (@do_update = 2 or @do_update = 9) BEGIN 
	
		UPDATE OLD_ROLE_EXT
		set OLD_ROLE_EXT.ixo_status_ext = 'Inactive' 
		
		from
			-- OLD ROLE 
			co_individual_x_organization OLD_ROLE
			inner join  co_individual_x_organization_ext OLD_ROLE_EXT	on OLD_ROLE.ixo_key = OLD_ROLE_EXT.ixo_key_ext
			inner join  co_individual_ext OLD_IND						on OLD_ROLE.ixo_ind_cst_key = OLD_IND.ind_cst_key_ext
			inner join  mb_member_type OLD_MBT							on OLD_ROLE_EXT.ixo_mbt_key_ext = OLD_MBT.mbt_key 
		
			-- RENEWED ROLE 
			inner join  co_individual_x_organization NEW_ROLE			on OLD_ROLE.ixo_ind_cst_key = NEW_ROLE.ixo_ind_cst_key	-- same INDIVIDUAL ...
			inner join  co_individual_x_organization_ext NEW_ROLE_EXT	on NEW_ROLE.ixo_key = NEW_ROLE_EXT.ixo_key_ext			-- Has a NEW ...
			inner join  mb_member_type NEW_MBT							on NEW_ROLE_EXT.ixo_mbt_key_ext = NEW_mbt.mbt_key		-- Participant Role  

		where	OLD_ROLE.ixo_end_date < @start_date_ty		--<<< LAST YEARS ROLES  !!!!
			and	NEW_ROLE.ixo_end_date > @start_date_ty		--<<< CURRENT YEARS ROLES !!!!
			and	NEW_ROLE.ixo_start_date >= @start_date_ty	--<<< CURRENT YEARS ROLES !!!!

			and	OLD_ROLE.ixo_delete_flag = 0
			and	NEW_ROLE.ixo_delete_flag = 0

			and	OLD_ROLE_EXT.ixo_status_ext = 'Not Renewed'
			and	NEW_ROLE_EXT.ixo_status_ext = 'Active'     -- ignoring Pending roles !

			and OLD_MBT.mbt_code = 'Participant' 
			and NEW_MBT.mbt_code = 'Participant' 

			and OLD_ROLE.ixo_rlt_code in ('Venturer Scout', 'Rover Scout Participant') 

			and OLD_ROLE.ixo_rlt_code = NEW_ROLE.ixo_rlt_code   -- Venture > Venture || Rover > Rover 

	print 'UPDATED - TYPE = 2 ... check and COMMIT'

	if @do_update = 2
			return 
	
	-- commit 
	-- rollback 

END 

/**************************************************************************************************
*	STEP 3 -- do same for Volunteers - but for Volunteers - limit to same role & same group 
**************************************************************************************************/

Select 
count(*) 
--top 100 OLD_ROLE.ixo_start_date , NEW_ROLE.ixo_start_date, OLD_ROLE_EXT.ixo_status_ext, NEW_ROLE_EXT.ixo_status_ext, OLD_ROLE.ixo_rlt_code, NEW_ROLE.ixo_rlt_code 
from

	-- OLD ROLE 

	co_individual_x_organization OLD_ROLE
	inner join  co_individual_x_organization_ext	OLD_ROLE_EXT on OLD_ROLE.ixo_key			= OLD_ROLE_EXT.ixo_key_ext
	inner join  co_individual_ext					IND			on OLD_ROLE.ixo_ind_cst_key		= IND.ind_cst_key_ext
	inner join  mb_member_type						OLD_MBT		on OLD_ROLE_EXT.ixo_mbt_key_ext = OLD_MBT.mbt_key 
		
	-- RENEWED ROLE 

	inner join  co_individual_x_organization NEW_ROLE			on	OLD_ROLE.ixo_ind_cst_key	= NEW_ROLE.ixo_ind_cst_key	-- same IND 
																and OLD_ROLE.ixo_org_cst_key	= NEW_ROLE.ixo_org_cst_key	-- same ORG 
																and OLD_ROLE.ixo_rlt_code		= NEW_ROLE.ixo_rlt_code		-- same ROLE TYPE 

	inner join  co_individual_x_organization_ext NEW_ROLE_EXT	on NEW_ROLE.ixo_key				= NEW_ROLE_EXT.ixo_key_ext
	inner join  mb_member_type NEW_MBT							on NEW_ROLE_EXT.ixo_mbt_key_ext = NEW_mbt.mbt_key 

where	OLD_ROLE.ixo_end_date < @start_date_ty  --<<< LAST YEARS ROLES  !!!!
	and	NEW_ROLE.ixo_start_date >= @start_date_ty --<<< CURRENT YEARS ROLES !!!!
	and	NEW_ROLE.ixo_end_date > @start_date_ty --<<< CURRENT YEARS ROLES !!!!

	and	OLD_ROLE.ixo_delete_flag = 0
	and	NEW_ROLE.ixo_delete_flag = 0
	
	and	OLD_ROLE_EXT.ixo_status_ext = 'Not Renewed'
	and	NEW_ROLE_EXT.ixo_status_ext = 'Active' 
	
	and OLD_MBT.mbt_code = 'Volunteer' 
	and NEW_MBT.mbt_code = 'Volunteer'

-------------------------------------------

if (@do_update = 3 or @do_update = 9) BEGIN 

	UPDATE OLD_ROLE_EXT 
	set OLD_ROLE_EXT.ixo_status_ext = 'Inactive' 
	from

		-- OLD ROLE 

		co_individual_x_organization OLD_ROLE
		inner join  co_individual_x_organization_ext	OLD_ROLE_EXT on OLD_ROLE.ixo_key			= OLD_ROLE_EXT.ixo_key_ext
		inner join  co_individual_ext					IND			on OLD_ROLE.ixo_ind_cst_key		= IND.ind_cst_key_ext
		inner join  mb_member_type						OLD_MBT		on OLD_ROLE_EXT.ixo_mbt_key_ext = OLD_MBT.mbt_key 
		
		-- RENEWED ROLE 

		inner join  co_individual_x_organization NEW_ROLE			on	OLD_ROLE.ixo_ind_cst_key	= NEW_ROLE.ixo_ind_cst_key	-- same IND 
																	and OLD_ROLE.ixo_org_cst_key	= NEW_ROLE.ixo_org_cst_key	-- same ORG 
																	and OLD_ROLE.ixo_rlt_code		= NEW_ROLE.ixo_rlt_code		-- same ROLE TYPE 

		inner join  co_individual_x_organization_ext NEW_ROLE_EXT	on NEW_ROLE.ixo_key				= NEW_ROLE_EXT.ixo_key_ext
		inner join  mb_member_type NEW_MBT							on NEW_ROLE_EXT.ixo_mbt_key_ext = NEW_mbt.mbt_key 

	where	OLD_ROLE.ixo_end_date < @start_date_ty  --<<< LAST YEARS ROLES  !!!!
		and	NEW_ROLE.ixo_start_date >= @start_date_ty --<<< CURRENT YEARS ROLES !!!!
		and	NEW_ROLE.ixo_end_date > @start_date_ty --<<< CURRENT YEARS ROLES !!!!

		and	OLD_ROLE.ixo_delete_flag = 0
		and	NEW_ROLE.ixo_delete_flag = 0
	
		and	OLD_ROLE_EXT.ixo_status_ext = 'Not Renewed'
		and	NEW_ROLE_EXT.ixo_status_ext = 'Active' 
	
		and OLD_MBT.mbt_code = 'Volunteer' 
		and NEW_MBT.mbt_code = 'Volunteer'

		print 'UPDATED type = 3 ... check and COMMIT ' 
		
	-- commit
	-- rollback 

END 
-------------------------------------------

