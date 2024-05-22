// traffic light controller
// Harris & Harris simple 6-state version
// insert all-red after each yellow
// use enumerated variables for states and for red-yellow-green
import light_package ::*;           // defines red, yellow, green

// same as Harris & Harris 4-state, but we have added two all-reds
module h_h_tlc(
  input clk, reset, Ta, Tb,
  output colors La, Lb);    // 

// HR = red-red following YR; RH = red-red following RY;
  typedef enum {GR, YR, HR, RG, RY, RH} tlc_states;  
  tlc_states    present_state, next_state;

// sequential part of our state machine
  always_ff @(posedge clk)
    if(reset)
	  present_state <= HR;
	else
	  present_state <= next_state;

// combinational part of state machine
// default needed because only 6 of 8 possible states are defined/used
  always_comb begin
    next_state = HR;            // default to reset state
    case(present_state)
// if green for street A, stay green if traffic, go to yellow if not
	GR:  if(Ta=='b0) next_state = YR;
	     else        next_state = GR;
// yellow for A street lasts one clock cycle, then on to all red 1
	YR:  next_state = HR;	   // all_red_1
// first all-red state; give precedence to other street for green
	HR:  if(Tb)      next_state = RG;    
    	 else if(Ta) next_state = GR;
		 else        next_state = HR;
// green in the other direction looks only at Tb (traffic on its own street)
	RG:  if(Tb=='b0) next_state = RY;
	     else        next_state = RG;
// yellow for B street goes to all red 2 
	RY:  next_state = RH;
// second all-red state -- not "fairness" reversal of priorities
	RH:  if(Ta)       next_state = GR;
	     else if(Tb)  next_state = RG;
		 else         next_state = RH;
    endcase
  end

// combination output driver
  always_comb begin
    La = red;              // cover all red plus undefined cases
	Lb = red;
    case(present_state)    // Moore machine
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
  end

endmodule