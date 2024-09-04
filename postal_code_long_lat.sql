select count(*) -- top 100 co_organization.*,  ll.a20_post_code, ll.a20_longitude, ll.a20_latitude,adr_post_code, adr_longitude, adr_latitude, org_name,org_add_date, co_address.* 
from co_organization_ext
	join co_organization on org_cst_key = org_cst_key_ext 
	join co_address on adr_cst_key_owner = org_cst_key_ext
	left join client_scouts_postal_long_lat ll on  left(adr_post_code,3) + RIGHT(adr_post_code,3) = ll.a20_post_code  
	-- 28,000 items 
where 
--- to look for MISSING / Fillable --- SECTIONS 

	org_ogt_code = 'Section' 
	and org_delete_flag = 0 
	and org_status_ext = 'Active' 
	
	--  6806  // all sections that are active 
	--  5646  // OF ALL have LL set up 
	--  1200  have problems ... 
	
	and adr_longitude is NOT NULL -- 1160 // 437 HAve LAT - even though there is no PC 
	and adr_post_code IS NULL -- 532 - missing log/lat but has PC -- 628 - NO PC and NO LAT 
	and ll.a20_longitude IS NOT NULL  -- 519 - FIXABLE 
	
--- to REVIEW -- 

	adr_longitude is not null 
--	and adr_post_code is not NULL 	-- 79 with PC / 789 w & wo PC
	and ll.a20_post_code is null 
	 
	
	-- NOTE -- found strange fact that 
	-- select top 100 * from client_scouts_postal_long_lat as ll where ll.a20_post_code like 'K2J5X9'
	-- finds nothing - even though F-A-G works for K2J5X9
	
	-- exec client_scouts_group_locator 'K2J5X9', 'beaver colony'  <<< WILL look into adr if missing from other table !
	
/* 

begin transaction 

update co_address 
set adr_latitude = '49.2365025705418' 
,  adr_longitude = '-124.801852576605'
where adr_key in( '131B8723-AAC9-4262-BD58-0076A512994B',
'C363D732-9200-462A-B898-C74AC1317D82',
'E59276A9-00C0-4E1A-85ED-062236187023') 

--commit

*/ 


select top 100 * from client_scouts_postal_long_lat as ll
where ll.a20_post_code = 'K2J5X9'