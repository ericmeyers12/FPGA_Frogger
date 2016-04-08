module random(	input clk,
					input [9:0] lowerBound,upperBound,p1_lives,p2_lives,
					output [9:0] random_number
					);
					
	logic[9:0] range, counter;
	
	assign range = upperBound - lowerBound;
					
	always_ff @ (posedge clk)
	begin
	
		random_number = (counter%range)+lowerBound;
		counter = counter + 10'b1;
	
	end

endmodule 