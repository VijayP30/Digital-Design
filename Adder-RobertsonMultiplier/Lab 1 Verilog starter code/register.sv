// load and store register
// sequential NOT combinational
module register # (parameter N = 8)
   (input                clk,   // implied input wire
    input                load,
    input                clear,
    input        [N-1:0] in,
    output logic [N-1:0] out
    );
	 
  always_ff @ (posedge clk, posedge clear)    begin
  // fill in guts
  //  if(...) out <= ... ;          // use <= nonblocking assignment!
  //  else if(...) out <= ... ;
  //   clear   load    out
  // 	   1       0      0	   (clear output)
  //     1       1      0
  //     0       0     hold  (no change in output)
  //     0       1      in   (update output)
    if (clear) // if clear is true, set out to 0
      out <= 0;
    else if (load) // if clear is false and load is true, set out to in
      out <= in;

    
  // Aside: What would be the impact of leaving posedge clear out of 
  //  the sensitivity list?
  //  The clear signal would not be recognized as a trigger to update the output.
  end	
		
endmodule

