select * 
from Smtr_Staging.dbo.Migrations
order by ExecutedBy, ExecutedDate

-- since JULY 2021
select count(*), ExecutedBy
from Smtr_Staging.dbo.Migrations
where ExecutedDate > '2021-07-31'
group by ExecutedBy