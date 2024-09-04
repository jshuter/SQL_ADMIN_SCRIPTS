------------------------------------------------------
-- PART 1 - parse LEF side into SUBMITTED_FOR 
------------------------------------------------------

declare @ldelim varchar(20) = 'performed:{'
declare @from as date = '1900-01-01' 
declare @to as date = '2020-01-01'

-- BEFORE

-- Check for dupes 

--- TO AVOID ISSUES - WE MUST USE OPTION 1 on RIGH_OF Function 
--- AND - as extra precaution - INSURE that the DELIM only occurs ONCE - 

SELECT count(*) 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
	and CMDTN.z05_add_date between @from and @to 
	and z05_comments like '%' + @ldelim + '%' + @ldelim + '%'
	and z05_delete_flag = 0 
	and CMDTN.z05_submitted_for is NULL 

-- count all 

SELECT count(*) 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
	and CMDTN.z05_add_date between @from and @to 
	and z05_comments like '%'+@ldelim+'%'
	and z05_delete_flag = 0 
	and CMDTN.z05_submitted_for is NULL 

-- use next line to count lines that are too long 
-- and len(dbo.str_left_of(z05_comments,@ldelim)) > 150

-- show some ADJUSTMENTS data 

SELECT top 1000 z05_key
    , z05_submitted_for 
	, ltrim(dbo.str_left_of(z05_comments,@ldelim)) as z05_submitted_for_NEW  
    , ltrim(dbo.str_right_of(z05_comments,@ldelim,1)) as z05_comments_NEW 
	, z05_comments as z05_comments_OLD
	, z05_submitted_by
	, z05_add_date
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
	and CMDTN.z05_add_date between @from and @to 
	and z05_comments like '%' + @ldelim + '%'
	and z05_delete_flag = 0 
	and CMDTN.z05_submitted_for is NULL 
order by z05_add_date desc

begin transaction 

-- STEP 1 -- Move Prefix into SUBMITTED_FOR 

UPDATE CMDTN 
SET z05_submitted_for = ltrim(dbo.str_left_of(z05_comments,@ldelim))
	, z05_comments =  ltrim(dbo.str_right_of(z05_comments,@ldelim,1)) 
	, z05_change_user = 'sys admin 1' 
	, z05_change_date = getdate() 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_z04_key = '6D3A2700-1571-4593-835C-87AE51BA6097' 
	and CMDTN.z05_add_date between @from and @to 
	and z05_comments like '%' + @ldelim + '%'
	and z05_delete_flag = 0 
	and CMDTN.z05_submitted_for is NULL 

-- commit 
-- rollback 

select count(*) 
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_change_user = 'sys admin 1'

select top 1000 z05_submitted_for, z05_comments, z05_submitted_by, z05_change_date
from client_scouts_recognition_list_x_co_customer as CMDTN
where z05_change_user = 'sys admin 1'
