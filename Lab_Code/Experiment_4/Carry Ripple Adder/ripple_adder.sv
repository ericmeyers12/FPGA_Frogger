module ripple_adder
(
    input	[15:0] A,
    input   [15:0] B,
    output  [15:0] Sum,
    output	CO
);
	wire c[14:0];

   full_adder(.x(A[0]), .y(B[0]), .z(0), .s(Sum[0]), .c(c[0]));
	full_adder(.x(A[1]), .y(B[1]), .z(c[0]), .s(Sum[1]), .c(c[1]));
	full_adder(.x(A[2]), .y(B[2]), .z(c[1]), .s(Sum[2]), .c(c[2]));
	full_adder(.x(A[3]), .y(B[3]), .z(c[2]), .s(Sum[3]), .c(c[3]));
	full_adder(.x(A[4]), .y(B[4]), .z(c[3]), .s(Sum[4]), .c(c[4]));
	full_adder(.x(A[5]), .y(B[5]), .z(c[4]), .s(Sum[5]), .c(c[5]));
	full_adder(.x(A[6]), .y(B[6]), .z(c[5]), .s(Sum[6]), .c(c[6]));
	full_adder(.x(A[7]), .y(B[7]), .z(c[6]), .s(Sum[7]), .c(c[7]));
	full_adder(.x(A[8]), .y(B[8]), .z(c[7]), .s(Sum[8]), .c(c[8]));
	full_adder(.x(A[9]), .y(B[9]), .z(c[8]), .s(Sum[9]), .c(c[9]));
	full_adder(.x(A[10]), .y(B[10]), .z(c[9]), .s(Sum[10]), .c(c[10]));
	full_adder(.x(A[11]), .y(B[11]), .z(c[10]), .s(Sum[11]), .c(c[11]));
	full_adder(.x(A[12]), .y(B[12]), .z(c[11]), .s(Sum[12]), .c(c[12]));
	full_adder(.x(A[13]), .y(B[13]), .z(c[12]), .s(Sum[13]), .c(c[13]));
	full_adder(.x(A[14]), .y(B[14]), .z(c[13]), .s(Sum[14]), .c(c[14]));
	full_adder(.x(A[15]), .y(B[15]), .z(c[14]), .s(Sum[15]), .c(CO));
	
endmodule
