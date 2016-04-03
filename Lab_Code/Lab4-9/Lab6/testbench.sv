module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
					// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;

logic Reset, Run, Continue;

logic [15:0] S;

logic [11:0] LED;
				
logic [6:0] HEX0, HEX1, HEX2, HEX3;

logic CE, UB, LB, OE, WE;

logic [19:0] ADDR;
wire [15:0] Data;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
slc3 slc3_module(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
//Toggle Reset
Reset = 0;

//Set initial values on operational switches
Run = 1;

//Switches - 1st operand = -59
S = 8'b00000000;				// Specify S

// Keep reset high
#2 Reset = 1;
				
//Toggle Run
#2 Run = 0;		
#2 Run = 1;
  

if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule