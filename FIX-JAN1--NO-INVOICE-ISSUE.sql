/* 

-- SELF REG -- 

select 'set @x13_key=''' + cast (x13_key as varchar(100))  + '''' , x13_key 
from client_scouts_experimental_registration 
where x13_add_date > '2015-12-31' 
and x13_source = 'Self' 
and x13_inv_key IS NULL
and x13_delete_flag = 0 
and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- participant 
and x13_z70_key is not NULL 
order by x13_add_date
*/

/* 
-- BY COUNCIL REG / GROUP REG

-- select x13_key, x13_ixo_key, x13_ind_cst_key_1, x13_ind_cst_key_2, x13_source , x13_progress, x13_inv_key, x13_add_date

select 'set @x13_key=''' + cast (x13_key as varchar(100))  + '''' , x13_key 
from client_scouts_experimental_registration 
where 
x13_progress in ('Confirmation','Payment Added') AND 
x13_inv_key IS NULL and
x13_add_date > '2016-01-01' and 
x13_source = 'Registrar'  and 
x13_delete_flag = 0 and 
x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' --and  -- participant << $$ 
order by x13_add_date 
*/
----------------------------------------------------------------------------------------------------------------

-- TEST WITH : x13-key  cst-key-1 cst-key-2 

-- 57B576AB-15B8-43C6-B81E-056AA228A610		F5C9119A-49CB-4EE0-96D8-28C2FFEFC5F7	EA486A1D-CD59-4ABA-9AA3-143975C7F326
-- 58E640AC-35C3-4652-89FD-05877F7B08AC		AFDC1AAE-D85C-4D30-BC03-9D48F8A53A7D	B193DBCC-AAE0-4CED-93B0-40499BCB8B40

	/* PARAMS */
	
	declare	@x13_key	uniqueidentifier = '58E640AC-35C3-4652-89FD-05877F7B08AC'
	declare	@type		nvarchar(50) = 'Payment' 

	-- FIX FOR SELF REG WITH NO INVOICES 	
	
	--set @x13_key='563489A9-6C41-4270-83C9-CA2A1AFFC103'
	--set @x13_key='F136F766-2540-4DFB-8117-8BAEEADDE528'
	--set @x13_key='0BBBA27E-4EF0-4CF8-A34B-512CE7096C9F'
	--set @x13_key='920210B0-7053-4225-AA0B-5B7C7BB294BB'
	--set @x13_key='C8D31539-03F3-4F32-BF8E-DA922B66D705'
	--set @x13_key='38F29595-ABEF-421A-9B95-7F4AE3D535C8'
	--set @x13_key='BF0D09FC-EA2D-4FD6-85AE-85A8920F3866'
	--set @x13_key='F4E6E831-CE25-4B58-98CD-21ED031B9255'
	--set @x13_key='469BADDF-5E25-4E04-85CF-ECF151C89434'
	--set @x13_key='14CBD1C4-5B6B-480E-8995-5746E2DDD16C'
	--set @x13_key='90407873-F33D-428E-90CF-123768719DB6'
	--set @x13_key='07CF3368-4B1F-4D4D-9F9B-D39EC91F5C5C'
	--set @x13_key='C829609B-D093-41E0-B862-088086FAD396'
	--set @x13_key='EB07A848-42E0-4FD7-BE84-D154CBA4F24C'
	--set @x13_key='4AE93878-4CD9-4BB9-A035-714212E21424'
	--set @x13_key='9D8B7434-D6A5-47EC-BC67-6A6C5AE74388'
	--set @x13_key='1C86576F-ED38-4F36-97A3-2E5D88E71EA2'
	--set @x13_key='C6821190-E117-4E93-B829-EB8293D8F6F9'
	--set @x13_key='EC02317D-3A13-4A9E-81AE-CB33D8F1E254'
	--set @x13_key='A719E2A4-0683-4292-9FB2-60244996A06E'
	--set @x13_key='872DC3EF-717C-467B-9FB7-5553C1FA7D1E'
	--set @x13_key='E7C2BA7A-4490-4F4F-BC37-676350C8AB6F'
	--set @x13_key='06EC2807-1226-423F-909B-81AED470EBF2'
	--set @x13_key='17D5B522-7A53-41BD-AB0C-E6F1E5E23FC6'
	--set @x13_key='842D0FB4-CDDA-45E9-BCD1-0B8BF0F129E3'
	--set @x13_key='FA7C5679-608E-4489-BC84-4D417A619C77'
	--set @x13_key='948EC139-B0E3-4675-9B66-BB07D4BC67F8'
	--set @x13_key='C593001C-B239-47AC-8DDF-CD87D8405073'
	--set @x13_key='1A25FD46-18B9-46B9-8C72-254E5A4A9382'
	--set @x13_key='9F26EAC7-24FF-43B2-B368-26E12F97D2F8'
	--set @x13_key='F7C4A106-57F9-4220-A244-BA953A73C44A'
	--set @x13_key='A8EC3F69-ECCF-4EB3-AC52-B796703C9DFE'
	--set @x13_key='0439A085-DEF2-4EDD-AA55-1346DE62C540'

-- 
-- AND THEN Create invoices for ONE  created by Council Registrar
-- IE - one that had NOLB FK to it 
--

	set	@type =	'PaymentWithDiscount' 
	set @x13_key='403D9FDC-4FFB-4445-92FC-EC1ECAAA5888'

-- 
-- AND THEN Create invoices for those created by Group Registrars 
--
	--set	@type = 'PaymentRegistrar' 

	--set @x13_key='5D52DC94-AD3E-4395-B870-6E3A51AADA7B'
	--set @x13_key='A5CA7883-A29A-4FBC-A21D-AE79476B8C69'
	--set @x13_key='B9B0EEEE-CBDA-41A4-A0FF-A9D71327C979'
	--set @x13_key='2032B9A4-6C05-4972-8C40-ECFB61111D2F'
	--set @x13_key='B0BC93FE-7BF2-4C8A-BA75-A704E17A5804'
	--set @x13_key='5CBC0F14-4B21-4931-82C3-6EA15AEB9E11'
	--set @x13_key='20038E8B-E31A-4FD4-B2F1-A00FA8D910F0'
	--set @x13_key='1F4C8B90-62F1-4D50-B3A6-8041C4BB8B83'
	--set @x13_key='2B0C35A7-4898-45B7-963B-7B8D5C44AE93'
	--set @x13_key='28CFAB6F-465F-4587-AEFE-D4287F6185C5'
	--set @x13_key='5E7765EB-DAF0-4692-AA69-88599D81DF03'
	--set @x13_key='484F2541-52C1-42FF-A44F-D3692438A926'
	--set @x13_key='3D648ABE-406A-4276-A049-DC86738BD4E2'
	--set @x13_key='F4DC0432-01A5-474D-890C-E895180F6206'
--ERROR--	set @x13_key='2A1F1CCD-CB9A-4BAA-A1A7-84F16983ACE4'
-- ERROR -- 	set @x13_key='DE52956A-E4F6-41BC-B3D8-D03CFE985519'
-- ERROR -- 	set @x13_key='DCF30055-11D6-41AC-AAEF-08E3BF728388'
-- ERROR --		set @x13_key='00A92A69-AC36-4DD8-A3A2-C48AC1311DAC'
--	set @x13_key='D72BCFE2-9065-40BC-9799-D453D34399AF'
--	set @x13_key='C992D0B4-B444-4812-BF99-C0F2D0E36659'
--	set @x13_key='60DC75AF-36A4-4A87-A136-66A743476A1C'
--	set @x13_key='280AEF1E-97FB-4E02-85E0-EC874A6A7E87'
--	set @x13_key='00BAC0C9-845D-4393-9BAC-B7B46E8FC2DB'
--	set @x13_key='9A0C2D74-ACDD-4DD2-8A7F-3669AC48FF5D'
--	set @x13_key='A9D6E9B4-39DC-40EE-B100-039C80D95D54'
--	set @x13_key='8C5C6A2F-C23C-46A7-839B-1005C92F387B'
--	set @x13_key='2435DFEF-C4B8-4185-899D-FBE696C23DA4'
--	set @x13_key='DD958101-0374-4C32-BAA9-F76DF39957AA'
--	set @x13_key='71ED5ADE-6376-424C-A940-CFAA36CD65F0'
--	set @x13_key='75F7785F-67E9-4910-801B-B3B6161E72C0'
--	set @x13_key='F00E188C-CDB6-43AC-A049-F5094C95E28A'
--	set @x13_key='B8B793CF-74C4-4F34-8B29-AFCDAF5FC1E8'
--	set @x13_key='BE27DDCA-D058-42B9-A220-8FEC8162946C'
--	set @x13_key='01418C61-BC33-4D48-A9A9-3DE03CB310EB'
--	set @x13_key='48DBA651-E292-4C87-8B20-F0D9EA08237F'
--	set @x13_key='7085EB99-10BE-41E2-A951-F84729F0848F'
--	set @x13_key='6029AA27-ACF0-4F63-9F79-C46B76E61D1F'
--	set @x13_key='DC8A1650-070E-4193-A9C8-93D842DC24B1'
--	set @x13_key='B8DD9582-E8FF-4FB4-87CB-3315B652E5B7'
--	set @x13_key='D8142A6A-5CDD-4540-91A7-8EB5EE4C7688'
--	set @x13_key='ACC07086-C058-4411-84C1-42903B678FC2'
--	set @x13_key='1A66F363-97E4-498E-A6A1-57E57E9F93C5'
--	set @x13_key='61052BDD-F20F-4C5A-8ACF-86FA2E7CE949'
--	set @x13_key='06EE7B5D-B72D-4262-BFED-B767132078C3'
--	set @x13_key='74C4BD64-96FC-43BB-AC85-71B14D95949A'
--	set @x13_key='382EE0F3-3F2B-4B45-8EF4-5F2E46248117'
--	set @x13_key='CFE411A5-AD22-4A68-ADCF-A92B2C0AD031'
--	set @x13_key='C144F1C7-E529-48CB-8ED4-89ECF5D5A393'
--	set @x13_key='49807655-90D1-4A6A-B5F0-BDB121A04BC2'
--	set @x13_key='D3C53A9B-873E-4C5D-9F0C-F6623DEC7AD9'
--	set @x13_key='3AC95157-5A09-458B-BD15-37F2061507AD'
--	set @x13_key='C2DA9919-4868-4E6E-AFD2-33652D7B8509'
--	set @x13_key='9AB998E7-5AC6-4437-96DD-69E3673679A3'
--	set @x13_key='5B2D6166-128A-4481-9F03-98F91AC0E9A6'
--	set @x13_key='D83D49D4-1265-4326-AAC3-F767BD27FFD3'
	

-- new invoice fix - 20160501 

-- see ticket 285569 

SET	@type    = 'Payment' 
SET @x13_key = '6C3E744E-8E63-4594-A415-95424B916F82'

--- 

	/* start script */
	
	declare @newid uniqueidentifier = newid()

	/* set progress code */
	
	update	client_scouts_experimental_registration
	set		x13_progress	= 'Confirmation'
	where	x13_key = @x13_key


	if (@type = 'Payment' or @type = 'PaymentRegistrar' or @type = 'PaymentWithDiscount' )
		and (select x13_inv_key from client_scouts_experimental_registration(nolock) where x13_key = @x13_key) is null
		begin

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
		declare @regyear			nvarchar(4)		 = (select x13_type from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
		declare @adduser			nvarchar(50)	 = 'RegistrationWizard';
		declare @cst_key			uniqueidentifier = (select isnull(x13_ind_cst_key_1,x13_ind_cst_key_2) from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
		declare @cxa_key			uniqueidentifier = (select cst_cxa_key from co_customer(nolock) where cst_key = @cst_key);
		declare @org_cst_key		uniqueidentifier = (select x13_org_cst_key from client_scouts_experimental_registration(nolock) where x13_key = @x13_key);
		declare @bat_org_key		uniqueidentifier = @org_cst_key;

		-- Find the group's batch if possible --<< Use National Batch 
		if  @type = 'Payment' or @type = 'PaymentWithDiscount' begin
			set @bat_org_key = (select top 1 org_cst_key from co_organization(nolock) where org_name = 'Scouts Canada' and org_ogt_code = 'National' and org_delete_flag = 0)
		end	if (select org_ogt_code from co_organization(nolock) where org_cst_key = @bat_org_key) = 'Group' begin
			set @bat_org_key = (select top 1 cst_key from co_customer(nolock) inner join co_organization(nolock) on org_cst_key = cst_parent_cst_key where org_cst_key = @bat_org_key)
		end		

		-- Open a batch if necessary
		declare @bat_key uniqueidentifier = (select dbo.client_scouts_get_online_batch_key(@bat_org_key))
		if @bat_key is null or @bat_key = '00000000-0000-0000-0000-000000000000' begin
			set @bat_key = NEWID()
			exec client_scouts_create_online_batch @bat_key = @bat_key, @bat_code = '', @org_name = '', @org_cst_key = @bat_org_key
		end

-- TEST 
-- select * from ac_invoice where inv_add_date > '2016-01-01'		

		-- Create invoice
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
		)
		values
		(	@inv_key,
			0,
			(select top 1 CONVERT(int,inv_code)+1 from ac_invoice order by CONVERT(int,inv_code) desc),
			@cst_key,
			@cst_key,
			null,
			0,
			@bat_key,
			@cxa_key,
			GETDATE(),
			'prepaid',
			'25E2CD93-3875-4150-858B-7AC518FA8998', -- hardcoded key
			3,0,
			1,0,
			@adduser,
			getdate(),
			0
		)
		-- Create invoice extensions
		insert into ac_invoice_ext(inv_key_ext, inv_agree_term_ext) values (@inv_key, 0)
  
		
 
		-- Create invoice detail
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
			CASE org_type when 'Group' then @ivd_keygroup when 'Council' then @ivd_keycouncil when 'National' then @ivd_keynational end,
			@inv_key, -- dynamic in future
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
		from	dbo.client_scouts_registration_line_items_table(@org_cst_key,@mbt_code,@regyear,null) where	price_okay = 1
		-- Create invoice detail extensions
		insert into ac_invoice_detail_ext (ivd_key_ext) select @ivd_keygroup union select @ivd_keycouncil union select @ivd_keynational


		-- Create payment info
		insert ac_payment_info 
		(	pin_key,
			pin_cst_key,
			pin_apm_key,
			pin_check_amount,
			pin_cc_preauth_flag,
			pin_add_user,
			pin_add_date,
			pin_delete_flag
		)
		values
		(	@pin_key,
			@cst_key,
			CASE @type	when 'Payment' then  'ED1A3944-D916-41C4-A646-EB2D558AE867' 
						when 'PaymentWithDiscount' then 'ED1A3944-D916-41C4-A646-EB2D558AE867' -- TODO -- Verify //should we use same APM_KEY as 'Payment' ??
						when 'PaymentRegistrar' then '3E6BDC73-0DA9-43EF-8268-F6749657784F' 
						else '3E6BDC73-0DA9-43EF-8268-F6749657784F' end,
			(select sum(price) from dbo.client_scouts_registration_line_items_table(@org_cst_key,@mbt_code,@regyear,null) where price_okay = 1),
			0,
			@adduser,
			GETDATE(),
			0
		)
		-- Create payment info extensions
		insert ac_payment_info_ext (pin_key_ext) values (@pin_key)


		-- Create payment 
		insert into ac_payment(
			pay_key,
			pay_code,
			pay_bat_key,
			pay_pin_key,
			pay_trx_date,
			pay_cst_key,
			pay_bat_close_flag,
			pay_post_flag,
			pay_add_user,
			pay_add_date,
			pay_delete_flag
		)
		values 
		(
			@pay_key,
			(select top 1 CONVERT(int,pay_code)+1 from ac_payment order by pay_add_date desc),
			@bat_key,
			@pin_key,
			GETDATE(),
			@cst_key,
			0,
			0,
			@adduser,
			GETDATE(),
			0
		)
		-- Create payment extensions
		insert into ac_payment_ext(pay_key_ext) values (@pay_key)


		-- Create payment detail
		insert into ac_payment_detail
		(
			pyd_key,
			pyd_pay_key,
			pyd_ivd_key,
			pyd_type,
			pyd_amount,
			pyd_gla_dr_key,
			pyd_gla_cr_key,
			pyd_cc_held_status,
			pyd_void_flag,
			pyd_add_user,
			pyd_add_date,
			pyd_delete_flag
		)
		select
			CASE org_type when 'Group' then @pyd_keygroup when 'Council' then @pyd_keycouncil when 'National' then @pyd_keynational end,
			@pay_key, 
			CASE org_type when 'Group' then @ivd_keygroup when 'Council' then @ivd_keycouncil when 'National' then @ivd_keynational end,
			'payment',
			price,
			prc_gla_ar_key,
			prc_gla_revenue_key,
			0,
			0,
			@adduser,
			GETDATE(),
			0
		from	dbo.client_scouts_registration_line_items_table(@org_cst_key,@mbt_code,@regyear,null) where	price_okay = 1 
		-- Create payment detail extensions
		insert into ac_payment_detail_ext (pyd_key_ext) select @pyd_keygroup union select @pyd_keycouncil union select @pyd_keynational

		-- Signal payment received
		update	client_scouts_experimental_registration
		set		x13_inv_key = @inv_key,
				x13_progress = 'Payment Received'
		where	x13_key = @x13_key
		
		
		-- MYAGI 20150716-NOLB: Apply discounts, if discount found
		
	     IF (select x13_inv_key from client_scouts_experimental_registration(nolock) where x13_key = @x13_key) is not null
	     AND (select TOP 1 z80_prc_key from client_scouts_discount(nolock) where z80_experimental_registration_key = @x13_key) is not null
	     BEGIN
	     
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

		-- Upon receipt, make the Participant active immediately
		if (select top 1 mbt_code from mb_member_type(nolock) inner join client_scouts_experimental_registration(nolock) on mbt_key = x13_mbt_key where x13_key = @x13_key) = 'Participant' begin
			update	co_individual_x_organization_ext
			set		ixo_status_ext = 'Active'
			where	ixo_key_ext = (select x13_ixo_key from client_scouts_experimental_registration(nolock) where x13_key = @x13_key)

			update	co_individual_ext
			set		ind_status_ext = 'Active'
			where	ind_cst_key_ext = (select x13_ind_cst_key_2 from client_scouts_experimental_registration(nolock) where x13_key = @x13_key)

		end
		
	end	-- @type in (Payment, PaymentRegistrar, PaymentWithDiscount) AND inv_key is NULL...

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


