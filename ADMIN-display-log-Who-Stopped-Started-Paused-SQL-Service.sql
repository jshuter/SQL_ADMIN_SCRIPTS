
SELECT  TE.name AS [EventName] ,
        v.subclass_name ,
        T.DatabaseName ,
        t.DatabaseID ,
        t.NTDomainName ,
        t.ApplicationName ,
        t.LoginName ,
        t.SPID ,
        t.StartTime ,
        t.SessionLoginName
FROM    sys.fn_trace_gettable(CONVERT(VARCHAR(150), ( SELECT TOP 1
                                                              f.[value]
                                                      FROM    sys.fn_trace_getinfo(NULL) f
                                                      WHERE   f.property = 2
                                                    )), 4) T  -- 4 is the default number of trace log files
        JOIN sys.trace_events TE ON T.EventClass = TE.trace_event_id
        JOIN sys.trace_subclass_values v ON v.trace_event_id = TE.trace_event_id
                                            AND v.subclass_value = t.EventSubClass

WHERE STARTTIME BETWEEN '2021-03-29' AND '2021-03-30'
AND subclass_name NOT IN ('Commit', 'begin')
ORDER BY STARTTIME 

--WHERE   te.name IN ( 'Audit Server Starts and Stops' )