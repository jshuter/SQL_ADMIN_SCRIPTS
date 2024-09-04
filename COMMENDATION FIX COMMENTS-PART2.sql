------------------------------------------------------------
-- PART 2 -- split out the SUBMITTED BY Data into new field 
------------------------------------------------------------

--======================================================
-- PREVIEW CHANGE/OVERVIEW
-- MUST INCLUDE DELIM IN THE WHERE/FILTER so that we are not just copying COMMENT into the SUBMITTED BY Column 
--======================================================

declare @rdelim varchar(20) = '}Submitted:'
declare @from as date = '1900-01-01' 
declare @to as date = '2020-01-01'

-- count dupes 
-- 4 found - they must be fixed 

select count(*) 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_comments like '%'+ @rdelim + '%'+ @rdelim + '%'
and z05_submitted_by is null 
and z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
and z05_delete_flag = 0 
and CMDTN.z05_add_date between @from and @to 

-- count all 

select count(*) 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_comments like '%'+ @rdelim + '%' 
and z05_submitted_by is null 
and z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
and z05_delete_flag = 0 
and CMDTN.z05_add_date between @from and @to 

-- find long lines in output to new fields -- NONE in dev 
-- and len(ltrim(dbo.str_right_of(z05_comments, @rdelim, 2))) > 140  



-- show some of the ADJUSTMENTS data 
select top 100  z05_submitted_for 
	, z05_comments as z05_comments_OLD 
	, z05_comments_NEW = ltrim(dbo.str_left_of(z05_comments,@rdelim)) 
	, z05_submitted_by = ltrim(dbo.str_right_of(z05_comments, @rdelim, 2))
	, z05_change_user = 'sys admin'
	, z05_change_date = getdate() 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_comments like '%'+ @rdelim + '%' 
and z05_submitted_by is null 
and z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
and z05_delete_flag = 0 
and CMDTN.z05_add_date between @from and @to 


--======================================================
-- DO UPDATE -- move suffix into SUBMITTED BY 
--======================================================

BEGIN TRANSACTION 

UPDATE CMDTN 

SET   z05_submitted_by = ltrim(dbo.str_right_of(z05_comments, @rdelim, 2))
	, z05_comments     = ltrim(dbo.str_left_of(z05_comments,@rdelim)) 
	, z05_change_user  = 'sys admin 2' 
	, z05_change_date  = getdate() 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_comments like '%'+ @rdelim + '%' 
and z05_submitted_by is null 
and z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
and z05_delete_flag = 0 
and CMDTN.z05_add_date between @from and @to 

-- commit 

-- rollback

--======================================================
-- POST FIX REVIEW 
--======================================================

select count(*) 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_change_user = 'sys admin 2' 


select top 1000 z05_submitted_for 
	 , z05_comments 
	 , z05_submitted_by 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_change_user = 'sys admin 2' 


