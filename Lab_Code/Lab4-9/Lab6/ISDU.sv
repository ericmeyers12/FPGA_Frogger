//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//------------------------------------------------------------------------------

	
module ISDU (input					Clk, 
											Reset,
											Run,
											Continue,
											ContinueIR,
									
				input [3:0]  			Opcode, 
				input        			IR_5, IR_11, BEN,
				  
				output logic 			LD_MAR,
											LD_MDR,
											LD_IR,
											LD_BEN,
											LD_CC,
											LD_REG,
											LD_PC,
									
				output logic 			GatePC,
											GateMDR,
											GateALU,
											GateMARMUX,
									
				output logic [1:0] 	PCMUX,
											DRMUX,
											SR1MUX,
											
				output logic 			SR2MUX,
											ADDR1MUX,
											
				output logic [1:0] 	ADDR2MUX,
				
				output logic 			MARMUX,
				  
				output logic [1:0] 	ALUK,
				  
				output logic 			Mem_CE,
											Mem_UB,
											Mem_LB,
											Mem_OE,
											Mem_WE
				);

    enum logic [4:0] {Halted, PauseIR1, PauseIR2, S_18, S_33_1, S_33_2, S_35, S_32, S_01, S_05, S_09, S_22, 
							S_12, S_04, S_06, S_25_1, S_25_2, S_27, S_07, S_23, S_16_1, S_16_2, S_20, S_21}   State, Next_state;   // Internal state logic
	    
    always_ff @ (posedge Clk or posedge Reset )
    begin : Assign_Next_State
        if (Reset) 
            State <= Halted;
        else 
            State <= Next_state;
    end
   
	 always_comb
    begin 
	    Next_state  = State;
	 
        unique case (State)
            Halted : //HALTED
	            if (Run) 
					Next_state <= S_18;					  
            S_18 : 	//FETCH - 1
                Next_state <= S_33_1;
            S_33_1 : //FETCH - 2
                Next_state <= S_33_2;
            S_33_2 : //FETCH - 3
                Next_state <= S_35;
            S_35 : 	//FETCH - 4
                Next_state <= PauseIR1;
            PauseIR1 : //PAUSE STATE
                if (~ContinueIR) 
                    Next_state <= PauseIR1;
                else 
                    Next_state <= PauseIR2;
            PauseIR2 : 
                if (ContinueIR) 
                    Next_state <= PauseIR2;
                else 
                    Next_state <= S_18;
            S_32 : //CHOOSE THE FUCKING OPCODE
				case (Opcode)
					4'b0001 : //ADD
					    Next_state <= S_01;
					4'b0101 : // AND
						Next_state <= S_05;
					4'b1001 : // NOT
						Next_state <= S_09;
					4'b0000 : // BR
						Next_state = (BEN) ? S_22 : S_18;
					4'b1100 : // JMP
						Next_state <= S_12;
					4'b0100 : // JSR
						Next_state <= S_04;
					4'b0110 : // LDR
						Next_state <= S_06;
					4'b0111 : // STR
						Next_state <= S_07;
					4'b1101 : // PSE
						Next_state <= PauseIR1;
					default : 
					    Next_state <= S_18;
				endcase
				
            S_01 : //ADD
					Next_state <= S_18;
				S_05:	//AND
					Next_state <= S_18;
				S_09:	//NOT
					Next_state <= S_18;
				S_22:	//BR - 1
					//if n == IR[11] or if z == IR[10] or if p == IR[9]
					Next_state <= S_18;
				S_12:	//JMP
					Next_state <= S_18;
				S_04:	//JSR - 1 
					Next_state <= S_21;
				S_21:	//JSR - 2
					Next_state <= S_18;
				S_06:	//LDR - 1
					Next_state <= S_25_1;
				S_25_1: //LDR - 2
					Next_state <= S_25_2;
				S_25_2: //LDR - 3
					Next_state <= S_27;
				S_27: //LDR - 4
					Next_state <= S_18;
				S_07:	//STR - 1
					Next_state <= S_23;
				S_23: //STR - 2
					Next_state <= S_16_1;
				S_16_1: //STR - 3
					Next_state <= S_16_2;
				S_16_2: //STR - 3
					Next_state <= S_18;
			default : ;
	     endcase
    end
   
    always_comb
    begin 
        //default controls signal values; within a process, these can be
        //overridden further down (in the case statement, in this case)
	    LD_MAR = 1'b0;
	    LD_MDR = 1'b0;
	    LD_IR = 1'b0;
	    LD_BEN = 1'b0;
	    LD_CC = 1'b0;
	    LD_REG = 1'b0;
	    LD_PC = 1'b0;
		 
	    GatePC = 1'b0;
	    GateMDR = 1'b0;
	    GateALU = 1'b0;
	    GateMARMUX = 1'b0;
		 
		 ALUK = 2'b00;
		 
		 PCMUX = 2'b00;
		 DRMUX = 2'b00;
		 SR1MUX = 2'b00;
		 SR2MUX = 1'b0;
		 ADDR1MUX = 1'b0;
		 ADDR2MUX = 2'b00;
		 MARMUX = 1'b0;
		 
		 Mem_OE = 1'b1;
		 Mem_WE = 1'b1;
		 s
	case (State)
	Halted: ;
	S_18 : //FETCH - step 1
		begin 
			GatePC = 1'b1;
			LD_MAR = 1'b1;
			PCMUX = 2'b00;
			LD_PC = 1'b1;
		end
	
	S_33_1 : //FETCH - step 2
		begin
			Mem_OE = 1'b0;
		end
	
	S_33_2 : //FETCH - step 3
		begin 
			Mem_OE = 1'b0;
			LD_MDR = 1'b1;
		end
	
	S_35 : //FETCH - step 3
		begin 
			GateMDR = 1'b1;
			LD_IR = 1'b1;
		end
	
	PauseIR1: ;
	
	PauseIR2: ;
	
	S_32 : 
			LD_BEN = 1'b1;
	
	S_01 : //ADD
		begin 
			SR2MUX = IR_5;
			LD_CC = 1'b1;
			ALUK = 2'b00;
			GateALU = 1'b1;
			LD_REG = 1'b1;
		end
	
	S_05:	//AND
		begin
			LD_REG = 1'b1;
			LD_CC = 1'b1;
			ALUK = 2'b10;
			GateALU = 1'b1;
		end
	
	S_09:	//NOT
		begin
			LD_REG = 1'b1;
			LD_CC = 1'b1;
			ALUK = 2'b01;
			GateALU = 1'b1;
			SR2MUX = IR_5;
		end
	
	S_22:	//BR
		begin
			LD_PC = 1'b1;
			PCMUX = 2'b01;
			ADDR1MUX = 1'b1;
			ADDR2MUX = 2'b01;
		end
	
	S_12:	//JMP
		begin
			LD_PC = 1'b1;
			PCMUX = 2'b01;
			ADDR1MUX = 1'b0;
			ADDR2MUX = 2'b11;
		end
	
	S_04:	//JSR - step 1
		begin
			MARMUX = 1'b1;
			GateMARMUX = 1'b1;
			ADDR2MUX = 2'b00;
			ADDR1MUX = 1'b1;
		end
	
	S_21: //JSR - step 2
		begin
			DRMUX = 1'b1;
			LD_REG = 1'b1;
		end
	
	S_06:	//LDR - step 1
		begin
			MARMUX = 1'b1; 
			GateMARMUX = 1'b1;
			ADDR1MUX = 1'b0; 
			ADDR2MUX = 2'b10; 
			LD_MAR = 1'b1;
		end
	
	S_25_1: //LDR - step 2
		begin
			Mem_OE = 1'b0;
		end
	
	S_25_2: //LDR - step 3
		begin
			Mem_OE = 1'b0;
			LD_MDR = 1'b1;
		end
	
	S_27: //LDR - step 4
		begin
			LD_REG = 1'b1;
			LD_CC = 1'b1;
			GateMDR = 1'b1; 
		end
	
	S_07:	//STR - step 1
		begin
			LD_MAR = 1'b1;
			ADDR1MUX = 1'b0; 
			ADDR2MUX = 2'b10; 
			MARMUX = 1'b1; 
			GateMARMUX = 1'b1;
		end
	
	S_23: //STR - step 2
		begin
			SR1MUX = 1'b1; 
			ALUK = 2'b11;
			GateALU = 1'b1;
			LD_MDR = 1'b1;
		end
	
	S_16_1: //STR - step 3
		begin
			Mem_WE = 1'b0; 
			GateMDR = 1'b1; 
		end
	
	S_16_2: //STR - step 4
		begin
			Mem_WE = 1'b0; 
			GateMDR = 1'b1; 
		end
		
	S_16_3: //STR - step 5
		begin
			Mem_WE = 1'b0; 
			GateMDR = 1'b1; 
		end
	
	default : ;
	
	endcase
     end 

	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule