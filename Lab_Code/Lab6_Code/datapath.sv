module datapath(  input Clk, Reset_ah,
						input logic GateMARMUX, GatePC, GateALU, GateMDR, LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
						input logic SR2MUX, ADDR1MUX, MARMUX, MIO_EN,
						input logic [1:0] PCMUX, DRMUX, SR1MUX, ADDR2MUX, ALUK,
						input logic [15:0] MDR_In,
						output logic BEN,
						output logic [15:0] MAR, MDR, IR
);

logic [15:0] PC_databus, MDR_databus, MARMUX_databus, ALU_databus, databus;
logic [1:0] select_bus;

always_comb
begin
	if (GatePC)
		select_bus = 2'b00;
	else if (GateMARMUX)
		select_bus = 2'b01;
	else if (GateMDR)
		select_bus = 2'b10;
	else if (GateALU)
		select_bus = 2'b11;
	else
		select_bus = 2'bxx;
end

four_one_mux_16_bus busssssssspussy(.D_In1(PC_databus), .D_In2(MARMUX_databus), .D_In3(MDR_databus), .D_In4(ALU_databus), .select(select_bus), .D_Out(databus));

logic [15:0] PC_REG_OUT, PC_MUX_OUT, MDR_D_OUT, IO_MUX_OUT, SR1_OUT, SR2_OUT, MARMUX_ADDER_OUT;


/**** PC MODULE ****/
tristate_buffer PC_OUT(.D_In(PC_REG_OUT), .select(GatePC), .D_Out(PC_databus));

register_16_bit PC_REG(.*, .reset(Reset_ah), .load_enable(LD_PC), .D_In(PC_MUX_OUT), .D_Out(PC_REG_OUT));

three_one_mux_16 PC_MUX(.*, .D_In1(PC_REG_OUT + 1'b1),.D_In2(MARMUX_ADDER_OUT), .D_In3(databus), .select(PCMUX), .D_Out(PC_MUX_OUT));



/****MDR/MAR MODULE ****/
//---MDR
tristate_buffer MDR_OUT(.D_In(MDR), .select(GateMDR), .D_Out(MDR_databus));

register_16_bit MDR_REG(.*, .reset(Reset_ah), .load_enable(LD_MDR), .D_In(IO_MUX_OUT), .D_Out(MDR));

two_one_mux_16 IO_MUX(.D_In1(databus), .D_In2(MDR_In), .select(MIO_EN), .D_Out(IO_MUX_OUT));

//---MAR
register_16_bit MAR_REG(.*, .reset(Reset), .load_enable(LD_MAR), .D_In(databus), .D_Out(MAR));


/**** INSTRUCTION REGISTER MODULE */
register_16_bit IR_REG(.*, .reset(Reset_ah), .load_enable(LD_IR), .D_In(databus), .D_Out(IR));



/**** MARMUX UNIT ****/
logic [15:0] ADDR2MUX_INPUT_1, ADDR2MUX_INPUT_2, ADDR2MUX_INPUT_3, ADD_IN_1, ADD_IN_2;

sext_6 sext_6_unit(.D_In(IR[5:0]), .D_Out(ADDR2MUX_INPUT_3));
sext_9 sext_9_unit(.D_In(IR[9:0]),.D_Out(ADDR2MUX_INPUT_2));
sext_11 sext_11_unit(.D_In(IR[11:0]),.D_Out(ADDR2MUX_INPUT_1));

four_one_mux_16 adder2mux_unit(.D_In1(ADDR2MUX_INPUT1), .D_In2(ADDR2MUX_INPUT2), .D_In3(ADDR2MUX_INPUT_3), .D_In4(16'b0), .select(ADDR2MUX), .D_Out(ADD_IN_1));
two_one_mux_16 adder1mux_unit(.D_In1(SR1_OUT), .D_In2(PC_REG_OUT), .select(ADDR1MUX), .D_Out(ADD_IN_2));

adder_16_bit adder_unit(.D_In1(ADD_IN_1), .D_In2(ADD_IN_2), .D_Out(MARMUX_ADDER_OUT));
tristate_buffer marmux_buffer(.D_In(MARMUX_ADDER_OUT), .D_Out(MARMUX_databus));


/**** ALU ****/
logic [15:0] SR2_MUX_IN_1, SR2_MUX_OUT, ALU_OUT;

sext_5 sext_5_unit(.D_In(IR[4:0]), .D_Out(SR2_MUX_IN_1));

two_one_mux_16 sr2_mux(.D_In1(SR2_MUX_IN_1), .D_In2(SR2_OUT), .select(SR2MUX), .D_Out(SR2_MUX_OUT));
ALU main_alu(.A_In(SR1_OUT), .B_In(SR2_MUX_OUT), .F(ALUK), .D_Out(ALU_OUT));

tristate_buffer ALU_buffer(.D_In(ALU_OUT), .D_Out(ALU_databus));


/**** REGISTER FILE ****/
logic [2:0] DRMUX_OUT, SR1MUX_OUT;
two_one_mux_3 DR_MUX(.D_In1(IR[11:9]), .D_In2(1'b111), .select(DRMUX), .D_Out(DRMUX_OUT));
two_one_mux_3 SR1_MUX(.D_In1(IR[11:9]), .D_In2(IR[8:6]), .select(SR1MUX), .D_Out(SR1MUX_OUT));

reg_file registers(.*, .Reset(Reset_ah), .LD_REG, .databus, .DR(DRMUX_OUT), .SR1(SR1MUX_OUT), .SR2(SR2), .SR1_OUT, .SR2_OUT);


/**** NZP ****/
NZP_Reg nzp_control(.*, .Reset(Reset_ah), .LD_CC, .databus, .NZP(IR[11:9]), .BEN);


endmodule