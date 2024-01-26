select '2022', count(*), ExecutedBy  
from smtr_staging.dbo.Migrations
where ExecutedDate between '2022-01-01' and '2022-04-01'
group by ExecutedBy
order by ExecutedBy desc 

select count(*), ExecutedBy  
from smtr_staging.dbo.Migrations
where ExecutedDate between '2021-01-01' and '2021-07-31'
group by ExecutedBy
order by ExecutedBy desc 

select count(*), ExecutedBy  
from smtr_staging.dbo.Migrations
where ExecutedDate between '2021-08-01' and '2021-12-31'
group by ExecutedBy
order by ExecutedBy desc 
