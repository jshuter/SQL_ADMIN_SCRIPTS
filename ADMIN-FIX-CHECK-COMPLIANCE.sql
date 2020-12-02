-- Determine who has more than 1 record of compliance tracking: they should NOT have more than 1 record or else
-- client_scouts_check_individual_compliance will fail and the user will not be able to login (White Screen)
-- Also see ZD414115
-- A summary listing the individual and the total number of rows it has

-- Step 1. Check and see if anyone should be cleaned up
select c01_ind_cst_key, count(c01_key) as numOfRows from client_scouts_compliance_tracking
group by c01_ind_cst_key
having count(c01_key) > 1


-- Step 2: If there are some individual that needs to be cleaned up. Run below
begin transaction

delete from client_scouts_compliance_tracking
where c01_key in
(
	select c01_key from
	(
		select 
		-- row index ordered by add_date. The first one will be the latest record
		ROW_NUMBER() OVER (PARTITION BY c01_ind_cst_key order by c01_add_date desc) as row_num,
		c01_key
		from client_scouts_compliance_tracking
	) A
	where row_num <> 1 --exclude the latest record (will only affect individual who has more than 1 record)
)


--Step 3: Once you are sure. Commit the changes.

--commit

/* For checking an individual 
SELECT * FROM client_scouts_compliance_tracking WHERE c01_ind_cst_key = 'KEY_HERE'
order by c01_add_date desc

*/





