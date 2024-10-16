// traffic light controller
// red-red   5 states
module h_h_tlc(
  input clk, reset, Ta, Tb,
  output logic[1:0] La, Lb);    // 

  logic[2:0] present_state, next_state;

// sequential part of our state machine
  always_ff @(posedge clk)
    if(reset)
	  present_state <= 'b0;	     // all-red
	else
	  present_state <= next_state;

// combinational part of state machine
// note yellows ignore Ta and Tb -- fixed duration of yellow, then on to red
// each green looks only at its own traffic detector, to decide whether to stay
//   or move on to yellow
  always_comb begin 
    next_state = 'b000;	                            // r r
    case(present_state)
// all-red to green in one direction or the other, in presence of traffic:
	  'b000: if(Ta=='b1)    next_state = 'b001;     // g r
	       else if(Tb=='b1) next_state = 'b011; 	// r g
// green goes to yellow when traffic disappears
      'b001: if(Ta=='b0)    next_state = 'b010;
	         else           next_state = 'b001;
// yellow unconditionally leads back to all red
	  'b010: next_state = 'b000;   // all red
// green to yellow for other direction
	  'b011: if(Tb=='b0)    next_state = 'b100;   
	         else           next_state = 'b011;
// yellow to all red for other direction
	  'b100: next_state = 'b000;   // all red

    endcase
  end

// combination output driver
// green = 00, yellow = 01, red = 10
  always_comb case(present_state)   // Moore machine
    'b000: {La,Lb} = 4'b10_10;    // red
	'b001: {La,Lb} = 4'b00_10;
	'b010: {La,Lb} = 4'b01_10;
	'b011: {La,Lb} = 4'b10_00;
    'b100: {La,Lb} = 4'b10_01;
  endcase

endmodule