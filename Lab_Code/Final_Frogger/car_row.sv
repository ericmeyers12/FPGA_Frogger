//-------------------------------------------------------------------------
//    Car.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  car_row ( input Reset, frame_clk,
						input [10:0] CarY, 
						input [1:0] Number_Cars,
						input [7:0] Gap_Size,
						input [4:0] Speed,
						input Direction,
						output logic [1:0][63:0] Car_Start_X
				 );
				 
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
    
   
endmodule