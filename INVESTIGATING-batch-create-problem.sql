-- 39  -- (progress is always 'Confirmation' or 'Payment Added'

-- BY COUNCIL REG / GROUP REG

select x13_key, x13_ixo_key, x13_ind_cst_key_1, x13_ind_cst_key_2, x13_source , x13_progress, x13_inv_key, x13_add_date
from client_scouts_experimental_registration 
where 
x13_progress in ('Confirmation','Payment Added') AND 
x13_inv_key IS NULL and
x13_add_date > '2016-01-01' and 
x13_source = 'Registrar'  and 
x13_delete_flag = 0 and 
x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' --and  -- participant << $$ 
order by x13_add_date 



select * from co_individual_x_organization 
where ixo_key in (
'FC9BE07B-50FF-4B88-AEAD-F23B931761B3',
'63942547-F5E4-4360-9618-E3D84D9E66EA',
'CDC1EAE8-E7A4-4431-9F19-3F103B7C83A5',
'0F5E22D6-DC45-4A73-B3DE-E906B1A56EC3'
)


select * from co_organization where org_cst_key = '8D0A47EB-EA02-4D29-969E-6CF945C387A2'


-- INVOICE / BATCH could not be created for this ORG !!!! ---

select reg.* from co_individual_x_organization org
join client_scouts_experimental_registration reg
on reg.x13_ixo_key = org.ixo_key 
where reg.x13_add_date > '2015-01-01'
and org.ixo_org_cst_key = '8D0A47EB-EA02-4D29-969E-6CF945C387A2'

select org.* from co_individual_x_organization org
join client_scouts_experimental_registration reg
on reg.x13_ixo_key = org.ixo_key 
where reg.x13_add_date > '2015-01-01'
and org.ixo_org_cst_key = '8D0A47EB-EA02-4D29-969E-6CF945C387A2'


















-- FOR COUNCIL REG : ONE NOLB Used in x13_key '403D9FDC-4FFB-4445-92FC-EC1ECAAA5888'
-- ALL OTHERS ... NO NOLB 

select * from client_scouts_discount 
where z80_experimental_registration_key in (
	select x13_key
	from client_scouts_experimental_registration 
	where 
	x13_progress in ('Confirmation','Payment Added') AND 
	x13_inv_key IS NULL and
	x13_add_date > '2016-01-01' and 
	x13_source = 'Registrar'  and 
	x13_delete_flag = 0 and 
	x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' --and  -- participant << $$ 
) 


--------------------------------------------------------------------------
-- CHECK FOR DISCOUNTS ! 

-- ONLY 1 of the 39 missing invoices had used a discount - AAB26A26-05A2-4B11-9B84-C00BAA14CE33

select z80_experimental_registration_key from client_scouts_discount d where d.z80_experimental_registration_key in (
	select x13_key
	from client_scouts_experimental_registration 
	where 
	x13_inv_key IS NULL and
	x13_add_date > '2016-01-01' and 
	x13_source = 'Self'  and 
	x13_delete_flag = 0 and 
	x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' and  -- participant << $$ 
	x13_z70_key is not NULL -- << CONFIRMATION - TRANS ERR LOG -- FOR SELF REG - INDICATES PAYMENT !
) 





select * from client_scouts_member_account x
where x.z11_ind_cst_key in (
'E5A8CED5-319A-4D4E-9BA8-B5D93BC80FD3',
'B6139D2C-5327-4DB2-95C7-75223B798014',
'21424B06-2323-4F37-9571-829EE945507E',
'D3C7122B-1D90-4140-861B-0422CB172B7B',
'E2E952BB-70A4-47EA-A344-0ECB832D0855',
'0CC06D6A-2967-422C-886D-401D7885EE18') 


--- SEARCH FOR ROVERS 

-- SELF REG -- 

select * from co_individual_x_organization 
where ixo_key in (
	select  x13_ixo_key 
	from client_scouts_experimental_registration 
	where x13_add_date > '2015-12-31' 
	and x13_source = 'Self' 
	and x13_inv_key IS NULL
	and x13_delete_flag = 0 
	and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- participant 
	and x13_z70_key is not NULL 
) 
and ixo_rlt_code like 'R%' 


-- BY COUNCIL REG / GROUP REG
select * from co_individual_x_organization 
where ixo_key in (
	select x13_ixo_key
	from client_scouts_experimental_registration 
	where 
	x13_progress in ('Confirmation','Payment Added') AND 
	x13_inv_key IS NULL and
	x13_add_date > '2016-01-01' and 
	x13_source = 'Registrar'  and 
	x13_delete_flag = 0 and 
	x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' --and  -- participant << $$ 
)
and ixo_rlt_code like 'Rov%'



select cst_recno  from co_customer c join client_scouts_experimental_registration r on c.cst_key = r.x13_ind_cst_key_1 
where x13_key = '403D9FDC-4FFB-4445-92FC-EC1ECAAA5888'

UNION 

select cst_recno  from co_customer c join client_scouts_experimental_registration r on c.cst_key = r.x13_ind_cst_key_2  
where x13_key = '403D9FDC-4FFB-4445-92FC-EC1ECAAA5888'

select * from client_scouts_experimental_registration 
where x13_key = '403D9FDC-4FFB-4445-92FC-EC1ECAAA5888'

10282274