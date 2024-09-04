
	-- If an invoice has been created with only 2 detail lines (propably caused by a missing FEE for Group or Council) 
	-- then the invoice may be created, but it will not be able to be Cancelled or Returned in iWeb 
	-- The following Code is used to insert the missing Product & Paymnet rows so that the Invoice can be Cancelled/Refunded/etc 
	
	declare @ac_code		integer = 461073-- 461073 
	declare @inv_key		uniqueidentifier
	declare @regyear		varchar(4) = '1111'
	declare @org_cst_key	uniqueidentifier 
	declare @mbt_code		nvarchar(50) 
	declare @x13_key		uniqueidentifier 
	declare @cst_key			uniqueidentifier

	-- random keys for Gruop & Council 
	declare @ivd_keygroup		uniqueidentifier = NEWID();
	declare @ivd_keycouncil		uniqueidentifier = NEWID();
	declare @pyd_keygroup		uniqueidentifier = NEWID();
	declare @pyd_keycouncil		uniqueidentifier = NEWID();

	SELECT * FROM AC_INVOICE WHERE INV_CODE = @ac_code 
	SELECT @inv_key = inv_key FROM AC_INVOICE WHERE INV_CODE = @ac_code 
	select @x13_key = x13_key , @regyear=x13_type,@org_cst_key=x13_org_cst_key from client_scouts_experimental_registration where x13_inv_key = @inv_key  

	select @cst_key = isnull(x13_ind_cst_key_1,x13_ind_cst_key_2) from client_scouts_experimental_registration(nolock) where x13_key = @x13_key

	select @mbt_code = mbt_code from client_scouts_experimental_registration(nolock) inner join mb_member_type(nolock) on mbt_key = x13_mbt_key where x13_key = @x13_key
	select @regyear 
	select @mbt_code 

	select * from dbo.client_scouts_registration_line_items_table(@org_cst_key,@mbt_code,@regyear,null) where	price_okay = 1

	--- Now check actual invoice 

	-- 1 -- check for missing EXT data 
	-- invoice detail
	SELECT 'invoice_detail - LEFT JOIN ', * FROM ac_invoice_detail left join ac_invoice_detail_ext on ivd_key_ext = ivd_key WHERE ivd_inv_key = @inv_key
	SELECT 'invoice_detail - JOIN ', * FROM ac_invoice_detail join ac_invoice_detail_ext on ivd_key_ext = ivd_key WHERE ivd_inv_key = @inv_key

/*
begin transaction  
insert into ac_invoice_detail_ext (ivd_key_ext) values('983DFA67-A85D-4B65-91C9-5AAF62168BAD') 
insert into ac_invoice_detail_ext (ivd_key_ext) values('77700F29-805B-42AC-A835-E9D353A1A7D9')
--commit 
--rollback 
*/

	-- 2 -- 1 row found  
	-- payment info
	SELECT 'pin - LEFT JOIN', * FROM ac_payment_info left join ac_payment_info_ext on pin_key_ext= pin_key where pin_key in (select pay_pin_key from ac_payment where pay_cst_key = @cst_key) 
	SELECT 'pin - JOIN', * FROM ac_payment_info join ac_payment_info_ext on pin_key_ext= pin_key where pin_key in (select pay_pin_key from ac_payment where pay_cst_key = @cst_key) 


	-- 3 -- payment 
	select 'payment - LEFT JOIN', * from ac_payment left join ac_payment_ext on pay_key_ext = pay_key	where pay_cst_key = @cst_key 
	select 'payment - JOIN', * from ac_payment join ac_payment_ext on pay_key_ext = pay_key	where pay_cst_key = @cst_key 

	-- 4 payment detail
	select 'payment_detail - LEFT JOIN', * from ac_payment_detail left join ac_payment_detail_ext on pyd_key = pyd_key_ext where pyd_ivd_key in (select ivd_key from ac_invoice_detail where ivd_inv_key=@inv_key) 
	select 'payment_detail - JOIN', * from ac_payment_detail join ac_payment_detail_ext on pyd_key = pyd_key_ext where pyd_ivd_key in (select ivd_key from ac_invoice_detail where ivd_inv_key=@inv_key) 

/* 

begin transaction 
insert into ac_payment_detail_ext (pyd_key_ext) values('78BCC2A1-4A0D-4EC2-88C6-7047713E575A') 
insert into ac_payment_detail_ext (pyd_key_ext) values('99EF8306-EF52-4769-814D-127030E08501') 

--rollback 
--commit 
*/
