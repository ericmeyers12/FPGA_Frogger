module four_bit_csa(input [3:0] a,
						input [3:0] b,
						input c_in,
						output [3:0] sum,
						output c_out);


wire c[2:0];			
			
one_bit_csa(.a(a[0]), .b(b[0]), .c_in(c_in), .s(sum[0]), .c_out(c[0]));
one_bit_csa(.a(a[1]), .b(b[1]), .c_in(c[0]), .s(sum[1]), .c_out(c[1]));
one_bit_csa(.a(a[2]), .b(b[2]), .c_in(c[1]), .s(sum[2]), .c_out(c[2]));
one_bit_csa(.a(a[3]), .b(b[3]), .c_in(c[2]), .s(sum[3]), .c_out(c_out));

endmodule