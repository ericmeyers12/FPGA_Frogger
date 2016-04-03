module adder_16_bit(	input [15:0] D_In1,
							input [15:0] D_In2,
							output logic [15:0] D_Out);
				 
assign D_Out = D_In1+D_In2;

endmodule 