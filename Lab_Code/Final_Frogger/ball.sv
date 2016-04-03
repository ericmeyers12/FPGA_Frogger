//-------------------------------------------------------------------------
//    Ball.sv                                                            --
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


module  ball ( input Reset, frame_clk,
               output [9:0]  BallX, BallY, BallS,
					input up, down, left, right);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Start=320;  // Start position on the X axis
    parameter [9:0] Ball_Y_Start=50;  // Start position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=10;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=10;      // Step size on the Y axis

    assign Ball_Size = 8;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Start;
				Ball_X_Pos <= Ball_X_Start;
        end
           
        else 
        begin 
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion <= Ball_Y_Step;
				 else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the right edge, BOUNCE!
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the left edge, BOUNCE!
					  Ball_X_Motion <= Ball_X_Step;  
				 else 
				begin
					if(up)//RIGHT BUTTON PRESSED = "W"
					begin
						Ball_X_Pos <= 
						Ball_X_Motion <= 10'b0;
						Ball_Y_Motion <= ~(Ball_Y_Step) + 1;
					end
					else if(down) //DOWN BUTTON PRESSED = "S"
					begin
						Ball_X_Motion <= 10'b0;
						Ball_Y_Motion <= Ball_Y_Step;
					end
					else if(left) //LEFT BUTTON PRESSED = "A"
					begin
						Ball_Y_Motion <= 10'b0;
						Ball_X_Motion <= ~(Ball_X_Step) + 1;
					end
					else if(right) //RIGHT BUTTON PRESSED = "D"
					begin
						Ball_Y_Motion <= 10'b0;
						Ball_X_Motion <= Ball_X_Step;
					end
					else //DEFAULT CASE - KEEP MOTION SAME
					begin
						Ball_Y_Motion <= 10'b0;
						Ball_X_Motion <= 10'b0;
					end
			end	 
			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
		end
	end
	
	assign BallX = Ball_X_Pos;
	assign BallY = Ball_Y_Pos;
	assign BallS = Ball_Size;
    
endmodule