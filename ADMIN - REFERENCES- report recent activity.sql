select * from co_customer 
join client_scouts_volunteer_screening_reference on cst_key = z22_ind_cst_key
where cst_recno = 787411


select count(*),cast(z22_add_date as date) as dt --, z22_status 
,sum(case when z22_status='Resubmit' then 1 else 0 end) as st_resubmit
,sum(case when z22_status='New' then 1 else 0 end) as st_new
,sum(case when z22_status='In Progress' then 1 else 0 end) as st_in_progress
,sum(case when z22_status='Missing Info' then 1 else 0 end) as st_missing_info
,sum(case when z22_status='NOT REQUIRED' then 1 else 0 end) as st_not_required
,sum(case when z22_status IS NULL then 1 else 0 end) as st_null
,sum(case when z22_status='UNABLE TO COMPLETE' then 1 else 0 end) as st_unable_to_complete
,sum(case when z22_status='Fail' then 1 else 0 end) as st_fail
,sum(case when z22_status='Pass' then 1 else 0 end) as st_pass

from client_scouts_volunteer_screening_reference 
where z22_add_date > '2017-08-01' -- 9-01' and '2017-09-02'
group by cast(z22_add_date as date) -- ,  z22_status
order by dt 
