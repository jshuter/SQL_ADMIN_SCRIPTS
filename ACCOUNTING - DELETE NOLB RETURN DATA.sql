
declare @inv_code as int 
declare @inv_key uniqueidentifier = NULL 
declare @ivd_key uniqueidentifier = NULL 

set @inv_code = 389234

select * from ac_invoice where inv_code = @inv_code
select @inv_key = inv_key from ac_invoice where inv_code = @inv_code

select * from ac_invoice_detail where ivd_inv_key = @inv_key 

select @ivd_key = ivd_key from ac_invoice_detail where ivd_inv_key = @inv_key AND ivd_type = 'discount' 

if @ivd_key is NULL begin 
	select 'WARNING - discount DNE - aborting this process.' 
	return 
end 

-- SHOW ITEMS TO DELETE 

select * from ac_return r		where r.ret_ivd_key = @ivd_key  
select * from ac_payment_detail where pyd_ivd_key = @ivd_key  
select * from ac_invoice_detail where ivd_key = @ivd_key  

begin transaction 

------------------------------------------------------------------------------------------------------
-- CANNOT DELETE invoice detail when RETURN exists !
------------------------------------------------------------------------------------------------------
	
delete ac_return where ret_ivd_key = @ivd_key
delete ac_payment_detail where pyd_ivd_key = @ivd_key
delete ac_invoice_detail where ivd_key = @ivd_key 

-- commit 
-- rollback 
-- commit IFF ALL LOOKS GOOD -- 

