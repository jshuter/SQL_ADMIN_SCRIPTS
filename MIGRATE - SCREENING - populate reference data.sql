/*

	Insert new JOIN Table :  REFERENCE x ORGANIZATION 

	SCOPE: Affect all Active or Pending Volunteer, Participant and Employees Roles
	
	Ran on 7/11/2018 on staging


	-- TO RESTART TESTING - clean up data 

	select count(*) from client_scouts_volunteer_screening_reference_x_co_organization

	delete from client_scouts_volunteer_screening_reference_x_co_organization


*/

declare @age18_dob date = DATEADD(YEAR,-18, GETDATE())

select @age18_dob 

-- A. Populate ReferenceXOrgs. Only associate all Pass references
-- Multiple Run is OK.
-- ~73, 583 references


-- ** STEP 1 ** // Insert MISSING rows -- all except Participants 

insert into client_scouts_volunteer_screening_reference_x_co_organization(z27_z22_key, z27_org_cst_key, z27_add_user)

-- 1 entry per reference per group organization. If entry (same ref and orgs) already exist. Does not insert.

select distinct z22_key
	, screening_orgs.org_screening_cst_key_ext		-- if org is a Section, set the org key to a Group Level
	, 'Screening Update 2018'						-- for easier testing, hardcoded this value

from co_individual_x_organization(nolock) 
	join co_individual_x_organization_ext(nolock)  on ixo_key_ext = ixo_key 
	join co_organization(nolock)  on org_cst_key = ixo_org_cst_key
	join co_organization_ext(nolock)  screening_orgs on org_cst_key_ext = ixo_org_cst_key
	join mb_member_type(nolock)  on ixo_mbt_key_ext = mbt_key
	join co_individual(nolock)  on ind_cst_key = ixo_ind_cst_key
	join client_scouts_volunteer_screening_reference(nolock)  on z22_ind_cst_key = ind_cst_key
	left join client_scouts_volunteer_screening_reference_x_co_organization(nolock) RefXOrgs 
		on RefXOrgs.z27_org_cst_key = org_screening_cst_key_ext
			and RefXOrgs.z27_z22_key = z22_key
			and RefXOrgs.z27_delete_flag = 0 
where  mbt_code in ('Volunteer','Employee','Non Member') 
	and ixo_status_ext in ( 'Active', 'Pending')
	and ( z22_status = 'Pass' 
			or (z22_status in ('New' , 'In Progress')  AND z22_add_date > dateadd(D, -40, getdate()) ) 
		) 
	and RefXOrgs.z27_key is null 
	and z22_delete_flag = 0
	and ind_delete_flag = 0
	and ixo_delete_flag = 0
	and org_delete_flag = 0



select count(*) from client_scouts_volunteer_screening_reference_x_co_organization

-- 71,982 inserted 

-----------------------------------------
--- PARTICIPANTS ARE A SEPARATE STEP ---- 
-----------------------------------------

select count(*) before from client_scouts_volunteer_screening_reference_x_co_organization

; with participant_data as ( 

	select distinct z22_key 
		, screening_orgs.org_screening_cst_key_ext		-- if org is a Section, set the org key to a Group Level
		, 'Screening Update 2018' as add_user						-- for easier testing, hardcoded this value
		, dbo.client_scouts_requires_REF(ixo_key) as [REF] 

	from co_individual_x_organization(nolock) 
		join co_individual_x_organization_ext(nolock)  on ixo_key_ext = ixo_key 
		join co_organization(nolock)  on org_cst_key = ixo_org_cst_key
		join co_organization_ext(nolock)  screening_orgs on org_cst_key_ext = ixo_org_cst_key
		join mb_member_type(nolock)  on ixo_mbt_key_ext = mbt_key
		join co_individual(nolock)  on ind_cst_key = ixo_ind_cst_key
		join client_scouts_volunteer_screening_reference(nolock)  on z22_ind_cst_key = ind_cst_key
		left join client_scouts_volunteer_screening_reference_x_co_organization(nolock) RefXOrgs 
			on RefXOrgs.z27_org_cst_key = org_screening_cst_key_ext
				and RefXOrgs.z27_z22_key = z22_key
				and RefXOrgs.z27_delete_flag = 0 
	where  mbt_code in ('Participant') 
		and ixo_status_ext in ( 'Active', 'Pending')
		and ( z22_status = 'Pass' 
				or (z22_status in ('New' , 'In Progress')  AND z22_add_date > dateadd(D, -40, getdate()) ) 
			) 
		and RefXOrgs.z27_key is null 
		and z22_delete_flag = 0
		and ind_delete_flag = 0
		and ixo_delete_flag = 0
		and org_delete_flag = 0
) 

insert into client_scouts_volunteer_screening_reference_x_co_organization(z27_z22_key, z27_org_cst_key, z27_add_user)
select pd.z22_key
	, pd.org_screening_cst_key_ext
	, pd.add_user 
from participant_data pd
where [REF] = 0 

select count(*) after from client_scouts_volunteer_screening_reference_x_co_organization

/*** 

Final test 

1 - delete new data -- prepare for reload !

	delete from client_scouts_volunteer_screening_reference_x_co_organization
	
	75,492 deleted 

2 - insert non participant 

3 - insert participant 

*/ 

