//-------------------------------------------------------------------------
//    LPad_Row.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  lilypad_row (input Reset, frame_clk,
						input [2:0] Number_LPads,			/*Total number of lpad modules used MAX 4 LPadS/ROW*/
						input [7:0] Gap_Size,				/*Defines gap size from xcoord of 1 car to xcoord to another car*/
						input [5:0] Speed,					/*1-32 speed, used in car module state machine*/
						input Direction, 						/*1 = RIGHT, 0 = LEFT */
						input [10:0] LPad_Start_Y,
						output [5:0] LPad_Remainder_Count,
						output logic [3:0] [10:0] LPad_X, 	/*640 positions*/
						output logic [3:0] [10:0] LPad_Y, 	/*Car_Y is for entire Row*/
						input [10:0] Frog_X, Frog_Y,
						output logic LPad_Collision
				 );
    	 
	logic [10:0] LPad_Start_X;
	assign LPad_Start_X = 11'd0;
	logic [3:0] lpad_collision_intermediate;
	logic [3:0][5:0]LPad_Remainder_Count_INT;

		 
	
	//This will generate a total of 4 Car Modules every time
	//Color Mapper will determine which ones must be on and which ones must be off
	generate
      genvar i;
		for (i = 0; i <= 2'd3; i = i + 1) 
		begin: LPad_i
				lilypad lpad_instance(.Reset,
									.frame_clk,
									.LPadX(LPad_X[i]),
									.LPadY(LPad_Y[i]),
									.LPad_Start_X(LPad_Start_X + Gap_Size*i + i*11'd40), 
									.LPad_Start_Y,
									.Direction,
									.Speed,
									.LPad_Remainder_Count(LPad_Remainder_Count_INT[i]),
									.Frog_X,
									.Frog_Y,
									.LPad_Collision(lpad_collision_intermediate[i])
									);
		end
   endgenerate	 
	
	assign LPad_Remainder_Count = LPad_Remainder_Count_INT[0];
	
	
	assign LPad_Collision = ((lpad_collision_intermediate [0] && Number_LPads >= 1) ||
								   (lpad_collision_intermediate [1] && Number_LPads >= 2) ||
									(lpad_collision_intermediate [2] && Number_LPads >= 3) ||
									(lpad_collision_intermediate [3] && Number_LPads == 4)) ? 1 : 0;
   
endmodule