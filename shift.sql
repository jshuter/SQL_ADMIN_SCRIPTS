drop function if exists TOOLS.[Shift]
go 
/*
	A simple function to shift the 1st item of of a multi line text variable 

	@String, the string to be parserd
	@Delimiter : 
		<EOL> is token for [CHR-13 + CHAR-10]

		Delimited accepts any valid T-SQL PATTERN 

USAGE 

	SELECT * from  TOOLS.shift('123456789-98765432122222222222222222','2345') 

*/
CREATE FUNCTION TOOLS.[Shift] (
	@string varchar(max), 
	@delimiter varchar(10)
) RETURNS Table
AS
RETURN ( 

	SELECT 

		SUBSTRING(
			@string,
			1 + len(@delimiter)
			,
			patindex(
				'%'+@delimiter+'%',
				@string
			) + len(@delimiter)-2	) as first, 


		SUBSTRING(
			@string, 
			patindex(
				'%'+@delimiter+'%',
				@string
			) + len(@delimiter),
			len(@string)
			) as rest 
)

GO 


