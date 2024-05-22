// traffic light controller
// Harris & Harris simple 4-state version
// using enum variables
import light_package::*;	   // defines (global) signal colors

module h_h_tlc(
  input         clk, reset, Ta, Tb,
  output colors La, Lb);       // "colors" is a type, like logic 

// we can use descriptive names for states, instead of numerical values
  typedef enum {GR,YR,RG,RY} tlc_states;
  tlc_states present_state, next_state;

// sequential part of our state machine
// usual: if reset, present_state goes to initialization value
//   else, updates to next_state value on each rising clock
  always_ff @(posedge clk)
    if(reset)
	  present_state <= GR;               // our 0 state, per typedef								
	else
	  present_state <= next_state;

// combinational part of state machine
// block C1 in our state machine block diagram
// this is the "brains" of the state machine
// for always_comb, every possible input combination must be covered 
  always_comb case(present_state)
// if green for street A, stay green if traffic, go to yellow if not
	GR:  if(Ta=='b0) next_state = YR;
	       else      next_state = GR;
// yellow for A street lasts one clock cycle, then on to red
	YR:  next_state = RG;
// green in the other direction looks only at Tb (traffic on its own street)
	RG:  if(Tb=='b0) next_state = RY;
	       else      next_state = RG;
// yellow for B street 
	RY:  next_state = GR;
  endcase

// combination output driver
// green = 00, yellow = 01, red = 10
  always_comb case(present_state)   // Moore machine
    GR: begin
		  La = green;
		  Lb = red;
		end	
	YR: begin
		  La = yellow;
		  Lb = red;
	    end
	RG: begin
	      La = red;
	      Lb = green;
	    end
	RY: begin
	      La = red;
	      Lb = yellow;
    	end      
  endcase

endmodule