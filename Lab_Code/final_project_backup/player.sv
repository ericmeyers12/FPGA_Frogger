module player(input frame_clk, Reset,
							up, down, left, right, shoot,
							new_level,
					input [9:0] TILE_SIZE, NUM_COLS,
							EnemyX, EnemyY, EnemyW, EnemyH,
							init_x, init_y,
					input [0:191] map,
					output [9:0] PlayerX, PlayerY, PlayerW, PlayerH, PlayerDir, 
							BulletX, BulletY, BulletW, BulletH,
							EnemyHealth, EnemyLives
					);
					
	int x, y, vx, vy;
	logic dir;
	
	int bullet_x, bullet_y;
	logic bullet_dir;
	
	int health, lives;
	
	parameter DIR_LEFT = 1'b0, DIR_RIGHT = 1'b1;
	
	//	INITIAL VALUES
	parameter [9:0] INIT_VX = 0;
	parameter [9:0] INIT_VY = 0;
	parameter INIT_DIR = DIR_RIGHT;
	 
	//	GAME BOUNDARIES	
   parameter [9:0] MIN_X=0;
   parameter [9:0] MAX_X=640;
   parameter [9:0] MIN_Y=0;
   parameter [9:0] MAX_Y=480;
	
	//	SPEED LIMITS  
	parameter [9:0] MIN_VX=5;
   parameter [9:0] MAX_VX=5;
   parameter [9:0] MIN_VY=100;
	parameter [9:0] MAX_VY=10;
	
	//	ACCELERATIONS
   parameter [9:0] ACC_MOVE=1;
	parameter [9:0] ACC_JUMP=15;
   parameter [9:0] ACC_GRAV=1;
	parameter [9:0] ACC_FRIC=1;
	
	//	PLAYER CONSTANTS
	parameter [9:0] WIDTH = 20;
	parameter [9:0] HEIGHT = 20;
	
	//	BULLET CONSTANTS
	parameter [9:0] BULLET_WIDTH = 4;
	parameter [9:0] BULLET_HEIGHT = 2;
	parameter [9:0] BULLET_SPEED = 6;
	
	//	HEALTH CONSTANTS
	parameter [9:0] MAX_HEALTH = 10,
						 MAX_LIVES = 3;
		
	always_ff @ (posedge Reset or posedge frame_clk )
	begin: Move_Player
		if (Reset==1'b1)  // Asynchronous Reset
		begin 
			
			x = init_x*TILE_SIZE + 10;
			y = init_y*TILE_SIZE + 10;
			vx = INIT_VX;
			vy = INIT_VY;
			dir = INIT_DIR;
			
			bullet_x = MAX_X;
			bullet_y = MAX_Y;
			bullet_dir = INIT_DIR;
						
			health = MAX_HEALTH;
			lives = MAX_LIVES;
						
		end
		else if(new_level == 1'b1)
		begin 
			
			x = init_x*TILE_SIZE + 10;
			y = init_y* TILE_SIZE + 10;
			vx = INIT_VX;
			vy = INIT_VY;
			dir = INIT_DIR;
			
			bullet_x = MAX_X;
			bullet_y = MAX_Y;
			bullet_dir = INIT_DIR;
						
			health = MAX_HEALTH;
			lives = MAX_LIVES;
			
		end
		else 
		begin 
		
		
			/////////////////////////////
			//	BULLET LOGIC 	///////////
			/////////////////////////////
			
			//	IF SHOOT IS PRESSED, AND BULLET IS OFF SCREEN, FIRE BULLET
			if(shoot && bullet_x >= MAX_X)
			begin
				bullet_dir = dir;
			
				if(dir == DIR_RIGHT)
				begin
					bullet_x = x + WIDTH;
					bullet_y = y + 6;
				end
				else
				begin
					bullet_x = x - BULLET_WIDTH;
					bullet_y = y + 6;
				end
			end
			
			//	IF BULLET IS WITHIN BOUNDS, IT EXISTS IN GAME
			else if(bullet_x > 0 && (bullet_x+BULLET_WIDTH) < MAX_X)
			begin
				if(bullet_dir == DIR_RIGHT)
				begin
					bullet_x = bullet_x + BULLET_SPEED;
					
					//	IF ENEMY HIT
					if(((bullet_x + BULLET_WIDTH - 1) > EnemyX && (bullet_x + BULLET_WIDTH - 1) < (EnemyX + EnemyW)) 
					&& (bullet_y) > EnemyY && (bullet_y) < (EnemyY + EnemyH))
					begin
						//	DEDUCT ENEMY HEALTH
						health = health - 1;
						bullet_x = MAX_X;
						bullet_y = MAX_Y;
						
						if(health == 0)
						begin
							lives = lives - 1;
							health = MAX_HEALTH;
						end
						
					end
					
				end
				
				else
				begin
					bullet_x = bullet_x - BULLET_SPEED;
					
					//	IF ENEMY HIT
					if(((bullet_x) > EnemyX && (bullet_x) < (EnemyX + EnemyW)) 
					&& (bullet_y) > EnemyY && (bullet_y) < (EnemyY + EnemyH))
					begin
						//	DEDUCT ENEMY HEALTH
						health = (health - 1);
						bullet_x = MAX_X;
						bullet_y = MAX_Y;
						
						if(health == 0)
						begin
							lives = lives - 1;
							health = MAX_HEALTH;
						end
					end
				end
			end
			
			//	IF BULLET IS OUT OF BOUNDS, LEAVE IT IN THE BOTTOM RIGHT CORNER.
			else
			begin
				bullet_x = MAX_X;
				bullet_y = MAX_Y;
			end
			
			////////////////////////////
			//	Y-DIRECTION		//////////
			////////////////////////////

			//	IF UP AND ON GROUND, JUMP.

			if(up && (map[ (x)/TILE_SIZE + (y+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1 || map[(x+WIDTH-1)/TILE_SIZE + (y+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1))
			begin
				vy = vy - ACC_JUMP;
				
				//		up
				if((map[ (x+1)/TILE_SIZE + (y+vy)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+WIDTH-1)/TILE_SIZE + (y+vy)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					y = (y/TILE_SIZE)*TILE_SIZE;
					vy = 0;
				end
				//		down
				else if((map[ (x+1)/TILE_SIZE + (y+vy+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+WIDTH-1)/TILE_SIZE + (y+vy+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					y = (y/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-HEIGHT);
					vy = 0;
				end
				else
				begin
					vy = vy;
					y = y + vy;
				end
			end

			//	ELSE IF NOT ON GROUND AND NOT AT TERMINAL VELOCITY, FALL FASTER.
			else if(!(map[ (x)/TILE_SIZE + (y+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1 || map[(x+WIDTH-1)/TILE_SIZE + (y+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1) && (vy >= ~(MIN_VY) + 1 || vy < MAX_VY))
			begin
				vy = vy + ACC_GRAV;
				
				//		up
				if((map[ (x+1)/TILE_SIZE + (y+vy)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+WIDTH-1)/TILE_SIZE + (y+vy)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					y = (y/TILE_SIZE)*TILE_SIZE;
					vy = 0;
				end
				//		down
				else if((map[ (x+1)/TILE_SIZE + (y+vy+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+WIDTH-1)/TILE_SIZE + (y+vy+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					y = (y/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-HEIGHT);
					vy = 0;
				end
				else
				begin
					vy = vy;
					y = y + vy;
				end
			end

			//	ELSE, DON'T CHANGE VY
			else
			begin
				vy = vy;
				
				//		up
				if((map[ (x+1)/TILE_SIZE + (y+vy)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+WIDTH-1)/TILE_SIZE + (y+vy)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					y = (y/TILE_SIZE)*TILE_SIZE;
					vy = 0;
				end
				//		down
				else if((map[ (x+1)/TILE_SIZE + (y+vy+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+WIDTH-1)/TILE_SIZE + (y+vy+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					y = (y/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-HEIGHT);
					vy = 0;
				end
				else
				begin
					vy = vy;
					y = y + vy;
				end				
			end
			


			////////////////////////	
			//	X-DIRECTION		//////
			////////////////////////


			//	IF LEFT, NOT RIGHT, AND GREATER THAN MIN_VX, ACCELERATE LEFT.
			if(left && !right && ( vx > (~(MIN_VX) + 1) || vx <= (MAX_VX) ))
			begin
				vx = vx - ACC_MOVE;
				dir = DIR_LEFT;
									
				//		left
				if((map[ (x+vx)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					x = ((x+vx)/TILE_SIZE + 10'd1)*TILE_SIZE;
					vx = 0;
				end
				//		right
				else if((map[ (x+vx+WIDTH)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx+WIDTH)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					x = (x/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-WIDTH);
					vx = 0;
				end
				else
				begin
					vx = vx;
					x = x + vx;
				end
				
			end

			//	IF RIGHT, NOT LEFT, AND LESS THAN MAX_VX, ACCELERATE RIGHT.
			else if(right && !left && ( vx >= (~(MIN_VX) + 1) || vx < (MAX_VX) ))
			begin
				vx = vx + ACC_MOVE;
				dir = DIR_RIGHT;
				
				//		left
				if((map[ (x+vx)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					
					x = ((x+vx)/TILE_SIZE + 10'd1)*TILE_SIZE;
					vx = 0;
				end
				//		right
				else if((map[ (x+vx+WIDTH)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx+WIDTH)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					x = (x/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-WIDTH);
					vx = 0;
				end
				else
				begin
					vx = vx;
					x = x + vx;
				end
			end

			//	IF ON GROUND, CHECK FOR FRICTION.
			else if((map[ (x)/TILE_SIZE + (y+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1 || map[(x+WIDTH-1)/TILE_SIZE + (y+HEIGHT)/TILE_SIZE*NUM_COLS ] == 1'b1))
			begin

				//	IF MOVING LEFT, APPLY POSITIVE FRICTION.
				if(vx >= (~(MIN_VX)+1))
				begin
					vx = vx + ACC_FRIC;
					
					//		left
					if((map[ (x+vx)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
					begin
						x = ((x+vx)/TILE_SIZE + 1)*TILE_SIZE;
						vx = 0;
					end
					//		right
					else if((map[ (x+vx+WIDTH)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx+WIDTH)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
					begin
						x = (x/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-WIDTH);
						vx = 0;
					end
					else
					begin
						vx = vx;
						x = x + vx;
					end
				end
				
				//	IF MOVING RIGHT, APPLY NEGATIVE FRICTION
				else if(vx > 0 && vx <= MAX_VX)
				begin
					vx = vx - ACC_FRIC;
					
					//		left
					if((map[ (x+vx)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
					begin
						
						x = ((x+vx)/TILE_SIZE + 10'd1)*TILE_SIZE;
						vx = 0;
					end
					//		right
					else if((map[ (x+vx+WIDTH)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx+WIDTH)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
					begin
						x = (x/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-WIDTH);
						vx = 0;
					end
					else
					begin
						vx = vx;
						x = x + vx;
					end
				end

				//	ELSE, DON'T CHANGE VX.
				else
				begin
					
					//		left
					if((map[ (x+vx)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
					begin
						x = ((x+vx)/TILE_SIZE + 10'd1)*TILE_SIZE;
						vx = 0;
					end
					//		right
					else if((map[ (x+vx+WIDTH)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx+WIDTH)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
					begin
						x = (x/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-WIDTH);
						vx = 0;
					end
					else
					begin
						vx = vx;
						x = x + vx;
					end
				end
			end

			//	ELSE, DON'T CHANGE VX.
			else
			begin
				
				//		left
				if((map[ (x+vx)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					x = ((x+vx)/TILE_SIZE + 10'd1)*TILE_SIZE;
					vx = 0;
				end
				//		right
				else if((map[ (x+vx+WIDTH)/TILE_SIZE + (y+1)/TILE_SIZE*NUM_COLS ] == 1'b1) || (map[ (x+vx+WIDTH)/TILE_SIZE + (y+HEIGHT-1)/TILE_SIZE*NUM_COLS ] == 1'b1))
				begin
					x = (x/TILE_SIZE)*TILE_SIZE+(TILE_SIZE-WIDTH);
					vx = 0;
				end
				else
				begin
					vx = vx;
					x = x + vx;
				end
			end
		end
		
		

		
	end
	
	assign PlayerX = x[9:0];
	assign PlayerY = y[9:0];
	assign PlayerW = WIDTH;
	assign PlayerH = HEIGHT;
	assign PlayerDir = dir;

	assign BulletX = bullet_x[9:0];
	assign BulletY = bullet_y[9:0];
	assign BulletW = BULLET_WIDTH;
	assign BulletH = BULLET_HEIGHT;
	
	assign EnemyHealth = health[9:0];
	assign EnemyLives = lives[9:0];
	

endmodule 