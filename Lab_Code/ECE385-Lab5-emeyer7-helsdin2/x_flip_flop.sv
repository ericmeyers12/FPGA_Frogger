module x_ff ( input Clk, load, reset, D_in,
				  output logic D_out );

always @ (posedge Clk or posedge reset)
begin
	D_out = D_out;
	
	if(reset)
		D_out <= 1'b0;
	else if(load)
		D_out <= D_in;
end			

endmodule