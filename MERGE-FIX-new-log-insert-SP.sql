
USE [netForumSCOUTSTest]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[client_scouts_generic_log_insert] (
	@description	[nvarchar](800) ,
	@reason			[nvarchar](50) = NULL ,	
	@source			[nvarchar](50) = NULL ,
	@field1			[nvarchar](50) = NULL ,
	@field2			[nvarchar](50) = NULL ,
	@field3			[nvarchar](50) = NULL ,
	@field4			[nvarchar](50) = NULL 
) 

AS

BEGIN 

SET NOCOUNT ON

if (@description is not null) begin 

	INSERT INTO [dbo].[client_scouts_generic_log]
	(	[z77_description],
		[z77_reason],	
		[z77_source],
		[z77_f1],
		[z77_f2],
		[z77_f3],
		[z77_f4])
	VALUES 
	(	@description,
		@reason,	
		@source,
		@field1,
		@field2,
		@field3,
		@field4)
		
end 

-- else DO NOTHING ! 

END 

go 

exec [client_scouts_generic_log_insert] 'this is test 1', @field1='11111111'
exec [client_scouts_generic_log_insert] 'this is test 2', @field2='22222222'
exec [client_scouts_generic_log_insert] 'this is test 3', @field3='33333333'
exec [client_scouts_generic_log_insert] 'this is test 4', @field1='aaaaaaa', @field2='bbbbb'

select * from [dbo].[client_scouts_generic_log]
