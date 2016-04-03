//-----------------------------------
// NZP Register
//-----------------------------------

module NZP_Reg(input Clk, Reset, LD_CC,
					input [15:0] databus,
					input [2:0] NZP,
					output logic BEN);
					
logic n, z, p;
	
always_comb
begin
	if ((NZP & {n, z, p}) != 0)
		BEN = 1;
	else
		BEN = 0;
end		
		
always_ff @ (posedge Clk or posedge Reset)
begin	
	if (Reset) 
	begin
		 n <= 0;
		 z <= 0;
		 p <= 0;
	end
		
	else if (Load)	begin
		if(databus == 16'b0) begin
			n <= 0;
			z <= 1;
			p <= 0;
		end else if (databus[15] == 1) begin
			n <= 1;
			z <= 0;
			p <= 0;
		end else if (databus[15] == 0) begin
			n <= 0;
			z <= 0;
			p <= 1;
		end
	end
end	

always_comb
begin
	if ((NZP & {n, z, p}) != 0)
		BEN = 1;
	else
		BEN = 0;
end

endmodule
