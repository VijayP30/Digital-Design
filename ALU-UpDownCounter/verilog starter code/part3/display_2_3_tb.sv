// task which drives consecutive 7=segment displays
// CSE140L  Lab 2 part 3 
// $display performs a return / new line feed; $write does not
task display_2_3_tb(input[6:0] seg_mon1, seg_mon0, 
                           seg_dat1,  seg_dat0, 
                           seg_j, 						  // day of week
                           seg_d,      seg_e, 			  // hours
                           seg_f,      seg_g, 			  // minutes
                           seg_h,      seg_i
  );
 // segment A
      if(seg_mon1[6]) $write(" _ ");
      else         $write("   ");
      $write(" ");
	  if(seg_mon0[6]) $write(" _ ");
      else         $write("   ");
      $write("  ");

	  if(seg_dat1[6]) $write(" _ ");
      else         $write("   ");
      $write(" ");
      if(seg_dat0[6]) $write(" _ ");
      else         $write("   ");
      $write("  ");
// day of week		
      if(seg_j[6]) $write(" _ ");
      else         $write("   ");
      $write("  ");
// hours
      if(seg_d[6]) $write(" _ ");
      else         $write("   ");
	  $write(" ");
	  if(seg_e[6]) $write(" _ ");
	  else         $write("   ");
	  $write("  ");
// minutes
	  if(seg_f[6]) $write(" _ ");
	  else         $write("   ");
      $write(" ");
	  if(seg_g[6]) $write(" _ ");
	  else         $write("   ");
/*	  $write("  ");
	  if(seg_h[6]) $write(" _ ");
	  else         $write("   ");
      $write(" ");
	  if(seg_i[6]) $write(" _ ");
	  else         $write("   ");
*/      $display();
 // segments FGB
  	  if(seg_mon1[1]) $write("|");
	  else $write(" ");
	  if(seg_mon1[0]) $write("_");
	  else $write(" ");
	  if(seg_mon1[5]) $write("|");
	  else $write(" ");
	  $write(" ");
	  if(seg_mon0[1]) $write("|");
	  else $write(" ");
	  if(seg_mon0[0]) $write("_");
	  else $write(" ");
	  if(seg_mon0[5]) $write("|");
	  else $write(" ");
	  $write("  ");

	  if(seg_dat1[1]) $write("|");
	  else $write(" ");
	  if(seg_dat1[0]) $write("_");
	  else $write(" ");
	  if(seg_dat1[5]) $write("|");
	  else $write(" ");
	  $write(" ");
	  if(seg_dat0[1]) $write("|");
	  else $write(" ");
	  if(seg_dat0[0]) $write("_");
	  else $write(" ");
	  if(seg_dat0[5]) $write("|");
	  else $write(" ");
	  $write("  ");
	  
 	  if(seg_j[1]) $write("|");
	  else $write(" ");
	  if(seg_j[0]) $write("_");
	  else $write(" ");
	  if(seg_j[5]) $write("|");
	  else $write(" ");
	  $write("  ");

	  if(seg_d[1]) $write("|");
	  else $write(" ");
	  if(seg_d[0]) $write("_");
	  else $write(" ");
	  if(seg_d[5]) $write("|");
	  else $write(" ");
	  $write(" ");
	  if(seg_e[1]) $write("|");
	  else $write(" ");
	  if(seg_e[0]) $write("_");
	  else $write(" ");
	  if(seg_e[5]) $write("|");
	  else $write(" ");
	  $write("  ");

	  if(seg_f[1]) $write("|");
	  else $write(" ");
	  if(seg_f[0]) $write("_");
	  else $write(" ");
	  if(seg_f[5]) $write("|");
	  else $write(" ");
	  $write(" ");
	  if(seg_g[1]) $write("|");
	  else $write(" ");
	  if(seg_g[0]) $write("_");
	  else $write(" ");
	  if(seg_g[5]) $write("|");
	  else $write(" ");
	  $display();
  // segments EDC
      if(seg_mon1[2]) $write("|");
	  else $write(" ");
	  if(seg_mon1[3]) $write("_");
	  else $write(" ");
	  if(seg_mon1[4]) $write("|");
	  else $write(" ");
	  $write(" ");
      if(seg_mon0[2]) $write("|");
	  else $write(" ");
	  if(seg_mon0[3]) $write("_");
	  else $write(" ");
	  if(seg_mon0[4]) $write("|");
	  else $write(" ");
	  $write("  ");
	  
      if(seg_dat1[2]) $write("|");
	  else $write(" ");
	  if(seg_dat1[3]) $write("_");
	  else $write(" ");
	  if(seg_dat1[4]) $write("|");
	  else $write(" ");
	  $write(" ");
      if(seg_dat0[2]) $write("|");
	  else $write(" ");
	  if(seg_dat0[3]) $write("_");
	  else $write(" ");
	  if(seg_dat0[4]) $write("|");
	  else $write(" ");
	  $write("  ");
// day	  
      if(seg_j[2]) $write("|");
	  else $write(" ");
	  if(seg_j[3]) $write("_");
	  else $write(" ");
	  if(seg_j[4]) $write("|");
	  else $write(" ");
	  $write("  ");
// hours
     if(seg_d[2]) $write("|");
	  else $write(" ");
	  if(seg_d[3]) $write("_");
	  else $write(" ");
	  if(seg_d[4]) $write("|");
	  else $write(" ");
	  $write(" ");
      if(seg_e[2]) $write("|");
	  else $write(" ");
	  if(seg_e[3]) $write("_");
	  else $write(" ");
	  if(seg_e[4]) $write("|");
	  else $write(" ");
	  $write("  ");
// minutes
      if(seg_f[2]) $write("|");
	  else $write(" ");
	  if(seg_f[3]) $write("_");
	  else $write(" ");
	  if(seg_f[4]) $write("|");
	  else $write(" ");
	  $write(" ");
      if(seg_g[2]) $write("|");
	  else $write(" ");
	  if(seg_g[3]) $write("_");
	  else $write(" ");
	  if(seg_g[4]) $write("|");
	  else $write(" ");
	  $display();

endtask