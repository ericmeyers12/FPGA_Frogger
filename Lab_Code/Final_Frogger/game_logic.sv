//-------------------------------------------------------------------------
//    game_clock.sv                                                            --
//    Does the thing with the thing with the game and the thing with the clock.\                                                       --
//                                                       --
//-------------------------------------------------------------------------


module  game_logic ( input game_restart, frame_clk,
               output [3:0]  tens_digit, ones_digit		//10 possible digits
					
				 );
				 
				 
				 
	always_comb 
	begin
      next_state = state;
      case (state)
			RESET: next_state = CLOCK_30;
			
			CLOCK_30: begin
							if (game_restart) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_29: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_28;
			end
			
			CLOCK_28: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_27;
			end
			
			CLOCK_27: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_26;
			end
			
			CLOCK_26: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_25;
			end
			
			CLOCK_25: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			CLOCK_30: begin
							if (game_reset) next_state = RESET;
							else next_state = CLOCK_29;
			end
			
			WAIT: next_state = (game_reset) ? MOVE : WAIT;
			GAMEOVER
			
			MOVE:	next_state = WAIT;
		endcase