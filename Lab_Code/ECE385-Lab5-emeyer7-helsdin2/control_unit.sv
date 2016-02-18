/*CONTROL MODULE 
* Defines inputs to the rest of the system to determine what actions system performs
*/
module control_unit ( input Clk, reset_button, clear_a_load_b_button, execute_button, M,									//inputs coming from switches and M bit
					  output logic shift_enable, add, load, subtract			//outputs going to shift registers and 9-bit adder
);


enum logic [4:0] {idle_state, load_state, start_state, done_state, reset_state,
						A_1, A_2, A_3, A_4, A_5, A_6, A_7, Sub_8, 
						Sh_1, Sh_2, Sh_3, Sh_4, Sh_5, Sh_6, Sh_7, Sh_8} curr_state, next_state;
						

always_ff @ (posedge Clk or posedge reset_button)  
	begin
		curr_state = reset_button ? reset_state : next_state;
	end

/*Defines Next States from Current States = 5 STATES TOTAL*/
always_comb
begin
	next_state = curr_state;
	unique case (curr_state)
	
		idle_state:
			if(execute_button == 1'b1)
				next_state = start_state;
			else if (clear_a_load_b_button == 1'b1)
				next_state = load_state;
				
		load_state:
			next_state = idle_state;
			
		start_state:
			next_state = A_1;
			A_1 : next_state = Sh_1;
			Sh_1: next_state = A_2;
			A_2 : next_state = Sh_2;
			Sh_2: next_state = A_3;
			A_3 : next_state = Sh_3;
			Sh_3: next_state = A_4;
			A_4 : next_state = Sh_4;
			Sh_4: next_state = A_5;
			A_5 : next_state = Sh_5;
			Sh_5: next_state = A_6;
			A_6 : next_state = Sh_6;
			Sh_6: next_state = A_7;
			A_7 : next_state = Sh_7;
			Sh_7: next_state = Sub_8;
			Sub_8: next_state = Sh_8;
			Sh_8: next_state = done_state;
			
		done_state:
			if(execute_button == 1'b0)
				next_state = idle_state;
				
		reset_state:
			next_state = idle_state;
			
	endcase
end

/*Defines Control Module Outputs which will then feed into the rest of the system to control the multiplier*/
always_comb
begin
	unique case (curr_state)
	
		idle_state:
			begin
				shift_enable <= 1'b0;
				add<= 1'b0;
				load<= 1'b0;
				subtract<= 1'b0;
			end
		
		load_state:
			begin
				shift_enable<= 1'b0;
				add<= 1'b0;
				load<= 1'b1;
				subtract<= 1'b0;
			end
			
		start_state:
			begin
				shift_enable<= 1'b0;
				add<= 1'b0;
				load<= 1'b0;
				subtract<= 1'b0;
			end
		
		A_1, A_2, A_3, A_4, A_5, A_6, A_7:
			begin
				shift_enable<= 1'b0;
				load<= 1'b0;
				subtract<= 1'b0;
				add <= (M==1'b1) ? 1'b1 : 1'b0;
			end
		
		Sh_1, Sh_2, Sh_3, Sh_4, Sh_5, Sh_6, Sh_7, Sh_8:
			begin
				shift_enable<= 1'b1;
				add<= 1'b0;
				load<= 1'b0;
				subtract<= 1'b0;
			end
		
		Sub_8:
			begin
				shift_enable<= 1'b0;
				load<= 1'b0;
				subtract<= 1'b1;
				add <= (M==1'b1) ? 1'b1 : 1'b0;
			end
		
		done_state:
			begin
				shift_enable<= 1'b0;
				add<= 1'b0;
				load<= 1'b0;
				subtract<= 1'b0;
			end
		
		reset_state:
			begin
				shift_enable<= 1'b0;
				add<= 1'b0;
				load<= 1'b0;
				subtract<= 1'b0;
			end
		
	endcase
end
endmodule