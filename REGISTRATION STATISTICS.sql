-- TODO 

-- limit to < 120 minutes for confirmation stats 
-- but get % less than 120 with ALL 


create PROCEDURE #tmp_stats

	@start_date date , 
	@num_days int = 0  -- 0 => 1 day 

as 

BEGIN 

if @num_days <  1 
	begin 
		select 'HOW MANY DAYS?'
		return
	end 


DECLARE @START_DATE_LY DATE

set @START_DATE_LY =  DATEADD(YEAR,-1,@start_date)

--if @num_days > 1 begin -
--	set @num_days = @num_days - 1
--end; 

--select 'date range',  @start_date, DATEADD(DAY,@num_days,@start_date);
;

with 

confirmations_ty as ( 

	select abs(DATEDIFF(MINUTE,inv_add_date, x13_add_date)) duration
		, inv_add_date
		, x13_add_date 
		, x13_source 
		, x13_progress
	from client_scouts_experimental_registration 
		join ac_invoice on inv_key = x13_inv_key 
	where x13_progress in ('Confirmation' , 'Payment Received') 
		and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
		and  abs(DATEDIFF(MINUTE,inv_add_date, x13_add_date)) < 120
		and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'

) 
, 
stats_all_ty as ( 
	select @start_date as start_date_ty 
		, avg(duration) as minutes_to_complete_ty
		, COUNT(duration) as count_all_ty
		, isnull((select avg(duration) from confirmations_ty where x13_source = 'registrar' and x13_progress = 'Confirmation' ),0) as minutes_to_complete_reg_ty
		, isnull((select count(duration) from confirmations_ty where x13_source = 'registrar' and x13_progress = 'Confirmation' ),0) as count_reg_ty
		, (select avg(duration) from confirmations_ty where x13_source = 'self' and x13_progress = 'Confirmation') as minutes_to_complete_self_ty
		, (select count(duration) from confirmations_ty where x13_source = 'self' and x13_progress = 'Confirmation') as count_self_ty
		
		, (select COUNT(*) from client_scouts_experimental_registration 
				where ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
						and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E') 
				as 'ALL_reg_ty'
		, (select COUNT(*) from client_scouts_experimental_registration 
				where x13_progress = 'Confirmation' 
					and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
					and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E') 
				as 'ALL_conf_ty'
		 from confirmations_ty 
) 
, 

confirmations_ly as ( 

	select abs(DATEDIFF(MINUTE,inv_add_date, x13_add_date)) duration
		, inv_add_date
		, x13_add_date 
		, x13_source 
		, x13_progress
	from client_scouts_experimental_registration 
		join ac_invoice on inv_key = x13_inv_key 
	where x13_progress = 'Confirmation' 
		and ( x13_add_date >= @START_DATE_LY AND x13_add_date < DATEADD(DAY,@num_days,@START_DATE_LY) ) 
		and  abs(DATEDIFF(MINUTE,inv_add_date, x13_add_date)) < 120
		and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'

) 
, 
stats_all_ly as ( 
	select @start_date_ly as start_date_ly
		, @start_date as start_date_ty 
		, avg(duration) as minutes_to_complete_ly
		, COUNT(duration) as count_all_ly
		, (select avg(duration) from confirmations_ly where x13_source = 'registrar' and x13_progress = 'Confirmation' ) as minutes_to_complete_reg_ly
		, (select count(duration) from confirmations_ly where x13_source = 'registrar' and x13_progress = 'Confirmation' ) as count_reg_ly
		, (select avg(duration) from confirmations_ly where x13_source = 'self' and x13_progress = 'Confirmation') as minutes_to_complete_self_ly
		, (select count(duration) from confirmations_ly where x13_source = 'self' and x13_progress = 'Confirmation') as count_self_ly
		, (select COUNT(*) from client_scouts_experimental_registration 
							where ( x13_add_date >= @START_DATE_LY AND x13_add_date < DATEADD(DAY,@num_days,@START_DATE_LY) ) 
								and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E') 
							as 'ALL_reg_ly'
		, (select COUNT(*) from client_scouts_experimental_registration 
							where x13_progress = 'Confirmation' 
								and ( x13_add_date >= @START_DATE_LY AND x13_add_date < DATEADD(DAY,@num_days,@START_DATE_LY) ) 
								and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E') 
							as 'ALL_conf_ly'
		 from confirmations_ly 
) 

select

    
     ty.start_date_ty
    ,ty.minutes_to_complete_ty
    ,ly.minutes_to_complete_ly
    ,ty.count_all_ty
    ,ly.count_all_ly
    ,isnull(ty.minutes_to_complete_reg_ty,0)
    ,isnull(ly.minutes_to_complete_reg_ly,0) 
    ,ty.count_reg_ty
    ,ly.count_reg_ly
    ,ty.minutes_to_complete_self_ty
    ,ly.minutes_to_complete_self_ly
    ,ty.count_self_ty
    ,ly.count_self_ly
    ,ty.ALL_conf_ty
    ,ly.ALL_conf_ly
    ,ty.ALL_reg_ty
    ,ly.ALL_reg_ly
	,100*ty.count_all_ty / ty.ALL_reg_ty as 'pct_conf_120_V_all_X13_TY' 
	,100*ly.count_all_ly / ly.ALL_reg_ly as 'pct_conf_120_V_all_X13_LY' 
	,100*ty.all_conf_ty / ty.ALL_reg_ty as 'pct_conf_ALL_V_all_X13_TY' 
	,100*ly.all_conf_ly / ly.ALL_reg_ly as 'pct_conf_ALL_V_all_X13_LY' 
	
	,
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'New' 
		and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) )
		and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	) as 'New_TY'
	,
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'New' 
		and ( x13_add_date >= @START_DATE_LY AND x13_add_date < DATEADD(DAY,@num_days,@START_DATE_LY) )
		and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	) as 'New_LY'
	,
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Add Parent' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	) as 'Add_Parent'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Registrant Added' 		
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Registrant_Added'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Contact Info' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E') 
	as 'Contact_Info1'
	,
	(select COUNT(*) from client_scouts_experimental_registration
		where x13_progress = 'Contact Info' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E') 
	as 'Contact_Info2'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Emergency Info' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	) as 'Emergency_Info'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Medical Info' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	) as 'Medical_Info'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Parental Involvement' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Parental_Involvement'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Photo Release' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Photo_Release'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Terms' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Terms'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Role Added' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Role_Added'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Order Details' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Order_Details'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Payment Added' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Payment_Added'
	,	
	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Payment Received' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Payment_Received'
	,	

	(select COUNT(*) from client_scouts_experimental_registration
	where x13_progress = 'Parent Added' 
			and ( x13_add_date >= @start_date AND x13_add_date < DATEADD(DAY,@num_days,@start_date) ) 
			and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
	)as 'Parent_Added'
	 
	from stats_all_ty ty join stats_all_ly ly on ty.start_date_ty = ly.start_date_ty 

	-- select COUNT(*) , x13_progress from client_scouts_experimental_registration	group by x13_progress 

END

GO 

select 
'0000-00-00' as start_date_ty
,0 as minutes_to_complete_ty
,0 as minutes_to_complete_ly
,0 count_all_ty
,0 count_all_ly
,0 minutes_to_complete_reg_ty
,0 minutes_to_complete_reg_ly
,0 count_reg_ty
,0 count_reg_ly
,0 minutes_to_complete_self_ty
,0 minutes_to_complete_self_ly
,0 count_self_ty
,0 count_self_ly
,0 ALL_conf_ty
,0 ALL_conf_ly
,0 ALL_reg_ty
,0 ALL_reg_ly
,0 pct_conf_120_V_all_X13_TY 
,0 pct_conf_120_V_all_X13_LY 
,0 pct_conf_ALL_V_all_X13_TY 
,0 pct_conf_ALL_V_all_X13_LY
,0 New_TY
,0 New_LY
,0 Add_Parent
,0 Registrant_Added
,0 Contact_Info1
,0 Contact_Info2
,0 Emergency_Info
,0 Medical_Info
,0 Parental_Involvement
,0 Photo_Release
,0 Terms
,0 Role_Added
,0 Order_Details
,0 Payment_Added
,0 Payment_Received
,0 Parent_Added

into #TEMPRESULTS002

-- test 
-- INSERT INTO  #TEMPRESULTS002 exec #tmp_stats '2017-05-01',1

select * from #TEMPRESULTS002


/* 

declare @sd date 
declare @ed date 
set @sd = '2016-09-01'
set @ED = '2016-09-06'

while @sd < @ed begin  
	INSERT INTO  #TEMPRESULTS002 
	exec #tmp_stats @sd,1
	set @sd = DATEADD(day,1,@sd) 	
end 

select * from #TEMPRESULTS002
order by start_date_ty

*/

-- 855 -- on Sept 4th (Sat) ( 39 w/o REG RECORD -- TRANSFERS )  
-- APPROX 400 Paid registratios
select  x13_add_date xad, ixo_add_date, ixo_mbt_key_ext, client_scouts_experimental_registration.* , co_individual_x_organization.* 
 from co_individual_x_organization join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
left join client_scouts_experimental_registration on x13_ixo_key = ixo_key 
where ixo_add_date between '2017-09-04' and '2017-09-05' and ixo_status_ext = 'Active' 
and ixo_mbt_key_ext = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- scout 
order by x13_add_date 

-- 510 active roles -- (Sat Sept 5th) 



