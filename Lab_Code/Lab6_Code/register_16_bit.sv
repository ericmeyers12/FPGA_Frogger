module register_16_bit( input Clk, reset, load_enable,
										input [15:0] D_In,
										output logic [15:0] D_Out
									);

									
always_ff @ (posedge Clk)
	begin
		if (load_enable == 1'b1)
			D_Out <= D_In;
		else if (reset == 1'b1)
			D_Out <= 16'b0;
	end

endmodule