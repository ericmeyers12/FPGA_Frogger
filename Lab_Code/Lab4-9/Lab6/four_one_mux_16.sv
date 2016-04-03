module four_one_mux_16(	input logic [15:0] D_In1, D_In2, D_In3, D_In4,
								input logic [1:0] select,
								output logic [15:0] D_Out
					);
						
	always_comb
	begin
		case(select)
			2'b00:
				D_Out <= D_In1;
			2'b01:
				D_Out <= D_In2;
			2'b10:
				D_Out <= D_In3;
			2'b11:
				D_Out <= D_In4;
		endcase
	end	
			
endmodule