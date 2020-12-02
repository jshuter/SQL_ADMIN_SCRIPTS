create procedure #create_course_date(

	@z01_course_code varchar(30),
	@z01_course_name varchar(100),
	@z06_external_code_EN varchar(20),
	@z06_external_code_FR  varchar(20), 
	@add_to_existing bit = 0 -- change to 1 to allow New Externals to an Existing Course 
) 
AS

BEGIN 

	declare  @z01_key uniqueidentifier = NULL  

	-------------------------------------------------
	-- Insure that course does not alredy exist !
	-------------------------------------------------

	if @add_to_existing = 0 begin 
		if exists(select * from client_scouts_course_catalogue where z01_course_code = @z01_course_code) begin 
			select '***WARNING*** COURSE CODE AREADY EXISTS'		
			select * from client_scouts_course_catalogue where z01_course_name = @z01_course_name 		
			return
		end else begin 
			set @z01_key = newid()
		end 
	end else begin -- assume 1 -- Expect code to exist 
		select @z01_key = z01_key  from client_scouts_course_catalogue where z01_course_code = @z01_course_code
		if @z01_key IS NULL begin 
			select '***WARNING*** DID NOT FIND COURSE CODE'
			return 
		end
	end 

	if exists(select * from client_scouts_course_catalogue_x_external 
				where z06_external_code in (@z06_external_code_EN,@z06_external_code_FR) ) begin 
		select '***WARNING*** EXTERNAL CODE AREADY EXISTS'
		select * from client_scouts_course_catalogue_x_external where z06_external_code in (@z06_external_code_EN,@z06_external_code_FR)
		return 
	end 

	-----------------------------------
	-- CREATE NEW ROWS 	
	-----------------------------------

	if @add_to_existing = 0 begin -- 
		insert into client_scouts_course_catalogue(z01_key,z01_course_code,z01_course_name,z01_description,z01_milestone_flag,z01_accredited_flag) 
		values(@z01_key,@z01_course_code,@z01_course_name,'Add description',0,0)  
	end 
	
	insert client_scouts_course_catalogue_x_external (z06_key, z06_z01_key, z06_language, z06_system , z06_external_code) 
	Values(NEWID(),@z01_key,'English','LMS',@z06_external_code_EN)  

	insert client_scouts_course_catalogue_x_external (z06_key, z06_z01_key, z06_language, z06_system , z06_external_code) 
	Values(NEWID(),@z01_key,'French','LMS',@z06_external_code_FR)  

	select *  from client_scouts_course_catalogue where z01_key = @z01_key

	select *  from client_scouts_course_catalogue_x_external 
	where z06_z01_key = @z01_key order by z06_add_date desc 

end 

GO 

--exec  #create_course_date 'CP-Wood-Badge-1','Wood Badge 1', '6536','6536'

/* 
exec  #create_course_date 'CP-Spirit','How to Incorporate Spirituality', '6533','6533'
exec  #create_course_date 'CP-Adv'   ,'How to Facilitate Adventure','6532','6532'
exec  #create_course_date 'CP-BalPr' ,'How to Facilitate a Balanced Program','6528','6528'
exec  #create_course_date 'CP-Prog'  ,'Understanding Personal Progression','6534','6534'
exec  #create_course_date 'CP-OAS'   ,'How to Facilitate Outdoor Adventure Skills','6512','6512'
exec  #create_course_date 'CP-Meet'  ,'How to Facilitate a Meeting','6535','6535'
exec  #create_course_date 'CP-Badge' ,'How to Incorporate Badges','6522','6522'
exec  #create_course_date 'CP-Camp'  ,'How to Take Youth Camping','6514','6514'
exec  #create_course_date 'CP-Ptrl'  ,'How to Use the Patrol System','6526','6526'
exec  #create_course_date 'CP-STEM'  ,'What is STEM?','6527','6527'
exec  #create_course_date 'CP-EngPar','How to Engage Parents','6530','6530'
exec  #create_course_date 'CP-Fund'  ,'How to Fund the Program','6529','6529'
exec  #create_course_date 'CP-SLT'   ,'How to Work with the Section Leadership Team','6531','6531'
exec  #create_course_date 'CP-P4YL'  ,'How to Plan for Youth-Led','6506','6506'
exec  #create_course_date 'CP-PQS'   ,'How to Use the Program Quality Standards','6511','6511'
exec  #create_course_date 'CP-F'     ,'Canadian Path Fundimentals','6417','6417'

-- NOV 4 2016 

exec  #create_course_date 'WB1mod1/AS','ZZZ Already Exsists','6557','6558', 1

-- Jan 2017 

exec  #create_course_date 'CYS-CJ-17','CYS Training for CJ’17 Youth OOS','6573','6575', 1

*/


select * from client_scouts_course_catalogue where z01_add_date > '2016-09-15' 
order by z01_add_date

select * from client_scouts_course_catalogue_x_external where z06_add_date > '2016-09-15' 
order by z06_add_date

select * from client_scouts_course_catalogue where z01_key = '930BC5A4-447A-4127-8946-D52EB553FB95'

select * from client_scouts_course_catalogue_x_external where z06_z01_key = '930BC5A4-447A-4127-8946-D52EB553FB95'



