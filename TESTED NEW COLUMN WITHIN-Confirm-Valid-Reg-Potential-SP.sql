-- trainning council - set dues prc to null -- and then back to BAA...

-- for self-reg 
exec client_scouts_confirm_valid_registration_potential_xweb '725A3F0F-92E3-4B30-AF8B-4FCD308DBC95' ,'3699A6B5-E476-478A-B4F1-3569F5872D15','9999'	,0
,@xml=0 
--for registrar
exec client_scouts_confirm_valid_registration_potential_xweb '725A3F0F-92E3-4B30-AF8B-4FCD308DBC95' ,'3699A6B5-E476-478A-B4F1-3569F5872D15'	,'9999'  	,1
,@xml=0 




select * from co_organization where org_name like '1st_exp%'

select * from co_organization_ext where org_cst_key_ext in (select org_cst_key  from co_organization where org_name like '1st_exp%') 


-- E87125F1-78AE-4C44-B4A3-39A406516C64 -- group 
-- DUES KEY -- BAAD0E77-23C7-4957-8EF9-D39AB3724C0E

update co_organization_ext
set org_dues_prc_key_ext = 'BAAD0E77-23C7-4957-8EF9-D39AB3724C0E'
where org_cst_key_ext = 'E87125F1-78AE-4C44-B4A3-39A406516C64'
