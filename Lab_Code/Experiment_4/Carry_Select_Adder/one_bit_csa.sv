module one_bit_csa(input a, b, c_in,
						output s, c_out);

						
wire s0, s1, c_out0, c_out1;
logic c_out_intermediate_and;

full_adder(.a(a), .b(b), .c_in(0), .s(s0), .c_out(c_out0));
full_adder(.a(a), .b(b), .c_in(1), .s(s1), .c_out(c_out1));

//COUT SELECTION LOGIC
assign c_out_intermediate_and = c_out1 & c_in;
assign c_out = c_out_intermediate_and | c_out0;

//2-to-1 Multiplexer
always_comb
if (c_in == 1'b0) begin
	s = s0;
end else
begin
	s = s1;
end
		
endmodule