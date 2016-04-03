///*---------------------------------------------------------------------------
//  --      AES.sv                                                           --
//  --      Joe Meng                                                         --
//  --      Fall 2013                                                        --
//  --                                                                       --
//  --      For use with ECE 298 Experiment 9                                --
//  --      UIUC ECE Department                                              --
//  ---------------------------------------------------------------------------*/
//
//// AES module interface with all ports, commented for Week 1
// module  AES ( input  [127:0]  Plaintext,
//                              Cipherkey,
//              input           clk, 
//                              Reset,
//		 	  				     Run,
//              output logic [127:0]  Ciphertext,
//              output          Ready  );
//
//// Partial interface for Week 1
//// Splitting the signals into 32-bit ones for compatibility with ModelSim
//	// module  AES ( input clk,
//	// 		  input  [0:31]  Cipherkey_0, Cipherkey_1, Cipherkey_2, Cipherkey_3,
//  //             output [0:31]  keyschedule_out_0, keyschedule_out_1, keyschedule_out_2, keyschedule_out_3 );					 
//					 
//	logic [0:1407] keyschedule;
//
//   logic [0:127] state, next_state;
//
//   logic [4:0]   counter;
//
//   enum          logic[4:0] {IDLE, FINISHED, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0} round_state, next_round_state;
//   enum          logic [4:0] {NR, INV_SHIFT_ROWS, INV_SUB_BYTES1, INV_SUB_BYTES2, ADD_ROUND_KEY, INV_MIX_COLUMNS1, INV_MIX_COLUMNS2, INV_MIX_COLUMNS3, INV_MIX_COLUMNS4} calc_state, next_calc_state;
//
//   
//					 
//	KeyExpansion keyexpansion_0(
//	                            .*,
//	                            .KeySchedule(keyschedule));
//	
////	assign {keyschedule_out_0, keyschedule_out_1, keyschedule_out_2, keyschedule_out_3} = keyschedule[1280:1407];
//
//   logic [0:31]  inv_mix_columns_in, inv_mix_columns_out;
//   logic [0:127] inv_shift_rows_in, inv_shift_rows_out, sub_bytes_in, sub_bytes_out, add_round_key_key, add_round_key_in, add_round_key_out;
//
//   InvShiftRows inv_shift_rows(.in(inv_shift_rows_in), .out(inv_shift_rows_out));
//   InvSubBytes_16 inv_sub_bytes(.clk(clk), .in(sub_bytes_in), .out(sub_bytes_out));
//   AddRoundKey add_round_key(.in(add_round_key_in), .out(add_round_key_out), .key(add_round_key_key));
//   InvMixColumns inv_mix_columns(.in(inv_mix_columns_in), .out(inv_mix_columns_out));
//   
//   always @ (posedge clk, posedge Reset) begin
//      if (Reset == 1'b1) begin
//         round_state <= IDLE;
//         calc_state <= NR;
//      end else begin
//         round_state <= next_round_state;
//         calc_state <= next_calc_state;
//         state <= next_state;
//         counter <= counter + 1;
//         
//         if (round_state == IDLE) 
//           counter <= 4'b0;
//         
//         if (round_state == FINISHED)
//           Ciphertext <= state;
//      end
//   end // always @ (posedge clk, posedge Reset)
//
//   always_comb begin
//      next_round_state = round_state;
//      add_round_key_key = 128'b0;
//      
//      unique case (round_state)
//        IDLE: begin
//           if (Run) begin
//              next_round_state <= R10;
//           end
//        end
//        
//        R10: begin
//           // wait for key expansion 
//           if (counter >= 4'hA) 
//             next_round_state <= R9;
//           
//           add_round_key_key <= keyschedule[1280:1407];
//        end
//
//        R9: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R8;
//           
//           add_round_key_key <= keyschedule[1152:1279];
//        end
//
//        R8: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R7;
//           
//           add_round_key_key <= keyschedule[1024:1151];
//        end
//
//        R7: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R6;
//
//           add_round_key_key <= keyschedule[896:1023];
//        end
//
//        R6: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R5;
//           
//           add_round_key_key <= keyschedule[768:895];
//        end
//
//        R5: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R4;
//           
//           add_round_key_key <= keyschedule[640:767];
//        end
//
//        R4: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R3;
//           
//           add_round_key_key <= keyschedule[512:639];
//        end
//
//        R3: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R2;
//           
//           add_round_key_key <= keyschedule[384:511];
//        end
//
//        R2: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R1;
//           
//           add_round_key_key <= keyschedule[256:383];
//        end
//
//        R1: begin
//           if (calc_state == INV_MIX_COLUMNS4)
//             next_round_state <= R0;
//
//           add_round_key_key <= keyschedule[128:255];
//        end
//
//        R0: begin
//           if (calc_state == ADD_ROUND_KEY)
//             next_round_state <= FINISHED;
//           
//           add_round_key_key <= keyschedule[0:127];
//        end
//
//        FINISHED: begin
//           next_round_state <= IDLE;
//        end
//
//        default: ;
//          
//      endcase // case (round_state)
//   end // always_comb
//
//   always_comb begin
//      next_calc_state = calc_state;
//      
//      // {NR, INV_SHIFT_ROWS, INV_SUB_BYTES, ADD_ROUND_KEY, INV_MIX_COLUMNS}
//      unique case (calc_state)
//        NR: begin
//           if (counter >= 4'h9) begin
//              next_calc_state <= ADD_ROUND_KEY;
//           end else begin
//              next_calc_state <= NR;
//           end
//        end
//        
//        INV_SHIFT_ROWS:
//          next_calc_state <= INV_SUB_BYTES1;
//
//        INV_SUB_BYTES1:
//          next_calc_state <= INV_SUB_BYTES2;
//
//        INV_SUB_BYTES2:
//          next_calc_state <= ADD_ROUND_KEY;
//
//        ADD_ROUND_KEY:
//          if (round_state == R10 && counter >= 4'hA)
//            next_calc_state <= INV_SHIFT_ROWS;
//          else if (round_state == R0)
//            next_calc_state <= NR;
//          else
//            next_calc_state <= INV_MIX_COLUMNS1;
//
//        INV_MIX_COLUMNS1:
//          next_calc_state <= INV_MIX_COLUMNS2;
//        
//        INV_MIX_COLUMNS2:
//          next_calc_state <= INV_MIX_COLUMNS3;
//        
//        INV_MIX_COLUMNS3:
//          next_calc_state <= INV_MIX_COLUMNS4;
//        
//        INV_MIX_COLUMNS4:
//          next_calc_state <= INV_SHIFT_ROWS;
//
//        default: ;
//        
//      endcase // case (calc_state)
//      
//   end // always_comb
//
//   assign Ready = (round_state == IDLE && Run == 1'b0) ? 1'b1 : 1'b0;
//   
//   always_comb begin
//      // default value
//      next_state = 128'b0;
//      inv_shift_rows_in = 128'b0;
//      inv_mix_columns_in = 31'b0;
//      sub_bytes_in = 128'b0;
//      add_round_key_in = 128'b0;
//
//      if (round_state == IDLE) 
//				next_state = Plaintext;
//
//      if (counter < 4'hA)
//        next_state = state;
//      
//         //   logic [0:31]  inv_mix_columns_in, inv_mix_columns_out;
//         // logic [0:127] inv_shift_rows_in, inv_shift_rows_out, sub_bytes_in, sub_bytes_out, add_round_key_key, add_round_key_in, add_round_key_out;
//      //    NR, INV_SHIFT_ROWS, INV_SUB_BYTES, ADD_ROUND_KEY, INV_MIX_COLUMNS1, INV_MIX_COLUMNS2, INV_MIX_COLUMNS3, INV_MIX_COLUMNS4
//      case (calc_state)
//        INV_SHIFT_ROWS: begin
//           inv_shift_rows_in = state;
//           next_state = inv_shift_rows_out;
//        end
//
//        INV_SUB_BYTES1: begin
//           sub_bytes_in = state;
//           next_state = state;
//        end
//
//        INV_SUB_BYTES2: begin
//           sub_bytes_in = state;
//           next_state = sub_bytes_out;
//        end
//
//        ADD_ROUND_KEY: begin
//           add_round_key_in = state;
//           next_state = add_round_key_out;
//        end
//
//        INV_MIX_COLUMNS1: begin
//           inv_mix_columns_in = state[0:31];
//           next_state = {inv_mix_columns_out, state[32:127]};
//        end
//
//        INV_MIX_COLUMNS2: begin
//           inv_mix_columns_in = state[32:63];
//           next_state = {state[0:31], inv_mix_columns_out, state[64:127]};
//        end
//
//        INV_MIX_COLUMNS3: begin
//           inv_mix_columns_in = state[64:95];
//           next_state = {state[0:63], inv_mix_columns_out, state[96:127]};
//        end
//
//        INV_MIX_COLUMNS4: begin
//           inv_mix_columns_in = state[96:127];
//           next_state = {state[0:95], inv_mix_columns_out};
//        end
//		  
//		  default: ;
//      endcase // case (calc_state)
//   end
//endmodule

module  AES ( input   clk, 
                       Reset,
							  Run,
					input  [127:0]  Plaintext,
                               Cipherkey,
               output logic [127:0]  Ciphertext,
               output          Ready  );
				 
					 
logic [0:1407] keyschedule;
logic [4:0]   	key_exp_wait;

//STATE RESULTS
logic [0:127] state, next_state;

//CALCULATION_STATES
enum		logic[4:0]{IDLE_CALC, INVSHIFTROWS, INVSUBBYTES1, INVSUBBYTES2, ADDROUNDKEY, 
						  INVMIXCOLS3, INVMIXCOLS2, INVMIXCOLS1, INVMIXCOLS0} calc, next_calc;

//ROUND STATES
enum		logic[4:0]{IDLE_ROUND, FINISHED, ROUND_0, ROUND_1, ROUND_2, ROUND_3, ROUND_4,
						  ROUND_5, ROUND_6, ROUND_7, ROUND_8, ROUND_9, ROUND_10} round, next_round;
		
		
logic [0:31]  inverse_mix_columns_input, inverse_mix_columns_output;
logic [0:127] inverse_shift_rows_input, inverse_shift_rows_output, 
					sub_bytes_input, sub_bytes_output, 
					key, add_round_key_input, add_round_key_output;
 
//All modules necessary to perform AES encryption
KeyExpansion keyexpansion_0(.*, .KeySchedule(keyschedule));
InvShiftRows inverse_shift_rows(.in(inverse_shift_rows_input), .out(inverse_shift_rows_output));
InvSubBytes_16 inverse_sub_bytes_16(.clk(clk), .in(sub_bytes_input), .out(sub_bytes_output));
AddRoundKey add_round_key(.in(add_round_key_input), .out(add_round_key_output), .key(key));
InvMixColumns inverse_mix_columns(.in(inverse_mix_columns_input), .out(inverse_mix_columns_output));


//Determining Next State
always @ (posedge clk, posedge Reset) 
begin
	if (Reset == 1'b1) 
	begin
		round <= IDLE_ROUND;
		calc <= IDLE_CALC;
   end 
	else 
	begin
		round <= next_round;
		calc <= next_calc;
		state <= next_state;
		key_exp_wait <= key_exp_wait + 1;
         
		if (round == IDLE_ROUND) 
		  key_exp_wait <= 4'b0;   
		  
		if (round == FINISHED)
        Ciphertext <= state;
   end
end

//Next State for Round (10 Rounds)
always_comb
begin
	next_round = round;
	key = 128'b0;

	unique case (round)
		IDLE_ROUND: 
		begin
			if (Run) 
				next_round <= ROUND_10;
		end
	  
		ROUND_10: 
		begin 
			if (key_exp_wait >= 4'hA) 
				next_round <= ROUND_9;
				
			key <= keyschedule[1280:1407];
		end

		ROUND_9: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_8;
		  
			key <= keyschedule[1152:1279];
		end
		
		ROUND_8: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_7;
		  
			key <= keyschedule[1024:1151];
		end
		
		ROUND_7: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_6;
		  
			key <= keyschedule[896:1023];
		end
		
		ROUND_6: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_5;
		  
			key <= keyschedule[768:895];
		end
		
		ROUND_5: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_4;
		  
			key <= keyschedule[640:767];
		end
		
		ROUND_4: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_3;
		  
			key <= keyschedule[512:639];
		end
		
		ROUND_3: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_2;
		  
			key <= keyschedule[384:511];
		end
		
		ROUND_2: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_1;
		  
			key <= keyschedule[256:383];
		end
		
		ROUND_1: 
		begin
			if (calc == INVMIXCOLS3)
				next_round <= ROUND_0;
		  
			key <= keyschedule[128:255];
		end
		
		ROUND_0: 
		begin
			if (calc == ADDROUNDKEY)
				next_round <= FINISHED;
		  
			key <= keyschedule[0:127];
		end
		FINISHED: 
		begin
           next_round <= IDLE_ROUND;
      end
      default: ;
	endcase
end

//NEXT_CALC_STATE
always_comb 
begin
	next_calc = calc;
	unique case (calc)
		IDLE_CALC:
		begin
			if (key_exp_wait >= 4'h9) 
			begin
				next_calc <= ADDROUNDKEY;
			end else begin
				next_calc <= IDLE_CALC;
			end
		end
  
		INVSHIFTROWS:
			next_calc <= INVSUBBYTES1;

		INVSUBBYTES1:
			next_calc <= INVSUBBYTES2;
			
		INVSUBBYTES2:
			next_calc <= ADDROUNDKEY;

		ADDROUNDKEY:
			if (round == ROUND_10 && key_exp_wait >= 4'hA)
				next_calc <= INVSHIFTROWS;
			else if (round == ROUND_0)
				next_calc <= IDLE_CALC;
			else
				next_calc <= INVMIXCOLS0;

		INVMIXCOLS0:
			next_calc <= INVMIXCOLS1;

		INVMIXCOLS1:
			next_calc <= INVMIXCOLS2;
  
		INVMIXCOLS2:
			next_calc <= INVMIXCOLS3;
  
		INVMIXCOLS3:
			next_calc <= INVSHIFTROWS;

		default: ;
	endcase
end

assign Ready = (round == IDLE_ROUND && Run == 1'b0) ? 1'b1 : 1'b0;

//Determining Value to Input to Modules
always_comb 
begin
	// default value
	next_state = 128'b0;
	inverse_shift_rows_input = 128'b0;
	inverse_mix_columns_input = 31'b0;
	sub_bytes_input = 128'b0;
	add_round_key_input = 128'b0;

	if (round == IDLE_ROUND) 
			next_state = Plaintext;

	if (key_exp_wait < 4'hA)
	  next_state = state;
	 
	case(calc)
	  INVSHIFTROWS: 
	  begin
		  inverse_shift_rows_input = state;
		  next_state = inverse_shift_rows_output;
	  end

	  INVSUBBYTES1: 
	  begin
		  sub_bytes_input = state;
		  next_state = state;
	  end

	  INVSUBBYTES2: 
	  begin
		  sub_bytes_input = state;
		  next_state = sub_bytes_output;
	  end

	  ADDROUNDKEY: 
	  begin
		  add_round_key_input = state;
		  next_state = add_round_key_output;
	  end

	  INVMIXCOLS0: 
	  begin
		  inverse_mix_columns_input = state[0:31];
		  next_state = {inverse_mix_columns_output, state[32:127]};
	  end

	  INVMIXCOLS1: 
	  begin
		  inverse_mix_columns_input = state[32:63];
		  next_state = {state[0:31], inverse_mix_columns_output, state[64:127]};
	  end

	  INVMIXCOLS2: 
	  begin
		  inverse_mix_columns_input = state[64:95];
		  next_state = {state[0:63], inverse_mix_columns_output, state[96:127]};
	  end

	  INVMIXCOLS3: 
	  begin
		  inverse_mix_columns_input = state[96:127];
		  next_state = {state[0:95], inverse_mix_columns_output};
	  end
	  
	  default: ;
	endcase
end
		 
endmodule