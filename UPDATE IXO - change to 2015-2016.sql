--------------------------
-- 91 problems 
select cst_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type,
	ixo.ixo_start_date sd, ixo.ixo_end_date, x13_source
	, x13_progress,ixo_rlt_code,ixo_add_user --, *
--	, inv.inv_trx_date   
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
--	left outer join  ac_invoice inv  on inv.inv_cst_key = ixo.ixo_ind_cst_key 

where xr.x13_add_date > '2015-05-01 00:00:00'
and x13_type='2016' and ixo_start_date < '2015-08-31 23:59:59'
--and (inv.inv_add_date > '2015-01-01' OR inv.inv_trx_date > '2015-01-01' OR inv.inv_add_date is NULL) 
--and ixo_status_ext = 'Active'
and cst_recno in (10025942,10121474,10162960,10221735,853816,10066418,721269,543164,691410
,841455,10222351,10185746,10222550,10222544,10168287,10159359,910116,837624
,10081934,10222793,10095467,596915,10171448,10084088,708780,10223241,10131345
,10198635,10075930,10172233,10223476,10223517,10081268,785544,10223477
,10175595,10002499,860580,10180055,10221735,10162960,10100407,10222550,10177803)

-- order by cst_recno --, ixo_status_ext,
order by ixo_start_date 

-- 

select cst_recno , ixo.ixo_start_date, ixo.ixo_end_date, cst_key, ixo_key 
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
--	left outer join  ac_invoice inv  on inv.inv_cst_key = ixo.ixo_ind_cst_key 

where xr.x13_add_date > '2015-05-01 00:00:00'
and x13_type='2016' and ixo_start_date < '2015-08-31 23:59:59'
and cst_recno in (10025942,10121474,10162960,10221735,853816,10066418,721269,543164,691410
,841455,10222351,10185746,10222550,10222544,10168287,10159359,910116,837624
,10081934,10222793,10095467,596915,10171448,10084088,708780,10223241,10131345
,10198635,10075930,10172233,10223476,10223517,10081268,785544,10223477
,10175595,10002499,860580,10180055,10221735,10162960,10100407,10222550,10177803)


begin transaction 

update co_individual_x_organization  
set co_individual_x_organization.ixo_start_date = '2015-09-01' , co_individual_x_organization.ixo_end_date = '2016-08-31' 
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
where xr.x13_add_date > '2015-05-01 00:00:00'
and x13_type='2016' and ixo_start_date < '2015-08-31 23:59:59'
and cst_recno in (10025942,10121474,10162960,10221735,853816,10066418,721269,543164,691410
,841455,10222351,10185746,10222550,10222544,10168287,10159359,910116,837624
,10081934,10222793,10095467,596915,10171448,10084088,708780,10223241,10131345
,10198635,10075930,10172233,10223476,10223517,10081268,785544,10223477
,10175595,10002499,860580,10180055,10221735,10162960,10100407,10222550,10177803)

--commit



-- FINAL TEST 

select cst_recno , ixo.ixo_start_date, ixo.ixo_end_date, cst_key, ixo_key , ixo.ixo_rlt_code, x13_org_cst_key
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
--	left outer join  ac_invoice inv  on inv.inv_cst_key = ixo.ixo_ind_cst_key 
where 
--xr.x13_add_date > '2015-05-01 00:00:00'
x13_type='2016' 
-- and ixo_start_date < '2015-08-31 23:59:59'
and cst_recno in (10025942,10121474,10162960,10221735,853816,10066418,721269,543164,691410
,841455,10222351,10185746,10222550,10222544,10168287,10159359,910116,837624
,10081934,10222793,10095467,596915,10171448,10084088,708780,10223241,10131345
,10198635,10075930,10172233,10223476,10223517,10081268,785544,10223477
,10175595,10002499,860580,10180055,10221735,10162960,10100407,10222550,10177803)
order by cst_recno 


----- 

-- Here is list of affected ORGS - lets see if there are in common ?

