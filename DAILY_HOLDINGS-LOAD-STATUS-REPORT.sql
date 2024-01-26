	USE SMTR 

	declare @days int = 30 

	;
	with data as (
		-- summarize holding_master data for review 
		select TOP 1000 AS_OF_DATE, Min(tools.utctolocal(ValidFromUtc)) mn, Max(tools.utctolocal(ValidFromUtc)) mx,count(*) c  
		from op.Holding_Master 
		where AS_OF_DATE BETWEEN dateadd(d, @days * -1, getdate()) AND dateadd(d, -1, getdate())
		group by AS_OF_DATE, cast(ValidFromUtc as date)
		order by AS_OF_DATE desc, cast(ValidFromUtc as date) DESC
	) 
	SELECT 
		d.FULL_DATE, D.Week_Day_Name_CHR, data.*,  HT.*
	FROM 
		TOOLS.Date_Master D LEFT JOIN data ON AS_OF_DATE = D.FULL_DATE
		LEFT JOIN TOOLS.Holiday_Master H ON D.FULL_DATE = H.FULL_DATE
		LEFT JOIN TOOLS.X_Holiday_Type HT ON H.HOLIDATY_TYPE_INT = HT.HOLIDATY_TYPE_INT
	WHERE 
		D.FULL_DATE BETWEEN dateadd(d, @days * -1,getdate()) and dateadd(d, -1, getdate())