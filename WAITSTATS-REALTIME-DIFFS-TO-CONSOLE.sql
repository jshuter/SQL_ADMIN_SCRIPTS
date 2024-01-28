--init 

drop table if exists #tmp1
drop table if exists #tmp2

select * 
into #tmp1
from sys.dm_os_wait_stats 
order by waiting_tasks_count desc 


-- loop report 

while 1 = 1 
begin 

	waitfor delay '00:00:01'
	drop table #tmp2
	select * 
	into #tmp2
	from sys.dm_os_wait_stats 
	-- where (waiting_tasks_count <> 0 or wait_time_ms <> 0 or max_wait_time_ms <> 0 or  signal_wait_time_ms <> 0 ) 
	

	select t1.* , 
	t2.waiting_tasks_count - t1.waiting_tasks_count d1,
	t2.wait_time_ms-t1.wait_time_ms d2,
	t2.max_wait_time_ms-t1.max_wait_time_ms d3,
	t2.signal_wait_time_ms-t1.signal_wait_time_ms d4
	from #tmp1 t1 
	join #tmp2 t2 on t2.wait_type = t1.wait_type
	where (t2.waiting_tasks_count <> 0 or t2.wait_time_ms <> 0 or t2.max_wait_time_ms <> 0 or  t2.signal_wait_time_ms <> 0 ) 
	order by 1 

	delete #tmp1

	insert into #tmp1 select * from #tmp2

end

