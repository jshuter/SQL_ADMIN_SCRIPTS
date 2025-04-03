SELECT TOP (1000) [Id]
      ,[JobId]
      ,[Name]
      ,[Reason]
      ,[CreatedAt]
      ,[Data]
  FROM ci.[ElectrumPersistent].[HangFire].[State]
  where name = 'failed'
  order by id desc 

