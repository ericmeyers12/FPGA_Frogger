//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --                                          --
//                                                                       --
//    				                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input logic [10:0] 
							  Frog1X, Frog1Y, 
							  Frog2X, Frog2Y,
							  Frog3X, Frog3Y, 
							  DrawX, DrawY, 
							  Frog1_Width, Frog1_Height,
							  Frog2_Width, Frog2_Height,
							  Frog3_Width, Frog3_Height,
							  LPad1_Width, LPad1_Height,
							  input logic [3:0][10:0] Car_Row1_X, Car_Row1_Y,
							  input logic [3:0][10:0] Car_Row2_X, Car_Row2_Y,
							  input logic [3:0][10:0] Car_Row3_X, Car_Row3_Y,  
							  input logic [3:0][10:0] Car_Row4_X, Car_Row4_Y,
							  input logic [3:0][10:0] LPad_Row1_X, LPad_Row1_Y,
							  input logic [3:0][10:0] LPad_Row2_X, LPad_Row2_Y,
							  input logic [3:0][10:0] LPad_Row3_X, LPad_Row3_Y,  
							  input logic [3:0][10:0] LPad_Row4_X, LPad_Row4_Y,   
							  input [2:0] Row1_Number_Cars, Row2_Number_Cars, Row3_Number_Cars, Row4_Number_Cars,
							  input [2:0] Row1_Number_LPads, Row2_Number_LPads, Row3_Number_LPads, Row4_Number_LPads,
							  input [3:0] Car_Collision, LPad_Collision,
							  input up, down, left, right,
							  input [1:0] cur_Frog1_Direction,
							  input [1:0] cur_Frog2_Direction,
							  input [1:0] cur_Frog3_Direction,
							  input win, lose,
							  input [3:0] tens_digit, ones_digit,
							  input [7:0] frog_lives,
							  //input logic [18:0] backgroundIndex,      //for background image
                       output logic [7:0]  Red, Green, Blue );
    
    logic frog1_on, frog2_on, frog3_on, lpad1_on;
	 logic [3:0] car_on1, car_on2, car_on3, car_on4;
	 logic [3:0] lpad_on1, lpad_on2, lpad_on3, lpad_on4;
	 
	 
	 logic [9:0] frog_sprite[0:39][0:39];
	 logic [9:0] frog1_color_idx, frog2_color_idx, frog3_color_idx;
	 logic [10:0] frog1_x_index, frog2_x_index, frog3_x_index;
	 logic [10:0] frog1_y_index, frog2_y_index, frog3_y_index;
	 frog_sprite frog(.rgb(frog_sprite));
	 
	 logic [9:0] logo[0:152][0:39];
	 logo logo_inst(.rgb(logo));
	 
//	 logic [9:0] lose_text_sprite[0:479][0:39];
//	 lose_text_sprite lose_text(.rgb(lose_text_sprite));

	 
	 logic [9:0] lilypad_sprite[0:39][0:39];
	 logic [9:0] lilypad_color_idx;
	 logic [5:0] lilypad_x_index;
	 logic [5:0] lilypad_y_index;
	 logic [10:0] LPad1X, LPad1Y;
	 lilypad_sprite lly(.rgb(lilypad_sprite));

	 logic [9:0] leftcar_sprite[0:79][0:39];
	 logic [9:0] leftcar_color_idx;
	 logic [6:0] leftcar_x_index;
	 logic [5:0] leftcar_y_index;
	 logic [10:0] Car1X, Car1Y;
	 carleft_sprite lc(.rgb(leftcar_sprite));

	 logic [9:0] rightcar_sprite[0:79][0:39];
	 logic [9:0] rightcar_color_idx;
	 logic [6:0] rightcar_x_index;
	 logic [5:0] rightcar_y_index;
	 logic [10:0] Car2X, Car2Y;
	 carright_sprite rc(.rgb(rightcar_sprite));
	 
	 
//	 logic [9:0] background[0:639][0:479];
//	 logic [9:0] background_color_idx;
//	 logic [10:0] background_x_index;
//	 logic [10:0] background_y_index;
//	 basicbackground b(.rgb(background));

	 logic [9:0] cur_color_idx;
	 logic [7:0] color_palette [0:18][0:2];   //correct-frogonly
	 palette game_palette(.palette(color_palette));
	 
	 
 //scoreboard - tens digit and ones digit
	 logic [9:0] numbers_1[0:239][0:31];
 	 logic [9:0] numbers_2[0:239][0:31];
	 logic [9:0] tensdig_color_idx;
	 logic [10:0] tensdig_x_index;
	 logic [10:0] tensdig_y_index;
	 numbers numtens(.rgb(numbers_1));	 

	 logic [9:0] onesdig_color_idx;
	 logic [10:0] onesdig_x_index;
	 logic [10:0] onesdig_y_index;
	 numbers numones(.rgb(numbers_2));	 
	 logic [4:0] num_width, num_height;
	 assign num_width = 5'd24;
	 assign num_height = 5'd32;
	 
	 logic [9:0] numbers_3[0:239][0:31];
	 logic [9:0] lives_color_idx;
	 logic [10:0] lives_x_index;
	 logic [10:0] lives_y_index;
	 numbers froglives(.rgb(numbers_3));
	 
	 
	 
	  	 
/*====== DISPLAY FROGGER ======*/	  
 always_comb
 begin:Frog1_on_proc
	  if (DrawX >= (Frog1X+7) && DrawX <= (Frog1_Width + (Frog1X-7)) &&
			DrawY >= (Frog1Y+10) && DrawY <= (Frog1_Height + Frog1Y-5)) 
			frog1_on = 1'b1;
	  else 
			frog1_on = 1'b0;
  end 
 
 always_comb
 begin:Frog2_on_proc
	  if (DrawX >= (Frog2X+7) && DrawX <= (Frog2_Width + (Frog2X-7)) &&
			DrawY >= (Frog2Y+10) && DrawY <= (Frog2_Height + Frog2Y-5)) 
			frog2_on = 1'b1;
	  else 
			frog2_on = 1'b0;
  end 
	
 always_comb
 begin:Frog3_on_proc
	  if (DrawX >= (Frog3X+7) && DrawX <= (Frog3_Width + (Frog3X-7)) &&
			DrawY >= (Frog3Y+10) && DrawY <= (Frog3_Height + Frog3Y-5)) 
			frog3_on = 1'b1;
	  else 
			frog3_on = 1'b0;
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
	
/*====== DISPLAY CAR_ROW3 =========*/ 
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
	
	
/*====== DISPLAY CAR_ROW4 =========*/ 
	generate 
		genvar i4;
		for (i4 = 0; i4 < 3'd4; i4 = i4 + 1) 
		begin: car_map4
			always_comb 
			begin
				if (i4 < Row4_Number_Cars)
				begin
					if(Car_Row4_X[i4] >= 11'd0 && Car_Row4_X[i4] < 11'd680)
					begin
						if (DrawX >= Car_Row4_X[i4] && DrawX <= (11'd80 + Car_Row4_X[i4]) &&
						DrawY >= Car_Row4_Y[i4] && DrawY <= (11'd40 + Car_Row4_Y[i4]))
							car_on4[i4] = 1'b1;
						else
							car_on4[i4] = 1'b0;
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd80 + Car_Row4_X[i4]) &&
						DrawY >= Car_Row4_Y[i4] && DrawY <= (11'd40 + Car_Row4_Y[i4]))
							car_on4[i4] = 1'b1;
						else
							car_on4[i4] = 1'b0;
					end
				end
				else car_on4[i4] = 1'b0;
			end
		end
	endgenerate

/*====== DISPLAY LPAD_ROW1 =========*/ 
	generate 
		genvar j1;
		for (j1 = 0; j1 < 3'd4; j1 = j1 + 1) 
		begin: lpad_map1
			always_comb 
			begin
				if (j1 < Row1_Number_LPads)
				begin
					if(LPad_Row1_X[j1] >= 11'd0 && LPad_Row1_X[j1] < 11'd680)
					begin
						if (DrawX >= LPad_Row1_X[j1] && DrawX <= (11'd40 + LPad_Row1_X[j1]) &&
						DrawY >= LPad_Row1_Y[j1] && DrawY <= (11'd40 + LPad_Row1_Y[j1]))
						begin
							lpad_on1[j1] = 1'b1;
						end
						else
						begin
							lpad_on1[j1] = 1'b0;
						end
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd40 + LPad_Row1_X[j1]) &&
						DrawY >= LPad_Row1_Y[j1] && DrawY <= (11'd40 + LPad_Row1_Y[j1]))
						begin
							lpad_on1[j1] = 1'b1;
						end
						else
						begin
							lpad_on1[j1] = 1'b0;
						end
					end
				end
				else 
				begin
					lpad_on1[j1] = 1'b0;
				end
			end
		end
	endgenerate
	
/*====== DISPLAY LPAD_ROW2 =========*/ 
	generate 
		genvar j2;
		for (j2 = 0; j2 < 3'd4; j2 = j2 + 1) 
		begin: lpad_map2
			always_comb 
			begin
				if (j2 < Row2_Number_LPads)
				begin
					if(LPad_Row2_X[j2] >= 11'd0 && LPad_Row2_X[j2] < 11'd680)
					begin
						if (DrawX >= LPad_Row2_X[j2] && DrawX <= (11'd40 + LPad_Row2_X[j2]) &&
						DrawY >= LPad_Row2_Y[j2] && DrawY <= (11'd40 + LPad_Row2_Y[j2]))
							lpad_on2[j2] = 1'b1;
						else
							lpad_on2[j2] = 1'b0;
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd40 + LPad_Row2_X[j2]) &&
						DrawY >= LPad_Row2_Y[j2] && DrawY <= (11'd40 + LPad_Row2_Y[j2]))
							lpad_on2[j2] = 1'b1;
						else
							lpad_on2[j2] = 1'b0;
					end
				end
				else lpad_on2[j2] = 1'b0;
			end
		end
	endgenerate
	
/*====== DISPLAY LPAD_ROW3 =========*/ 
	generate 
		genvar j3;
		for (j3 = 0; j3 < 3'd4; j3 = j3 + 1) 
		begin: lpad_map3
			always_comb 
			begin
				if (j3 < Row3_Number_LPads)
				begin
					if(LPad_Row3_X[j3] >= 11'd0 && LPad_Row3_X[j3] < 11'd680)
					begin
						if (DrawX >= LPad_Row3_X[j3] && DrawX <= (11'd40 + LPad_Row3_X[j3]) &&
						DrawY >= LPad_Row3_Y[j3] && DrawY <= (11'd40 + LPad_Row3_Y[j3]))
							lpad_on3[j3] = 1'b1;
						else
							lpad_on3[j3] = 1'b0;
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd40 + LPad_Row3_X[j3]) &&
						DrawY >= LPad_Row3_Y[j3] && DrawY <= (11'd40 + LPad_Row3_Y[j3]))
							lpad_on3[j3] = 1'b1;
						else
							lpad_on3[j3] = 1'b0;
					end
				end
				else lpad_on3[j3] = 1'b0;
			end
		end
	endgenerate
	
	
/*====== DISPLAY LPAD_ROW4 =========*/ 
	generate 
		genvar j4;
		for (j4 = 0; j4 < 3'd4; j4 = j4 + 1) 
		begin: lpad_map4
			always_comb 
			begin
				if (j4 < Row4_Number_LPads)
				begin
					if(LPad_Row4_X[j4] >= 11'd0 && LPad_Row4_X[j4] < 11'd680)
					begin
						if (DrawX >= LPad_Row4_X[j4] && DrawX <= (11'd40 + LPad_Row4_X[j4]) &&
						DrawY >= LPad_Row4_Y[j4] && DrawY <= (11'd40 + LPad_Row4_Y[j4]))
							lpad_on4[j4] = 1'b1;
						else
							lpad_on4[j4] = 1'b0;
					end
					else
					begin
						if (DrawX >= 11'd0 && DrawX <= (11'd40 + LPad_Row4_X[j4]) &&
						DrawY >= LPad_Row4_Y[j4] && DrawY <= (11'd40 + LPad_Row4_Y[j4]))
							lpad_on4[j4] = 1'b1;
						else
							lpad_on4[j4] = 1'b0;
					end
				end
				else lpad_on4[j4] = 1'b0;
			end
		end
	endgenerate





/*======= MAPPING COLOR INDEX FOR FROGGER ======*/	
//setting indexes for Frog	
assign frog1_x_index = DrawX - Frog1X;
assign frog1_y_index = DrawY - Frog1Y;

assign frog2_x_index = DrawX - Frog2X;
assign frog2_y_index = DrawY - Frog2Y;

assign frog3_x_index = DrawX - Frog3X;
assign frog3_y_index = DrawY - Frog3Y;


always_comb
begin
if (cur_Frog1_Direction == 2'b00)     //up
	frog1_color_idx = frog_sprite[frog1_x_index][frog1_y_index];
else if (cur_Frog1_Direction == 2'b01) //down
	frog1_color_idx = frog_sprite[Frog1_Width-frog1_x_index][Frog1_Height-frog1_y_index];
else if (cur_Frog1_Direction == 2'b10) //right
	frog1_color_idx = frog_sprite[Frog1_Height-frog1_y_index][Frog1_Width-frog1_x_index];
else if (cur_Frog1_Direction == 2'b11) //left
	frog1_color_idx = frog_sprite[frog1_y_index][frog1_x_index];

else 
	frog1_color_idx = frog_sprite[frog1_x_index][frog1_y_index];
end

always_comb
begin
if (cur_Frog2_Direction == 2'b00)     //up
	frog2_color_idx = frog_sprite[frog2_x_index][frog2_y_index];
else if (cur_Frog2_Direction == 2'b01) //down
	frog2_color_idx = frog_sprite[Frog2_Width-frog2_x_index][Frog2_Height-frog2_y_index];
else if (cur_Frog2_Direction == 2'b10) //right
	frog2_color_idx = frog_sprite[Frog2_Height-frog2_y_index][Frog2_Width-frog2_x_index];
else if (cur_Frog2_Direction == 2'b11) //left
	frog2_color_idx = frog_sprite[frog2_y_index][frog2_x_index];

else 
	frog2_color_idx = frog_sprite[frog2_x_index][frog2_y_index];
end


always_comb
begin
if (cur_Frog3_Direction == 2'b00)     //up
	frog3_color_idx = frog_sprite[frog3_x_index][frog3_y_index];
else if (cur_Frog3_Direction == 2'b01) //down
	frog3_color_idx = frog_sprite[Frog3_Width-frog3_x_index][Frog3_Height-frog3_y_index];
else if (cur_Frog3_Direction == 2'b10) //right
	frog3_color_idx = frog_sprite[Frog3_Height-frog3_y_index][Frog3_Width-frog3_x_index];
else if (cur_Frog3_Direction == 2'b11) //left
	frog3_color_idx = frog_sprite[frog3_y_index][frog3_x_index];

else 
	frog3_color_idx = frog_sprite[frog3_x_index][frog3_y_index];
end

/*======= MAPPING COLOR INDEX FOR CARS ======*/

always_comb
begin
//cars row 1
	if (car_on1[0] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row1_X[0];
		Car2Y = Car_Row1_Y[0];
	end
	else if (car_on1[1] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row1_X[1];
		Car2Y = Car_Row1_Y[1];
	end	
	else if (car_on1[2] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row1_X[2];
		Car2Y = Car_Row1_Y[2];
	end	
	else if (car_on1[3] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row1_X[3];
		Car2Y = Car_Row1_Y[3];
	end	
//cars row 2
	else if (car_on2[0] == 1'b1)
	begin
		Car2X = 11'b0;
		Car2Y = 11'b0;
		Car1X = Car_Row2_X[0];
		Car1Y = Car_Row2_Y[0];
	end	
	else if (car_on2[1] == 1'b1)
	begin
		Car2X = 11'b0;
		Car2Y = 11'b0;
		Car1X = Car_Row2_X[1];
		Car1Y = Car_Row2_Y[1];
	end	
	else if (car_on2[2] == 1'b1)
	begin
		Car2X = 11'b0;
		Car2Y = 11'b0;
		Car1X = Car_Row2_X[2];
		Car1Y = Car_Row2_Y[2];
	end	
	else if (car_on2[3] == 1'b1)
	begin
		Car2X = 11'b0;
		Car2Y = 11'b0;
		Car1X = Car_Row2_X[3];
		Car1Y = Car_Row2_Y[3];
	end	
//lilypads row 3
	else if (car_on3[0] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row3_X[0];
		Car2Y = Car_Row3_Y[0];
	end	
	else if (car_on3[1] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row3_X[1];
		Car2Y = Car_Row3_Y[1];
	end	
	else if (car_on3[2] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row3_X[2];
		Car2Y = Car_Row3_Y[2];
	end	
	else if (car_on3[3] == 1'b1)
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = Car_Row3_X[3];
		Car2Y = Car_Row3_Y[3];
	end	
//lilypads row 4
	else if (car_on4[0] == 1'b1)
	begin
		Car1X = Car_Row4_X[0];
		Car1Y = Car_Row4_Y[0];
		Car2X = 11'b0;
		Car2Y = 11'b0;
	end	
	else if (car_on4[1] == 1'b1)
	begin
		Car1X = Car_Row4_X[1];
		Car1Y = Car_Row4_Y[1];
		Car2X = 11'b0;
		Car2Y = 11'b0;
	end	
	else if (car_on4[2] == 1'b1)
	begin
		Car1X = Car_Row4_X[2];
		Car1Y = Car_Row4_Y[2];
		Car2X = 11'b0;
		Car2Y = 11'b0;
	end	
	else if (car_on4[3] == 1'b1)
	begin
		Car1X = Car_Row4_X[3];
		Car1Y = Car_Row4_Y[3];
		Car2X = 11'b0;
		Car2Y = 11'b0;
	end	
//outside cases
	else 
	begin
		Car1X = 11'b0;
		Car1Y = 11'b0;
		Car2X = 11'b0;
		Car2Y = 11'b0;
	end
end

assign leftcar_x_index = DrawX - Car1X;
assign leftcar_y_index = DrawY - Car1Y;
assign rightcar_x_index = DrawX - Car2X;
assign rightcar_y_index = DrawY - Car2Y;

always_comb
begin
	leftcar_color_idx = leftcar_sprite[leftcar_x_index][leftcar_y_index];
	rightcar_color_idx = rightcar_sprite[rightcar_x_index][rightcar_y_index];
end



/*======= MAPPING COLOR INDEX FOR LILYPADS ======*/
always_comb
begin
//lilypads row 1
	if (lpad_on1[0] == 1'b1)
	begin
		LPad1X = LPad_Row1_X[0];
		LPad1Y = LPad_Row1_Y[0];
	end
	else if (lpad_on1[1] == 1'b1)
	begin
		LPad1X = LPad_Row1_X[1];
		LPad1Y = LPad_Row1_Y[1];
	end	
	else if (lpad_on1[2] == 1'b1)
	begin
		LPad1X = LPad_Row1_X[2];
		LPad1Y = LPad_Row1_Y[2];
	end	
	else if (lpad_on1[3] == 1'b1)
	begin
		LPad1X = LPad_Row1_X[3];
		LPad1Y = LPad_Row1_Y[3];
	end	
//lilypads row 2
	else if (lpad_on2[0] == 1'b1)
	begin
		LPad1X = LPad_Row2_X[0];
		LPad1Y = LPad_Row2_Y[0];
	end	
	else if (lpad_on2[1] == 1'b1)
	begin
		LPad1X = LPad_Row2_X[1];
		LPad1Y = LPad_Row2_Y[1];
	end	
	else if (lpad_on2[2] == 1'b1)
	begin
		LPad1X = LPad_Row2_X[2];
		LPad1Y = LPad_Row2_Y[2];
	end	
	else if (lpad_on2[3] == 1'b1)
	begin
		LPad1X = LPad_Row2_X[3];
		LPad1Y = LPad_Row2_Y[3];
	end	
//lilypads row 3
	else if (lpad_on3[0] == 1'b1)
	begin
		LPad1X = LPad_Row3_X[0];
		LPad1Y = LPad_Row3_Y[0];
	end	
	else if (lpad_on3[1] == 1'b1)
	begin
		LPad1X = LPad_Row3_X[1];
		LPad1Y = LPad_Row3_Y[1];
	end	
	else if (lpad_on3[2] == 1'b1)
	begin
		LPad1X = LPad_Row3_X[2];
		LPad1Y = LPad_Row3_Y[2];
	end	
	else if (lpad_on3[3] == 1'b1)
	begin
		LPad1X = LPad_Row3_X[3];
		LPad1Y = LPad_Row3_Y[3];
	end	
//lilypads row 4
	else if (lpad_on4[0] == 1'b1)
	begin
		LPad1X = LPad_Row4_X[0];
		LPad1Y = LPad_Row4_Y[0];
	end	
	else if (lpad_on4[1] == 1'b1)
	begin
		LPad1X = LPad_Row4_X[1];
		LPad1Y = LPad_Row4_Y[1];
	end	
	else if (lpad_on4[2] == 1'b1)
	begin
		LPad1X = LPad_Row4_X[2];
		LPad1Y = LPad_Row4_Y[2];
	end	
	else if (lpad_on4[3] == 1'b1)
	begin
		LPad1X = LPad_Row4_X[3];
		LPad1Y = LPad_Row4_Y[3];
	end	
//outside cases
	else 
	begin
		LPad1X = 11'b0;
		LPad1Y = 11'b0;
	end
end

assign lilypad_x_index = DrawX - LPad1X;
assign lilypad_y_index = DrawY - LPad1Y;

always_comb
begin
	lilypad_color_idx = lilypad_sprite[lilypad_x_index][lilypad_y_index];
end

/*======= MAPPING COLOR INDEX FOR SCORECLOCK/LIVES ======*/
	assign tensdig_x_index = DrawX - 9'd315 + (num_width * tens_digit);
	assign tensdig_y_index = DrawY - 3'd4;
	assign onesdig_x_index = DrawX - 9'd339 + (num_width * ones_digit);
	assign onesdig_y_index = DrawY - 3'd4;
	assign lives_x_index = DrawX - 10'd575 + (num_width * frog_lives[4:0]);
	assign lives_y_index = DrawY - 10'd4;

	always_comb
	begin
		tensdig_color_idx = numbers_1[tensdig_x_index][tensdig_y_index];
		onesdig_color_idx = numbers_2[onesdig_x_index][onesdig_y_index];
		lives_color_idx = numbers_3[lives_x_index][lives_y_index];
  	end

	
	
	

/*======= UPDATE VGA DISPLAY ======*/	 
 always_comb
 begin:RGB_Display
	  if ((frog1_on == 1'b1) && frog1_color_idx!=0) //FROG ON
	  begin 
			Red = color_palette[frog1_color_idx][0];
			Green = color_palette[frog1_color_idx][1];
			Blue = color_palette[frog1_color_idx][2];
	  end
	  else
	  if ((frog2_on == 1'b1) && frog2_color_idx!=0) //FROG ON
	  begin 
			Red = color_palette[frog2_color_idx][0];
			Green = color_palette[frog2_color_idx][1];
			Blue = color_palette[frog2_color_idx][2];
	  end
	  else
	  if ((frog3_on == 1'b1) && frog3_color_idx!=0) //FROG ON
	  begin 
			Red = color_palette[frog3_color_idx][0];
			Green = color_palette[frog3_color_idx][1];
			Blue = color_palette[frog3_color_idx][2];
	  end
	  else
	  //CARROW #1 ON
	  if ((car_on1[0] == 1'b1 || car_on1[1] == 1'b1 || car_on1[2] == 1'b1 || car_on1[3] == 1'b1) && rightcar_color_idx!=0)
	  begin
			Red = color_palette[rightcar_color_idx][0];
			Green = color_palette[rightcar_color_idx][1];
			Blue = color_palette[rightcar_color_idx][2];
	  end	
	  else //CARROW #2 ON
	  if ((car_on2[0] == 1'b1 || car_on2[1] == 1'b1 || car_on2[2] == 1'b1 || car_on2[3] == 1'b1) && leftcar_color_idx!=0)
	  begin
			Red = color_palette[leftcar_color_idx][0];
			Green = color_palette[leftcar_color_idx][1];
			Blue = color_palette[leftcar_color_idx][2];
	  end
	  else //CARROW #3 ON
	  if ((car_on3[0] == 1'b1 || car_on3[1] == 1'b1 || car_on3[2] == 1'b1 || car_on3[3] == 1'b1) && rightcar_color_idx!=0)
	  begin
			Red = color_palette[rightcar_color_idx][0];
			Green = color_palette[rightcar_color_idx][1];
			Blue = color_palette[rightcar_color_idx][2];
	  end	
	  else //CARROW #4 ON
	  if ((car_on4[0] == 1'b1 || car_on4[1] == 1'b1 || car_on4[2] == 1'b1 || car_on4[3] == 1'b1) && leftcar_color_idx!=0)
	  begin
			Red = color_palette[leftcar_color_idx][0];
			Green = color_palette[leftcar_color_idx][1];
			Blue = color_palette[leftcar_color_idx][2];
	  end

	  else //ANY LILYPAD ON - Should all be same color
	  if ((lpad_on1[0] == 1'b1 || lpad_on1[1] == 1'b1 ||  lpad_on1[2] == 1'b1 ||  lpad_on1[3] == 1'b1 ||
				  lpad_on2[0] == 1'b1 || lpad_on2[1] == 1'b1 ||  lpad_on2[2] == 1'b1 ||  lpad_on2[3] == 1'b1 ||
				  lpad_on3[0] == 1'b1 || lpad_on3[1] == 1'b1 ||  lpad_on3[2] == 1'b1 ||  lpad_on3[3] == 1'b1 ||
				  lpad_on4[0] == 1'b1 || lpad_on4[1] == 1'b1 ||  lpad_on4[2] == 1'b1 ||  lpad_on4[3] == 1'b1) && lilypad_color_idx!=0)
	  begin
//	   if (lilypad_color_idx!=0)
//		 begin
			Red = 8'd0;
			Green = 8'd250;
			Blue = 8'd0;
//			Red = color_palette[lilypad_color_idx][0];
//			Green = color_palette[lilypad_color_idx][1];
//			Blue = color_palette[lilypad_color_idx][2];
//		 end
//		else
//		 begin
//			Red = 8'd0;
//			Green = 8'd200;
//			Blue = 8'd255;
//		end
	  end
	  else //SHOW APPROPRIATE BACKGROUND 
	  begin 
			//scoreboard		
			if ((DrawY >= 4 && DrawY <= 36) && (DrawX >= 315 && DrawX <= 339))
			begin
				Red = color_palette[tensdig_color_idx][0];
				Green = color_palette[tensdig_color_idx][1];
				Blue = color_palette[tensdig_color_idx][2];
			end
			else if ((DrawY >= 4 && DrawY <= 36) && (DrawX >= 339 && DrawX <= 362))
			begin
				Red = color_palette[onesdig_color_idx][0];
				Green = color_palette[onesdig_color_idx][1];
				Blue = color_palette[onesdig_color_idx][2];
			end
			else if ((DrawY >= 4 && DrawY <= 36) && (DrawX >= 575 && DrawX <= 599))
			begin
				Red = color_palette[lives_color_idx][0];
				Green = color_palette[lives_color_idx][1];
				Blue = color_palette[lives_color_idx][2];
			end

			//water color
			else if (DrawY >= 80 && DrawY <= 239 )
			begin
				Red = 8'd0;
				Green = 8'd200;
				Blue = 8'd255;
			end
			//dark grass color
			else if ((DrawY >= 40 && DrawY <= 79) && ((DrawX >= 0 && DrawX <= 119) || (DrawX >= 160 && DrawX <= 279) || (DrawX >= 320 && DrawX <= 479) || (DrawX >= 520 && DrawX <= 679))) 
			begin
				Red = 8'd0;
				Green = 8'd100; 
				Blue = 8'd0;	
			end
			//grass color
			else if ((DrawY >= 240 && DrawY <= 279) || 
				(DrawY >= 440) || 
				((DrawY >= 40 && DrawY <= 79) && ((DrawX >= 120 && DrawX <= 159) || (DrawX >= 280 && DrawX <= 319) || (DrawX >= 480 && DrawX <= 519)))) 
			begin
				Red = 8'd0;
				Green = 8'd200; 
				Blue = 8'd0;	
			end
			//construction yellow
			else if (((DrawY >= 318 && DrawY <= 322) || (DrawY >= 358 && DrawY <= 362) || (DrawY >= 398 && DrawY <= 402))  && 
				((DrawX >= 0 && DrawX <= 100) || (DrawX >= 200 && DrawX <= 300) || (DrawX >= 400 && DrawX <= 500) || (DrawX >= 600)))
			begin
				Red = 8'd255;
				Green = 8'd204;
				Blue = 8'd0;
			end
			//pavement color
			else if (DrawY >= 280 && DrawY <= 439)
			begin
				Red = 8'd69;
				Green = 8'd69;
				Blue = 8'd69;
			end
			else if (DrawX >= 0 && DrawX <=152 && DrawY >= 0 && DrawY <=39 && logo[DrawX][DrawY] != 0)
			begin
				Red = color_palette[logo[DrawX][DrawY]][0];
				Green = color_palette[logo[DrawX][DrawY]][1];
				Blue = color_palette[logo[DrawX][DrawY]][2];
			end
			else
			begin
				Red = 255;
				Blue = 255;
				Green = 255;
			end
	  end 	     
 end 
    
endmodule