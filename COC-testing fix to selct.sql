/* cleanup !

	SELECT COUNT(*) from client_scouts_code_of_conduct_x_co_individual where z24_z23_key = 'F9DE7BDE-91CC-4A9A-81BC-8FB352AA881F'
	select z23_key from client_scouts_code_of_conduct where z23_version = '2015_2016'
	DELETE from client_scouts_code_of_conduct_x_co_individual where z24_z23_key = 'F9DE7BDE-91CC-4A9A-81BC-8FB352AA881F'
	select z23_key from client_scouts_code_of_conduct where z23_version = '2015_2016'
	SELECT COUNT(*) from client_scouts_code_of_conduct_x_co_individual where z24_z23_key = 'F9DE7BDE-91CC-4A9A-81BC-8FB352AA881F'
*/	

	-- 4033 rows - accumulated from initial testing 
	-- 2837 with old YOS < 2
	-- 2192 with new rules for Parents and Participants > 17 -- EXPECTING subset of initial rows 
	
	
	declare @date_threshold as date = '2015-05-01'			-- Any OLD COC's signed after this date get PASS on NEW COC 
	declare @admins_cst_key as uniqueidentifier = NULL		-- KEY used for coc_x_individual - entry_by ... 
	declare @old_version as varchar(50) = '2014_2015'		-- Z23_VERSION of old COC
	declare @new_version as varchar(50) = '2015_2016'		-- Z23_VERSION of old COC

	set @admins_cst_key = (select cst_key from co_customer where cst_eml_address_dn = 'jeffrey.shuter@scouts.ca') 

	/** CREATE 'Acceptance' Record **/ 
	
	INSERT INTO client_scouts_code_of_conduct_x_co_individual
	(z24_key,z24_ind_cst_key, z24_entry_ind_cst_key,z24_z23_key,z24_add_user) 

	select newid(), indext1.ind_cst_key_ext, @admins_cst_key

		,(select z23_key from client_scouts_code_of_conduct where z23_version = @new_version)
		,'sys admin'

	from client_scouts_code_of_conduct_x_co_individual 
		join co_individual_ext indext1 on indext1.ind_cst_key_ext = z24_ind_cst_key
		join co_individual ind1 on ind1.ind_cst_key = indext1.ind_cst_key_ext
		
	where indext1.ind_status_ext in ('Active','Pending','Not Renewed') 
		and z24_z23_key = (select z23_key from client_scouts_code_of_conduct where z23_version = @old_version ) 
		and z24_add_date >= @date_threshold  
		-- Limit to NEW MEMBERS -- 1 implies New Volunteer / 0 implies Non-Volunteer - Youths with Accounts ? 
		
		AND
		
		-- dbo.client_scouts_years_in_scouting(ind_cst_key_ext) < 2  

		-- YEARS OF SERVICE == 1 
		-- BUT PARTICIPANTS MUST BE > 17 YO 
		
		(SELECT COUNT(DISTINCT ScoutingPeriod) 
		
			 FROM  (SELECT ScoutingPeriod =  [dbo].[client_scouts_get_scouting_period](ixo_start_date, ixo_end_date, '-')
						FROM co_individual_x_organization(nolock) AS x 
						INNER JOIN co_individual_x_organization_ext(nolock) on x.ixo_key = ixo_key_ext
						INNER JOIN mb_member_type(nolock) on ixo_mbt_key_ext = mbt_key
						INNER JOIN co_individual ind2 (nolock) on IND2.ind_cst_key = x.ixo_ind_cst_key
						WHERE ixo_delete_flag = 0
							AND (mbt_code = 'Volunteer' 
									OR mbt_code = 'Employee' 
									OR mbt_code = 'Parent'
									OR (mbt_code = 'Participant' AND IND2.ind_age_cp > 17) 
							) 
							AND x.ixo_ind_cst_key = ind1.ind_cst_key                                                    
							AND x.ixo_start_date <= GETDATE()
							) AS innerYISTbl                                                      
		)  =  1

		
		-- >>> CODE moved into field list 
		

		-- Replace standard Years-Of_Service with Modified Code 
		-- so that Participants are Not included, but Parents Are 
		
		-- Exclude any that have already signed the NEW COC ** 

		and ind_cst_key_ext not in (select z24_ind_cst_key 
										from  client_scouts_code_of_conduct_x_co_individual cxi_new 
											join client_scouts_code_of_conduct coc_new
												on cxi_new.z24_z23_key = coc_new.z23_key
										where coc_new.z23_version = @new_version) 		

		and NOT (	ind_delete_flag = 1
					or isnull(ind_suspended_flag_ext ,0) = 1 
					or ind_deceased_flag = 1)

