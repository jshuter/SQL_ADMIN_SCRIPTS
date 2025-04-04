
-- TRY TO COPY MISSING ADDRESSES 
-- TRY TO COPY MISSING EMAILS - FROM CHILD TO PARENT 

/* 
-- SUMMARY 

 initial problem involved 29,000 parents with NULL Address and many with NULL EMails 
 from 2014 

 problem meant Parents could not log into myscouts - after entry by registrar 

 ISSUE - email address validation - missing emails - shared emails 

 SINCE 2014 - many members have become inactive 
 many accounts have been fixed - manually 
 
 3561   - 2015 to pres
 29,120 - 2014 to pres
  9,002 - 2014 to pres -- Active 
  13,000 - 2014 to pres -- Not Renewed  
  6,210 - 2014 to pres -- Inactive 
-- FROM ACTIVE ROLES >> 2300 have empty email addresses

  of the 29,000 roles with parents with NULL address 
  -- only 9000 are active childres 
  -- of these 9,000 active children that have parents with no address - 2300 have missing emails as well 
  
 OPTIONS - EMAIL - Copy email from child to parents - or leave as is (10,000 missing emails// For ACTIVE drops to 2,300) 
 
 OPTIONS - addresses - Copy from chile or leave NULL (29,000 records with BLANK address info) 
 
  







select top 10 cxa.*, child.cst_eml_address_dn, cst_prt.cst_eml_address_dn  from 
co_customer child 
 join co_customer_ext childx on child.cst_key = childx.cst_key_ext
 join co_individual childind on childind.ind_cst_key = child.cst_key 
 join co_individual_ext childindx on childindx.ind_cst_key_ext = child.cst_key 
 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child.cst_key and cxc_rlt_code = 'Parent/Guardian'
 join co_customer cst_prt on cxc.cxc_cst_key_1 = cst_prt.cst_key  
 join co_customer_x_address cxa on child.cst_cxa_key = cxa.cxa_key
 where  cxc.cxc_add_date > '2014-01-01'
 and cst_prt.cst_cxa_key is NULL 


select * from  co_address where adr_key in (
'BF209893-6DCE-40C2-95C0-96140EDA08F4',
'47221F7E-3E4D-40BD-A0E1-671F846A0D44',
'ACC88135-B576-481A-8AAB-E1CD15EDC643',
'209FE1C6-BDAE-446D-9901-A5E0798F636D',
'FFE62A1C-469C-42A4-8337-1B0937EA4CC1') 

/*

-- RANDAM LIST Parents with & without missing info : 

select top 10 cst_prt.cst_recno, cst_prt.cst_name_cp, cst_prt.cst_cxa_key,  * -- child.cst_eml_address_dn, cst_prt.cst_eml_address_dn
from co_customer child 
 join co_customer_ext childx on child.cst_key = childx.cst_key_ext
 join co_individual childind on childind.ind_cst_key = child.cst_key 
 join co_individual_ext childindx on childindx.ind_cst_key_ext = child.cst_key 
 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child.cst_key and cxc_rlt_code = 'Parent/Guardian'
 join co_customer cst_prt on cxc.cxc_cst_key_1 = cst_prt.cst_key 
 where  cxc.cxc_add_date > '2014-01-01'
 and cst_prt.cst_cxa_key is NULL 

UNION ALL 

select top 10 cst_prt.cst_recno, cst_prt.cst_name_cp, cst_prt.cst_cxa_key,  * -- child.cst_eml_address_dn, cst_prt.cst_eml_address_dn
from co_customer child 
 join co_customer_ext childx on child.cst_key = childx.cst_key_ext
 join co_individual childind on childind.ind_cst_key = child.cst_key 
 join co_individual_ext childindx on childindx.ind_cst_key_ext = child.cst_key 
 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child.cst_key and cxc_rlt_code = 'Parent/Guardian'
 join co_customer cst_prt on cxc.cxc_cst_key_1 = cst_prt.cst_key 
 where  cxc.cxc_add_date > '2014-01-01'
 and cst_prt.cst_cxa_key is NOT NULL 

ORDER BY cst_prt.cst_cxa_key

----
select count(*) -- child.cst_eml_address_dn, cst_prt.cst_eml_address_dn
from co_customer child 
 join co_customer_ext childx on child.cst_key = childx.cst_key_ext
 join co_individual childind on childind.ind_cst_key = child.cst_key 
 join co_individual_ext childindx on childindx.ind_cst_key_ext = child.cst_key 
 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child.cst_key and cxc_rlt_code = 'Parent/Guardian'
 join co_customer cst_prt on cxc.cxc_cst_key_1 = cst_prt.cst_key 
 where  cxc.cxc_add_date > '2014-01-01'
 and cst_prt.cst_cxa_key is NOT NULL 


-- 29,121 ARE NULL  
-- 46,855 ARE NOT NULL 


-- 573,000 with parent in pos 1 -- 75,000 after 2014 
--  48,000 with Child in pos 1  --    792 after 2014 

where childindx.ind_status_ext = 'Active' 

select top 10 * from co_customer cst_prt where cst_prt.cst_cxa_key is null 
and cst_eml_address_dn is null 

-- MISSING ADDRESS
	-- 31,000 rows where parent has no address 
	-- 26,000 created after '2014-01-01' 
	--  3,000 created after '2015-01-01' 
	--     97 created since fix of MAR 2015 

-- MISSING EMAIL ADDRESS 



EXAMPLE 
10161605 member - Jenny Koo
10161606 member - Soonmi Oh - parent --> BUT IS DUPLICATE OF 10236608 - Soonmi Oh

*/


-- select COUNT(*) from co_customer where cst_cxa_key is null 




declare @parent_cst_key uniqueidentifier 
declare @new_adr_key as uniqueidentifier = newid() 
declare @new_cxa_key as uniqueidentifier = newid() 

-- mother 
select @parent_cst_key = cst_key from co_customer where cst_recno = 10165630

-- child

insert

select @parent_cst_key PK1, @new_adr_key PK2, adr.* from co_customer
join co_customer_x_address on cst_cxa_key = cxa_key
join co_address adr on adr_key = cxa_adr_key
where cst_recno = 10165628


PK1		55F715EE-D8B0-4D86-A4A3-34C8288CFCBC
PK2		B88AAF19-E6E4-4A62-AF61-5667D554C919
adr_country		CANADA
adr_city_state_code Pincher Creek, AB  T0K 1W0
adr_post_code T0K 1W0
adr_state	AB
adr_city	Pincher Creek
adr_line1	1134 John Avenue
adr_line2	NULL
adr_line3	NULL
adr_cst_key_owner	B2CD5B5E-205F-4213-B960-6ECC333E9053
adr_key	2674C74A-3416-4ABC-93E8-6403F51F29F2



--
-- what does normal NEW PARENT look like for REG (non online) 
--

select  top 10 * from client_scouts_experimental_registration r
join co_customer c on c.cst_key = r.x13_ind_cst_key_1
where x13_source = 'Self' 
and x13_delete_flag = 0
and x13_progress <> 'New' 
and x13_progress = 'Confirmation'
and x13_type = '2016'
and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- part

UNION ALL 

select  top 10 * from client_scouts_experimental_registration r
join co_customer c on c.cst_key = r.x13_ind_cst_key_1
where x13_source = 'Registrar' 
and cst_add_date > '2015-01-01'
and x13_delete_flag = 0
and x13_progress <> 'New' 
and x13_progress = 'Confirmation'
and x13_type = '2016'
and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- part

UNION ALL 

select  top 10 * from client_scouts_experimental_registration r
join co_customer c on c.cst_key = r.x13_ind_cst_key_1
where x13_source = 'Registrar' 
and cst_add_date > '2015-01-01'
and x13_delete_flag = 0
and x13_progress <> 'New' 
and x13_progress = 'Confirmation'
and cst_cxa_key IS NULL 
and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- part
order by x13_source 


/* --- LOOKING For dif between reg by reg and self 

CONCLUSION 

MAIN DIFF  IS THAT CHILD RECORDS HAVE ADDRESS AND PARENT RECORDS DO NOT 


self must have account - reg by reg may no ...

1) x13_z70_key    
if SELF - has key 
if REG - IS NULL 

2) cst_ixo_key IS NULL for many - so Primary is not used by Participants I guess ? 

  2 of 10 REG'd emails are not available -- 
  none@none.none
  notgiven@nowhere.com

3) ALL HAVE VALID CST_CXA_KEY

4) CST_WEB_PASSWORD is NULL for all REG'd (value is SHA1?) 


*/








-- ==================================================================================================
-- NEW TOPIC - reg stats / breakdown by types

-- COUNT TOTAL REG RECORDS - ALL TYPES 
select COUNT(*) from client_scouts_experimental_registration where x13_type = '2016'
-- 2012 - 0
-- 2013 - 0  
-- 2014 -- 22,205
-- 2015 -- 131,803
-- 2016 --  92,323 


-- COUNT WITH IXO (Active or NOT) 
select COUNT(*) from client_scouts_experimental_registration 
where x13_type = '2014'
and x13_ixo_key IS not NULL 
-- 2014 - 15,948 
-- 2015 - 88,000 
-- 2016 - 67,000

select COUNT(*) from client_scouts_experimental_registration reg
join co_individual_x_organization_ext ixo on x13_ixo_key =  ixo.ixo_key_ext 
where x13_type = '2016'
and ixo.ixo_status_ext = 'Active' 
and x13_ixo_key IS not NULL 
-- 2016 -> 52,532 ACTIVE ROLES 



--- 
--  EVAL performance of REGISTRATION - for REG & SELF - for 2016 
--  CONVERSION from X13 -> IXO -> confirmed Payment 
--  REG  : 41,000  > 28,000 > 21,000 
--  SELF : 33,000  > 20,000 > 14,000 
--- 
select COUNT(*) from client_scouts_experimental_registration 
where x13_type = '2016'
and x13_source = 'registrar'

-- SELF: 33,245 
-- REG : 41,542

-- COUNT WITH IXO (Active or NOT) 
select COUNT(*) from client_scouts_experimental_registration 
where x13_type = '2016'
and x13_ixo_key IS not NULL 
and x13_source = 'self'
-- REG  : 28,939 
-- SELF : 20,635 


select COUNT(*) from client_scouts_experimental_registration reg
join co_individual_x_organization_ext ixo on x13_ixo_key =  ixo.ixo_key_ext 
where x13_type = '2016'
and ixo.ixo_status_ext = 'Active' 
and x13_ixo_key IS not NULL 
and x13_source = 'registrar'
-- SELF : 14,456 
-- REG  : 21,761 
--==================================================================================

select top 100
'child', 
child_cst.cst_name_cp child,
parent_cst.cst_name_cp parent, 
child_adr.adr_line1, parent_adr.adr_line1 , child_cst.cst_eml_address_dn child_email , parent_cst.cst_eml_address_dn parent_email , child_adr.* 

from co_customer child_cst
	 join co_customer_ext child_cust_ext on child_cst.cst_key = child_cust_ext.cst_key_ext
	join co_individual child_ind on child_ind.ind_cst_key = child_cst.cst_key 
	join co_individual_ext child_ind_ext on child_ind_ext.ind_cst_key_ext = child_cst.cst_key 
 
	 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child_cst.cst_key and cxc_rlt_code = 'Parent/Guardian'
 
	join co_customer parent_cst on cxc.cxc_cst_key_1 = parent_cst.cst_key 
	 
	join co_customer_x_address child_cxa on child_cst.cst_cxa_key = child_cxa.cxa_key
	join co_address child_adr on child_adr.adr_key = child_cxa.cxa_adr_key 
	
	left outer join co_customer_x_address parent_cxa on parent_cst.cst_cxa_key = parent_cxa.cxa_key
	left outer join co_address parent_adr on parent_adr.adr_key = parent_cxa.cxa_adr_key 
 
 where  cxc.cxc_add_date > '2015-01-01'
 and parent_cst.cst_cxa_key is  NULL 
-- and parent_cst.cst_eml_address_dn IS NULL 

UNION ALL 

select top 100
'parent', 
child_cst.cst_name_cp child,
parent_cst.cst_name_cp parent, 
child_adr.adr_line1, parent_adr.adr_line1  , child_cst.cst_eml_address_dn child_email, parent_cst.cst_eml_address_dn parent_email, parent_adr.* 

from co_customer child_cst
	 join co_customer_ext child_cust_ext on child_cst.cst_key = child_cust_ext.cst_key_ext
	join co_individual child_ind on child_ind.ind_cst_key = child_cst.cst_key 
	join co_individual_ext child_ind_ext on child_ind_ext.ind_cst_key_ext = child_cst.cst_key 
 
	 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child_cst.cst_key and cxc_rlt_code = 'Parent/Guardian'
 
	join co_customer parent_cst on cxc.cxc_cst_key_1 = parent_cst.cst_key 
	 
	join co_customer_x_address child_cxa on child_cst.cst_cxa_key = child_cxa.cxa_key
	join co_address child_adr on child_adr.adr_key = child_cxa.cxa_adr_key 
	
	left outer join co_customer_x_address parent_cxa on parent_cst.cst_cxa_key = parent_cxa.cxa_key
	left outer join co_address parent_adr on parent_adr.adr_key = parent_cxa.cxa_adr_key 
 
 where  cxc.cxc_add_date > '2015-01-01'
 and parent_cst.cst_cxa_key is NULL 
-- and parent_cst.cst_eml_address_dn IS NULL 

order by 2



------------------------------------------- 

select count(*) 
--top 100 'child', child_cst.cst_name_cp child,parent_cst.cst_name_cp parent, 
--child_adr.adr_line1, parent_adr.adr_line1 , child_cst.cst_eml_address_dn child_email , parent_cst.cst_eml_address_dn parent_email , child_adr.* 

from co_customer child_cst
	 join co_customer_ext child_cust_ext on child_cst.cst_key = child_cust_ext.cst_key_ext
	join co_individual child_ind on child_ind.ind_cst_key = child_cst.cst_key 
	join co_individual_ext child_ind_ext on child_ind_ext.ind_cst_key_ext = child_cst.cst_key 
 
	 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child_cst.cst_key and cxc_rlt_code = 'Parent/Guardian'
 
	join co_customer parent_cst on cxc.cxc_cst_key_1 = parent_cst.cst_key 
	 
	join co_customer_x_address child_cxa on child_cst.cst_cxa_key = child_cxa.cxa_key
	join co_address child_adr on child_adr.adr_key = child_cxa.cxa_adr_key 
	
	left outer join co_customer_x_address parent_cxa on parent_cst.cst_cxa_key = parent_cxa.cxa_key
	left outer join co_address parent_adr on parent_adr.adr_key = parent_cxa.cxa_adr_key 
 
 where  cxc.cxc_add_date > '2013-01-01'
 and parent_cst.cst_cxa_key is  NULL 
 and parent_cst.cst_eml_address_dn IS NULL 
 and child_ind_ext.ind_status_ext = 'Active' 
 
-----

select top 100
'child', 
child_cst.cst_name_cp child,
parent_cst.cst_name_cp parent, 
child_adr.adr_line1, parent_adr.adr_line1 , child_cst.cst_eml_address_dn child_email , parent_cst.cst_eml_address_dn parent_email , child_adr.* 


SELECT COUNT(*) 
from co_customer child_cst
	 join co_customer_ext child_cust_ext on child_cst.cst_key = child_cust_ext.cst_key_ext
	join co_individual child_ind on child_ind.ind_cst_key = child_cst.cst_key 
	join co_individual_ext child_ind_ext on child_ind_ext.ind_cst_key_ext = child_cst.cst_key 
 
	 join co_customer_x_customer cxc on cxc.cxc_cst_key_2 = child_cst.cst_key and cxc_rlt_code = 'Parent/Guardian'
 
	join co_customer parent_cst on cxc.cxc_cst_key_1 = parent_cst.cst_key 
	 
	join co_customer_x_address child_cxa on child_cst.cst_cxa_key = child_cxa.cxa_key
	join co_address child_adr on child_adr.adr_key = child_cxa.cxa_adr_key 
	
	left outer join co_customer_x_address parent_cxa on parent_cst.cst_cxa_key = parent_cxa.cxa_key
	left outer join co_address parent_adr on parent_adr.adr_key = parent_cxa.cxa_adr_key 
 
 where  cxc.cxc_add_date > '2014-01-01'
 and parent_cst.cst_cxa_key is  NULL -- NO ADDRESS ! Issue 
-- and child_ind_ext.ind_status_ext = 'Active'
 and parent_cst.cst_eml_address_dn IS NULL 

-- 3561   - 2015 to pres
-- 29,120 - 2014 to pres

--   9,002 - 2014 to pres -- Active 
--  13,000 - 2014 to pres -- Not Renewed  
--   6,210 - 2014 to pres -- Inactive 

-- FROM ACTIVE ROLES >> 2300 have empty email addresses



update  co_customer 
set cst_ind_full_name_dn = 'jeffrey.shuter@scouts.ca'
where cst_ind_full_name_dn like 'shuter test%'



begin  transaction 

update co_customer 
set cst_eml_address_dn = 'jeffrey.shuter@scouts.ca' 
where cst_recno = 010209939 

commit 