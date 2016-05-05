module testbench();
   timeunit 10ns;// Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
   timeprecision 1ns;
   
   // These signals are internal because the control will be
   // instantiated as a submodule in testbench.
	
   /* ============== FROG, CAR, AND LILYPAD MODULES BELOW ==============*/			
	logic soft_reset, frame_clk;

	logic up, down, left, right, frog_1_key, frog_2_key, frog_3_key;
	
	 logic [10:0] frogcurxsig, frogcurysig, 
					  frog1xsig, frog1ysig, frog1widthsig, frog1heightsig,
					  frog2xsig, frog2ysig, frog2widthsig, frog2heightsig,
					  frog3xsig, frog3ysig, frog3widthsig, frog3heightsig,
					 lpad1xsig, lpad1ysig, lpad1widthsig, lpad1heightsig;
					 
	 logic [3:0] carcollisionsig;
	 logic [3:0] lpadcollisionsig;
	 
	 logic dead_frog1, dead_frog2, dead_frog3;
	 
	 logic [1:0] frog_lives;
	 logic win_game, lose_game;
	 
	 /*4 Cars in Each Row * X Position (Top-Left) for each car*/
	 logic [3:0] [10:0] carrow_xsig [3:0];
	 logic [3:0] [10:0] carrow_ysig [3:0]; 
	 logic [3:0] [10:0] lpadrow_xsig [3:0];
	 logic [3:0] [10:0] lpadrow_ysig [3:0];
	 
	 logic [1:0] curfrog1dir, curfrog2dir, curfrog3dir;
	 
	 logic [3:0] [5:0] LPad_Remainder_Count;

	 /*===== Car Parameters =====*/
	 parameter bit [2:0] Number_Cars_Row [0:3] = '{3'd4, 
																  3'd4, 
																  3'd4,
																  3'd4};

	 
	 parameter bit [7:0] Gap_Size_Cars_Row [0:3] = '{8'd80,
																    8'd80,
																    8'd80,
																    8'd80};
														
	 parameter bit [5:0] Speed_Cars_Row [0:3] = '{6'd10,
															    6'd7,
															    6'd3,
															    6'd1};

	 parameter bit Direction_Cars_Row [0:3] = '{1'b1,
															  1'b0,
															  1'b1,
															  1'b0};
														
	 parameter bit [10:0] Start_Y_Cars_Row [0:3] = '{11'd400,
																    11'd360,
																    11'd320,
																    11'd280};
	
	/*===== Lilypad Parameters =====*/
	 parameter bit [2:0] Number_LPad_Row [0:3] = '{3'd4, 
																  3'd4, 
																  3'd4,
																  3'd4};

	 
	 parameter bit [7:0] Gap_Size_LPad_Row [0:3] = '{8'd80,
																	 8'd80,
																    8'd80,
																	 8'd80};
														
	 parameter bit [5:0] Speed_LPad_Row [0:3] = '{5'd30,
																 5'd27,
															    5'd30,
															    5'd25};

	 parameter bit Direction_LPad_Row [0:3] = '{1'b1,
															  1'b0,
															  1'b1,
															  1'b0};
														
	 parameter bit [10:0] Start_Y_LPad_Row [0:3] = '{11'd80,
																    11'd120,
																    11'd160,
																    11'd200};
	 
		always_comb
		begin
			if (frog_1_key)
			begin
				frogcurxsig = frog1xsig;
				frogcurysig = frog1ysig;
			end
			else if (frog_2_key)
			begin
				frogcurxsig = frog2xsig;
				frogcurysig = frog2ysig;
			end
			else if (frog_3_key)
			begin
				frogcurxsig = frog3xsig;
				frogcurysig = frog3ysig; 
			end
			else 
			begin
				frogcurxsig = 11'd0;
				frogcurysig = 11'd0;
			end
		end
							  
		generate
      genvar i;
		for (i = 0; i <= 2'd3; i = i + 1) 
		begin: car_row_i
			car_row car_row_instance1(.Reset(soft_reset),
									.frame_clk,
									.Number_Cars(Number_Cars_Row[i]),
									.Gap_Size(Gap_Size_Cars_Row[i]),
									.Speed(Speed_Cars_Row[i]),
									.Direction(Direction_Cars_Row[i]), 
									.Car_Start_Y(Start_Y_Cars_Row[i]),
									.Car_X(carrow_xsig[i]), 	
									.Car_Y(carrow_ysig[i]),
									.Frog_X(frogcurxsig),
									.Frog_Y(frogcurysig),
									.Car_Collision(carcollisionsig[i]));
		end
		endgenerate	 
		
	
		generate
      genvar j;
		for (j = 0; j <= 2'd3; j = j + 1) 
		begin: lpad_row_j
			lilypad_row lilypad_row (.Reset(soft_reset), 
						.frame_clk,
						.Number_LPads(Number_LPad_Row[j]),
						.Gap_Size(Gap_Size_LPad_Row[j]),
						.Speed(Speed_LPad_Row[j]),
						.LPad_Remainder_Count(LPad_Remainder_Count[j]),
						.Direction(Direction_LPad_Row[j]), 
						.LPad_Start_Y(Start_Y_LPad_Row[j]),
						.LPad_X(lpadrow_xsig[j]), 	
						.LPad_Y(lpadrow_ysig[j]),
						.Frog_X(frogcurxsig),
						.Frog_Y(frogcurysig),
						.LPad_Collision(lpadcollisionsig[j])
				 );
		end
		endgenerate	 		

		frog frog_instance_1(.Reset(soft_reset), 
							  .frame_clk,
							  .FrogX(frog1xsig),
							  .FrogY(frog1ysig),
							  .Frog_Width(frog1widthsig),
							  .Frog_Height(frog1heightsig),
							  .Frog_X_Start(11'd120),
							  .up, 
							  .down, 
							  .left, 
							  .right,
							  .Car_Collision(carcollisionsig),
							  .LPad_Speed(Speed_LPad_Row),
							  .LPad_Remainder_Count(LPad_Remainder_Count),
							  .LPad_Direction(Direction_LPad_Row),
							  .LPad_Collision(lpadcollisionsig),
							  .cur_Frog_Direction(curfrog1dir),
							  .dead_frog(dead_frog1),
							  .active(frog_1_key),
							  .win(win_game),
							  .lose(lose_game)
							  );
//							  
		frog frog_instance_2(.Reset(soft_reset), 
							  .frame_clk,
							  .FrogX(frog2xsig),
							  .FrogY(frog2ysig),
							  .Frog_Width(frog2widthsig),
							  .Frog_Height(frog2heightsig),
							  .Frog_X_Start(11'd320),
							  .up, 
							  .down, 
							  .left, 
							  .right,
							  .Car_Collision(carcollisionsig),
							  .LPad_Speed(Speed_LPad_Row),
							  .LPad_Remainder_Count(LPad_Remainder_Count),
							  .LPad_Direction(Direction_LPad_Row),
							  .LPad_Collision(lpadcollisionsig),
							  .cur_Frog_Direction(curfrog2dir),
							  .dead_frog(dead_frog2),
							  .active(frog_2_key),
							  .win(win_game),
							  .lose(lose_game)
							  );
							  
		frog frog_instance_3(.Reset(soft_reset), 
							  .frame_clk,
							  .FrogX(frog3xsig),
							  .FrogY(frog3ysig),
							  .Frog_Width(frog3widthsig),
							  .Frog_Height(frog3heightsig),
							  .Frog_X_Start(11'd520),
							  .up, 
							  .down, 
							  .left, 
							  .right,
							  .Car_Collision(carcollisionsig),
							  .LPad_Speed(Speed_LPad_Row),
							  .LPad_Remainder_Count(LPad_Remainder_Count),
							  .LPad_Direction(Direction_LPad_Row),
							  .LPad_Collision(lpadcollisionsig),
							  .cur_Frog_Direction(curfrog3dir),
							  .dead_frog(dead_frog3),
							  .active(frog_3_key)
							  );
	
	 assign dead_frog = dead_frog1 || dead_frog2 || dead_frog3;

	 game_logic game_logic_mod(.game_restart(soft_reset), 						//push button that signals restart the game
							.frame_clk,	
							.Frog1_X(frog1xsig), .Frog1_Y(frog1ysig),
							.Frog2_X(frog2xsig), .Frog2_Y(frog2ysig),
							.Frog3_X(frog3xsig), .Frog3_Y(frog3ysig),
							.dead_frog,
							.frog_lives,	
							.win_game,
							.lose_game);
	
	// Toggle the clock
   // #1 means wait for a delay of 1 timeunit
   always begin : CLOCK_GENERATION
      #1 frame_clk = ~frame_clk;
   end

   initial begin: CLOCK_INITIALIZATION
      frame_clk = 0;
   end

   //Testing starts
   initial begin: TEST_VECTORS
      soft_reset = 0;
		left = 0;
		right = 0;
		up = 0;
		down = 0;
		frog_1_key = 0;
		frog_2_key= 0; 
		frog_3_key = 0;
		
		
      #4 soft_reset = 1;
		#5 soft_reset = 0;
		
		#1 frog_1_key = 1;
	
		#50 up = 1;
		#5 up = 0;
		
		#50 up = 1;
		#5 up = 0;
		
		#50 up = 1;
		#5 up = 0;
		
		#50 up = 1;
		#5 up = 0;
		
		#50 up = 1;
		#5 up = 0;
		
		#50 up = 1;
		#5 up = 0;
		
		#50 up = 1;
		#5 up = 0;

   end

endmodule




//module testbench();
//   timeunit 10ns;// Half clock cycle at 50 MHz
//   // This is the amount of time represented by #1
//   timeprecision 1ns;
//   
//   // These signals are internal because the control will be
//   // instantiated as a submodule in testbench.
//	 parameter bit [2:0] Number_LPad_Row [0:3] = '{3'd4, 
//																  3'd4, 
//																  3'd4,
//																  3'd4};
//
//	 
//	 parameter bit [7:0] Gap_Size_LPad_Row [0:3] = '{8'd80,
//																	 8'd80,
//																    8'd80,
//																	 8'd80};
//														
//	 parameter bit [5:0] Speed_LPad_Row [0:3] = '{5'd25,
//																 5'd25,
//															    5'd25,
//															    5'd25};
//
//	 parameter bit Direction_LPad_Row [0:3] = '{1'b1,
//															  1'b0,
//															  1'b1,
//															  1'b0};
//														
//	 parameter bit [10:0] Start_Y_LPad_Row [0:3] = '{11'd320,
//																    11'd360,
//																    11'd400,
//																    11'd440};
//
//	logic Reset, frame_clk;
//
//	logic up, down, left, right;
//
//	logic [3:0] [10:0] lpadrow_xsig [3:0];
//	logic [3:0] [10:0] lpadrow_ysig [3:0];
//	 
//	logic [10:0] frogxsig, frogysig, frogheightsig, frogwidthsig;
//	 
//	logic [3:0] lpadcollisionsig;
//	
//		 logic [3:0] [5:0] LPad_Remainder_Count;
//	logic [1:0] cur_Frog_Direction;
//
//                       
//   // A counter to count the instances where simulation results
//   // do no match with expected results
//   integer      ErrorCnt = 0;
//
//   // Instantiating the DUT
//   // Make sure the module and signal names match with those in your design
//	generate
//	genvar j;
//	for (j = 0; j <= 2'd3; j = j + 1) 
//	begin: lpad_row_j
//		lilypad_row lilypad_row (.Reset, 
//					.frame_clk,
//					.Number_LPads(Number_LPad_Row[j]),
//					.Gap_Size(Gap_Size_LPad_Row[j]),
//					.Speed(Speed_LPad_Row[j]),
//					.LPad_Remainder_Count(LPad_Remainder_Count[j]),
//					.Direction(Direction_LPad_Row[j]), 
//					.LPad_Start_Y(Start_Y_LPad_Row[j]),
//					.LPad_X(lpadrow_xsig[j]), 	
//					.LPad_Y(lpadrow_ysig[j]),
//					.Frog_X(frogxsig),
//					.Frog_Y(frogysig),
//					.LPad_Collision(lpadcollisionsig[j])
//				 ); 	
//	end
//	endgenerate
//
//									
//	frog frog_instance(.Reset, 
//							  .frame_clk,
//							  .FrogX(frogxsig),
//							  .FrogY(frogysig),
//							  .Frog_Width(frogwidthsig),
//							  .Frog_Height(frogheightsig),
//							  .up, 
//							  .down, 
//							  .left, 
//							  .right,
//							  .LPad_Remainder_Count,
//							  .LPad_Speed(Speed_LPad_Row),
//							  .LPad_Direction(Direction_LPad_Row),
//							  .LPad_Collision(lpadcollisionsig),
//							  .cur_Frog_Direction
//							  );
//	
//	// Toggle the clock
//   // #1 means wait for a delay of 1 timeunit
//   always begin : CLOCK_GENERATION
//      #1 frame_clk = ~frame_clk;
//   end
//
//   initial begin: CLOCK_INITIALIZATION
//      frame_clk = 0;
//   end
//
//   //Testing starts
//   initial begin: TEST_VECTORS
//      Reset = 0;
//		left = 0;
//		right = 0;
//		up = 0;
//		down = 0;
//		
//		
//      #4 Reset = 1;
//		#5 Reset = 0;
//
//  
//		
//		#100 up = 1;
//		#5 up = 0;
//
//      
//      if (ErrorCnt == 0)
//        $display("Success!");
//      else
//        $display("%d error(s) detected. Try again!", ErrorCnt);
//   end
//
//endmodule
//
