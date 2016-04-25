module (output logic [15:0] MAR, MDR,
        input logic Clk, Reset_h, MIO_EN);

   always_ff @ (posedge Clk or posedge Reset_h)
     begin
	      if (Reset_h)
		      begin
					   MAR <= 0;
					   MDR <= 0;
		      end
		    else
		      begin
             // Setup register loading
             MAR <= Data;
             if (MIO_EN)
               MDR <= MDR_In;
          end
     end // always_ff @
	 
endmodule
