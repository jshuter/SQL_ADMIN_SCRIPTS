-- If accounint needs paypal batch for day that did not have pp transaction ... create one now 

-- used on July 7 for July 4 batch 

-- ******************************
-- WARNING -- Create Batch process will be adjusted soon, and Batch Name/ Format will change from YYYY-MM-DD to MMDDYY 
--			  client_scouts_create_online_batch_coupon() may be replaced !
-- ******************************

declare @bat_code varchar(100) -- BATCH NAME 
declare @bat_org_key uniqueidentifier -- ORG OWNING BATCH 
declare @bat_key uniqueidentifier -- for new BATCH 
			
select @bat_code 

select * from ac_batch where bat_code like 'PP2017-07%' order by bat_code 
set @bat_code = 'PP2017-07-04' 

-- verify that DNE 
select * from ac_batch where bat_code = @bat_code order by bat_code 

-- set org of batch to National !
set @bat_org_key = (select top 1 org_cst_key from co_organization(nolock) where org_name = 'Scouts Canada' and org_ogt_code = 'National' and org_delete_flag = 0)
select @bat_org_key


-- look for the KEY for this ORG's Monthly Batch  
select top 1 @bat_key = bat_key
from ac_batch (nolock) join ac_batch_ext (nolock) on bat_key = bat_key_ext
where bat_org_cst_key_ext = @bat_org_key AND -- ?? DOES PP need batch key ? 
	bat_code like @bat_code + '%'
	and bat_delete_flag = 0 
	and bat_close_flag = 0
	order by bat_code desc

-- if Batch is not found - create one 
if @bat_key is null begin 
	set @bat_key = newid()	
	select 'Creating batch ', @bat_key, @bat_org_key, @bat_code 
	exec client_scouts_create_online_batch_coupon @bat_key, @bat_org_key, @bat_code 
end else begin 
	select 'Found Existing BAT', @bat_code , @bat_key
	select * from ac_batch where bat_key = @bat_key 
end

