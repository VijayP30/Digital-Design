// 5:1 MULTIPLEXER	(combinational 5-way switch)
module mux5 (input        d0, d1, d2, d3, d4,
             input [2:0]  s, 
             output logic y);

    always_comb begin   // always @(*)    // always @(d0, d1, d2, d3, d4, s);
    // fill in guts
    // when using always_comb, be sure to cover all cases & use =, not <=
    // case(s)
    //     0: y = ...;
    //	 ...
    //	 default: y = ...;  // shorthand for last N cases with same output
    // endcase
    //  s      y
    //  0	  d0		s = 3'b000
    //  1	  d1
    //  2	  d2
    //  3	  d3
    //  4	  d4
    //  5	   0
    //  6	   0
    //  7	   0	    s = 3'b111
        case(s) // case statement
            3'b000: y = d0; // choice 0 - d0
            3'b001: y = d1; // choice 1 - d1
            3'b010: y = d2; // choice 2 - d2
            3'b011: y = d3; // choice 3 - d3
            3'b100: y = d4; // choice 4 - d4
            default: y = 0; // choice 5, 6, 7 - 0
        endcase
    end
endmodule
