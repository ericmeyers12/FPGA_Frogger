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
														LPad1X, LPad1Y, LPad1_Width, LPad1_Height,
							  input logic [3:0][10:0] Car_Row1_X, Car_Row1_Y,
							  input logic [3:0][10:0] Car_Row2_X, Car_Row2_Y,
							  input logic [3:0][10:0] Car_Row3_X, Car_Row3_Y,  
							  input [2:0] Row1_Number_Cars, Row2_Number_Cars, Row3_Number_Cars,
							  input [3:0] Car_Collision, LPad_Collision,
                       output logic [7:0]  Red, Green, Blue );
    
    logic frog_on, lpad1_on;
	 logic [3:0] car_on1, car_on2, car_on3;
	 
	 
/*====== DISPLAY FROGGER ======*/	  
 always_comb
 begin:Frog_on_proc
	  if (DrawX >= FrogX && DrawX <= (Frog_Width + FrogX) &&
			DrawY >= FrogY && DrawY <= (Frog_Height + FrogY)) 
			frog_on = 1'b1;
	  else 
			frog_on = 1'b0;
  end 
	 

/*====== DISPLAY CAR_ROW1 =========*/ 
	generate 
		genvar i1;
		for (i1 = 0; i1 < 3'd4; i1 = i1 + 1) 
		begin: car_map1
			always_comb 
			begin
				if (i1 < Row1_Number_Cars)
				begin
					if(Car_Row1_X[i1] >= 11'd0 && Car_Row1_X[i1] < 11'd680)
					begin
						if (DrawX >= Car_Row1_X[i1] && DrawX <= (11'd80 + Car_Row1_X[i1]) &&
						DrawY >= Car_Row1_Y[i1] && DrawY <= (11'd40 + Car_Row1_Y[i1]))
							car_on1[i1] = 1'b1;
						else
							car_on1[i1] = 1'b0;
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd80 + Car_Row1_X[i1]) &&
						DrawY >= Car_Row1_Y[i1] && DrawY <= (11'd40 + Car_Row1_Y[i1]))
							car_on1[i1] = 1'b1;
						else
							car_on1[i1] = 1'b0;
					end
				end
				else car_on1[i1] = 1'b0;
			end
		end
	endgenerate
	
/*====== DISPLAY CAR_ROW2 =========*/ 
	generate 
		genvar i2;
		for (i2 = 0; i2 < 3'd4; i2 = i2 + 1) 
		begin: car_map2
			always_comb 
			begin
				if (i2 < Row2_Number_Cars)
				begin
					if(Car_Row2_X[i2] >= 11'd0 && Car_Row2_X[i2] < 11'd680)
					begin
						if (DrawX >= Car_Row2_X[i2] && DrawX <= (11'd80 + Car_Row2_X[i2]) &&
						DrawY >= Car_Row2_Y[i2] && DrawY <= (11'd40 + Car_Row2_Y[i2]))
							car_on2[i2] = 1'b1;
						else
							car_on2[i2] = 1'b0;
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd80 + Car_Row2_X[i2]) &&
						DrawY >= Car_Row2_Y[i2] && DrawY <= (11'd40 + Car_Row2_Y[i2]))
							car_on2[i2] = 1'b1;
						else
							car_on2[i2] = 1'b0;
					end
				end
				else car_on2[i2] = 1'b0;
			end
		end
	endgenerate
	
/*====== DISPLAY CAR_ROW2 =========*/ 
	generate 
		genvar i3;
		for (i3 = 0; i3 < 3'd4; i3 = i3 + 1) 
		begin: car_map3
			always_comb 
			begin
				if (i3 < Row3_Number_Cars)
				begin
					if(Car_Row3_X[i3] >= 11'd0 && Car_Row3_X[i3] < 11'd680)
					begin
						if (DrawX >= Car_Row3_X[i3] && DrawX <= (11'd80 + Car_Row3_X[i3]) &&
						DrawY >= Car_Row3_Y[i3] && DrawY <= (11'd40 + Car_Row3_Y[i3]))
							car_on3[i3] = 1'b1;
						else
							car_on3[i3] = 1'b0;
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd80 + Car_Row3_X[i3]) &&
						DrawY >= Car_Row3_Y[i3] && DrawY <= (11'd40 + Car_Row3_Y[i3]))
							car_on3[i3] = 1'b1;
						else
							car_on3[i3] = 1'b0;
					end
				end
				else car_on3[i3] = 1'b0;
			end
		end
	endgenerate

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
	  else if (car_on1[0] == 1'b1 || car_on1[1] == 1'b1 || car_on1[2] == 1'b1 || car_on1[3] == 1'b1)	//CARROW #1 ON
	  begin
			Red = 8'd0;
			Green = 8'd150;
			Blue = 8'd250;
	  end
	  else if (car_on2[0] == 1'b1 || car_on2[1] == 1'b1 || car_on2[2] == 1'b1 || car_on2[3] == 1'b1)	//CARROW #2 ON
	  begin
			Red = 8'd150;
			Green = 8'd0;
			Blue = 8'd30;
	  end
	  else if (car_on3[0] == 1'b1 || car_on3[1] == 1'b1 || car_on3[2] == 1'b1 || car_on3[3] == 1'b1)	//CARROW #3 ON
	  begin
			Red = 8'd150;
			Green = 8'd250;
			Blue = 8'd0;
	  end
	  else if (lpad1_on == 1'b1)	//LILYPAD ON
	  begin
			Red = 8'd0;
			Green = 8'd256;
			Blue = 8'd256;
	  end
	  else if (Car_Collision[0] == 1'b1 || Car_Collision[1] == 1'b1 || Car_Collision[2] == 1'b1) //Car_Collision represents each row here
	  begin
			Red = 8'd255;
			Green = 8'd00;
			Blue = 8'd00;
	  end
	  else //SHOW BACKGROUND
	  begin 
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
	  end      
 end 
    
endmodule
