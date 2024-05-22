// simple starter test bench for 2-street traffic light controllers
module h_h_tlc_tb();

  logic     clk = 'b0, reset = 'b1, 
            Ta  = 'b0, Tb    = 'b0;
  wire[1:0] La, Lb;			// light drivers (green, yellow, red)
  typedef enum logic[1:0] {green,yellow,red} light;	  // default: green=0, yellow=1, red=2
  light lA, lB;				// lA and lB are of type "light," defined in typedef enum logic ...
// instantiate DUT itself
  h_h_tlc hh1(
  .clk, .reset, .Ta, .Tb, .La, .Lb);

  assign lA = light'(La);	// cast binary La as enum lA -- A street traffic signal
  assign lB = light'(Lb);

  always begin
	#5ns clk = 'b1;	        // device active edges come at times 5, 15, 25, ...
	#5ns clk = 'b0;
  end

  initial begin
    #10ns reset = 'b0;
  	#30ns Ta = 'b1;		    // test bench changes come at times 10, 20, 30 ...
    #20ns Tb = 'b1; 		//   avoids potential for setup/hold violations, race conditions
	#10ns Ta = 'b0;
	#30ns Tb = 'b0;
    #50ns $stop;  	 
  end    

endmodule