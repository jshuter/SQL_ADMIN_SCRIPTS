/* 
select * from co_customer where cst_eml_address_dn = 'klmanuel92@gmail.com'

select * from co_individual_x_organization x where x.ixo_ind_cst_key = '37B4A946-7153-4155-97CE-C994C14C6D09'
order by ixo_rlt_code

select dbo.client_scouts_ixo_training_validate('3BB8E7AF-5528-49D2-B423-22C6193AA505')
*/

-- GROUP COMMISSIONER 
declare @ixo_key varchar(100) = '3BB8E7AF-5528-49D2-B423-22C6193AA505'

	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = 	 case 
	when
	(
	
	-- this goes through and checks if an ixo has an appropriate set of training
	-- ideally compliance report and scorecard should use this
	
	select 
CASE 
	WHEN a01_ogt_sub_type = 'Beaver Colony' THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
	and z01_course_code = 'TMS1/B'
		and z03_completed_flag = 1
	and z03_delete_flag = 0

	)
	WHEN a01_ogt_sub_type = 'Cub Pack' THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
	and z01_course_code = 'TMS1/C'
		and z03_completed_flag = 1
	and z03_delete_flag = 0

	)
		WHEN a01_ogt_sub_type = 'Scout Troop' THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
	and z01_course_code = 'TMS1/S'
		and z03_completed_flag = 1
	and z03_delete_flag = 0

	)
			WHEN a01_ogt_sub_type = 'Venturer Company' THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
	and z01_course_code = 'TMS1/V'
		and z03_completed_flag = 1
	and z03_delete_flag = 0

	)
				WHEN a01_ogt_sub_type = 'Rover Crew' and ixo_rlt_code != 'Rover Scout Participant' THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
	and z01_course_code = 'TMS1/R'
		and z03_completed_flag = 1
	and z03_delete_flag = 0

	)
	-- December 19th - Rover Scout Participants no longer need WB
		WHEN a01_ogt_sub_type = 'Rover Crew' and ixo_rlt_code = 'Rover Scout Participant' THEN 1
	--	
			WHEN (a01_ogt_sub_type = 'Committee' and org_ogt_code = 'Section') THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
		and z03_completed_flag = 1
	and z03_delete_flag = 0
	and z01_course_code in   (
	'ELTMS1/B',
'ELTMS1/V',
'ELTMS1/R',
'ELTMS1/S',
'ELTMS1/C',
'TMS1/G',
'TMS1/ST',
--'TMS1/TRAIN',
'TMS1/V',
'TMSGCT',
'TMS1/B',
'TMS1/R',
'TMS1/C',
'TMS1/S',
 'TMS1/GC' --added Sept 5 2013
	)-- end of list
	
)
	
/*				WHEN a01_ogt_sub_type = 'Service Team' THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
	and z01_course_code = 'TMS1/ST'
	and z03_delete_flag = 0

	)*/  -- you don't need this specific WB for a service team apparently

				WHEN (org_ogt_code = 'Area' or org_ogt_code = 'Council' or org_ogt_code = 'National') THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
		and z03_completed_flag = 1
	and z03_delete_flag = 0
	and z01_course_code in 
	(
	'ELTMS1/B',
'ELTMS1/V',
'ELTMS1/R',
'ELTMS1/S',
'ELTMS1/C',
'TMS1/G',
'TMS1/ST',
--'TMS1/TRAIN',
'TMS1/V',
'TMSGCT',
'TMS1/B',
'TMS1/R',
'TMS1/C',
'TMS1/S'
,
 'TMS1/GC' --added Sept 5 2013
	)-- end of list






	)
		WHEN (org_ogt_code = 'Group' and ixo_rlt_code = 'Group Commissioner') THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
		and z03_completed_flag = 1
	and z03_delete_flag = 0
	and (z01_course_code = 'TMS1/G' or z01_course_code = 'TMSGCT')) 
	-- for group commission
	
	WHEN (org_ogt_code = 'Group' and ixo_rlt_code <> 'Group Commissioner') THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
		and z03_completed_flag = 1
	and z03_delete_flag = 0
	and z01_course_code in 
	(
	'ELTMS1/B',
'ELTMS1/V',
'ELTMS1/R',
'ELTMS1/S',
'ELTMS1/C',
'TMS1/G',
'TMS1/ST',
--'TMS1/TRAIN',
'TMS1/V',
'TMSGCT',
'TMS1/B',
'TMS1/R',
'TMS1/C',
'TMS1/S'
,
 'TMS1/GC' --added Sept 5 2013
	)-- end of list
	)  
WHEN (a01_ogt_sub_type = 'Service Team' and org_ogt_code = 'Section') THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
		and z03_completed_flag = 1
	and z03_delete_flag = 0
	and z01_course_code in   (
	'ELTMS1/B',
'ELTMS1/V',
'ELTMS1/R',
'ELTMS1/S',
'ELTMS1/C',
'TMS1/G',
'TMS1/ST',
--'TMS1/TRAIN',
'TMS1/V',
'TMSGCT',
'TMS1/B',
'TMS1/R',
'TMS1/C',
'TMS1/S'
,
 'TMS1/GC' --added Sept 5 2013
	)-- end of list

) 
	
	WHEN (a01_ogt_sub_type = 'ScoutsAbout' OR a01_ogt_sub_type = 'Extreme Adventure' OR a01_ogt_sub_type = 'Schools And Scouting') THEN (select COUNT(z03_key) from client_scouts_course_catalogue_x_co_customer(nolock)
	inner join client_scouts_course_catalogue(nolock) on z03_z01_key = z01_key
	where z03_cst_key = ind_cst_key
		and z03_completed_flag = 1
	and z03_delete_flag = 0
	and z01_course_code in   (
	'ELTMS1/B',
'ELTMS1/V',
'ELTMS1/R',
'ELTMS1/S',
'ELTMS1/C',
'TMS1/G',
'TMS1/ST',
--'TMS1/TRAIN',
'TMS1/V',
'TMSGCT',
'TMS1/B',
'TMS1/R',
'TMS1/C',
'TMS1/S'
,
 'TMS1/GC' --added Sept 5 2013
	)-- end of list

    )-- 
	
	
-- next is the group comissioner,  then group in general
	--)
	ELSE 1
	END
	
	from 
	co_individual_x_organization(nolock) inner join
	co_individual(nolock)on ind_cst_key = ixo_ind_cst_key inner join
	co_individual_ext(nolock) on ind_cst_key = ind_cst_key_ext inner join
	co_customer(nolock) on ind_cst_key = cst_key inner join
	co_customer_ext(nolock) on cst_key = cst_key_ext inner join
	
	co_organization(nolock) on org_cst_key = ixo_org_cst_key inner join
	co_organization_ext(nolock) on org_cst_key = org_cst_key_ext inner join
	client_scouts_organization_sub_type(nolock) on org_a01_key_ext = a01_key
	where ixo_key = @ixo_key

	
	) > 0 then 1 else 0
	
	
	end

	-- Return the result of the function
	select @Result


