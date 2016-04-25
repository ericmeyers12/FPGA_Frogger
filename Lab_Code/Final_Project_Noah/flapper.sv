module flapper(input Clk,
					output logic flap);
			
parameter [7:0] TOTAL_CYCLES = 8'd30;		
parameter [7:0] FLAP_BOUND = 8'd15;
logic [7:0] counter = 8'b0;
	
always_ff @ (posedge Clk)
  begin
    counter <= counter + 1;
    if(counter > TOTAL_CYCLES) begin
	   flap <= 1'b0;
		counter <= 1'b0;
	 end else if(counter > FLAP_BOUND) begin
	   flap <= 1'b1;
	 end else begin
	   flap <= 1'b0;
	 end
  end
			
endmodule