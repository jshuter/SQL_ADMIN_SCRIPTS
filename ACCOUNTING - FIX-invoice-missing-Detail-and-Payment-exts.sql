
	-- If an invoice has been created with only 2 detail lines (propably caused by a missing FEE for Group or Council) 
	-- then the invoice may be created, but it will not be able to be Cancelled or Returned in iWeb 
	-- The following Code is used to insert the missing Product & Paymnet rows so that the Invoice can be Cancelled/Refunded/etc 
	
	-- July 10 - 472470 
	-- July 17 - 476770

	declare @ac_code		integer = 476770 -- 463909 --463913        -- 461073-- 461073 
	declare @inv_key		uniqueidentifier
	declare @regyear		varchar(4) = '1111'
	declare @org_cst_key	uniqueidentifier 
	declare @mbt_code		nvarchar(50) 
	declare @x13_key		uniqueidentifier 
	declare @cst_key		uniqueidentifier

	declare @Fix_key		uniqueidentifier 

	-- random keys for Gruop & Council 
	declare @ivd_keygroup		uniqueidentifier = NEWID();
	declare @ivd_keycouncil		uniqueidentifier = NEWID();
	declare @pyd_keygroup		uniqueidentifier = NEWID();
	declare @pyd_keycouncil		uniqueidentifier = NEWID();

	SELECT 'INVOICE:', * FROM AC_INVOICE WHERE INV_CODE = @ac_code 

	SELECT @inv_key = inv_key FROM AC_INVOICE WHERE INV_CODE = @ac_code 
	select @x13_key = x13_key , @regyear=x13_type,@org_cst_key=x13_org_cst_key from client_scouts_experimental_registration where x13_inv_key = @inv_key  
	select @cst_key = isnull(x13_ind_cst_key_1,x13_ind_cst_key_2) from client_scouts_experimental_registration(nolock) where x13_key = @x13_key

	select @mbt_code = mbt_code 
	from client_scouts_experimental_registration(nolock) inner join mb_member_type(nolock) 
		on mbt_key = x13_mbt_key where x13_key = @x13_key

	select  'REG INFO:',  @regyear ,  @mbt_code 
	
	--------------------------------------------------------
	SELECT 'LINE ITEM CHECK:' 
	select * from dbo.client_scouts_registration_line_items_table(@org_cst_key,@mbt_code,@regyear,null) where	price_okay = 1

	--- Now check actual invoice 

	-- 1 -- check for missing EXT data 
	-- invoice detail
	select 'INVOICE DETAIL  CHECK:'
	SELECT 'invoice_detail - LEFT JOIN ', * FROM ac_invoice_detail left join ac_invoice_detail_ext on ivd_key_ext = ivd_key WHERE ivd_inv_key = @inv_key
	SELECT 'invoice_detail - JOIN ', * FROM ac_invoice_detail join ac_invoice_detail_ext on ivd_key_ext = ivd_key WHERE ivd_inv_key = @inv_key

--------------------------------------------------

	SELECT @fix_key = ivd_key
	FROM ac_invoice_detail LEFT join ac_invoice_detail_ext on ivd_key_ext = ivd_key 
	WHERE ivd_inv_key = @inv_key
		AND ivd_key_ext IS NULL 

	if(@fix_key IS NOT NULL) BEGIN 

		select 'FIX Missing Key: ', @fix_key 

		begin transaction  
		insert into ac_invoice_detail_ext (ivd_key_ext) values(@fix_key) 

		--commit 
		--rollback 

		RETURN -- to view and do manual commit !

	END -- of FIX 

	--------------------------------------------------------
	-- 2 -- 1 row found  
	-- payment info
	select 'PAYMENT INFO CHECK:'
	SELECT 'pin - LEFT JOIN', * FROM ac_payment_info left join ac_payment_info_ext on pin_key_ext= pin_key where pin_key in (select pay_pin_key from ac_payment where pay_cst_key = @cst_key) 
	SELECT 'pin - JOIN', * FROM ac_payment_info join ac_payment_info_ext on pin_key_ext= pin_key where pin_key in (select pay_pin_key from ac_payment where pay_cst_key = @cst_key) 


	--------------------------------------------------------
	-- 3 -- payment 
	select 'PAYMENT CHECK:'
	select 'payment - LEFT JOIN', * from ac_payment left join ac_payment_ext on pay_key_ext = pay_key	where pay_cst_key = @cst_key 
	select 'payment - JOIN', * from ac_payment join ac_payment_ext on pay_key_ext = pay_key	where pay_cst_key = @cst_key 

	--------------------------------------------------------
	-- 4 payment detail
	select 'PAYMENT DETAIL CHECK:' 
	select 'payment_detail - LEFT JOIN', * from ac_payment_detail left join ac_payment_detail_ext on pyd_key = pyd_key_ext where pyd_ivd_key in (select ivd_key from ac_invoice_detail where ivd_inv_key=@inv_key) 
	select 'payment_detail - JOIN', * from ac_payment_detail join ac_payment_detail_ext on pyd_key = pyd_key_ext where pyd_ivd_key in (select ivd_key from ac_invoice_detail where ivd_inv_key=@inv_key) 


--------------------------------------------------

	select @fix_key = pyd_key 
	from  ac_payment_detail 
		left join ac_payment_detail_ext on pyd_key = pyd_key_ext 
		where pyd_ivd_key in (select ivd_key from ac_invoice_detail where ivd_inv_key=@inv_key) 
		AND pyd_key_ext IS NULL 

	if(@fix_key IS NOT NULL) BEGIN 

		select 'FIX Missing Key: ', @fix_key 

		begin transaction  
		insert into ac_payment_detail_ext (pyd_key_ext) values(@fix_key) 

		--commit 
		--rollback 

		RETURN -- to view and do manual commit !

	END -- of FIX 

	--------------------------------------------------------
	select 'ALL DONE! no updates required'