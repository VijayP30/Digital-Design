// CSE140 lab 2  
// How does this work? How long does the alarm stay on? 
// (buzz is the alarm itself)
module alarm(
  input[6:0]   tmin,
               amin,
			   thrs,
			   ahrs,
               tday,
               aday,					 
  output logic buzz
);

  always_comb begin
    if (aday==7)
    	buzz = (tmin == amin) && (thrs == ahrs);
    else 
      buzz = (tmin == amin) && (thrs == ahrs) && (tday != aday) && ((tday + 6) % 7 != aday);
  end
    /* fill in the guts:
	buzz = 1 when tmin and thrs match amin and ahrs, respectively */


endmodule