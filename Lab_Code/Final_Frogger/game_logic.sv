//-------------------------------------------------------------------------
//    game_clock.sv                                                            --
//    Does the thing with the thing with the game and the thing with the clock.\                                                       --
//                                                       --
//-------------------------------------------------------------------------


module  game_logic ( input game_restart, 						//push button that signals restart the game
									frame_clk, 
									isDead,								//is the Frog dead?
									isAlive,								//is the Frog safely on the other side?
               output [3:0]  tens_digit, ones_digit,		//10 possible digits
									
				 );
				 
	
	logic [5:0] game_clock;
	logic [1:0] frog_wins;
	parameter [5:0] clock_restart = 6'd60;
	parameter [1:0] frog_wins_restart = 2'd0;
	parameter [1:0] frog_wins_gameover = 2'd3;

				 
	always_comb 
	begin
      next_state = state;
      case (state)
			if (game_restart == 1'd1) next_state = START;
			
			RESTART_OR_NAH: //checks if player wishes to start a new game
					begin
						next_state = RESTART_OR_NAH;
						//will restart if game_restart is true
			end
			
			START: begin
						game_clock <= clock_restart;			//reset clock
						frog_wins <= frog_wins_restart;		//reset wins
						next_state <= CONTINUE;	
						//reset isDead
			end
			
			CONTINUE: 
						next_state = WAIT;
			//reset frog position, isAlive
			
			WAIT: begin
						if (/*something with clock every second*/)
							next_state = INCREMENT_CLK;
						else if (isDead == 1'd1)
							next_state = DEAD;
						else if (isAlive == 1'd1)
							next_state = WIN;
						else
							next_state = WAIT;
			end
			
			//deduct a second from the game clock
			INCREMENT_CLK: begin
						game_clock <= game_clock - 1'd1;
						if (game_clock = 1'd0)
							next_state = DEAD;
						else
							next_state = WAIT;
			end

			
			DEAD: begin
						next_state <= RESTART_OR_NAH;
			end
			
			WIN: begin
						if (frog_wins == frog_wins_gameover)
								next_state = RESTART_OR_NAH;
						else 
								next_state = CONTINUE;
			end
			
			
		endcase
	end
	
	//determining tens_digit and ones_digit
	always_comb 
	begin
			ones_digit = game_clock % 4'd10;
			tens_digit = game_clock / 4'd10;		
	end
	