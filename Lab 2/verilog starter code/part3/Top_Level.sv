// CSE140L  
// see Structural Diagram in Lab2 assignment writeup
// fill in missing connections and parameters
module Top_Level #(parameter NS=60, NH=24, ND=7, NM=12)(
  input Reset,
        Timeset, 	  // manual buttons
        Alarmset,	  //	(five total)
		Minadv,
		Hrsadv,
    	Dayadv,
  		Datadv,
  		Monadv,
		Alarmon,
		Pulse,		  // digital clock, assume 1 cycle/sec.
// 6 decimal digit display (7 segment)
  output [6:0] S1disp, S0disp, 	   // 2-digit seconds display
               M1disp, M0disp, 
               H1disp, H0disp,
                       D0disp,
               N1disp, N0disp,
               T1disp, T0disp,   // for part 2
  output logic Buzz);	           // alarm sounds
// internal connections (may need more)
  logic[6:0] TSec, TMin, THrs, TDays, TDate, TMonth,     // clock/time 
             AMin, AHrs, ADay, Dates;		   // alarm setting
  logic[6:0] Min, Hrs, Days, Date, Mon;
  logic S_max, TM_max, TH_max, TD_max, TDate_Max, TMonth_Max, // "carry out" from sec -> min, min -> hrs, hrs -> days
        AM_max, AH_max, AD_max,
        TMen, THen, AMen, AHen, TDen, ADen, TDateen, TMonthen; 

  always_comb case (TMonth) 
      0 : Dates = 31;
      1 : Dates = 29;
      2 : Dates = 31;
      3 : Dates = 30;
      4 : Dates = 31;
      5 : Dates = 30;
      6 : Dates = 31;
      7 : Dates = 31;
      8 : Dates = 30;
      9 : Dates = 31;
      10 : Dates = 30;
      11 : Dates = 31;
    default: Dates = -1;
  endcase

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
  
  assign TDateen = (Timeset && Datadv) || (TH_max && TM_max && S_max);
  ct_mod_N Datect(
  // input ports
    .clk(Pulse), .rst(Reset), .en(TDateen), 
  // output ports
    .ct_out(TDate), .ct_max(TDate_Max), .modulus(Dates) 
);
assign TMonthen = (Timeset && Monadv) || (TDate_Max && TH_max && TM_max && S_max);

  ct_mod_N Monthct(
  // input ports
    .clk(Pulse), .rst(Reset), .en(TMonthen), 
  // output ports
    .ct_out(TMonth), .ct_max(TMonth_Max), .modulus(NM) 
);

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
assign Date = !Alarmset ? (TDate + 1) : 0;
assign Mon = !Alarmset ? (TMonth + 1) : 0;

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

  lcd_int Tdisp(
    .bin_in    (Date),
    .Segment1  (T1disp),
    .Segment0  (T0disp)
	);

  lcd_int Ndisp(
    .bin_in    (Mon),
    .Segment1  (N1disp),
    .Segment0  (N0disp)
	);

// buzz off :)	  make the connections
  alarm a1(
    .tmin(TMin), .amin(AMin), .thrs(THrs), .ahrs(AHrs), .tday(TDays), .aday(ADay), .buzz(Buzz)
	);



endmodule