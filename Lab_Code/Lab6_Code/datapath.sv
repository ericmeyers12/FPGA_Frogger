module datapath(  input Clk, Reset_ah,
						input logic GateMARMUX, GatePC, GateALU, GateMDR, LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
						input logic SR2MUX, ADDR1MUX, MARMUX, MIO_EN,
						input logic BEN,
						input logic [1:0] PCMUX, DRMUX, SR1MUX, ADDR2MUX, ALUK,
						input logic [15:0] MDR_In,
						
						output logic [15:0] MAR, MDR, IR
);

logic [15:0] PC_databus, MDR_databus;
logic [15:0] PC_REG_OUT, PC_D_OUT, PC_MUX_OUT, MDR_D_OUT, IO_MUX_OUT;


/**** PC MODULE ****/
tristate_buffer PC_OUT(.D_In(PC_REG_OUT), .select(GatePC), .D_Out(PC_databus));

register_16_bit PC_REG(.*, .reset(Reset_ah), .load_enable(LD_PC), .D_In(PC_MUX_OUT), .D_Out(PC_REG_OUT));

three_one_mux_16 PC_MUX(.*, .D_In1(PC_REG_OUT + 1'b1),.D_In2(16'b0/*ADDER*/), .D_In3(databus), .select(PCMUX), .D_Out(PC_MUX_OUT));



/****MDR/MAR MODULE ****/
//---MDR
tristate_buffer MDR_OUT(.D_In(MDR), .select(GateMDR), .D_Out(MDR_databus));

register_16_bit MDR_REG(.*, .reset(Reset_ah), .load_enable(LD_MDR), .D_In(IO_MUX_OUT), .D_Out(MDR));

two_one_mux_16 IO_MUX(.D_In1(PC_databus), .D_In2(MDR_In), .select(MIO_EN), .D_Out(IO_MUX_OUT));

//---MAR
register_16_bit MAR_REG(.*, .reset(Reset), .load_enable(LD_MAR), .D_In(PC_databus), .D_Out(MAR));


/**** INSTRUCTION REGISTER MODULE */
register_16_bit IR_REG(.*, .reset(Reset_ah), .load_enable(LD_IR), .D_In(MDR_databus), .D_Out(IR));


endmodule