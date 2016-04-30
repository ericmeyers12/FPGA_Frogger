module testbench();
   timeunit 10ns;// Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
   timeprecision 1ns;
   
   // These signals are internal because the control will be
   // instantiated as a submodule in testbench.
	 parameter bit [2:0] Number_LPad_Row [0:3] = '{3'd4, 
																  3'd4, 
																  3'd4,
																  3'd4};

	 
	 parameter bit [7:0] Gap_Size_LPad_Row [0:3] = '{8'd80,
																	 8'd80,
																    8'd80,
																	 8'd80};
														
	 parameter bit [5:0] Speed_LPad_Row [0:3] = '{5'd15,
																 5'd20,
															    5'd25,
															    5'd10};

	 parameter bit Direction_LPad_Row [0:3] = '{1'b1,
															  1'b0,
															  1'b1,
															  1'b0};
														
	 parameter bit [10:0] Start_Y_LPad_Row [0:3] = '{11'd320,
																    11'd360,
																    11'd400,
																    11'd440};

	logic Reset, frame_clk;

	logic up, down, left, right;

	logic [3:0] [10:0] lpadrow_xsig [3:0];
	logic [3:0] [10:0] lpadrow_ysig [3:0];
	 
	logic [10:0] frogxsig, frogysig, frogheightsig, frogwidthsig;
	 
	logic [3:0] lpadcollisionsig;
	
		 logic [3:0] [5:0] LPad_Remainder_Count;
	logic [1:0] cur_Frog_Direction;

                       
   // A counter to count the instances where simulation results
   // do no match with expected results
   integer      ErrorCnt = 0;

   // Instantiating the DUT
   // Make sure the module and signal names match with those in your design
	generate
	genvar j;
	for (j = 0; j <= 2'd3; j = j + 1) 
	begin: lpad_row_j
		lilypad_row lilypad_row (.Reset, 
					.frame_clk,
					.Number_LPads(Number_LPad_Row[j]),
					.Gap_Size(Gap_Size_LPad_Row[j]),
					.Speed(Speed_LPad_Row[j]),
					.LPad_Remainder_Count(LPad_Remainder_Count[j]),
					.Direction(Direction_LPad_Row[j]), 
					.LPad_Start_Y(Start_Y_LPad_Row[j]),
					.LPad_X(lpadrow_xsig[j]), 	
					.LPad_Y(lpadrow_ysig[j]),
					.Frog_X(frogxsig),
					.Frog_Y(frogysig),
					.LPad_Collision(lpadcollisionsig[j])
				 ); 	
	end
	endgenerate

									
	frog frog_instance(.Reset, 
							  .frame_clk,
							  .FrogX(frogxsig),
							  .FrogY(frogysig),
							  .Frog_Width(frogwidthsig),
							  .Frog_Height(frogheightsig),
							  .up, 
							  .down, 
							  .left, 
							  .right,
							  .LPad_Remainder_Count,
							  .LPad_Speed(Speed_LPad_Row),
							  .LPad_Direction(Direction_LPad_Row),
							  .LPad_Collision(lpadcollisionsig),
							  .cur_Frog_Direction
							  );
	
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
      Reset = 0;
		left = 0;
		right = 0;
		up = 0;
		down = 0;
		
		
      #4 Reset = 1;
		#5 Reset = 0;
		
		#2 down = 1;
		#3 down = 0;
		
		#50 left = 1;
		#1 left = 0;
		
		#150  
		
		#5 up = 1;
		#5 up = 0;
      
      if (ErrorCnt == 0)
        $display("Success!");
      else
        $display("%d error(s) detected. Try again!", ErrorCnt);
   end

endmodule

