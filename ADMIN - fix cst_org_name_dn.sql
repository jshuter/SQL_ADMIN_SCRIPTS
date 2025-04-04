
set statistics io on 
set statistics time on 

-- FINAL UPDATE SCRIPT 
-- START
update co_customer set cst_org_name_dn = o.org_name
from co_customer(nolock) c 
	join co_individual_x_organization(nolock) ixo on ixo.ixo_key = c.cst_ixo_key				-- << PRIMARY ROLE <<
	join co_individual_x_organization_ext(nolock) ixo_ext on ixo.ixo_key = ixo_ext.ixo_key_ext	-- << HAS STATUS 
	join co_organization(nolock) o on o.org_cst_key = ixo.ixo_org_cst_key						-- << ORGS REAL NAME 
	join co_individual_ext(nolock) ie on ie.ind_cst_key_ext = c.cst_key							-- << has IND status 
where ixo_ext.ixo_status_ext = 'Active'	and	ie.ind_status_ext = 'Active'				-- << SHOULD BE PRIMARY AND ACTIVE ... 
and ( c.cst_org_name_dn <> o.org_name OR c.cst_org_name_dn IS NULL )					-- << and not yet matched ... 
------ END 




-- UPDATED / FASTER select 

select count(*) -- select top 1000 c.cst_recno, cst_delete_flag, c.cst_org_name_dn, o.org_name , c.* 
from co_customer c 
 join co_individual_x_organization ixo on ixo.ixo_key = c.cst_ixo_key 
 join co_individual_x_organization_ext ixo_ext on ixo.ixo_key = ixo_ext.ixo_key_ext
 join co_organization o on o.org_cst_key = ixo.ixo_org_cst_key
where ixo_ext.ixo_status_ext = 'Active' 
and (c.cst_org_name_dn <> o.org_name OR c.cst_org_name_dn IS NULL) 


select count(*) -- select top 1000 c.cst_recno, cst_delete_flag, c.cst_org_name_dn, o.org_name , c.* 
from co_customer c 
 join co_individual_x_organization ixo on ixo.ixo_key = c.cst_ixo_key 
 join co_individual_x_organization_ext ixo_ext on ixo.ixo_key = ixo_ext.ixo_key_ext
 join co_organization o on o.org_cst_key = ixo.ixo_org_cst_key
where ixo_ext.ixo_status_ext = 'Active' 
and c.cst_org_name_dn <> o.org_name

select count(*) -- select top 1000 c.cst_recno, cst_delete_flag, c.cst_org_name_dn, o.org_name , c.* 
from co_customer c 
 join co_individual_x_organization ixo on ixo.ixo_key = c.cst_ixo_key 
 join co_individual_x_organization_ext ixo_ext on ixo.ixo_key = ixo_ext.ixo_key_ext
 join co_organization o on o.org_cst_key = ixo.ixo_org_cst_key
where ixo_ext.ixo_status_ext = 'Active' 
and c.cst_org_name_dn IS NULL


--- 
-- old select 

select count(*) -- top 1000 c.cst_recno, cst_delete_flag, c.cst_org_name_dn, o.org_name , c.* 
from co_individual_ext ie
 join co_customer c on c.cst_key = ie.ind_cst_key_ext
 join co_individual_x_organization ixo on ixo.ixo_key = c.cst_ixo_key 
 join co_organization o on o.org_cst_key = ixo.ixo_org_cst_key
where ie.ind_status_ext = 'Active' 
and (c.cst_org_name_dn <> o.org_name OR c.cst_org_name_dn IS NULL) 


--------------------------------------------
-- MAIN LINE --
--------------------------------------------

-- begin transaction 

update co_customer 
set cst_org_name_dn = o.org_name

from co_customer c 
 join co_individual_x_organization ixo on ixo.ixo_key = c.cst_ixo_key 
 join co_individual_x_organization_ext ixo_ext on ixo.ixo_key = ixo_ext.ixo_key_ext
 join co_organization o on o.org_cst_key = ixo.ixo_org_cst_key
where ixo_ext.ixo_status_ext = 'Active' 
and ( c.cst_org_name_dn <> o.org_name OR c.cst_org_name_dn IS NULL ) 



-- for ALL Active individuals 

-- if org name of primary role is not cst_org_name_ndn - then update it 

-- all = 69 000 -- after start date 
-- all = 70,000       -- just active 
-- mismatch    -- 13,867   <> 
-- NOT NULL 

select count(*) -- select top 1000 c.cst_recno, cst_delete_flag, c.cst_org_name_dn, o.org_name , c.* 
from co_customer c 
 join co_individual_x_organization ixo on ixo.ixo_key = c.cst_ixo_key 
 join co_individual_x_organization_ext ixo_ext on ixo.ixo_key = ixo_ext.ixo_key_ext
 join co_organization o on o.org_cst_key = ixo.ixo_org_cst_key
where ixo_ext.ixo_status_ext = 'Active' 
and c.cst_org_name_dn <> o.org_name

select count(*) -- select top 1000 c.cst_recno, cst_delete_flag, c.cst_org_name_dn, o.org_name , c.* 
from co_customer c 
 join co_individual_x_organization ixo on ixo.ixo_key = c.cst_ixo_key 
 join co_individual_x_organization_ext ixo_ext on ixo.ixo_key = ixo_ext.ixo_key_ext
 join co_organization o on o.org_cst_key = ixo.ixo_org_cst_key
where ixo_ext.ixo_status_ext = 'Active' 
and c.cst_org_name_dn IS NULL

-- commit 
