module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
					// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;

logic reset, clear_a_load_b, run;

logic [7:0] S;

logic X;

logic [7:0] Aval,
				Bval;
				
logic [6:0] AhexL,
				AhexU,
				BhexL,
				BhexU; 

// To store expected results
logic [7:0] ans_1a, ans_2b;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
multiplier multiplier0(.*);	

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
reset = 0;

//Set initial values on operational switches
clear_a_load_b = 1;
run = 1;

//Switches - 1st operand = -59
S = 8'b11000101;				// Specify S

// Keep reset high
#2 reset = 1;
				
//Toggle ClearALoadB
#2 clear_a_load_b = 0;		
#2 clear_a_load_b = 1;


//Switch - 2nd operand = +7
#2 S = 8'b00000111;	// Change S

// Toggle Execute
#2 run = 0;
#2 run = 1;

  
  
if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule