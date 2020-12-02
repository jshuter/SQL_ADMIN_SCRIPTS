CREATE proc #TMP_add_pc
	@pc varchar(10) , 
	@lat float,
	@long float
as 
begin 

	set @pc = RTRIM(@pc) 
	if(@pc like '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]') 
		set @pc = LEFT(@pc,3) + RIGHT(@pc,3) 
	
	if(@pc like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]') BEGIN

		if exists(select * from client_scouts_postal_long_lat where a20_post_code = @pc) 
			select * from client_scouts_postal_long_lat where a20_post_code = @pc
		else BEGIN 
		
			INSERT client_scouts_postal_long_lat (a20_key, a20_post_code, a20_latitude, a20_longitude) 
				values ( newid(), @pc, @lat, @long) 
					
		END  

		select * from client_scouts_postal_long_lat where a20_post_code like left(@pc,5) + '%'
			order by a20_post_code

	END else 
	
		select 'BAD PC' 
 		
end 

go 



--./get_postal_code.php 'L7P0M'
exec #TMP_add_pc 'L7P0M0', 43.42392, -79.933014
exec #TMP_add_pc 'L7P0M1', 43.423920, -79.933014
exec #TMP_add_pc 'L7P0M2', 43.426531, -79.936069
exec #TMP_add_pc 'L7P0M3', 43.423275, -79.933355
exec #TMP_add_pc 'L7P0M4', 43.420860, -79.932157
exec #TMP_add_pc 'L7P0M5', 43.197781, -79.676958
exec #TMP_add_pc 'L7P0M6', 43.421952, -79.930499
exec #TMP_add_pc 'L7P0M7', 43.425557, -79.930372
exec #TMP_add_pc 'L7P0M8', 43.422978, -79.926616
exec #TMP_add_pc 'L7P0M9', 43.421279, -79.929332

--./get_postal_code.php 'P0X1C'
exec #TMP_add_pc 'P0X1C0', 49.761057, -94.556550

--./get_postal_code.php 'T0K0I'
exec #TMP_add_pc 'T0K0I0', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I1', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I2', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I3', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I4', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I5', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I6', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I7', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I8', 49.024567, -111.298373
exec #TMP_add_pc 'T0K0I9', 49.024567, -111.298373

--./get_postal_code.php 'K2C0A'
exec #TMP_add_pc 'K2C0A0', 45.381048, -75.710576
exec #TMP_add_pc 'K2C0A1', 45.374273, -75.709300
exec #TMP_add_pc 'K2C0A2', 45.373242, -75.711722
exec #TMP_add_pc 'K2C0A3', 45.370120, -75.718898
exec #TMP_add_pc 'K2C0A4', 45.368943, -75.721610
exec #TMP_add_pc 'K2C0A5', 45.367541, -75.724843
exec #TMP_add_pc 'K2C0A6', 45.366837, -75.726466
exec #TMP_add_pc 'K2C0A7', 45.363704, -75.736163
exec #TMP_add_pc 'K2C0A8', 45.363241, -75.738653
exec #TMP_add_pc 'K2C0A9', 45.363603, -75.733816

--./get_postal_code.php 'KIC4W'  === I to 1 ??
exec #TMP_add_pc 'K1C4W0', 45.462087, -75.518195
exec #TMP_add_pc 'K1C4W1', 45.462087, -75.518195
exec #TMP_add_pc 'K1C4W2', 45.459013, -75.526889
exec #TMP_add_pc 'K1C4W3', 45.460814, -75.522051
exec #TMP_add_pc 'K1C4W4', 45.462087, -75.518195
exec #TMP_add_pc 'K1C4W5', 45.459031, -75.522422
exec #TMP_add_pc 'K1C4W6', 45.462087, -75.518195
exec #TMP_add_pc 'K1C4W7', 45.462087, -75.518195
exec #TMP_add_pc 'K1C4W8', 45.458237, -75.521641
exec #TMP_add_pc 'K1C4W9', 45.458159, -75.520967


--./get_postal_code.php 'S0X0A'

??

--./get_postal_code.php 'S6W0A'

exec #TMP_add_pc 'S6W0A0', 53.180327, -105.7394
exec #TMP_add_pc 'S6W0A1', 53.180327, -105.739400
exec #TMP_add_pc 'S6W0A2', 53.180327, -105.739400
exec #TMP_add_pc 'S6W0A3', 53.180480, -105.765065
exec #TMP_add_pc 'S6W0A4', 53.186543, -105.772216
exec #TMP_add_pc 'S6W0A5', 53.209598, -105.737409
exec #TMP_add_pc 'S6W0A6', 53.184099, -105.769828
exec #TMP_add_pc 'S6W0A7', 53.180327, -105.7394
exec #TMP_add_pc 'S6W0A8', 53.180327, -105.7394
exec #TMP_add_pc 'S6W0A9', 53.180327, -105.7394

--./get_postal_code.php 'L6C0T'

exec #TMP_add_pc 'L6C0T0', 43.885684, -79.310265
exec #TMP_add_pc 'L6C0T1', 43.885684, -79.310265
exec #TMP_add_pc 'L6C0T2', 43.884922, -79.310687
exec #TMP_add_pc 'L6C0T3', 43.882806, -79.310618
exec #TMP_add_pc 'L6C0T4', 43.910741, -79.375541
exec #TMP_add_pc 'L6C0T5', 43.909641, -79.375311
exec #TMP_add_pc 'L6C0T6', 43.910257, -79.376266
exec #TMP_add_pc 'L6C0T7', 43.910018, -79.376622
exec #TMP_add_pc 'L6C0T8', 43.909333, -79.377761
exec #TMP_add_pc 'L6C0T9', 43.908400, -79.378821


--./get_postal_code.php 'L7R3X'
-- Has 2 vALUES !!!!
exec #TMP_add_pc 'L7R3X4', 43.385638, -79.851640



--./get_postal_code.php 'N0G2R'

exec #TMP_add_pc 'N0G2R0', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R1', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R2', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R3', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R4', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R5', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R6', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R7', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R8', 44.065773, -81.669774
exec #TMP_add_pc 'N0G2R9', 44.070157, -81.578761

--./get_postal_code.php 'N3H3L'

exec #TMP_add_pc 'N3H3L0', 43.392093, -80.352916
exec #TMP_add_pc 'N3H3L1', 43.392093, -80.352916
exec #TMP_add_pc 'N3H3L2', 43.390733, -80.351691
exec #TMP_add_pc 'N3H3L3', 43.390817, -80.351010
exec #TMP_add_pc 'N3H3L4', 43.389912, -80.350028
exec #TMP_add_pc 'N3H3L5', 43.390365, -80.349439
exec #TMP_add_pc 'N3H3L6', 43.389248, -80.348706
exec #TMP_add_pc 'N3H3L7', 43.389778, -80.348455
exec #TMP_add_pc 'N3H3L8', 43.389057, -80.346834
exec #TMP_add_pc 'N3H3L9', 43.388743, -80.347557

--./get_postal_code.php 'N0L1K'


exec #TMP_add_pc 'N0L1K0', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K1', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K2', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K3', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K4', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K5', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K6', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K7', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K8', 42.715602, -81.306648
exec #TMP_add_pc 'N0L1K9', 42.715602, -81.306648

--./get_postal_code.php 'T0B3M'

exec #TMP_add_pc 'T0B3M0', 53.235667, -113.073743
exec #TMP_add_pc 'T0B3M1', 53.337850, -113.219927
exec #TMP_add_pc 'T0B3M2', 53.330673, -113.098382
exec #TMP_add_pc 'T0B3M3', 53.300276, -113.244497
exec #TMP_add_pc 'T0B3M4', 53.235736, -113.098287
exec #TMP_add_pc 'T0B3M5', 53.235667, -113.073743
exec #TMP_add_pc 'T0B3M6', 52.957418, -111.703535
exec #TMP_add_pc 'T0B3M7', 53.235667, -113.073743
exec #TMP_add_pc 'T0B3M8', 53.235667, -113.073743
exec #TMP_add_pc 'T0B3M9', 53.235667, -113.073743

--./get_postal_code.php 'NOM2T'             O ==> 0 

exec #TMP_add_pc 'N0M2T0', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T1', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T2', 43.421170, -81.624776
exec #TMP_add_pc 'N0M2T3', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T4', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T5', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T6', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T7', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T8', 43.421402, -81.655186
exec #TMP_add_pc 'N0M2T9', 43.421402, -81.655186
 
--./get_postal_code.php 'POM1N'   O = 0 

exec #TMP_add_pc 'P0M1N0', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N1', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N2', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N3', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N4', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N5', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N6', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N7', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N8', 46.482293, -81.067343
exec #TMP_add_pc 'P0M1N9', 46.482293, -81.067343







