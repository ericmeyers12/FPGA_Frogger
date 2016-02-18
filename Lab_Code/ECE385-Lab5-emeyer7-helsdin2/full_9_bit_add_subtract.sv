module full_9_bit_add_subtract(	input [7:0] A, B,
											input subtract,
											output logic [8:0] Sum
										);

wire c[8:0];
logic [7:0] B_S;
logic A_9, B_9;

/*Flipping bit conditionally*/
assign B_S = B ^ {8{subtract}};
assign A_9 = A[7];
assign B_9 = B_S[7];


full_adder full_adder1(.a(A[0]), .b(B_S[0]), .c_in(subtract), .s(Sum[0]), .c_out(c[0]));
full_adder full_adder2(.a(A[1]), .b(B_S[1]), .c_in(c[0]), .s(Sum[1]), .c_out(c[1]));
full_adder full_adder3(.a(A[2]), .b(B_S[2]), .c_in(c[1]), .s(Sum[2]), .c_out(c[2]));
full_adder full_adder4(.a(A[3]), .b(B_S[3]), .c_in(c[2]), .s(Sum[3]), .c_out(c[3]));
full_adder full_adder5(.a(A[4]), .b(B_S[4]), .c_in(c[3]), .s(Sum[4]), .c_out(c[4]));
full_adder full_adder6(.a(A[5]), .b(B_S[5]), .c_in(c[4]), .s(Sum[5]), .c_out(c[5]));
full_adder full_adder7(.a(A[6]), .b(B_S[6]), .c_in(c[5]), .s(Sum[6]), .c_out(c[6]));
full_adder full_adder8(.a(A[7]), .b(B_S[7]), .c_in(c[6]), .s(Sum[7]), .c_out(c[7]));
full_adder full_adder9(.a(A_9), .b(B_9), .c_in(c[7]), .s(Sum[8]), .c_out(c[8]));

endmodule
