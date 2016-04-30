//-------------------------------------------------------------------------
//    LPad.sv                                                            --
//    Does the thing with the thing with the LPad.\                                                       --
//                                                       --
//-------------------------------------------------------------------------


module  lilypad( input Reset, frame_clk,
               output [10:0]  LPadX, LPadY, LPad_Width, LPad_Height,
					input [10:0] LPad_Start_X, LPad_Start_Y,
					input Direction,
					input [5:0] Speed,
					input [10:0] Frog_X, Frog_Y,
					output [5:0] LPad_Remainder_Count,
					output logic [3:0] LPad_Collision
				 );
    
    logic [10:0] LPad_X_Position, LPad_Y_Position, LPad_X_Motion, LPad_Y_Motion;
	 
	 logic [10:0] time_count;
	 
	 enum		logic [1:0] {MOVE, WAIT} state, next_state;
	 
    parameter [10:0] LPad_X_Min=11'd0;       // Leftmost point on the X axis
    parameter [10:0] LPad_X_Max=11'd640;     // Rightmost point on the X axis
    parameter [10:0] LPad_Y_Min=11'd0;       // Topmost point on the Y axis
    parameter [10:0] LPad_Y_Max=11'd480;     // Bottommost point on the Y axis
    parameter [10:0] LPad_X_Step=11'd20;      // Step size on the X axis
    parameter [10:0] LPad_Y_Step=11'd0;      // Step size on the Y axis
	 parameter [10:0] X_TOLERANCE = 11'd5;
	 parameter [10:0] Y_TOLERANCE = 11'd1;
	 parameter [10:0] Frog_Side = 11'd40;

    assign LPad_Width = 40;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign LPad_Height = 40;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_LPad
        if (Reset)  // Asynchronous Reset
        begin 
				state <= MOVE;
				time_count <= 6'b0;
            LPad_Y_Motion <= 11'd0; //LPad_Y_Step;
				LPad_X_Motion <= 11'd0; //LPad_X_Step;
				LPad_Y_Position <= LPad_Start_Y;
				LPad_X_Position <= LPad_Start_X;
        end
        else 
        begin 
				state <= next_state;
				case(state)
					MOVE:
					begin
						if (Direction == 1'b0) //DIRECTION == LEFT
						begin
							if ((LPad_X_Position + LPad_Width) == 11'd0)  //LEFT EDGE
								LPad_X_Position = 11'd640;
							else
								LPad_X_Motion = ~(LPad_X_Step) + 1; //2s Complement
						end
						else //DIRECTION == RIGHT
						begin
							if ((LPad_X_Position == 11'd640)) //RIGHT EDGE
								LPad_X_Position = 11'd2008;
							else
								LPad_X_Motion = LPad_X_Step;
						end
						time_count = 11'b0;
					end
					WAIT:
					begin
						LPad_X_Motion = 11'b0;
						time_count <= time_count + 1;
					end
				endcase		 
				LPad_X_Position <= (LPad_X_Position + LPad_X_Motion);  // Update LPad position
		end
	end
	
   assign LPad_Motion_X = LPad_X_Motion;
	assign LPad_Remainder_Count = time_count;
	
	always_comb 
	begin
      next_state = state;
      case (state)
			WAIT: next_state = (time_count == Speed) ? MOVE : WAIT;
			
			MOVE:	next_state = WAIT;
		endcase
		/*
		 * 4 Scenarios for Collision with LPad:
		 *		UPPER LEFT
		 *		UPPER RIGHT
		 *		BOTTOM LEFT
		 *		BOTTOM RIGHT
		 *		Change Frog_X and Frog_Y values to change tolerance to sprite collisions (in future)
		 */
		if (
			((Frog_X+X_TOLERANCE) >= LPad_X_Position && (Frog_X+X_TOLERANCE) <= (LPad_X_Position + LPad_Width)  /*TOP LEFT*/
			&& (Frog_Y+Y_TOLERANCE) >= LPad_Y_Position && (Frog_Y+Y_TOLERANCE) <= (LPad_Y_Position + LPad_Height)) 
			||
			((Frog_X+X_TOLERANCE) >= LPad_X_Position && (Frog_X+X_TOLERANCE) <= (LPad_X_Position + LPad_Width) /*BOTTOM LEFT*/
			&& ((Frog_Y-Y_TOLERANCE) + Frog_Side) >= LPad_Y_Position && ((Frog_Y-Y_TOLERANCE) + Frog_Side) <= (LPad_Y_Position + LPad_Height))
			||
			(((Frog_X-X_TOLERANCE) + Frog_Side) >= LPad_X_Position && ((Frog_X-X_TOLERANCE) + Frog_Side) <= (LPad_X_Position + LPad_Width) /*TOP RIGHT*/
			&& (Frog_Y+Y_TOLERANCE) >= LPad_Y_Position && (Frog_Y+Y_TOLERANCE) <= (LPad_Y_Position+LPad_Height))
			||
			(((Frog_X-X_TOLERANCE) + Frog_Side) >= LPad_X_Position && ((Frog_X-X_TOLERANCE) + Frog_Side) <= (LPad_X_Position + LPad_Width) /*BOTTOM RIGHT*/
			&& ((Frog_Y-Y_TOLERANCE) + Frog_Side) >= LPad_Y_Position && ((Frog_Y-Y_TOLERANCE) + Frog_Side) <= (LPad_Y_Position + LPad_Height))
			)
			LPad_Collision = 1'b1;
		else
			LPad_Collision = 1'b0;
	end
    
	assign LPadX = LPad_X_Position;
	assign LPadY = LPad_Y_Position;
endmodule