//-------------------------------------------------------------------------
//    Frog.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  frog ( input Reset, frame_clk,
               output [9:0]  FrogX, FrogY, FrogS,
					input up, down, left, right);
    
    logic [9:0] Frog_X_Pos, Frog_X_Motion, Frog_Y_Pos, Frog_Y_Motion, Frog_Size;
	 
	 enum		logic [2:0] {UP, DOWN, LEFT, RIGHT, WAIT, SET} state, next_state;
	 
    parameter [9:0] Frog_X_Start=320;  // Start position on the X axis
    parameter [9:0] Frog_Y_Start=440;  // Start position on the Y axis
    parameter [9:0] Frog_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Frog_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Frog_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Frog_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Frog_X_Step=40;      // Step size on the X axis
    parameter [9:0] Frog_Y_Step=30;      // Step size on the Y axis

    assign Frog_Size = 8;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Frog
        if (Reset)  // Asynchronous Reset
        begin 
				state <= SET;
            Frog_Y_Motion <= 10'd0; //Frog_Y_Step;
				Frog_X_Motion <= 10'd0; //Frog_X_Step;
				Frog_Y_Pos <= Frog_Y_Start;
				Frog_X_Pos <= Frog_X_Start;
        end
        else 
        begin 
				 state <= next_state;
				 if ( (Frog_Y_Pos + Frog_Size) >= Frog_Y_Max )  // Frog is at the bottom edge, BOUNCE!
					  Frog_Y_Motion <= (~ (Frog_Y_Step) + 1'b1);  // 2's complement.
				 else if ( (Frog_Y_Pos - Frog_Size) <= Frog_Y_Min )  // Frog is at the top edge, BOUNCE!
					  Frog_Y_Motion <= Frog_Y_Step;
				 else if ( (Frog_X_Pos + Frog_Size) >= Frog_X_Max )  // Frog is at the right edge, BOUNCE!
					  Frog_X_Motion <= (~ (Frog_X_Step) + 1'b1);  // 2's complement.
				 else if ( (Frog_X_Pos - Frog_Size) <= Frog_X_Min )  // Frog is at the left edge, BOUNCE!
					  Frog_X_Motion <= Frog_X_Step;  
				 else 
					begin
						if(state == UP)//RIGHT BUTTON PRESSED = "W"
						begin
								Frog_X_Motion <= 10'b0;
								Frog_Y_Motion <= ~(Frog_Y_Step) + 1;
						end
						else if(state == DOWN) //DOWN BUTTON PRESSED = "S"
						begin
								Frog_X_Motion <= 10'b0;
								Frog_Y_Motion <= Frog_Y_Step;
						end
						else if(state == LEFT) //LEFT BUTTON PRESSED = "A"
						begin
								Frog_Y_Motion <= 10'b0;
								Frog_X_Motion <= ~(Frog_X_Step) + 1;
						end
						else if(state == RIGHT) //RIGHT BUTTON PRESSED = "D"
						begin
								Frog_Y_Motion <= 10'b0;
								Frog_X_Motion <= Frog_X_Step;
						end
						else //DEFAULT CASE - Nothing pressed so stay still
						begin
							Frog_Y_Motion <= 10'b0;
							Frog_X_Motion <= 10'b0;
						end
				end	 
			Frog_Y_Pos <= (Frog_Y_Pos + Frog_Y_Motion);  // Update Frog position
			Frog_X_Pos <= (Frog_X_Pos + Frog_X_Motion);
		end
	end
	
	assign FrogX = Frog_X_Pos;
	assign FrogY = Frog_Y_Pos;
	assign FrogS = Frog_Size;
	
	//STATE MACHINE
	always_comb 
	begin
      next_state = state;
      case (state)
			DOWN:		next_state = WAIT;

			UP:		next_state = WAIT;

			LEFT:		next_state = WAIT;
			
			RIGHT:	next_state = WAIT;
			
			WAIT: next_state = (down == 1'b0 && up == 1'b0 && left == 1'b0 && right == 1'b0) ? SET : WAIT;
			
			SET:
				if (down)
					next_state = DOWN;
				else if (up)
					next_state = UP;
				else if (left)
					next_state = LEFT;
				else if (right)
					next_state = RIGHT;
				else next_state = SET;

		endcase
	end
    
endmodule