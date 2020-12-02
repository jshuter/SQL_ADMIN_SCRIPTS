--  USE SP_HELP 
--  Then move columns - name/type/length/nullable
-- Column_name	Type	Length	Nullable

/* 

--exec #md_column_quick_insert 'z83_key','varchar',50			,0,0,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_coupon_type','varchar',10		,1,1,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_coupon_amount','varchar',10	,1,0,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_coupon_unit','varchar',10		,1,0,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_coupon_limit','int',4			,1,1,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_coupon_uses','int',4			,1,1,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_expiry_date','av_date',8		,1,1,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_org_cst_key','av_key',16		,1,1,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_notes','varchar',1000			,1,0,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_add_user','av_user',128		,0,1,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_add_date','av_date',8			,0,1,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_change_user','av_user',128	,1,0,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_change_date','av_date',8		,1,0,'client_scouts_coupons'
exec #md_column_quick_insert 'z83_delete_flag','av_delete_flag',1,0,1,'client_scouts_coupons'

-- delete md_column where mdc_name = 'z83_coupon_type'

-- select * from md_column where mdc_name like 'z83%'
*/


ALTER procedure #md_column_quick_insert

  @column_name    varchar(50)  
, @data_type      varchar(50) 
, @width		  int 
, @nullable 	  int 
, @required       int
, @table_name     varchar(50) 
, @description    varchar(50) = ''


AS BEGIN 

select * from md_column

insert into md_column( 
 mdc_key
,mdc_name 
,mdc_mdt_name 
,mdc_table_name
,mdc_description 
,mdc_data_type  
,mdc_width 
,mdc_width_max
,mdc_required 
,mdc_nullable
,mdc_readonly
,mdc_readonlyedit
,mdc_not_editable
,mdc_hidden
,mdc_has_lookup
,mdc_autopostback
,mdc_change_log_flag
,mdc_disable_autocomplete_flag
,mdc_enable_subform_lookup_flag
,mdc_available_in_social_flag
,mdc_delete_flag
,mdc_ext 
,mdc_add_user
,mdc_add_date
,mdc_sort_order
,mdc_query_select_flag
) 
values(
 newid()
 ,@column_name				-- column-name
 ,@table_name	-- table name 
 ,@table_name	-- table name 
 ,@description -- description 
 ,@data_type  -- data type 
 ,@width		-- width 
 ,@width 		-- width (max) 
 ,@required		-- required 
 ,@nullable 	-- nullable 
 , 0
 , 0,0,0,0,0,0,0,0,0,0,0
 , 'jshuter'
 , GETDATE()
 , 1000
 ,1
 ) 
   
 select * from md_column where 
 mdc_name like 'z82%' 
or mdc_name like 'z83%' 
order by mdc_name

END 