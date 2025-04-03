
declare @Name varchar(100) = '%PerformanceCalculationData%'

select top 100 * from ElectrumWarehouse.fact.TestResultHistory where testcase like @Name and source = 'qwinvci01' order by 1 desc

select top 100 * from ElectrumWarehouse.fact.TestResultHistory where testcase like @Name and source = 'qwinvut01' order by 1 desc

