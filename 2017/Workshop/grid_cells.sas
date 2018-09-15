FILENAME REFFILE 'Y:/Work/git/statistics/design_documents/yield_monitor_data/workshop2017/sample.csv';

proc import datafile=reffile
	dbms=csv
	out=sample;
	getnames=yes;
run;


title 'Sample Kriging';
ods graphics on;
proc krige2d data=sample;
   coordinates xc=LonM yc=LatM;
   predict var=Yield radius=100;
   model scale=7.4599 range=30.1111 form=SPHERICAL;
   grid x=0 to 200 by 10 y=0 to 100 by 10;
run;

ods graphics off;