
-- 6738 
-- June 18 - 14,744 - PRE REG (
select * from co_individual_x_organization x 
join co_individual_x_organization_ext ext on ext.ixo_key_ext = x.ixo_key
where x.ixo_add_date > '2015-05-04'
and ixo_add_user <> 'MyScouts.System.Renew'
and ixo_start_date > '2015-08-31'

-- 
select * from co_individual_x_organization x 
join co_individual_x_organization_ext ext on ext.ixo_key_ext = x.ixo_key
where x.ixo_add_date > '2015-06-17'
and ixo_add_user <> 'MyScouts.System.Renew'
and ixo_start_date > '2015-08-31'

select * from co_individual_x_organization x 
join co_individual_x_organization_ext ext on ext.ixo_key_ext = x.ixo_key
where x.ixo_add_date > '2015-06-18'
and ixo_add_user <> 'MyScouts.System.Renew'
and ixo_start_date > '2015-08-31'


-- 3241
-- REG REG - JUNE 18 - 3389 (ie approx 140 NEW) 
select * from co_individual_x_organization x 
join co_individual_x_organization_ext ext on ext.ixo_key_ext = x.ixo_key
where x.ixo_add_date > '2015-05-04'
and ixo_add_user <> 'MyScouts.System.Renew'
and ixo_start_date < '2015-05-30'
order by ixo_start_date 

select * from co_individual_x_organization x 
join co_individual_x_organization_ext ext on ext.ixo_key_ext = x.ixo_key
where x.ixo_add_date > '2015-06-17'
and ixo_add_user <> 'MyScouts.System.Renew'
and ixo_start_date < '2015-05-30'
order by ixo_add_date 


-- distribution - 7233 Confirm 1500 reg added 1900 New -- etc 
select count(*), x13_progress 
from client_scouts_experimental_registration xr 
where xr.x13_add_date > '2015-05-01'
group by xr.x13_progress

-- 8401 
select x13_type, ixo.ixo_start_date  
from  client_scouts_experimental_registration xr 
join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
where xr.x13_add_date > '2015-05-03'


-- 188 OK for current year 
select x13_type, ixo.ixo_start_date  from client_scouts_experimental_registration xr 
join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
where xr.x13_add_date > '2015-05-03'
and x13_type='2015' and ixo_start_date < '2015-05-01'

--------------------------

-- 91 problems 
-- 101 problems -- (from May 4) 
-- First fix made soon after Pauls email of May 22

-- 81 New issues since May 22
 -- 79 distinct members 
 
 -- JUNE 18 th - 
 
select cst_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type,
	ixo.ixo_start_date sd, ixo.ixo_end_date, x13_source
	, x13_progress,ixo_rlt_code,ixo_add_user, x13_add_date --, *
--	, inv.inv_trx_date   
--select distinct cst_recno 
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
--	left outer join  ac_invoice inv  on inv.inv_cst_key = ixo.ixo_ind_cst_key 

where xr.x13_add_date > '2015-05-22 00:00:00'
and x13_type='2016' and ixo_start_date < '2015-08-31 23:59:59'
--and (inv.inv_add_date > '2015-01-01' OR inv.inv_trx_date > '2015-01-01' OR inv.inv_add_date is NULL) 
and ixo_status_ext = 'Active'
order by x13_add_date

----- SHOW ALL ACTIVE  ROLES FOR list of members above 

select ALL_IXO.ixo_add_date
,all_ixo.ixo_start_date
,all_ixo.ixo_end_date
, cst_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type,
	ixo.ixo_start_date sd, ixo.ixo_end_date, x13_source
	, xr.x13_progress,ixo.ixo_rlt_code,ixo.ixo_add_user, xr.x13_add_date --, *
--	, inv.inv_trx_date   
--select distinct cst_recno 
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
	join co_individual_x_organization ALL_IXO on ALL_IXO.ixo_ind_cst_key = cst.cst_key 
	join co_individual_x_organization_ext ALL_EXT on ALL_EXT.ixo_key_ext = ALL_IXO.ixo_key
--	left outer join  ac_invoice inv  on inv.inv_cst_key = ixo.ixo_ind_cst_key 

where xr.x13_add_date > '2015-05-22 00:00:00'
	and xr.x13_type='2016' 
	and ixo.ixo_start_date < '2015-08-31 23:59:59'
--and (inv.inv_add_date > '2015-01-01' OR inv.inv_trx_date > '2015-01-01' OR inv.inv_add_date is NULL) 
	and ext.ixo_status_ext = 'Active'
	and ALL_EXT.ixo_status_ext = 'Active' 
order by cst_recno

--- 120 on 05-25  >> 4 were in wrong year !!!
--- select * from client_scouts_experimental_registration where x13_add_date > '2015-05-25 00:00:00'

--- WHICH ONES ARE IN WRONG YEAR -- WHICH GROUP ARE THEY IN ???? 

and cst_recno in (10025942,10121474,10162960,10221735,853816,10066418,721269,543164,691410
,841455,10222351,10185746,10222550,10222544,10168287,10159359,910116,837624
,10081934,10222793,10095467,596915,10171448,10084088,708780,10223241,10131345
,10198635,10075930,10172233,10223476,10223517,10081268,785544,10223477
,10175595,10002499,860580,10180055,10221735,10162960,10100407,10222550,10177803)

order by ixo_status_ext,ixo_start_date 


--------------------------
-- Count good self reg's

-- 2288 all 

-- 1769 - active 
-- 432 - Pending - ie, volunteers
-- 87 - inactive - not completed ... deactivated ? 

select cst_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type,
	ixo.ixo_start_date sd, ixo.ixo_end_date, x13_source
	, x13_progress,ixo_rlt_code,ixo_add_user --, *
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
where xr.x13_add_date > '2015-05-01 00:00:00'
	and ixo.ixo_start_date < '2015-09-01 00:00:00'
	--and ixo_status_ext = 'Active' 
	and x13_type='2016'
order by x13_type, cst_key, ixo_status_ext,ixo_start_date 


--------------------------



select * 

from co_individual_x_organization roles

where roles.ixo_ind_cst_key in (select cst_key
	from client_scouts_experimental_registration xr 
		join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
		join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
		join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
	where xr.x13_add_date > '2015-05-01 00:00:00'
		and x13_type='2016' 
		and ixo_start_date < '2015-08-31 23:59:59'
		and ext.ixo_status_ext = 'Active')
and roles.ixo_start_date > '2015-01-01' 

order by roles.ixo_ind_cst_key

select x13_type, ixo.ixo_start_date sd, ixo.ixo_end_date, *  from client_scouts_experimental_registration xr 
join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
where xr.x13_add_date > '2015-05-04 00:00:00'
and x13_type='2015' and ixo_start_date > '2015-08-31'
order by ixo_start_date 




-- list all invoices 

 

sp_help ac_invoice 