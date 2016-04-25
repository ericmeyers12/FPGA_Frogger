module  lab8 		( input         CLOCK_50,
                       input [3:0]         KEY, //bit 0 is set up as Reset
							         input [17:0]        SW, // used to seed PRNG
							         output [6:0]        HEX0, HEX1, //HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							         output [8:0]        LEDG,
							  //output [17:0] LEDR,
							  // VGA Interface
                       output [7:0]        VGA_R, //VGA Red
							                             VGA_G, //VGA Green
											                     VGA_B, //VGA Blue
							         output              VGA_CLK, //VGA Clock
							                             VGA_SYNC_N, //VGA Sync signal
											                     VGA_BLANK_N, //VGA Blank signal
											                     VGA_VS, //VGA virtical sync signal
											                     VGA_HS, //VGA horizontal sync signal
							  // CY7C67200 Interface
							         inout [15:0]        OTG_DATA, //	CY7C67200 Data bus 16 Bits
							         output [1:0]        OTG_ADDR, //	CY7C 67200 Address 2 Bits
							         output              OTG_CS_N, //	CY7C67200 Chip Select
											                     OTG_RD_N, //	CY7C67200 Write
											                     OTG_WR_N, //	CY7C67200 Read
											                     OTG_RST_N, //	CY7C67200 Reset
							         input               OTG_INT, //	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							         output [12:0]       DRAM_ADDR, // SDRAM Address 13 Bits
							         inout [31:0]        DRAM_DQ, // SDRAM Data 32 Bits
							         output [1:0]        DRAM_BA, // SDRAM Bank Address 2 Bits
							         output [3:0]        DRAM_DQM, // SDRAM Data Mast 4 Bits
							         output              DRAM_RAS_N, // SDRAM Row Address Strobe
							         output              DRAM_CAS_N, // SDRAM Column Address Strobe
							         output              DRAM_CKE, // SDRAM Clock Enable
							         output              DRAM_WE_N, // SDRAM Write Enable
							         output              DRAM_CS_N, // SDRAM Chip Select
							         output              DRAM_CLK, // SDRAM Clock,
                       output logic        SRAM_CE_N, UB, LB, SRAM_OE_N, SRAM_WE_N,
	                     output logic [19:0] SRAM_ADDR,
	                inout wire [15:0] SRAM_DQ //tristate buffers need to be of type wire
											);


    logic Reset_h, vssig, Clk;
    logic [9:0] drawxsig, drawysig, birdxsig, birdysig, birdsizesig;
	 logic [15:0] keycode;

	 assign VGA_VS = vssig;

	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low


	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;

//	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
//										 .from_sw_data_in(hpi_data_in),
//										 .from_sw_data_out(hpi_data_out),
//										 .from_sw_r(hpi_r),
//										 .from_sw_w(hpi_w),
//										 .from_sw_cs(hpi_cs),
//		 								 .OTG_DATA(OTG_DATA),
//										 .OTG_SRAM_ADDR(OTG_SRAM_ADDR),
//										 .OTG_RD_N(OTG_RD_N),
//										 .OTG_WR_N(OTG_WR_N),
//										 .OTG_CS_N(OTG_CS_N),
//										 .OTG_RST_N(OTG_RST_N),
//										 .OTG_INT(OTG_INT),
//										 .Clk(Clk),
//										 .Reset(Reset_h)
//	 );

	 //The connections for nios_system might be named different depending on how you set up Qsys
//	 nios_system nios_system(
//										 .clk_clk(Clk),
//										 .reset_reset_n(KEY[0]),
//										 .sdram_wire_addr(DRAM_SRAM_ADDR),
//										 .sdram_wire_ba(DRAM_BA),
//										 .sdram_wire_cas_n(DRAM_CAS_N),
//										 .sdram_wire_cke(DRAM_CKE),
//										 .sdram_wire_cs_n(DRAM_CS_N),
//										 .sdram_wire_dq(DRAM_DQ),
//										 .sdram_wire_dqm(DRAM_DQM),
//										 .sdram_wire_ras_n(DRAM_RAS_N),
//										 .sdram_wire_we_n(DRAM_SRAM_WE_N_N),
//										 .sdram_clk_clk(DRAM_CLK),
//										 .keycode_external_connection_export(keycode),
//										 .otg_hpi_address_external_connection_export(hpi_addr),
//										 .otg_hpi_data_external_connection_in_port(hpi_data_in),
//										 .otg_hpi_data_external_connection_out_port(hpi_data_out),
//										 .otg_hpi_cs_external_connection_export(hpi_cs),
//										 .otg_hpi_r_external_connection_export(hpi_r),
//										 .otg_hpi_w_external_connection_export(hpi_w));

	//Fill in the connections for the rest of the modules
    vga_controller vgasync_instance(.*, .Reset(Reset_h), .DrawX(drawxsig), .DrawY(drawysig), .vs(vssig), .hs(VGA_HS),
												  .pixel_clk(VGA_CLK), // 25 MHz pixel clock output
												  .blank(VGA_BLANK_N),     // Blanking interval indicator.  Active low.
												  .sync(VGA_SYNC_N));
   logic gameOn, ded;
	logic flap;
   logic [7:0] score, lastScore;
	logic SoftReset;
	assign SoftReset = ~(KEY[1]);
	
	always_ff @(posedge Clk or posedge SoftReset) begin	
		if (SoftReset)
			lastScore = 0;
		else if (score > lastScore) 
			lastScore = score;
		else 
			lastScore = lastScore;	
	end
		
   logic [3:0][12:0] pipeX, pipeWidth, pipeGapSize, pipeGapLocation;
   generate // start of generate block
      genvar i;

      for (i=0; i<4; i=i+1) begin: pipe_i
         pipe pipe_instance(.clk(vssig),
                            .Reset(Reset_h),
									 .SoftReset(SoftReset),
                            .startX((12'd639+12'd25) + i*12'd154),
									 .switches(SW[7:0]*(i+1)),
                            .currentX(pipeX[i]),
                            .width(pipeWidth[i]),
                            .gapSize(pipeGapSize[i]),
                            .gapLocation(pipeGapLocation[i]),
                            .gameOn(gameOn));
      end
   endgenerate
										  
	 logic[7:0] last_keycode;
	 logic space;
	 //assign space = keycode == 16'h2C ? 1'b1 : 1'b0;
	 assign space = ~KEY[3];
	 assign LEDG[2] = space;
	 assign LEDG[3] = last_keycode == 16'h2C ? 1'b1 : 1'b0; // space

	 HexDriver hex_inst_0 (lastScore[3:0], HEX0);
	 HexDriver hex_inst_1 (lastScore[7:4], HEX1);

	 always_ff @ (posedge Clk)
		begin
			last_keycode <= (keycode == 16'h0) ? last_keycode : keycode;
		end

   logic [15:0]                            MDR_In;
   logic [19:0]                            MAR;
   logic [15:0]                            MDR, LAST_MDR;
   logic [15:0]                            Data_Mem_In, Data_Mem_Out;
   logic [15:0]                            zeroSig;
   logic                                   MIO_EN;
   assign MIO_EN = ~SRAM_OE_N;

   assign zeroSig = 16'b0;

   assign SRAM_ADDR = { 4'b00, MAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16

   assign SRAM_OE_N = 1'b0;

   logic [19:0]                            vgaPosCounter;

   always_ff @(posedge VGA_CLK or posedge Reset_h) begin
      if (Reset_h) begin
         vgaPosCounter <= 19'b0;
      end else begin
         if (vgaPosCounter >= 19'd307199)
           vgaPosCounter <= 19'b0;
         else
			     if (VGA_BLANK_N) begin
              LAST_MDR <= MDR;
					    vgaPosCounter <= vgaPosCounter + 1'b1;
           end
      end
   end // always_ff @

   assign MAR = vgaPosCounter;

   always_ff @(posedge Clk) begin
         MDR <= MDR_In;
   end

   assign SRAM_WE_N = 1'b1;
   assign SRAM_CE_N = 1'b0;
	 assign UB = 1'b0;
	 assign LB = 1'b0;

   Mem2IO memory_subsystem(.Clk(Clk), .LB(LB), .UB(UB), .Data_Mem_Out(Data_Mem_Out),
									.Data_Mem_In(Data_Mem_In), .Switches(zeroSig), .CE(SRAM_CE_N), .OE(SRAM_OE_N), .WE(SRAM_WE_N),
	                        .Reset(Reset_h), .A(SRAM_ADDR),
	                        .Data_CPU_In(MDR), .Data_CPU_Out(MDR_In)
                           );

   // Break the tri-state bus to the ram into input/outputs
   tristate #(.N(16)) tr0(
	                        .Clk(Clk), .OE(~SRAM_WE_N), .In(Data_Mem_Out), .Out(Data_Mem_In), .Data(SRAM_DQ)
                          );

	 bird bird_instance(.*, .Reset(Reset_h), .frame_clk(vssig), .BirdX(birdxsig), .BirdY(birdysig), .BirdS(birdsizesig));
   flapper flap_instance(.Clk(vssig), .flap(flap));

   // The .* includes pipe information
   gamestate game(.*, .BirdX(birdxsig), .BirdY(birdysig), .Bird_size(birdsizesig), .clk(vssig), .gameOn(gameOn), .Reset(Reset_h), .space(space));


   // The .* includes pipe information
   color_mapper color_instance(.*, .BirdX(birdxsig), .BirdY(birdysig), .DrawX(drawxsig), .DrawY(drawysig), .Bird_size(birdsizesig),
                               .Red(VGA_R), .Green(VGA_G), .Blue(VGA_B), .flap(flap), .backgroundIdx(LAST_MDR));


endmodule
