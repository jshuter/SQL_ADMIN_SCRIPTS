

USE ElectrumWarehouse 
GO 

SELECT name, 
	size/128.0 FileSize,
	FILEPROPERTY(name, 'spaceused')/128.0 UsedSpace,
	size/128.0 - FILEPROPERTY(name, 'spaceused')/128.0 as EmptySpace,   * FROM SYS.database_files


DBCC SHRINKFILE (ElectrumWarehouse_LOG, 1) 