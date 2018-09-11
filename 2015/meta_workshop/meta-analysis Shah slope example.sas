 
/*
				META-ANALYSIS DEMONSTRATION PROGRAM 
(L. MADDEN, Ohio State University, with additional contributions by P. Paul).

Program designed for univariate fixed- and random-effects meta-analysis. 
This version is for SAS 9.3 (or later). May also work with SAS University Edition
(one SGPLOT run requires slightly different coding with University Edition).

Below, a data set supplied by Shah & Dillard (see Plant Disease 90: 1413-1418 [2006])
is analyzed using metaa-analysis. 

This program uses several SAS macros written by L. Madden and others (especially D. Wilson).
These are intended to streamline the analysis and the presentation of the data in graphic form.
The user should either:
	1)	First open meta_macros.sas and run the program, then return to this program file 
		for analyses;
or
	2)	use an %INCLUDE 'c:\...path....\meta_macros.sas' statement at the start of this
		program, in order to use the macros in the other meta_macros file.

Many of the calculations are explained in Madden & Paul (Phytopathology 102:16-30 [2011]), 
and references given in that publication. See the commentary throughout this file
for explanations of the methodology.

Program provided "as is". There are no warranties. 
*/


/*
Example from Shah and Dillard (Plant Disease 90: 1413-1418 [2006]). Effect size in 
each study is the slope of the relationship between sweet-corn yield and rust severity. 
This data set corresponds to the processing sweet-corn data in the paper
(see their Fig. 1).

Data set contains the estimated slope and standard error (from a regression analysis in
each study), study identification (study), and several moderator variables. The 95% 
confidence interval for the slope in each study is also given (lowerlimit --> upperlimit).

For a meta-analysis, one needs to define the so-called sampling variance for each study 
and its inverse (the weight). When dealing with regression parameters, the sampling variance
is the square of the standard error of the estimated parameter. The weight is simply
the inverse of the sampling variance.
*/

/*
Variable names:

study		Label for study (trial), character variable
State		Name of state
Variety		Sweetcorn cultivar name
Year		Year of study
slope		Estimated Effect Size for the study (slope of yield-loss vs. disease severity)
SE			Estimated standard error for the estimated slope (square this for "sampling variance"
lowerlimit	Lower limit of the 95% confidence interval for the slope (for each study)
upperlimit	Upper limit of the 95% confidence interval for the slope (for each study)
MinD		Minimum (plot) disease severity in the study (possible moderator variable)
MaxD		Maximum (plot) disease severity in the study (possible moderator variable)
MeanD		Average disease severity in the study (possible moderator variable)

wgt			Fixed study weight in meta-analysis: 1/SE^2 = 1/(sampling varaince)
id			Numeric ID for the study
baseD		Binary moderator variable (1 if MaxD <= 50%, 2 if MaxD > 50%) 
			(possible moderator calculated in data step)
*/

*%include 'c:\users\madden.1\My Documents\My SAS Files\Meta-analysis Tri-Societies\meta_macros.sas';


title 'Yield loss in sweet corn from common rust (Shah & Dillard)';
data shah;							*<--take out * in next line if using University Edition (UE);
*infile datalines dlm='09'x;		*<--use this line with SAS UE (for embedded tabs);
input study $ State $ Variety $ Year slope SE lowerlimit upperlimit MinD MaxD MeanD;	
sampvar = SE**2;			*<--sampling variance for each slope;
wgt = 1/sampvar;			*<--weight used in the meta-analysis;
id = _n_;					*<--number of the studies (in order);
baseD=1; 					*<--categorical variable (is maximum disease > or < 50% ?);
if (MaxD gt 50) then baseD = 2;		*<--(1 for low max. disease, 2 for high max. disease);
datalines;
1	NY	Zenith	1999	2.13607	2.18587	-3.03268	7.30483	0.00	1.46	0.39
2	NY	Zenith	1998	0.47288	0.18572	0.03372	0.91204	0.01	19.04	3.05
8	NY	Squeen	2000	1.17716	0.14263	0.83989	1.51443	1.50	24.30	6.58
11	NY	Bold	2001	0.33829	0.05394	0.21626	0.46031	20.49	77.31	45.91
22a	NY	Zenith	1997	0.78559	0.24789	-0.00331	1.57450	1.40	19.40	8.10
22b	NY	Rival	1997	-0.50102	0.42602	-1.85679	0.85476	1.50	6.30	3.73
31	MI	HMX83865	1993	0.31888	0.01484	0.27163	0.36612	5.40	57.50	18.73
35	MI	YBelle	1992	0.14559	0.12224	-0.15352	0.44470	2.60	85.80	22.96
50	NY	Jubilee	1984	-0.79923	0.31152	-1.79063	0.19217	8.08	15.50	11.73
59	IL	FSSweet	1984	0.63267	0.02300	0.58577	0.67958	5.59	62.83	38.07
60	IL	FSSweet	1985	1.08843	0.06339	0.95246	1.22439	10.45	55.20	26.51
61	IL	FSSweet	1986	0.66299	0.25871	0.09357	1.23241	1.55	17.65	9.54
62	IL	Gcup	1984	0.85302	0.04194	0.76626	0.93979	15.45	59.91	39.79
63	IL	Gcup	1985	0.55555	0.03612	0.48142	0.62967	7.60	50.08	27.63
64	IL	Gcup	1986	0.15786	0.28335	-0.44282	0.75854	1.67	20.57	6.22
65	IL	Stylepak	1984	0.62416	0.01996	0.58344	0.66488	23.63	67.68	38.94
66	IL	Stylepak	1985	0.37280	0.02808	0.31402	0.43157	7.50	49.84	25.70
67	IL	Stylepak	1986	0.78146	0.14652	0.47233	1.09058	1.42	17.40	6.72
70	IL	SnowWhite	2001	0.59867	0.01999	0.55697	0.64036	23.00	65.00	36.95
71	IL	Sterling	2001	0.40333	0.01810	0.36559	0.44108	18.00	59.00	35.81
;
run;

*---Look at the data;
proc print data=shah;
var study slope SE lowerlimit upperlimit sampvar wgt state variety year meanD baseD;
run;


/*
Now create Forest plots of the effect sizes (ES). The new
SGPLOT procedure is used here (works for sas 9.2 and later). 

SOME IMPORTANT TERMS TO BE USED IN SGPLOT PROCEDURE:
x:			the Effect Size (ES) of the study
y:			the study label (ID)
xerrorlower:lower limit for interval in plot 
			(can be ES - standard error, or lower confidence limit for ES)
xerrorupper:upper limit for interval in plot
			(can be ES + standard error, or upper confidence limit for ES)
refline:	value that indicates "no effect" (often 0)
xaxis label:label of the effect size in the graph
yaxis label:label of the study ID in the graph
xaxis max:	upper limit in graph for the ES (optional)
xaxis min:	lower limit in graph for the ES (optional)
*/


proc sgplot data=shah;
title2 'Forest plot';
scatter x=slope y=study 
		/ xerrorlower=lowerlimit xerrorupper=upperlimit
		markerattrs=(color=blue symbol=squarefilled size=9pt)
		errorbarattrs=(color=blue pattern=1 thickness=1);
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5); *<--reference line (null hypothesis);
xaxis 	label="Slope for yield loss" ;
yaxis 	type=discrete discreteorder=data label="Study" ;
run;

ods graphics on / width=5in height=4in;
*---Now control the lower and upper limits because of the wide intervals above;
proc sgplot data=shah;	
title2 'Forest plot';	
scatter x=slope y=study 
		/ xerrorlower=lowerlimit xerrorupper=upperlimit
		markerattrs=(color=blue symbol=squarefilled size=9pt)
		errorbarattrs=(color=blue pattern=1 thickness=1);
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5); *<--reference line (null hypothesis);
xaxis 	max= 4 min=-2 label="Slope for yield loss";		*<--cut off the extemes of CIs for one study;
yaxis 	type=discrete discreteorder=data label="Study";
run;



/*	Get a funnel plot and a radial (Galbraith) plot. Helps to identify publication
	bias (gaps in the graphs), and also the need to use random-effects analysis
	(when there are multiple data points outside the lines/curves. 
	In the Results window (for html), you generally should just scroll past all
	the table output, and just look at the graphs. 

dfile		name of the sas data file with data
es			name of variable in dfile with the effect size response variable
wgt			name of the weight variable in dfile. This needs to be the
			inverse of the "sampling variance" for each study
study		variable name for the labeled study (trial) in dfile
minprec		Minimum calculated precision value used in the graph (set by trial and error, so
			that the full range of data is encompassed by the curves
maxprec		Maximum calculated precision value used in the graph (set by trial and error, so
			that the full range of data is encompassed by the curves
numb		Number of precision values to make from minprect to maxprec (default25)
*/

ods graphics on / width=4in;
%funnel(dfile=shah,es=slope,wgt=wgt,study=study,minprec=2,maxprec=70);

		
*---Conduct a meta-analysis using the method of moments (using macro by Lipsey and Wilson).
	Confidence intervals are based on large-sample theory (z and not t statistic);
%meanes(slope,wgt,dsn=shah,print=raw) ;

*---Use SAS procedure (PROC GLM) and post-procedure processing to get Cochran's Q 
	and related statistics (all for	method of moments). Macro uses portions of GLM output
	(most of it is not appropriate for this application) to determine the various statistics.
	Compare with MEANES macro from Lipsey and Wilson.	;
%moments(dfile=shah,es=slope,wgt=wgt,study=study);


*---Now do a random-effects meta-analysis based on likelihood principles. We find this a 
	better approach, although moment-based analyses are extremely common (based on
	history).;
*---One can either do a Maximum Likelihood (ML) or Restricted Maximum Likelihood (REML)
	analysis. The former is best suited for large numbers of studies (say, >30), although
	some authors like to use ML for all meta-analyses. With 20 studies in the example, 
	REML is probabably better, but we show both here (for completion and comparison). ;

/*	Model is: z_i = zeta + u_i + e_i
	Where 	z_i is the estimated effect size for the i-th study,
			zeta is the true expected effect size across all studies
				(estimate is labeled INTERCEPT in the MIXED output),
			u_i is the random effect of the i-study on the effect size
				(between-study variability term),
			e_i is the within-study random effect or residual
				(sampling variability term, assumed known for each study)
*/


proc glimmix data=shah  method=RSPL; *<---RSPL means REML (use method=MSPL for ML);
title2 'random effects, REML';
class study;							*<--Make study (trial) a class variable;
weight wgt;								*<--Specify 1/samp.var as the weight (to get fixed e_i);
model slope = / chisq s dfm=betwithin;	*<--No predictors in the model. Options for getting a  
											chi-square test and for the denominator df method.;
random study;							*<--Indicate that STUDY is a random effect (u_i);

parms (1) (1) / hold=2;					*<--Initial guesses of the among-study variance and the
											residual, the latter being held at a fixed 1. Required.
											Combination of WEIGHT and fixed residual var (=1) is key.;
estimate 'meanES' int 1 / cl;			*<--Get estimated expected ES (zeta^) and confidence interval;
run;

*---There is no agreed-upon method to determine the denonimator degrees of freedom (df).
	This is discussed below. For now, we use the Between-Within method. This agrees with
	the default Containment method for the procedure (in this simple situation). Gives
	compatibility with algorithms elsewhere.;


*---Now do maximum likelihood, assuming large number of studies. Override denominator df. 
	Now, the t statistic is same as a z (standard normal) statistic.;
proc glimmix data=shah  method=MSPL;	*<--MSPL means ML in GLIMMIX;
title2 'Random Effects, _ML_';			*<--(see above comments for more details on GLIMMIX syntax);
class study;
weight wgt;
model slope = / chisq s ddf=1000 ;		*<--Make denominator df large to get "large sample" results;
random study;

parms (1) (1) / hold=2;
estimate 'meanES' int 1 / cl df=1000;	*<--Make df large for "large sample" results;
run;

*---There are other ways of fixing the within-study sampling variances. The approach
	followed here is the simplest, but many do not know about it. Some other approaches
	are described in Madden&Paul_meta-analysis_eXtra_overview_Jan2011.pdf .
	See also optional demo in the third case study.;

*---The diagnostic plots above (Funnel and radial) show that a fixed-effects analysis is not appropriate. 
	This is confirmed by the I2 and R2 indices determined from the MOMENTS-based meta-analysis.
	For completion, however, we show how to do a FIXED-effects analysis using MIXED.
	Model:  z_i = zeta + e_i  ;
proc glimmix data=shah  method=rspl;	*<--See earlier runs of GLIMMIX for detailed comments;
title2 'fixed effects analysis';
class study;							
weight wgt;								*<--No RANDOM statement with fixed-only model;
model slope = / chisq s ddfm=betwithin;		
parms (1) / hold=1;						*<--Only one variance parameter (for residual) (held at 1);
estimate 'meanES' int 1 / cl;
run;


/*
Dealing with among-study variability in true effect size (when sigma^2 > 0):

One can get the Higgins-Thompson R2 index by dividing the SE from the random effects analysis by the SE from 
the fixed-effects analysis, and squaring them. Here, 
	R2 = (.08560/.007465)**2 = 131 (this is extremely large).

The confidence interval is automatically calculated with the CL option in GLIMMIX. 
	ES_mean +/- t*.SE
A _prediction_ interval must be done "by hand". One calculates 
	ES_mean +/- t*.sqrt(VAR*), 
where
	t*	is critical value from Student t distribution (for alpha=0.05, and denominator df),
		(approximately 2 with high enough df). With df=19, t* = 2.093.
	VAR* = SE**2 + (AMONG-STUDY VARIANCE).

	VAR* = 0.0856**2   + 0.1181 = 0.1254 in this exmample.

95% prediction interval:	0.516 +/- 2.093.sqrt(.1254): -0.225 ---> 1.257

Note: the 95% confidence interval is:					  0.337  --> 0.696
*/

*---Now get H2 and I2 statistics of Higgins & Thompson, based on ML or REML parameter 
	estimates. One must first run %moments macro (above), and then run %H2I2 macro.
	One specifies the among-study variance (var). Other needed metrics are stored in file
	created by %moments.
	H2 and I2 based on moment estimates are printed by the %moments macro.;

%H2I2_(var=.118,es=.516,se=.0856,alpha=.05);


*---Often, one likes to include the (random- and/or fixed-effects) overall expected effect size (across
	all studies) in the Forest plot. In SAS, one would do this by first putting the mean ES and the confidence
	limits in a data file, and then stacking the original data file on top of the new one. Also, one
	can also show the PREDICTION INTERVAL for the mean ES, using the same approach.;

data shahmeans;									*<--Can use any label for these extra "studies".;
input studym $ slope lowerlimit upperlimit;		*<--Note that the study ID is given a different name from original file;
datalines;
RAND.-CI .516 .337 .696
FIXED    .493 .477 .508
;
run;
data shahmeans2;								*<--Now augment with the Prediction Intervals;
input studym2 $ slope lowerlimit upperlimit;	*<--Yet, another study ID label;
datalines;
RAND.-PI .516 -.225 1.257
;
run;

*---Stack the data files, and look at the combined file.;
*---ORDER: file with pred. int., file with conf.int., and original file.;

data shah_c; set shahmeans2 shahmeans shah ;
run;

proc print data=shah_c;		*<--this is flipped to get the right order in forest plot;
title2 'Original file augmented with overall fixed- and random-efffects effect sizes';
var study studym studym2 slope lowerlimit upperlimit;
run;

/*
See above comments for the use of SGPLOT procedure to obtain Forest plot.
Here, extra SCATTER statements are used to get the overall expected 
effect size (random or fixed effects), and also the expected effect
size with PREDICTION interval (second procedure, below).
*/

*ods html style=default;
ods graphics on / width=5in height=5in;
proc sgplot data=shah_c noautolegend;
title2 'Forest Plot';
scatter x=slope y=studym2 
		/ 	xerrorlower=lowerlimit xerrorupper=upperlimit
			markerattrs=(color=black symbol=diamond size=12pt)
			errorbarattrs=(color=black pattern=1 thickness=1);
scatter x=slope y=studym 
		/ 	xerrorlower=lowerlimit xerrorupper=upperlimit
			markerattrs=(color=red symbol=diamondfilled size=11pt)
			errorbarattrs=(color=red pattern=1 thickness=1);
scatter x=slope y=study 
		/ 	xerrorlower=lowerlimit xerrorupper=upperlimit
			markerattrs=(color=blue symbol=squarefilled size=9pt)
			errorbarattrs=(color=blue pattern=1 thickness=1);
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5);
xaxis label="Slope for yield loss" min=-2 max=4;
yaxis type=discrete discreteorder=data label="Study" ;
run;



********************************************************************************;
***********************  MODERATOR VARIABLES  **********************************;
********************************************************************************;

/*
It is often of major importance to determine if characteristics of the studies affect
the expected effect size. A study characteristic could be the cultivar being 
grown or the level of disease resistance of cultivars being grown (say, L or H).
Another characteristic could be an environmental summary variable for the 
study (total rainfall in a field study, etc.). Study properties or characteristics
are known in meta-analysis as moderator variables. Analysis is based on 
an expansion of the basic linear model, with terms for categorical (factor, class)
moderator variables or continuous moderator variables. 

Analysis is demonstrated below for three moderators in the Shah data set. 

Start with a binary moderator variable (based on maximum level of disease study).
*/


*---easy way to select colors, markers, etc., within SGPLOT for Groups;
%modstyle(name=markers, parent=statistical, type=CLM,
	markers=squarefilled circle , colors=blue black );
ods html style=markers; run;
ods graphics on / width=4.5in height=4in;
proc sgplot data=shah ;
title2 'Forest Plot (with baseD disease moderator)';
scatter x=slope y=study 
		/ xerrorlower=lowerlimit xerrorupper=upperlimit
		markerattrs=(size=9pt )
		group=baseD;				*<--note the GROUP= option;
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5);
xaxis label="slope for yield loss" min=-2 max=4;
yaxis type=discrete discreteorder=data label="Study";
run;

*ods html style=statistical;run;


/*
*An approach that runs with SAS 9.4 (not 9.3) for defining markers and colors.;
*Also runs with SAS University Edition (above does not run with UE).;

ods html style=statistical;run;
ods graphics on / width=4in attrpriority=none;
proc sgplot data=shah ;
title2 'Forest Plot';
styleattrs 	datasymbols=(squarefilled circlefilled)
			datacolors=(blue red)
			datalinepatterns=(solid solid);
scatter x=slope y=study 
		/ xerrorlower=lowerlimit xerrorupper=upperlimit
		markerattrs=(size=9pt )
		group=baseD;
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5);
xaxis label="slope for yield loss" min=-2 max=4;
yaxis type=discrete discreteorder=data label="Study";
run;
*/

****************************************************************************;
************** OPTIONAL GRAPHICAL DIAGNOSTICS ******************************;
****************************************************************************;

*---DEMONSTRATION (OPTIONAL): fixed effects analysis with moderator variable 
	(to get residuals in output file). We already know we need 
	random-effects analysis.;
proc glimmix data=shah ;
title2 'Moderator variable analysis (get residuals to make a funnel plot)';
title3 'FIXED effects, effect of disease level binary category [baseD]';
class study baseD;
weight wgt;
model slope = baseD / chisq s ddfm=betwithin;
parms (1) / hold=1;
lsmeans baseD / diff cl;
OUTPUT out=modfixedout pred=pred resid=resid;	*<--store residuals and predicted values;
run;
proc print data=modfixedout;run;

*---Funnel plot based on residuals from a fixed-effect analysis (one moderator);
ods graphics on / width=4in;
%funnel(dfile=modfixedout,es=resid,wgt=wgt,study=study,minprec=1,maxprec=70);

*******************************************************************************;



*************************************************************************************;
**************************** MODERATOR VARIABLES ************************************;
*************************************************************************************;

*---random effects analysis with moderator variable;
proc glimmix data=shah ;
title2 'Moderator variable analysis';
title3 'random effects, effect of disease level binary category [baseD]';
class study baseD;								*<--put factor moderator in CLASS;
weight wgt;
model slope = baseD / chisq s ddfm=betwithin;	*<--put moderator in MODEL;
random study;
parms (1) (1) / hold=2;
lsmeans baseD / diff cl;		*<--use LSMEANS to get mean effect size for each group;
run;
*^--Note that denominator df = 0 using between-within (or containment) methods for df.
	In general, it is recommended that one uses DDFM = KR (Kenward-Roger) method....;

*---switch to Kenward-Roger denominator df method....;
proc glimmix data=shah ;
title2 'Moderator variable analysis (with ddfm=KR)';
title3 'random effects, effect of disease level binary category [baseD]';
class study baseD;
weight wgt;
model slope = baseD / chisq s ddfm=KR;	*<--change ddf method (could also choose "residual");
random study;
parms (1) (1) / hold=2;
lsmeans baseD / diff cl lines;
run;


*************************************************************************************;
*********************** OPTIONAL USE OF SOME MACROS *********************************;
*************************************************************************************;
*---Demonstrate SAS macro for moderators..... Might skip this part, depending on time. 
	Used to show how the macro and GLIMMIX do the analyses (slightly differently). 
	One can choose options in GLIMMIX (or MIXED) to exactly duplicate the macro
	approach. This is demonstrated. Note: the macro is not better than the 
	procedure. The macro has few options, and is quite restrictive. But if one
	wants, the macro can be duplicated (it may be informative to see how...);
title2 'Use of metaf macro, ML-based random-effect analysis';
%metaf(slope,wgt,baseD,dsn=shah,model=ML) ;

*^--The estimate between-study variance and SE are not the same as above GLIMMIX 
	output, and there are other smaller differences, as well. Note that the macro
	uses strictly chi-squared (and standard normal) test statistics (no denominator
	df). We have been using F tests, and t statistics for individual contrasts.;
*---Now let's get GLIMMIX to duplicate the metaf macro results. METAF does ML here, 
	not REML, so we need to choose this in GLIMMIX. Also, we need to match df.
	The macro uses Chi-square statistics, so we ignore the F test stuff in GLIMMIX.
	Finally, the macro uses Fisher Scoring (expected Hessian) for the variance 
	(or variance-covariance)matrix, not the observed Hessian. 
	This needs to change also for duplication. Also need a 2nd derivative estimation
	technique.
	In GLIMMIX, use MSPL for ML, SCORING=100 to use expected Hessian, and ddf= to
	override the denominator df calcuation. You can also use CHISQ output.;

proc glimmix data=shah method=MSPL SCORING=100 /* use expected Hessian for 100 iterations */;
title2 'Moderator variable analysis, ML, expected Hessian, override df (10000)';
title3 'random effects, effect of disease level binary category [baseD]';
title4 'purpose: match results with METAF macro above (academic exercise)';
class study baseD;
weight wgt;
model slope = baseD / chisq s ddf=10000;	*<--change ddf method.;
random study;
parms (1) (1) / hold=2;
lsmeans baseD / diff cl lines df=10000; 	*<--assume infinite ddf for chi-square approach;
nloptions tech=NRRIDG; 	*<--needed to get 2nd derivative optimization technique.;
run;

*---You can also get method of moments (DL) using this macro. Just use MM;
title2 'Use of metaf macro, moment-based random-effect analysis';
%metaf(slope,wgt,baseD,dsn=shah,model=MM) ;

*---You can also get fixed effect analysis with macro. Just use FIXED;
title2 'Use of metaf macro, fixed effect analysis';
%metaf(slope,wgt,baseD,dsn=shah,model=FIXED) ;

*************************************************************************************;


*************************************************************************************;
****************************  MORE WITH MODERATORS  *********************************;
*************************************************************************************;

*---Plot Effect Size estimate versus CONTINUOUS moderator variable.
	Note: it is INCORRECT to just use regression or even weighted regression.
	One must use a mixed (hierarchical) model, for within-study sampling
	variance and among-study variance.;
proc sgplot data=shah;
title2 'Mean disease continuous moderator variable';
title3 '(bubble: SE)';
bubble y=slope x=meanD size=SE;
run;
proc sgplot data=shah;
title2 'Mean disease continuous moderator variable';
title3 '(bubble: 1/(sampling var.))';
bubble y=slope x=meanD size=wgt;
run;

proc glimmix data=shah  ;
title2 'Moderator variable analysis (ddfm=KR)';
title3 'random effects, effect of mean disease per study [meanD]';
class study ;
weight wgt;
model slope = meanD / chisq s ddfm=KR;
random study;
parms (1) (1) / hold=2;
*---must use ESTIMATE statements to get estimated effect size at each level of X;
estimate 'ES @ meanD=10%' int 1 meanD 10 / cl;
estimate 'ES @ meanD=25%' int 1 meanD 25 / cl;
estimate 'ES @ meanD=50%' int 1 meanD 50 / cl;
run;

*---Plant cultivar (not enough studies for each cultivar). Shown as 
	a demonstration example only.;
proc glimmix data=shah ;
title2 'Moderator variable analysis (ddfm=KR)';
title3 'random effects, variety effect (demonstration only, no evidence of effect)';
class study variety;
weight wgt;
model slope = variety / chisq s ddfm=kr;
random study;
parms (1) (1) / hold=2;
estimate 'meanES' int 1 / cl;
lsmeans variety / cl lines adjust=simulate diff plots=mean;
run;




*************************************************************************************;
******* OPTIONAL DIAGNOSTICS: DELETED RESIDUALS and INFLUENCE STATISTICS ************;
*************************************************************************************;
			
*---Get some regular mixed-model diagnostic plots.; 
proc glimmix data=shah  method=RSPL plots=studentpanel(marginal); *<---RSPL means REML;
title2 'random effects, REML, with STUDENT RESIDUAL plots';
class study;							*<--Make study (trial) a class variable;
weight wgt;								*<--Specify 1/samp.var as the weight (to get fixed e_i);
model slope = / chisq s ddfm=betwithin;	*<--No predictors in the model. Options for getting a  
											chi-square test and for the denominator df method.;
random study;							*<--Indicate that STUDY is a random effect (u_i);

parms (1) (1) / hold=2;					*<--Initial guesses of the among-study variance and the
											residual, the latter being held at a fixed 1. Required.
											Combination of WEIGHT and fixed residual var (=1) is key.;
estimate 'meanES' int 1 / cl;			*<--Get estimated expected ES (zeta^) and confidence interval;
run;


*---Must use PROC MIXED to get so-called _INFLUENCE_ Statistics (such as Cook's D). 
	Syntax is mostly the same, but note the method=REML option for REML.;
proc mixed data=shah covtest method=REML plots=studentpanel(marginal);
title2 'random effects, REML, INFLUENCE STATISTICS';
ods output influence=influence1;		*<--store the influence statistics in a file;
class study;							*<--Make study (trial) a class variable;
weight wgt;								*<--Specify 1/samp.var as the weight (to get fixed e_i);
model slope = / chisq s ddfm=betwithin INFLUENCE(iter=5) OUTP=shahblup;	*<-predictions in a file;
										*^--Note the INFLUENCE option.;
random study ;							*<--Indicate that STUDY is a random effect (u_i);

parms (1) (1) / hold=2;					*<--Initial guesses of the between-study variance and the
											residual, the latter being held at a fixed 1. Required.
											Combination of WEIGHT and fixed residual var (=1) is key.;
estimate 'meanES' int 1 / cl;			*<--Get estimated expected ES (zeta^) and confidence interval;
run;
*^--Note that observation #9 is influential. (This corresponds to study="50").;



*---May be useful to plot the influence statistics versus study ID, in the style of
	a Forrest plot (for direct comparisons). The following code does this. 
	Must define a base of 0 for graphs. One can then get horizontal lines/bars
	(starting at 0) for Cook's D, etc.;

*---merge file with predictions (etc.) with influence statistics...;
data shahc2; merge  shahblup influence1;
st = _n_;	*<--another ID for study (based on order). For possible use later;
stinv=1/st;
base=0;		*<--lower end of lines for graphs below;
run;

*---rstudent is studentized deleted residual. RLD is restricted likelihood distance for i-th study;
proc print data=shahc2;
var study slope wgt pred stderrpred  rstudent cookD cookDCP RLD;
run;


proc sgplot data=shahc2;
highlow y=study low=base high=cookD / lineattrs=(thickness=2 color=blue);
xaxis label="Cook's Distance (for zeta)" ;
yaxis label="Study" ;
run;

proc sgplot data=shahc2;
highlow y=study low=base high=cookDCP / lineattrs=(thickness=2 color=blue);
xaxis label="Cook's Distance (for sigma^2)" ;
yaxis label="Study" ;
run;

proc sgplot data=shahc2;
scatter y=study x=rstudent/ markerattrs=(size=2pct color=blue symbol=circlefilled);
xaxis label="Studentized deleted residual" ;
yaxis label="Study" ;
refline 0 / axis=x lineattrs=(color=black pattern=1 thickness=1.5);
run;

*************************************************************************************;
*************************************************************************************;




*************************************************************************************;
******************** OPTIONAL: PROBABILITY FOR A NEW STUDY  *************************;
*************************************************************************************;
/*
Now that we have the results for the random-effects meta-analysis 
(meanES = 0.515, SE = 0.0856, between-study variance [SIGMA2] = 0.1181),
we can perform several applications. First, we estimate the probability
that a new randomly selected study has an effect size larger (or less)
than a pre-specified constant (c). For instance, an ES of 0 may be 
especially of interest (say, 0 could mean that a fungicide had _no_ effect
on disease or yield), but other constants could be equally of interest.

The %Probnewstudy macro does all the calculations, using the method 
described in Madden and Paul (2011). One supplies the results from the prior
(original) analysis, and gives a range of constants of interest 
(minT --> maxT). One gets a printed table of results (in sas file _gener, which
can be accessed later).

One specifies meanES, SIGMA2, minT, maxT, and optionally numb (the number of
constants after minT (one actually gets numb+1 results)). Default numb is 21.
*/

%Probnewstudy(meanES=.515,minT=0,maxT=.8,SIGMA2=.1181);

proc sgplot data=_gener;
title2 'Probability of effect size less/greater than constant';
series x=_t y=_pz / lineattrs=(thickness=2 color=blue);
series x=_t y=_1mpz / lineattrs=(thickness=2 color=red);
yaxis label='Probability';
xaxis label='Constant';
run;


%Probnewstudy(meanES=.515,minT=.0,maxT=.5,SIGMA2=.1181,numb=2);	*<-one gets 1 more than "numb";

*************************************************************************************;
*************************************************************************************;



*************************************************************************************;
************************** OPTIONAL: POWER  *****************************************;
*************************************************************************************;
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

%metapower(meanES=.515,SE=.0856,K=20,alpha=0.05,nullmu=0);

%metapower(meanES=.515,SE=.0856,K=20,alpha=0.05,nullmu=.25);

%metapower(meanES=.515,SE=.0856,K=20,alpha=0.05,nullmu=0.4);



/*
%metapower2 expands on %metapower by calculating power for a range of nullmu 
values (from nuumumin to nullmumax). Results are also plotted. 

By default, one obtains 26 power values between nullmumin and nullmumax.

One can specify numb to obtain numb+1 power values.
Results are stored in the sas file _fullpower2 (which is availble for later 
access). But when you run the macro another time, the original stored values
are gone.
*/

%metapower2(meanES=.515,SE=.0856,K=20,alpha=0.05,nullmumin=.0,nullmumax=.75);

%metapower2(meanES=.515,SE=.0856,K=20,alpha=0.05,nullmumin=.0,nullmumax=.75,numb=15);


/*
Now, determine power (theoretically) for a range of number of studies, from K = Kmin to Kmax. 
Specify the mean under the null hypothesis (nullmu), and the number of studies
in the original meta-analysis (Korig).
Results are stored in the sas file _fullpower3 (which is availble for later 
access). But when you run the macro another time, the original stored values
are gone.

As a bonus, %metapower3 also determines the confidence interval for the expected
effect size for each value of K. 
*/

%metapower3(meanES=.515,SE=.0856,alpha=0.05,nullmu=.25,Kmin=2,Kmax=25,Korig=20);

*************************************************************************************;
*************************************************************************************;



*************************************************************************************;
**************************** OPTIONAL: BIAS  ****************************************;
*************************************************************************************;
/*
Publication bias is a recurring theme in meta-analysis: the selective reporting of 
certain studies rather than all studies that can inform a topic. Because of publication
bias, calculated mean effect sizes (based on the available studies, not the total
of all studies) could be too large in absolute value (the _estimated_ mean will be 
farther from 0 than the _true_ expected effect size. Many approaches have
been developed to assess the possible magnitude of this bias, and some methods try to
correct for this bias. The funnel and radial plots (shown above) can help in this 
assessment. We especially like the method developed by Copas and Jackson (2004). 
Here one considers how biased the _mean_ ES can be if there are m _more_ (new)studies 
that have not been included in the meta-analysis. The method determines the absolute
value of the UPPER BOUND for this bias -- actual bias will almost always be less than
this upper bound(|bound|), but the actual bias is determined by too many unknown
factors to predict. 

The macro determines this |bound| based on the results from a meta-analysis for a 
range of _additional_ studies not used in the (original) meta-analysis.

One specifies the SAS file with the data, indicating the weight (wgt) used
in the meta-analysis, together with the estimated between-study variance (SIGMA2), and
number of studies in this original analysis(K). Then, one specifies the maximum number
of additional studies that could exist (new, a hypothetical value). That is, the
number of new studies not in the original are m = 1, 2, ..., new.

The graphic output is the most useful output of the macro. One needs to indicate
the maximum in the graph of |bound| versus m. (That is, one must give the
maximum value on the y axis. It is recommended that one chooses
the mean ES (actually, its absolute value) from the prior meta-analysis as the maximum
in the graph. The idea is that bias is important if |bound| determined with the 
Copas-Jackson algorithm gets too close to this maximum (or even supasses this maximum). 

One also specifies another reference line. This can be the "lower" limit of a confidence 
interval for the mean ES (from the original meta-analysis).

Results are stored in sas file _gg0 (which is available for later access).
*/


%biasbound(dfile=shah,wgt=wgt,SIGMA2=.1181,K=20,new=20,plotbiasmax=.52,plotbiasref=.34);

*************************************************************************************;
*************************************************************************************;



*************************************************************************************;
************** BAYESIAN ANALYSIS (INTRODUCTION - NOT COVERED)  **********************;
*************************************************************************************;
/*
All the  material in this file, so far, can be considered frequentist analysis, which is 
the most common paradign for data analysis. However, Bayesian analysis is becomning 
more-and-more popular for many kinds of analyses, including meta-analysis. 
Here we show how to use the MCMC procedure for a Bayesian analysis.

This approach is based on defining a prior probability distribution for each parameter.
It is common to use a so-called noninformative prior. Then, one combines this prior
with the likelihood function for the data to determine the posterior distribution 
for the parameters. Summary measures (e.g., mean, median, quantiles) of the
posterior distributions are used for interpretation. This method is very 
computationally intensive, but now software makes this quite feasible. 

Not teaching the method here. 
*/

/*
data shahc; set shah; trial=_n_;	*<--need a numeric code for the studies (not just characters);
ods graphics / width=6in height=5in;

proc mcmc data=shahc outpost=postout thin=10 nmc=100000  seed=123;
parms zeta 1  ;
parms sigma2 1 ;

prior zeta ~ normal(0,var=10000);			*<-noninformative normal prior for zeta;
prior  sigma2 ~ igamma(0.001,scale=.001);	*<--noninformative inverse Gaussian prior for sigma2;

random upsilon ~n(zeta,var=sigma2) subject=trial;	*<-upsilon has normal distribution with mean sigma2;

model slope ~ normal(upsilon,var=1/wgt);
run;

*/

*************************************************************************************;
********************************** THE END ******************************************;
*************************************************************************************;
