declare @x as varchar(100) = '67A47EBC-918B-4CA6-A1FA-91E033FCADEE' 

select * from co_customer where cst_key = @x 

select * from  client_scouts_participant_roles_summary(@x) 

SELECT case when sum(role_count_this_year) > 1 then (
		-----
		SELECT case when sum(isnull(role_count_this_year,0)) > 0 
			then 0 -- 0 -- dont show if 1 or more active roles found for group 
			else 1 -- 1 
			end -- NULL becomes 1 
		FROM client_scouts_participant_roles_summary(@x) 
		WHERE ixo_status_ext in ('Active')
		-----
		) 
	else 0 -- NULL becomes 0
	end 
FROM client_scouts_participant_roles_summary(@x) 
WHERE ixo_status_ext in ('Not Renewed')



		SELECT  sum(isnull(role_count_this_year,0))
		FROM client_scouts_participant_roles_summary(@x) 
		WHERE ixo_status_ext in ('Active')
