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
					input [10:0] Frog_X_Start,
					input up, down, left, right,
					input bit [5:0] LPad_Speed [0:3],
					input [3:0] [5:0] LPad_Remainder_Count,
					input bit LPad_Direction [0:3],
					input [3:0] LPad_Collision,
					input [3:0] Car_Collision,
					input active,
					output logic [1:0] cur_Frog_Direction,
					input dead,
					input win);		//up 00, down 01, left 11, right 10
    
    logic [10:0] Frog_X_Position, Frog_Y_Position, Frog_X_Motion, Frog_Y_Motion; 
	 logic [5:0] time_count;
	 
	 enum		logic [3:0] {UP, DOWN, LEFT, RIGHT, KEYWAIT, WAIT, RESET, DEAD, WIN, LILY_WAIT, LILY_MOVE} state, next_state;
	 
    parameter [10:0] Frog_X_Min=0;       // Leftmost point on the X axis
    parameter [10:0] Frog_X_Max=640;     // Rightmost point on the X axis
    parameter [10:0] Frog_Y_Min=0;       // Topmost point on the Y axis
    parameter [10:0] Frog_Y_Max=480;     // Bottommost point on the Y axis
    parameter [10:0] Frog_X_Step=20;      // Step size on the X axis
    parameter [10:0] Frog_Y_Step=40;      // Step size on the Y axis
	 parameter [10:0] LPad_X_Step=20;

    assign Frog_Width = 40;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Frog_Height = 40;
	 
	 int collision_idx;
	 
	 always_comb
	 begin
		if (LPad_Collision[0] == 1'b1)
			collision_idx = 0;
		else if (LPad_Collision[1] == 1'b1)
			collision_idx = 1;
		else if (LPad_Collision[2] == 1'b1)
			collision_idx = 2;
		else if (LPad_Collision[3] == 1'b1)				
			collision_idx = 3;
		else collision_idx = 0;
	 end
	 

   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Frog
        if (Reset)  // Asynchronous Reset
        begin 
				state <= WAIT;
				time_count <= 6'b0;
				cur_Frog_Direction <= 2'd0;
            Frog_Y_Motion <= 11'd0; //Frog_Y_Step;
				Frog_X_Motion <= 11'd0; //Frog_X_Step;
				Frog_Y_Position <= 11'd440;
				Frog_X_Position <= Frog_X_Start;
        end
        else 
        begin 
			 state <= next_state;
			 if ((Frog_Y_Position + Frog_Height) > Frog_Y_Max)  //BOTTOM EDGE
				  Frog_Y_Position = Frog_Y_Max - Frog_Height;
			 else if (Frog_Y_Position > 11'd800 && Frog_Y_Position < 11'd1024) //TOP EDGE
				  Frog_Y_Position = Frog_Y_Min;
			 else if ((Frog_X_Position + Frog_Width) > Frog_X_Max )  //RIGHT EDGE
				  Frog_X_Position = Frog_X_Max - Frog_Width;
			 else if (Frog_X_Position > 11'd800 && Frog_X_Position < 11'd1024)  //LEFT EDGE
				  Frog_X_Position = Frog_X_Min;
			 else 
			 begin
					if (state == RESET)
					begin
							Frog_X_Position = Frog_X_Start;
							Frog_Y_Position = 11'd440;
					end
					/*KEYPRESS*/
					else if(state == UP && Frog_Y_Position != 0 && active)//UP BUTTON PRESSED
					begin
							Frog_X_Motion = 11'b0;
							Frog_Y_Motion = ~(Frog_Y_Step)+1; //2s Complement
							cur_Frog_Direction = 2'b00;
							time_count = 6'b0;
					end
					else if(state == DOWN && Frog_Y_Position != 440 && active) //DOWN BUTTON PRESSED
					begin
							Frog_X_Motion = 11'b0;
							Frog_Y_Motion = Frog_Y_Step;
							cur_Frog_Direction = 2'b01;
							time_count = 6'b0;

					end
					else if(state == LEFT && Frog_X_Position != 0 && active) //LEFT BUTTON PRESSED
					begin
							Frog_Y_Motion = 11'b0;
							Frog_X_Motion = ~(Frog_X_Step)+1; //2s Complement
							cur_Frog_Direction = 2'b11;
							time_count = 6'b0;

					end
					else if(state == RIGHT && Frog_X_Position != 600 && active) //RIGHT BUTTON PRESSED
					begin
							Frog_Y_Motion = 11'b0;
							Frog_X_Motion = Frog_X_Step;
							cur_Frog_Direction = 2'b10;							
							time_count = 6'b0;

					end
					else if (state == LILY_MOVE)
					begin
						if (LPad_Direction[collision_idx] == 1'b0) //DIRECTION == LEFT
						begin
							if ((Frog_X_Position + Frog_Width) == 11'd0)  //LEFT EDGE
							begin
								Frog_X_Position = 11'd0;
							end
							else
								Frog_X_Motion = ~(LPad_X_Step) + 1; //2s Complement
						end
						else //DIRECTION == RIGHT
						begin
							if ((Frog_X_Position == 11'd600)) //RIGHT EDGE
							begin
								Frog_X_Position = 11'd600;
							end
							else
								Frog_X_Motion = LPad_X_Step;
						end
						time_count = 6'b0;
					end
					else if (state == LILY_WAIT)
					begin
						if(time_count == 6'b0)
						begin
							if(LPad_Remainder_Count[collision_idx] != 6'b0)
								time_count = LPad_Remainder_Count[collision_idx] + 1;
							else
								time_count = 6'b0;
						end
						else
							time_count <= time_count + 1;
						Frog_X_Motion = 11'b0;
					end
					else //DEFAULT CASE - WAIT - Nothing pressed so stay still
					begin
							Frog_Y_Motion = 11'b0;
							Frog_X_Motion = 11'b0;
							time_count = 6'b0;
					end
				end
				Frog_X_Position <= (Frog_X_Position + Frog_X_Motion);
				Frog_Y_Position <= (Frog_Y_Position + Frog_Y_Motion); 
		end
	end
	
	assign FrogX = Frog_X_Position;
	assign FrogY = Frog_Y_Position;
	
	//STATE MACHINE
	always_comb 
	begin
      next_state = state;
      case (state)
			WAIT:
				//check if car or water collision - go to DEAD STATE
				if ((Car_Collision[0] || Car_Collision[1] || Car_Collision[2] || Car_Collision[3] || 
					(Frog_Y_Position >= 80 && Frog_Y_Position <= 200 &&
					!(LPad_Collision[0] || LPad_Collision[1] || LPad_Collision[2] || LPad_Collision[3])) || dead) && active)
					next_state = DEAD;
				else if ((LPad_Collision[0] || LPad_Collision[1] || LPad_Collision[2] || LPad_Collision[3])&& active) //check if lilypad collision - go to LILY STATE
					next_state = LILY_WAIT;
				else if (win)
					next_state = WIN;				//check if at end state - go to WIN STATE
				else if (down)//check if keypress
					next_state = DOWN;
				else if (up)
					next_state = UP;
				else if (left)
					next_state = LEFT;
				else if (right)
					next_state = RIGHT;
				else 
					next_state = WAIT;
			
			DEAD: next_state = RESET;
			
			WIN: next_state = RESET;
				
			RESET: next_state = WAIT;
				
			LILY_WAIT: 
				if (down)//check if keypress
					next_state = DOWN;
				else if (up)
					next_state = UP;
				else if (left)
					next_state = LEFT;
				else if (right)
					next_state = RIGHT;
				else if (LPad_Collision[0] == 1'b0 && LPad_Collision[1] == 1'b0 && LPad_Collision[2] == 1'b0 && LPad_Collision[3] == 1'b0)
					next_state = WAIT;
				else if (time_count == (LPad_Speed[collision_idx]))
					next_state = LILY_MOVE;
				else next_state = LILY_WAIT;
				
			
			LILY_MOVE: next_state = LILY_WAIT;
			
			DOWN:		next_state = KEYWAIT;

			UP:		next_state = KEYWAIT;

			LEFT:		next_state = KEYWAIT;
			
			RIGHT:	next_state = KEYWAIT;
			
			KEYWAIT: next_state = (down == 1'b0 && up == 1'b0 && left == 1'b0 && right == 1'b0) ? WAIT : KEYWAIT;
			
			RESET:	next_state = WAIT;

		endcase
	end
    
endmodule