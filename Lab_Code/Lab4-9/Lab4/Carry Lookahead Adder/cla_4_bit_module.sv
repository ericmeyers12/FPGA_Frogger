module cla_4_bit_module(input [3:0] a,
								input [3:0] b, 
								input c_in,
								output[3:0] s,
								output c_out);

//wire for interconnections in between FA modules
wire c[2:0];

//4 FA that interconnect to form a 4-bit CLA
full_adder_cla(.a(a[0]), .b(b[0]), .c_in(c_in), .s(s[0]), .c_out(c[0]));
full_adder_cla(.a(a[1]), .b(b[1]), .c_in(c[0]), .s(s[1]), .c_out(c[1]));
full_adder_cla(.a(a[2]), .b(b[2]), .c_in(c[1]), .s(s[2]), .c_out(c[2]));
full_adder_cla(.a(a[3]), .b(b[3]), .c_in(c[2]), .s(s[3]), .c_out(c_out));															
		
endmodule