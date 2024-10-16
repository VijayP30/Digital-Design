// testbench for lab2
`include "display_2_3_tb.sv"
module lab2_3_tb();
  logic Reset = 1,
        Clk = 0,
        Timeset = 0,
        Alarmset = 0,
		Minadv = 0,
		Hrsadv = 0,
		Dayadv = 0,
		Datadv = 0,
		Monadv = 0,
		Alarmon = 1,
		Pulse = 0;
		
  wire[6:0] S1disp, S0disp,
            M1disp, M0disp,
	        H1disp, H0disp, 
	        D0disp,
	        N1disp, N0disp,
	        T1disp, T0disp;
  wire Buzz;

  Top_Level top(.*); // (.Reset(Reset),....)

  initial begin
	#  2ns  Reset    = 0;
    #  2ns
    $display("5': before setting. '010100000', Jan 1, ",$time);
    display_2_3_tb (.seg_mon1(N1disp), .seg_mon0(N0disp),
       .seg_dat1(T1disp), .seg_dat0(T0disp),.seg_j(D0disp),.seg_d(H1disp),
      .seg_e(H0disp), .seg_f(M1disp),
      .seg_g(M0disp), .seg_h(S1disp),
      .seg_i(S0disp));
	#  2ns  Timeset  = 1;
		    Datadv  = 1;
		    Monadv = 1;
	# 22ns  Monadv = 0;   //month: 12
    # 38ns  Datadv  = 0;   //date: 31
			Timeset  = 0;
    #  2ns
    $display("5':after setting,'1231', manually increment date/month successful ",$time);
    display_2_3_tb (.seg_mon1(N1disp), .seg_mon0(N0disp),
      .seg_dat1(T1disp), .seg_dat0(T0disp),.seg_j(D0disp),.seg_d(H1disp),
      .seg_e(H0disp), .seg_f(M1disp),
      .seg_g(M0disp), .seg_h(S1disp),
      .seg_i(S0disp));
    repeat(24) #7200ns;    //24 hours
    $display("5': '010100',passively increment date/month successful, also testing range month 1-12, date from 1 ",$time);
    display_2_3_tb (.seg_mon1(N1disp), .seg_mon0(N0disp),
      .seg_dat1(T1disp), .seg_dat0(T0disp),.seg_j(D0disp),.seg_d(H1disp),
      .seg_e(H0disp), .seg_f(M1disp),
      .seg_g(M0disp), .seg_h(S1disp),
      .seg_i(S0disp));

	#  2ns  Timeset  = 1;
		    Datadv  = 1;
		    Monadv = 1;
	#  2ns  Monadv = 0;   //month 2
    # 54ns  Datadv  = 0;  //date: 29
			Timeset  = 0;
			  
    #  2ns
    $display("5'---------------testing mod-----------");
    $display("testing Feb has 29 days:'0229' ",$time);
    display_2_3_tb (.seg_mon1(N1disp), .seg_mon0(N0disp),
      .seg_dat1(T1disp), .seg_dat0(T0disp),.seg_j(D0disp),.seg_d(H1disp),
      .seg_e(H0disp), .seg_f(M1disp),
      .seg_g(M0disp), .seg_h(S1disp),
      .seg_i(S0disp));

    repeat(24) #7200ns; //24hours
    $display("0301");
    display_2_3_tb (.seg_mon1(N1disp), .seg_mon0(N0disp),
       .seg_dat1(T1disp), .seg_dat0(T0disp),.seg_j(D0disp),.seg_d(H1disp),
      .seg_e(H0disp), .seg_f(M1disp),
      .seg_g(M0disp), .seg_h(S1disp),
      .seg_i(S0disp));

	#  2ns  Timeset  = 1;
			Datadv  = 1;
			Monadv = 1;
	#  2ns  Monadv = 0;  //month 4
    # 56ns  Datadv = 0; //date: 30
	   	    Timeset  = 0;
    #  2ns
    $display("testing April has 30 days: '0430' ",$time);
    display_2_3_tb (.seg_mon1(N1disp), .seg_mon0(N0disp),
      .seg_dat1(T1disp), .seg_dat0(T0disp),.seg_j(D0disp),.seg_d(H1disp),
      .seg_e(H0disp), .seg_f(M1disp),
      .seg_g(M0disp), .seg_h(S1disp),
      .seg_i(S0disp));
    repeat(24) #7200ns; //24hours
    $display("5 points: 0501 ",$time);
    display_2_3_tb (.seg_mon1(N1disp), .seg_mon0(N0disp),
       .seg_dat1(T1disp), .seg_dat0(T0disp),.seg_j(D0disp),.seg_d(H1disp),
      .seg_e(H0disp), .seg_f(M1disp),
      .seg_g(M0disp), .seg_h(S1disp),
      .seg_i(S0disp));
	 
	#100ns  $stop; 
  end 
  
  always begin  // period is 2 ns
    #1ns Pulse = 1;				 // #500ps Pulse = 1;	  1ns      500ps ==> 1ns	  5ns  
	#1ns Pulse = 0;				 // #500ps Pulse = 0;								  5ns
  end
endmodule