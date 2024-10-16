// traffic light controller
// red-red   5 states
// with green light counters
// NOTE: green light counters = work in progress
module h_h_tlc(
  input clk, reset, Ta, Tb,
  output logic[1:0] La, Lb);    // 

  logic[2:0] present_state, next_state;
  logic[3:0] ctr;  // mod10 counter
  logic      ctr_reset, ctr_adv;

// sequential part of our state machine
  always_ff @(posedge clk)
    if(reset) begin
	  present_state <= 'b0;	     // all-red
      ctr           <= 'b0;
    end
	else begin
	  present_state <= next_state;
	  if(ctr_reset)    ctr <= 'b0;
	  else if(ctr_adv) ctr <= ctr + 1; 
	end

// combinational part of state machine
  always_comb begin 
    next_state = 'b000;	
    ctr_reset = 'b1;   
    ctr_adv = 'b0;                         // r r
    case(present_state)
	  'b000: if(Ta=='b1)    next_state = 'b001;     // g r
	       else if(Tb=='b1) next_state = 'b011; 	// r g
      'b001: begin
		 ctr_reset = 'b0;
		 ctr_adv   = 'b1;
         if(Ta=='b0)    next_state = 'b010;
	     else if(ctr<9)  next_state = 'b001;

	  end
	  'b010: next_state = 'b000;   // all red

	  'b011: if(Tb=='b0)    next_state = 'b100;   
	         else           next_state = 'b011;

	  'b100: next_state = 'b000;   // all red

    endcase
  end

// combination output driver
// green = 00, yellow = 01, red = 10
  always_comb case(present_state)   // Moore machine
    'b000: {La,Lb} = 4'b10_10;      // red
	'b001: {La,Lb} = 4'b00_10;
	'b010: {La,Lb} = 4'b01_10;
	'b011: {La,Lb} = 4'b10_00;
    'b100: {La,Lb} = 4'b10_01;
  endcase

endmodule