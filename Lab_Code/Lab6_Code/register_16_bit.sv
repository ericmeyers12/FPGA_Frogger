module register_16_bit( input Clk, reset, load_enable
										input [7:0] D_in,
										output logic [7:0] D_out
									);

									
always_ff @ (posedge Clk)
	begin
		if (load_enable == 1'b1)
			D_out <= D_in;
		else if (reset == 1'b1)
			D_out <= 16'b0;
	end

endmodule