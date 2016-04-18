module testbench();
   timeunit 10ns;// Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
   timeprecision 1ns;
   
   // These signals are internal because the control will be
   // instantiated as a submodule in testbench.
	logic Reset, frame_clk;
	logic [2:0] Number_Cars;			/*Total number of car modules used MAX 4 CARS/ROW*/
	logic [7:0] Gap_Size;				/*Defines gap size from xcoord of 1 car to xcoord to another car*/
	logic [4:0] Speed;					/*1-32 speed, used in car module state machine*/
	logic Direction; 						/*1 = RIGHT, 0 = LEFT */
	logic [10:0] Car_Start_Y;
	logic [3:0] [10:0] Car_X; 	/*640/10 = 64 positions (2^6) on grid with 10 pixel steps*/
	logic [3:0] [10:0] Car_Y;
	logic [10:0] Frog_X, Frog_Y;
	logic Car_Collision;
                       
   // A counter to count the instances where simulation results
   // do no match with expected results
   integer      ErrorCnt = 0;

   // Instantiating the DUT
   // Make sure the module and signal names match with those in your design
   car_row car_row_instance(.*);
	
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
		Frog_X = 600;
		Frog_Y = 0;
		Number_Cars = 3'd2;
      Gap_Size = 8'd80;
		Speed = 5'd10;
      Direction = 1'b1;
		Car_Start_Y = 11'd0;
      
      #2 Reset = 1;
		#3 Reset = 0;
      
      if (ErrorCnt == 0)
        $display("Success!");
      else
        $display("%d error(s) detected. Try again!", ErrorCnt);
   end

endmodule

