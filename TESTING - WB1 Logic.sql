-- NOTES 

/* 
Days in Role double counts when roles overlap. 
-- in one case a role 
*/

declare @status varchar(100) = 'Active' 
declare @count int = 1000

-- Test randomly 50 (non primary) + 100 (primary ixo) IXO 
;with IXOs as
(
	select top (@count) ixo_key, ixo_rlt_code, ixo_status_ext  from vw_client_scouts_member_roles
	left join co_customer CUST on CUST.cst_ixo_key = ixo_key
	where mbt_code = 'Volunteer' and (ixo_status_ext = @status )
	and CUST.cst_key is NOT null -- PRIMARY 

)

select * into #tmpIXOs from IXOs

--select ixo_key	, dbo.client_scouts_wb1_validate(ixo_key) as [Result] from #tmpIXOs
;

with r as ( 
select ixo_key
, dbo.client_scouts_requires_WBI(ixo_key) as [WBI] 
, WB1.* 
from #tmpIXOs
cross apply dbo.client_scouts_wb1_report(ixo_key) WB1
)
 
select * from r 
order by WBI, reason 

/*
select ixo_key, dbo.client_scouts_requires_WBI(ixo_key) as [WBI] 
--select ixo_key, dbo.client_scouts_requires_PRC(ixo_key) as [WBI] 
from #tmpIXOs
*/

drop table #tmpIXOs

RETURN 

set statistics io on 
set statistics time on 
---------------------------------------------------------------------------
---- ADDITIONAL TESTS FOR SPECIFIC ROLES LISTED with unexpected results ... 
---------------------------------------------------------------------------

select rs.ixo_status_ext,  rs.ixo_rlt_code , rs.org_name, rs.ixo_start_date, rs.ixo_key as real_ixo_key, c.cst_ixo_key as 'PRIMARY IXO KEY' , rs.mbt_code, rs.org_ogt_code,  main.* 
from co_individual_x_organization main 
	join vw_client_scouts_member_roles rs on rs.ixo_ind_cst_key = main.ixo_ind_cst_key 
	join co_customer C on c.cst_key = rs.cst_key 
where main.ixo_key = '072FC12C-D77F-41CC-9683-00040DCAA2C4' -- '84198CBC-4037-479A-AC72-00046C55FD2A' -- 'A8637DEB-CF81-4E2D-B17F-001388255103' 
	and rs.ixo_rlt_code = main.ixo_rlt_code



--set statistics io on 
--set statistics time on 
select top 500 dbo.client_scouts_requires_WBI(ixo_key), *
from vw_client_scouts_member_roles 
where ixo_status_ext = 'Active' 

/* 

	PRC PRC PRC PRC 

(500 row(s) affected)
Table 'co_customer'. Scan count 0, logical reads 4080, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_organization'. Scan count 0, logical reads 1540, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_organization_ext'. Scan count 0, logical reads 1540, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_individual_x_organization'. Scan count 1, logical reads 458, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_individual_x_organization_ext'. Scan count 1, logical reads 166, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'mb_member_type'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'client_scouts_organization_sub_type'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:    CPU time = 780 ms,  elapsed time = 1190 ms.
 SQL Server Execution Times:    CPU time = 187 ms,  elapsed time =  420 ms.
 
 
	WBI WBI WBI 

(500 row(s) affected)
Table 'co_customer'. Scan count 0, logical reads 4080, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_organization'. Scan count 0, logical reads 1540, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_organization_ext'. Scan count 0, logical reads 1540, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_individual_x_organization'. Scan count 1, logical reads 458, physical reads 0, read-ahead reads 598, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_individual_x_organization_ext'. Scan count 1, logical reads 166, physical reads 0, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'mb_member_type'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'client_scouts_organization_sub_type'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:   CPU time = 796 ms,  elapsed time = 25087 ms.
 SQL Server Execution Times:   CPU time = 702 ms,  elapsed time = 1185 ms.

 select * from client_scouts_course_catalogue  where z01_course_code = 'TMS1/CP'

SCF = WB1mod1/AS *Scouting Fundamentals	Wood Badge I – Scouting Fundamentals (previously:WBI Module 1 All Sections) 
WBI = TMS1/CP	 Wood Badge I for The Canadian Path

 */


select dbo.client_scouts_new_to_section_type('9CDDAD5D-161F-4401-88E1-020FEBDE7E7A') , dbo.client_scouts_ixo_training_validate('9CDDAD5D-161F-4401-88E1-020FEBDE7E7A') 

