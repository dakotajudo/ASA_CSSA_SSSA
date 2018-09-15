
/*
References
https://support.sas.com/documentation/cdl/en/statugkrige2d/61797/PDF/default/statugkrige2d.pdf
https://support.sas.com/documentation/cdl/en/statugvariogram/61847/PDF/default/statugvariogram.pdf
https://support.sas.com/documentation/cdl/en/statugloess/61801/PDF/default/statugloess.pdf
*/

filename autofile 'c:/Work/workshop2017/autocorrelation.csv';

proc import datafile=autofile
	dbms=csv
	out=autocorrelated replace;
	getnames=yes;
run;

filename reffile 'c:/Work/workshop2017/sample.csv';

proc import datafile=reffile
	dbms=csv
	out=sample replace;
	getnames=yes;
run;

/*
Slide 56 plot variogram
We need to specify both lag distance and maximum number of lags. However, we might run
   proc variogram data=sample plot(only)=pairs;
      compute novariogram nhc=10;
      coordinates xc=LonM yc=LatM;
      var Yield;
   run;
with different values for nhc (number of histogram categories) to determine a max lag.
*/
title 'Slide 56 plot variogram';
proc variogram data=sample outvar=yieldvar;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   var Yield;
run;


/*
Slide 60 Plotting a Fitted Variogram.
If we want to plot the fit and only the fit, include 
   plot(only)=fit 
in the proc variogram line.
*/
title 'Slide 60 Yield Variogram';
proc variogram data=sample outvar=yieldvar;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   model form=sph;
   var Yield;
   store out=yieldvgm /label="Yield Variogram";
run;

/*
Slide 61 Models, Yield.
We suppress fitting to a nugget using the parameter nugget=0.
*/
title 'Slide 61 Models, Yield';
proc variogram data=sample plot(only)=fit;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   model form=sph nugget=0;
   var Yield;
run;

proc variogram data=sample plot(only)=fit;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   model form=exp;
   var Yield;
run;

proc variogram data=sample plot(only)=fit;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   model form=gauss;
   var Yield;
run;

/*
Slide 63 Moisture
*/
title 'Slide 63 Moisture Spherical';
proc variogram data=sample;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   model form=sph;
   var Moisture;
run;

/*
Slide 64 Distance
*/
title 'Slide 64 Distance Spherical';
proc variogram data=sample;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   model form=sph;
   var Distance;
run;

/*
Slide 65
*/
title 'Slide 65 Heading Spherical';
proc variogram data=sample;
   compute lagdist=5 maxlag=20;
   coordinates xc=LonM yc=LatM;
   model form=sph;
   var Heading;
run;

/*
Slide 67 Yield
Simply add ndir to produce variograms in multiple directions.
*/
title 'Slide 67 Yield Anistropy';
proc variogram data=sample;
   compute lagd=5 maxlag=20 ndir=4;
   coordinates xc=LonM yc=LatM;
   var Yield;
   model form=sph;
   store out=yieldanivgm /label="Anisotropic Yield Variogram";
run;

/*
Slide 68 Moisture
*/
title 'Slide 68 Moisture Anistropy';
proc variogram data=sample;
   compute lagd=5 maxlag=20 ndir=4;
   coordinates xc=LonM yc=LatM;
   var Moisture;
   model form=sph;
run;

/*
Slide 69 Distance
*/
title 'Slide 69 Distance Anistropy';
proc variogram data=sample;
   compute lagd=5 maxlag=20 ndir=4;
   coordinates xc=LonM yc=LatM;
   var Distance;
   model form=sph;
run;

/*
Slide 70 Heading
*/
title 'Slide 70 Heading Anistropy';
proc variogram data=sample;
   compute lagd=5 maxlag=20 ndir=4;
   coordinates xc=LonM yc=LatM;
   var Heading;
   model form=sph;
run;

/*
Slide 75-77
Note that we saved the results of the variogram fit by calling store out=yieldvgm.
If we hadn't, we might enter values manually, i.e.
   proc krige2d data=sample oute=krigyield plots=all;
     coordinates xc=LonM yc=LatM;
     predict var=Yield radius=100;
     model scale=85.2820 range=88.2322 nugget=129.06 form=sph;
     grid x=0 to 200 by 10 y=0 to 200 by 10;
     outset=yieldkrig;
   run;

It might be nice to use the anisotropic variogram, but SAS won't let us call
   restore in=yieldanivgm;
without complaint - we must select an angle.
*/
title 'Slide 75-77 Kriging 20x20';
proc krige2d data=sample oute=krigyield plots=all;
   restore in=yieldvgm;
   coordinates xc=LonM yc=LatM;
   predict var=Yield radius=100;
   model storeselect;
   grid x=10 to 190 by 10 y=10 to 190 by 10;
run;

/*
Slide 85 Comparison I,C,G
We supply the parameter randomization instead of the default = normality.
weights=distance is a inverse weighted distance.
We could also use 
   lagdistance=10 autocorrelation(weights=binary)
*/
title 'Slide 85 Comparison I,C,G';
proc variogram data=sample plots=none;
   compute novariogram autocorrelation(weights=distance assumption=randomization);
   coordinates xc=LonM yc=LatM;
   var YieldOrdered	Yield YieldDisordered YieldWhiteNoise YieldChecked;
run;

/*
Slide 95. Polynomial Regression.
*/
title 'Slide 95. Polynomial Regression';
proc glm data=autocorrelated;
   model trenderror = index;
run;
proc glm data=autocorrelated;
   model trenderror = index|index;
run;
proc glm data=autocorrelated;
   model trenderror = index|index|index;
run;
proc glm data=autocorrelated;
   model trenderror = index|index|index|index;
run;
proc glm data=autocorrelated;
   model trenderror = index|index|index|index|index;
run;

/*
We can also use orthoreg to specify polynomials more simply.
*/
proc orthoreg data=autocorrelated;
   effect poly5 = polynomial(index / degree=5);
   model trenderror = poly5;
   effectplot fit / obs;
run;


/*
Slide 97. Random Walk.
*/
title 'Detrending Random Walk';
proc glm data=autocorrelated;
   model randomwalk = index;
run;
proc glm data=autocorrelated;
   model randomwalk = index|index;
run;
proc glm data=autocorrelated;
   model randomwalk = index|index|index;
run;
proc glm data=autocorrelated;
   model randomwalk = index|index|index|index;
run;
proc glm data=autocorrelated;
   model randomwalk = index|index|index|index|index;
run;

/*
Slide 99. Trend Surface Fit
These calls are the closest I can find to reproducing the plots.
*/
title 'Slide 99 Trend Surface Fit';
proc glm data=sample;
   model Yield = LonM | LonM | LonM | LonM * LatM | LatM | LatM | LatM @3;
run;

proc glm data=sample;
   model Yield = LonM | LonM | LonM | LonM | LonM | LonM 
               * LatM | LatM | LatM | LatM | LatM | LatM @5;
run;

proc glm data=sample;
   model Yield = LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM 
               * LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM @7;
run;

proc glm data=sample;
   model Yield = LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM 
               * LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM @9;
run;

proc glm data=sample;
   model Yield = LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM
               * LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LonM | LonM @11;
run;

proc glm data=sample;
   model Yield = LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM | LonM
               * LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LatM | LonM | LonM | LonM | LonM @13;
run;



/*
Slide 99. Trend surface fit.
Some examples using orthoreg.
*/
proc orthoreg data=sample;
   effect poly5 = polynomial(LonM LatM / degree=3);
   model Yield = poly5;
   effectplot contour(x=LonM y=LatM);
run;

proc orthoreg data=sample;
   effect poly5 = polynomial(LonM LatM / degree=5);
   model Yield = poly5;
   effectplot contour(x=LonM y=LatM);
run;

proc orthoreg data=sample;
   effect poly9 = polynomial(LonM LatM / degree=9);
   model Yield = poly9;
   effectplot contour(x=LonM y=LatM);
run;

/*
Slide 108 Uniform Grid Points.
This creates a data frame defining a 20x20 grid.
*/
title 'Slide 108 Uniform Grid Points.';
data GridPoints; 
   do LonM = 5 to 195 by 10;
      do LatM = 5 to 195 by 10;
         output;
      end;
   end;
run;

/*
Slide 110. Trend Estimates.
I haven't found a simple way to extract parameters from a GLM or ORTHOREG model, which is what
we need to predict yield on a fixed grid.
Instead of a global trend, we can use LOESS. This will fit local polynomial trends using
low-order polynomials.
Note we need to explicitly save the interpolated (score) results.
*/
title 'Slide 110 Trend estimates';
proc loess data=sample;
   model Yield = LonM LatM;
   output out = LoessYield P=Fit residual=YieldResid;
   score data = GridPoints;
   ods output ScoreResults=LoessGrid; 
run;

/* Rename p_Yield to Estimate; this is how the results are stored from ODS */
data LoessGrid;
   set LoessGrid;
   Estimate = p_Yield;
run;

/*
I haven't provided the equivalent plot in R, but 
this shows that LOESS smoothing leaves a white-noise residual.
*/
proc variogram data=LoessYield;
   compute lagdist=5 maxlag=20 autocorrelation(weights=distance assumption=randomization);
   coordinates xc=LonM yc=LatM;
   model form=sph;
   var YieldResid;
run;

/*
Slide 111.
This is similar to the previous kriging call, but we use the grid data points.
*/
title 'Slide 111 Krige estimates';
proc krige2d data=sample oute=KrigGrid plots=all;
   restore in=YieldVgm;
   coordinates xc=LonM yc=LatM;
   predict var=Yield radius=100;
   model storeselect;
   grid griddata=GridPoints xc=LonM yc=LatM;
run;

/*
Comparing Interpolation.
We don't have LISA plots in SAS, but we can use variograms and global measures.
Note that the variogram implies a longer range correlation.
*/
title 'Slide 112 Comparing Interpolation.';

title 'Variogram, LOESS Estimates at Grid Points';
proc variogram data=LoessGrid;
   compute lagdist=5 maxlag=20 autocorrelation(weights=distance assumption=randomization);
   coordinates xc=LonM yc=LatM;
   model form=sph;
   var Estimate;
run;

title 'Variogram, Krig Estimates at Grid Points';
proc variogram data=KrigGrid;
   compute lagdist=5 maxlag=20 autocorrelation(weights=distance assumption=randomization);
   coordinates xc=gxc yc=gyc;
   model form=sph;
   var Estimate;
run;

/*
Slide 113. Comparing Grid Means.
*/
title 'Slide 113 Comparing Grid Means';

/*
Convert latitude and longitude to grid cell coordinates.
*/
data LoessGrid;
   set LoessGrid;
   Row = Ceil(LatM/20);
   Col = Ceil(LonM/20);
   Cell = (Row-1)*10 + Col;
   if Cell = . then delete;
run;

/*
Calculate cell means for LOESS trend.
*/
proc means data=LoessGrid;
  class Cell;
  var Estimate;
  output out=LoessCell mean=Estimate;
run;

/*
Convert Cell back to row and column.
*/
data LoessCell;
   set LoessCell;
   Row = ceil(Cell/10);
   Col = mod(Cell,10) + 1;
   if Cell = . then delete;
run;

/*
Variogram to check spatial structure
*/
title 'Variogram, Loess Means in Cells';
proc variogram data=LoessCell;
   compute lagdist=1 maxlag=10 autocorrelation(weights=distance assumption=randomization);
   coordinates xc=Row yc=Col;
   model form=sph;
   var Estimate;
run;

/*
Repeat with kriged data.
*/
data KrigGrid;
   set KrigGrid;
   Row = Ceil(gyc/20);
   Col = Ceil(gxc/20);
   Cell = (Row-1)*10 + Col;
run;


title 'Means KrigGrid';
proc means data=KrigGrid;
  class Cell;
  var Estimate;
  output out=KrigCell mean=Estimate;
run;

data KrigCell;
   set KrigCell;
   Row = ceil(Cell/10);
   Col = mod(Cell,10) + 1;
   if Cell = . then delete;
run;

title 'Variogram, Krig Means in Cells';
proc variogram data=KrigCell;
   compute lagdist=1 maxlag=10 autocorrelation(weights=distance assumption=randomization);
   coordinates xc=Row yc=Col;
   model form=sph;
   var Estimate;
run;

data sample;
   set sample;
   Row = Ceil((LatM+0.01)/20);
   if(Row>10) then Row=10;
   Col = Ceil((LonM+0.01)/20);
   if(Col>10) then Col=10;
   Cell = (Row-1)*10 + Col;
run;

title 'Cell Means';
proc means data=sample;
  class Cell;
  var Yield;
  output out=MeanCell mean=Estimate;
run;

data MeanCell;
   set MeanCell;
   Row = ceil(Cell/10);
   Col = mod(Cell,10) +1;
   if Cell = . then delete;
run;

title 'Variogram, Yield Means in Cells';
proc variogram data=MeanCell;
   compute lagdist=1 maxlag=10 autocorrelation(weights=distance assumption=randomization);
   coordinates xc=Row yc=Col;
   model form=sph;
   var Estimate;
run;
