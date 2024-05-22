// traffic light controller
// Harris & Harris simple 4-state version
module h_h_tlc(
  input clk, reset, Ta, Tb,
  output logic[1:0] La, Lb);    // 

  logic[1:0] present_state, next_state;

// sequential part of our state machine
  always_ff @(posedge clk)
    if(reset)
	  present_state <= 'b0;
	else
	  present_state <= next_state;

// combinational part of state machine
  always_comb case(present_state)
// if green for street A, stay green if traffic, go to yellow if not
	'b00:  if(Ta=='b0) next_state = 'b01;
	       else        next_state = 'b00;
// yellow for A street lasts one clock cycle, then on to red
	'b01:  next_state = 'b10;
// green in the other direction looks only at Tb (traffic on its own street)
	'b10:  if(Tb=='b0) next_state = 'b11;
	       else        next_state = 'b10;
// yellow for B street 
	'b11:  next_state = 'b00;
  endcase

// combination output driver
// green = 00, yellow = 01, red = 10
  always_comb case(present_state)   // Moore machine
    'b00: {La,Lb} = 4'b00_10;       // green    red
	'b01: {La,Lb} = 4'b01_10;		// yellow   red
	'b10: {La,Lb} = 4'b10_00;		// red      green
	'b11: {La,Lb} = 4'b10_01;		// red      yellow
  endcase

endmodule