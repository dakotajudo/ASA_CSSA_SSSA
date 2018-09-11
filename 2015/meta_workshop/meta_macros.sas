
/*
Collection of macros for meta-analysis. 
Macros written by L. Madden  or D. Wilson.

Macros are provided with no warranties or guarantees.

L. V. Madden (Ohio State University), updated 9/2015.
*/

*---First three macros written and provided by David Wilson. Other macros written
	by Larry Madden.;
%MACRO metareg(es,w,x,dsn=_last_,model=fe) ;
*---Revised Lipsey-Wilson macro, 7/2005 (L. Madden). This version CORRECTLY does the ML estimation
	(but not REML). Macro made available for distribution courtesy of David Wilson.
	If you use, please cite book: Practical Meta-Analyis, by M. W. Lipsey & D. B. Wilson. 
	2001. Sage Publications, Thousand Oaks, USA.;
*---Does moment (MM) or ML estimation.;

      proc iml;

        use &dsn ;
        read all var {&es} into es  where(&es^=. & &w^=. & &x^=.) ;
        read all var {&w}  into w   where(&es^=. & &w^=. & &x^=.) ;
        read all var {&x}  into x   where(&es^=. & &w^=. & &x^=.) ;

        k = nrow(es)  ;
        df = k - 1   ;
        j = j(k,1,1) ;
        x = j(k,1,1) || x ;
        p = j(1,ncol(x),1) ;
		v = 1/w;

        %if %upcase(&model) = MM | %upcase(&model) = ML %then
           %do;
                  xw = x#(w*p) ; xwx = T(xw)*x ;
                  B = inv(xwx)*T(xw)*es ;
                  qe = sum(es#w#es) - T(B)*xwx*B ;
                  ww = w#w ; xww = x#(ww*p) ; xwwx = T(xww)*x ;
                  c = (qe-(k-ncol(x)))*inv(sum(w) - trace((xwwx)*inv(xwx))) ;
                  if c<0 then c = 0 ;
                  w = 1/(1/w + c) ;
            %end ;

        %if %upcase(&model) = ML %then
           %do i=1 %to 100;
                          xw = x#(w*p) ; xwx = T(xw)*x ;
                          B = inv(xwx)*T(xw)*es ;
                          r = es - x*B ;
                          c = sum((w#w)#(r#r-(v)))/
                                (sum(w#w)) ;
                          if c<0 then c = 0 ;
                          w = 1/(v+c) ;

			 %end ;

		%if %upcase(&model) = ML %then
			%do ;  se_c = sqrt(2/sum(w#w)) ; %end ;

        xw = x#(w*p) ; xwx = T(xw)*x ;
        B = inv(xwx)*T(xw)*es ;

        meanes = sum(es#w)/sum(w) ;
        q =  sum((meanes - es)#(meanes - es)#w) ;
        qe = sum(es#w#es) - T(B)*xwx*B ;
        qr = q - qe ;
        dfe = nrow(es)-ncol(x) ;
        dfr = ncol(x)-1 ;
        dft = nrow(es)-1 ;
        pt = 1 - probchi(q,dft)  ;
        pe = 1 - probchi(qe,dfe) ;
        pr = 1 - probchi(qr,dfr) ;
        se = sqrt(vecdiag(inv(xwx))) ;
        zvalues = B#vecdiag(inv(diag(se))) ;
        pvalues = (1 - probnorm(abs(zvalues)))*2 ;
        lowerB = B - se*1.96 ;
        upperB = B + se*1.96 ;

        d = x - T(T((x#(w*p))[+,])*T(j)/sum(w)) ;
        sx = sqrt(vecdiag(T(d#(w*p))*d/sum(w))) ;
          sy = sqrt(q/sum(w)) ;
        beta = (B#sx) *inv(sy) ;
        r2 = qr/(qr+qe) ;
              %if %upcase(&model) = MM %then
                %do ; print "--------- Random Effects Model ------" ;
                      print "-- estimated via method of moments --" ;
                print c [label= ' '] [rowname = 'Random eff. var. component = ']
                                [format=12.8];
                %end ;

              %if %upcase(&model) = ML %then
                %do ; print "--------- Random Effects Model ------" ;
                      print "-- estimated via iterative full information maximum likelihood --" ;
                mlc = c // se_c ;
				print mlc [label= ' '] [rowname = {'Random eff. var. component  = '
				                                  'St. Error of var. component = '}]
                                [format=12.8];
                %end ;


              print "------- Descriptives -------" ;
              print k      [label="No. of Obs. "]
                         meanes [label="Mean Obs."] [format=10.4]
                        r2     [label="R-squared"] [format=10.4] ;

              print  "------- Homogeneity Analysis  -------";
                qtab1 = qr // qe // q ;
                qtab2 = dfr // dfe // dft ;
                qtab3 = pr // pe // pt ;
                print qtab1 [rowname={"Model","Residual","Total"}]
                            [colname="Q"][label="Source"] [format=12.5]
                            qtab2 [label="df"]
                            qtab3 [label="p"] [format=12.5];

              print "------- Regression Coefficients -------" ;
              names = {&x} ;
              names = T(names) ;
              group = {"Constant"} // names ;
              print b [rowname=group] [colname="B"] [label="Variable"]
                          [format=10.5]
                        se [label="SE"] [format=10.5]
                        lowerB [label='-95%CI'] [format=10.5]
                        upperB [label='+95%CI'] [format=10.5]
                        zvalues  [label="z"] [format=10.5]
                        pvalues  [label="p"] [format=10.5]
                        beta     [label="beta"] [format=10.5] ;

%MEND metareg ;
run; quit;


%MACRO meanes(es,w,dsn=_last_,print=raw) ;	
*---Lipsey-Wilson macro for mean effect size and other statistics,
	based on MOMENT-type calculations. Macro made available for distribution courtesy of 
	David Wilson. If you use, please cite book: Practical Meta-Analyis, by M. W. Lipsey 
	& D. B. Wilson. 2001. Sage Publications, Thousand Oaks, USA.
	[Some macro additions by L. Madden];
        proc iml;
                use &dsn ;
                read all var{&es} into es   where(&es^=. & &w^=.) ;
                read all var{&w}  into w    where(&es^=. & &w^=.) ;

                k = nrow(es)  ;
                df = k - 1   ;

                mes = sum(es#w)/sum(w);
                sem = sqrt(1/sum(w));
                les = mes - 1.95996*sem;
                ues = mes + 1.95996*sem;
                z   = mes/sem ;
                pz  = (1 - (.5+erf(abs(z)/sqrt(2))/2))*2 ;
                maxes = max(es) ;
                mines = min(es) ;

                Q = sum((es#es)#w) - sum(es#w)#sum(es#w)/sum(w);
                wsd   = sqrt(Q*w[+,]**-1) ;
                pq   = 1-probchi(Q,df) ;

				H2 = Q/df;	*---Hedges Hsquared statistic;
				I2 = 100*(H2-1)/H2; if (I2 < 0) then I2 = 0;  *---Hedges Isquared statistic;

                c    = (Q - df)/(w[+,]-sum(w#w)/w[+,]) ;
                if c<0 then ; do ; c = 0 ; end ;
                wre    = 1/(1/w + c) ;

                mesre = sum(es#wre)/sum(wre) ;
                semre = sqrt(1/sum(wre)) ;
                lesre = mesre -    1.95996*semre ;
                uesre = mesre +    1.95996*semre ;
                zre   = mesre/semre ;
                pzre  = (1 - (.5+erf(abs(zre)/sqrt(2))/2))*2 ;

				R2 = (semre/sem)**2;
                %if %upcase(&print) = EXP %then
                        %do;
                                mes = exp(mes) ;
                                les = exp(les) ;
                                ues = exp(ues) ;
                                sem = . ;
                                mes_re = exp(mes_re) ;
                                les_re = exp(les_re) ;
                                ues_re = exp(ues_re) ;
                                semre = . ;
                %end;

                print '-------------- Distribution Description --------------';
                mattrib         k     label={"No. of obs."}     maxes label={"Max Obs."}
                        mines label={"Min Obs."} wsd   label={"Weighted SD"};
                print k mines maxes wsd [format=12.5];
                
                print '-------------- Homogeneity Analysis --------------';
                mattrib df label={"df"} pq label={"p"} ;
                print Q [format=12.5] df pq [format=12.5];
                

                print '---------- Fixed & Random Effects Model (Method of Moments) ----------';
                fixed = mes || sem || les || ues || z || pz ;
                random = mesre || semre || lesre || uesre || zre || pzre ;

                model = fixed // random ;
                mattrib model rowname=({'Fixed', 'Random'})
                        colname=({'Mean' 'SE' '-95%CI' '+95%CI' 'z' 'p'})
                        label={"Model"};
                print model [format=10.5];
                mattrib c label={" "};
                print c [rowname="Random effects var. component = "];
				
				print "Higgins & Thompson 2002 indices of heterogeneity (from moment estimates)";
				print H2 I2 R2;
				print "(When p-value is given as 0.00000, this means p < 0.00001)";


%MEND meanes;
run; quit;


%MACRO metaf(es,w,x,dsn=_last_,model=fe) ;
*---Revised Lipsey-Wilson macro, 7/2005 (L. Madden). This version CORRECTLY does the ML estimation
	(but maybe not REML). Macro made available for distribution courtesy of David Wilson.
	If you use, please cite book: Practical Meta-Analyis, by M. W. Lipsey & D. B. Wilson. 
	2001. Sage Publications, Thousand Oaks, USA.;
*---Does moment or ML estimation;
      proc iml;

        use &dsn ;
        read all var {&es} into es  where(&es^=. & &w^=. & &x^=.) ;
        read all var {&w}  into w   where(&es^=. & &w^=. & &x^=.) ;
        read all var {&x}  into grp where(&es^=. & &w^=. & &x^=.) ;

        k = nrow(es)  ;
        df = k - 1   ;
        x = design(grp) ;
        p = j(1,ncol(x),1) ;
        j = j(k,1,1) ;
        v = 1/w ;

        %if %upcase(&model) = MM | %upcase(&model) = ML %then
           %do;
                  xw = x#(w*p) ; xwx = T(xw)*x ;
                  B = inv(xwx)*T(xw)*es ;
                  qe = sum(es#w#es) - T(B)*xwx*B ;
                  ww = w#w ; xww = x#(ww*p) ; xwwx = T(xww)*x ;
                  c = (qe-(k-ncol(x)))*inv(sum(w) - trace((xwwx)*inv(xwx))) ;
				  
                  if c<0 then c = 0 ;
                  w = 1/(v + c) ;
            %end ;

        %if %upcase(&model) = ML %then
           %do i=1 %to 100;
                          xw = x#(w*p) ; xwx = T(xw)*x ;
                          B = inv(xwx)*T(xw)*es ;
                          r = es - x*B ;
                          c = sum((w#w)#(r#r-(v))) /
                                (sum(w#w)) ;
                          if c<0 then c = 0 ;
			  w = 1/(v+c) ;
           %end ;

	%if %upcase(&model) = ML %then
			%do ;  se_c = sqrt(2/sum(w#w)) ; %end ;

	  group = char(inv(T(x)*x)*T(x)*grp,8,0) ;
	  means = T(T(T(x#(w*p))*es)*inv(T(x#(w*p))*x)) ;
	  grpns = vecdiag(T(x)*x) ;
	  q =  T(x#(w*p))*(es##2)-T(T((T(x#(w*p))*es)##2)*inv(T(x#(w*p))*x)) ;
	  qt = sum(es##2#w) - sum(es#w)**2/sum(w) ;
	  qw = sum(q) ;
	  qb = qt - qw ;
	  dfb = ncol(x) - 1 ;
	  dfw = nrow(es) - ncol(x) ;
	  dft = nrow(es) - 1 ;
	  pb   = 1 - probchi(qb,dfb) ;
	  pw   = 1 - probchi(qw,dfw) ;
	  ptot = 1 - probchi(qt,dft) ;
	  se = sqrt(vecdiag(inv(T(x#(w*p))*x)));
	  tvalues = means#vecdiag(inv(diag(se))) ;
	  pt = 1-probf(tvalues#tvalues,1,dfw) ;
	  lmeans = means - (se#1.96) ;
	  umeans = means + (se#1.96) ;
	  gmean = sum(es#w)/sum(w) ;
	  segmean = sqrt(1/sum(w)) ;
	  df = grpns - 1 ;    
	  pq = 1 - probchi(q,df) ;

      %if %upcase(&model) = MM %then
        %do ; print "--------- Random Effects Model ------" ;
              print "-- estimated via method of moments --" ;
        print c [label= ' '] [rowname = 'Random eff. var. component = ']
                        [format=12.8];
        %end ;

      %if %upcase(&model) = ML %then
        %do ; print "--------- Random Effects Model ------" ;
              print "-- estimated via iterative full information maximum likelihood --" ;
        mlc = c // se_c ;
		print mlc [label= ' '] [rowname = {'Random eff. var. component  = '
                  'St. Error of var. component = '}]
                  [format=12.8];
        %end ;

	  print  "------- Analog ANOVA table (Homogeneity Q)  -------";
	  qtab1 = qb // qw // qt ;
	  qtab2 = dfb // dfw // dft ;
	  qtab3 = pb // pw // ptot ;
	  print qtab1 [rowname={"Between","Within","Total"}] 
	  			  [colname="Q"]		[label="Source"] [format=12.5]
	  		qtab2 [label="df"] 
	  		qtab3 [label="p"] [format=12.5];
	
	  print "------- Q by Group -------" ;
	  print q [rowname=group] 
	  			  [colname="Q"]	[label="Group"] [format=12.5]
		 	df [label="df"]
			pq [label="p"] [format=12.5];
	  
	  print "------- Effect Size Results by Group -------" ;
	  means = means // gmean ;
	  se = se // segmean ;
	  lmeans = lmeans // gmean-(segmean*1.96) ;
	  umeans = umeans // gmean+(segmean*1.96) ;
	  tvalues = tvalues // gmean/segmean ;
	  pt = pt // 1-probf((gmean/segmean)#(gmean/segmean),1,dfw) ;
	  grpns = grpns // k ;
	  group = group // "   Total" ;
	  print means [rowname=group] [colname="Means"] [label="Group"]
	  		[format=10.5]
			se [label="SE"] [format=10.5]
			lmeans [label='-95%CI'] [format=10.5]
			umeans [label='+95%CI'] [format=10.5]
			tvalues  [label="t"] [format=10.5]
			pt  [label="p"] [format=10.5]
			grpns [label="n"];

%MEND metaf;
run;quit;


%macro moments(dfile=,es=,wgt=,study=);
*---Experimental macro, provided as-is (that is, provided with no warranty).;

*---Macro is an alternative to the 'meanes' macro by Wilson (see above). 
	This uses SAS procedures and data steps to conduct a univariate MOMENT-based 
	meta analysis, instead of an IML program. In some ways, the advantage of this 
	macro is for educational purposes -- demonstrating how to obtain the needed 
	statistics for the simple case of no moderators. Program also is useful 
	for obtaining the I-squared heterogeneity index of Higgins and Thompson.;  
*---Macro written by L. Madden.;

*---In general, I prefer likelihood-based meta-analyses, but many use the
	moment approach (thus, this macro).;

/*
dfile		name of the sas data file with data
es			name of variable in dfile with the effect size response variable
wgt			name of the weight variable in dfile. This needs to be the
			inverse of the "sampling variance" for each study
study		variable name for the labeled study (trial) in dfile

Macro creates various variables and data files starting with the underline symbol (_). 
As a precaution, it is best if you do not have any variables or file names that
start with this symbol. Macro also overwrites titles starting at title2. 

After running the macro, the data files _q_out2 and _q_out3, which contain the 
results, are available for further processing (if needed).
*/

title2 "Cochran's Q, df, test of homogeneity, and Higgins-Thompson H2 & I2";
proc glm data=&dfile;
ods exclude all;
*ods listing select overallanova;		*<--look only at a table that contains SSE;
ods output overallanova=_q_out;			*<--store Q (=SSE) for manipulation below;
class &study;
weight &wgt;
model &es = / solution;
run;quit;
ods exclude none;
*---Only one piece of output from PROC GLM is used (the rest is meaningless here).;

data _q_out2; set _q_out(where=(Source='Error'));	*<--manipulate the Q value;
	Q = ss;
	H2 = Q/df;					*<--H-squared statistic of Higgins and Thompson;
	I2 = 100*(H2-1)/H2;			*<--I-squared statistic of Higgins and Thompson;
	if (I2 lt 0) then I2 = 0;
	Pq = 1 - probchi(Q,df);		*<--P value for test of homogeneity (Cochran Q test);
	keep Q  df Pq H2 I2 ;
run;
/*
proc print data=_q_out2;
	var Q df Pq H2 I2 ;
run;
*/

/*
One can get the MOMENT-based estimate of the among-study variance using the
following code, which uses the value of Q calculated in the above file.
*/

*ods listing close;
data _dfile2; set &dfile; 			*<--temporary file;
wgt2=&wgt**2;						*<--get weights squared (same as sampling SD to 4th power);
run;

*proc print data=_dfile2;run;

proc means data=_dfile2 sum noprint;	*<--get and store the sum of weights and weights-squared;
var &wgt wgt2;
output out= _dfile2out  sum(&wgt)=wgts sum(wgt2)=wgt2s;
run;

data _q_out3; merge _q_out2 _dfile2out;	*<--combine/merge files (Q, etc., with sum of weights);
data _q_out3; set _q_out3;				*<--get c coefficient (see Appendix in Madden & Paul);
c = wgts - (wgt2s/wgts);	
variance_MM = (Q - df)/c;				*<--get moment-based among-study variance estimate;
if (variance_MM lt 0) then variance_MM = 0;
run;

data _dtemp; 
if _n_ = 1 then set _q_out3;
set &dfile;
newweight = 1/(variance_MM + (1/&wgt));
joint = newweight*&es;
*proc print data=_dtemp;run;

proc means data=_dtemp noprint;
output out=_dfile2out sum(newweight)=snewweight sum(joint)=sjoint;
data _dfile2out; set _dfile2out;
meanES_MM = sjoint/snewweight;
SE_meanES_MM = snewweight**(-0.50);

data _q_out3; merge _q_out3 _dfile2out;
Hsq_multiplier = (wgts - (wgt2s/wgts))/df;
*ods listing;
run;
title2 'Moment-based estimate of the among-study variance, etc. (cf. meanes macro results)';
*proc print data=_q_out3;
*var Q c variance_MM meanES_MM SE_meanES_MM wgts wgt2s Hsq_multiplier;

proc print data=_q_out3;
	format Pq pvalue7.4;
	var Q c df Pq variance_MM meanES_MM SE_meanES_MM  H2 I2 ;
run;
ods results off;
proc datasets nolist ;delete _dfile2 _dfile2out _dtemp _q_out  run;
ods results;
run;
title2;
run;
%mend moments;
run;

%macro H2I2(dfile=_q_out3,var=1,df=100);
title2 'H^2 and I^2 statistics based on ML or REML among-study variance';
/*
Macro _REQUIRES_ prior running of %moments macro, or prior creation of a 
file with c (see page 29 in Madden & Paul 2011), and df. 
One must input the among-study variance (var), estimated with ML or REML 
with random-effects model.

Experimental (no warranties).  L. V. Madden (Ohio State Univ.) - 2015

dfile	File name with c and df. Default is _q_out3, created by %moments
var		Among-study variance, determined with ML or REML (using GLIMMIX, etc.). Required.
df		Degrees of freedom, assumed to be in dfile (if not, then specify)

H2_ML	Output variable (either ML or REML estimate of H2)
I2_ML	Output varialbe (either ML or REML estimate of I2)
*/
data &dfile; set &dfile;
varml = &var;
H2_ML = ((c*&var)/df) + 1;
I2_ML = 100*(H2_ML - 1)/H2_ML ;
run;
proc print data=&dfile;
var varml df c H2_ML I2_ML ;
run;
%mend H2I2;


%macro H2I2_(dfile=_q_out3,var=1,alpha=.05,es=1,se=1);
title2 'H^2 and I^2 statistics based on ML or REML among-study variance';
title3 '(1-alpha)100% prediction limits';
/*
Macro _REQUIRES_ prior running of %moments macro, or prior creation of a 
file with c (see page 29 in Madden & Paul 2011), and df. 
One must input the among-study variance (var), estimated with ML or REML 
with random-effects model.

Experimental (no warranties).  L. V. Madden (Ohio State Univ.) - 2015

dfile	File name with c and df. Default is _q_out3, created by %moments
var		Among-study variance, determined with ML or REML (using GLIMMIX, etc.). Required.
df		Degrees of freedom, assumed to be in dfile
es		Effect size mean
se		Standard error of effect size mean
alpha	Chosen probability for calculating prediction interval

H2_ML	Output variable (either ML or REML estimate of H2)
I2_ML	Output varialbe (either ML or REML estimate of I2)
predlow	Lower limit of (1-alpha)100% prediction interval
predhighUpper limit of prediction interval
*/
data &dfile; set &dfile;
varml = &var;
se= &se;
es= &es;
alpha = &alpha;
H2_ML = ((c*&var)/df) + 1;
I2_ML = 100*(H2_ML - 1)/H2_ML ;
tstar= tinv(1-&alpha/2,df);
sestar = sqrt(varml + se**2);
predlow = es - tstar*sestar;
predhigh= es + tstar*sestar;
run;
proc print data=&dfile;
var es se varml df c H2_ML I2_ML alpha tstar predlow predhigh;
run;
%mend H2I2_;



%macro funnel(dfile=,es=,wgt=,study=,minprec=2,maxprec=80,numb=25);
*---Experimental macro, provided as-is (that is, provided with no warranty);

*---Macro produces a funnel graph and a radial plot for assessing whether or
	not a random study effect is needed. These diagnostics, especially the
	funnel graph, are very common in some disciplines (but not yet in plant 
	pathology). Macro written by L. Madden.;

*---Funnel graph: plot of "precision" vs. effect size, with a vertical line
	for FIXED-effect common effect size, and curves for the confidence intervals
	around the common effect size. If "too many" points are outside the curves,
	this is evidence for a random effects analysis.
	In this application, precision is the inverse of the within-study SE;
*---Ideally, the funnel graph should be symmetrical. Gaps (say, on the lower
	left or right), can indicate PUBLICATION BIAS, where nonsignificant results
	are not published or made available. However, the gaps could be due to
	other factors, so this is just a guide. These graphs originiated with, or
	were advocated by, Light and Pillemer, Sterne et al., and Egger et al.;

*---Radial plots, also known as Galbraith plots, show the standardized effect
	size (_es_/SE) versus precision (1/SE) for each study. The slope of the line
	through these points is the FIXED-effects common effect size. If many points
	fall outside the confidence bands, there is evidence for a random effects
	analysis. Gaps are indicative of PUBLICATION BIAS.;
	
/*
dfile		name of the sas data file with data
es			name of variable in dfile with the effect size response variable
wgt			name of the weight variable in dfile. This needs to be the
			inverse of the "sampling variance" for each study
study		variable name for the labeled study (trial) in dfile
minprec		Minimum precision value used in the graph (set by trial and error, so
			that the full range of data is encompassed by the curves
maxprec		Maximum precision value used in the graph (set by trial and error, so
			that the full range of data is encompassed by the curves
numb		Number of precision values to make from minprect to maxprec (default25)

Macro creates various variables and data files starting with the underline symbol (_). 
As a precaution, it is best if you do not have any variables or file names that
start with this symbol. Macro also overwrites titles starting at title2. 
One can ignore tabular output here (just use the plots). Graphs are made with 
the new SGPLOT procedure, which requires sas 9.2 or later.

After running the macro, the data files _pred1s and _funnel are available for 
further use, if desired.
*/

title2 'Funnel and radial plots';
*ods listing close;
*ods html;
*ods graphics on  /* / width=6in */ ;

data _ESdata; set &dfile;
keep &es  _precdata _StES;
_precdata = sqrt(&wgt);
_StES = &es*_precdata;
run;
*proc print data=_ESdata;run;
ods exclude all;
proc mixed data=_ESdata;	*---a fixed-effect (common-effect) analysis.;
title3 '(PROC MIXED used to get fixed-effect values, go right to the plots)';
ods output solutionf=_sf; 
model _StES = _precdata / s noint outp=_pred1;
parms (1) / hold=1;
run;
ods exclude none;
title3;
data _null_; set _sf;
call symput('ref',estimate);

run;


data _prec; 

_incr = (&maxPrec - &minPrec)/&numb;
do _prec = &minPrec to &maxPrec by _incr;

	_ES1 = &ref + 2*(1/_prec);
	_ES2 = &ref - 2*(1/_prec);
	output;
end;
run;
*proc print data=_prec;run;




data _funnel; merge _prec _ESdata;
run;
*proc print data=_funnel;run;

data _pred1; set _pred1;
low = pred - 2;
high = pred + 2;

proc sort data=_pred1 out=_pred1s;
by _precdata;run;
*proc print data=_pred1s;run;



data _pred1s; set _pred1s;
label _precdata = 1/SE _StES=Standardized Effect Size;
data _funnel; set _funnel;
label &es=Effect size _precdata=1/SE;
run;

data _null_;
put "Radial plot data in file _pred1s";
put "funnel data in file _funnel";
run;

run;


proc sgplot data=_funnel noautolegend;
series x=_ES1 y=_prec / lineattrs=(color=red pattern=2 thickness=2);
series x=_ES2 y=_prec / lineattrs=(color=red pattern=2 thickness=2);
scatter x=&es y=_precdata / markerattrs=(color=blue symbol=squarefilled size=7pt);
refline &ref / axis=x  lineattrs=(color=blue pattern=1 thickness=2);
*refline 0 / axis=x lineattrs=(color=gray pattern=3 thickness=1);
run;

proc sgplot data=_pred1s noautolegend;
scatter  x=_precdata y=_StES / markerattrs=(color=red symbol=squarefilled size=7pt);
series x=_precdata y=pred / lineattrs=(color=red pattern=1 thickness=2);
series x=_precdata y=low / lineattrs=(color=blue pattern=2 thickness=1);
series x=_precdata y=high / lineattrs=(color=blue pattern=2 thickness=1);
run;   

*ods graphics off;
*ods html close;
*ods listing;
run;

title2;
ods results off;
proc datasets nolist ; delete _esdata  _prec _pred1  _sf; run; ods results;run;
%mend funnel;
run;

%macro Probnewstudy(meanES=,SIGMA2=,numb=20,minT=,maxT=);
*---Experimental macro, provided as-is (that is, with no warranty).;

*---Determine probability that a randomly selected study has an Effect Size greater (less) than
	the constant _T, based on the meanES and between-study variance from a random-effects
	meta-analysis. Method described in Madden and Paul (Phytopathology 101:16-30 [2011]).
	Key references given in that paper. Macro written by L. Madden. ;
*---Macro overwrites title2 and higher.;

/*
meanES		Mean (expected) Effect Size. Use meanES estimated from a random-effects meta-analysis
SIGMA2		Among-study variance (from a random-effects meta-analysis)
minT		Minimum value of Effect-Size Constant considered 
maxT		Maximum value of Effect-Size Constant considered
numb		Number of constant Effect Sizes between minT and maxT (default is 20)
			(one actually gets one more than the value of numb)

Results are put in the data file _gener, which can be accessed after running the macro,
if desired.
*/

title2 'Probability that Effect Size is greater (or less) than specified constants';
title3 '(Investigator must use context to know which one of two probabilities is needed)';
data _gener; 
_meanES = &meanES;
_SIG2 = &SIGMA2;
label  _1mpz='Pr(ES > const)' _meanES='mean ES' _SIG2='among-study var' 
_pz='Pr(ES < const)' 
_t='const ES';

_SIGMA=sqrt(&SIGMA2);
_incr = (&maxT - &minT)/&numb;

do 	_t =  &minT to &maxT  by _incr;
	_z = (_t - &meanES)/_SIGMA;
	_pz = cdf('normal',_z);
	_1mpz = 1 - _pz;
	output;
label _t='Constant' _z='Z statistic' _pz='Prob(less than)' _1mpz='Prob(greater than)';
end;
put "data file is _gener";
run;
proc print data=_gener label; var _meanES _SIG2 _t _z _pz _1mpz; 
run;
*proc datasets nolist;*run;
%mend Probnewstudy;
run;

%macro biasbound(dfile=,wgt=,SIGMA2=,plotbiasmax=,plotbiasref=,K=,new=);
*---Experimental macro, provided as-is (that is, with no warranty).;

*---Macro calcuates the absolute value of the bias bound from a univariate meta-analysis,
	based on the method developed by Copas and Jackson. Basic concept: find the
	magnitude of the bias (upper limit) for the estimated effect size if there is from 
	1 to NEW additional studies that were not included in the meta-analysis.;
*---Tabular and graphic output is generated.
	Results are stored in data file _gg0, which can be accessed after running the macro.;
*---Macro written by L. Madden.;

/*
dfile		Name of sas data file with effect sizes and related items
wgt			Weight variable (inverse of the "sampling variance") for each
			study. The same weight used in the meta-analysis
SIGMA2		Among-study variance (estimated from a random-effects meta-analysis)
plotbiasmax	Maximum "y value" in the graph of |bias bound| vs. # of unrepored studies.
			Good choice: absoulte value of the mean ES estimated from the random-effects
			meta-analysis.
plotbiasref	A horizontal reference line on the graph. Could be the absolute value of 
			lower 95% confidence limit for mean ES. If you don't want a reference
			line, then give a plotbiasref value greater than plotbiasmax.
K			Number of studies in the actual meta-analysis.
new			Maxinum number of "additional" studies that could exist. The bias
			bound is found for 1-->new addtional studies. One choice for NEW:
			if the original meta-analysis was based on K studies, then also
			use K for NEW. 

			If the bias-bound curve does not cross or come too close to the mean
			ES, then publication bias is likely not too much of a concern.
*/
title2 '|Bias bound| vs. unobserved studies';
data _gg00; set &dfile;
_pr = (1/&wgt);
_pr2 = (_pr + &SIGMA2)**(-0.5);
_pr3 = (_pr + &SIGMA2)**(-1);
run;
*proc print data=_gg00;run;
proc means data=_gg00  noprint ;
var _pr2 _pr3;
output out=_gg000 sum(_pr2)=_pr2 sum(_pr3)=_pr3; 
proc print data=_gg000;run;
data _gg000; set _gg000;
_rat1 = _pr2/_pr3;
call symput('_precR',_rat1);

data _gg0;
do m = 1 to &new;
	ratio = &K/(&K+m);
	middle = quantile('NORMAL',ratio);
	prob=pdf('NORMAL',middle);
	_bias = (1/ratio)*prob*&_precR;
	
	output;

	end;
label _bias='|Bias bound|' m='Additional studies';

proc print data=_gg0 label;
var m _bias;
run;

*---graph the bias bound vs. number of unobserved studies;
*ods html;
*ods graphics on / width=3in;
proc sgplot data=_gg0;
series x=m y=_bias / 
		lineattrs=(color=blue thickness=3 pattern=1);
refline &plotbiasref / axis=y lineattrs=(color=grey pattern=3 thickness=1);
xaxis  label="Number of unobserved studies" ;
yaxis  label="|Bias bound|" max=&plotbiasmax min=0;
run;
*ods graphics off;
*ods html close;
run;
*proc datasets nolist;*run;
%mend biasbound;


%macro metapower(meanES=,SE=,K=,dfAdjust=1,alpha=0.05,nullmu=0);
title2 'Power analysis for random-effects meta-analysis (1- and 2-sided)';
*---Experimental macro, provided as-is (that is, with no warranty).;
*---Determine the power of the meta-analysis to detect true non-null effects, if one 
	had another set of K studies with the same results, with the assumption that
	the null hypothesis (of no effect) is false (i.e., so that the alternative
	hypothesis is true).;
*---The null hypothesis is 		Ho: ES = nullmu

	Alternative hypothesis is:	Ha: ES ne nullmu 	(not equal)	, or
								Ha: ES >  nullmu				, or
								Ha: ES <  nullmu
	All three Ha hypotheses are evaluated. Note that a large number of decimal places are displayed,
	so that one can compare different scenarios.
	
	All based on t or F distribution with non-centrality parameter. NOT done with simulation.;

/*
meanES		Mean (expected) Effect Size. Use meanES estimated from a random-effects meta-analysis
SE			Standard Error of estimated Effect Size (from a random-effects meta-analysis)
K			Number of studies in the meta-analysis
alpha		Pre-determined type I error rate constant (usually 0.05). That is, if one is
			performing a test of Ho: ES = nullmu with the chosen alpha.
nullmu		Constant value of the null hypothesis, that is, Ho: ES = nullmu
dfAdjust	df for the hypothesis test is based on number of studies minus dfAdjust.
			Typically, this is df = K - dfAdjust, and dfAdjust=1. However, some
			argue for more stringent conditions (e.g., dfAdjust=2). 

Results are put in the data file _fullpower, which can be accessed after running the macro,
if desired.
*/
data _fullpower;
	_meanES = &meanES;
	_SE = &SE;
	_mu = &nullmu;
	_df = &K - &dfAdjust;
	_tstatistic = &meanES/&SE;
	_noncen = ((&meanES - &nullmu)/&SE)**2;			*---noncen, power, etc., are for LRdon;
				
	_Fcrit = finv(1-&alpha,1,_df,0);
	_power = 1 - probf(_Fcrit,1,_df,_noncen);

	nc0 = (&meanES - &nullmu) / &SE ;
	tcrit1 = tinv(1-&alpha/1, _df);					*<--one-sided;
	tcrit2 = tinv(&alpha/1, _df);
	
	Pwr10 = 1 - probt(tcrit1,_df,nc0);
	Pwr20 = probt(tcrit2,_df,nc0);

	format _power 16.12 Pwr10 16.12 Pwr20 16.12;
	*label _power='Power';
	label _power='Power(2-side)' _mu='NullMean' Pwr10='Power(upper 1-side)' Pwr20='Power(lower 1-side)'
		_meanES='mean ES' _SE='Std Error' _df='df' nc0='NonCentral param';

run;
proc print data=_fullpower label;  
var _meanES _SE _df _mu nc0 _power Pwr10 Pwr20; run;
data _null_;
put "results are in file _fullpower";
run;
title2;
%mend metapower;


%macro metapower2(meanES=,SE=,K=,dfAdjust=1,alpha=0.05,nullmumin=0,nullmumax=,numb=25);
title2 'Power analysis for random-effects meta-analysis (1- and 2-sided)';

*---Experimental macro, provided as-is (that is, with no warranty).;
*---Determine the power of the meta-analysis to detect true non-null effects, if one 
	had another set of K studies with the same results, with the assumption that
	the null hypothesis (of no effect) is false (i.e., so that the alternative
	hypothesis is true).;
*---The null hypothesis is 		Ho: ES = nullmu

	Alternative hypothesis is:	Ha: ES ne nullmu 	(not equal)	, or
								Ha: ES >  nullmu				, or
								Ha: ES <  nullmu
	All three Ha hypotheses are evaluated. Note that a large number of decimal places are displayed,
	so that one can compare different scenarios.

	A range of values for the expected value under the null hypothesis (nullmu) is considered,
	from nullmumin to nullmumax. In other words, this macro is the same as metapower, except
	that multiple values of nullmu are evaluated.

	All based on t or F distribution with non-centrality parameter. NOT done with simulation.;

*---Results are stored in data file _fullpower2, which can be accessed after running the macro.;

/*
meanES		Mean (expected) Effect Size. Use meanES estimated from a random-effects meta-analysis
SE			Standard Error of estimated Effect Size (from a random-effects meta-analysis)
K			Number of studies in the original meta-analysis
alpha		Pre-determined type I error rate constant (usually 0.05). That is, if one is
			performing a test of Ho: ES = nullmu with the chosen alpha.
nullmumin	Smallest mean ES under Ho (ES = nullmu) considered
nullmumax	Largest mean ES under Ho (ES = nullmu) considered
dfAdjust	df for the hypothesis test is based on number of studies minus dfAdjust.
			Typically, this is df = K - dfAdjust, and dfAdjust=1. However, some
			argue for more stringent conditions (e.g., dfAdjust=2). 
numb		Number of distinct nullmeans evaluated (between nullmumin and nullmax)
			Default of 25 values.

Graph made with the SGPLOT procedure (requires sas 9.2 or later).

*/
data _fullpower2;
	_meanES = &meanES;
	_SE = &SE;
_incr = (&nullmumax - &nullmumin)/&numb;
_df = &K - &dfAdjust;
_K = &K;

do _mu = &nullmumin to &nullmumax by _incr;
	_tstatistic = &meanES/&SE;
	_noncen = ((&meanES - _mu)/&SE)**2;					*---noncen, power, etc., are for LRdon;
				
	_Fcrit = finv(1-&alpha,1,_df,0);
	_power = 1 - probf(_Fcrit,1,_df,_noncen);

	nc0 = (&meanES - _mu) / &SE ;
	tcrit1 = tinv(1-&alpha/1, _df);					*<--one-sided;
	tcrit2 = tinv(&alpha/1, _df);
	
	Pwr10 = 1 - probt(tcrit1,_df,nc0);
	Pwr20 = probt(tcrit2,_df,nc0);
	output;
end;

format _power 16.12 Pwr10 16.12 Pwr20 16.12;
label _power='Power(2-side)' _mu='NullMean' Pwr10='Power(upper 1-side)' 
Pwr20='Power(lower 1-side)' _df='df' _K='No of studies'
_meanES='mean ES' _SE='Std Error' _df='df' nc0='NonCentral param'  
;
run;

*ods html;
*ods graphics on / width=6in;
proc print data=_fullpower2 label; 
var _meanES _SE _df  _K _mu nc0 _power Pwr10 Pwr20; run;


proc sgplot data=_fullpower2;
series x=_mu y=_power / lineattrs=(color=blue thickness=3 pattern=1);;
series x=_mu y=Pwr10 / lineattrs=(color=blue thickness=2 pattern=3);;
series x=_mu y=Pwr20 / lineattrs=(color=blue thickness=2 pattern=4);;
yaxis label="Power"; xaxis label="Null hypothesis mean";
run;
*ods graphics ;
*ods html close;
run;
data _null_;
put "results in file _fullpower2";
title2;
run;
%mend metapower2;
run;


%macro metapower3(meanES=,SE=,alpha=0.05,nullmu=0,Korig=,Kmin=2,Kmax=);
title2 'Power analysis for random-effects meta-analysis (1- and 2-sided)';
*title3 '(range of number of studies for identified ES under the null hypothesis)';

*---Experimental macro, provided as-is (that is, with no warranty).;
*---Determine the power of the meta-analysis to detect true non-null effects, if one 
	had another set of K studies with the same results, with the assumption that
	the null hypothesis (of no effect) is false (i.e., so that the alternative
	hypothesis is true).;
*---The null hypothesis is 		Ho: ES = nullmu

	Alternative hypothesis is:	Ha: ES ne nullmu	 (not equal), or
								Ha: ES >  nullmu				, or
								Ha: ES <  nullmu
	All three Ha s are evaluated. Note that a large number of decimal places are displayed,
	so that one can compare different scenarios.

	A range of number of studies (K) is considered (from Kmin to Kmax), all for one 
	null-hypothesis mean (nullmu). Separate results for K: Kmin-->Kmax. This macro is the 
	same as %metapower, except that a range of K values are considered.;
*---The macro is based on the "theoretical power" calculations shown in Madden
	and Paul (2011). A more accurate approach is based on simulation (also described in
	Madden and Paul), but this macro does not do the latter.;

*---Macro also calculates the 95% confidence interval for the expected effect size for
	all K values between Kmin and Kmax. All done with theoretical distribution, NOT
	done with simulation.;

*---Results are stored in data file _fullpower3, which can be accessed after running the macro.;

/*
meanES		Mean (expected) Effect Size. Use meanES estimated from a random-effects meta-analysis
SE			Standard Error of estimated Effect Size (from a random-effects meta-analysis)
Korig		Original number of studies (K) in the meta-analysis that results in meanES and SE
Kmin		Minimum number of studies in the original meta-analysis
Kmax		Maximun number of studies in the meta-analysis
alpha		Pre-determined type I error rate constant (usually 0.05). That is, if one is
			performing a test of Ho: ES = nullmu with the chosen alpha.
nullmu		Constant value of the null hypothesis, that is, Ho: ES = nullmu
dfAdjust	df for the hypothesis test is based on number of studies minus dfAdjust.
			Typically, this is df = K - dfAdjust, and dfAdjust=1. However, some
			argue for more stringent conditions (e.g., dfAdjust=2). 

Graph made with SGPLOT procedure (requires sas 9.2 or later).
*/

data _fullpower3;

_mnES = &meanES;
_C = &SE/(&Korig**(-0.5));	*<--a Standard-Deviation-type index;
nullmean=&nullmu;
do _K = &Kmin to &Kmax ;
	
	_SE = _C*(_K**(-0.5));
	_tstatistic = &meanES/_SE;
	_noncen = ((&meanES - &nullmu)/_SE)**2;					*---noncen, power, etc.;
				
	_Fcrit = finv(1-&alpha,1,_K-1,0);
	_power = 1 - probf(_Fcrit,1,_K-1,_noncen);

	nc0 = (&meanES - &nullmu) / _SE ;
	tcrit1 = tinv(1-&alpha/1, _K-1);						*<--one-sided;
	tcrit2 = tinv(&alpha/1, _K-1);
	
	Pwr10 = 1 - probt(tcrit1,_K-1,nc0);
	Pwr20 = probt(tcrit2,_K-1,nc0);
	output;
end;

format _power 16.12 Pwr10 16.12 Pwr20 16.12 nc0 7.3 _K 4.0;

label _power='Power(2-side)'  Pwr10='Power(upper 1-side)' Pwr20='Power(lower 1-side)' 
nc0='Noncentral Parm' _K='Numb of studies' _df='df' _mnES='Mean ES' ;

data _fullpower3; set _fullpower3;
_upperl = &meanES + sqrt(_Fcrit)*_SE;
_lowerl = &meanES - sqrt(_Fcrit)*_SE;
label _upperl="Upper limit" _lowerl="Lower limit";
run;

*ods html;
*ods graphics on;
proc print data=_fullpower3 label; var _mnES _K  nc0  nullmean _power Pwr10 
		Pwr20 ; 
proc print data=_fullpower3 label; var _mnES _K _lowerl _upperl;
run;

proc sgplot data=_fullpower3;
series x=_K y=_power / lineattrs=(color=blue thickness=3 pattern=1);;
series x=_K y=Pwr10 / lineattrs=(color=blue thickness=2 pattern=3);;
series x=_K y=Pwr20 / lineattrs=(color=blue thickness=2 pattern=4);;
yaxis label="Power"; xaxis label="Number of studies";
run;

proc sgplot data=_fullpower3;
band x=_K upper=_upperl lower=_lowerl / transparency=0.5 fill 
		outline lineattrs=(pattern=solid);
series x=_K y=_mnES / lineattrs=(color=blue thickness=3);;
xaxis type=Log /*logstyle=LogExpand minor*/ label="Number of studies";
yaxis label="Mean and Conf. Int.";
run;
*ods graphics off;
*ods html close;
run;
data _null_;
put "results in file _fullpower3";
title2;
run;
%mend metapower3;
run;


data _pvalues1;
input P @@;
datalines;
.1 .02 .09 .25 .5 .015 
;
run;

title;
%macro globalP(dfile=,P=);
*---Experimental macro, written by L. Madden (no warranties).;
*---Macro performs the method of Fisher for determining a "global" P value
	based on the pvalues for individual studies. The input data set 
	(dfile) is specified, and the name of the pvalue variable in the 
	data set. No other information is required.;
*---Output is the achieved chi-squared statistic, df (=2*number of studies),
	and the global P value.;
*---Macro also does the LOGIT-based method of George for combining P values,also
	does inverse-normal method of Stouffer ;
title2 'Meta-analysis based only on P-values';

proc iml;
use &dfile;
read all var{&P} into pvalue;

K = nrow(pvalue);
df = 2*K;
*---Fisher method;
indiv = -2*log(pvalue);
stat = sum(indiv);
globalP = 1 - probchi(stat,df);
Crit_chisq05 = cinv(.95,df);		*<---critical test statistic at alpha=.05;
Crit_chisq01 = cinv(.99,df);		*<---critical test statistic at alpha=.01;
Crit_chisq001 = cinv(.999,df);		*<---critical test statistic at alpha=.001;

*---Logit method of George;
df_lgt = 5*K + 4;
indiv_lgt = log(pvalue/(1-pvalue));
stat1_lgt = sum(indiv_lgt);
scale_lgt = -sqrt((15*K + 12)/((5*K+2)*K*3.141593**2));
stat_lgt = scale_lgt*stat1_lgt;
globalP_lgt = 1 - probt(stat_lgt,df_lgt);
Crit_t05 = tinv(.95,df_lgt);
Crit_t01 = tinv(.99,df_lgt);
Crit_t001 = tinv(.999,df_lgt);

*---Inverse normal method of Stouffer;
indiv_z = probit(pvalue);
stat_z = sum(indiv_z/sqrt(K));
globalP_z = 1 - probnorm(-stat_z);
Crit_z05 = probit(.95);
Crit_z01 = probit(.99);
Crit_z001 = probit(.999);

*print pvalue indiv;

print "Fisher-based global P value, based on a chi-squared test and a collection of individual P values";
print stat df globalP [format= pvalue11.7] crit_chisq05 crit_chisq01 crit_chisq001;

print "";
print "LOGIT-based global P value, based on a t test and a collection of individual P values";
print stat_lgt df_lgt globalP_lgt [format= pvalue11.7]  crit_t05 crit_t01 crit_t001;


print "";
print "Inverse-normal-based global P value, based on a z test and a collection of individual P values";
print stat_z  globalP_z  [format= pvalue11.7] crit_z05 crit_z01 crit_z001;

print "^^^Critical values for test statistic (chi-squared, t, or z) are shown above (at .05, .01, .001)^^^";
run;quit;
%mend globalP;

*options mprint;
*%globalP(dfile=_pvalues1,P=P);
run;


