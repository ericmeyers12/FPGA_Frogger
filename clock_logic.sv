//-------------------------------------------------------------------------
//    game_clock.sv                                                            --
//    Does the thing with the thing with the game and the thing with the clock.\                                                       --
//                                                       --
//-------------------------------------------------------------------------


module  clock_logic ( input game_restart, 						//push button that signals restart the game
									frame_clk,
							output logic [7:0] clock_time,
							input lose_game, win_game
						 );
				 
	enum		logic [2:0] {WAIT, DECREMENT} state, next_state;
	
	logic [7:0] cycles_count;
	parameter [7:0] Time_Seconds_Tolerance=8'd65;       // Leftmost point on the X axis


	always_ff @ (posedge game_restart or posedge frame_clk)
	begin
		if (game_restart)  // Asynchronous Reset
		begin 
			clock_time = 8'd60;
			state = WAIT;
		end
		else
		begin
			state <= next_state;
			case(state)	
				WAIT:
				begin
					cycles_count <= cycles_count + 1;
				end

				DECREMENT:
				begin
					cycles_count = 0;
					clock_time <= clock_time - 1;
				end
			endcase
		end

end
		 
	always_comb 
	begin
      next_state = state;
		if (game_restart == 1'd1) 
			next_state = WAIT;
		else
		begin
			case (state)
				WAIT: 
				begin
					if (cycles_count == Time_Seconds_Tolerance && !lose_game && !win_game)
						next_state = DECREMENT;
					else
						next_state = WAIT;
				end
			
				DECREMENT: next_state = WAIT;
			endcase
		end
	end
endmodule