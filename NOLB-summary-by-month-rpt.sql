


-- Daily Discount Amounts 

-- VOIDS ? 
-- REFUNDS ? 
-- OTHER ? 

select bat.bat_date , SUM(ivd.ivd_price)  

from ac_batch bat
 join ac_invoice inv on inv.inv_bat_key = bat.bat_key
 join ac_invoice_detail ivd on ivd.ivd_inv_key = inv.inv_key 
 join oe_product_type ptp on ptp.ptp_key = ivd.ivd_prc_prd_ptp_key and ptp.ptp_code = 'Discount' 

where bat.bat_date between '2015-09-01' and '2015-10-31' 
 and  bat.bat_code like '%-000101'
 and inv.inv_delete_flag=0 

group by bat.bat_date 




select  * from ac_batch bat 
 join ac_invoice inv on inv.inv_bat_key = bat.bat_key
 join ac_invoice_detail ivd on ivd.ivd_inv_key = inv.inv_key 
 join oe_product_type ptp on ptp.ptp_key = ivd.ivd_prc_prd_ptp_key and ptp.ptp_code = 'Discount' 

where bat.bat_date between '2015-10-19' and '2015-10-20' 
 and  bat.bat_code like '%-000101'
 and inv.inv_delete_flag=0 

select * from client_scouts_online_transaction_error_log
where z70_add_date between '2015-10-19' and '2015-10-20' 
order by z70_add_date
