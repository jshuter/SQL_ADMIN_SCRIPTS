set nocount on 

declare @cst_key as uniqueidentifier 
DECLARE @age as integer 
declare @last_cst_key as uniqueidentifier = NULL 

declare @ixo_key as uniqueidentifier 
declare @role as varchar(100) 
declare @status as varchar(30) 

-- create cursor for loop 
declare test_cases cursor for 

/* MAIN SELECTION HERE */

select top 40 I.ind_cst_key , I.ind_age_cp, X.ixo_rlt_code, X.ixo_key, ixo_status_ext , i.ind_dob 
	from co_individual_x_organization X
		join co_individual I on i.ind_cst_key = X.ixo_ind_cst_key 
		join co_individual_x_organization_ext on x.ixo_key = ixo_key_ext  
		
	where ixo_end_date > '2016-09-01'
		and i.ind_dob > '2000-01-01' 	and X.ixo_rlt_code like '%Youth%' -- Youth Volunteers 
		-- and ind_dob < '2000-01-01' and X.ixo_rlt_code like '%leader'   -- adult volunteers 
		-- and ind_dob < '2000-01-01' and X.ixo_rlt_code = 'Beaver Scout'   -- adult volunteers 
	order by ind_dob    , ind_cst_key 

/* try parents and those without a role */ 
/* 

-- includes a variety of edge cases where DATES are null in Age, and in ixo_end_date 
select top 40 I.ind_cst_key , I.ind_age_cp, X.ixo_rlt_code, X.ixo_key, ixo_status_ext , i.ind_dob 
	from co_individual_x_organization X
		left outer join co_individual I on i.ind_cst_key = X.ixo_ind_cst_key 
		left outer join co_individual_x_organization_ext on x.ixo_key = ixo_key_ext  
	where ixo_end_date is null 
*/ 

-- init

declare @dob as datetime 
declare @count as int = 0 
OPEN test_cases  
FETCH NEXT FROM test_cases into @cst_key , @age , @role , @ixo_key, @status , @dob 

while @@FETCH_STATUS = 0 
begin 
	set @count = @count + 1 
	-- test 
	if @last_cst_key <> @cst_key or @last_cst_key is null BEGIN 
		select '================================================================================================================================='
		select @cst_key as CST_KEY, @age as AGE, @dob as DOB 
		exec client_scouts_check_code_of_conduct_xweb_new  @ind_cst_key = @cst_key , @debug = 1
	END 

	select dbo.client_scouts_get_requires_string(@ixo_key) 
	select @count as [count], @role as 'ROLE' , @ixo_key as IXO_KEY , @status as [STATUS] 
	exec client_scouts_rpt_compliance_current_year_active_members  1, @cst_key , NULL	

	-- save prior key before getting next row
	set @last_cst_key = @cst_key
	
	FETCH NEXT FROM test_cases into @cst_key , @age , @role , @ixo_key , @status , @dob 

end 

CLOSE test_cases;  
DEALLOCATE test_cases;  



-- select * from client_scouts_code_of_conduct

/* 

select client_scouts_code_of_conduct.z23_version from client_scouts_code_of_conduct_x_co_individual 
join client_scouts_code_of_conduct on z23_key = z24_z23_key
where z24_ind_cst_key = '8E5D8433-C3B1-4332-BCF1-65A57EC3D0D3'

*/
