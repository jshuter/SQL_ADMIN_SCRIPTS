USE [netForumSCOUTSTest]
GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_approval_list_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Select list of Reviewers of request
-- =============================================

/* 
	test with 
	-- finds NO DATA  
	exec [client_scouts_discount_approval_list_xweb] '96641F49-D4EB-4205-9B49-2F6549F1BF99'

	-- finds data (during testing) 
	exec [client_scouts_discount_approval_list_xweb] 'A2AEE823-C5F1-415B-9107-173E041F6AB7'


*/

CREATE PROCEDURE [dbo].[client_scouts_discount_approval_list_xweb] 

	@request_key as av_key = NULL 

AS
BEGIN

	select apr.z81_status, 
			apr.z81_add_date, 
			cust.cst_ind_full_name_dn , 
			apr.z81_approved_by
	from client_scouts_discount_approval apr
		inner join co_customer cust on cust.cst_key = apr.z81_approver_cst_key 
	where apr.z81_discount_request_key = @request_key 
		and z81_delete_flag = 0 
	order by apr.z81_add_date desc 
	
	for xml path('approval'), elements xsinil, type, root('approvals')
	
--	select 'didnt find nothing'
	
END


GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_list_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =================================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Select list of Discounts of request
-- =================================================

/* 
	PARAMS 
	
		format_xml [0|1]	1 -> XML  (DEFAULT) 
							0 -> regular query 



	TESTS 
	
	-- finds NO DATA  
	exec [client_scouts_discount_list_xweb] '96641F49-D4EB-4205-9B49-2F6549F1BFAA'

	-- finds data (during testing) 

	-- TESTS FOR XML 	
	exec [client_scouts_discount_list_xweb] 'request', '227AC9B6-5106-4E28-8962-231181A7F736', 'all'		
	exec [client_scouts_discount_list_xweb] 'cst', '3E634364-A0C9-4A01-9581-51144777B2CB', 'all' 
	exec [client_scouts_discount_list_xweb] 'request', '227AC9B6-5106-4E28-8962-231181A7F736', 'available'
	exec [client_scouts_discount_list_xweb] 'cst', '3E634364-A0C9-4A01-9581-51144777B2CB', 'available' 

	-- TESTS - SIMPLE TABLE 
	exec [client_scouts_discount_list_xweb] 'request', '227AC9B6-5106-4E28-8962-231181A7F736', 'all'		
	,@return_xml=0
	exec [client_scouts_discount_list_xweb] 'cst', '3E634364-A0C9-4A01-9581-51144777B2CB', 'all' 
	,@return_xml=0
	exec [client_scouts_discount_list_xweb] 'request', '227AC9B6-5106-4E28-8962-231181A7F736', 'available'
	,@return_xml=0
	exec [client_scouts_discount_list_xweb] 'cst', '3E634364-A0C9-4A01-9581-51144777B2CB', 'available' 
	,@return_xml=0


	-- select * from client_scouts_discount order by z80_add_date 
	
*/

-- TODO : FIX 2 queries - to get to list from either REQUEST - OR CST 

-- TODO : allow selection of status -- new / used / expired


CREATE PROCEDURE [dbo].[client_scouts_discount_list_xweb] 

	@fktype as varchar(10) = NULL,		-- 'cst' -> INDIVIDUAL's cst_key 
										-- 'request' -> DISCOUNT_REQUEST processed to get this key (which also has the CST_KEY ?? 
	@key as av_key = NULL, 
	@status as varchar(10) = 'all',		-- option 'all' simply returns all 
										-- option 'available' return all that are not USED nor EXPIRED 
	@return_xml bit	= 1					-- allow user to remove default 'XML' output formating
										

AS
BEGIN

	SET NOCOUNT ON 

	-- 1 - create #tmp_discount that can be used in multiple queries 
	-- SP does not allow insert into to use the same #table more than once !
	
	select top 1 d.z80_key, 
				d.z80_expiry_date, 
				d.z80_discount_type, 
				d.z80_discount_amount,
				d.z80_discount_unit, 
				d.z80_date_used, 
				d.z80_cancelled_flag, 
				d.z80_prc_key,
				p.prc_price,
				p.prc_percent
				
	into #tmp_discounts 

	from client_scouts_discount as d
		left outer join oe_price P 
			on z80_prc_key = p.prc_key
	
	-- 2 - clear table for real results 
	
	truncate table #tmp_discounts
	

	-- BEGIN MAIN SELECT
	
	if @status='all' begin 
			
		if @fktype = 'cst' begin

			insert into #tmp_discounts 
			
			select d.z80_key, 
				d.z80_expiry_date, 
				d.z80_discount_type, 
				d.z80_discount_amount,
				d.z80_discount_unit, 
				d.z80_date_used, 
				d.z80_cancelled_flag,
				d.z80_prc_key ,
				op.prc_price ,
				op.prc_percent
				
			from client_scouts_discount_request as req
				join client_scouts_discount as d
					on d.z80_discount_request_key = req.z78_key 
				join oe_price op 
					on d.z80_prc_key = op.prc_key
			where z78_cst_key = @key 
				and z80_delete_flag = 0 
				and z80_cancelled_flag = 0 
				
		end
		
		if @fktype = 'request' begin 
		
			insert into #tmp_discounts 

			select d.z80_key, 
				d.z80_expiry_date, 
				d.z80_discount_type, 
				d.z80_discount_amount,
				d.z80_discount_unit, 
				d.z80_date_used, 
				d.z80_cancelled_flag,
				d.z80_prc_key,
				op.prc_price,
				op.prc_percent
							
			from client_scouts_discount_request as req
				join client_scouts_discount as d
					on d.z80_discount_request_key = req.z78_key 
				join oe_price op 
					on d.z80_prc_key = op.prc_key
			where z78_key = @key 
				and z80_delete_flag = 0 
				and z80_cancelled_flag = 0 

		end

	end 
	
	if @status='available' begin 
	
		-- limit to specific status (ie to get all available) 
		
		if @fktype = 'cst' begin

			insert into #tmp_discounts 

			select d.z80_key,
				d.z80_expiry_date, 
				d.z80_discount_type, 
				d.z80_discount_amount,
				d.z80_discount_unit, 
				d.z80_date_used, 
				d.z80_cancelled_flag, 
				d.z80_prc_key,
				op.prc_price,
				op.prc_percent
			
			from client_scouts_discount_request as req
				join client_scouts_discount as d
					on d.z80_discount_request_key = req.z78_key 
				join oe_price op 
					on d.z80_prc_key = op.prc_key
			where z78_cst_key = @key 
				and d.z80_delete_flag = 0 
				and d.z80_expiry_date > dateadd(DAY,1,GETDATE()) 
				and d.z80_date_used IS NULL 
				and d.z80_cancelled_flag = 0 
		
		end
		
		if @fktype = 'request' 
		
			insert into #tmp_discounts 

			select d.z80_key, 
				d.z80_expiry_date, 
				d.z80_discount_type, 
				d.z80_discount_amount,
				d.z80_discount_unit, 
				d.z80_date_used, 
				d.z80_cancelled_flag, 
				d.z80_prc_key,
				op.prc_price,
				op.prc_percent

			from client_scouts_discount_request as req
				join client_scouts_discount as d
					on d.z80_discount_request_key = req.z78_key 
				join oe_price op 
					on d.z80_prc_key = op.prc_key
			where z78_key = @key 
				and z80_delete_flag = 0 
				and d.z80_expiry_date > dateadd(DAY,1,GETDATE()) 
				and d.z80_date_used IS NULL 
				and d.z80_cancelled_flag = 0 
		
		end
 		
	-- results formatting 
	
	if @return_xml = 1 begin 
		select * 
		from #tmp_discounts 
		for xml path('discount'), elements xsinil, type, root('discounts')
	end else begin 
		select * 
		from #tmp_discounts 
	end 
	
END


GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_oprice_list_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =================================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Simple List of DISCOUNTS and VALUES 
-- =================================================

/* 
	PARAMS 

	@product_code - this is the product code which may have 1 or more variations attached to it, IE, $Value of discount
	
	TEST 
	
		exec [client_scouts_discount_oprice_list_xweb] @product_code = 'NOLB'

*/

CREATE PROCEDURE [dbo].[client_scouts_discount_oprice_list_xweb] 

	@product_code as varchar(10) 

AS
BEGIN

	SET NOCOUNT ON 

	SELECT oprice.prc_key, oprice.prc_code, oprice.prc_price , oprice.prc_percent FROM oe_product oprod
		INNER JOIN oe_price oprice ON oprice.prc_prd_key = oprod.prd_key
	WHERE oprod.prd_code = @product_code 
		AND oprice.prc_delete_flag = 0
		AND (oprice.prc_start_date IS NULL OR oprice.prc_start_date <= GETDATE())
		AND (oprice.prc_end_date IS NULL OR oprice.prc_end_date >= GETDATE())
		order by prc_code 
	for xml path('oprice'), elements xsinil, type, root('oprices') 
	
END



GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_request_add_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Handles INSERT for discount_request table 
-- =============================================

/* 

	test with 
	-- test 1 -- trap error 
	
	exec client_scouts_discount_request_add_xweb

	-- test 2 -- create new request (with minimum required values) 

	-- TEST WITH INVALID KEY 
	exec client_scouts_discount_request_add_xweb
		@cst_key = '3E634364-A0C9-4A01-9581-51144777B2CB',
		@family_income=44444, 
		@child_count=3, 
		@org_key = 'AAAAAA'


	-- test with VALID GROUP KEY 
	exec client_scouts_discount_request_add_xweb
		@cst_key = '3E634364-A0C9-4A01-9581-51144777B2CB',
		@family_income=2, 
		@child_count=3, 
		@org_key = 'F76F347D-A393-4BBF-A59B-0006BBA34DDA'

	select * from client_scouts_discount_request order by z78_add_date desc 


	-- test with VALID COUNCIL  KEY 
	
	exec client_scouts_discount_request_add_xweb
		@cst_key = '3E634364-A0C9-4A01-9581-51144777B2CB',
		@family_income=1, 
		@child_count=3, 
		@org_key = 'BBA3C956-4171-4868-9C9C-01AF8A73E342'
	
	select * from client_scouts_discount_request order by z78_add_date desc 


*/

CREATE PROCEDURE [dbo].[client_scouts_discount_request_add_xweb] 
	@cst_key as varchar(36)=null,
	@family_income int=null, 
	@family_size smallint=null,
	@child_count smallint=null, 
	@org_key varchar(36), 
	@debug bit = 0 
AS
BEGIN

	declare @newkey as varchar(36) 
	declare @council_key as varchar(36) = NULL -- default for INSERT 
	declare @group_key as varchar(36) = NULL -- default for INSERT 
	
	set @newkey = NEWID()

	-- is the @council_key from COUNCIL or GROUP ? 
	if exists(select * from co_organization where org_cst_key = @org_key and org_ogt_code = 'council') begin 
		set @council_key = @org_key
	end else begin 
		-- looking up hierarchy for Council 
		set @group_key = @org_key
		set @council_key = dbo.client_scouts_get_parent_org_by_type (@group_key, 'council')
	end 

	if (@debug =1) begin 
	
		select @group_key , @council_key
		
	end 
	
	begin try 
	
		insert into dbo.client_scouts_discount_request(
			z78_key,
			z78_family_income, 
			z78_family_size, 
			z78_child_count,
			z78_cst_key,
			z78_council_key,
			z78_group_key,
			z78_status)
		values (
			@newkey,
			@family_income,
			@family_size,
			@child_count,
			@cst_key,
			@council_key,
			@group_key,
			'new')

		 -- return the new row 		 
		 exec [client_scouts_discount_request_form_get_xweb] @newkey
		 
		 return 
			
	end try 
	begin catch 
		
		 -- add error info in response ?
		 select 'false' as answer for xml path('responses'), elements xsinil, type, root('response')
		 return 
		 
	end catch 
	
END


GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_request_form_get_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Handles DATA for discount_request form
-- selects either [a] an existing DISCOUNT_REQUEST or 
--                [b] individual data - based on CST_KEY 
-- =============================================

/* 
test 
	exec [client_scouts_discount_request_get_xweb] 'A2AEE823-C5F1-415B-9107-173E041F6AB7'
*/

CREATE PROCEDURE [dbo].[client_scouts_discount_request_form_get_xweb] 

	@key as uniqueidentifier = NULL,     
	@cst_key as uniqueidentifier = NULL  -- 
	
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- verify that key exists -- 
	
	--	if exists(select z78_key from client_scouts_discount_request where z78_key = @key) begin 
	if (@key is NULL) begin 
	
		-- assume cst_key is being passed (since one is required) 
	
			select 
				IND.ind_gender,
				IND.ind_first_name,	
				IND.ind_last_name ,
				IND.ind_dob,
				EXT.ind_primary_lang_spoken_ext,
				EXT.ind_status_ext,
				CST.cst_eml_address_dn,
				CST.cst_key,
				CST.cst_recno,
				ADR.adr_line1,
				ADR.adr_line2,
				ADR.adr_line3,
				ADR.adr_city,
				ADR.adr_state,
				ADR.adr_post_code,
				PH.cst_evening_phone_ext ,
				PH.cst_other_phone_ext,
				PH.cst_daytime_phone_ext,
				PH.cst_fax_ext,
				'' as z78_key, 
				'' as z78_cst_key, 
				'' as z78_status, 
				'' as z78_family_income, 
				'' as z78_family_size, 
				'' as z78_child_count,
				'' as z78_council_key
			from  co_customer as CST 
				inner join co_individual as IND on IND.ind_cst_key = CST.cst_key
				inner join co_individual_EXT as EXT on EXT.ind_cst_key_ext = CST.cst_key
				inner join co_address as ADR on ADR.adr_cst_key_owner = CST.cst_key  
				inner join co_customer_ext as PH on PH.cst_key_ext = CST.cst_key
			where cst_key = @cst_key
			for xml path('row'), elements xsinil, type, root('discount_request')
	
	end else begin 
	
			select 
				IND.ind_gender,
				IND.ind_first_name,	
				IND.ind_last_name ,
				IND.ind_dob,
				EXT.ind_primary_lang_spoken_ext,
				EXT.ind_status_ext,
				CST.cst_eml_address_dn,
				CST.cst_key,
				CST.cst_recno,
				ADR.adr_line1,
				ADR.adr_line2,
				ADR.adr_line3,
				ADR.adr_city,
				ADR.adr_state,
				ADR.adr_post_code,
				PH.cst_evening_phone_ext ,
				PH.cst_other_phone_ext,
				PH.cst_daytime_phone_ext,
				PH.cst_fax_ext,
				REQ.z78_key, 
				REQ.z78_cst_key, 
				REQ.z78_status, 
				REQ.z78_family_income, 
				REQ.z78_family_size, 
				REQ.z78_child_count,
				REQ.z78_council_key
			from client_scouts_discount_request as REQ 
				inner join co_customer as CST on REQ.z78_cst_key = CST.cst_key 
				inner join co_individual as IND on IND.ind_cst_key = CST.cst_key
				inner join co_individual_EXT as EXT on EXT.ind_cst_key_ext = CST.cst_key
				inner join co_address as ADR on ADR.adr_cst_key_owner = CST.cst_key  
				inner join co_customer_ext as PH on PH.cst_key_ext = CST.cst_key
			where z78_key = @key
			for xml path('row'), elements xsinil, type, root('discount_request')
	
	end 
	
	
END

GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_request_list_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Display list of Requests to Council office 
-- =============================================

/* 

WEB METHOD: 

	This SP is mapped to Web Method : DiscountRequestList 
	As such, it requires a single row of blanks when resulting in an empty set 

TODO:	return empty row if DNE 

TESTS: 

	exec [client_scouts_discount_request_list_xweb] 
		 @status='all'
		, @cst_key='3E634364-A0C9-4A01-9581-51144777B2CB'
		

	exec [client_scouts_discount_request_list_xweb] 
		 @status='all'
		, @council_key = 'BBA3C956-4171-4868-9C9C-01AF8A73E342'
			

	select z78_cst_key, z78_council_key  from client_scouts_discount_request 
	
*/

CREATE PROCEDURE [dbo].[client_scouts_discount_request_list_xweb] 

	 @council_key as uniqueidentifier = NULL		-- OPTIONAL KEY to Council 
	,@status as varchar(200) ='new'					-- status can be [new|approve|deny] (maybe should be 0,1,2) 
	,@cst_key as uniqueidentifier = NULL			-- OPTIONAL KEY to Requestor 
	
	-- At least one of COUNCIL_KEY , CST_KEY is required 
	
AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- IFF optional council_key is provided - it may be an org key that is under a council hierarchy 
	if (@council_key is not null) begin 
		-- if submitted key is council - it will not change 
		-- otherwise, it will find 1 council - or 'Scouts Canada' of a council cannot be found
		set @council_key = dbo.client_scouts_get_parent_org_by_type (@council_key, 'council')
	end 

	declare @stati as table(s varchar(10))  
	
	if @status='all' 
		set @status='new,approve,deny'
	
	-- push 1 or more values from Comma Separated List of codes into Array 
	;
	WITH StrCTE(start, stop) AS
    ( SELECT  1, CHARINDEX(',' , @status )
      UNION ALL
      SELECT  stop + 1, CHARINDEX(',' ,@status  , stop + 1)
      FROM StrCTE
      WHERE stop > 0 )
    insert into @stati 
    SELECT   SUBSTRING(@status , start, CASE WHEN stop > 0 THEN stop-start ELSE 4000 END) 
    AS stringValue
    FROM StrCTE


	-- verify that key exists -- 

	IF EXISTS(	select z78_key
				from dbo.client_scouts_discount_request req
					inner join co_address as ADR on ADR.adr_cst_key_owner = REQ.z78_cst_key
				where req.z78_status in (select s from @stati)
					and z78_council_key = @council_key
			) OR 
		EXISTS ( select z78_key
				from dbo.client_scouts_discount_request req
					inner join co_address as ADR on ADR.adr_cst_key_owner = REQ.z78_cst_key
				where req.z78_status in (select s from @stati)
					and z78_cst_key = @cst_key) 
	BEGIN 

		select 
				IND.ind_gender,
				IND.ind_first_name,	
				IND.ind_last_name ,
				IND.ind_dob,
				EXT.ind_primary_lang_spoken_ext,
				CST.cst_eml_address_dn,
				ADR.adr_line1,
				ADR.adr_line2,
				ADR.adr_line3,
				ADR.adr_city,
				ADR.adr_state,
				ADR.adr_post_code,
				PH.cst_evening_phone_ext ,
				PH.cst_other_phone_ext,
				PH.cst_daytime_phone_ext,
				PH.cst_fax_ext,
				REQ.z78_key, 
				REQ.z78_cst_key, 
				REQ.z78_status, 
				REQ.z78_family_income, 
				REQ.z78_family_size, 
				REQ.z78_child_count,
				REQ.z78_add_date
			from client_scouts_discount_request as REQ 
				inner join co_customer as CST on REQ.z78_cst_key = CST.cst_key 
				inner join co_individual as IND on IND.ind_cst_key = CST.cst_key
				inner join co_individual_EXT as EXT on EXT.ind_cst_key_ext = CST.cst_key

				inner join co_customer_x_address CXA on cst.cst_cxa_key = CXA.cxa_key
				inner join co_address as ADR on cxa.cxa_adr_key = ADR.adr_key

				inner join co_customer_ext as PH on PH.cst_key_ext = CST.cst_key
				where req.z78_status in (select s from @stati)
					and z78_council_key = @council_key

		UNION 
		
		select 
				IND.ind_gender,
				IND.ind_first_name,	
				IND.ind_last_name ,
				IND.ind_dob,
				EXT.ind_primary_lang_spoken_ext,
				CST.cst_eml_address_dn,
				ADR.adr_line1,
				ADR.adr_line2,
				ADR.adr_line3,
				ADR.adr_city,
				ADR.adr_state,
				ADR.adr_post_code,
				PH.cst_evening_phone_ext ,
				PH.cst_other_phone_ext,
				PH.cst_daytime_phone_ext,
				PH.cst_fax_ext,
				REQ.z78_key, 
				REQ.z78_cst_key, 
				REQ.z78_status, 
				REQ.z78_family_income, 
				REQ.z78_family_size, 
				REQ.z78_child_count,
				REQ.z78_add_date
			from client_scouts_discount_request as REQ 
				inner join co_customer as CST on REQ.z78_cst_key = CST.cst_key 
				inner join co_individual as IND on IND.ind_cst_key = CST.cst_key
				inner join co_individual_EXT as EXT on EXT.ind_cst_key_ext = CST.cst_key
				
				inner join co_customer_x_address CXA on cst.cst_cxa_key = CXA.cxa_key
				inner join co_address as ADR on cxa.cxa_adr_key = ADR.adr_key
				
				inner join co_customer_ext as PH on PH.cst_key_ext = CST.cst_key
				where req.z78_status in (select s from @stati)
					and z78_cst_key = @cst_key

		order by z78_add_date desc 
						
		for xml path('discount_request'), elements xsinil, type, root('discount_requests') 
	
	END ELSE BEGIN 

		select 'false' as answer , @council_key as 'council_key'
			for xml path('responses'), elements xsinil, type, root('response')

	END 	

END

GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_request_process_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Sets status of request to either APPROVE or DENY 
--				records APPROVER 
--				creates DISCOUNT if Approved 
-- =============================================

/* 

	-- do we need to limit number of discoutns ? 
	-- should there be separate discount rows for each 'discount' 
	-- or a limit on the discount 
	
	test with 

	-- test 1 -- trap error 
	
	-- test 2 -- create new request (with minimum required values) 

	exec client_scouts_discount_request_process_xweb
		@discount_request_key   = 'E7C7A730-7D5F-4820-8C67-154C8D6A319F' ,
		@approvers_cst_key = 'E7C7A730-7D5F-4820-8C67-154C8D6A319F', 
		@status = 'approve', 
		@discount_type = 'NOLB1',
		@discount_amount = '50', 
		@discount_unit = '%', 
		@number_of_discounts = 3
		--, @debug=1

	-- TEST DENY 
	exec client_scouts_discount_request_process_xweb
		@discount_request_key   = 'E7C7A730-7D5F-4820-8C67-154C8D6A319F' ,
		@approvers_cst_key = 'E7C7A730-7D5F-4820-8C67-154C8D6A319F', 
		@status = 'deny', 
--		@discount_type = 'NOLB1',
--		@discount_amount = '50', 
--		@discount_unit = '%', 
		@number_of_discounts = 3
		, @debug=1

	
	--rollback 
	
	select * from client_scouts_discount_request where z78_key = 'E7C7A730-7D5F-4820-8C67-154C8D6A319F'
	select * from client_scouts_discount_approval -- where z78_key = 'E7C7A730-7D5F-4820-8C67-154C8D6A319F'
	select * from client_scouts_discount -- where z78_key = 'E7C7A730-7D5F-4820-8C67-154C8D6A319F'
	
	--truncate table client_scouts_discount_approval
	--truncate table client_scouts_discount
	
*/

CREATE PROCEDURE [dbo].[client_scouts_discount_request_process_xweb] 

	@discount_request_key AS av_key = null, 
	@requestors_cst_key varchar(36) = null,
	@approvers_cst_key varchar(36) = null,	-- key of data entry user
	@approved_by varchar(500) = NULL,		-- text of approval signature
	@status varchar(10)= null, 
	@expiry_date datetime = null,			-- for discount record 
	@discount_type varchar(10) = null, 
	@discount_amount varchar(10) = null, 
	@discount_unit varchar(10) = null, 
	@prc_key varchar(36) = null,
	@number_of_discounts smallint = 1,
	@debug bit = 0 

AS
BEGIN

	SET NOCOUNT ON 
	
	-- to allow multiple discounts to be created for an individual 
	declare @max_discounts as smallint = 9
	declare @discount_number as smallint
	declare @newkey as varchar(36) 
	
	set @newkey = NEWID()  -- for insert into discount_approval
	
	-- limit to max_discounts -- 
	if @number_of_discounts > @max_discounts begin 
		set @number_of_discounts = @max_discounts
	end 
	
	if @expiry_date is NULL begin 
		set @expiry_date = dateadd(D,60,getdate())
	end
	
	-- validate require fields are present !
	if LEN(@discount_request_key) > 10 
		--- and LEN( 
	begin 
	
		begin try 
		
			begin transaction 
			
			if @debug=1	print 'starting trans' 
			
			-- update the status IFF 2 approvals exist for the request 
			update dbo.client_scouts_discount_request
				set z78_status = @status 
			where z78_key=@discount_request_key 
		
			-- record approver 
			insert into client_scouts_discount_approval (
				z81_key, 
				z81_approver_cst_key, 
				z81_status, 
				z81_approved_by,
				z81_discount_request_key) 
			values(
				@newkey, 
				@approvers_cst_key, 
				@status, 
				@approved_by,
				@discount_request_key)
				
			-- create discount if approved 
			if @status = 'approve' begin 
			
				-- IF any discounts already exist - cancel them so they can be recreated 
				
				update client_scouts_discount
				set z80_cancelled_flag = 1, 
					z80_change_user = SUSER_SID(), 
					z80_change_date = GETDATE()  
				where z80_discount_request_key = @discount_request_key
					and z80_date_used is null 
					and z80_delete_flag = 0 
					and z80_Cancelled_flag = 0 
					
				
				set @discount_number = 1

				while @discount_number <= @number_of_discounts begin 
				
					-- new key for each discount 
					
					set @newkey = newid() 
					
					insert into client_scouts_discount(
						z80_key, 
						z80_expiry_date, 
						z80_discount_type, 
						z80_discount_amount,
						z80_discount_unit,
						z80_prc_key,
						z80_discount_request_key) 
					values(
						@newkey, 
						@expiry_date, 
						@discount_type, 
						@discount_amount,
						@discount_unit,
						@prc_key,
						@discount_request_key)
					
					-- counter 
					set @discount_number = @discount_number + 1

				end 
				
			end 	
			
			-- cancel all discounts if any were previously created 
			if @status = 'deny' begin 
			
				update client_scouts_discount
				set z80_cancelled_flag = 1 
				where z80_discount_request_key = @discount_request_key
					and z80_date_used IS NULL 
				
			end 
			
			commit
			if @debug=1	
				print 'committed trans' 
				
			-- we must send back something, otherwise ERROR is assumed, and xWeb call is made again !
			select 'true' as answer for xml path('responses'), elements xsinil, type, root('response')
		
		end try 

		begin catch 

			rollback 

			if @debug=1	begin 
				DECLARE @ErrorNumber INT = ERROR_NUMBER();
				DECLARE @ErrorLine INT = ERROR_LINE();
				DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
				DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
				DECLARE @ErrorState INT = ERROR_STATE();

				PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
				PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));

				RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    		end 

			-- add entry to error log ??
			-- select 'false' as answer for xml path('responses'), elements xsinil, type, root('response')
			-- return 

		end catch  

	end 
		
END

GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_request_update_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Handles CRUD for discount_request table 
-- =============================================

/* 
	test with 

	-- test 1 -- trap error 
	
	exec client_scouts_discount_request_update_xweb

	-- test 2 -- create new request (with minimum required values) 
	exec client_scouts_discount_request_update_xweb
		@key = 'AAF12D95-C65D-4890-8E3B-754FBCC93E37',
		@family_income = '55555',
		@child_count = '3'

*/

CREATE PROCEDURE [dbo].[client_scouts_discount_request_update_xweb] 

	@key as varchar(36) = null,
	@family_income int=null, 
	@family_size smallint=null, 
	@child_count smallint=null,
	@council_key varchar(36)   -- required field !
	 
AS
BEGIN

	SET NOCOUNT ON 
	
	begin try 

		update  dbo.client_scouts_discount_request
			set 
			z78_family_income= 	    @family_income,
			z78_family_size= 	    @family_size,
			z78_child_count=	    @child_count, 
			z78_council_key=		@council_key,
			z78_change_date=		getdate(), 
			z78_change_user=		suser_sname()
		where 
			z78_key=				@key

		-- return something ?
		 select 'true' as answer for xml path('responses'), elements xsinil, type, root('response')
		 return 
		
	end try 
	
	begin catch 
		 select 'false' as answer for xml path('responses'), elements xsinil, type, root('response')
		 return 
	end catch  
	
		
END


GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_stats_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =================================================
-- Author:		Jshuter
-- Create date: July 3 2015
-- Description:	Simple stats to display 
-- =================================================

/* 
	PARAMS 

exec [client_scouts_discount_stats_xweb]
	
*/

CREATE PROCEDURE [dbo].[client_scouts_discount_stats_xweb] 

AS
BEGIN

	SET NOCOUNT ON 

	-- I want - PER COUNCIL -- DENIED / APPROVED -> / USED, / AVAILABLE / Expired / Cancelled / 
	
	;
	
	with council_keys as (
		select count(*) as 'applied', r.z78_council_key from client_scouts_discount_request r
		-- to change from COUNT of requests to COUNT of discouts use 
		-- join client_scouts_discount d on r.z78_key = d.z80_discount_request_key
		group by r.z78_council_key ) 
	
	select councils.z78_council_key
		, councils.applied
		, ( select count(*) 
			from client_scouts_discount_request 
			where client_scouts_discount_request.z78_council_key = councils.z78_council_key 
				and client_scouts_discount_request.z78_status = 'new' ) as 'new' 
		, ( select count(*) 
			from client_scouts_discount_request 
			where client_scouts_discount_request.z78_council_key = councils.z78_council_key 
				and client_scouts_discount_request.z78_status = 'approve' ) as 'approved' 
		, ( select count(*) 
			from client_scouts_discount_request 
			where client_scouts_discount_request.z78_council_key = councils.z78_council_key 
				and client_scouts_discount_request.z78_status = 'deny' ) as 'denied' 
		, ( select count(*) 
			from client_scouts_discount_request R
				inner join client_scouts_discount D on R.z78_key = D.z80_discount_request_key 
			where R.z78_council_key = councils.z78_council_key 
				and D.z80_date_used IS NOT NULL ) as 'used' 	
		, ( select count(*) 
			from client_scouts_discount_request R
				inner join client_scouts_discount D on R.z78_key = D.z80_discount_request_key 
			where R.z78_council_key = councils.z78_council_key 
				and D.z80_date_used is NULL ) as 'available' 	
		, ( select count(*) 
			from client_scouts_discount_request R
				inner join client_scouts_discount D on R.z78_key = D.z80_discount_request_key 
			where R.z78_council_key = councils.z78_council_key 
				and D.z80_expiry_date < getdate() ) as 'expired' 	
		, ( select count(*) 
			from client_scouts_discount_request R
				inner join client_scouts_discount D on R.z78_key = D.z80_discount_request_key 
			where R.z78_council_key = councils.z78_council_key 
				and D.z80_cancelled_flag = 1 ) as 'cancelled' 	
	from council_keys as councils
	
	for xml path('row'), elements xsinil, type, root('rows')

	 
		
	

	
END


/* 
		select * 
			from 
					client_scouts_discount_request R inner join 
					client_scouts_discount D  on R.z78_key = D.z80_discount_request_key 
					
			where  R.z78_council_key = councils.z78_council_key and 
			D.z80_date_used is NOT NULL 
*/

GO

/****** Object:  StoredProcedure [dbo].[client_scouts_discount_update_xweb]    Script Date: 08/07/2015 16:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Myagi
-- Create date: July 16 2015
-- Description:	Updates the client_scouts_discount table and sets the discount code used flag
--				Must have a valid discount and experimental registration key
-- Arguments:		@discount_key => The key to the client_scouts_discount table
--				@experimental_registration_key => The key to the client_scouts_experimental_registration table
-- =============================================
CREATE PROCEDURE [dbo].[client_scouts_discount_update_xweb]
	@discount_key AS UNIQUEIDENTIFIER = NULL,
	@experimental_registration_key AS UNIQUEIDENTIFIER = NULL,
	@return_xml BIT = 1
AS
BEGIN

	SET NOCOUNT ON 
	
	BEGIN TRY 

	   DECLARE @record_found BIT = 1

	   IF EXISTS (SELECT z80_key FROM client_scouts_discount WHERE z80_key = @discount_key)
		  AND EXISTS (SELECT x13_key FROM client_scouts_experimental_registration WHERE x13_key = @experimental_registration_key)	
	   BEGIN
		  UPDATE  dbo.client_scouts_discount
		  SET 
			 z80_experimental_registration_key = @experimental_registration_key, 
			 z80_date_used = GETDATE(), 
			 z80_change_date = GETDATE(), 
			 z80_change_user = SUSER_SNAME()
		  WHERE 
			 z80_key = @discount_key
	   END
	   ELSE
	   BEGIN
		  SET @record_found = 0		  			 
	   END		  

	   IF @return_xml = 1
	   BEGIN
		  IF @record_found = 1
		  BEGIN
			 SELECT 'true' AS answer FOR XML PATH('responses'), ELEMENTS XSINIL, TYPE, ROOT('response')
		  END
		  ELSE
		  BEGIN
			 SELECT 'dne' AS answer FOR XML PATH('responses'), ELEMENTS XSINIL, TYPE, ROOT('response')
		  END
		  
		  RETURN
	   END			
	   ELSE
	   BEGIN		 
		  --SELECT 1 AS answer
		  RETURN
	   END
		
	END TRY 
	
	BEGIN CATCH 
	   IF @return_xml = 1
	   BEGIN
		  SELECT 'false' AS answer FOR XML PATH('responses'), ELEMENTS XSINIL, TYPE, ROOT('response')
		  RETURN
	   END			
	   ELSE
	   BEGIN		 
		  --SELECT 0 AS answer
		  RETURN
	   END
	END CATCH  
	
		
END


GO


