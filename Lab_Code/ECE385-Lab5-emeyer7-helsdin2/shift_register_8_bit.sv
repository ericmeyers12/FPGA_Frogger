module shift_register_8_bit( input Clk, reset, shift_in, load, shift_enable,
										input [7:0] D_in,
										output shift_out,
										output logic [7:0] D_out
									);

									
always_ff @ (posedge Clk)
	begin
		if (shift_enable == 1'b1)
			D_out <= { shift_in, D_out[7:1] };
		else if (load == 1'b1)
			D_out <= D_in;
		else if (reset == 1'b1)
			D_out <= 8'b0;
	end

assign shift_out = D_out[0];

endmodule