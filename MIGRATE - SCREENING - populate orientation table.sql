/* 

** TO RETEST -- just truncate [client_scouts_volunteer_screening_orientation] 

delete from [client_scouts_volunteer_screening_orientation]


NOTES 

	* this should be run after INTERVIEWS are created !
	* this proc will simply created EXP records for each ROLE that requires one 

*/ 

-------------------------------------------------------------------
-- PART 1 -- create ORIENTATION Roles for non-members that need one 
-------------------------------------------------------------------

-- NO LONGER REQUIRED -- because having an INT satifies the EXP function if EXP is missing 

-- 1 -- INSERT screening org into record for ALL ACTIVE Non Members that need it 

with A as ( -- ALL Non Members ...
	select dbo.client_scouts_requires_EXP(ixo_key) as [EXP]
		, cst_key
		, ixo_ind_cst_key
		, ixo_org_cst_key
		, co_organization_ext.org_screening_cst_key_ext
	from vw_client_scouts_member_roles r
		join co_organization_ext on org_cst_key_ext = ixo_org_cst_key
	where r.ixo_status_ext in('Active')
		and mbt_code = 'Non Member'
)
 
-- ONLY 1588 Non Member Roles
-- 402 / 312 distinct  >> select distinct int,[exp], ixo_ind_cst_key, ixo_org_cst_key, org_screening_cst_key_ext from a
-- 297 -- select distinct ixo_ind_cst_key, org_screening_cst_key_ext from a
-- for 292 distinct INDividuals 

, b as ( 
	select distinct ixo_ind_cst_key, org_screening_cst_key_ext 
	from a
	where a.EXP = 0 
) 

--- NOTE That requires_EXP will return 1 if INT exists 
--- so these are only from the Roles that are missing 
--- both INTs and EXPs

insert into client_scouts_volunteer_screening_orientation (
	z28_key
	, z28_ind_cst_key
	, z28_org_cst_key
	, z28_ortn_performed_by
	, z28_ortn_performed_on
	, z28_add_user)

select newid()  
	, b.ixo_ind_cst_key
	, b.org_screening_cst_key_ext 
	, 'Interview Existed'
	, getdate()
	, 'July 2018 System Update'
from b

select * from client_scouts_volunteer_screening_orientation
order by z28_add_date desc 



--------------------------------------------------------------------
--- check for duplicates 
--------------------------------------------------------------------

with dupcheck as ( 
	select count(*) c, z28_ind_cst_key, z28_org_cst_key 
	from client_scouts_volunteer_screening_orientation
	group by z28_ind_cst_key, z28_org_cst_key 
) select * from dupcheck where c > 1 


/*

SINCE ALL roles that required EXP were given one (see above) we should be 100% done now !!

OLD CODE FOLLOWS 


-----------------------------------------------------------------
-- PART 2 -- remaining NON MEMBERS -- without INT 
-----------------------------------------------------------------

with a as (
	select dbo.client_scouts_requires_EXP(ixo_key) as [EXP]
	, ixo_rlt_code
	, ixo_mbt_key_ext
	, org_ogt_code
	, cst_key, ixo_ind_cst_key, ixo_org_cst_key, org_screening_cst_key_ext
	from vw_client_scouts_member_roles r
		left join client_scouts_volunteer_screening(nolock) as interviews 	
			on interviews.z21_ind_cst_key_1 = r.ixo_ind_cst_key
	where r.ixo_status_ext in ('Active') -- 196 ACTIVE -- 1043 Pending 
	and mbt_code = 'Non Member'
	and z21_key is null 
) 
select * from a
order by ixo_rlt_code 

**/ 





/*********


	ADDITIONAL CODE -- started to duplicate what was created above !


-- Script to insert all required EXP records -- 
-- If member has an Active NON MEMBER Role that requires an EXP - they will be given the EXP record as part of the implemtnation
-- IF Member Has a PENDING role that requires EXP - it will become a non-compliant item in the Requies String & Reports 
-- NOTE -- EXP is not requied if INTerviews have been passed by the member ...  
-- 1500 

with ind_screening_org as ( 
	select distinct ixo_ind_cst_key, org_screening_cst_key_ext
	from vw_client_scouts_member_roles R
	where ixo_status_ext in ('Pending', 'Active')
	and mbt_code = 'Non Member'				-- MUST RUN AFTER Parent >> NON MEMBER !!!!!!
)

select * from ind_screening_org R -- unique Screening Orgs for each IND 
	join client_scouts_volunteer_screening_orientation EXP 
		on exp.z28_org_cst_key = r.org_screening_cst_key_ext
			and exp.z28_ind_cst_key = r.ixo_ind_cst_key


-- select * from client_scouts_volunteer_screening_orientation -- 320 -- 317 unique ind/org entries 

*********/ 

