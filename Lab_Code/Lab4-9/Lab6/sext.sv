//---------------------------------
//	Sign Extension Registers
//---------------------------------
module sext_6 (input [5:0] D_In, output logic [15:0] D_Out);
	
	always_comb
	begin
		if(D_In[5] == 0)
			D_Out <= (16'b0000000000000000 + D_In);
		else
			D_Out <= (16'b1111111111000000 + D_In);
	end
endmodule

module sext_9 (input [8:0] D_In, output logic [15:0] D_Out);
	
	always_comb
	begin
		if(D_In[8] == 0)
			D_Out <= (16'b0000000000000000 + D_In);
		else
			D_Out <= (16'b1111111000000000 + D_In);
	end
endmodule

module sext_11 (input [10:0] D_In, output logic [15:0] D_Out);
	
	always_comb
	begin
		if(D_In[10] == 0)
			D_Out <= (16'b0000000000000000 + D_In);
		else
			D_Out <= (16'b1111100000000000 + D_In);
	end
endmodule


module sext_5 (input [4:0] D_In, output logic [15:0] D_Out);
	always_comb
	begin
		if(D_In[4] == 0)
			D_Out <= (16'b0000000000000000 + D_In);
		else
			D_Out <= (16'b1111111111100000 + D_In);
	end
endmodule
