//------------------------------------------------------------------------------
// Arithmetic Logic Unit (ALU)
//------------------------------------------------------------------------------

module ALU(input [15:0] A_In, B_In, input [1:0] F, output logic [15:0] D_Out);

always_comb
	begin
		unique case (F)
			2'b00 : D_Out = A_In + B_In ;
			2'b01 : D_Out = A_In & B_In ;
			2'b10 : D_Out = ~A_In;
			2'b11 : D_Out = A_In;
			default : D_Out = A_In;
		endcase
	end
endmodule