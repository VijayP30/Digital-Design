// micro-program counter, asynchronous reset
// Active high load
// Active low increment
module upcreg(
  input              clk,
  input              reset,
  input              load_incr,
  input [4:0]        upc_next,
  output logic [4:0] upc);

  always_ff @ (posedge clk, posedge reset) begin
  // fill in guts
  //   if(...) upc <= ...; else if(...) upc <= ...; else ... 
  //   reset    load_incr	    upc
  //     1		    1			      0
  //	   1		    0           0
  //	   0		    1		      upc_next
  //	   0	      0          upc+1
    if (reset) // if reset is true, set upc to 0
      upc <= 0;
    else if (load_incr) // if reset is false and load_incr is true, set upc to upc_next
      upc <= upc_next;
    else // if reset and load_incr are false, increment upc by 1
      upc <= upc + 1;
  end
endmodule    