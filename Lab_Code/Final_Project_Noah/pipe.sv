module pipe (input clk, Reset, gameOn, SoftReset,
             input logic [11:0]  startX,
				 input [7:0] switches,
             output logic [11:0] currentX, width, gapSize, gapLocation);

   parameter [11:0] Pipe_X_Step = ~(12'b1) + 12'b1;      // Step on the X axis (-1)
   parameter [11:0] Right_Screen_Edge = 639;     // Rightmost point on the X axis


   assign width = 12'd24; // Width is 24 on each side
   assign gapSize = 12'd75; // Gap size is 75 + 75 (more of a radius)
	
	logic [7:0] random;
	logic RandReset;
	assign RandReset = SoftReset || Reset;
	
	random rand_instance(.clk(clk), .reset(RandReset), .seed(switches), .random(random));
   
   always_ff @ (posedge Reset or posedge clk) begin: Move_Pipe
      if (Reset) begin
         currentX <= startX;
			gapLocation <= random + 112;
      end

      else begin
         // currrentX - width is touching the 0 edge of the screen. 
         if ((currentX + ~(width) + 1) > 12'b0 )
           if (gameOn)
             currentX <= currentX + Pipe_X_Step;
			  else 
				  currentX <= currentX;
         else
			  begin
			    gapLocation <= random + 112;
             currentX <= Right_Screen_Edge + width; // Put it just off the right side of the screen
			  end
      end
   end
endmodule
