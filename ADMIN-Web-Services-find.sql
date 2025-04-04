
declare @s varchar(100) = 'recognitionrecord' 
-- by stored proc 
select wxm_web_method, node.wxn_sql, * 
from ws_web_service_method wm 
join ws_web_service_method_node node on  node.wxn_wxm_key = wm.wxm_key
where node.wxn_sql like '%' + @s + '%'

-- by name 
select wxm_web_method, node.wxn_sql, * 
from ws_web_service_method wm 
join ws_web_service_method_node node on  node.wxn_wxm_key = wm.wxm_key
where wm.wxm_web_method like '%' + @s + '%'


/* 

-- find all 
select * 
from ws_web_service_method wm 
join ws_web_service_method_node node on  node.wxn_wxm_key = wm.wxm_key
order by wm.wxm_add_date desc 

*/
