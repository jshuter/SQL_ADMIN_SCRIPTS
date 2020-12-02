select top 100 * from client_scouts_recognition_list_x_co_customer join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1060'

select count(*) from client_scouts_recognition_list_x_co_customer join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1019' and z05_comments like '%performed:%' 
select count(*) from client_scouts_recognition_list_x_co_customer join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1019' and z05_comments like '%performed:{%' 
select count(*) from client_scouts_recognition_list_x_co_customer join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1019' and z05_comments like '%, performed:{%' 

select count(*) from client_scouts_recognition_list_x_co_customer join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1019' and z05_comments like '%submitted:%' 
select count(*) from client_scouts_recognition_list_x_co_customer join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1019' and z05_comments like '%}Submitted:%' 


--43,598 
and z05_recognition_date < '2017-09-29'
-- 38860 

/*  Peggy from ... 2014, performed:{ I wou...by. }Submitted: Duane Sovyn "Mischief"(Fellow W II Trainer),403-229-4235  */

-- step 1 -- Update -- MOVE LEFT SIDE 

declare @t varchar(8000) = 'Peggy Wierenga from 144th Lake Bonavista Community A Group-Chinook 5 Area-Chinook on 08/08/2014, performed:{ I would like to thank you Peggy for all of your hard work and assistance in helping me deliver the WB II program this year at the Camp Woods family camp.  Thank you for your positive attitude and willingness to have fun.  You made the week fly by. }Submitted: Duane Sovyn "Mischief"(Fellow W II Trainer),403-229-4235'
select ltrim( dbo.str_left_of(@t,'%performed:{%' ))

declare @patternLeft varchar(100) = ', performed:{' 
select top 10 
  ltrim( dbo.str_left_of(z05_comments,@patternLeft ) ) as submitted_for 
, ltrim( dbo.str_right_of(z05_comments,@patternLeft ) ) as comments 
, z05_comments 
from client_scouts_recognition_list_x_co_customer
join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1019'
and z05_comments like '%'+@patternLeft+'%' 



-- step 2 -- Update -- MOVE LEFT SIDE 
declare @patternRight varchar(100) = '}Submitted:' 
select top 10
   ltrim(dbo.str_left_of(z05_comments,@patternRight)) as comments  
 , ltrim(dbo.str_right_of(z05_comments,@patternRight)) as submitted_by  
 , z05_comments 
from client_scouts_recognition_list_x_co_customer
join client_scouts_recognition_list on z04_key = z05_z04_key where z04_recognition_code= '1019'
and z05_comments like '%'+@patternRight+'%'

/*
Peggy Wierenga from 144th Lake Bonavista Community A Group-Chinook 5 Area-Chinook on 08/08/2014, performed:{ I would like to thank you Peggy for all of your hard work and assistance in helping me deliver the WB II program this year at the Camp Woods family camp.  Thank you for your positive attitude and willingness to have fun.  You made the week fly by. 	
Duane Sovyn "Mischief"(Fellow W II Trainer),403-229-4235	
Peggy Wierenga from 144th Lake Bonavista Community A Group-Chinook 5 Area-Chinook on 08/08/2014, performed:{ I would like to thank you Peggy for all of your hard work and assistance in helping me deliver the WB II program this year at the Camp Woods family camp.  Thank you for your positive attitude and willingness to have fun.  You made the week fly by. }Submitted: Duane Sovyn "Mischief"(Fellow W II Trainer),403-229-4235
*/ 


