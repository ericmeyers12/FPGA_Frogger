module three_one_mux_16(input Clk,
						input logic [15:0] D_In1, D_In2, D_In3,
						input logic [1:0] select,
						output logic [15:0] D_Out
					);
						
	always_ff @ (posedge Clk)
	begin
		if (select == 2'b00)
			D_Out <= D_In1;
		else if (select == 2'b01)
			D_Out <= D_In2;
		else if (select == 2'b10)
			D_Out <= D_In3;
	end		
endmodule