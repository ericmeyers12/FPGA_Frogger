//-------------------------------------------------------------------------
//      PS2 Keyboard interface                                           --
//      Sai Ma                                                           --
//      11-13-2014                                                       --
//                                                                       --
//      For use with ECE 385 Final Project                     --
//      ECE Department @ UIUC                                            --
//-------------------------------------------------------------------------
module keyboard(input logic Clk, psClk, psData, reset,
					 output logic 
					 p1_up, p1_down, p1_left, p1_right, p1_shoot,
					 p2_up, p2_down, p2_left, p2_right, p2_shoot
					 );
					
	parameter 	KEY_W = 8'h1D, KEY_S = 8'h1B, KEY_A = 8'h1C, KEY_D = 8'h23, KEY_L_SHIFT = 8'h12,
					KEY_I = 8'h43, KEY_K = 8'h42, KEY_J = 8'h3B, KEY_L = 8'h4B, KEY_R_SHIFT = 8'h59;
					
	logic Q1, Q2, en, enable, shiftoutA, shiftoutB, shiftoutC;
	logic [4:0] Count; 
	logic [10:0] DO_A, DO_B, DO_C;
	logic [9:0] counter;
	
	//Counter to sync ps2 clock and system clock
	always@(posedge Clk or posedge reset)
	begin
		if(reset)
		begin
			counter = 10'b0000000000;
			enable = 1'b1;
		end
		else if (counter == 10'b0111111111)
		begin
			counter = 10'b0000000000;
			enable = 1'b1;
		end
		else 
		begin
			counter += 1'b1;
			enable = 1'b0;
		end
	end
	
	//edge detector of PS2 clock
	always@(posedge Clk)
	begin
		if(enable==1)
		begin
			if((reset)|| (Count==5'b01011))    
				Count <= 5'b00000;
		else if(Q1==0 && Q2==1)
			begin  			
				Count += 1'b1;
				en = 1'b1;
			end
		end
	end     

	always@(posedge Clk)
	begin
		if( Count == 5'b01011)
		begin

			//	IF RELEASE KEY WAS DETECTED, RELEASE THE SPECIFIED KEY.
			if(DO_B[9:2] == 8'hF0)
			begin
			
				if(DO_C[9:2] == KEY_W)					p1_up = 1'b0;
				else if(DO_C[9:2] == KEY_S)			p1_down = 1'b0;
				else if(DO_C[9:2] == KEY_A)			p1_left = 1'b0;
				else if(DO_C[9:2] == KEY_D)			p1_right = 1'b0;
				else if(DO_C[9:2] == KEY_L_SHIFT)	p1_shoot = 1'b0;
					
				if(DO_C[9:2] == KEY_I)					p2_up = 1'b0;
				else if(DO_C[9:2] == KEY_K)			p2_down = 1'b0;
				else if(DO_C[9:2] == KEY_J)			p2_left = 1'b0;
				else if(DO_C[9:2] == KEY_L)			p2_right = 1'b0;
				else if(DO_C[9:2] == KEY_R_SHIFT)	p2_shoot = 1'b0;
				
			end

			//	IF IT WASN'T, THEN SET THE KEY TO HIGH.
			else
			begin
				
				if(DO_C[9:2] == KEY_W)					p1_up = 1'b1;
				else if(DO_C[9:2] == KEY_S)			p1_down = 1'b1;
				else if(DO_C[9:2] == KEY_A)			p1_left = 1'b1;
				else if(DO_C[9:2] == KEY_D)			p1_right = 1'b1;
				else if(DO_C[9:2] == KEY_L_SHIFT)	p1_shoot = 1'b1;
					
				if(DO_C[9:2] == KEY_I)					p2_up = 1'b1;
				else if(DO_C[9:2] == KEY_K)			p2_down = 1'b1;
				else if(DO_C[9:2] == KEY_J)			p2_left = 1'b1;
				else if(DO_C[9:2] == KEY_L)			p2_right = 1'b1;
				else if(DO_C[9:2] == KEY_R_SHIFT)	p2_shoot = 1'b1;
				
			end
		end
	end
	
	Dreg Dreg_instance1 ( .*,
								 .Load(enable),
								 .Reset(reset), 
								 .D(psClk),
								 .Q(Q1) );
   Dreg Dreg_instance2 ( .*,
								 .Load(enable),
								 .Reset(reset), 
								 .D(Q1),
								 .Q(Q2) );
	
	reg_11 reg_C(
					.Clk(psClk),
					.Reset(reset), 
					.Shift_In(psData), 
					.Load(1'b0), 
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftoutC),
					.Data_Out(DO_C)
					);
	
	reg_11 reg_B(
					.Clk(psClk),
					.Reset(reset), 
					.Shift_In(shiftoutC), 
					.Load(1'b0), 
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftoutB),
					.Data_Out(DO_B)
					);
					
	reg_11 reg_A(
					.Clk(psClk),
					.Reset(reset), 
					.Shift_In(shiftoutB), 
					.Load(1'b0), 
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftoutA),
					.Data_Out(DO_A)
					);
	
endmodule 