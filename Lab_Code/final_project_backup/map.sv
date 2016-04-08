module map(	input reset, clk,
				input[9:0] init_map, next_level,
								p1_lives, p2_lives,
				output [191:0] mask,
				output[9:0] p1_init_x, p1_init_y,
								p2_init_x, p2_init_y,
								num_levels,
				output new_level, 
				output [1:0] winner
								);

	logic [9:0] current_map;
	
	logic ignore_death;
	
	logic [0:191] map0, map1, map2, map3, map4;
	logic [9:0]	map0_p1x, map0_p1y, map0_p2x, map0_p2y,
					map1_p1x, map1_p1y, map1_p2x, map1_p2y,
					map2_p1x, map2_p1y, map2_p2x, map2_p2y,
					map3_p1x, map3_p1y, map3_p2x, map3_p2y,
					map4_p1x, map4_p1y, map4_p2x, map4_p2y;
								
	assign num_levels = 10'd5;
								
	always_ff @ (posedge reset or posedge clk)
	begin
	
		if(reset == 1'b1)
		begin
			
			winner = 2'd0;
			current_map = init_map;
			ignore_death = 1'b0;
					
			unique case(current_map)
				10'd0 : 
				begin
					mask = map0;
					p1_init_x = map0_p1x;
					p1_init_y = map0_p1y;
					p2_init_x = map0_p2x;
					p2_init_y = map0_p2y;
				end
				10'd1 : 
				begin
					mask = map1;
					p1_init_x = map1_p1x;
					p1_init_y = map1_p1y;
					p2_init_x = map1_p2x;
					p2_init_y = map1_p2y;
				end
				10'd2 : 
				begin
					mask = map2;
					p1_init_x = map2_p1x;
					p1_init_y = map2_p1y;
					p2_init_x = map2_p2x;
					p2_init_y = map2_p2y;
				end
				10'd3:
				begin
					mask = map3;
					p1_init_x = map3_p1x;
					p1_init_y = map3_p1y;
					p2_init_x = map3_p2x;
					p2_init_y = map3_p2y;
				end
				default:
				begin
					mask = map4;
					p1_init_x = map4_p1x;
					p1_init_y = map4_p1y;
					p2_init_x = map4_p2x;
					p2_init_y = map4_p2y;
				end
				
			endcase
			
			new_level = 1'b1;
			
		end
		else if(p1_lives == 1'b0 || p2_lives == 1'b0)
		begin
		
			if(p1_lives == 1'b0)
				winner = 2'd2;
			else winner = 2'd1;
			
			if(!ignore_death)
			begin
				current_map = next_level;
				new_level = 1'b1;
				ignore_death = 1'b1;
				
				unique case(current_map)
					10'd0 : 
					begin
						mask = map0;
						p1_init_x = map0_p1x;
						p1_init_y = map0_p1y;
						p2_init_x = map0_p2x;
						p2_init_y = map0_p2y;
					end
					10'd1 : 
					begin
						mask = map1;
						p1_init_x = map1_p1x;
						p1_init_y = map1_p1y;
						p2_init_x = map1_p2x;
						p2_init_y = map1_p2y;
					end
					10'd2 : 
					begin
						mask = map2;
						p1_init_x = map2_p1x;
						p1_init_y = map2_p1y;
						p2_init_x = map2_p2x;
						p2_init_y = map2_p2y;
					end
					10'd3:
					begin
						mask = map3;
						p1_init_x = map3_p1x;
						p1_init_y = map3_p1y;
						p2_init_x = map3_p2x;
						p2_init_y = map3_p2y;
					end
					default:
					begin
						mask = map4;
						p1_init_x = map4_p1x;
						p1_init_y = map4_p1y;
						p2_init_x = map4_p2x;
						p2_init_y = map4_p2y;
					end
					
				endcase
			end
			else
			begin
				ignore_death = 1'b0;
			end
		
		end
		else
		begin
			new_level = 1'b0;
			ignore_death = 1'b0;
			mask = mask;
			p1_init_x = p1_init_x;
			p1_init_y = p1_init_y;
			p2_init_x = p2_init_x;
			p2_init_y = p2_init_y;
		end
		
	end
	

	assign map0 = {
	16'b1111111111111111,
	16'b1000000000000001,
	16'b1111000000011111,
	16'b1011110000000001,
	16'b1000111100000001,
	16'b1000000000001111,
	16'b1000000000111111,
	16'b1000111111110001,
	16'b1000000000000001,
	16'b1111000000001111,
	16'b1000000000000001,
	16'b1111111111111111};
	assign map0_p1x = 2;
	assign map0_p1y = 1;
	assign map0_p2x = 14;
	assign map0_p2y = 8;
	
	assign map1 = {
	16'b1111111111111111,
	16'b1100000000000011,
	16'b1000000000000001,
	16'b1000000000000001,
	16'b1001111001111001,
	16'b1000000000000001,
	16'b1110001111000111,
	16'b1000000000000001,
	16'b1000010000100001,
	16'b1000110000110001,
	16'b1001111111111001,
	16'b1111111111111111};
	assign map1_p1x = 1;
	assign map1_p1y = 10;
	assign map1_p2x = 14;
	assign map1_p2y = 10;
	
	assign map2 = {
	16'b1111111111111111,
	16'b1100000000000011,
	16'b1000000000000001,
	16'b1000001111000001,
	16'b1000000110000001,
	16'b1110011111100111,
	16'b1000000110000001,
	16'b1001100110011001,
	16'b1000000110000001,
	16'b1100000110000011,
	16'b1110001111000111,
	16'b1111111111111111};
	assign map2_p1x = 4;
	assign map2_p1y = 10;
	assign map2_p2x = 11;
	assign map2_p2y = 10;
	
	assign map3 = {
	16'b1111111111111111,
	16'b1100000110000011,
	16'b1000000110000001,
	16'b1000011111100001,
	16'b1000000000000001,
	16'b1000011111100001,
	16'b1110001111000111,
	16'b1111000110001111,
	16'b1110000110000111,
	16'b1100011111100011,
	16'b1000111111110001,
	16'b1111111111111111};
	assign map3_p1x = 2;
	assign map3_p1y = 10;
	assign map3_p2x = 13;
	assign map3_p2y = 10;
	
	assign map4 = {
	16'b1111111111111111,
	16'b1000000000000001,
	16'b1001110000111001,
	16'b1111111001111111,
	16'b1000000000000001,
	16'b1011111111111101,
	16'b1000000000000001,
	16'b1111111001111111,
	16'b1000000000000001,
	16'b1011111111111101,
	16'b1000000000000001,
	16'b1111111111111111};
	assign map4_p1x = 1;
	assign map4_p1y = 2;
	assign map4_p2x = 14;
	assign map4_p2y = 2;
	
endmodule 