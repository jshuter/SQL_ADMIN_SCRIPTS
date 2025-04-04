select * from co_organization
where org_add_date > '2016-05-01'

select top 100 * from co_customer_x_customer

-- org type code - 1 -- or_cst_key = '32C17B5C-D2E4-4B93-AAB9-529640C9F343' 
select * from co_organization o 
join co_organization_ext oe on oe.org_cst_key_ext = o.org_cst_key
where oe.org_sponsor_type_ext =  'LDS Church'
and o.org_delete_flag = 0 
and oe.org_status_ext = 'Active' 
and org_ogt_code = 'LDS' 


-- select all LDS Orgs 
select * from co_organization_ext where org_hierarchy_hash_ext is null 


-- 906 active orgs 
select * from co_organization o 
join co_organization_ext oe on oe.org_cst_key_ext = o.org_cst_key
where oe.org_sponsor_type_ext =  'LDS Church'
and o.org_delete_flag = 0 
and oe.org_status_ext = 'Active' 

-- 234 groups
select * from co_organization o 
join co_organization_ext oe on oe.org_cst_key_ext = o.org_cst_key
where oe.org_sponsor_type_ext =  'LDS Church'
and o.org_delete_flag = 0 
and oe.org_status_ext = 'Active' 
and org_ogt_code = 'Group' 


--- Create Coupon 

insert into client_scouts_coupons ( 
  z83_key
, z83_coupon_type
, z83_expiry_date
, z83_org_cst_key 
) 
values (
  NEWID() 
  , 'LDS'
  , '2016-12-31'
  , '32C17B5C-D2E4-4B93-AAB9-529640C9F343'
 ) 
 
select * from client_scouts_coupons


-- 339 non child - subsiduary relationships

select COUNT(*) 
from co_customer_x_customer
where cxc_rlt_code <> 'Child' 
and  cxc_rlt_code2 <> 'Child' 
and cxc_add_date > '2015-01-01'



select * from 
client_scouts_coupons c
join co_organization o on o.org_cst_key = c.z83_org_cst_key 
where c.z83_delete_flag = 0 
