/* 

-- WHEN TESTING --- UNDO all interview and references -- IT IS SAFE (until Production)

	-- GET COUNTS --

	select count(*) from client_scouts_volunteer_screening where z21_org_cst_key is not null 
	-- 22,819 NOT NULL after update 

	select count(*) from client_scouts_volunteer_screening where z21_add_user = 'Screening Update 2018'
	--  4, 816 rows inserted !

	--------------------------------------	
	-- REMOVE - UNDO updates 
	--------------------------------------	

	delete from client_scouts_volunteer_screening where z21_add_user = 'Screening Update 2018'

	update interviews set 
		z21_org_cst_key = NULL
		,z21_change_user = NULL
	from client_scouts_volunteer_screening interviews
	where z21_org_cst_key is not null 

*/

/* WHAT IT DOES

1. Associate org to interviews

2. Create new interviews with Uncertain and Migrate Data for all other roles

SCOPE: Affect all Active or Pending Volunteer, Participant and Employees Roles

*/

-- 1.	Associate Organization to all existing interviews (only for primary role). 
--		The other interviews will be associated in Step 2.
--		~ 129 840 interviews 
--		22,819 updated when ALL Active/Pending Roles are included

---------------------------------------------------------------------

declare @age18_dob date = DATEADD(YEAR,-18, GETDATE()) 

update interviews set 
	z21_org_cst_key = org_screening_cst_key_ext
	,z21_change_user = 'Screening Update 2018'

-- declare @age18_dob date = DATEADD(YEAR,-18, GETDATE()) ; select org_screening_cst_key_ext, ixo_ind_cst_key

from client_scouts_volunteer_screening interviews -- this may return duplicates, so need to be handled below
	join co_customer on cst_key = interviews.z21_ind_cst_key_1
	join co_individual on ind_cst_key = cst_key
	join co_individual_x_organization on cst_ixo_key = ixo_key -- DO NOT REMOVE: primary role, the only way
	join co_individual_x_organization_ext on ixo_key_ext = ixo_key and ixo_status_ext in ( 'Active', 'Pending')
	join mb_member_type on ixo_mbt_key_ext = mbt_key
	join co_organization_ext screening_orgs on screening_orgs.org_cst_key_ext = ixo_org_cst_key

where cst_delete_flag = 0
	and ixo_delete_flag = 0
	and z21_org_cst_key IS NULL 

-----------------------------------------------------------------------------------------

-- 2. 
--  Create new interviews for non-primary roles and associate to a organization
--  If entry (same interview, org and individual) already exist. Does not insert.
--  ~ 9,938 interviews

; with INTERVIEWS
AS
(
select
	distinct
	z21_ind_cst_key_1			= ind_cst_key, 
	z21_appropriate				= 'N/A',
	z21_appropriate_comment		= 'See Interview on Primary Role. Update created this record to reflect that Interview existed on Primary Role.',
	z21_challengingprograms		= 'N/A',
	z21_activeexpression		= 'N/A',
	z21_outdoorprogramming		= 'N/A',
	z21_personaldevelopment		= 'N/A',
	z21_rolemodel				= 'N/A',
	z21_sla						= 'N/A',
	z21_honest					= 'N/A',
	z21_childprotection			= 'N/A',
	z21_acceptable_flag			= 1,
	z21_add_user				= 'Screening Update 2018',
	screening_orgs.org_screening_cst_key_ext	

from co_individual_x_organization
	join co_individual_x_organization_ext on ixo_key_ext = ixo_key
	join mb_member_type on ixo_mbt_key_ext = mbt_key
	join co_individual on ind_cst_key = ixo_ind_cst_key
	join co_customer on cst_key = ind_cst_key 
	join co_organization_ext screening_orgs on org_cst_key_ext = ixo_org_cst_key -- for screening_cst_key! (ie. parent if section) cst_key

	-- existing interviews with no group associated to it
	left join client_scouts_volunteer_screening
					on z21_ind_cst_key_1 = ind_cst_key -- ind 
					and z21_org_cst_key = screening_orgs.org_screening_cst_key_ext -- org 
					and z21_delete_flag = 0

where z21_org_cst_key is null
	and ind_delete_flag = 0
	and ixo_delete_flag = 0
	and ixo_status_ext in ( 'Active', 'Pending') 

	and cst_ixo_key != ixo_key	-- ALL NON PRIMARY ! 
								-- These should anyhow be excluded because z21_org_cst_key 
								-- will NOT be NULL for Primary ... 									
)

-- insert from CTE
insert into client_scouts_volunteer_screening (
	z21_ind_cst_key_1,
	z21_appropriate				,
	z21_appropriate_comment		,
	z21_challengingprograms		,
	z21_activeexpression		,
	z21_outdoorprogramming		,
	z21_personaldevelopment		,
	z21_rolemodel				,
	z21_sla						,
	z21_honest					,
	z21_childprotection			,
	z21_acceptable_flag			,
	z21_add_user				,
	z21_org_cst_key				
)
select 
	z21_ind_cst_key_1, 
	z21_appropriate				,
	z21_appropriate_comment		,
	z21_challengingprograms		,
	z21_activeexpression		,
	z21_outdoorprogramming	,
	z21_personaldevelopment	,	
	z21_rolemodel			,	
	z21_sla					,	
	z21_honest		,
	z21_childprotection	,
	z21_acceptable_flag	,
	z21_add_user		,
	org_screening_cst_key_ext	
from INTERVIEWS


-- commit