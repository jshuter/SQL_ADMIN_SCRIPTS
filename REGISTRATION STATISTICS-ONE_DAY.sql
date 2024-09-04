-- TODO 

-- limit to < 120 minutes for confirmation stats 
-- but get % less than 120 with ALL 


declare @bar varchar(500) 
set @bar = '######################################################################'

declare @start_date date = getdate() - 1

;
with alll as ( 
	select 
		DATEDIFF(MINUTE, x13_add_date,inv_add_date) as duration_MIN
	,	left( @bar, DATEDIFF(MINUTE, x13_add_date,inv_add_date))  as duration
	,	DATEDIFF(HOUR, x13_add_date,inv_add_date) as duration_HR
	,	DATEDIFF(DAY, x13_add_date,inv_add_date) as duration_DAY
	, inv_add_date
	, x13_add_date 
	, x13_source 
	, x13_progress
	, x13_add_user
from client_scouts_experimental_registration 
	left join ac_invoice on inv_key = x13_inv_key 
where 
	--x13_progress = 'Confirmation' and 
	x13_add_date between @start_date and DATEADD(DAY, 1, @start_date) and 
	x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
) 

select * from alll order by alll.duration_MIN desc 



