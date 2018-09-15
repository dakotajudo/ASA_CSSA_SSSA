/*
 * Import sample data
 */

%web_drop_table(sample);

FILENAME REFFILE 'Y:/Work/git/statistics/design_documents/yield_monitor_data/workshop2017/sample.csv';

proc import datafile=reffile
	dbms=csv
	out=sample;
	getnames=yes;
run;

proc contents data=sample; run;

%web_open_table(sample);


*/

title 'Example 1';
proc variogram data=sample outv=outv plots=moran;
   compute lagd=2 maxlag=10 autocorr(assum=random);
   coordinates xc=LonM yc=LatM;
   var Yield;
run;

title 'Example 2';
proc variogram data=sample plots=observ; 
  compute novariogram nhc=35;
  coord xc=LonM yc=LatM;
  var Yield;
run;

title 'Example 3';
proc variogram data=sample plots=semivar;
   compute lagd=4 maxlag=16 ndir=12 atol=22.5 bandw=20;
   coord xc=LonM yc=LatM;
   var Yield;
run;

title 'Example 4';
proc glm data=sample plots=none;
   model Yield = LatM LonM LatM*LatM LonM*LonM LonM*LatM;
   output out=gmout predicted=pred residual=ResidualYield;
run;

title 'Example 5';
proc variogram data=gmout plots=observ; 
  compute novariogram nhc=35;
  coord xc=LonM yc=LatM;
  var ResidualYield;
run;

title 'Example 6';
proc variogram data=gmout plot(only)=semivar;
   compute lagd=4 maxlag=16 ndir=12 atol=22.5 bandw=20;
   coord xc=LonM yc=LatM;
   var ResidualYield;
run;

title 'Example 7';
proc variogram data=gmout plot(only)=fit;
   compute lagd=4 maxlag=16;
   directions 0(22.5,10) 90(22.5,10);
   coord xc=LonM yc=LatM;
   model form=sph;
   parms (0.) (2 to 3 by 0.5) (5 to 25 by 10) / hold=(1);
   var ResidualYield;
run;


