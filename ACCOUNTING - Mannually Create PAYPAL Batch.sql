-- Was asked to create batch PP01261801 

-- needed by accounting to complete refunds 

-- check the status and details - see below 

select top 400 * from ac_batch where bat_code like 'PP%'
order by bat_add_date desc  

-- then create if batch does not exist -- 01 will be appeneded 

/* 

declare  @bat_key uniqueidentifier 
set @bat_key = newid() 
exec client_scouts_create_online_batch 
  @bat_key = @bat_key
, @bat_code = 'PP012618'
, @org_cst_key = 'F15FF832-A40D-404A-87E2-F3BDB704822A'

*/
