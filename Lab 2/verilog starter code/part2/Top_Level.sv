// CSE140L  
// see Structural Diagram in Lab2 assignment writeup
// fill in missing connections and parameters
module Top_Level #(parameter NS=60, NH=24, ND=7)(
  input Reset,
        Timeset, 	  // manual buttons
        Alarmset,	  //	(five total)
		Minadv,
		Hrsadv,
    	Dayadv,
		Alarmon,
		Pulse,		  // digital clock, assume 1 cycle/sec.
// 6 decimal digit display (7 segment)
  output [6:0] S1disp, S0disp, 	   // 2-digit seconds display
               M1disp, M0disp, 
               H1disp, H0disp,
                       D0disp,   // for part 2
  output logic Buzz);	           // alarm sounds
// internal connections (may need more)
  logic[6:0] TSec, TMin, THrs, TDays,     // clock/time 
             AMin, AHrs, ADay;		   // alarm setting
  logic[6:0] Min, Hrs, Days;
  logic S_max, TM_max, TH_max, TD_max, // "carry out" from sec -> min, min -> hrs, hrs -> days
        AM_max, AH_max, AD_max,
        TMen, THen, AMen, AHen, TDen, ADen; 

// (almost) free-running seconds counter	-- be sure to set modulus inputs on ct_mod_N modules
  ct_mod_N  Sct(
// input ports
    .clk(Pulse), .rst(Reset), .en(!Timeset), .modulus(NS),
// output ports    
    .ct_out(TSec), .ct_max(S_max));
  assign TMen = S_max || (Timeset && Minadv); // enable minutes counter

// minutes counter -- runs at either 1/sec while being set or 1/60sec normally
  ct_mod_N Mct(
// input ports
    .clk(Pulse), .rst(Reset), .en(TMen), .modulus(NS),
// output ports
    .ct_out(TMin), .ct_max(TM_max));
  assign THen = (TM_max && S_max) || (Timeset && Hrsadv); // enable hours counter

// hours counter -- runs at either 1/sec or 1/60min
  ct_mod_N  Hct(
// input ports
	.clk(Pulse), .rst(Reset), .en(THen), .modulus(NH),
// output ports
  .ct_out(THrs), .ct_max(TH_max));
  assign TDen = (TM_max && S_max && TH_max) || (Timeset && Dayadv);


// days counter -- runs at either 1/sec or 1/24hrs
  ct_mod_N  Dct(
// input ports
    .clk(Pulse), .rst(Reset), .en(TDen), .modulus(ND),
// output ports
  .ct_out(TDays), .ct_max(TD_max));
  assign AMen = (!Timeset && Alarmset && Minadv); // enable alarm minute set registers
  


// alarm set registers -- either hold or advance 1/sec while being set
  ct_mod_N Mreg(
// input ports
    .clk(Pulse), .rst(Reset), .en(AMen), .modulus(NS),   
// output ports    
    .ct_out(AMin), .ct_max(AM_max));
  assign AHen = (!Timeset && Alarmset && Hrsadv); // enable alarm hour set registers

  ct_mod_N  Hreg(
// input ports
    .clk(Pulse), .rst(Reset), .en(AHen), .modulus(NH),
// output ports    
    .ct_out(AHrs), .ct_max(AH_max));
  assign ADen = (!Timeset && Alarmset && Dayadv);

  ct_mod_N  Dreg(
// input ports
    .clk(Pulse), .rst(Reset), .en(ADen), .modulus(ND),
// output ports    
    .ct_out(ADay), .ct_max(AD_max));


// MUX for time display
always_comb begin
  if (Alarmset) begin
    Min = AMin;
    Hrs = AHrs;
    Days = ADay;
  end
  else begin
    Min = TMin;
    Hrs = THrs;
    Days = TDays;
  end
end

// display drivers (2 digits each, 6 digits total)
  lcd_int Sdisp(					  // seconds display
    .bin_in    (TSec)  ,
	.Segment1  (S1disp),
	.Segment0  (S0disp)
	);

  lcd_int Mdisp(
    .bin_in    (Min),
	.Segment1  (M1disp),
  .Segment0  (M0disp)
	);

  lcd_int Hdisp(
    .bin_in    (Hrs),
	.Segment1  (H1disp),
  .Segment0  (H0disp)
	);

  lcd_int DDisp(
    .bin_in(Days),
    .Segment1(),
    .Segment0(D0disp)
  );

// buzz off :)	  make the connections
  alarm a1(
    .tmin(TMin), .amin(AMin), .thrs(THrs), .ahrs(AHrs), .tday(TDays), .aday(ADay), .buzz(Buzz)
	);



endmodule