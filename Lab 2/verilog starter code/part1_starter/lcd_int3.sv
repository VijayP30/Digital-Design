// 1. convert binary to binary coded decimal 
// 2. convert BCD to 7-segment LED/LCD/etc. display
module lcd_int(
  input[6:0] bin_in,
  output logic [6:0] Segment1,
                     Segment0);

  logic[3:0] bin0;			  // binary to binary coded decimal (BCD)
  assign bin0 = bin_in % 10;  // mod10   LSD
  logic[3:0] bin1;
  assign bin1 = bin_in/10;
/* alternative if can't synthesize modulus operator, %:
  logic[3:0] bin1;
  assign bin1 = bin_in/10;		  // why?
  logic[3:0] bin0;
  assign bin0 = bin_in - 10*bin1; // why?
*/
  
// mapping of BCD to 7-segment layout
  always_comb case(bin0) 
    4'b0000 : Segment0 = 7'h7E;	   // 0: all 6 outer segments light up; center horizontal bar doesn't
    4'b0001 : Segment0 = 7'h30;	   // 1: two rightmost vertical segments light up
    4'b0010 : Segment0 = 7'h6D;				  
    4'b0011 : Segment0 = 7'h79;				  
    4'b0100 : Segment0 = 7'h33;          	  
    4'b0101 : Segment0 = 7'h5B;
    4'b0110 : Segment0 = 7'h5F;
    4'b0111 : Segment0 = 7'h70;	   // 7: top and two right most vertical segments light up
    4'b1000 : Segment0 = 7'h7F;	   // 8: all 7 segments light up
    4'b1001 : Segment0 = 7'h7B;
	default : Segment0 = 7'h00;
  endcase
    always_comb case(bin1) 
    4'b0000 : Segment1 = 7'h7E;
    4'b0001 : Segment1 = 7'h30;
    4'b0010 : Segment1 = 7'h6D;
    4'b0011 : Segment1 = 7'h79;
    4'b0100 : Segment1 = 7'h33;          
    4'b0101 : Segment1 = 7'h5B;
    4'b0110 : Segment1 = 7'h5F;
    4'b0111 : Segment1 = 7'h70;
    4'b1000 : Segment1 = 7'h7F;
    4'b1001 : Segment1 = 7'h7B;
	default : Segment1 = 7'h00;
  endcase

endmodule

