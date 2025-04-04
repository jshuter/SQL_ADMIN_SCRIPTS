USE [netforumscoutsTest]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_put_rows_by_key_xweb]    Script Date: 01/25/2016 13:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* 

The input to this proc is an XML doc with simple structure of 

<data>
  <tabl name="co_individual" keyname="ind_cst_key" keyvalue="3999E32D-2DC0-4BAB-B94C-A8E514A9113D" row="2">
    <field name="ind_first_name">data</field>
		...
  </tabl>
	...
</data>


NOTE - although MULTIPLE Tables and Rows can be inserted as a single transaction 

	This proc can only insert for a SINGLE table at a time (for now) 
	In part this is due to the way that 'extender' tables share the KEY of the base table 
	and therefore we must return the new Key before populating 'extender' table data 
	
	The INSERT will create {TABLE} and automatically will create {TABLE}_EXT  
	
	
NOTE - the first field is the primary key for the row 

TESTS

exec client_scouts_put_rows_by_key_xweb 'x'

*/

ALTER PROCEDURE [dbo].[client_scouts_put_rows_by_key_xweb]

	-- required values 
	@xml as xml = NULL, 
	@cst_key as uniqueidentifier = NULL,
	@before_trigger as nvarchar(100) = NULL,
	@after_trigger as nvarchar(100) = NULL,
	@debug as bit = 0		-- debug also invoke VALIDATION of metadata fields, tables

	-- PASS IN THE XML !	@mode as varchar = NULL -- [add|modify|delete] 

AS
BEGIN

	SET NOCOUNT ON;

	-- DECLARATIONS
	
	declare @tblname as varchar(50) 
	declare @pk_name as varchar(50) 
	declare @pk_value as varchar(50) 
	declare @fldname as varchar(50) 
	declare @fldvalue as varchar(1000) 
	declare @sql as nvarchar(max) 
	declare @set_clause as nvarchar(max) 
	declare @count as int 
	declare @count1 as int 
	declare @count2 as int 
	declare @mode as varchar(20) 
	declare @row int 
	declare @max int 
	declare @fieldlist as varchar(1000)
	declare @rowcount int 
	declare @cst_recno int = 0 
	declare @data_type as varchar(20) 
	declare @dtflag as bit = 0 
	declare @newkey as uniqueidentifier = NULL 
	declare @new_cst_key as uniqueidentifier = NULL 
	
	-- av user data types 	
	declare @fv_currency as av_currency		
	declare @fv_date as av_date			
	declare @fv_date_small as av_date_small		
	declare @fv_decimal2 as av_decimal2		
	declare @fv_decimal4 as av_decimal4		
	declare @fv_delete_flag as av_delete_flag		
	declare @fv_email as av_email		
	declare @fv_fax as av_fax			
	declare @fv_flag as av_flag			
	declare @fv_float as av_float		
	declare @fv_integer as av_integer		
	declare @fv_key as av_key			                 	                        
	declare @fv_messaging_name as av_messaging_name
	declare @fv_phone as av_phone		
	declare @fv_recno as av_recno	
	declare @fv_url as av_url			
	declare @fv_url_long as av_url_long
	declare @fv_user as av_user			
	-- GENERIC TYPES
	declare @fv_nvarchar as nvarchar(2500) -- max max_witdh from mdc_column table 
	 
	declare @fv_text as nvarchar(max) 
		
-- declare @fv_text as av_text			
-- declare @fv_picture as av_picture

/*
Msg 2739, Level 16, State 1, Procedure client_scouts_put_rows_by_key_xweb, Line 22
The text, ntext, and image data types are invalid for local variables.
*/

	-- TEST DATA 

	/* 
	-- DATA INCLUDES - non-existing field 
	set @xml = '
	<data>
	  <tabl name="co_individual" keyname="ind_cst_key" keyvalue="3999E32D-2DC0-4BAB-B94C-A8E514A9113D" row="2">
		 <field name="ind_first_name">Jeffrey</field>
		 <field name="ind_las_name">Shuter</field>
		 <field name="ind_primary_lang_spoken_ext">English</field>
		</tabl>
		<tabl name="co_address" keyname="adr_key" keyvalue="53E89D0A-822E-4022-A4D8-407467485F9B" row="3">
		<field name="adr_line1">1508 - 1150 fisher ave</field><field name="adr_line2"></field><field name="adr_city">ottawa</field><field name="adr_state">ON</field><field name="adr_post_code">k1z8m3</field><field name="adr_country">CANADA</field></tabl><tabl name="co_customer" keyname="cst_key" keyvalue="3999E32D-2DC0-4BAB-B94C-A8E514A9113D" row="4"><field name="cst_evening_phone_ext"></field><field name="cst_daytime_phone_ext"></field><field name="cst_other_phone_ext"></field><field name="cst_eml_address_dn">jeffrey.shuter@scouts.ca</field></tabl></data>
	'

	-- DATA INCLUDES - NULL PRIMARY KEY 
	set @xml = '
	<data>
	  <tabl name="co_individual" keyname="ind_cst_key" keyvalue="" row="2">
		 <field name="ind_first_name">Jeffrey</field>
		 <field name="ind_las_name">Shuter</field>
		 <field name="ind_primary_lang_spoken_ext">English</field>
		</tabl>
		<tabl name="co_address" keyname="adr_key" keyvalue="53E89D0A-822E-4022-A4D8-407467485F9B" row="3">
		<field name="adr_line1">1508 - 1150 fisher ave</field><field name="adr_line2"></field><field name="adr_city">ottawa</field><field name="adr_state">ON</field><field name="adr_post_code">k1z8m3</field><field name="adr_country">CANADA</field></tabl><tabl name="co_customer" keyname="cst_key" keyvalue="3999E32D-2DC0-4BAB-B94C-A8E514A9113D" row="4"><field name="cst_evening_phone_ext"></field><field name="cst_daytime_phone_ext"></field><field name="cst_other_phone_ext"></field><field name="cst_eml_address_dn">jeffrey.shuter@scouts.ca</field></tabl></data>
	'

	-- GOOD DATA 	
	set @xml = '<data><tabl name="co_individual" keyname="ind_cst_key" keyvalue="3999E32D-2DC0-4BAB-B94C-A8E514A9113D" row="2" mode="U"><field name="ind_first_name">Jeffrey</field><field name="ind_last_name">Shuter</field><field name="ind_primary_lang_spoken_ext">English</field></tabl><tabl name="co_address" keyname="adr_key" keyvalue="53E89D0A-822E-4022-A4D8-407467485F9B" row="3" mode="U"><field name="adr_line1">1508 - 1150 fisher ave</field><field name="adr_line2"></field><field name="adr_city">ottawa</field><field name="adr_state">ON</field><field name="adr_post_code">k1z8m3</field><field name="adr_country">CANADA</field></tabl><tabl name="co_customer" keyname="cst_key" keyvalue="3999E32D-2DC0-4BAB-B94C-A8E514A9113D" row="4" mode="U"><field name="cst_evening_phone_ext"></field><field name="cst_daytime_phone_ext"></field><field name="cst_other_phone_ext"></field><field name="cst_eml_address_dn">jeffrey.shuter@scouts.ca</field></tabl></data>'
	*/
	

	-- validate requestor and use RECNO in change user / change date
	select @cst_recno = cst_recno from co_customer where cst_key = @cst_key 

	if @cst_recno = 0 begin
		select 'false' as answer 
		, 1 as 'code'
		, 'WARNING - User Key is missing or is invalid' as 'message'
		for xml path('responses'), elements xsinil, type, root('response')
		return 1 
	end 

	-- CREATE DATA SET from XML 
;
	with DELTAS as (
	select
		Tabl.Col.value('../@row', 'nvarchar(max)' ) as row_num, 
		Tabl.Col.value('../@mode', 'nvarchar(3)' ) as mode, 
		Tabl.Col.value('../@name', 'nvarchar(max)' ) as [table_name], 
		Tabl.Col.value('../@keyname', 'nvarchar(max)' ) as [pk_name], 
		Tabl.Col.value('../@keyvalue', 'nvarchar(max)' ) as [pk_value], 
		Tabl.Col.value('(@name)', 'nvarchar(max)' ) as [column], 
		Tabl.Col.value('.', 'nvarchar(max)' ) as [value]
		from @xml.nodes('/data/tabl/field') Tabl(Col))
	--
	select DELTAS.*
	, COLS.mdc_table_name 
	, COLS.mdc_nullable
	, COLS.mdc_width_max
	, COLS.mdc_required
	, COLS.mdc_data_type
	, COLS.mdc_default_value
	INTO #TMP001
	from DELTAS 
		left outer join md_column COLS 
		on cols.mdc_name = DELTAS.[column]
	order by DELTAS.row_num, mdc_table_name 

	
	if(@debug=1) begin 
		select table_name as tbl, mdc_table_name as mdtbl, * from #TMP001
		order by row_num
		--for xml path('record'), elements xsinil, type, root('records')
		-- return 1
	end 


	-- parms 
	select @row = MIN(row_num) from #TMP001
	select @max = MAX(row_num) from #TMP001

	------------------------------------------------------------------------
	-- VALIDATION of the META DATA -- insure fields etc are valid 
	--

	-- IF MODE = UPDATE 
	-- CHECK FOR NULL KEYS 
	select @count=COUNT(*) from #TMP001 where mode = 'U' 
		and (pk_name = '' or pk_name is NULL or pk_value = '' or pk_value is NULL) 

	if (@count > 0 ) begin 
		select 'false' as answer
		, 2 as 'code' 
		, 'WARNING - Primary Key data is missing ...' as 'message'
		for xml path('responses'), elements xsinil, type, root('response')
		return 1 
	end 

	-- IF MODE = ADD
	-- KEYS SHOULD BE named for each 
	select @count1=COUNT(*) from #TMP001 where mode = 'A' 
	select @count2=COUNT(*) from #TMP001 where mode = 'A' and NOT (pk_name = '' or pk_name is NULL) 

	if (@count1 <> @count2 ) begin 
		select 'false' as answer
		, 3 as 'code'  
		, 'WARNING - Primary Key NAME is missing for insert' as 'message'
		for xml path('responses'), elements xsinil, type, root('response')
		return 1 
	end 

	-- IF MODE = ADD
	-- KEYS SHOULD BE NULL
	select @count2=COUNT(*) from #TMP001 where mode = 'A' and NOT (pk_value = '' or pk_value is NULL) 

	if (@count2 > 0) begin 
		select 'false' as answer
		, 4 as 'code' 
		, 'WARNING - Primary Key VALUE should not exist when inserting a new row' as 'message'
		for xml path('responses'), elements xsinil, type, root('response')
		return 1 
	end 

	-- WRONG DATA - metadata must exists for these fields 
	select @count=COUNT(*) from #TMP001 
		where mdc_table_name <> table_name 
		or table_name IS NULL 
	if (@count > 0) begin 
		select 'false' as answer
		, 5 as 'code'  
		, 'WARNING - Table/Field mismatch. One of the fieldnames being posted does not belong to the table specified.' as 'message' 
		for xml path('responses'), elements xsinil, type, root('response')
		return 1 
	end 

	---------------------------------------------------------
	-- NOW READY TO BEING UPDATE 
	---------------------------------------------------------

	declare @comma char(1) = ''

	begin try 

		begin transaction 
		-- execute before trigger IFF EXISTS
		
		-- SINCE the return values may be different for each - we may need to hard code for each trigger that returns a value 
		
		if @before_trigger IS NOT NULL begin
		
			if @before_trigger = 'new_individual' begin 
			
				-- run special handler for new_ind - which returns a new key 
				exec client_scouts_individual_create_blank_xweb @cst_key, @new_cst_key OUTPUT
				select @new_cst_key
				
				rollback 
				return 
			
			end else begin 

				-- attempt generic trigger 
				set @before_trigger = 'client_scouts_' + @before_trigger + '_xweb'
				exec sp_executesql @before_trigger 
			
			end 
		
		end 
		
		
		-- PROCESS - Main line 

		WHILE @row <= @MAX
		BEGIN

			-- for each <table> unpacked from XML we have KEY/VALUE pairs that need to be transalted into a dynamic SQL statement 

			if (@debug = 1) begin 
				SELECT * from #TMP001 where row_num = @row 
			end 
							
			-- assuming for a particular ROW number, there must be 1 and only 1 entry for a particular COLUMN name 
			-- and therefore we will loop through subset (where row = x) AND use the COLUMN as the key to the row !
			
			set @count=0 -- avoid any possibility of infinite loop 
			set @fieldlist = ''
			set @comma=''		
			set @set_clause=''

			--
			--------------------------------------------
			-- get table info 			
			SELECT top 1 @mode=mode, @tblname = table_name, @pk_name =pk_name, @pk_value=pk_value from #TMP001 where row_num = @row 
									
			-- get first row
			SELECT  top 1 @data_type = [mdc_data_type] , @tblname=mdc_table_name,  @fldname  = [COLUMN] , @fldvalue=[VALUE] from #TMP001 where row_num = @row 
			set @rowcount=@@ROWCOUNT 

			if @debug = 1 begin 
				SELECT  @data_type, @tblname, @fldname, @fldvalue, @row 
			end 
					
			while (@count < 1000 AND @rowcount > 0) begin 

				-- then get each field 		
				set @fieldlist = @fieldlist + @comma + @fldname 
				
				-- IFF int ...
				set @set_clause = @set_clause + @comma + @fldname + '=' + @fldvalue 
				
				-- remove row before getting next field defn'
				DELETE FROM  #TMP001 where row_num = @row and [COLUMN] = @fldname
				set @count=@count+1 
				set @comma = ','	

				-----------
				-- PREFORM UPDATE FOR 1 COLUMN 
					set @dtflag=0 		
					set @sql = ''

					-- MUST INCLUDE HANDLER FOR ALL DATA TYPES !
					-- assume PK is uniqueidentifier -- !! must have WHERE clause !!

					--------------------------------------------------------------------
					-- >> TYPES: AV_FLAG 
					if @data_type = 'av_flag' begin 
						set @dtflag = 1 
						if @fldvalue = '1' begin 
							set @fv_flag = 1
						end else begin 
							set @fv_flag = 0
						end 
						
						set @sql = 'UPDATE ' + @tblname + ' set ' + @fldname + '= @fv_flag where ' + @pk_name + '=''' + @pk_value +'''' 
	  					-- perfrom the main update here !!!!!
						exec sp_executesql @sql , N'@fv_flag av_flag', @fv_flag 
					end 

					--------------------------------------------------------------------
					-- >> TYPES: NVARCHAR - handle MAX SIZE / blanks / NULLABLE / etc ?
					if @data_type in ('nvarchar', 'av_email', 'av_phone') begin
						set @dtflag = 1
						set @fv_nvarchar = @fldvalue 
		
						set @sql = 'UPDATE ' + @tblname + ' set ' + @fldname + '= @fv_nvarchar where ' + @pk_name + '=''' + @pk_value +'''' 
	  					-- perfrom the main update here !!!!!
						exec sp_executesql @sql , N'@fv_nvarchar nvarchar(2500)', @fv_nvarchar
					end 

					--------------------------------------------------------------------
					-- >> TYPES: av_text - handle MAX SIZE / blanks / NULLABLE / etc ?
					if @data_type = 'av_text' begin
						set @dtflag = 1
						set @fv_text = @fldvalue 
		
						set @sql = 'UPDATE ' + @tblname + ' set ' + @fldname + '= @fv_text where ' + @pk_name + '=''' + @pk_value +'''' 
	  					-- perfrom the main update here !!!!!
						exec sp_executesql @sql , N'@fv_text av_text', @fv_text
					end 
					
					--------------------------------------------------------------------
					-- >> TYPES: av_key 
					if @data_type = 'av_key' begin
						set @dtflag = 1
						set @fv_key = @fldvalue -- GUID String ?
		
						set @sql = 'UPDATE ' + @tblname + ' set ' + @fldname + '= @fv_key where ' + @pk_name + '=''' + @pk_value +'''' 
	  					-- perfrom the main update here !!!!!
						exec sp_executesql @sql , N'@fv_key av_key', @fv_key 
					end 
					
					--------------------------------------------------------------------
					-- >> TYPES: NVARCHAR - handle MAX SIZE / blanks / NULLABLE / etc ?
					if @data_type = 'av_date' begin
						set @dtflag = 1
	
						-- NULLing of dates
						if rtrim(ltrim(@fldvalue)) = '' begin 
							set @sql = 'UPDATE ' + @tblname + ' set ' + @fldname + '= NULL where ' + @pk_name + '=''' + @pk_value +'''' 
		  					-- perfrom the main update here !!!!!
							exec sp_executesql @sql 
						end else begin 
							set @fv_date = @fldvalue 		
							set @sql = 'UPDATE ' + @tblname + ' set ' + @fldname + '= @fv_date where ' + @pk_name + '=''' + @pk_value +'''' 
		  					-- perfrom the main update here !!!!!
							exec sp_executesql @sql , N'@fv_date av_date', @fv_date
						end 
						
					end 
					--------------------------------------------------------------------
	 
					if @debug = 1 begin 
  						select  @sql
  					end 
									
					if @dtflag = 0 begin 
						select 'false' as answer 
						, 7 as 'code' 
						, 'WARNING - unexpected data_type encountered' as 'message'
						for xml path('responses'), elements xsinil, type, root('response')
						
						-- cancel the transaction 
						rollback
						
						-- get out of here 
						return 1 				
					end 
					
				-------------
			
				-- get next row/field defn'
				SELECT  top 1 @data_type = [mdc_data_type] , @tblname=mdc_table_name, @fldname  = [COLUMN] , @fldvalue=[VALUE] from #TMP001 where row_num = @row 
				set @rowcount=@@ROWCOUNT 
			end 


	/* trying this for 1 column at a time ...		
			-- assume PK is uniqueidentifier -- !! must have WHERE clause !!
			if @data_type = 'av_flag'
			set @sql = 'UPDATE ' + @tblname + ' set ' + @set_clause + '  where ' + @pk_name + '=''' + @pk_value +'''' 
			if @debug =1 begin 
	  			select  @sql
	  		end 
	  		-- perfrom the main update here !!!!!
			exec sp_executesql @sql
	*/

			if @debug =1 begin 
	  			set @sql = 'SELECT ' +  @fieldlist + ' FROM ' + @tblname + '  where ' + @pk_name + '=''' + @pk_value +'''' 
				print @sql
				exec sp_executesql @sql
			end 

			SET @row = @row + 1

		END

		--rollback or commit ?!
		
		-- execute before trigger IFF EXISTS
		if @after_trigger IS NOT NULL begin
			print 'after ... test'	
		end 

		
		commit
		
	end try
	
	begin catch 

		rollback 
		
		-- an unexpected error has occurred  -- 
		-- trap it and return info to calling function 
		select 'false' as answer
		, 8 as 'code' 
		, 'UNEXPECTED ERROR HAS OCCURRED!' as 'message'
		, ERROR_MESSAGE() as 'error_message'
		, ERROR_LINE() as 'error_line'
		, ERROR_PROCEDURE() as 'error_procedure'
		, ERROR_NUMBER() as 'error_number'
		for xml path('responses'), elements xsinil, type, root('response')
		return 1		
	end catch 


	-- send message that update succeeded 
	if (@newkey IS NULL) begin 
		select 'true' as answer
		, 9 as 'code' 
		, 'Record updated' as 'message'
		for xml path('responses'), elements xsinil, type, root('response')
	end else begin 
		select 'true' as answer
		, 10 as 'code' 
		, 'Record added' as 'message'
		, @newkey as 'new_key'
		for xml path('responses'), elements xsinil, type, root('response')	
	end 
	
	
END
