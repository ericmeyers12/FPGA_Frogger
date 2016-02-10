module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

wire c[2:0];			

four_bit_full_adder(.a(A[3:0]), .b(B[3:0]), .c_in(0), .s(Sum[3:0]), .c_out(c[0]));
four_bit_csa(.a(A[7:4]), .b(B[7:4]), .c_in(c[0]), .sum(Sum[7:4]), .c_out(c[1]));
four_bit_csa(.a(A[11:8]), .b(B[11:8]), .c_in(c[1]), .sum(Sum[11:8]), .c_out(c[2]));
four_bit_csa(.a(A[15:12]), .b(B[15:12]), .c_in(c[2]), .sum(Sum[15:12]), .c_out(CO));
     
endmodule
