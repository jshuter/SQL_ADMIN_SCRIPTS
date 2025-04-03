USE SMTR 

DECLARE @MWTopsAccountId INT = 1041

SELECT top 100 AsOfDate, StagingDateCreated
FROM SMTR.OP.FactorExposure 
WHERE AccountId = @MWTopsAccountId --@MWTopsAccountId 
	AND FactorType = 'Country'-- @BBFactorType
GROUP BY AsOfDate, StagingDateCreated
order by StagingDateCreated desc, AsOfDate desc 

SELECT AsOfDate, StagingDateCreated
FROM SMTR.OP.FactorExposure 
WHERE AccountId = @MWTopsAccountId --@MWTopsAccountId 
	AND FactorType = 'Country'-- @BBFactorType
GROUP BY AsOfDate, StagingDateCreated
order by StagingDateCreated desc, AsOfDate desc 

SELECT AsOfDate, StagingDateCreated FROM SMTR.OP.FactorExposure WHERE StagingDateCreated='2024-08-19 10:45:10.757'
order by 1 desc 

UPDATE SMTR.OP.FactorExposure = getdate() set WHERE StagingDateCreated='2024-08-19 10:45:10.757'
