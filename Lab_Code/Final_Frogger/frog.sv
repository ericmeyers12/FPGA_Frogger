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
               output [10:0]  FrogX, FrogY, Frog_Width, Frog_Height,
					input up, down, left, right);
    
    logic [10:0] Frog_X_Position, Frog_Y_Position, Frog_X_Motion, Frog_Y_Motion;
	 
	 enum		logic [2:0] {UP, DOWN, LEFT, RIGHT, WAIT, SET} state, next_state;
	 
    parameter [10:0] Frog_X_Start=320;  // Start position on the X axis
    parameter [10:0] Frog_Y_Start=440;  // Start position on the Y axis
    parameter [10:0] Frog_X_Min=0;       // Leftmost point on the X axis
    parameter [10:0] Frog_X_Max=640;     // Rightmost point on the X axis
    parameter [10:0] Frog_Y_Min=0;       // Topmost point on the Y axis
    parameter [10:0] Frog_Y_Max=480;     // Bottommost point on the Y axis
    parameter [10:0] Frog_X_Step=40;      // Step size on the X axis
    parameter [10:0] Frog_Y_Step=40;      // Step size on the Y axis

    assign Frog_Width = 40;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Frog_Height = 40;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Frog
        if (Reset)  // Asynchronous Reset
        begin 
				state <= SET;
            Frog_Y_Motion <= 11'd0; //Frog_Y_Step;
				Frog_X_Motion <= 11'd0; //Frog_X_Step;
				Frog_Y_Position <= Frog_Y_Start;
				Frog_X_Position <= Frog_X_Start;
        end
        else 
        begin 
				 state <= next_state;
				 if ((Frog_Y_Position + Frog_Height) > Frog_Y_Max)  //BOTTOM EDGE
				 begin
					  //Frog_Y_Motion <= 11'b0;
					  Frog_Y_Position = Frog_Y_Max - Frog_Height;
				 end
				 else if (Frog_Y_Position > 11'd800 && Frog_Y_Position < 11'd1024) //TOP EDGE
				 begin
					  //Frog_Y_Motion <= 11'b0;
					  Frog_Y_Position = Frog_Y_Min;
				 end
				 else if ((Frog_X_Position + Frog_Width) > Frog_X_Max )  //RIGHT EDGE
				 begin
					  //Frog_X_Motion <= 11'b0;
					  Frog_X_Position = Frog_X_Max - Frog_Width;
				 end
				 else if (Frog_X_Position > 11'd800 && Frog_X_Position < 11'd1024)  //LEFT EDGE
				 begin
					  //Frog_X_Motion <= 11'b0;
					  Frog_X_Position = Frog_X_Min;
				 end
				 else 
					begin
						if(state == UP && Frog_Y_Position != 0)//RIGHT BUTTON PRESSED
						begin
								Frog_X_Motion <= 11'b0;
								Frog_Y_Motion <= ~(Frog_Y_Step)+1; //2s Complement
						end
						else if(state == DOWN) //DOWN BUTTON PRESSED
						begin
								Frog_X_Motion <= 11'b0;
								Frog_Y_Motion <= Frog_Y_Step;
						end
						else if(state == LEFT && Frog_X_Position != 0) //LEFT BUTTON PRESSED
						begin
								Frog_Y_Motion <= 11'b0;
								Frog_X_Motion <= ~(Frog_X_Step)+1; //2s Complement
						end
						else if(state == RIGHT) //RIGHT BUTTON PRESSED
						begin
								Frog_Y_Motion <= 11'b0;
								Frog_X_Motion <= Frog_X_Step;
						end
						else //DEFAULT CASE - Nothing pressed so stay still
						begin
							Frog_Y_Motion <= 11'b0;
							Frog_X_Motion <= 11'b0;
						end
				end	 
				Frog_Y_Position <= (Frog_Y_Position + Frog_Y_Motion);  // Update Frog position
				Frog_X_Position <= (Frog_X_Position + Frog_X_Motion);
		end
	end
	
	assign FrogX = Frog_X_Position;
	assign FrogY = Frog_Y_Position;
	
	//STATE MACHINE FOR ONLY MOVING ONCE UPON ANY KEYPRESS
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