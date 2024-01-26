select top 20 count(*), cast(logged as date) d, Level
from PR.ElectrumPersistent.LOG.MessageLog
where message not like 'Failed to load prices%' and level = 'Error'
group by cast(logged as date), level
order by 2 desc, 3 desc

select count(*), cast(logged as date) d, Level
from PR.ElectrumPersistent.LOG.MessageLog
where message not like 'Failed to load prices%'
group by cast(logged as date), level
order by 2 desc, 3 desc

select * from PR.ElectrumPersistent.LOG.MessageLog 
where level = 'error' and logged > '2023-01-28'
AND message not like 'Failed to load prices%' order by logged desc 
