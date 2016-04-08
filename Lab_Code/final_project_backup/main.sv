module  main 		( 	  input         Clk,
                                     Reset,
							  output [8:0]  LEDG,
							  output [17:0] LEDR,
							  // VGA Interface 
                       output [7:0]  Red,
							                Green,
												 Blue,
							  output        VGA_clk,
							                sync,
												 blank,
												 vs,
												 hs,
							  // PS/2 interface
							  input	 	 	 psClk, psData
											);
    
   logic 			Reset_h, vssig, press,
						p1_up, p1_down, p1_left, p1_right, p1_shoot,
						p2_up, p2_down, p2_left, p2_right, p2_shoot,
						new_level;
						
	logic [1:0] 	winner;
						
	logic [9:0] 	drawxsig, drawysig,
						p1_x, p1_y, p1_w, p1_h, p1_dir,
						p2_x, p2_y, p2_w, p2_h, p2_dir,
						b1_x, b1_y, b1_w, b1_h,
						b2_x, b2_y, b2_w, b2_h,
						p1_health, p2_health,
						p1_lives, p2_lives,
						p1_init_x, p1_init_y,
						p2_init_x, p2_init_y,
						num_levels, random_number;
						
    
	logic [191:0] 	map;
	logic [9:0]		TILE_SIZE, NUM_COLS, START_MAP;
	
	assign TILE_SIZE = 40;
	assign NUM_COLS = 16;
	assign START_MAP = 0;
	 
   assign {Reset_h}=~ (Reset);

	
   vga_controller vgasync_instance(.*,
	                                 .Clk(Clk),
											   .Reset(Reset_h),
											   .pixel_clk(VGA_clk),
											   .DrawX(drawxsig),
								 			   .DrawY(drawysig) 
	);

	random randy (	.*,
						.clk(vs),
						.lowerBound(10'b0),
						.upperBound(num_levels),
						.random_number(random_number)
						);
	
	keyboard kb (	.*,
						.Clk(Clk),
						.reset(Reset_h),
						.psClk(psClk),
						.psData(psData)
	);


	player	player1(	.*,
							.frame_clk(vs),
							.Reset(Reset_h),
							
							.init_x(p1_init_x),
							.init_y(p1_init_y),
							
							.PlayerX(p1_x),
							.PlayerY(p1_y),
							.PlayerW(p1_w),
							.PlayerH(p1_h),
							.PlayerDir(p1_dir),
							
							.BulletX(b1_x),
							.BulletY(b1_y),
							.BulletW(b1_w),
							.BulletH(b1_h),
							
							.EnemyX(p2_x),
							.EnemyY(p2_y),
							.EnemyW(p2_w),
							.EnemyH(p2_h),
							.EnemyHealth(p2_health),
							.EnemyLives(p2_lives),
							
							.up(p1_up),
							.down(p1_down),
							.left(p1_left),
							.right(p1_right),
							.shoot(p1_shoot),
							.new_level(new_level));
							
							
	player	player2(	.*,
							.frame_clk(vs),
							.Reset(Reset_h),
							
							.init_x(p2_init_x),
							.init_y(p2_init_y),
							
							.PlayerX(p2_x),
							.PlayerY(p2_y),
							.PlayerW(p2_w),
							.PlayerH(p2_h),
							.PlayerDir(p2_dir),
							
							.BulletX(b2_x),
							.BulletY(b2_y),
							.BulletW(b2_w),
							.BulletH(b2_h),
							
							.EnemyX(p1_x),
							.EnemyY(p1_y),
							.EnemyW(p1_w),
							.EnemyH(p1_h),
							.EnemyHealth(p1_health),
							.EnemyLives(p1_lives),
							
							.up(p2_up),
							.down(p2_down),
							.left(p2_left),
							.right(p2_right),
							.shoot(p2_shoot),
							.new_level(new_level)  );
						  
						
	map maps(	.*,
					.init_map(START_MAP),
					.reset(Reset_h),
					.next_level(random_number),
					.clk(vs),
					.mask(map));
	
	
	color_mapper color_instance(	.*,
											.Player1X(p1_x),
											.Player1Y(p1_y),
											.Player1W(p1_w),
											.Player1H(p1_h),
											.Player1Dir(p1_dir),
											.Player1Health(p1_health),
											.Player1Lives(p1_lives),
											
											.Player2X(p2_x),
											.Player2Y(p2_y),
											.Player2W(p2_w),
											.Player2H(p2_h),
											.Player2Dir(p2_dir),
											.Player2Health(p2_health),
											.Player2Lives(p2_lives),
											
											.Bullet1X(b1_x),
											.Bullet1Y(b1_y),
											.Bullet1W(b1_w),
											.Bullet1H(b1_h),
											
											.Bullet2X(b2_x),
											.Bullet2Y(b2_y),
											.Bullet2W(b2_w),
											.Bullet2H(b2_h),
											
											.DrawX(drawxsig),
											.DrawY(drawysig)
											 );
	
	assign LEDR = {p1_up,p1_down,p1_left,p1_right,p1_shoot};
	assign LEDG = {p2_up,p2_down,p2_left,p2_right,p2_shoot};

endmodule
