module aes_controllerTestbench();
   timeunit 10ns;// Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
   timeprecision 1ns;
   
   // These signals are internal because the control will be
   // instantiated as a submodule in testbench.
   logic [127:0]  msg_en;
   
   logic [127:0]  key;
   
   logic          clk, 
                  reset_n;
   
   logic [127:0]  msg_de;
   logic          aes_ready, io_ready;
                       
   // A counter to count the instances where simulation results
   // do no match with expected results
   integer      ErrorCnt = 0;

   // Instantiating the DUT
   // Make sure the module and signal names match with those in your design
   aes_controller aes(.*);
	
	// Toggle the clock
   // #1 means wait for a delay of 1 timeunit
   always begin : CLOCK_GENERATION
      #1 clk = ~clk;
   end

   initial begin: CLOCK_INITIALIZATION
      clk = 0;
   end

   // Testing begins here
   initial begin: TEST_VECTORS
      msg_en = 128'hdaec3055df058e1c39e814ea76f6747e;
      key = 128'h000102030405060708090a0b0c0d0e0f;
      reset_n = 1;
      io_ready = 0;
      
      // Test a load on reg 7

      #2 reset_n = 0;

      #3 reset_n = 1;
      
      #4 io_ready = 1;
      
      if (ErrorCnt == 0)
        $display("Success!");  // Command line output in ModelSim
      else
        $display("%d error(s) detected. Try again!", ErrorCnt);
   end

endmodule

