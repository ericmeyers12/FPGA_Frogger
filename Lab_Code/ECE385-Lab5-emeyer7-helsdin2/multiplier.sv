/*  LAB 5 - MULTIPLIER (ECE385)
* 	Authors: Eric Meyers, Ryan Helsdingen
*	Date: February 17th, 2016
*/	
 

/* Module declaration.  Everything within the parentheses()
 * is a port between this module and the outside world */
 
module multiplier
(
	input logic 			Clk,					//Internal Clock Signal
								reset,   			//Push Button 1 - RESET Signal 
								clear_a_load_b,	//Push Button 2 - ClearALoadB Signal - Self Explanator
								run,					//Push Button 3 - Run Signal 
					
	input logic  [7:0]	S,					//8 Switches on FPGA

	output logic 			X,					//MostSigBit of A
	
					
	output logic [7:0]	Aval,				//A Output on Shift Register (8 bits)
								Bval,				//B Output on Shift Register (8 bits)

	output logic [6:0]	AhexL,			//HEX DISPLAY
								AhexU,			//HEX DISPLAY
								BhexL,			//HEX DISPLAY
								BhexU				//HEX DISPLAY
);

/*wires and logics defined here simply for movement between modules*/
wire sh_en, load_a_add, load_b, subtract_wire, shft_out_A;
logic [8:0] Sum;
logic B_shift_out, reset_high, clear_a_load_b_high, run_high;

/*Need to flip status of buttons becuase high is low and vice versa*/
always_comb
begin
	reset_high = ~reset;
	clear_a_load_b_high = ~clear_a_load_b;
	run_high = ~run;
end


/*CONTROL UNIT*/					 	
control_unit control(.*, 
							.reset_button(reset_high), 
							.clear_a_load_b_button(clear_a_load_b_high), 
							.execute_button(run_high), 
							.M(B_shift_out),
							.shift_enable(sh_en), 
							.add(load_a_add), 
							.load(load_b), 
							.subtract(subtract_wire)
);

/*9-BIT ADDER/SUBTRACTOR*/
full_9_bit_add_subtract adder(.A(Aval), 
										.B(S),
										.subtract(subtract_wire),
										.Sum(Sum)
);

/*8-BIT SHIFT REGISTER - A */
shift_register_8_bit register_A(	.*, 
											.reset(reset_high), 
											.shift_in(X), 
											.load(load_a_add), 
											.shift_enable(sh_en),
											.D_in(Sum[7:0]),
											.shift_out(shft_out_A),
											.D_out(Aval)
);

/*8-BIT SHIFT REGISTER - B*/
shift_register_8_bit register_B(	.*, 
											.reset(reset_high), 
											.shift_in(shft_out_A), 
											.load(load_b), 
											.shift_enable(sh_en),
											.D_in(S),
											.shift_out(B_shift_out),
											.D_out(Bval)
);

/* X Register Flip Flop */						
x_ff X_register(	.*,
						.load(load_a_add),
						.reset(reset_high),
						.D_in(Sum[8]),
						.D_out(X));
						
/* HEX DRIVERS TO OUTPUT TO DISPLAY */ 
HexDriver HexAL(
.In0(Aval[3:0]),
.Out0(AhexL));

HexDriver HexAU(
.In0(Aval[7:4]),
.Out0(AhexU));

HexDriver HexBL(
.In0(Bval[3:0]),
.Out0(BhexL));

HexDriver HexBU(
.In0(Bval[7:4]),
.Out0(BhexU));

endmodule
