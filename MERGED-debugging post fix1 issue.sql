
-- list all customer info from MERGED RECORDS  

select cst_change_user, cst_delete_flag, * from co_customer where cst_recno in (
	select z77_f2 as 'hidden_recno' from client_scouts_generic_log 
)


select *  from client_scouts_generic_log 
order by z77_f4,  z77_add_date 


-- CAUSED ERROR -- 




UPDATE  client_scouts_experimental_registration  
SET  x13_ixo_key =   'E77F0AB8-752A-4A40-8CF8-1284EF41DB65'  
WHERE  x13_ixo_key = '5DA389A5-0DD6-4182-84DC-F854B1B21E9B'





select * from client_scouts_experimental_registration  WHERE  x13_ixo_key = '5DA389A5-0DD6-4182-84DC-F854B1B21E9B'

select * from 
client_scouts_experimental_registration  
WHERE  x13_ixo_key =  'E77F0AB8-752A-4A40-8CF8-1284EF41DB65' 


declare @old_key  as varchar(100) 
set @old_key = '2606a065-a672-408b-9e8e-a284ecbc714a'

declare @new_key as varchar(100)
set @new_key = 'eabd8a21-0e65-4420-a6c7-5020e94e26f1'

select * from client_scouts_experimental_registration  WHERE  x13_ind_cst_key_1 = @old_key 
select * from client_scouts_experimental_registration  WHERE  x13_ind_cst_key_2 = @old_key 

select * from client_scouts_experimental_registration  WHERE  x13_ind_cst_key_1 = @new_key 
select * from client_scouts_experimental_registration  WHERE  x13_ind_cst_key_2 = @new_key 

	 
select ixo_key, ixo_org_cst_key from
co_individual_x_organization ixo1 where ixo1.ixo_ind_cst_key = @old_key 
order by ixo_key

select ixo_key,  ixo2.ixo_org_cst_key 
from co_individual_x_organization ixo2 where ixo2.ixo_ind_cst_key = @new_key 
order by ixo_key

-- DELETES HERE 
-- DELETE co_individual_x_organization where ixo_key in 
select ixo_key from co_individual_x_organization ixo1 where ixo1.ixo_ind_cst_key = @old_key and 
	 ixo1.ixo_org_cst_key not in  (select ixo2.ixo_org_cst_key from co_individual_x_organization ixo2 where ixo2.ixo_ind_cst_key = @new_key ) 
	 