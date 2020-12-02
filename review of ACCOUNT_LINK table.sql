with a as ( 
	select distinct ACCOUNT_INT from  op.Holding_Master 
) 
select * from a 
left join op.Account_Link on a.ACCOUNT_INT = CHILD_ACCOUNT_INT 
join op.Account_Master am on a.ACCOUNT_INT = am.NUMBER_INT
order by PARENT_ACCOUNT_INT

select * from op.Account_Link l 
join op.Account_Master m on m.NUMBER_INT = l.PARENT_ACCOUNT_INT

-- mostly 1 to 1 -- with a few 2 and 3 children  
select count(*), parent_account_int 
from op.Account_Link 
group by PARENT_ACCOUNT_INT


-- JOIN op.Fund_Master f on f.ACCOUNT_INT = a.ACCOUNT_INT

select * from op.Account_Link


select * from op.Account_Link l 
join op.Account_Master m 
	on m.NUMBER_INT = l.PARENT_ACCOUNT_INT

	
select l.*, m.Name_CHR, c.Name_CHR from op.Account_Link l 
join op.Account_Master m on m.NUMBER_INT = l.PARENT_ACCOUNT_INT
join op.Account_Master c on c.NUMBER_INT = l.PARENT_ACCOUNT_INT
where l.PARENT_ACCOUNT_INT = 557 

select * from op.Account_Master where NUMBER_INT in (556,557) 
select * from op.Fund_Master where ACCOUNT_INT in  (556, 557) 

; with holdings as ( 
	select count(*) counts, ISIN_CHR, ACCOUNT_INT 
	from op.Holding_Master 
	where ACCOUNT_INT in (556, 557) 
	group by ISIN_CHR, ACCOUNT_INT
) 
select * 
from holdings join op.Security_Master s on s.ISIN_CHR = holdings.ISIN_CHR 
order by TYPE_CHR
---
select * from op.Transaction_Master m join op.transaction_detail d on m.NUMBER_INT = d.TRANSACTION_NUMBER_INT 
where FUND_INT in (556, 557) 

--- 

select 'PARENT' as a, * from op.Account_Link l join op.Account_Master m on m.NUMBER_INT = l.PARENT_ACCOUNT_INT
UNION 
select 'CHILD', * from op.Account_Link l join op.Account_Master m on m.NUMBER_INT = l.CHILD_ACCOUNT_INT 
ORDER BY  PARENT_ACCOUNT_INT, CHILD_ACCOUNT_INT, a desc  


-- =========================

select * from op.Account_Link p1


; with level2 as ( 
	select p1.PARENT_ACCOUNT_INT P1, p1.CHILD_ACCOUNT_INT C1, p2.CHILD_ACCOUNT_INT C2
	from op.Account_Link p1 
	left join op.Account_Link p2 on p2.PARENT_ACCOUNT_INT = p1.CHILD_ACCOUNT_INT
	left join op.Account_Link p3 on p3.PARENT_ACCOUNT_INT = p2.CHILD_ACCOUNT_INT
	left join op.Account_Link p4 on p4.PARENT_ACCOUNT_INT = p3.CHILD_ACCOUNT_INT
	left join op.Account_Link p5 on p5.PARENT_ACCOUNT_INT = p4.CHILD_ACCOUNT_INT
) select level2.*
, m1.TYPE_CHR
, m2.TYPE_CHR
, m3.TYPE_CHR
, m1.SOURCE_CHR
, m2.SOURCE_CHR
, m3.SOURCE_CHR
, m1.SCOPE_CHR
, m2.SCOPE_CHR
, m3.SCOPE_CHR
, m1.Name_CHR
, m2.Name_CHR
, m3.Name_CHR
, case when c2 is null 
	then p1 
	else p1 + 1000
	end as ob
	 
 from level2  
	join op.Account_Master m1 on m1.NUMBER_INT = level2.P1 
	left join op.Account_Master m2 on m2.NUMBER_INT = level2.c1  
	left join op.Account_Master m3 on m3.NUMBER_INT = level2.c2 
order by ob 


-- select * from SMTR_Audit.op.Account_Link where modified >= '2018-01-01'


-- hard code vaues to be reviewed  
declare @links table(f int) 
insert into @links values (725), (726), (728) 
select * from @links 



select 'LINKS:', * from op.Account_Link where PARENT_ACCOUNT_INT in (select f from @links) or CHILD_ACCOUNT_INT  in (select f from @links) 

select 'ACCOUNTS:', * from op.Account_Master where NUMBER_INT in (select f from @links) 

select 'FUNDS:', * from op.Fund_Master where ACCOUNT_INT in  (select f from @links)  

; with holdings as ( 
	select 'HOLDINGS:' as nm, count(*) counts, sum(m.Base_Cost_DEC) cost_sum, ISIN_CHR, ACCOUNT_INT 
	from op.Holding_Master m
	where ACCOUNT_INT in (select f from @links)  
	group by ISIN_CHR, ACCOUNT_INT
) 
select * 
from holdings join op.Security_Master s on s.ISIN_CHR = holdings.ISIN_CHR 
order by TYPE_CHR

---
select 
	'TRANSACIONS:', * 
from 
	op.Transaction_Master m 
		join op.transaction_detail d 
		on m.NUMBER_INT = d.TRANSACTION_NUMBER_INT 
where FUND_INT in (select f from @links) 

