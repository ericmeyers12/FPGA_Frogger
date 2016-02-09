module full_adder_cla(input a, b, c_in,
						output s, c_out);

		logic p, g;
		assign s = a^b^c_in;
		assign g = a & b;
		assign p = a ^ b;
		assign c_out = g | (p & c_in);
		
endmodule