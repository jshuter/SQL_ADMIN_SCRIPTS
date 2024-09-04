
with 

orphan_invoices (Oinv_key, Oinv_cst_key) 
as 
(select inv.inv_key
, inv.inv_cst_key
--, inv.inv_cst_billing_key
--, inv.inv_ind_cst_billing_key
--,er.x13_ind_cst_key_1, er.x13_ind_cst_key_2
-- ,inv.*, er.*  
from ac_invoice inv 
left join client_scouts_experimental_registration er on er.x13_inv_key = inv.inv_key 
where inv.inv_add_date > '2015-09-01' 
and er.x13_key IS NULL) , 

reg_wo_inv (
x13_key,
x13_inv_key, 
x13_preogress
,ixo_cst_key_owner
,ixo_ind_cst_key
,x13_ind_cst_key_1
,x13_ind_cst_key_2
) 
as 
(select er.x13_key, er.x13_inv_key, er.x13_progress, ixo.ixo_cst_key_owner, ixo.ixo_ind_cst_key
,er.x13_ind_cst_key_1, er.x13_ind_cst_key_2
from client_scouts_experimental_registration er
join co_individual_x_organization ixo on er.x13_ixo_key = ixo.ixo_key
where er.x13_add_date > '2015-09-01' 
and er.x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT 
and er.x13_ixo_key is NOT NULL -- HAS ROLE 
and er.x13_inv_key is null     -- HAS NO INVOICE 
and er.x13_progress='Confirmation'
-- and er.x13_source = 'self' --  ('mass renew transfer','registrar','self') <<< 3 rows
and ixo.ixo_rlt_code <> 'Rover Scout Participant') 

-- INSURES 194 orphan invoices are added to EXP_REGISTRATION RECORDS
-- select distinct inv_key  from orphan_invoices O join reg_wo_inv R on O.inv_cst_key = R.ixo_ind_cst_key

--select O.o
--select O.Oinv_cst_key, O.Oinv_key, x13_key  from orphan_invoices O join reg_wo_inv R on O.Oinv_cst_key = R.ixo_ind_cst_key

-- 'SELECT x13_inv_key from client_scouts_experimental_registration where x13_key = ''' +  cast(x13_key as varchar(100)) + ''''  from orphan_invoices O join reg_wo_inv R on O.Oinv_cst_key = R.ixo_ind_cst_key

select 'UPDATE client_scouts_experimental_registration  SET x13_inv_key  = ''' + cast(Oinv_key as varchar(100)) +  ''' where x13_key = ''' +  cast(x13_key as varchar(100)) + ''''  from orphan_invoices O join reg_wo_inv R on O.Oinv_cst_key = R.ixo_ind_cst_key





/**** 







-- 3	- self reg 
-- 22	- registrar 
-- 195  - mass renew transfer 
------------------------------------------------
-- 220 ROWS with no INVOICE BUT WITH A ROLE !
------------------------------------------------

--/ *

select 
count(*) 
-- ixo.ixo_rlt_code, er.* 
from client_scouts_experimental_registration er
join co_individual_x_organization ixo on er.x13_ixo_key = ixo.ixo_key
where er.x13_add_date > '2015-09-01' 
and er.x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT 
and er.x13_ixo_key is NOT NULL -- HAS ROLE 
and er.x13_inv_key is null     -- HAS NO INVOICE 
and er.x13_progress='Confirmation'
--and er.x13_source = 'self' --  ('mass renew transfer','registrar','self') <<< 3 rows
and ixo.ixo_rlt_code <> 'Rover Scout Participant'

-- * /


--------------------------------------------------------------------------
-- problems - inv without reg 

-- INVOICES THAT ARE ORPHANED !  -- 194 of them 
-- CST_KEY of the parent 

select inv.inv_cst_key, inv.inv_cst_billing_key, inv.inv_ind_cst_billing_key
,er.x13_ind_cst_key_1, er.x13_ind_cst_key_2
,inv.*, er.*  
from ac_invoice inv 
	left join client_scouts_experimental_registration er on er.x13_inv_key = inv.inv_key 
where inv.inv_add_date > '2015-09-01' 
and er.x13_key IS NULL 
ORDER BY inv.inv_cst_key 

-- and inv_cst_key <> inv_cst_billing_key --<< ALL ARE IDENTICAL 

-- / * 
---------------------
-- sample good data
-- problems - inv without reg 
select top 100 inv.inv_cst_key, inv.inv_cst_billing_key, inv.inv_ind_cst_billing_key
,er.x13_ind_cst_key_1, er.x13_ind_cst_key_2
,inv.*, er.*  
from ac_invoice inv 
	left join client_scouts_experimental_registration er on er.x13_inv_key = inv.inv_key 
where inv.inv_add_date > '2015-09-01' 
and er.x13_key IS NOT NULL 

-- * /


--------------------------------------------------
select ixo.ixo_cst_key_owner, ixo.ixo_ind_cst_key
,er.x13_ind_cst_key_1, er.x13_ind_cst_key_2
, er.*  
from client_scouts_experimental_registration er
join co_individual_x_organization ixo on er.x13_ixo_key = ixo.ixo_key
where er.x13_add_date > '2015-09-01' 
and er.x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT 
and er.x13_ixo_key is NOT NULL -- HAS ROLE 
and er.x13_inv_key is null     -- HAS NO INVOICE 
and er.x13_progress='Confirmation'
--and er.x13_source = 'self' --  ('mass renew transfer','registrar','self') <<< 3 rows
and ixo.ixo_rlt_code <> 'Rover Scout Participant'
order by x13_source, ixo_ind_cst_key 


*/






