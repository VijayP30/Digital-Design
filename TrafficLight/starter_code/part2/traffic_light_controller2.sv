// traffic light controller solution stretch
// CSE140L 3-street, 20-state version, ew str/left decouple
// inserts all-red after each yellow
// uses enumerated variables for states and for red-yellow-green
// 5 after traffic, 10 max cycles for green when other traffic present
import light_package ::*;           // defines red, yellow, green

// same as Harris & Harris 4-state, but we have added two all-reds
module traffic_light_controller(
  input clk, reset, e_str_sensor, w_str_sensor, e_left_sensor, 
        w_left_sensor, ns_sensor,             // traffic sensors, east-west str, east-west left, north-south 
  output colors e_str_light, w_str_light, e_left_light, w_left_light, ns_light);     // traffic lights, east-west str, east-west left, north-south

  logic s, sb, e, eb, w, wb, l, lb, n, nb;	 // shorthand for traffic combinations:

  assign s  = e_str_sensor || w_str_sensor;					 // str E or W
  assign sb = e_left_sensor || w_left_sensor || ns_sensor;			     // 3 directions which conflict with s
  assign e  = e_left_sensor || e_str_sensor;					     // E str or L
  assign eb = w_left_sensor || w_str_sensor || ns_sensor;			 // conflicts with e
  assign w  = w_left_sensor || w_str_sensor;
  assign wb = e_left_sensor || e_str_sensor || ns_sensor;
  assign l  = e_left_sensor || w_left_sensor;
  assign lb = e_str_sensor || w_str_sensor || ns_sensor;
  assign n  = ns_sensor;
  assign nb = s || l; 

// 20 suggested states, 4 per direction   Y, Z = easy way to get 2-second yellows
// HRRRR = red-red following ZRRRR; ZRRRR = second yellow following YRRRR; 
// RRRRH = red-red following RRRRZ;
  typedef enum {GRRRR, YRRRR, ZRRRR, HRRRR, 	           // ES+WS
  	            RGRRR, RYRRR, RZRRR, RHRRR, 			   // EL+ES
	            RRGRR, RRYRR, RRZRR, RRHRR,				   // WL+WS
	            RRRGR, RRRYR, RRRZR, RRRHR, 			   // WL+EL
	            RRRRG, RRRRY, RRRRZ, RRRRH} tlc_states;    // NS
	tlc_states    present_state, next_state;
	int     ctr5, next_ctr5,       //  5 sec timeout when my traffic goes away
			ctr10, next_ctr10;     // 10 sec limit when other traffic presents

// sequential part of our state machine (register between C1 and C2 in Harris & Harris Moore machine diagram
// combinational part will reset or increment the counters and figure out the next_state
  always_ff @(posedge clk)
	if(reset) begin
	  present_state <= RRRRH;
	  ctr5          <= 'd0;
	  ctr10         <= 'd0;
	end  
	else begin
	  present_state <= next_state;
	  ctr5          <= next_ctr5;
	  ctr10         <= next_ctr10;
	end  

// combinational part of state machine ("C1" block in the Harris & Harris Moore machine diagram)
// default needed because only 6 of 8 possible states are defined/used
  always_comb begin
	next_state = RRRRH;                            // default to reset state
	next_ctr5  = 'd0; 							   // default: reset counters
	next_ctr10 = 'd0;
	case(present_state)
/* ************* Fill in the case statements ************** */
		GRRRR: begin
    		next_state = (ctr5 == 4 || ctr10 == 9) ? YRRRR : GRRRR;
    		next_ctr5 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
                		(ctr5 != 0) ? ctr5 + 1 : 
                		(!s) ? 1 : next_ctr5;
    		next_ctr10 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
                 		(ctr10 != 0) ? ctr10 + 1 : 
                 		(s && sb) ? 1 : next_ctr10;
		end
		RGRRR: begin
			next_state = (ctr5 == 4 || ctr10 == 9) ? RYRRR : RGRRR;
			next_ctr5 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr5 != 0) ? ctr5 + 1 : 
						(!e) ? 1 : next_ctr5;
			next_ctr10 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr10 != 0) ? ctr10 + 1 : 
						(e && eb) ? 1 : next_ctr10;
		end
	  	RYRRR: next_state = RZRRR;
	  	RZRRR: next_state = RHRRR;
		RHRRR: begin
    		next_state = (w) ? RRGRR : 
                 		(l) ? RRRGR : 
                 		(n) ? RRRRG : 
                 		(s) ? GRRRR : 
                 		(e) ? RGRRR : 
                 		RHRRR;
		end
		RRGRR: begin
			next_state = (ctr5 == 4 || ctr10 == 9) ? RRYRR : RRGRR;
			next_ctr5 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr5 != 0) ? ctr5 + 1 : 
						(!w) ? 1 : next_ctr5;
			next_ctr10 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr10 != 0) ? ctr10 + 1 : 
						(w && wb) ? 1 : next_ctr10;
		end
		YRRRR: next_state = ZRRRR;
		ZRRRR: next_state = HRRRR;
		HRRRR: begin
    		next_state = (e) ? RGRRR : 
                 		(w) ? RRGRR : 
                 		(l) ? RRRGR : 
                 		(n) ? RRRRG : 
                 		(s) ? GRRRR : 
                 		HRRRR;
		end
		RRYRR: next_state = RRZRR;
		RRZRR: next_state = RRHRR;
		RRHRR: begin
    		next_state = (l) ? RRRGR : 
                 		(n) ? RRRRG : 
                 		(s) ? GRRRR : 
                 		(e) ? RGRRR : 
                 		(w) ? RRGRR : 
                 		RRHRR;
		end
		RRRGR: begin
			next_state = (ctr5 == 4 || ctr10 == 9) ? RRRYR : RRRGR;
			next_ctr5 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr5 != 0) ? ctr5 + 1 : 
						(!l) ? 1 : next_ctr5;
			next_ctr10 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr10 != 0) ? ctr10 + 1 : 
						(l && lb) ? 1 : next_ctr10;
		end
		RRRYR: next_state = RRRZR;
		RRRZR: next_state = RRRHR;
		RRRHR: begin
    		next_state = (n) ? RRRRG : 
                 		(s) ? GRRRR : 
                 		(e) ? RGRRR : 
                 		(w) ? RRGRR : 
                 		(l) ? RRRGR : 
                 		RRRHR;
		end
		RRRRG: begin
			next_state = (ctr5 == 4 || ctr10 == 9) ? RRRRY : RRRRG;
			next_ctr5 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr5 != 0) ? ctr5 + 1 : 
						(!n) ? 1 : next_ctr5;
			next_ctr10 = (ctr5 == 4 || ctr10 == 9) ? 0 : 
						(ctr10 != 0) ? ctr10 + 1 : 
						(n && nb) ? 1 : next_ctr10;
		end
		RRRRY: next_state = RRRRZ;
		RRRRZ: next_state = RRRRH;
		RRRRH: begin
    		next_state = (s) ? GRRRR : 
                 		(e) ? RGRRR : 
                 		(w) ? RRGRR : 
                 		(l) ? RRRGR : 
                 		(n) ? RRRRG : 
                 		RRRRH;
		end
    endcase
  end

// combination output driver  ("C2" block in the Harris & Harris Moore machine diagram)
	always_comb begin
	  e_str_light  = red;                // cover all red plus undefined cases
	  w_str_light  = red;				 // no need to list them below this block
	  e_left_light = red;
	  w_left_light = red;
	  ns_light     = red;
	  case(present_state)      // Moore machine
		GRRRR: begin 
			e_str_light = green;
			w_str_light = green;
		end
		RGRRR: begin
			e_str_light = green;
			e_left_light = green;
		end
		RRGRR: begin
			w_str_light = green;
			w_left_light = green;
		end
		RRRGR: begin
			e_left_light = green;
			w_left_light = green;
		end
		RRRRG: ns_light = green;
		YRRRR: begin
			e_str_light = yellow;
			w_str_light = yellow;
		end
		RYRRR: begin
			e_str_light = yellow;
			e_left_light = yellow;
		end
		RRYRR: begin
			w_str_light = yellow;
			w_left_light = yellow;
		end
		RRRYR: begin
			e_left_light = yellow;
			w_left_light = yellow;
		end
		RRRRY: ns_light = yellow;
		ZRRRR: begin
			e_str_light = yellow;
			w_str_light = yellow;
		end
		RZRRR: begin
			e_str_light = yellow;
			e_left_light = yellow;
		end
		RRZRR: begin
			w_str_light = yellow;
			w_left_light = yellow;
		end
		RRRZR: begin
			e_left_light = yellow;
			w_left_light = yellow;
		end
		RRRRZ: ns_light = yellow;
      // ** fill in the guts for all 5 directions -- just the greens and yellows **
	  endcase
	end

endmodule