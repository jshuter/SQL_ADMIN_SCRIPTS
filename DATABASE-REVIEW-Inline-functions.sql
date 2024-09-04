
use smtr 

select object_name(object_id), is_inlineable inlinable, inline_type inlined, * from sys.sql_modules order by is_inlineable desc , inline_type, 1

