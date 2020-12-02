WITH a AS ( 
	SELECT 
		MAX(pr.ACCOUNT_INT) AS ACCOUNT_INT 
		,am.Name_CHR 
		+ ' (' + am.TYPE_CHR + ' / ' + cast(min(pr.as_of_date) as varchar) 
		+ ' ... ' + cast(max(pr.as_of_date) as varchar) + ')' as Name_CHR
		,min(pr.as_of_date) as Start_Date
		,max(pr.as_of_date) as End_Date
		,am.TYPE_CHR as TYPE_CHR
	FROM 
		op.performance_return PR 
		left outer join op.Account_Master AM 
			on pr.ACCOUNT_INT = am.NUMBER_INT
	group by
		pr.account_int, am.Name_CHR, am.TYPE_CHR
) 

SELECT a.* 
	,  fm.CURRENCY_CD_CHR fm_curr 
	,mm.CURRENCY_CD_CHR
FROM a 
	LEFT JOIN OP.Fund_Master fm ON a.ACCOUNT_INT = fm.ACCOUNT_INT 
	LEFT JOIN OP.Manager_Master mm ON mm.NUMBER_INT = fm.MANAGER_INT
	ORDER BY TYPE_CHR, fm_curr DESC 



