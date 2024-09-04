/* 

CREATE ENTRY FOR NEW RELATIONSHIP_TYPE : "Global Use" 

which includes all Methods or Forms that should be accessibale to ALL users 

*/

select * from co_relationship_type order by rlt_code 
			
		
/* 
insert co_relationship_type (rlt_key,rlt_code,rlt_type,rlt_category,rlt_delete_flag) 
values('302A0F6B-D970-4951-BF7B-B7848EA1654A', 'Global Use', 'Ind_Org','Individual',0); 
*/

/* 
begin transaction 
delete from co_relationship_type 
where rlt_key = '302A0F6B-D970-4951-BF7B-B7848EA1654A'
--commit 
*/
