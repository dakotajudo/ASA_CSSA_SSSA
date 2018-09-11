
/*		EXAMPLE:  META-ANALYSIS WORKSHOP BY LARRY MADDEN

Case study #3: Effect of fungicide treatment on yield of maize (corn).
Source: Paul, Madden, Bradley, et al. (2011. Phytopathology 101: 1122-1132).

Paper dealt with four possible fungicide treatment programs. Here we
consider only one treatment:
	Application of Quilt (azoxystrobin + propiconazole)at labeled rate
	between VT (tassel emergence) and R1 (silk emergence). K = 61 studies

Variables:
trial:		ID for trial (study), numeric variable
year:		year of study	
rep:		number of replicates in the primary study
yld_chk		mean yield for the control (check) (bushels/acre)
yld_trt		mean yield for the fungicide treatment 
yld_diff	difference in mean yield (yld_trt - yld_chk),
			the estimated Effect Size for the meta-analysis
resid_var	residual variance in the individual study
si2			sampling variance (i.e., within-study variance of DIFFERENCE),
			= 2*resid_var/rep (with no missing data), held fixed in analysis
sed			standard error of the difference, often reported in publications,
			= sqrt(si2)
lower		lower limit of 95% confidence interval for yld_diff (effect size),
			approximate, for each study
upper 		upper limit of 95% confidence interval for yld_diff (effect size),
			approximate, for each study
baseyld		categorical moderator variable, for magnitude of yield
			in the control (1: low, 2: high yield)
basedisease	categorical (1,2,3) moderator variable, for magnitude of 
			foliar disease severity in control
			(1: low disease [<5%], 2: high disease, 3: no measurement)

In Paul et al. (2011), yields were converted to kilograms/hectare, but here
we work with bushels/acre. Paul et al. used somewhat different model-fitting
methods (ML) compared to what we do here (REML). We also use a different method
to estimate the degrees of freedom. Thus, results here may be slightly 
different from those reported in the paper.

Program made available without warranties.  L. Madden (Ohio State Univ.), 9/2-2015
*/


*---Run the meta_macros.sas program first, or use this include statement...;
*%include 'c:\users\madden.1\My Documents\My SAS Files\Meta-analysis Tri-Societies\meta_macros.sas';

title 'Meta-analysis of the effect of Quilt on corn yield'; 
data yield;
*infile datalines dlm='09'x;		*<--use this line with SAS UE (for embedded tabs);
input trial year rep yld_chk yld_trt yld_diff resid_var si2 sed lower upper baseyld basedisease;
datalines;
 1  2009  6   241.60   253.10    11.50   246.81    82.27     9.07    -6.64    29.64  2  .
 2  2009  6   257.60   262.20     4.60   101.60    33.87     5.82    -7.04    16.24  2  .
 3  2008  4   203.00   218.00    15.00   175.25    87.63     9.36    -3.72    33.72  2  2
 4  2007  4   233.89   231.97    -1.92    76.42    38.21     6.18   -14.28    10.44  2  3
 5  2007  4   182.29   189.81     7.52    93.65    46.83     6.84    -6.17    21.21  1  3
 6  2007  4   193.58   191.55    -2.03   316.30   158.15    12.58   -27.18    23.12  2  3
 7  2007  4   197.57   192.00    -5.57   316.30   158.15    12.58   -30.72    19.58  2  3
 8  2007  4   134.00   139.57     5.57   169.94    84.97     9.22   -12.87    24.01  1  1
10  2007  5   170.76   175.18     4.42     0.85     0.34     0.58     3.25     5.59  1  3
11  2007  6   183.23   196.63    13.40   172.44    57.48     7.58    -1.76    28.56  1  2
12  2007  6   195.47   213.39    17.92   133.14    44.38     6.66     4.60    31.24  2  2
 9  2007  4   182.62   170.81   -11.81   340.14   170.07    13.04   -37.89    14.27  1  2
13  2007  3   251.75   252.17     0.42   123.49    82.33     9.07   -17.73    18.57  2  2
14  2007  4   178.50   176.57    -1.93   103.67    51.84     7.20   -16.33    12.47  1  2
15  2007  3   238.87   244.81     5.94   123.49    82.33     9.07   -12.21    24.09  2  2
16  2007  4   181.26   186.07     4.82   103.67    51.84     7.20    -9.58    19.22  1  2
17  2007  3   236.54   236.28    -0.26   123.49    82.33     9.07   -18.41    17.89  2  2
18  2007  4   154.21   154.77     0.56   103.67    51.84     7.20   -13.84    14.96  1  2
19  2007  3   231.35   232.63     1.27   123.49    82.33     9.07   -16.88    19.42  2  2
20  2007  4   163.38   185.09    21.71   103.67    51.84     7.20     7.31    36.11  1  1
21  2007  4   244.45   239.52    -4.93     7.34     3.67     1.92    -8.76    -1.10  2  3
22  2008  4   213.62   205.86    -7.76   336.73   168.37    12.98   -33.71    18.19  2  1
23  2008  4   202.29   215.36    13.07   336.73   168.37    12.98   -12.88    39.02  2  1
24  2008  6   190.70   194.03     3.33   105.73    35.24     5.94    -8.54    15.20  2  1
25  2008  4   265.48   280.10    14.63    57.98    28.99     5.38     3.86    25.40  2  1
26  2007  4   227.99   228.87     0.88    28.71    14.36     3.79    -6.70     8.46  2  3
27  2007  4   227.90   238.13    10.23   141.87    70.94     8.42    -6.61    27.07  2  3
28  2007  4   234.23   239.38     5.15   141.87    70.94     8.42   -11.69    21.99  2  3
29  2005  6   223.00   228.10     5.10   122.81    40.94     6.40    -7.70    17.90  2  .
30  2009  6   257.60   275.30    17.70    68.94    22.98     4.79     8.11    27.29  2  .
31  2007  4   193.50   193.25    -0.25    65.01    32.51     5.70   -11.65    11.15  2  1
32  2007  2   168.35   167.20    -1.15   264.06   264.06    16.25   -33.65    31.35  1  3
33  2007  2   192.40   195.40     3.00     1.00     1.00     1.00     1.00     5.00  2  3
34  2008  4   114.97   108.62    -6.35    61.12    30.56     5.53   -17.41     4.71  1  3
35  2008  4   196.00   196.00     0.00   390.61   195.31    13.98   -27.95    27.95  2  2
36  2007  2   182.46   181.45    -1.01     0.05     0.05     0.22    -1.46    -0.56  1  3
37  2007  4   153.28   163.95    10.67    76.68    38.34     6.19    -1.71    23.05  1  2
38  2007  4   221.58   219.74    -1.84    15.10     7.55     2.75    -7.34     3.66  2  3
39  2007  4   178.50   206.25    27.75   437.80   218.90    14.80    -1.84    57.34  1  1
40  2009  6   185.50   202.80    17.30   520.58   173.53    13.17    -9.05    43.65  1  2
43  2004  4   115.50   156.20    40.70   282.78   141.39    11.89    16.92    64.48  1  2
44  2005  4    94.50   115.90    21.40   126.55    63.28     7.95     5.49    37.31  1  2
45  2006  4   128.30   176.62    48.32   258.48   129.24    11.37    25.58    71.06  1  2
46  2007  4    82.47   121.38    38.91   138.93    69.47     8.33    22.24    55.58  1  2
47  2008  4   118.80   139.30    20.50    47.50    23.75     4.87    10.75    30.25  1  2
48  2009  4   186.76   201.16    14.40   243.97   121.99    11.04    -7.69    36.49  1  1
49  2008  4   171.77   175.15     3.38   248.46   124.23    11.15   -18.91    25.67  1  1
50  2007  4   114.94   108.27    -6.67   864.58   432.29    20.79   -48.25    34.91  1  3
41  2007  4   222.06   219.74    -2.32     3.26     1.63     1.28    -4.87     0.23  2  3
42  2007  4   205.41   209.56     4.15    15.67     7.84     2.80    -1.45     9.75  2  3
51  2009  6   191.70   154.00   -37.70  1467.00   489.00    22.11   -81.93     6.53  2  1
52  2007  4   251.00   255.00     4.00   143.88    71.94     8.48   -12.96    20.96  2  3
53  2007  4   208.25   215.00     6.75    83.32    41.66     6.45    -6.16    19.66  2  3
54  2007  4   161.00   157.18    -3.82   251.14   125.57    11.21   -26.23    18.59  1  1
55  2008  4   172.00   178.00     6.00   115.88    57.94     7.61    -9.22    21.22  1  2
56  2007  4   214.41   192.10   -22.31    78.82    39.41     6.28   -34.87    -9.75  2  2
57  2007  3   255.17   268.89    13.72   123.49    82.33     9.07    -4.43    31.87  2  2
58  2007  4   187.52   175.44   -12.09   103.67    51.84     7.20   -26.49     2.31  1  1
59  2007  4   205.65   193.64   -12.02   103.67    51.84     7.20   -26.42     2.38  2  1
60  2007  2   177.30   176.25    -1.05   145.20   145.20    12.05   -25.15    23.05  1  3
61  2006  4   154.01   164.84    10.83   187.50    93.75     9.68    -8.53    30.19  1  1
run;

*---Make a second variable to identify the study (trial), this one being a character
	variable.;
data yield; set yield;
study = put(trial,2.);	*<--make a character version of the trial ID; 
wtdiff = 1/si2;			*<--within-study weight is the inverse of the sampling variance;
run;

			/*  ods html close; ods html style=statistical; */

proc print data=yield;
run;


********************************************************************************;
************************  Graphing the data  ***********************************;
********************************************************************************;

ods graphics on / height=6in width=3.5in; 
proc sgplot data=yield noautolegend;
title2;
scatter x=yld_diff y=study	
	/	xerrorlower=lower xerrorupper=upper
		markerattrs=(color=blue symbol=squarefilled size=7pt)
		errorbarattrs=(color=blue pattern=1 thickness=1);
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5);
xaxis label="Yield difference (bu/acre)" ;
yaxis label="Study" ;		*<--study as a character variable;
run;

*---A different type of Forrest plot (sorted). Two versions. Need to sort 
	data first;
proc sort data=yield out=yieldsort;
by yld_diff;
run;
proc sgplot data=yieldsort noautolegend;
title2;
scatter x=yld_diff y=study	
	/	xerrorlower=lower 
		xerrorupper=upper
		markerattrs=(color=blue symbol=squarefilled size=7pt)
		errorbarattrs=(color=blue pattern=1 thickness=1);
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5);
xaxis label="Yield difference (bu/acre)" ;
yaxis label="Study" ;
run;


ods graphics / width=6in height=3.5in;
*---see Madden & Paul (2011) for an example of the following HORIZONTAL Forrest graph;
proc sgplot data=yieldsort noautolegend;
title2;
vbarparm response=yld_diff category=study / 
	limitupper=upper limitlower=lower limitattrs=(thickness=.0001in);;

refline 0 / axis=y lineattrs=(color=black pattern=1 thickness=1.5);
yaxis label="Yield difference (bu/acre)" ;
xaxis label="Study" type=discrete fitpolicy=thin;
run;



ods graphics / width=5in height=4in;

*---Get a funnel plot using macro. One may have to use trial and error
	to decide on the limits for precision (precision = 1/sqrt(si2) = sqrt(wtdiff)).
	Note that these graphs are not overly helpful for THIS example (dominated by 
	one or a few points, the rest with very similar SEs.;

%funnel(dfile=yield,es=yld_diff,wgt=wtdiff,study=study,minprec=.05,maxprec=5);run;

*---drop an outlier to better visualize funnel plot (for the rest of the data). Note 
	that ALL the data are used in the analysis.;
data yieldshort; set yield;	*<--data set with one fewer observation;
if (trial ne 36);
run;

%funnel(dfile=yieldshort,es=yld_diff,wgt=wtdiff,study=study,minprec=.05,maxprec=2);run;




*********************************************************************************;
******** Univariate meta-analysis model (different ways of fitting) *************;
*********************************************************************************;


*---In the Paul et al. article, ML (not REML) model fitting was done. Here we use REML 
	(called RSPL in GLIMMIX).;

*---Fixed-effect model;
title 'Meta-analysis of the effect of Quilt on corn yield'; 
proc glimmix  data=yield;
	title2 'Fixed-effect model';
	class TRIAL;
	weight wtdiff;			*<--specify 1/si2 as the weight;
	model yld_diff = / s cl;
	parms (1) / hold=1; 	*<--the within-study (i.e., sampling) variance held fixed at 1;
	estimate 'mean diff' int 1 / cl;
run;
*^--Use a combination of weight (=1/si2), and hold the residual variance fixed at 1 (using
	parms statement with hold option. When there are no random effects, the procedure
	put the scale parameter (i.e., residual or within-study sampling variance) in the 
	table of parameter estimates (together with the "intercept");


*---Random-effect model (note the random trial effect).;
proc glimmix  data=yield;
	title2 'Random-effect model';
	class TRIAL;
	weight wtdiff;			*<--specify 1/si2 as the weight;
	model yld_diff = / s cl;
	random trial;
	parms (1) (1) / hold=2; *<--among-study variance and within-study variance (latter held fixed at 1);
	estimate 'mean diff' int 1 / cl;
run;


proc glimmix  data=yield;
	title2 'Random-effect model, with likelihood test for among-study variance';
	class TRIAL;
	weight wtdiff;
	model yld_diff = / s cl;
	random trial;
	covtest 0 / cl(type=profile);	*<--test of among-study variance (Ho: sigma2 = 0);
	parms (1) (1) / hold=2; *<--among-study variance and the within-study variance (latter held fixed);
	estimate 'mean diff' int 1 / cl;
run;
*^--note the the confidence interval for sigma2 is not symmetrical;



*---Conduct a meta-analysis using the method of moments (using macro by Lipsey and Wilson).
	Confidence intervals are based on large-sample theory (z and not t statistic);
%meanes(yld_diff,wtdiff,dsn=yield,print=raw) ;

*---Use SAS procedure (PROC GLM) and post-procedure processing to get Cochran's Q 
	and related statistics (all for	method of moments). Macro uses portions of GLM output
	(most of it is not appropriate for this application) to determine the various statistics.
	Compare with MEANES macro from Lipsey and Wilson. Savvy SAS users can study the
	macro code to learn about moment (DL) estimation of model;
%moments(dfile=yield,es=yld_diff,wgt=wtdiff,study=trial);

*---Get prediction interval for mean effect size and also get H^2 and I^2 statistics, 
	all for the REML estimates.
	Must first run %moments before running %H2I2_ (the latter uses a file created
	by the former).;
%H2I2_(var=71.908, es=5.29, se=1.472);



********************************************************************************;
***** OPTIONAL: hard ways of fitting the univariate meta-analytical model  *****;
********************************************************************************;

*---Now for the hard way to do the random-effects analysis. Create a file with the within-study
	variances (one observation for each trial) and the starting value of the among-study 
	variance. The among-study variance has to be first. Here is one way to do this.....;

*---data MUST by sorted by trial (study) first, to match up two separate files in the PROC.
	GLIMMIX or MIXED internally sorts the levels of the random effect (the trials), so
	you need to match this in a created file with sampling variances.;
proc sort data=yield out=yieldsort;
by trial;
run;
data varparm0;
set yieldsort;
keep trial si2;	*<--need to keep the trial ID (could be "study" instead) and the sampling variance (not the weight);
run;
data varparm1;	*<--starting value for among-study variance (only one record);
input est;
datalines;
1
;

*---stack the above two files with variance values (estimate or actual). Rename the
	variance as "est" or "estimate".;
data varparm; set varparm1 varparm0(rename=(si2=est));	*<--stack the files together.;

*---The file varparm has 1+K rows (1+61 here), a row for each variance parameter. First row is the 
	among-study variance guess, and then the next 61 rows are the within-study (sampling or residual) 
	variances for the 61 studies. The variance is called EST, and there should be a variable with the TRIAL
	name (for identification purposes -- error checking).;
*---One calls the varparm variance file using the PDATA= option in GLIMMIX or MIXED. Ones needs
	a statement to let the procedure know that there is a different residual for each trial.;

proc print data=varparm; run;

proc glimmix  data=yieldsort method=rspl;
	title2 'Random-effect model, with hard way of specifying the separate residual variances';
	title3 'Use of PDATA= and GROUP= options (no weights)';
	class trial;
	*---no weight statement (compare with above);
	model yld_diff = / s cl;
	random trial;
	random _residual_ / GROUP=trial type=simple;	*<--there is a separate within-study variance for each trial;
	parms / PDATA=varparm hold=2 to 62; *<--among-study variance and  within-study variances (latter held fixed);
	estimate 'mean diff' int 1 / cl;
run;
*^--Uses a "random _residual_ statement to specify that each trial has a separate residual variance.
	In MIXED, one uses "repeated" statement instead. In output, note that one sees the fixed sampling
	variance for each study (not a "1" for residual).;

********************************************************************************;
********************************************************************************;





********************************************************************************;
*********************  Moderator variable analysis *****************************;
********************************************************************************;

*---Does yield in the control affect the effect size? BASEYLD (base yield) is 
	categorical, with two levels for low and high yield;
proc glimmix  data=yield;
	title2 'Random effect model, with BASEYLD moderator variable';
	class trial baseyld;		*<--make sure that this moderator is listed as class variable;
	weight wtdiff;
	model yld_diff = baseyld / s cl ddfm=kr;	*<--give moderator in model statement;
	random trial;
	parms (1) (1) / hold=2; *<--among-study variance and the within-study variance (latter held fixed);
	lsmeans baseyld / cl diff lines plots=mean;	*<--get means for each level, and difference;
run;


*---Does disease severity in the control affect the effect size? BASEDISEASE is 
	categorical (factor) variable with three levels ;
proc glimmix  data=yield;
	title2 'Random effect model, with BASEDISEASE moderator variable.';
	class trial baseyld basedisease;	*<-make sure that moderators are listed as class variable;
	weight wtdiff;
	model yld_diff = basedisease / s cl ddfm=kr;
	random trial;
	parms (1) (1) / hold=2; *<--among-study variance and the within-study variance (latter held fixed);
	*---use LSMESTIMATE to get contrasts for levels of moderator (one of several ways to do this;
	lsmestimate basedisease 'low vs high' [1,1] [-1,2], 
							'low vs none' [1,1] [-1,3], 
							'high vs none' [1,2] [-1,3],
							'high vs others' [-.5,1] [-.5,3] [1,2] / cl;
	estimate 'high vs others' basedisease -1 2 -1 / divisor=2 cl;	*<--another way of doing one contrast;
	lsmeans basedisease / cl diff lines;
run;
*^--LSMESTIMATE statement given here without explantion or instruction (one of the ways
	of doing contrasts, this time with so-called non-positional syntax);

*---look at continuous moderator variable (yld_chk). First a graph......;
proc sgplot data=yield;
title2 'effect size versis baseline yield';
bubble y=yld_diff x=yld_chk size=si2;	*<--bubble size proportional to sampling variance (not weight);
xaxis label = 'baseline yield (yld_chk)';
yaxis label = 'effect size (yld_diff)';
run;


proc glimmix  data=yield ;;
	title2 'Random effect model, YLD_DIFF, with YLD_CHK continuous moderator variable';
	class trial ;			*<--moderator is not a class variable;
	weight wtdiff;
	model yld_diff = yld_chk / s cl ddfm=kr;
	random trial;
	parms (50) (1) / hold=2; *<--among-study variance and the within-study variance (latter held fixed);
	output OUT=yieldspline pred(noblup)=pred lcl(noblup)=low ucl(noblup)=high;
	estimate 'mean ylddiff @ X=125' int 1 yld_chk 125 / cl;		*<--example prediction at two Xs;
	estimate 'mean ylddiff @ X=150' int 1 yld_chk 150 / cl;
	estimate 'mean ylddiff @ X=250' int 1 yld_chk 250 / cl;
run;
*^--note that predictions (and conf. int.) are stored in output file (out=yieldspline) for plotting below.;

proc sort data=yieldspline out=yieldspline;	*<--sort for smooth plotting of predicted values with observed;
by pred;
run;
*proc print data=yieldspline;run;

*---observed and predicted;
proc sgplot data=yieldspline noautolegend;
title2 'Effect of baseline yield on effect size';
scatter x=yld_chk y=yld_diff / markerattrs=(symbol=circlefilled color=blue size=10);
series x=yld_chk  y=pred / lineattrs=(color=blue pattern=1 thickness=2);
xaxis label = 'baseline yield (yld_chk)';
yaxis label = 'effect size (yld_diff)';
run;

*---Get prediction and confidence interval. This is not the same as simply doing a
	weighted regression analysis.;
proc sgplot data=yieldspline noautolegend;
title2 'Effect of baseline yield on effect size';
scatter x=yld_chk y=yld_diff / markerattrs=(symbol=circlefilled color=blue size=10) ;
series x=yld_chk  y=pred / lineattrs=(color=blue pattern=1 thickness=2);
series x=yld_chk y=low / lineattrs=(color=red pattern=2 thickness=2);
series x=yld_chk y=high / lineattrs=(color=red pattern=2 thickness=2);
xaxis label = 'baseline yield (yld_chk)';
yaxis label = 'effect size (yld_diff)';
run;


/*
^^WARNING^^: there are some potential problems with the use of yld_chk as a moderator
variable. The effect size (difference) is made up of the difference of yld_trt and yld_chk. 
Thus, there is a functional negative correlation between the effect size and the moderator
variable. Also, the moderator is measured with error. These issues are not 
incorporated into the above analysis. There is a more sophisticated way to address
the effect of yld_chk on the effect size (yld_trt - yld_chk). This requires
multi-treatment meta-analysis (see optional material below).
*/

*******************************************************************************;
*******************************************************************************;





****************************************************************************;
****************************************************************************;
******************  MULTI-TREATMENT META-ANALYSIS  *************************;
****************************************************************************;
****************************************************************************;

*---Stack the control and treatment observations (two records instead of one).
	Determine the appropriate "sampling variance" (= 1/2 of variance
	of a difference)....;
data stack;
set yield;
array response {2} yld_chk yld_trt;
do trt = 1 to 2;
	y = response{trt};
	si2s = si2/2;	*<--sampling variance (= HALF the sampling variance for a DIFFERENCE !);
	wts  = 1/si2s;	*<--weight is 1/(new sampling variance);
	output;
	end;
keep trial study rep trt y resid_var si2s wts si2 wtdiff basedisease;	*<--clean up file;
run;

*---The above results in two records for each trial, one for check and one for treatment, 
	with an indicator variable to identify the treatments;
proc print data=stack;run;



*---Multi-treatment (network meta-analysis) random-effect model (note the fixed trial effect
	and the random trial*trt effect).;
proc glimmix  data=stack method=rspl;
	title2 'Multi-treatment random-effect model, with fixed TRIAL main effect';
	title3 'Random trial x treatment';
	class trial  trt;
	weight wts;				*<--specify 1/si2s as the weight;
	model y = trial trt / ddfm=betwithin noint;
	random trt*trial;		*<--random effect of trial (study) on the treatment effect (for u_ij);
	parms (40) (1)/ hold=2;	*<--among-study variance and within-study variance (latter held fixed at 1);
	lsmeans trt / cl diff;
	estimate 'difference' trt -1 1 / cl;	*<--redundant with "diff" in LSMEANS. demonstration;
	nloptions tech=nrridg;
run;

*---Compare above two-treatment model fit with the univariate one from earlier in file....
	This is just a repeat of the earlier analysis.;
proc glimmix  data=yield ;
	title2 'Univariate Random-effect model, repeat of earlier';	*<--repeating univariate analysis, just to compare;
	class TRIAL;
	weight wtdiff;			*<--specify 1/si2 as the weight;
	model yld_diff = / s cl;
	random trial;			*<--This is for u_i;
	parms (40) (1) / hold=2; *<--among-study variance and within-study variance (latter held fixed at 1);
	estimate 'mean diff' int 1 / cl;
run;
*^--Note that the trial variance for the 'difference effect size' is double the trt*trial 
	variance of the two-treatment analysis of 'means'. This works out to give identical 
	results for the mean (and SE) of the difference.;


*---Multi-treatment Random-effect model (note the random TRIAL and TRT*TRIAL effects).
	This is not the same model as with a fixed trial effect (see above). However, 
	because all trials have both treatments, the mean (and SE) results are the same here.;
proc glimmix  data=stack method=rspl;
	title2 'Multi-treatment RANDOM-effect model: one version';
	class trial trt;
	weight wts;					*<--specify 1/sis2 as the weight;
	model y =  trt / ddfm=betwithin;
	random trial trt*trial;		*<--two random effects (this is for beta_i and u_ij);
	parms (1) (10) (1) / hold=3; *<--variances for trial, triat*trt, residual (latter held fixed at 1);
	lsmeans trt / cl diff;
	estimate 'difference' trt -1 1 / cl;	*<--redundant with "diff" in LSMEANS. Demonstration;
	nloptions tech=nrridg;		*<--optional optimization method (works better here);
run;


*---Multi-treatment Random-effect model. Equivalent way of writing the above model.
	Here we use the subject= syntax on the random statement. Same as above or below.
	This gives two random effect terms (in addition to the sampling variance).;
proc glimmix  data=stack method=rspl;
	title2 'Multi-treatment random-effect model, using subject= syntax in random statement';
	title3 '(equivalent to writing random trial trial*trt;)';
	class trial trt;
	weight wts;					*<--specify 1/sis2 as the weight;
	model y =  trt / ddfm=betwithin;
	random int trt / sub=trial type=VC;	*<--VC is variance components;
	parms (1000) (20) (1) / hold=3; *<--among-study var. and covar., and within-study variance (latter held fixed at 1);
	lsmeans trt / cl diff;
	estimate 'difference' trt -1 1 / cl;	*<--redundant with "diff" in LSMEANS. Demonstration;
	nloptions tech=nrridg;
run;

*---Multi-treatment Random-effect model. Equivalent way of writing the above model.
	Here we use so-called Compound Symmetry structure for the between-trial variance-covariance
	matrix. This gives two random effect terms (in addition to the sampling variance).;
proc glimmix  data=stack method=rspl;
	title2 'Multi-treatment random-effect model, compound symmetry (CS) version';
	title3 '(equivalent to writing random trial trial*trt;)';
	class trial trt;
	weight wts;					*<--specify 1/sis2 as the weight;
	model y =  trt / ddfm=betwithin;
	random trt / sub=trial type=CS G GCORR;	*<--Compound Symmetry gives you two var-cov parameters;
	parms (10) (100) (1) / hold=3; *<--among-study var. and covar., and within-study variance (latter held fixed at 1);
	lsmeans trt / cl diff;
	estimate 'difference' trt -1 1 / cl;	*<--redundant with "diff" in LSMEANS. Demonstration;
	nloptions tech=nrridg;
run;


/*
As an aside, one can directly assess the effect of yld_chk on the effect size of
yld_diff = yld_trt - yld_chk, by using the variances and covariances in the G
matrix displayed in the above output (for the CS structure). This approach
requires the use of a random main effect of study. This overcomes 
problems described for the univariate analysis of the effect of yld_chk, since
now both means are treated as response variables. The slope of 
(yld_trt - yld_chk) in relation to yld_chk is given by 
	slope = (cov/var)-1 = -0.022.
where var is the among-study treatment-effect variance (1658.2 in above G output, which 
is also the sum of 1622.25 and 35.9443), and cov is the covariance term (1622.25), both in
the G matrix. The estimate is smaller than found for the univariate analysis, with
yld_chk as the moderator (-0.09). To get a SE for this slope, one needs to use
large-sample theory and the delta-method. This is exactly done using NLMIXED below.

For more details on this, see Paul et al. (Phytopathology 98: 999-1011 [2008]), and
Arends (Statistics in Medicine 19: 3497-3518 [2000]).

There is another way to do this, using a multiplicative mixed model. Not discussed
here. See Piepho, Madden, and Williams (Statistics in Medicine 34: 582-594 [2015])
for more details (and a link to the SAS code).
*/
				
****************************************************************************;
****************************************************************************;




*****************************************************************************;
****** OPTIONAL: MODERATOR VARIABLES IN MULTI-TREATMENT META-ANALYSIS *******;
*****************************************************************************;
		
*---first re-look at univariate approach with basedisease moderator (as a reminder)...;
proc glimmix  data=yield;*<--original unstacked data file;
	title2 'Random effect model, with BASEDISEASE moderator variable (low, high)';
	title3 'repeat of univariate analysis of the difference';
	class trial baseyld basedisease;
	weight wtdiff;
	model yld_diff = basedisease / s cl ddfm=kr;
	random trial;
	parms (1) (1) / hold=2; *<--among-study variance and the within-study variance (latter held fixed);
	lsmestimate basedisease	'low vs high' [1,1] [-1,2], 
							'low vs none' [1,1] [-1,3], 
							'high vs none' [1,2] [-1,3],
							'high vs others' [-.5,1] [-.5,3] [1,2] / cl;
	estimate 'high vs others' basedisease -1 2 -1 / divisor=2 cl;
	lsmeans basedisease / cl diff lines;
run;


*---With multiple treatments, the added term in the model is trt*moderator,
	not just moderator variable main effect. This gives _EFFECT OF_ moderator 
	on the treatment effect.;

*---Multi-treatment Random-effect model (note the fixed trial effect).
	Many fixed-effect parameters are not estimable, but the ones we need
	are estimable, especially contrasts (differences).
	Note that the model includes trt*X (not X as a main effect).;
proc glimmix  data=stack method=rspl;	
	title2 'Multi-treatment random-effect model, with fixed TRIAL main effect';
	title3 'Moderator: basedisease, using trt*basedisease in model';
	class trial  trt basedisease;
	weight wts;			*<--specify 1/si2s as the weight;
	model y = trial trt trt*basedisease / noint ddfm=kr ;	*<--note the KR ddf method;
	random trt*trial;
	parms (1) (1) / hold=2; *<--among-study variance and within-study variance (latter held fixed at 1);
	
	*---below, two ways to get treatment differences at each level of moderator...
		use LSMESTIMATE or ESTIMATE...... Duplicates some univariate analysis
		(means in univariate analysis of treatment difference).;
	lsmestimate trt*basedisease 
		'trt2-1,basedis 1' [-1,1 1] [1,2 1],
		'trt2-1,basedis 2' [-1,1 2] [1,2 2],
		'trt2-1,basedis 3' [-1,1 3] [1,2 3];	*<--trt difference at each baseline;

	*---get DIFFERENCE of effect sizes for DIFFERENCE of the levels of the moderator.
		For example, first one is difference in yield (yld_trt-yld_chk) for difference in 
		baseisease between 1 and 2. Duplicates some output from univariate analysis
		(differences in means in univariate analysis of treatment differences)....;
	lsmestimate trt*basedisease 
		'trt2-1,basedis 1-2' [-1,1 1] [1,2 1] [1,1 2] [-1,2 2],
		'trt2-1,basedis 1-3' [-1,1 1] [1,2 1] [1,1 3] [-1,2 3],
		'trt2-1,basedis 2-3' [-1,1 2] [1,2 2] [1,1 3] [-1, 2 3],
		'trt2-1,basedis 2vs others' [-1,1 2] [1,2 2] [0.5,1 1] [-0.5,2 1] [0.5,1 3] [-0.5,2 3];

	*---Below is another way of getting the treatment difference effect size (trt-check)
		for each level of the moderator....;
	estimate 'trt1-2@basedis 1' trt -1 1 trt*basedisease -1 0 0 1 0 0;	*<--trt diff. for each X level;	
	estimate 'trt1-2@basedis 2' trt -1 1 trt*basedisease 0 -1 0  0 1 0;		
	estimate 'trt1-2@basedis 3' trt -1 1 trt*basedisease 0 0 -1  0 0 1;		
	estimate 'trt1-2,basedis 1-2' trt*basedisease -1 1 0 1 -1 0; *<--trt diff. for diff. in X;
	estimate 'trt1-2,basedis 1-3' trt*basedisease -1 0 1 1 0 -1;	
	estimate 'trt1-2,basedis 2-3' trt*basedisease 0 -1 1 0 1 -1;	
	*nloptions tech=nrridg;
run;
*^--The above duplicates key output of the univariate moderator analysis (must 
	know where to look in output). Not covered.;



*---Multi-treatment RANDOM-effect model;
proc glimmix  data=stack method=rspl;  
	title2 'Multi-treatment random-effect model, with fixed TRIAL main effect';
	class trial  trt basedisease;
	weight wts;			*<--specify 1/si2s as the weight;
	model y =  trt trt*basedisease / noint ddfm=kr ;
	random trial trt*trial;		*<--random effects for trial and trt*trial;
	parms (1) (1) (1) / hold=3; *<--among-study variances and within-study variance (latter held fixed at 1);
	lsmeans trt trt*basedisease / cl diff ;

	*---below, two ways to get treatment differences at each level of moderator...
		use LSMESTIMATE or ESTIMATE (below)...... Duplicates some univariate analysis
		(means in univariate analysis of treatment difference).;
	lsmestimate trt*basedisease 
		'trt2-1,basedis 1' [-1,1 1] [1,2 1],
		'trt2-1,basedis 2' [-1,1 2] [1,2 2],
		'trt2-1,basedis 3' [-1,1 3] [1,2 3];	

	*---get DIFFERENCE of effect sizes for DIFFERENCE of the levels of the moderator.
		For example, first one is difference in (yld_trt-yld_chk) for difference in 
		baseisease between 1 and 2. Duplicates some output from univariate analysis
		(differences in means in univariate analysis of treatment differences).;
	lsmestimate trt*basedisease 
		'trt2-1,basedis 1-2' [-1,1 1] [1,2 1] [1,1 2] [-1,2 2],
		'trt2-1,basedis 1-3' [-1,1 1] [1,2 1] [1,1 3] [-1,2 3],
		'trt2-1,basedis 2-3' [-1,1 2] [1,2 2] [1,1 3] [-1, 2 3],
		'trt2-1,basedis 2vs others' [-1,1 2] [1,2 2] [0.5,1 1] [-0.5,2 1] [0.5,1 3] [-0.5,2 3];

	*---Below is another way of getting the treatment difference effect size (trt-check)
		for each level of the moderator....;
	estimate 'trt1-2@basedis 1' trt -1 1 trt*basedisease -1 0 0 1 0 0;		
	estimate 'trt1-2@basedis 2' trt -1 1 trt*basedisease 0 -1 0  0 1 0;		
	estimate 'trt1-2@basedis 3' trt -1 1 trt*basedisease 0 0 -1  0 0 1;		
	estimate 'trt1-2,basedis 1-2' trt*basedisease -1 1 0 1 -1 0;	
	estimate 'trt1-2,basedis 1-3' trt*basedisease -1 0 1 1 0 -1;	
	estimate 'trt1-2,basedis 2-3' trt*basedisease 0 -1 1 0 1 -1;	
	*nloptions tech=nrridg;
run;

****************************************************************************;
****************************************************************************;



****************************************************************************;
******* OPTIONAL: ALTERNATIVE WAY OF DOING MULTI-TREATMENT ANALYSIS ********;
****************************************************************************;
/*
Below we show a different way of performing a multi-treatment meta-analysis
using NLMIXED. Code here is just for two treatments, but can be 
generalized to q treatments. Reason for this: formally quantifying the 
effect of the baseline (yield in the control, which is one of the two
treatments) on the effect size (the mean difference). Full explanations
are not possible here. This is for the savvy mixed-model person....

Note that NLMIXED uses ML, not REML. This makes a small difference (one
could repeat earlier analysis with method=mspl to be compatible with 
the following.
*/



data stack; set stack;
c1 = 0;
c2=0;
if (trt eq 1) then c1 = 1;
if (trt eq 2) then c2 = 1;
run;


title2 'analysis with NLMIXED, getting slope and intercept for baseline effect on Effect Size';
title3 '(see slope_y-x:x for effect of yld_chk on effect size (a difference)';
proc nlmixed data=stack cov corr tech=newrap ;
parms mean1= 300 mean2 = 300 
	var1 = 1700 cov12 =  1600 ;
model y ~ normal(beta1*c1 + beta2*c2, 1/wts);
random beta1 beta2 ~ normal([mean1,mean2],
	[var1,cov12,var1]) subject=trial;
estimate 'effect size' mean2 - mean1;
estimate 'slope_y:x' cov12/var1;
estimate 'slope_y-x:x' cov12/var1 - 1;
estimate 'slope_x-y:x' 1 - cov12/var1;
run;
*^--Note: the "slope_y-x:x" parameter is for 
	(yld_trt - yld_chk) as a function of yld_chk.
	This proc directly gives the estimated SE (delta method). Thus,
	it has an advantage over post-processing values from GLIMMIX.
	See above commentary where we calcuated this 'by hand' after
	running GLIMMIX for the multi-treatment dataset.;

****************************************************************************;
****************************************************************************;



********************************************************************************;
******************  Additional graphical diagnostics  **************************;
********************************************************************************;

*---Look for influential trials (no moderators). Need to use MIXED for the INFLUENCE 
	statistics. This is for the univariate analysis of yld_diff (not multi-treatment 
	analysis);

proc mixed  data=yield plots=studentpanel(marginal);
	title2 'Random effect model, INFLUENCE statistics for each trial';
	ods output influence=influencey;
	class TRIAL;
	weight wtdiff;
	model yld_diff = / s cl INFLUENCE(iter=5) ddfm=kr;
	random trial;
	parms (1) (1) / hold=2; *<--among-study variance and the within-study variance (latter held fixed);
	estimate 'mean diff' int 1 / cl;
run;
*^--there are a ~ couple of influential trials;

data yieldinflue; merge yield influencey; *<--put files together for possible graphs (not shown);

*proc print data=yieldinflue;run;

****************************************************************************;
****************************************************************************;






********************************************************************************;
***********************  PROBABILITY FOR A NEW STUDY  **************************;
********************************************************************************;

*---The following is for the univariate analysis of yld_diff.;

%Probnewstudy(meanES=5.29,minT=-5,maxT=25,SIGMA2=71.908);

proc sgplot data=_gener;
series y=_pz x=_t / lineattrs=(thickness=2 pattern=2 color=blue);
series y=_1mpz x=_t / lineattrs=(thickness=2 pattern=1 color=blue);
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5);
run;




***********************************************************************************;
*********************************  POWER  *****************************************;
***********************************************************************************;
/*
Statistical power is one of the great advantages of meta-analysis. In many cases,
the power to detect the true alternative hypothesis (when it is true) can be 
quite high, even when the power for each individual study is (very) low. 
The following macros calculate the power. One could use the results from a previous 
meta-analysis as a starting point. In other words, one determines the power for 
a meta-analysis of a new collection of K studies that have the specified mean and 
variance (SE).

%metapower calculates (estimates) this power, given the mean ES (meanES), 
SE, and number of studies (K) in the meta-analysis (at a given 
alpha [typicaly 0.05]). One needs to specifiy the expected value under the null 
hypothesis that one is considering (i.e., nullmu). 

The null hypothesis is 		Ho: ES = nullmu

Alternative hypothesis is:	Ha: ES ne nullmu   (not equal),   or
								Ha: ES >  nullmu			, or
								Ha: ES <  nullmu
All three Ha hypotheses are evaluated. Note that a large number of decimal places 
are displayed, so that one can compare different scenarios.

Results are stored in the sas file _fullpower (which is available for later
access). But when you run the macro another time, the original stored values
are over-written (unless you copied the file with another name).

Note: the calculations are the theoretical ones (using a non-central t distribution, as
described in Madden & Paul (2011). It may be better to use simulation because
of unequal (and fixed) sampling variances. This is NOT done with these macros.
Preliminary results to date show good agreement between the approach here and 
the more demanding simulation approach.

You get one line of output from this macro.
*/

*---Get power for another K (20) studies with same global mean and SE as original
	meta-analysis;
%metapower(meanES=5.29,SE=1.472,K=60,alpha=0.05,nullmu=0);	*<--null mean is 0;

%metapower(meanES=5.29,SE=1.472,K=60,alpha=0.05,nullmu=8);	*<--null mean is 8;


/*
Now, determine power (theoretically) for a range of number of studies, from K = Kmin to Kmax. 
Specify the mean under the null hypothesis (nullmu), and the number of studies
in the original meta-analysis (Korig).
Results are stored in the sas file _fullpower3 (which is availble for later 
access). But when you run the macro another time, the original stored values
are gone.

As a bonus, %metapower3 also determines the confidence interval for the expected
effect size for each value of K.   All of this is based on theory, not based on
simulation.

Note: all these calculations are based on the noncentral t distribution for mean
effect size. I call these the theoretical calculations. See details in Madden and 
Paul (2011). A better way would involve simulation, as described in the 
same paper (the macros do NOT do simulations).

*/

%metapower3(meanES=5.29,SE=1.472,alpha=0.05,nullmu=0,Kmin=2,Kmax=25,Korig=61);

*************************************************************************************;
*************************************************************************************;


*---Bias is not being determined (you can do this on your own). I don't think it is
	very relevant here, because the mean ES is very small. Usually you look at bias
	when you have a substantial effect size and you want to know how many 'zero' 
	studies are needed to cancel out the positive treatment effect. With zeta^ = 5.,
	it won't take many studies to cancel out this effect.;




