// testbench for lab2 part 1 -- basic alarm clock
// hours, minutes, and seconds
`include "display_tb_part1.sv"
module lab2__part1_tb #(parameter NS = 60, NH = 24);
  logic Reset    = 1,
        Clk      = 0,
        Timeset  = 0,
        Alarmset = 0,
        Minadv   = 0,
        Hrsadv   = 0,
        Alarmon  = 1,
        Pulse    = 0;
  wire[6:0] S1disp, S0disp,
            M1disp, M0disp;
  wire[6:0] , H0disp;
  wire Buzz;

  Top_Level #(.NS(NS),.NH(NH)) sd(.*);             // our DUT itself
  initial begin
	#  2us  Reset    = 0;
	#  1us  Timeset  = 1;
	        Minadv   = 1;
	# 50us  Minadv   = 0;
	       Hrsadv   = 1;
	#  7us  Timeset  = 0;
//	force (.sd.Min = 'h5);
//	release(.sd.Min);
    display_tb_part1 (.seg_d(),
    .seg_e(H0disp), .seg_f(M1disp),
    .seg_g(M0disp), .seg_h(S1disp),
    .seg_i(S0disp), .Buzz(Buzz));
	#  1us  Alarmset = 1;
	#  8us  Hrsadv   = 0;
	#  1us  Minadv   = 1;
	# 10us  Minadv   = 0;
	#  1us  Alarmset = 0;
    display_tb_part1 (.seg_d(),
    .seg_e(H0disp), .seg_f(M1disp),
    .seg_g(M0disp), .seg_h(S1disp),
    .seg_i(S0disp), .Buzz(Buzz));
    for(int i=0; i<1640; i++) 
	# 1us  display_tb_part1 (.seg_d(),
    .seg_e(H0disp), .seg_f(M1disp),
    .seg_g(M0disp), .seg_h(S1disp),
    .seg_i(S0disp),.Buzz(Buzz));
  	#1500us  $stop;
  end 
  always begin
    #500ns Pulse = 1;
	  #500ns Pulse = 0;
  end

endmodule