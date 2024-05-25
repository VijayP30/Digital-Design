// traffic light controller
// CSE140L 3-street, 12-state version
// inserts all-red after each yellow
// uses enumerated variables for states and for red-yellow-green
// 5 after traffic, 10 max cycles for green after conflict
// starter (shell) -- you need to complete the always_comb logic
import light_package ::*;           // defines red, yellow, green

// same as Harris & Harris 4-state, but we have added two all-reds
module traffic_light_controller(
  input  clk, reset, 
         s_s, l_s, n_s,  // traffic sensors, east-west straight, east-west left, north-south 
  output colors str_light, left_light, ns_light);    // traffic lights, east-west straight, east-west left, north-south

// HRR = red-red following YRR; RRH = red-red following RRY;
// ZRR = 2nd cycle yellow, follows YRR, etc. 
  typedef enum {GRR, YRR, ZRR, HRR,              // ES+WS
                RGR, RYR, RZR, RHR, 	         // EL+WL
                RRG, RRY, RRZ, RRH} tlc_states;  // NS
  tlc_states    present_state, next_state;
  int     ctr5, next_ctr5,       //  5 sec timeout when my traffic goes away
          ctr10, next_ctr10;     // 10 sec limit when other traffic presents

// sequential part of our state machine (register between C1 and C2 in Harris & Harris Moore machine diagram
// combinational part will reset or increment the counters and figure out the next_state
  always_ff @(posedge clk)
    if(reset) begin
	    present_state <= RRH;
      ctr5          <= 0;
      ctr10         <= 0;
    end  
	  else begin
	    present_state  <= next_state;
      ctr5           <= next_ctr5;
      ctr10          <= next_ctr10;
    end  

// combinational part of state machine ("C1" block in the Harris & Harris Moore machine diagram)
// default needed because only 6 of 8 possible states are defined/used
  always_comb begin
    next_state = RRH;            // default to reset state
    next_ctr5  = 0; 	         // default to clearing counters
    next_ctr10 = 0;
    case(present_state)
/* ************* Fill in the case statements ************** */
	  GRR: begin
        // Check for 5 cycles of no traffic, or 10 cycles of traffic
        if (ctr5 == 4 || ctr10 == 9) begin
          next_state = YRR;
          next_ctr5 = 0;
          next_ctr10 = 0;
        end
        else begin
          // Stay in the same state, increment counters
          next_state = GRR;
          if (ctr5 != 0)
            next_ctr5 = ctr5 + 1;
          else if (!s_s)
            next_ctr5 = 1;
          if (ctr10 != 0)
            next_ctr10 = ctr10 + 1;
          else if (s_s && (l_s || n_s))
            next_ctr10 = 1;
        end
      end
    // Brute force way to make yellow last 2 cycles
    YRR: next_state = ZRR;
    ZRR: next_state = HRR;
    // Check the sensors to determine the next state via priority
    HRR: begin
      if (l_s)
        next_state = RGR;
      else if (n_s)
        next_state = RRG;
      else if (s_s)
        next_state = GRR; 
      else
        next_state = HRR;
      end
    RGR: begin
        // Check for 5 cycles of no traffic, or 10 cycles of traffic
        if (ctr5 == 4 || ctr10 == 9) begin
          next_state = RYR;
          next_ctr5 = 0;
          next_ctr10 = 0;
        end
        else begin
          // Stay in the same state, increment counters
          next_state = RGR;
          if (ctr5 != 0)
            next_ctr5 = ctr5 + 1;
          else if (!l_s)
            next_ctr5 = 1;
          if (ctr10 != 0)
            next_ctr10 = ctr10 + 1;
          else if (l_s && (s_s || n_s))
            next_ctr10 = 1;
        end
      end
    // Brute force way to make yellow last 2 cycles
    RYR: next_state = RZR;
    RZR: next_state = RHR;
    // Check the sensors to determine the next state via priority
    RHR: begin
      if (n_s)
        next_state = RRG;
      else if (s_s)
        next_state = GRR;
      else if (l_s)
        next_state = RGR;
      else
        next_state = RHR;
      end
    RRG: begin
        // Check for 5 cycles of no traffic, or 10 cycles of traffic
        if (ctr5 == 4 || ctr10 == 9) begin
          next_state = RRY;
          next_ctr5 = 0;
          next_ctr10 = 0;
        end
        else begin
          // Stay in the same state, increment counters
          next_state = RRG;
          if (ctr5 != 0)
            next_ctr5 = ctr5 + 1;
          else if (!n_s)
            next_ctr5 = 1;
          if (ctr10 != 0)
            next_ctr10 = ctr10 + 1;
          else if (n_s && (s_s || l_s))
            next_ctr10 = 1;
        end
      end
    // Brute force way to make yellow last 2 cycles
    RRY: next_state = RRZ;
    RRZ: next_state = RRH;
    // Check the sensors to determine the next state via priority
    RRH: begin
      if (s_s)
        next_state = GRR;
      else if (l_s)
        next_state = RGR;
      else if (n_s)
        next_state = RRG;
      else
        next_state = RRH;
      end
    endcase
  end

// combination output driver  ("C2" block in the Harris & Harris Moore machine diagram)
  always_comb begin
    str_light  = red;      // cover all red plus undefined cases
    left_light = red;	   // default to red, then call out exceptions in case
    ns_light   = red;
    case(present_state)    // Moore machine
      GRR:     str_light  = green;
      YRR,ZRR: str_light  = yellow;  // my dual yellow states -- brute force way to make yellow last 2 cycles
      RGR:     left_light = green;
      RYR,RZR: left_light = yellow;
      RRG:     ns_light   = green;
      RRY,RRZ: ns_light   = yellow;
    endcase
  end

endmodule