module gamestate(input logic clk, Reset, space,
                 input logic [3:0][12:0] pipeX, pipeWidth, pipeGapSize, pipeGapLocation, 
                 input logic [9:0]       BirdX, BirdY, Bird_size,
                 output logic            gameOn, ded,
					       output logic [7:0]      score);

   enum                                  logic [3:0] {GAME_OFF, GAME_ON, GAME_LOST} state, next_state;
	 
	 

   always_ff @ (posedge clk, posedge Reset) begin
      if (Reset) begin
         state <= GAME_OFF;
         score <= 8'b0;
      end
      else begin
         state <= next_state;

         if (pipeScores[0] == 1'b1 || pipeScores[1] == 1'b1 || pipeScores[2] == 1'b1 || pipeScores[3] == 1'b1) begin
            // Don't let first digit over 9 to keep things decimal
            if (score[3:0] >= 9) begin
               score[3:0] = 4'b0;
               
               // Don't let second digit over 9
               if (score[7:4] < 9) 
                 score[7:4] = score[7:4] + 1'b1;
            end
            else begin
               score[3:0] = score[3:0] + 1'b1;
            end
         end
      end
   end
   
	 logic [3:0] pipeCollisions;
   logic [3:0] pipeScores;
   generate
      genvar   i;
      for (i = 0; i < 4; i = i+1) begin: pipe_detect_i
         always_comb begin
				    pipeCollisions[i] = 1'b0;
            if (GAME_ON) begin
               if ( // Right edge of the bird is within the x range
                    ((BirdX + Bird_size) <= (pipeX[i] + pipeWidth[i]) && (BirdX+Bird_size) >= (pipeX[i] - pipeWidth[i])) &&
                    // and Bird is NOT within the gap, it must be touching and therefore DED
                    // low                                                                  high
                    ((BirdY + Bird_size) > (pipeGapLocation[i] + pipeGapSize[i]) || (BirdY - Bird_size) < (pipeGapLocation[i] - pipeGapSize[i])))
                 pipeCollisions[i] = 1'b1;

               // When the left side of the bird passes the right side of the pipe, up the score
               if ((BirdX - Bird_size) == (pipeX[i] + pipeWidth[i])) begin
                  pipeScores[i] = 1'b1;
               end else begin
                  pipeScores[i] = 1'b0;
               end
            end
         end // always_comb
      end
   endgenerate

   always_comb begin
      next_state = state;
      gameOn = 1'b0;
		  ded = 1'b0;

      case(state)
			  GAME_OFF: begin
				   if (space)
					   next_state = GAME_ON;
			  end
			  
        GAME_ON: begin
				   if (pipeCollisions[0] || pipeCollisions[1] || pipeCollisions[2] || pipeCollisions[3] || (BirdY + Bird_size) >= 479) begin
					    gameOn = 1'b0;
					    ded = 1'b1;
					    next_state = GAME_LOST;
				   end else
					   gameOn = 1'b1;
			  end
			  
			  GAME_LOST: begin
				   ded = 1'b1;
			  end
      endcase // case (state)
	 end
   
endmodule
