
select top 10 cst_eml_address_dn, cst_recno as recno, * from co_customer where cst_eml_address_dn like 'zzjeffrey%'
order by cst_recno 

begin transaction 

update co_customer 
set cst_eml_address_dn =  substring(cst_eml_address_dn, 3,LEN(cst_eml_address_dn)-4 )
where cst_eml_address_dn like 'zz%zz' 

select top 10 cst_eml_address_dn, cst_recno as recno, * from co_customer where cst_eml_address_dn like 'jeffrey%'
order by cst_recno 

-- commit 

-- rollback 