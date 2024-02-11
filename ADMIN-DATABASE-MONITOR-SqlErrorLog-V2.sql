


EXEC xp_readerrorlog 0, 1, NULL, NULL, '2024-02-06', NULL, 'DESC'

exec sp_who2


-- SERVER 
-- current log 
EXEC xp_readerrorlog 0, 1, N'Fatal', NULL, '2024-02-06', NULL, 'DESC'
EXEC xp_readerrorlog 0, 1, N'Error', NULL, '2024-02-06', NULL, 'DESC'

-- prior log 
EXEC xp_readerrorlog 1, 1, N'Fatal', NULL, '2024-02-07', NULL, 'DESC'
EXEC xp_readerrorlog 1, 1, N'Error', NULL, '2024-02-07', NULL, 'DESC'

-- AGENT 
-- current log 
EXEC xp_readerrorlog 0, 2, N'Fatal', NULL, '2024-02-06', NULL, 'DESC'
EXEC xp_readerrorlog 0, 2, N'Error', NULL, '2024-02-06', NULL, 'DESC'

-- prior log 
EXEC xp_readerrorlog 1, 2, N'Fatal', NULL, '2024-02-06', NULL, 'DESC'
EXEC xp_readerrorlog 1, 2, N'Error', NULL, '2024-02-06', NULL, 'DESC'



EXEC xp_readerrorlog 1, 1, N'Fatal', NULL, '2024-02-07', NULL, 'DESC'
EXEC xp_readerrorlog 1, 1, N'Error', NULL, '2024-02-07', NULL, 'DESC'
