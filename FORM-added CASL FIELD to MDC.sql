

SELECT     TOP (200)* 
FROM         md_column
WHERE     (mdc_table_name LIKE 'co_individual_ext')
ORDER BY mdc_name

begin  transaction 
update md_column 
set mdc_data_type='av_flag' 
where mdc_name = 'ind_casl_permission_ext' 
--commit

