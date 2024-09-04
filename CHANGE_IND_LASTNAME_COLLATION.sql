
select ci.ind_last_name
from co_individual ci
where ci.ind_last_name like 'b_langer'


select ci.ind_last_name
from co_individual ci
where ci.ind_last_name = 'belanger'

---
/* 

Msg 5074, Level 16, State 1, Line 2

The column 'ind_full_name_cp' is dependent on column 'ind_last_name'.
The column 'ind_salutation_cp' is dependent on column 'ind_last_name'.
The object 'vw_client_scouts_parent_guardians' is dependent on column 'ind_last_name'.
The index  'IX_co_individual_ind_last_name' is dependent on column 'ind_last_name'.
The index  'IX_co_individual_ind_last_name_ind_first_name' is dependent on column 'ind_last_name'.

Msg 4922, Level 16, State 9, Line 2
ALTER TABLE ALTER COLUMN ind_last_name failed because one or more objects access this column.

*/

/* CANNOT CHANGE COLLATION WITHOUT AFFECTING 5 dependent objects - SEE ABOVE * 
-- default for DB is SQL_Latin1_General_CP1_CI_AS ! 
ALTER TABLE dbo.co_individual
ALTER COLUMN ind_last_name nvarchar(30) 
	COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL;
GO
*/

