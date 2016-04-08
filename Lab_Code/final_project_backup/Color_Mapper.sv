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


module  color_mapper ( 	input [9:0] 			Player1X, Player1Y, Player1W, Player1H, Player1Dir,
															Player2X, Player2Y, Player2W, Player2H, Player2Dir,
															Bullet1X, Bullet1Y, Bullet1W, Bullet1H,
															Bullet2X, Bullet2Y, Bullet2W, Bullet2H,
															Player1Health, Player2Health, 
															Player1Lives, Player2Lives,
															DrawX, DrawY,
															TILE_SIZE, NUM_COLS,
								input [0:191]			map,
								input [1:0]				winner,
								output logic [7:0]  	Red, Green, Blue);

	parameter [9:0] DIR_LEFT = 0, DIR_RIGHT = 1;
	
	parameter [9:0] 	HEALTH1_X = 80, 
							HEALTH2_X = 360,
							HEALTH_Y = 460, 
							HEALTH_H = 10;
	
	parameter [9:0]	LIFE1_X = 10,
							LIFE2_X = 570,
							LIFE_Y = 455,
							LIFE_H = 20;
							
	parameter [9:0]	BANNER_X = 296,
							BANNER_Y = 462,
							BANNER_WIDTH = 48,
							BANNER_HEIGHT = 7;
								
	logic player1_on, player2_on,
			bullet1_on, bullet2_on,
			health1_on, health2_on,
			banner_on,
			life1_on, life2_on,
			map_on;
	
	logic [3:0]		p1_color, p2_color, map_color,
						life1_color, life2_color;
	
	logic [23:0] 	color,BG_COLOR,HUD_COLOR,TEXT_COLOR,
						BULLET_1_COLOR, BULLET_2_COLOR,
						P1_0, P1_1, P1_2, P1_3, P1_4, P1_5, P1_6,
						P2_0, P2_1, P2_2, P2_3, P2_4, P2_5, P2_6,
						G_0, G_1, G_2, G_3;
	 
	assign BG_COLOR	 	= 24'h0099ff;
	assign HUD_COLOR		= 24'h000000;
	assign TEXT_COLOR		= 24'hffffff;
	assign BULLET_1_COLOR = 24'hff0000;
	assign BULLET_2_COLOR = 24'h00ff00;
	
	//	RYAN COLORS
	assign P1_0 			= BG_COLOR;
	assign P1_1 			= 24'he0b000;
	assign P1_2 			= 24'hffc867;
	assign P1_3 			= 24'hffff00;
	assign P1_4 			= 24'h130641;
	assign P1_5 			= 24'h000000;
	assign P1_6 			= 24'hffffff;
	
	//	ERIC COLORS
	
	assign P2_0 			= BG_COLOR;
	assign P2_1 			= 24'h000000;
	assign P2_2 			= 24'hffc867;
	assign P2_3 			= 24'h00c000;
	assign P2_4 			= 24'h130641;
	assign P2_5 			= 24'h000000;
	assign P2_6 			= 24'hffffff;
	
	//	GRASS COLORS
	
	assign G_0				= 24'h558800;
	assign G_1				= 24'h77aa22;
	assign G_2				= 24'h50380d;
	assign G_3				= 24'h795514;
	
	  
	int mapX, mapY, mapIndex,
		 grassX, grassY, grassIndex,
		 p1X, p1Y, p1IndexRight, p1IndexLeft,
		 p2X, p2Y, p2IndexRight, p2IndexLeft,
		 lifeX, lifeY, life1Index, life2Index,
		 bannerX, bannerY, bannerIndex,
		 h1_width, h2_width,
		 life1_width, life2_width;
		 
	assign mapX = DrawX/TILE_SIZE;
	assign mapY = DrawY/TILE_SIZE;
	assign mapIndex = mapX + mapY*NUM_COLS;
	
	assign grassX = ((DrawX%40)/2)*4;
	assign grassY = ((DrawY%40)/2)*4;
	assign grassIndex = grassX + grassY*20;
	
	assign p1X = (DrawX-Player1X)*4;
	assign p1Y = (DrawY-Player1Y)*4;
	assign p1IndexRight = p1X + p1Y*Player1W;
	assign p1IndexLeft = ((4*Player1W)-p1X-4) + p1Y*Player1W;
	
	assign p2X = (DrawX-Player2X)*4;
	assign p2Y = (DrawY-Player2Y)*4;
	assign p2IndexRight = p2X + p2Y*Player2W;
	assign p2IndexLeft = ((4*Player2W)-p2X-4) + p2Y*Player2W;
	
	assign lifeX = ((DrawX+10)%20)*4;
	assign lifeY = ((DrawY+5)%20)*4;
	assign life1Index = lifeX + lifeY*Player1W;
	assign life2Index = ((4*Player2W)-lifeX-4) + lifeY*Player2W;
	
	assign bannerX = (DrawX - BANNER_X);
	assign bannerY = (DrawY - BANNER_Y);
	assign bannerIndex = bannerX + bannerY * 48;
	
	assign h1_width = Player1Health*20;
	assign h2_width = Player2Health*20;
	
	assign life1_width = Player1Lives*20;
	assign life2_width = Player2Lives*20;
	
	
	logic[0:1599] player_sprite, grass_sprite;
	
	logic[0:335] p1_wins, p2_wins;
	
	assign	player_sprite = {	80'h00001111111000000000,
										80'h00011111111100000000,
										80'h00011222222200000000,
										80'h00212652265200000000,
										80'h00222652265200000000,
										80'h00222222222200000000,
										80'h00022555555200000555,
										80'h00332222222333332520,
										80'h03333333333333332200,
										80'h33333333333333330000,
										80'h33333333333330000000,
										80'h33033333333300000000,
										80'h33003333333300000000,
										80'h33003333333300000000,
										80'h22006666556600000000,
										80'h22004444444400000000,
										80'h00044444444400000000,
										80'h00044400044440000000,
										80'h00555500055550000000,
										80'h05555500055555500000
										};
										
	assign	grass_sprite = {	80'h00000000000000000000,
										80'h01111111111111111110,
										80'h01111111111111111110,
										80'h01111111111111111110,
										80'h01111111111111111110,
										80'h01111111111111111110,
										80'h01111111111111111110,
										80'h00000000000000000000,
										80'h22222222222222222222,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h23333333333333333332,
										80'h22222222222222222222};

	assign p1_wins = {	48'b000000000000000000000000000000000000000000000000,
								48'b011111000110000001000100111110010001000111100110,
								48'b010001000010000001000100001000011001001000000110,
								48'b011111000010000001010100001000010101000111000110,
								48'b010000000010000001010100001000010011000000100000,
								48'b010000001111100000101000111110010001001111000110,
								48'b000000000000000000000000000000000000000000000000
							};
										
	assign p2_wins = {	48'b000000000000000000000000000000000000000000000000,
								48'b011111000111000001000100111110010001000111100110,
								48'b010001001000100001000100001000011001001000000110,
								48'b011111000011000001010100001000010101000111000110,
								48'b010000000110000001010100001000010011000000100000,
								48'b010000001111100000101000111110010001001111000110,
								48'b000000000000000000000000000000000000000000000000
							};
	
	
	always_comb 
	begin

		//	CHECK FOR GROUND VS SKY
		map_on = map[mapIndex];
		
		map_color = {	grass_sprite[grassIndex],grass_sprite[grassIndex+1],
							grass_sprite[grassIndex+2],grass_sprite[grassIndex+3]};

		//	CHECK IF ON WIN BANNER
		if ( (DrawX >= BANNER_X && DrawX < BANNER_X+BANNER_WIDTH) && (DrawY >= HEALTH_Y && DrawY < HEALTH_Y+HEALTH_H) )
			banner_on = 1'b1;
		else banner_on = 1'b0;
		
		//	CHECK PLAYER 1 HEALTH
		if ( (DrawX >= HEALTH1_X && DrawX < HEALTH1_X+h1_width) && (DrawY >= HEALTH_Y && DrawY < HEALTH_Y+HEALTH_H) )
			health1_on = 1'b1;
		else health1_on = 1'b0;
		
		//	CHECK PLAYER 2 HEALTH
		if ( (DrawX >= HEALTH2_X && DrawX < HEALTH2_X+h2_width) && (DrawY >= HEALTH_Y && DrawY < HEALTH_Y+HEALTH_H) )
			health2_on = 1'b1;
		else health2_on = 1'b0;
		
		//	CHECK PLAYER 1 LIVES
		if ( (DrawX >= LIFE1_X && DrawX < LIFE1_X+life1_width) && (DrawY >= LIFE_Y && DrawY < LIFE_Y+LIFE_H) )
			life1_on = 1'b1;
		else life1_on = 1'b0;
		
		//	CHECK PLAYER 2 LIVES
		if ( (DrawX >= LIFE2_X && DrawX < LIFE2_X+life2_width) && (DrawY >= LIFE_Y && DrawY < LIFE_Y+LIFE_H) )
			life2_on = 1'b1;
		else life2_on = 1'b0;
		
		//	SET LIFE 1 COLOR
		life1_color = {player_sprite[life1Index],player_sprite[life1Index+1],
							player_sprite[life1Index+2],player_sprite[life1Index+3]};
		
		//	SET LIFE 2 COLOR
		life2_color = {player_sprite[life2Index],player_sprite[life2Index+1],
							player_sprite[life2Index+2],player_sprite[life2Index+3]};

		//	CHECK FOR PLAYER 1
		if(Player1Dir == DIR_RIGHT)
		begin
			p1_color = {player_sprite[p1IndexRight],player_sprite[p1IndexRight+1],
							player_sprite[p1IndexRight+2],player_sprite[p1IndexRight+3]};
		
			if ( p1_color != 4'h0 && (DrawX >= Player1X && DrawX < Player1X+Player1W) && (DrawY >= Player1Y && DrawY < Player1Y+Player1H) )
				player1_on = 1'b1;
			else player1_on = 1'b0;
		end
		else
		begin
			p1_color = {player_sprite[p1IndexLeft],player_sprite[p1IndexLeft+1],
							player_sprite[p1IndexLeft+2],player_sprite[p1IndexLeft+3]};
							
			if ( p1_color != 4'h0 && (DrawX >= Player1X && DrawX < Player1X+Player1W) && (DrawY >= Player1Y && DrawY < Player1Y+Player1H) )
				player1_on = 1'b1;
			else player1_on = 1'b0;
		end
		
		//	CHECK PLAYER 2
		if ( (DrawX >= Player2X && DrawX < Player2X+Player2W) && (DrawY >= Player2Y && DrawY < Player2Y+Player2H) )
			player2_on = 1'b1;
		else player2_on = 1'b0;
							
		if(Player2Dir == DIR_RIGHT)
			p2_color = {player_sprite[p2IndexRight],player_sprite[p2IndexRight+1],
							player_sprite[p2IndexRight+2],player_sprite[p2IndexRight+3]};
		else
			p2_color = {player_sprite[p2IndexLeft],player_sprite[p2IndexLeft+1],
							player_sprite[p2IndexLeft+2],player_sprite[p2IndexLeft+3]};
			
		//	CHECK FOR BULLET 1
		if ( (DrawX >= Bullet1X && DrawX < Bullet1X+Bullet1W) && (DrawY >= Bullet1Y && DrawY < Bullet1Y+Bullet1H) )
			bullet1_on = 1'b1;
		else bullet1_on = 1'b0;
		
		//	CHECK FOR BULLET 2
		if ( (DrawX >= Bullet2X && DrawX < Bullet2X+Bullet2W) && (DrawY >= Bullet2Y && DrawY < Bullet2Y+Bullet2H) )
			bullet2_on = 1'b1;
		else bullet2_on = 1'b0;
			
	end 
	 
	always_comb begin:RGB_Display
		if ((player1_on == 1'b1))
		begin
			if(p1_color == 4'h1)
				color = P1_1;
			else if(p1_color == 4'h2)
				color = P1_2;
			else if(p1_color == 4'h3)
				color = P1_3;
			else if(p1_color == 4'h4)
				color = P1_4;
			else if(p1_color == 4'h5)
				color = P1_5;
			else if(p1_color == 4'h6)
				color = P1_6;
			else color = P1_0;
		end
		else if ((player2_on == 1'b1))
		begin
			if(p2_color == 4'h1)
				color = P2_1;
			else if(p2_color == 4'h2)
				color = P2_2;
			else if(p2_color == 4'h3)
				color = P2_3;
			else if(p2_color == 4'h4)
				color = P2_4;
			else if(p2_color == 4'h5)
				color = P2_5;
			else if(p2_color == 4'h6)
				color = P2_6;
			else color = P2_0;
		end
		else if ((life1_on == 1'b1))
		begin
			if(life1_color == 4'h1)
				color = P1_1;
			else if(life1_color == 4'h2)
				color = P1_2;
			else if(life1_color == 4'h3)
				color = P1_3;
			else if(life1_color == 4'h4)
				color = P1_4;
			else if(life1_color == 4'h5)
				color = P1_5;
			else if(life1_color == 4'h6)
				color = P1_6;
			else color = HUD_COLOR;
		end
		else if ((life2_on == 1'b1))
		begin
			if(life2_color == 4'h1)
				color = P2_1;
			else if(life2_color == 4'h2)
				color = P2_2;
			else if(life2_color == 4'h3)
				color = P2_3;
			else if(life2_color == 4'h4)
				color = P2_4;
			else if(life2_color == 4'h5)
				color = P2_5;
			else if(life2_color == 4'h6)
				color = P2_6;
			else color = HUD_COLOR;
		end
		else if(bullet1_on==1'b1)
			color = BULLET_1_COLOR;
		else if(bullet2_on==1'b1)
			color = BULLET_2_COLOR;
		else if(banner_on == 1'b1)
			if(winner == 2'd1)
				if(p1_wins[bannerIndex] == 1'b1)
					color = TEXT_COLOR;
				else color = HUD_COLOR;
			else if(winner == 2'd2)
				if(p2_wins[bannerIndex] == 1'b1)
					color = TEXT_COLOR;
				else color = HUD_COLOR;
			else color = HUD_COLOR;
		else if(health1_on == 1'b1)
			color = P1_3;
		else if(health2_on == 1'b1)
			color = P2_3;
		else if(map_on==1'b1)
			if(DrawY >= 450)
				color = HUD_COLOR;
			else if(map_color == 4'h0)
				color = G_0;
			else if(map_color == 4'h1)
				color = G_1;
			else if(map_color == 4'h2)
				color = G_2;
			else color = G_3;
		else
			color = BG_COLOR;
	end 
	 
	assign Red = color[23:16];
	assign Green = color[15:8];
	assign Blue = color[7:0];
 
endmodule
