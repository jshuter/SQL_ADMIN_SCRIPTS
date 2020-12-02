/* 

-- LIST DICOUNTS THAT ARE HALF USED 

 select top 100 x13_key, ivd_key, ivd_type, inv_key , ivd.* 
 from client_scouts_discount
 join client_scouts_experimental_registration on z80_experimental_registration_key = x13_key 
 join ac_invoice on inv_key = x13_inv_key 
 join ac_invoice_detail ivd on ivd_inv_key = inv_key 
 
 where z80_experimental_registration_key is not null 
 and z80_date_used > '2016-06-27'
 
 order by ivd_add_date
 
-- delete ac_invoice_detail where ivd_key = '2DADA4DB-B41C-470B-B3E6-4B943756B53F'

--================================================================================

TO BE FIXED : 

 select top 100 x13_key, ivd_key, ivd_type, inv_key , ivd.* 
 from client_scouts_discount
 join client_scouts_experimental_registration on z80_experimental_registration_key = x13_key 
 join ac_invoice on inv_key = x13_inv_key 
 join ac_invoice_detail ivd on ivd_inv_key = inv_key 
 where z80_experimental_registration_key in ( 
	'4F23062D-93EC-4394-A898-1E3D32314269',  -- DONE
	'2430C083-EBCC-4350-9DF2-385DED8A2AB9',
	'6CE85C79-139E-42A1-A0B8-3A1AFE9CCC21',
	'FF55D7D2-F4BD-45D6-B0F6-4FA4C3172C16',
	'70B0B717-8052-4C08-A134-650CC3DED113',
	'704CEF80-F3E0-4D7A-89C1-698F9D5EA26B',
	'86399DEC-06DF-41B4-A562-787D0CF34A42',
	'82DB2D9C-4C6B-49C9-90F9-8028F804985B',
	'20790E09-F067-4F8D-AAA6-8B99188645E8',
	'845FD017-FD53-426F-82B2-B29AB8AD2A5C',
	'AD383CF3-FA04-4A68-9A58-B30221FC5F61',
	'437FDA58-49A6-42B1-803F-B6A802BC7616',
	'F3C6323D-BDB8-4A66-A9E4-B9EB52B8B7EA',
	'60BE67C2-3A7C-4BE9-93C8-BC61FE5F1D5D',
	'559387CB-F2A8-4CFC-A70E-E953A5E0CFBD') 



with discounts as ( 
 select distinct x13_key, ivd_type, inv_key   --ivd_add_date 
 , (select x.ivd_type from ac_invoice_detail x where x.ivd_inv_key = inv_key and x.ivd_type='discount') as DISCOUNTED
 from client_scouts_discount
 join client_scouts_experimental_registration on z80_experimental_registration_key = x13_key 
 join ac_invoice on inv_key = x13_inv_key 
 join ac_invoice_detail ivd on ivd_inv_key = inv_key 
 where z80_experimental_registration_key is not null 
 and z80_date_used > '2016-06-27'
) 
select * from discounts 
where DISCOUNTED IS NULL

*/
	
	declare @x13_key	uniqueidentifier = '4F23062D-93EC-4394-A898-1E3D32314269', 
	@type		nvarchar(50),
	@value		uniqueidentifier

	set @x13_key = '2430C083-EBCC-4350-9DF2-385DED8A2AB9'
	set @x13_key = '6CE85C79-139E-42A1-A0B8-3A1AFE9CCC21'
	set @x13_key = 'FF55D7D2-F4BD-45D6-B0F6-4FA4C3172C16'
	set @x13_key = '70B0B717-8052-4C08-A134-650CC3DED113'
	set @x13_key = '704CEF80-F3E0-4D7A-89C1-698F9D5EA26B'
	set @x13_key = '86399DEC-06DF-41B4-A562-787D0CF34A42'
	set @x13_key = '82DB2D9C-4C6B-49C9-90F9-8028F804985B'
	set @x13_key = '20790E09-F067-4F8D-AAA6-8B99188645E8'
	set @x13_key = '845FD017-FD53-426F-82B2-B29AB8AD2A5C'
	set @x13_key = 'AD383CF3-FA04-4A68-9A58-B30221FC5F61'
	set @x13_key = '437FDA58-49A6-42B1-803F-B6A802BC7616'
	set @x13_key = 'F3C6323D-BDB8-4A66-A9E4-B9EB52B8B7EA'
	set @x13_key = '60BE67C2-3A7C-4BE9-93C8-BC61FE5F1D5D'
	set @x13_key = '559387CB-F2A8-4CFC-A70E-E953A5E0CFBD' 


	declare @inv_key			uniqueidentifier  = (select x13_inv_key from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
	declare @ivd_keygroup		uniqueidentifier = NEWID();
	declare @ivd_keycouncil		uniqueidentifier = NEWID();
	declare @ivd_keynational	uniqueidentifier = NEWID();
	declare @pin_key			uniqueidentifier = NEWID();
	declare @pay_key			uniqueidentifier = NEWID();
	declare @pyd_keygroup		uniqueidentifier = NEWID();
	declare @pyd_keycouncil		uniqueidentifier = NEWID();
	declare @pyd_keynational	uniqueidentifier = NEWID();
	declare @new_inv_detail_id	uniqueidentifier = NEWID();
	declare @line_items_total	money;
	declare @prc_key			uniqueidentifier;
	declare @mbt_code			nvarchar(50)	 = (select top 1 mbt_code from client_scouts_experimental_registration(nolock) inner join mb_member_type(nolock) on mbt_key = x13_mbt_key where x13_key = @x13_key);
	declare @rlt_code			nvarchar(50)	 = '' 
	declare @x13_type			nvarchar(10)	 = (select x13_type from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
	declare @adduser			nvarchar(50)	 = 'RegistrationWizard';
	declare @cst_key			uniqueidentifier = (select isnull(x13_ind_cst_key_1,x13_ind_cst_key_2) from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
	declare @cxa_key			uniqueidentifier = (select cst_cxa_key from co_customer(nolock) where cst_key = @cst_key);
	declare @org_cst_key		uniqueidentifier = (select x13_org_cst_key from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
	declare @bat_org_key		uniqueidentifier = @org_cst_key;
		
	-- handle YYYY+YYYY
	declare @regyear			nvarchar(4) = right(@x13_type,4) 
	declare @regfreeyear		nvarchar(4) = NULL 
	
	if LEN(@x13_type) = 9 begin 
		set @regfreeyear = left(@x13_type, 4) 
	end 
				
	--=================================================
	-- MAIN INVOICE CREATION 
	--=================================================
		
	-- MYAGI 20150716-NOLB: Apply discounts, if discount found
		
	IF (select TOP 1 z80_prc_key from client_scouts_discount(nolock) where z80_experimental_registration_key = @x13_key) is not null BEGIN
	     
		  SET @prc_key = (SELECT TOP 1 z80_prc_key FROM client_scouts_discount WHERE z80_experimental_registration_key = @x13_key)

		  SET @line_items_total = (select SUM(ivd_price) FROM ac_invoice_detail 
								WHERE ivd_inv_key = @inv_key
								AND ivd_type != 'discount')

 		
		  INSERT INTO ac_invoice_detail
		  (	 ivd_key,
			 ivd_inv_key,
			 ivd_qty,
			 ivd_price,
			 ivd_parity,
			 ivd_gla_cr_key,
			 ivd_gla_dr_key,
			 ivd_prc_key,
			 ivd_prc_prd_key,
			 ivd_prc_prd_ptp_key,
			 ivd_backorder_flag,
			 ivd_inventory_held_qty,
			 ivd_ship_qty,
			 ivd_close_flag,
			 ivd_approve_flag,
			 ivd_void_flag,
			 ivd_do_not_fulfill,
			 ivd_add_user,
			 ivd_add_date,
			 ivd_delete_flag,
			 ivd_type
		  )


		  SELECT
			 @new_inv_detail_id,
			 @inv_key,
			 1, 
			 (
				CASE 
					WHEN op.prc_price > 0 AND (@line_items_total-op.prc_price) < 0.00
					   THEN @line_items_total
					WHEN op.prc_percent > 0
					   THEN (op.prc_percent/100)*@line_items_total					   					   
					ELSE op.prc_price
				END				    
			 ),
			 1,
			 op.prc_gla_ar_key,
			 op.prc_gla_revenue_key,
			 op.prc_key,
			 op.prc_prd_key,
			 op.prc_prd_ptp_key,
			 0,
			 0,
			 0,
			 1,
			 0,
			 0,
			 0,
			 'RegistrationWizard',
			 GETDATE(),
			 0,
			 'discount'
		  FROM oe_price op
		  WHERE op.prc_key = @prc_key
		  AND op.prc_delete_flag = 0
		  AND (op.prc_start_date IS NULL OR op.prc_start_date <= GETDATE())
		  AND (op.prc_end_date IS NULL OR op.prc_end_date >= GETDATE())
		  AND (op.prc_price > 0 OR op.prc_percent > 0)
		  
		 END


