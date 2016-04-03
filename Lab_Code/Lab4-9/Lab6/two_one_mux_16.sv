module two_one_mux_16(	input logic [15:0] D_In1, D_In2,
								input logic select,
								output logic [15:0] D_Out
					);
						
	always_comb
	begin
		D_Out = (~select) ? D_In1 : D_In2;
	end	
			
endmodule