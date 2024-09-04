---- 
-- Web Methods 
----

-- EXEC into TEXT output !!!!!!!!!!!!!!!!!!!


-- select * from ws_web_service_method order by wxm_add_date desc 

/*
As of Sep 6, 2018 can possibly ignore the following:
ScoutsGetOrgMembersXAddress
ScoutsRequestReportData
ScoutsGetFees
MyFamilyExt
ScoutsGetGroupMembersLatLng

*/

; 
with prod as ( 
	SELECT *
	FROM [scoutssql02.tpca.ld].nfscouts.dbo.ws_web_service_method m
)  
, 
stage as ( 
	SELECT * 
	FROM ws_web_service_method
) 

select /* stage.wxm_add_date	, stage.wxm_web_method	, stage.wxm_allow_anonymous_access_flag anon	, stage.wxm_notes
	, stage.wxm_delete_flag del	, stage.wxm_add_date 	, stage.wxm_change_date
	, prod.wxm_add_date 	, prod.wxm_change_date 
	, n.wxn_add_date as dev_Add_Date
	*/ 
	stage.wxm_web_method
	, stage.wxm_add_date as dev_add_date
	, prod.wxm_add_date as Prod_add_date
	, stage.wxm_change_date as dev_change_Date
	, isnull(prod.wxm_change_date,prod.wxm_add_date) as Prod_change_date
	, '---------' + char(11) + char(13) 
	, n.wxn_sql as DEV_SQL 
	, '---------' + char(11) + char(13) 
	, n2.wxn_sql as PROD_SQL 
	, char(11) + char(13) 
	, '--------------------------------------------------------------------------------------------', char(11) + char(13) 
from stage
	join ws_web_service_method_node n on n.wxn_wxm_key = wxm_key  
	LEFT OUTER JOIN prod on stage.wxm_web_method = prod.wxm_web_method 
	LEFT OUTER JOIN [scoutssql02.tpca.ld].nfscouts.dbo.ws_web_service_method_node n2 on n2.wxn_wxm_key = prod.wxm_key  
where 

(stage.wxm_add_date > isnull(prod.wxm_add_date, '1900-01-01') 
OR stage.wxm_change_date > isnull(prod.wxm_change_date, prod.wxm_add_date)
)
AND 
n.wxn_sql != isnull(n2.wxn_sql,'')
order by n2.wxn_change_date DESC 




