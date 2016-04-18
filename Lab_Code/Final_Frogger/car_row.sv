//-------------------------------------------------------------------------
//    Car.sv                                                            --
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


module  car_row ( input Reset, frame_clk,
						input [2:0] Number_Cars,			/*Total number of car modules used MAX 4 CARS/ROW*/
						input [7:0] Gap_Size,				/*Defines gap size from xcoord of 1 car to xcoord to another car*/
						input [4:0] Speed,					/*1-32 speed, used in car module state machine*/
						input Direction, 						/*1 = RIGHT, 0 = LEFT */
						input [10:0] Car_Start_Y,
						output logic [3:0] [10:0] Car_X, 	/*640/10 = 64 positions (2^6) on grid with 10 pixel steps*/
						output logic [3:0] [10:0] Car_Y, 			/*Car_Y is for entire Row*/
						input [10:0] Frog_X, Frog_Y,
						output logic Car_Collision
				 );
				 
	logic [10:0] Car_Start_X;
	assign Car_Start_X = 11'd0;
	logic [3:0] car_collision_intermediate;
	
	//This will generate a total of 4 Car Modules every time
	//Color Mapper will determine which ones must be on and which ones must be off
	generate
      genvar i;
		for (i = 0; i <= 2'd3; i = i + 1) 
		begin: car_i
				car car_instance(.Reset,
									.frame_clk,
									.CarX(Car_X[i]),
									.CarY(Car_Y[i]),
									.Car_Start_X(Car_Start_X + Gap_Size*i + i*11'd80), 
									.Car_Start_Y,
									.Direction,
									.Speed,
									.Frog_X,
									.Frog_Y,
									.Car_Collision(car_collision_intermediate[i])
									);
		end
   endgenerate	 
	
	assign Car_Collision = ((car_collision_intermediate [0] && Number_Cars <= 1) ||
								   (car_collision_intermediate [1] && Number_Cars <= 2) ||
									(car_collision_intermediate [2] && Number_Cars <= 3) ||
									(car_collision_intermediate [3] && Number_Cars <= 4)) ? 1 : 0;
   
endmodule