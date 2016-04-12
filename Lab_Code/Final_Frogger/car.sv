//-------------------------------------------------------------------------
//    Car.sv                                                            --
//    Does the thing with the thing with the car.\                                                       --
//                                                       --
//-------------------------------------------------------------------------


module  car ( input Reset, frame_clk,
               output [10:0]  CarX, CarY, Car_Width, Car_Height,
					input [10:0] Car_Start_X, Car_Start_Y,
					input Direction,
					input [4:0] Speed
				 );
    
    logic [10:0] Car_X_Position, Car_Y_Position, Car_X_Motion, Car_Y_Motion;
	 
	 logic [10:0] time_count;
	 
	 enum		logic [1:0] {MOVE, WAIT} state, next_state;
	 
    parameter [10:0] Car_X_Min=11'd0;       // Leftmost point on the X axis
    parameter [10:0] Car_X_Max=11'd640;     // Rightmost point on the X axis
    parameter [10:0] Car_Y_Min=11'd0;       // Topmost point on the Y axis
    parameter [10:0] Car_Y_Max=11'd480;     // Bottommost point on the Y axis
    parameter [10:0] Car_X_Step=11'd10;      // Step size on the X axis
    parameter [10:0] Car_Y_Step=11'd0;      // Step size on the Y axis

    assign Car_Width = 80;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Car_Height = 40;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Car
        if (Reset)  // Asynchronous Reset
        begin 
				state <= MOVE;
				time_count <= 11'b0;
            Car_Y_Motion <= 11'd0; //Car_Y_Step;
				Car_X_Motion <= 11'd0; //Car_X_Step;
				Car_Y_Position <= Car_Start_Y;
				Car_X_Position <= Car_Start_X;
        end
        else 
        begin 
				state <= next_state;
				case(state)
					MOVE:
					begin
						if (Direction == 1'b0) //DIRECTION == LEFT
						begin
							if ((Car_X_Position + Car_Width) == 11'd0)  //LEFT EDGE
							begin
								Car_X_Position = 11'd640;
							end
							else
							begin
								Car_X_Motion <= ~(Car_X_Step) + 1; //2s Complement
								Car_Y_Motion <= 11'b0;
							end
						end
						else //DIRECTION == RIGHT
						begin
							if ((Car_X_Position == 11'd640))
							begin
								Car_X_Position = 11'd1968;
							end
							else
							begin
								Car_X_Motion <= Car_X_Step;
								Car_Y_Motion <= 11'b0;
							end
						end
						time_count <= 11'b0;
					end
					WAIT:
					begin
						Car_X_Motion <= 11'b0;
						time_count <= time_count + 1;
					end
				endcase		 
				Car_Y_Position <= (Car_Y_Position + Car_Y_Motion);  // Update Car position
				Car_X_Position <= (Car_X_Position + Car_X_Motion);
		end
	end
	
	assign CarX = Car_X_Position;
	assign CarY = Car_Y_Position;
	
	always_comb 
	begin
      next_state = state;
      case (state)
			WAIT: next_state = (time_count == Speed) ? MOVE : WAIT;
			
			MOVE:	next_state = WAIT;
		endcase
	end
    
endmodule