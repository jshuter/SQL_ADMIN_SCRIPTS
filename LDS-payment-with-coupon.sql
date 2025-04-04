declare 

	@x13_key	uniqueidentifier	= '38E3A46E-CD48-48D2-B1C7-00001D321453',    -- THE REGISTRATION RECORD KEY 
	@type		nvarchar(50)		= 'PaymentWithCoupon' ,						  -- TYPE OF PAYMNET !
	@value		uniqueidentifier	= '8412CB24-74C9-4A78-AA42-D0BE97B0651A',    -- the TRANSACTION RECORD KEY  
	@invoice_age_threshold int = 15 

	select org_ogt_code from co_organization(nolock) where org_cst_key = 'D1360B87-AEC3-4A3C-9F2A-5276FF8CEA76'
	select dbo.client_scouts_get_online_batch_key('D1360B87-AEC3-4A3C-9F2A-5276FF8CEA76')

------------------------------------------------------------------------
-- RESET FOR TEST -------------------------
update  client_scouts_experimental_registration set x13_progress = 'Terms', x13_inv_key = NULL , x13_z70_key = NULL where x13_key = @x13_key 
select * from client_scouts_experimental_registration where x13_key = @x13_key
select * from client_scouts_online_transaction_error_log where z70_key = '8412CB24-74C9-4A78-AA42-D0BE97B0651A'
select * from ac_batch (nolock) join ac_batch_ext (nolock) on bat_key = bat_key_ext where bat_org_cst_key_ext = (select z83_org_cst_key from client_scouts_coupons where z83_key  = '12121212') 
	and bat_delete_flag = 0 and bat_close_flag = 0
select * from client_scouts_coupons where z83_key = '12121212'
----------------------------------------------------------------------------------

-- assume type = PaymentWithCoupon ...
exec client_scouts_experimental_registration_coupon_payment @x13_key, @value 

/* 
	declare @inv_key			uniqueidentifier = NEWID();
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
	declare @x13_type			nvarchar(10)	 = (select x13_type from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
	declare @adduser			nvarchar(50)	 = 'RegistrationWizard';
	declare @cst_key			uniqueidentifier = (select isnull(x13_ind_cst_key_1,x13_ind_cst_key_2) from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
	declare @cxa_key			uniqueidentifier = (select cst_cxa_key from co_customer(nolock) where cst_key = @cst_key);
	declare @org_cst_key		uniqueidentifier = (select x13_org_cst_key from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
	declare @bat_org_key		uniqueidentifier = NULL ; -- will get from coupons table 
	declare @bat_key			uniqueidentifier = NULL 
	-- handle YYYY+YYYY
	declare @regyear			nvarchar(4) = right(@x13_type,4) 

	-- for Payment By COUPON
	declare @coupon_type as varchar(20) 
	declare @coupon_key as varchar(100) 
	
	---------------------------------------------
	-- initialize data 
	---------------------------------------------
			
	-- Find Coupon_key & Org_Key for this payment ! ASSUMES its there ! 
	
	-- 1 get coupon_code frmo trx log 
	select @coupon_key = z70_auth_code from client_scouts_online_transaction_error_log where z70_key = @value 

	-- 2 get coupon info 
	select @bat_org_key = z83_org_cst_key,  
		@coupon_type = z83_coupon_type 
	from client_scouts_coupons where z83_key = @coupon_key 
			
	-- get BATCH KEY for the COUPON's ORG 
	select 	top 1 @bat_key = bat_key
	from ac_batch (nolock) join ac_batch_ext (nolock) on bat_key = bat_key_ext 
	where bat_org_cst_key_ext = @bat_org_key and bat_delete_flag = 0 and bat_close_flag = 0
	order by bat_code desc 

	-- if Batch is not found - create one 
	if @bat_key is null begin 
		set @bat_key = newid()
		exec client_scouts_create_online_batch_coupon @bat_key, @coupon_type, @coupon_key 
	end 

	-----------------------------
	-- Create invoice
	-----------------------------
	
	insert into ac_invoice 
		(	inv_key,
			inv_proforma, 
			inv_code,
			inv_cst_billing_key, 
			inv_cst_key,
			inv_pref_comm_meth,
			inv_email_confirm_sent_flag,
			inv_bat_key,
			inv_cxa_key,
			inv_trx_date, 
			inv_orig_trans_type,
			inv_ait_key, 
			inv_ship_priority,
			inv_fax_confirm_sent_flag,
			inv_close_flag,
			inv_group_flag,
			inv_add_user,
			inv_add_date, 
			inv_delete_flag
			, inv_po_number
		)
		values
		(	@inv_key,
			0,
			(select top 1 CONVERT(int,inv_code)+1 from ac_invoice order by CONVERT(int,inv_code) desc),
			@bat_org_key, -- @cst_key,  mv billing address to LDS Org 
			@cst_key,
			null,
			0,
			@bat_key,
			@cxa_key,
			GETDATE(),
			'terms',
			'25E2CD93-3875-4150-858B-7AC518FA8998', -- hardcoded key
			3,0,
			0, -- closed -> 'Paid' 
			0,
			@adduser,
			getdate(),
			0, 'test'
		)

		-- Create invoice extensions
		insert into ac_invoice_ext(inv_key_ext, inv_agree_term_ext) values (@inv_key, 0)
  

		-- Create invoice detail -- JUST THE NATIONAL FEE !
		insert into ac_invoice_detail
		(	ivd_key,
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
			ivd_delete_flag
		)
		select
			@ivd_keynational,
			@inv_key, 
			1, 
			price,
			1,
			prc_gla_ar_key,
			prc_gla_revenue_key,
			prc_key,
			prc_prd_key,
			prc_prd_ptp_key,
			0,
			0,
			0,
			1,
			0,-- shipping
			0,
			0,
			@adduser,
			GETDATE(),
			0
		from	dbo.client_scouts_registration_line_items_table(@org_cst_key,@mbt_code,@regyear,null) 
		where	price_okay = 1 and org_type = 'National' 

		-- Create invoice detail extensions -- Just for National 
		insert into ac_invoice_detail_ext (ivd_key_ext)  values(@ivd_keynational) 
		

		------------------------------------------------
		-- -- payment details ?? do we need this ??
		
		-- Create payment info
		insert ac_payment_info (pin_key,pin_cst_key,pin_apm_key,pin_check_amount,pin_cc_preauth_flag,pin_add_user,pin_add_date,pin_delete_flag)
		values (@pin_key,@cst_key, '3E6BDC73-0DA9-43EF-8268-F6749657784F', -- national 
			(select sum(price) from dbo.client_scouts_registration_line_items_table(@org_cst_key, @mbt_code, @regyear, null) where price_okay = 1 and org_type = 'National'),
			0,@adduser,GETDATE(),0)

		-- Create payment info extensions
		insert ac_payment_info_ext (pin_key_ext) values (@pin_key)

		-- Create payment 
		insert ac_payment(pay_key,pay_code,pay_bat_key,pay_pin_key,pay_trx_date,pay_cst_key,pay_bat_close_flag,pay_post_flag, pay_add_user,pay_add_date,pay_delete_flag)
		values (@pay_key,(select top 1 CONVERT(int,pay_code)+1 from ac_payment order by pay_add_date desc),	@bat_key,@pin_key,GETDATE(),@cst_key,0,0,@adduser,GETDATE(),0)
			
		-- Create payment extensions
		insert ac_payment_ext(pay_key_ext) values (@pay_key)

		-- Create payment detail
		insert ac_payment_detail (pyd_key,	pyd_pay_key,pyd_ivd_key,pyd_type,pyd_amount,pyd_gla_dr_key,pyd_gla_cr_key,pyd_cc_held_status,pyd_void_flag,pyd_add_user,pyd_add_date,pyd_delete_flag)
		select @pyd_keynational,@pay_key, @ivd_keynational,'payment',price,prc_gla_ar_key,prc_gla_revenue_key,0,0,@adduser,GETDATE(),0
		from dbo.client_scouts_registration_line_items_table(@org_cst_key,@mbt_code,@regyear,null) where price_okay = 1 and org_type = 'National'

		-- Create payment detail extensions
		insert into ac_payment_detail_ext (pyd_key_ext) values(@pyd_keynational) 

		-- -- 
		-------------------------------------------------	

		-- update 'uses' of coupon 		
		update client_scouts_coupons 
		set z83_coupon_uses = z83_coupon_uses + 1 
		where z83_key = @coupon_key


*/