select * from pr.electrumpersistent.hangfire.state a
join pr.electrumpersistent.hangfire.jobparameter b on a.jobid = b.jobid
where b.value like '%email%'
and a.name = 'Failed'
order by createdat desc

select * from pr.electrumpersistent.hangfire.state a
join pr.electrumpersistent.hangfire.jobparameter b on a.jobid = b.jobid
where b.value like '%email%'
order by createdat desc 

