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

	 logic [10:0] drawxsig, drawysig;
	 
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
	 /* ============== FROG, CAR, AND LILYPAD MODULES BELOW ==============*/					
	 logic [10:0] frogxsig, frogysig, frogwidthsig, frogheightsig,
					 lpad1xsig, lpad1ysig, lpad1widthsig, lpad1heightsig;
					 
	 logic [3:0] carcollisionsig;
	 logic [3:0] lpadcollisionsig;
	 
	 /*4 Cars in Each Row * X Position (Top-Left) for each car*/
	 logic [3:0] [10:0] carrow_xsig [3:0];
	 logic [3:0] [10:0] carrow_ysig [3:0]; 
	 logic [3:0] [10:0] lpadrow_xsig [3:0];
	 logic [3:0] [10:0] lpadrow_ysig [3:0];
	 
	 logic [1:0] curfrogdir;
	 
	 logic [3:0] [5:0] LPad_Remainder_Count;

	 /*===== Car Parameters =====*/
	 parameter bit [2:0] Number_Cars_Row [0:3] = '{3'd4, 
																  3'd4, 
																  3'd4,
																  3'd4};

	 
	 parameter bit [7:0] Gap_Size_Cars_Row [0:3] = '{8'd80,
																    8'd80,
																    8'd80,
																    8'd80};
														
	 parameter bit [5:0] Speed_Cars_Row [0:3] = '{5'd20,
															    5'd15,
															    5'd10,
															    5'd5};

	 parameter bit Direction_Cars_Row [0:3] = '{1'b1,
															  1'b0,
															  1'b1,
															  1'b0};
														
	 parameter bit [10:0] Start_Y_Cars_Row [0:3] = '{11'd400,
																    11'd360,
																    11'd320,
																    11'd280};
	
	/*===== Lilypad Parameters =====*/
	 parameter bit [2:0] Number_LPad_Row [0:3] = '{3'd4, 
																  3'd4, 
																  3'd4,
																  3'd4};

	 
	 parameter bit [7:0] Gap_Size_LPad_Row [0:3] = '{8'd80,
																	 8'd80,
																    8'd80,
																	 8'd80};
														
	 parameter bit [5:0] Speed_LPad_Row [0:3] = '{5'd15,
																 5'd20,
															    5'd25,
															    5'd30};

	 parameter bit Direction_LPad_Row [0:3] = '{1'b1,
															  1'b0,
															  1'b1,
															  1'b0};
														
	 parameter bit [10:0] Start_Y_LPad_Row [0:3] = '{11'd80,
																    11'd120,
																    11'd160,
																    11'd200};
	 

	 
							  
		generate
      genvar i;
		for (i = 0; i <= 2'd3; i = i + 1) 
		begin: car_row_i
			car_row car_row_instance1(.Reset(Reset_h),
									.frame_clk(vssig),
									.Number_Cars(Number_Cars_Row[i]),
									.Gap_Size(Gap_Size_Cars_Row[i]),
									.Speed(Speed_Cars_Row[i]),
									.Direction(Direction_Cars_Row[i]), 
									.Car_Start_Y(Start_Y_Cars_Row[i]),
									.Car_X(carrow_xsig[i]), 	
									.Car_Y(carrow_ysig[i]),
									.Frog_X(frogxsig),
									.Frog_Y(frogysig),
									.Car_Collision(carcollisionsig[i]));
		end
		endgenerate	 
		
	
		generate
      genvar j;
		for (j = 0; j <= 2'd3; j = j + 1) 
		begin: lpad_row_j
			lilypad_row lilypad_row (.Reset(Reset_h), 
						.frame_clk(vssig),
						.Number_LPads(Number_LPad_Row[j]),
						.Gap_Size(Gap_Size_LPad_Row[j]),
						.Speed(Speed_LPad_Row[j]),
						.LPad_Remainder_Count(LPad_Remainder_Count[j]),
						.Direction(Direction_LPad_Row[j]), 
						.LPad_Start_Y(Start_Y_LPad_Row[j]),
						.LPad_X(lpadrow_xsig[j]), 	
						.LPad_Y(lpadrow_ysig[j]),
						.Frog_X(frogxsig),
						.Frog_Y(frogysig),
						.LPad_Collision(lpadcollisionsig[j])
				 );
		end
		endgenerate	 		
		
		frog frog_instance(.Reset(Reset_h), 
							  .frame_clk(vssig),
							  .FrogX(frogxsig),
							  .FrogY(frogysig),
							  .Frog_Width(frogwidthsig),
							  .Frog_Height(frogheightsig),
							  .up, 
							  .down, 
							  .left, 
							  .right,
							  .Car_Collision(carcollisionsig),
							  .LPad_Speed(Speed_LPad_Row),
							  .LPad_Remainder_Count,
							  .LPad_Direction(Direction_LPad_Row),
							  .LPad_Collision(lpadcollisionsig),
							  .cur_Frog_Direction(curfrogdir)
							  );


	
    color_mapper color_instance(.FrogX(frogxsig), 
										  .FrogY(frogysig), 
										  .DrawX(drawxsig), 
										  .DrawY(drawysig), 
										  .Frog_Width(frogwidthsig),
										  .Frog_Height(frogheightsig),
										  .Car_Row1_X(carrow_xsig[0]),
										  .Car_Row1_Y(carrow_ysig[0]),
										  .Row1_Number_Cars(Number_Cars_Row[0]),
										  .Car_Row2_X(carrow_xsig[1]),
										  .Car_Row2_Y(carrow_ysig[1]),
										  .Row2_Number_Cars(Number_Cars_Row[1]),
										  .Car_Row3_X(carrow_xsig[2]),
										  .Car_Row3_Y(carrow_ysig[2]),
										  .Row3_Number_Cars(Number_Cars_Row[2]),
										  .Car_Row4_X(carrow_xsig[3]),
										  .Car_Row4_Y(carrow_ysig[3]),
										  .Row4_Number_Cars(Number_Cars_Row[3]),
										  .LPad_Row1_X(lpadrow_xsig[0]),
										  .LPad_Row1_Y(lpadrow_ysig[0]),
										  .Row1_Number_LPads(Number_LPad_Row[0]),
										  .LPad_Row2_X(lpadrow_xsig[1]),
										  .LPad_Row2_Y(lpadrow_ysig[1]),
										  .Row2_Number_LPads(Number_LPad_Row[1]),
										  .LPad_Row3_X(lpadrow_xsig[2]),
										  .LPad_Row3_Y(lpadrow_ysig[2]),
										  .Row3_Number_LPads(Number_LPad_Row[2]),
										  .LPad_Row4_X(lpadrow_xsig[3]),
										  .LPad_Row4_Y(lpadrow_ysig[3]),
										  .Row4_Number_LPads(Number_LPad_Row[3]),
										  .LPad_Collision(lpadcollisionsig),
										  .Car_Collision(carcollisionsig),
										  .up, .down, .left, .right,
										  .cur_Frog_Direction(curfrogdir),
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