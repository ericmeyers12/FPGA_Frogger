//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BirdX, BirdY, DrawX, DrawY, Bird_size,
                       input [3:0][12:0]  pipeX, pipeWidth, pipeGapSize, pipeGapLocation,
                       input [15:0]       backgroundIdx,
                       input flap,
                       input [7:0] score,
                       output logic [7:0] Red, Green, Blue);

    logic bird_on, score_on_1, score_on_0, score_on_00;

 /* Old Bird: Generated square box by checking if the current pixel is within a square of length
    2*Bird_Size, centered at (BirdX, BirdY).  Note that this requires unsigned comparisons.

    if ((DrawX >= BirdX - Bird_size) &&
       (DrawX <= BirdX + Bird_size) &&
       (DrawY >= BirdY - Bird_size) &&
       (DrawY <= BirdY + Bird_size))

     New Bird: Generates (pixelated) circle by using the standard circle formula.  Note that while
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */

    int DistX, DistY, Size;
	 assign DistX = DrawX - BirdX;
    assign DistY = DrawY - BirdY;

   logic [9:0] curColorIdx;
	logic [9:0] birdColorIdx;
	logic [9:0] scoreColorIdx;
   logic [7:0] colorPalette[0:505][0:2];
   palette p(.palette(colorPalette));

   logic [9:0] birdSprite[0:31][0:31];



	logic [9:0] birdSprite2[0:31][0:31];
	bird_sprite2 d(.rgb(birdSprite2));
	
	logic [9:0] fireballSprite[0:31][0:31];
	fireball fb(.rgb(fireballSprite));

   logic [9:0] pipeSprite[0:47][0:379];

   bottom_pipe a(.rgb(pipeSprite));

	logic [9:0] zeroSprite[0:23][0:31];
	logic [9:0] oneSprite[0:23][0:31];
	logic [9:0] twoSprite[0:23][0:31];
	logic [9:0] threeSprite[0:23][0:31];
	logic [9:0] fourSprite[0:23][0:31];
	logic [9:0] fiveSprite[0:23][0:31];
	logic [9:0] sixSprite[0:23][0:31];
	logic [9:0] sevenSprite[0:23][0:31];
	logic [9:0] eightSprite[0:23][0:31];
	logic [9:0] nineSprite[0:23][0:31];

	zero d0(.rgb(zeroSprite));
	one d1(.rgb(oneSprite));
	two d2(.rgb(twoSprite));
	three d3(.rgb(threeSprite));
	four d4(.rgb(fourSprite));
	five d5(.rgb(fiveSprite));
	six d6(.rgb(sixSprite));
	seven d7(.rgb(sevenSprite));
	eight d8(.rgb(eightSprite));
	nine d9(.rgb(nineSprite));

   logic [9:0] birdLeftSide;
   logic [9:0] birdRightSide;
   logic [9:0] birdBottomSide;
   logic [9:0] birdTopSide;
   logic [9:0] negBirdSize;

   assign negBirdSize = ~(Bird_size) + 1;
   assign birdLeftSide = BirdX + negBirdSize;
   assign birdRightSide = BirdX + Bird_size;
   assign birdBottomSide = BirdY + Bird_size;
   assign birdTopSide = BirdY + negBirdSize;

    always_comb
    begin:Bird_on_proc
        if (DrawX >= birdLeftSide && DrawX < birdRightSide && DrawY >= birdTopSide && DrawY < birdBottomSide)
            bird_on = 1'b1;
        else
            bird_on = 1'b0;
     end

	  always_comb
	  begin:Score_on
	  //score_on_1 = 1'b0;
	  //score_on_0 = 1'b0;
      if(score < 10 && DrawX >= 308 && DrawX < 332 && DrawY >= 20 && DrawY <= 52)
        begin
          score_on_00 = 1'b1;
          score_on_0 = 1'b0;
          score_on_1 = 1'b0;
        end
      else
        begin
        score_on_00 = 1'b0;
	  		if (DrawX >= 296 && DrawX < 320 && DrawY >= 20 && DrawY <= 52)
			  score_on_1 = 1'b1;
			else
			  score_on_1 = 1'b0;
			if (DrawX >= 320 && DrawX < 344 && DrawY >= 20 && DrawY <= 52)
			  score_on_0 = 1'b1;
			else
			  score_on_0 = 1'b0;
      end
	  end

	  logic [3:0] bottom_pipe_on, top_pipe_on;
   logic [12:0] pipeXIndex [3:0];
   logic [12:0] pipeYIndex [3:0];

   generate
      genvar    i;

      for (i=0; i<4; i=i+1) begin: rectangle_i_for
	       always_comb
	         begin: rectangle_i
				      top_pipe_on[i] = 1'b0;
				      bottom_pipe_on[i] = 1'b0;

		          if (DrawX > (pipeX[i] - pipeWidth[i])
							    && DrawX < (pipeX[i] + pipeWidth[i])
                  && DrawX >= (pipeWidth[i] + pipeWidth[i])) begin // One full pipe before zero is faded out
                 if (DrawY <= (pipeGapLocation[i]-pipeGapSize[i])) begin
                    top_pipe_on[i] = 1'b1;
                 end else begin
                    top_pipe_on[i] = 1'b0;
                 end

                 if (DrawY >= (pipeGapLocation[i] + pipeGapSize[i])) begin
                    bottom_pipe_on[i] = 1'b1;
                 end else begin
                    bottom_pipe_on[i] = 1'b0;
                 end
	            end // if (DrawX > (pipeX[i] - pipeWidth[i])...

              if (bottom_pipe_on[i]) begin
                 pipeXIndex[i] = DrawX - pipeX[i] - 40;
                 pipeYIndex[i] = DrawY - (pipeGapLocation[i] + pipeGapSize[i]);
              end else begin
                 if (top_pipe_on[i]) begin
                    pipeXIndex[i] = DrawX - pipeX[i] - 40;
                    // Get bottom of image minus how far we have to the top of the screen
                    pipeYIndex[i] = 12'd362 - (DrawY - (pipeGapLocation[i] + pipeGapSize[i]));
                 end
              end
				   end
      end
   endgenerate

   logic [9:0] birdXIndex;
   logic [9:0] birdYIndex;
   assign birdXIndex = DrawX  + ~(birdLeftSide) + 1;
   assign birdYIndex = DrawY + ~(birdTopSide) + 1;
	logic [9:0] scoreXIndex1;
	logic [9:0] scoreXIndex0;
	logic [9:0] scoreXIndex00;
	logic [9:0] scoreYIndex;
	assign scoreXIndex00 = DrawX - 10'd308;
	assign scoreXIndex0 = DrawX - 10'd320;
	assign scoreXIndex1 = DrawX - 10'd296;
	assign scoreYIndex = DrawY - 10'd20;

	logic [3:0] scoreLow, scoreHigh;
	assign scoreLow = score[3:0];
	assign scoreHigh = score[7:4];

   always_comb
     begin:RGB_Display
      curColorIdx = backgroundIdx[9:0];
		scoreColorIdx = 10'd391;
		  if ((BirdY + Bird_size) >= 475)
			 birdColorIdx = fireballSprite[birdXIndex][birdYIndex];
        else if(flap == 1'b1) begin
			 birdColorIdx = birdSprite2[birdXIndex][birdYIndex];
		  end else begin
			 birdColorIdx = birdSprite[birdXIndex][birdYIndex];
		  end
		  
        if (bird_on == 1'b1 && birdColorIdx != 0 && birdColorIdx != 391) begin
			 curColorIdx = birdColorIdx;
        end else begin
           if (bottom_pipe_on[0]) begin
              curColorIdx = pipeSprite[pipeXIndex[0]][pipeYIndex[0]];
           end else if (bottom_pipe_on[1]) begin
              curColorIdx = pipeSprite[pipeXIndex[1]][pipeYIndex[1]];
           end else if (bottom_pipe_on[2]) begin
              curColorIdx = pipeSprite[pipeXIndex[2]][pipeYIndex[2]];
           end else if (bottom_pipe_on[3]) begin
              curColorIdx = pipeSprite[pipeXIndex[3]][pipeYIndex[3]];
           end else
             if (top_pipe_on[0]) begin
                curColorIdx = pipeSprite[pipeXIndex[0]][pipeYIndex[0]];
             end else if (top_pipe_on[1]) begin
                curColorIdx = pipeSprite[pipeXIndex[1]][pipeYIndex[1]];
             end else if (top_pipe_on[2]) begin
                curColorIdx = pipeSprite[pipeXIndex[2]][pipeYIndex[2]];
             end else if (top_pipe_on[3]) begin
                curColorIdx = pipeSprite[pipeXIndex[3]][pipeYIndex[3]];
             end
			  end // else: !if(bird_on == 1'b1)

      if(score_on_00 == 1'b1) begin
        case(scoreLow)
		  4'd0: begin
          scoreColorIdx = zeroSprite[scoreXIndex00][scoreYIndex];
        end
        4'd1: begin
          scoreColorIdx = oneSprite[scoreXIndex00][scoreYIndex];
        end
        4'd2: begin
          scoreColorIdx = twoSprite[scoreXIndex00][scoreYIndex];
        end
        4'd3: begin
          scoreColorIdx = threeSprite[scoreXIndex00][scoreYIndex];
        end
        4'd4: begin
          scoreColorIdx = fourSprite[scoreXIndex00][scoreYIndex];
        end
        4'd5: begin
          scoreColorIdx = fiveSprite[scoreXIndex00][scoreYIndex];
        end
        4'd6: begin
          scoreColorIdx = sixSprite[scoreXIndex00][scoreYIndex];
        end
        4'd7: begin
          scoreColorIdx = sevenSprite[scoreXIndex00][scoreYIndex];
        end
        4'd8: begin
          scoreColorIdx = eightSprite[scoreXIndex00][scoreYIndex];
        end
        4'd9: begin
          scoreColorIdx = nineSprite[scoreXIndex00][scoreYIndex];
        end
        endcase

       if(scoreColorIdx != 391) begin
        curColorIdx = scoreColorIdx;
       end
      end
		else begin

		  if(score_on_1 == 1'b1) begin
		    case(scoreHigh)
				4'd1: begin
				  scoreColorIdx = oneSprite[scoreXIndex1][scoreYIndex];
				end
				4'd2: begin
				  scoreColorIdx = twoSprite[scoreXIndex1][scoreYIndex];
				end
				4'd3: begin
				  scoreColorIdx = threeSprite[scoreXIndex1][scoreYIndex];
				end
				4'd4: begin
				  scoreColorIdx = fourSprite[scoreXIndex1][scoreYIndex];
				end
				4'd5: begin
				  scoreColorIdx = fiveSprite[scoreXIndex1][scoreYIndex];
				end
				4'd6: begin
				  scoreColorIdx = sixSprite[scoreXIndex1][scoreYIndex];
				end
				4'd7: begin
				  scoreColorIdx = sevenSprite[scoreXIndex1][scoreYIndex];
				end
				4'd8: begin
				  scoreColorIdx = eightSprite[scoreXIndex1][scoreYIndex];
				end
				4'd9: begin
				  scoreColorIdx = nineSprite[scoreXIndex1][scoreYIndex];
				end
			  endcase

			 if(scoreColorIdx != 391) begin
				curColorIdx = scoreColorIdx;
			 end
		  end
		  else if(score_on_0 == 1'b1) begin
		    case(scoreLow)
			   0: begin
				  scoreColorIdx = zeroSprite[scoreXIndex0][scoreYIndex];
				end
				1: begin
				  scoreColorIdx = oneSprite[scoreXIndex0][scoreYIndex];
				end
				2: begin
				  scoreColorIdx = twoSprite[scoreXIndex0][scoreYIndex];
				end
				3: begin
				  scoreColorIdx = threeSprite[scoreXIndex0][scoreYIndex];
				end
				4: begin
				  scoreColorIdx = fourSprite[scoreXIndex0][scoreYIndex];
				end
				5: begin
				  scoreColorIdx = fiveSprite[scoreXIndex0][scoreYIndex];
				end
				6: begin
				  scoreColorIdx = sixSprite[scoreXIndex0][scoreYIndex];
				end
				7: begin
				  scoreColorIdx = sevenSprite[scoreXIndex0][scoreYIndex];
				end
				8: begin
				  scoreColorIdx = eightSprite[scoreXIndex0][scoreYIndex];
				end
				9: begin
				  scoreColorIdx = nineSprite[scoreXIndex0][scoreYIndex];
				end
			 endcase

			 if(scoreColorIdx != 391) begin
				curColorIdx = scoreColorIdx;
			 end
		  end
		  end
        if (curColorIdx == 391) begin
          curColorIdx = backgroundIdx[9:0];
        end
		  	Red = colorPalette[curColorIdx][0];
			  Green = colorPalette[curColorIdx][1];
        Blue = colorPalette[curColorIdx][2];
     end

endmodule
