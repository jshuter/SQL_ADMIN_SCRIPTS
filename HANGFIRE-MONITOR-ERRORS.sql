select Count(*) from ci.electrumpersistent.hangfire.Job
where StateName='Failed' and CreatedAt > dateadd(M, -6, getdate()) 
select Count(*) from ut.electrumpersistent.hangfire.Job
where StateName='Failed' and CreatedAt > dateadd(M, -6, getdate()) 
select Count(*) from pr.electrumpersistent.hangfire.Job
where StateName='Failed' and CreatedAt > dateadd(M, -6, getdate()) 

select * from ci.electrumpersistent.hangfire.Job
where StateName='Failed' and CreatedAt > dateadd(D, -10, getdate()) 
order by id desc 

select * from ut.electrumpersistent.hangfire.Job
where StateName='Failed' and CreatedAt > dateadd(D, -10, getdate()) 
order by id desc 

select * from pr.electrumpersistent.hangfire.Job
where StateName='Failed' and CreatedAt > dateadd(D, -10, getdate()) 
order by id desc 
