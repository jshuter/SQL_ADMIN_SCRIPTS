
-- REVIEW of System Dates Calendar  ETC 

			SELECT
				MAX(DM.FULL_DATE) [F_DATE]
				, DM.Month_Number_INT
				, DM.Full_Year_CHR
				, CASE WHEN APM.STATUS_CHR = 'Closed' THEN 1 ELSE 0 END [Closed]
				--, * 

			FROM
				SMTR.TOOLS.Date_Master DM
				left outer join SMTR.CTRL.Accounting_Period_Master APM
					ON DM.Month_Number_INT = CAST(APM.MONTH_CHR AS INT)
					AND CAST(DM.Full_Year_CHR AS INT) = APM.YEAR_INT
			WHERE
				CAST(DM.Full_Year_CHR AS INT) = 2018 
				AND DM.FULL_DATE <= TOOLS.Previous_Business_Day(GetDate())
			Group By
				DM.Month_Number_INT, DM.Full_Year_CHR, APM.STATUS_CHR




SELECT * FROM SMTR.TOOLS.Date_Master DM -- 1950 UNTIL 2050  MON/DAY/YEAR/ ACCOUNTING DATA etc DAY # week # ETC !!!!

select * from  SMTR.CTRL.Accounting_Period_Master APM  WHERE YEAR_INT = 2017 --   year/month/status 


