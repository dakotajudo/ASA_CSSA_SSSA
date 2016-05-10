/*
You should run this before the workshop to make sure you have things set up
correctly. Also, read the comments here.

SAS University Edition (UE) operates on a virtual Linux machine created on your
computer. Access to UE is through a web browser. Once launched, the user interacts
with UE through "SAS Studio". It has a different apprearance and flavor compared
with the front end of regular (licensed) SAS. Note that the opened file names and 
key buttons appear on top with UE (they are below the windows with regular SAS).
With UE, the results are in the RESULTS window, and the program is in the CODE
window. By default with UE, the old results are deleted with each run of
the program. You can change this by switching to "interactive" (third button
from the right on top), but this can lead to challenges in accessing macros. 

The text comments are automatically converted to italics with UE. Moreover,
SAS Studio has a type-ahead feature: it figures out what you are trying to 
type and attemps to fill in the rest (if you let it). This helps when you are not
sure of the syntax. There are also many other features of UE (such as code 
snippets that can be accessed to make your programming easier). 

Because UE works as a Linux program, there can be issues when reading data
that were first stored in EXCEL (a Windows program). Embedded tabs and other 
hidden characters from Excel can cause problems. Thus, to read data file s, 
below, you need to use the strange looking INFILE statement; this statement 
is not used with regular SAS run on Windows. If you omit the statement here, 
you would get an error on the read. The infile statement is not needed with
the second data file.

You should run this program and make sure that file y and file s are printed
in the Results window, and that there are no errors in the Log. If you can run 
these correctly, then you will be all set for the workshop! We will use BOTH 
of these data files a lot in the workshop, with plenty of comments descring
all the variables.
*/

title 'SAS University Edition (UE) test of data input';
data s;							
infile datalines dlm='09'x;	*<--use this line with SAS UE (for embedded tabs);
input study $ State $ Variety $ Year slope SE lowerlimit upperlimit MinD MaxD MeanD;	
sampvar = SE**2;			
wgt = 1/sampvar;			
id = _n_;					
baseD=1; 					
if (MaxD gt 50) then baseD = 2;		
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

proc print data=s;
title2 'Printing of data file s';
var study slope SE lowerlimit upperlimit sampvar wgt state variety year meanD baseD;
run;


data y;		
/* The INFILE statement is not needed for data file y. It is commented out (with an *). */						
*infile datalines dlm='09'x;		*<--The * turns this statement into a comment;
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
data y; set y;
study = put(trial,2.);	*<--make a character version of the trial ID; 
wtdiff = 1/si2;			*<--within-study weight is the inverse of the sampling variance;
run;

proc print data=y;
title2 'Printing of data file y';
run;
