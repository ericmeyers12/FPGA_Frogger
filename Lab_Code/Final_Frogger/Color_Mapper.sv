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


module  color_mapper ( input logic [10:0] FrogX, FrogY, DrawX, DrawY, 
														Frog_Width, Frog_Height,
														Car1X, Car1Y, Car1_Width, Car1_Height,
														Car2X, Car2Y, Car2_Width, Car2_Height,
														Car3X, Car3Y, Car3_Width, Car3_Height,
														LPad1X, LPad1Y, LPad1_Width, LPad1_Height,
                       output logic [7:0]  Red, Green, Blue );
    
    logic frog_on, car1_on, car2_on, car3_on, lpad1_on;

	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	 
/*====== DISPLAY FROGGER ======*/	  
 always_comb
 begin:Frog_on_proc
	  if (DrawX >= FrogX && DrawX <= (Frog_Width + FrogX) &&
			DrawY >= FrogY && DrawY <= (Frog_Height + FrogY)) 
			frog_on = 1'b1;
	  else 
			frog_on = 1'b0;
  end 
	 

/*====== DISPLAY CAR1 =========*/ 
always_comb
begin:Car1_on_proc
		if(Car1X >= 11'd0 && Car1X < 11'd680)
		begin
			if (DrawX >= Car1X && DrawX <= (Car1_Width + Car1X) &&
			DrawY >= Car1Y && DrawY <= (Car1_Height+Car1Y))
				car1_on = 1'b1;
			else
				car1_on = 1'b0;
		end
		else
		begin
			if (DrawX >= 11'd0 && DrawX <= (Car1_Width + Car1X) &&
			DrawY >= Car1Y && DrawY <= (Car1_Height+Car1Y))
				car1_on = 1'b1;
			else
				car1_on = 1'b0;
		end
end

/*======= DISPLAY CAR2 ========*/
always_comb
begin:Car2_on_proc
		if(Car2X >= 11'd0 && Car2X < (11'd680))
		begin
			if (DrawX >= Car2X && DrawX <= (Car2_Width + Car2X) &&
			DrawY >= Car2Y && DrawY <= (Car2_Height+Car2Y))
				car2_on = 1'b1;
			else
				car2_on = 1'b0;
		end
		else 
		begin
			if (DrawX >= 0 && DrawX <= (Car2_Width + Car2X) &&
			DrawY >= Car2Y && DrawY <= (Car2_Height+Car2Y))
				car2_on = 1'b1;
			else
				car2_on = 1'b0;
		end
end

/*======= DISPLAY CAR3 ========*/
always_comb
begin:Car3_on_proc
		if(Car3X >= 11'd0 && Car3X < (11'd680))
		begin
			if (DrawX >= Car3X && DrawX <= (Car3_Width + Car3X) &&
			DrawY >= Car3Y && DrawY <= (Car3_Height+Car3Y))
				car3_on = 1'b1;
			else
				car3_on = 1'b0;
		end
		else 
		begin
			if (DrawX >= 0 && DrawX <= (Car3_Width + Car3X) &&
			DrawY >= Car3Y && DrawY <= (Car3_Height+Car3Y))
				car3_on = 1'b1;
			else
				car3_on = 1'b0;
		end
end

/*======= DISPLAY LILYPAD1 ========*/
always_comb
begin:LPad1_on_proc
		if(LPad1X >= 11'd0 && LPad1X < (11'd680))
		begin
			if (DrawX >= LPad1X && DrawX <= (LPad1_Width + LPad1X) &&
			DrawY >= LPad1Y && DrawY <= (LPad1_Height + LPad1Y))
				lpad1_on = 1'b1;
			else
				lpad1_on = 1'b0;
		end
		else 
		begin
			if (DrawX >= 0 && DrawX <= (LPad1_Width + LPad1X) &&
			DrawY >= LPad1Y && DrawY <= (LPad1_Height+LPad1Y))
				lpad1_on = 1'b1;
			else
				lpad1_on = 1'b0;
		end
end

/*======= UPDATE VGA DISPLAY ======*/	 
 always_comb
 begin:RGB_Display
	  if ((frog_on == 1'b1)) 		//FROG ON
	  begin 
			Red = 8'd38;
			Green = 8'd252;
			Blue = 8'd73;
	  end       
	  else if (car1_on == 1'b1)	//CAR #1 ON
	  begin
			Red = 8'd60;
			Green = 8'd130;
			Blue = 8'd80;
	  end
	  else if (car2_on == 1'b1)	//CAR #2 ON
	  begin
			Red = 8'd130;
			Green = 8'd30;
			Blue = 8'd90;
	  end
	  else if (car3_on == 1'b1)	//CAR #3 ON
	  begin
			Red = 8'd240;
			Green = 8'd280;
			Blue = 8'd20;
	  end
	  else if (lpad1_on == 1'b1)	//LILYPAD ON
	  begin
			Red = 8'd0;
			Green = 8'd256;
			Blue = 8'd256;
	  end
	  else //SHOW BACKGROUND
	  begin 
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
	  end      
 end 
    
endmodule
