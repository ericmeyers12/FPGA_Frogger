module bird( input Reset, frame_clk, gameOn, ded,
               output [9:0] BirdX, BirdY, BirdS,
               input        space);
   
   logic [9:0]              Bird_X_Pos, Bird_X_Velocity, Bird_Y_Pos, Bird_Size, Bird_Y_Velocity;
   
   parameter [9:0] Bird_X_Center=320;  // Center position on the X axis
   parameter [9:0] Bird_Y_Center=240;  // Center position on the Y axis
   parameter [9:0] Bird_X_Min=0;       // Leftmost point on the X axis
   parameter [9:0] Bird_X_Max=639;     // Rightmost point on the X axis
   parameter [9:0] Bird_Y_Min=0;       // Topmost point on the Y axis
   parameter [9:0] Bird_Y_Max=479;     // Bottommost point on the Y axis
   parameter [9:0] Bird_X_Step=1;      // Step size on the X axis
   logic [9:0] Bird_Y_Accel;     // Downward acceleration
   parameter [9:0] Bird_Y_Up_Velocity=~(10'h7) + 1;     // Velocity immediately after pressing up

   enum                     logic [1:0] {UP, DOWN, WAIT} state, next_state;
	
	logic[2:0] apply_accel_counter; 

   
   assign Bird_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
   always_ff @ (posedge Reset or posedge frame_clk )
     begin: Move_Bird
        if (Reset)  // Asynchronous Reset
          begin
             state <= DOWN;
             Bird_Y_Velocity <= 10'd0; 
             Bird_X_Velocity <= 10'd0;
             Bird_Y_Pos <= Bird_Y_Center;
             Bird_X_Pos <= Bird_X_Center;
				 Bird_Y_Accel <= 10'b0;
				 apply_accel_counter <= 3'b0;
          end
        
        else begin
          state <= next_state;
             if ( (Bird_Y_Pos + Bird_Size) >= Bird_Y_Max && Bird_Y_Pos[9] != 1'b1)  // Bird is at the bottom edge, DIE!
             begin
               Bird_Y_Velocity <= 10'b0;
					Bird_Y_Pos <= Bird_Y_Max - Bird_Size - 1;
					Bird_Y_Accel <= 10'b0;
					apply_accel_counter <= 3'b0;
             end
             else 
               begin
                  if (state == UP) begin // Go straight up
							Bird_Y_Accel <= 10'b10;
							apply_accel_counter <= 3'b0;
                     Bird_Y_Velocity <= Bird_Y_Up_Velocity;
                  end
                  else // Accelerate downward
							if (apply_accel_counter > 3) begin
								Bird_Y_Velocity <= Bird_Y_Velocity + Bird_Y_Accel;
								apply_accel_counter <= 3'b0;
							end else begin
								apply_accel_counter <= apply_accel_counter + 1;
							end
						  
					Bird_Y_Pos <= (Bird_Y_Pos + Bird_Y_Velocity);  // Update bird position
					Bird_X_Pos <= (Bird_X_Pos + Bird_X_Velocity);
             end
          end  
     end
   
   assign BirdX = Bird_X_Pos;
   
   assign BirdY = Bird_Y_Pos;
   
   assign BirdS = Bird_Size;
   

   always_comb begin
      next_state = state;

      case (state)
        DOWN:
          if (space)
				if (gameOn && ~ded)
					next_state = UP;
          else
            next_state = DOWN;

        UP: // Only stay in up for one state
          next_state = WAIT;
       
      WAIT: // Wait for the up button to come down
       if (~space) 
        next_state = DOWN;
        
      endcase // case (state)
  end
      
endmodule
