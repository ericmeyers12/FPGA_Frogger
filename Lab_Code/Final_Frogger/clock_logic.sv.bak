//-------------------------------------------------------------------------
//    game_clock.sv                                                            --
//    Does the thing with the thing with the game and the thing with the clock.\                                                       --
//                                                       --
//-------------------------------------------------------------------------


module  game_logic ( input game_restart, 						//push button that signals restart the game
									frame_clk,	
							input [10:0] Frog1_X, Frog1_Y, Frog2_X, Frog2_Y, Frog3_X, Frog3_Y,
							input dead_frog,
							output logic [1:0] frog_lives,	
							output logic win_game,
							output logic lose_game
//              output [3:0] tens_digit, ones_digit		//10 possible digits				
				 );
				 
	enum		logic [2:0] {START, WIN, DEAD, LOSE, WAIT, RESTART} state, next_state;
	
//	logic [6:0] game_clock, clock_cnt;
	logic [1:0] frog_wins;
	
//	parameter [6:0] clock_restart = 6'd60;
//	parameter [1:0] frog_wins_restart = 2'd0;

	always_ff @ (posedge game_restart or posedge frame_clk)
	begin
		if (game_restart)  // Asynchronous Reset
		begin 
			frog_lives = 2'd3;
			win_game = 1'b0;
			lose_game = 1'b0;
			state = START;
		end
		else
		begin
			state <= next_state;
			case(state)
				START:
				begin
					frog_lives = 2'd3;
					win_game = 1'b0;
					lose_game = 1'b0;
				end
				
				WIN:
				begin
					win_game = 1'b1;
					lose_game = 1'b0;
				end
				
				DEAD:
				begin
					win_game = 1'b0;
					lose_game = 1'b0;
					frog_lives <= frog_lives - 1;
				end
				
				LOSE:
				begin
					win_game = 1'b0;
					lose_game = 1'b1;	
				end
				
				WAIT:
				begin
					win_game = 1'b0;
					lose_game= 1'b0;
				end

				RESTART:
				begin
					win_game = 1'b0;
					lose_game= 1'b0;
				end
				
				default:
				begin
					win_game = 1'b0;
					lose_game= 1'b0;
					frog_lives = 2'd3;
				end
			endcase
		end

end
		 
	always_comb 
	begin
      next_state = state;
		if (game_restart == 1'd1) 
			next_state = START;
		else
		begin
			case (state)
				RESTART: next_state = WAIT;
				
				START: next_state = WAIT;	
				
				WAIT: 
				begin
					if (Frog1_Y == 40 && (Frog1_X == 120 || Frog1_X == 280 || Frog1_X ==480)&&
						 Frog2_Y == 40 && (Frog2_X == 120 || Frog2_X == 280 || Frog2_X ==480) &&
						 Frog3_Y == 40 && (Frog3_X == 120 || Frog3_X == 280 || Frog3_X ==480))
						next_state = WIN;
					else if (dead_frog)
						next_state = DEAD;
					else
						next_state = WAIT;
				end
			
				DEAD: 
				begin
					if (frog_lives == 0)
						next_state = LOSE;
					else
						next_state = WAIT;
				end
				
				LOSE:
				begin
					if (game_restart)
						next_state = RESTART;
					else
						next_state = LOSE;
				end
				
				WIN:
				begin
					if (game_restart)
						next_state = RESTART;
					else
						next_state = WIN;
				end
			endcase
		end
	end
endmodule
	
//	//determining tens_digit and ones_digit
//	always_comb 
//	begin
//			ones_digit = game_clock % 4'd10;
//			tens_digit = game_clock / 4'd10;		
//	end
	