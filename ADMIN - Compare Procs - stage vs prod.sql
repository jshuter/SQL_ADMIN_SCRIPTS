/* 
SELECT DISTINCT o.name AS Object_Name,     o.type_desc
FROM sys.sql_modules m
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
WHERE m.definition Like '%[ABD]%';
*/
---- 
-- views - triggers - functions - procedures 

with prods as ( 
SELECT DISTINCT o.name AS Object_Name, o.create_date as create_on_prod, o.modify_date as mod_on_prod
  FROM [scoutssql02.tpca.ld].nfscouts.sys.sql_modules m
       INNER JOIN [scoutssql02.tpca.ld].nfscouts.sys.objects o
        ON m.object_id = o.object_id
	--where modify_date > '2017-03-01' -- NOT NEEDED - rely upon change date on STAGE 
) 
, 
stages as ( 
SELECT DISTINCT o.name AS Object_Name, o.create_date as create_on_stage, o.modify_date as mod_on_stage, o.type_desc
  FROM sys.sql_modules m
       INNER JOIN sys.objects o
        ON m.object_id = o.object_id
	where modify_date > '2017-03-01' 
) 


/** MAIN REPORT IS HERE **/

select stages.*
	, prods.mod_on_prod
	, prods.create_on_prod
	, prods.Object_Name
, DATEDIFF (D, stages.mod_on_stage,  prods.mod_on_prod) as daydif 
from stages 
	left join prods on stages.Object_Name = prods.Object_Name

-- to limit list 
 where prods.mod_on_prod < stages.mod_on_stage OR mod_on_prod is NULL 

order by daydif 

