module testbench();
   timeunit 10ns;// Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
   timeprecision 1ns;
   
   // These signals are internal because the control will be
   // instantiated as a submodule in testbench.
	logic Reset, frame_clk;
   logic [10:0]  CarX, CarY, Car_Width, Car_Height, Car_Start_X, Car_Start_Y;
	logic Direction;
                       
   // A counter to count the instances where simulation results
   // do no match with expected results
   integer      ErrorCnt = 0;

   // Instantiating the DUT
   // Make sure the module and signal names match with those in your design
   car car_instance(.*);
	
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
      Car_Start_X = 11'd320;
      Car_Start_Y = 11'd240;
		Direction = 1'b0;
      Reset = 0;
      
      #2 Reset = 1;
		#3 Reset = 0;
      
      if (ErrorCnt == 0)
        $display("Success!");
      else
        $display("%d error(s) detected. Try again!", ErrorCnt);
   end

endmodule

