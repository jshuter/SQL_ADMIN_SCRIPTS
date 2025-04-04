
	declare	@codeyear as nvarchar(20) ='2016',						-- MUST be YYYY (End YYYY of a scouting year) 
	@org_cst_key as uniqueidentifier = 'EF33EA2D-3D59-4543-9E52-7B9841A87CA8',	-- key of ORG 
	@format_seasonal_assessment_list as nvarchar(10) = 'brief', 	
	@ind_cst_key as uniqueidentifier = '104BB94D-4A49-4A2E-B4D5-5691FCDC33C6'  

-- select * from co_organization where org_name like '72nd Ottawa%'

-- required params 

	declare @pqs_code as varchar(20) 
	declare @pqs_key as uniqueidentifier 
	declare @SA_codes as varchar(20) 
	declare @yy1 as varchar(2) 
	declare @yy2 as varchar(2) 
	declare @count as int 
	
-- create PQS code ie PQS1516 

	set @yy2 = RIGHT(@codeyear,2) 
	set @yy1 = @yy2 -1 
	
	set @pqs_code = 'PQS' + @yy1 + @yy2 
	set @SA_codes = 'PQS-' + @codeyear + '-%'
	
	select @pqs_key = z04_key from client_scouts_recognition_list where z04_recognition_code = @pqs_code 

-- count number of SA's have been created for this year 

	select @count = COUNT(*) from client_scouts_recognition_list L
		join client_scouts_recognition_list_x_co_customer C
		on l.z04_key = C.z05_z04_key
	where  z04_recognition_code like @SA_codes
			and c.z05_cst_key = @org_cst_key 
	 
-- if SA count >= 3 -- insert new PQS Recognition IFF it DNE yet

	if @count >=2 begin 

		-- does PQSYYYY already exist ? 
		
		select @count = COUNT(*) from client_scouts_recognition_list PQS
			join client_scouts_recognition_list_x_co_customer C
				on c.z05_z04_key = PQS.z04_key
		where  C.z05_cst_key = @org_cst_key -- this ORG 
				and z04_recognition_code = @pqs_code -- and PQS Recognition Award for this year 

		if @count > 0 begin 
			-- THEN DO NOTHING (or display to debug, etc) 
			select 'already exists ' 
		end else begin 
			-- OTHERWISE -- insert new award 
			insert into client_scouts_recognition_list_x_co_customer 
				([z05_key]
				,[z05_z04_key]
				,[z05_cst_key]
				,[z05_recognition_date]
				,[z05_approval_date]
				,[z05_comments]) 
			select  
				NEWID() as [z05_key]
				, @pqs_key as [z05_z04_key]
				, @org_cst_key as [z05_cst_key]
				, getdate() as [z05_recognition_date]
				, GETDATE() as [z05_approval_date]
				, 'Automatically inserted after 3rd Seasonal Assessment is added' as [z05_comments]
				
			select * from client_scouts_recognition_list_x_co_customer
				where z05_z04_key = @pqs_key
				
		end 
		
	end 
