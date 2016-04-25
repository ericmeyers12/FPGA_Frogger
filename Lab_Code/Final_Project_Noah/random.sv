module random(input clk, reset,
					input [7:0] seed,
					output logic [8:0] random);
					
	parameter [8:0] multiplier = 9'd229;
	parameter [8:0] increment = 9'd71;
			
	always_ff @ (posedge clk or posedge reset)
		begin
			if(reset)
				begin
					random <= seed;
				end
			else
				begin
					random <= random * multiplier + increment;
				end
		end
					
endmodule