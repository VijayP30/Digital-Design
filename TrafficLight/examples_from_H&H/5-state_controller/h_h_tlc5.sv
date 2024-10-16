// traffic light controller
// red-red   5 states
// with green light counters
// NOTE: green light counters = work in progress
import light_package ::*;

module h_h_tlc(
  input clk, reset, Ta, Tb,
  output colors La, Lb);    // 


  typedef enum logic[2:0] {rr, gr, yr, rg, ry} state;
  state present_state, next_state;
  logic[3:0] ctr;  // mod10 counter
  logic      ctr_reset, ctr_adv;

// sequential part of our state machine
  always_ff @(posedge clk)
    if(reset) begin
	  present_state <= rr;	     // all-red
      ctr           <= 'b0;
    end
	else begin
	  present_state        <= next_state;
	  if(ctr_reset)    ctr <= 'b0;
	  else if(ctr_adv) ctr <= ctr + 1; 
	end

// combinational part of state machine
  always_comb begin 
    next_state = rr;	
    ctr_reset = 'b1;   
    ctr_adv   = 'b0;                         // r r
    case(present_state)
	  rr: if(Ta)      next_state = gr;     // g r
	      else if(Tb) next_state = rg; 	// r g
      gr: begin
		 ctr_reset = 'b0;
		 ctr_adv   = 'b1;
         if(Ta && ctr<9) next_state = gr;
	     else            next_state = yr;
	      end
	  yr: next_state = rr;   // all red
	  rg: if(!Tb)    next_state = ry;   
	      else       next_state = rg;
	  ry: next_state = rr;   // all red
    endcase
  end

// combination output driver
// green = 00, yellow = 01, red = 10
  always_comb begin
    La = red;
	Lb = red;
    case(present_state)   // Moore machine
//      'b000: {La,Lb} = 4'b10_10;      // red
	  gr: La = green;
	  yr: La = yellow;
	  rg: Lb = green;
      ry: Lb = yellow;
    endcase
  end
endmodule