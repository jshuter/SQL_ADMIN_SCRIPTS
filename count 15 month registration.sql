
select org_name, COUNT(*) from client_scouts_experimental_registration
join co_customer sect on x13_org_cst_key = sect.cst_key 
join co_customer grp on grp.cst_key = sect.cst_parent_cst_key 
join co_organization on org_cst_key = grp.cst_key 
where x13_add_date > '2016-05-01'
and x13_add_user = 'multiyear.split' 
group by org_name 
