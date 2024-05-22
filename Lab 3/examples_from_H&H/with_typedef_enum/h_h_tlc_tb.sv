// simple starter test bench for 2-street traffic light controllers
// import global variables (definition of "colors")
import light_package::*;

module h_h_tlc_tb();

  logic     clk = 'b0, reset = 'b1, 
            Ta  = 'b0, Tb    = 'b0;
  colors    La, Lb;			// light drivers (green, yellow, red)
// instantiate DUT itself
  h_h_tlc hh1(.clk, .reset, .Ta, .Tb, 
               .La, .Lb);	// outputs

  always begin
	#5ns clk = 'b1;	        // device active edges come at times 5, 15, 25, ...
	#2ns $display("%b %b %s %s",Ta,Tb,La,Lb); 
	#3ns clk = 'b0;
  end

  initial begin
    $display("Ta Tb La Lb");
    #10ns reset = 'b0;
  	#30ns Ta = 'b1;		    // test bench changes come at times 10, 20, 30 ...
    #20ns Tb = 'b1; 		//   avoids potential for setup/hold violations, race conditions
	#10ns Ta = 'b0;
	#30ns Tb = 'b0;
    #50ns $stop;  	 
  end    

endmodule