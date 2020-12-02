-- needed by accounting to complete refunds 

-- check the status and details - see below 

select top 10 * from ac_batch where bat_code like '%-000101'
order by bat_add_date desc  

--- THIS WILL ONLY CREATE IF BATCH IS MISSING !!!!

---- make new batch 

declare @bat_code varchar(100) = '' 
declare @bat_key uniqueidentifier = newid()  
declare @bat_org_key uniqueidentifier = NULL 

--select * from co_organization where org_name like '1st exp%'

exec client_scouts_get_online_batch_by_type 
	@org_cst_key ='725A3F0F-92E3-4B30-AF8B-4FCD308DBC95'  -- org cst from registration (section key) 
	, @reg_type	= 'Payment'							-- 'Payment' | 'PaymentByPaypal' | 'PaymentRegistrar' | 'PaymentByGC' | 'PalmentWithDiscount'
	, @bat_code = @bat_code OUTPUT				-- bat code (if possible) 
	, @x13_source = 'Self' 						-- 'Self' | 'Registrar' 
	, @bat_key = @bat_key OUTPUT				-- bat_key if one exists 
	, @bat_org_cst_key = @bat_org_key OUTPUT	-- org for this org_type 
				
select @bat_code as bat_code, @bat_key as bat_key, @bat_org_key as bat_org_key

if @bat_key is null begin -- batch was not found -- Batch does not exist and needs to be created
	set @bat_key = NEWID()
	exec client_scouts_create_online_batch @bat_key = @bat_key, @bat_code = @bat_code, @org_cst_key = @bat_org_key
end 


