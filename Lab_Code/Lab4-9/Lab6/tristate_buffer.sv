module tristate_buffer(	input logic [15:0] D_In, 
								input logic select, 
								output logic [15:0] D_Out);

always_comb
begin
	D_Out=D_In;
end
endmodule