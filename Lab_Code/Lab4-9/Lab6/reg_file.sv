//------------------------------------------------------------------------------
// Register File (REG0-7)
//------------------------------------------------------------------------------
module reg_file(input Clk, Reset, LD_REG,
					input logic [15:0] databus, 
					input logic [2:0] DR, SR1, SR2, 
					output logic [15:0] SR1_OUT, SR2_OUT);
	
logic [15:0] registers [0:7];
	
	always_ff @ (posedge Clk)
		begin
			if(LD_REG) registers[DR] <= databus;
		end
	
	always_comb
		begin
			SR1_OUT = registers[SR1];
			SR2_OUT = registers[SR2];
		end
endmodule	
		
	
