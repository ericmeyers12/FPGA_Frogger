//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  final_frogger_top ( input         CLOCK_50,
								  input[3:0]    KEY, //bit 0 is set up as Reset
								  output [6:0]  HEX0, HEX1,// HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
								  output [8:0]  LEDG,
								  //output [17:0] LEDR,
								  // VGA Interface 
								  output [7:0]  VGA_R,					//VGA Red
													 VGA_G,					//VGA Green
													 VGA_B,					//VGA Blue
								  output        VGA_CLK,				//VGA Clock
													 VGA_SYNC_N,			//VGA Sync signal
													 VGA_BLANK_N,			//VGA Blank signal
													 VGA_VS,					//VGA virtical sync signal	
													 VGA_HS,					//VGA horizontal sync signal
								  // CY7C67200 Interface
								  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
								  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
								  output        OTG_CS_N,						//	CY7C67200 Chip Select
													 OTG_RD_N,						//	CY7C67200 Write
													 OTG_WR_N,						//	CY7C67200 Read
													 OTG_RST_N,						//	CY7C67200 Reset
								  input			 OTG_INT,						//	CY7C67200 Interrupt
								  // SDRAM Interface for Nios II Software
								  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
								  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
								  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
								  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
								  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
								  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
								  output			 DRAM_CKE,				// SDRAM Clock Enable
								  output			 DRAM_WE_N,				// SDRAM Write Enable
								  output			 DRAM_CS_N,				// SDRAM Chip Select
								  output			 DRAM_CLK				// SDRAM Clock
									);
    
    logic Reset_h, vssig, Clk;
    logic [10:0] drawxsig, drawysig, 
					 frogxsig, frogysig, frogwidthsig, frogheightsig,
					 lpad1xsig, lpad1ysig, lpad1widthsig, lpad1heightsig, lpadmotionxsig;
					 
	 logic [3:0] carcollisionsig, lpadcollisionsig;

	 logic [15:0] keycode;
	 logic left, right, up, down;
	 
	 assign VGA_VS = vssig;
    
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
	
	 
	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),         
										 .reset_reset_n(KEY[0]),   
										 .sdram_wire_addr(DRAM_ADDR), 
										 .sdram_wire_ba(DRAM_BA),   
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),  
										 .sdram_wire_cs_n(DRAM_CS_N), 
										 .sdram_wire_dq(DRAM_DQ),   
										 .sdram_wire_dqm(DRAM_DQM),  
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N), 
										 .sdram_out_clk(DRAM_CLK),
										 .keycode_export(keycode),  
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w)
										 );
	
	//Fill in the connections for the rest of the modules 
    vga_controller vgasync_instance(.Clk, 
												.Reset(Reset_h), 
												.hs(VGA_HS), 
												.vs(vssig), 
												.pixel_clk(VGA_CLK), 
												.blank(VGA_BLANK_N),  
												.sync(VGA_SYNC_N),
												.DrawX(drawxsig),
												.DrawY(drawysig)
												);

	 frog frog_instance(.Reset(Reset_h), 
							  .frame_clk(vssig),
							  .FrogX(frogxsig),
							  .FrogY(frogysig),
							  .Frog_Width(frogwidthsig),
							  .Frog_Height(frogheightsig),
							  .LPad_MotionX(lpadmotionxsig),
							  .up, 
							  .down, 
							  .left, 
							  .right
							  );
		
	  logic [3:0] [10:0] carrow1_xsig,carrow1_ysig;
	  car_row car_row_instance1(.Reset(Reset_h),
										.frame_clk(vssig),
										.Number_Cars(3'd3),
										.Gap_Size(8'd80),
										.Speed(5'd5),
										.Direction(1'b1), 
										.Car_Start_Y(11'd240),
										.Car_X(carrow1_xsig), 	
										.Car_Y(carrow1_ysig),
										.Frog_X(frogxsig),
										.Frog_Y(frogysig),
										.Car_Collision(carcollisionsig[0]));
					

		logic [3:0] [10:0] carrow2_xsig,carrow2_ysig;
	 	car_row car_row_instance2(.Reset(Reset_h),
										.frame_clk(vssig),
										.Number_Cars(3'd4),
										.Gap_Size(8'd80),
										.Speed(5'd10),
										.Direction(1'b0), 
										.Car_Start_Y(11'd280),
										.Car_X(carrow2_xsig), 	
										.Car_Y(carrow2_ysig),
										.Frog_X(frogxsig),
										.Frog_Y(frogysig),
										.Car_Collision(carcollisionsig[1]));
		
		logic [3:0] [10:0] carrow3_xsig,carrow3_ysig;
	 	car_row car_row_instance3(.Reset(Reset_h),
										.frame_clk(vssig),
										.Number_Cars(3'd3),
										.Gap_Size(8'd80),
										.Speed(5'd15),
										.Direction(1'b1), 
										.Car_Start_Y(11'd320),
										.Car_X(carrow3_xsig), 	
										.Car_Y(carrow3_ysig),
										.Frog_X(frogxsig),
										.Frog_Y(frogysig),
										.Car_Collision(carcollisionsig[2]));
								
	 lilypad lpad_inst1( .Reset(Reset_h),
								.frame_clk(vssig),
								.LPadX(lpad1xsig),
								.LPadY(lpad1ysig),
								.LPad_Width(lpad1widthsig),
								.LPad_Height(lpad1heightsig),
								.LPad_Start_X(11'd680),
								.LPad_Start_Y(11'd80),
								.LPad_MotionX(lpadmotionxsig),
								.Frog_X(frogxsig),
								.Frog_Y(frogysig),
								.LPad_Collision(lpadcollisionsig[0]),
								.Direction(2'd0)
	);
	
	
    color_mapper color_instance(.FrogX(frogxsig), 
										  .FrogY(frogysig), 
										  .DrawX(drawxsig), 
										  .DrawY(drawysig), 
										  .Frog_Width(frogwidthsig),
										  .Frog_Height(frogheightsig),
										  .Car_Row1_X(carrow1_xsig),
										  .Car_Row1_Y(carrow1_ysig),
										  .Row1_Number_Cars(3'd3),
										  .Car_Row2_X(carrow2_xsig),
										  .Car_Row2_Y(carrow2_ysig),
										  .Row2_Number_Cars(3'd4),
										  .Car_Row3_X(carrow3_xsig),
										  .Car_Row3_Y(carrow3_ysig),
										  .Row3_Number_Cars(3'd3),
										  .LPad1X(lpad1xsig),
										  .LPad1Y(lpad1ysig),
										  .LPad1_Width(lpad1widthsig),
										  .LPad1_Height(lpad1heightsig),
										  .LPad_Collision(lpadcollisionsig),
										  .Car_Collision(carcollisionsig),
										  .Red(VGA_R), 
										  .Green(VGA_G), 
										  .Blue(VGA_B)
										  );
						
		//Previous keycode, and logic left, right, up, down
		logic[7:0] keycode_prev;
		
		//Assigning Keycodes to left,down,right,and up - ARROW KEYS
		//				<^>
		//		<<>   <v>   <>>
		assign left = keycode == 16'h50 ? 1'b1 : 1'b0;
		assign right = keycode == 16'h4f ? 1'b1 : 1'b0;
		assign up = keycode == 16'h52 ? 1'b1 : 1'b0;
		assign down = keycode == 16'h51 ? 1'b1 : 1'b0;
		
		//Assign previous keycodes based on functionality (only one key at a time)
		assign LEDG[0] = keycode_prev == 16'h4f ? 1'b1 : 1'b0; // right
		assign LEDG[1] = keycode_prev == 16'h51 ? 1'b1 : 1'b0; // down
		assign LEDG[2] = keycode_prev == 16'h52 ? 1'b1 : 1'b0; // up
		assign LEDG[3] = keycode_prev == 16'h50 ? 1'b1 : 1'b0; // left
		
		//Update Hex Drivers
		HexDriver hex_inst_0 (keycode[3:0], HEX0);
		HexDriver hex_inst_1 (keycode[7:4], HEX1);
			
		//Update 
		always_ff @ (posedge Clk)
			begin
				keycode_prev <= (keycode == 16'h0) ? keycode_prev : keycode;
			end
endmodule