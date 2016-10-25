<TeXmacs|1.99.5>

<style|<tuple|beamer|ice>>

<\body>
  <screens|<\hidden>
    <tit|>

    <doc-data|<doc-title|Making Sense of the Mixed Model Analyses Available
    in R>|<doc-author|<author-data|<author-name|Peter
    Claussen>|<\author-affiliation>
      Gyling Data Management
    </author-affiliation>>>>

    \ 
  </hidden>|<\hidden>
    <tit|Workflow - AOV of a Linear Model>

    Given a sequence of steps in the analysis of experimental data,

    <\itemize-dot>
      <item>Data Entry

      <item>Model Fitting

      <item>Diagnostics

      <item>Model Building

      <item>Summary Statistics

      <item>Hypothesis Testing

      <item>Presentation
    </itemize-dot>

    how easily can an unfamiliar analysis package be inserted into a familiar
    routine?
  </hidden>|<\hidden>
    <tit|Data Sets>

    \;

    <\enumerate-numeric>
      <item>Simulated Data for an RCBD with Two Missing Observations.

      <item>Series of Similar Experiments

      <item>Multi-environment Breeding Trial

      Data are from\ 

      Model: <math|Y<rsub|i j k>=\<mu\>+Loc<rsub|i> +Rep<rsub|j> (Loc<rsub|i>
      ) +Gen<rsub|k> +Loc<rsub|i>\<times\>Gen<rsub|k>+Cov+\<varepsilon\><rsub|i
      j k>>

      We also use the model from Cotes

      <em|<strong|A Bayesian Approach for Assessing the Stability of
      Genotypes<em|>><strong|>>, Jose Miguel Cotes, Jose Crossa, Adhemar
      Sanches, and Paul L. Cornelius, <with|font-shape|italic|Crop Science>.
      46:2654\U2665 (2006)

      Assume a MET with <math|a> environments, <math|r<rsub|i>> blocks in
      each environment and <math|b=\<Sigma\>r<rsub|i>>, <math|g> genotypes,
      <math|n<rsub|i>> observations in each environment, <math|m<rsub|k>> the
      number of enviroments where the <math|k<rsup|th>> genotype was
      evaluated and <math|n=\<Sigma\>n<rsub|i>> observations.

      <\equation*>
        \<b-y\> = \<b-up-X\>\<b-beta\> \<noplus\>+\<b-Z\><rsub|1>\<b-up-u\><rsub|1>
        +\<b-Z\><rsub|2>\<b-up-u\><rsub|2>+<below|<above|<big|sum>|g>|k=1>\<b-Z\><rsub|3<around*|(|k|)>>\<b-up-u\><rsub|3<around*|(|k|)>>+\<b-1\><rsub|n<rsub|i>>\<otimes\>\<b-up-e\><rsub|i>
      </equation*>

      <\eqnarray*>
        <tformat|<table|<row|<cell|\<b-beta\>
        \<noplus\>>|<cell|=>|<cell|<around*|[|\<mu\><rsub|1>,\<mu\><rsub|2>,\<ldots\>,\<mu\><rsub|g>|]>>>|<row|<cell|\<b-up-u\><rsub|1>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|<with|font-series|bold|0>,\<sigma\><rsub|u<rsub|1>><rsup|2>|)>>>|<row|<cell|\<b-up-u\><rsub|2>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|0,\<sigma\><rsub|u<rsub|2>><rsup|2>|)>>>|<row|<cell|\<b-up-u\><rsub|3<around*|(|k|)>>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|0,\<sigma\><rsub|u<rsub|3<around*|(|k|)>>><rsup|2>|)>>>|<row|<cell|\<b-up-e\><rsub|i><rsub|>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|0,\<sigma\><rsub|e<rsub|i>><rsup|2>|)>\<nocomma\>>>>>
      </eqnarray*>
    </enumerate-numeric>

    \;
  </hidden>|<\hidden>
    <tit|Data Entry (Example 1)>

    R data are commonly stored in data frames.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7 \<less\>- data.frame(

        \ \ \ \ \ \ \ \ plot = c(101,102,103,104,105,106,201,202,203,204,205,206,301,302,303,

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 304,305,306,401,402,403,404,405,406),

        \ \ \ \ \ \ \ \ rep = as.factor(c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4)),

        \ \ \ \ \ \ \ \ col = as.factor(c(1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6)),

        \ \ \ \ \ \ \ \ trt = as.factor(c(4,5,6,3,1,2,6,4,2,5,3,1,2,3,1,6,5,4,3,6,2,5,4,1)),

        \ \ \ \ \ \ \ \ obs = c(3.43,5.25,6.47,2.8,NA,2.66,8.43,6.09,6.41,5.69,7.04,NA,6.07,

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.19,4.93,5.95,4.99,3.26,5.22,7.35,4.48,6.34,6.71,3.13))

        #some packages choke on missing values

        Table5.7 \<less\>- subset(Table5.7, !is.na(Table5.7$obs))
      <|unfolded-io>
        Table5.7 \<less\>- data.frame(

        + \ \ \ \ \ \ \ \ plot = c(101,102,103,104,105,106,201,202,203,204,205,206,301,302,30

        \<less\>103,104,105,106,201,202,203,204,205,206,301,302,303,

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 304,305,306,401,402,403,404,405,406),

        + \ \ \ \ \ \ \ \ rep = as.factor(c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4))

        \<less\>(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4)),

        + \ \ \ \ \ \ \ \ col = as.factor(c(1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6))

        \<less\>(1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6)),

        + \ \ \ \ \ \ \ \ trt = as.factor(c(4,5,6,3,1,2,6,4,2,5,3,1,2,3,1,6,5,4,3,6,2,5,4,1))

        \<less\>(4,5,6,3,1,2,6,4,2,5,3,1,2,3,1,6,5,4,3,6,2,5,4,1)),

        + \ \ \ \ \ \ \ \ obs = c(3.43,5.25,6.47,2.8,NA,2.66,8.43,6.09,6.41,5.69,7.04,NA,6.07

        \<less\>,6.47,2.8,NA,2.66,8.43,6.09,6.41,5.69,7.04,NA,6.07,

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.19,4.93,5.95,4.99,3.26,5.22,7.35,4.48,6.34,6.71,3.13))

        \<gtr\> #some packages choke on missing values

        \<gtr\> Table5.7 \<less\>- subset(Table5.7, !is.na(Table5.7$obs))
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.treatments \<less\>- length(levels(Table5.7$trt))
      <|unfolded-io>
        Table5.7.treatments \<less\>- length(levels(Table5.7$trt))
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Data Entry (Example 2)>

    For structured data, factors can be added programmatically.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1 \<less\>- data.frame(

        Trial=as.factor(c(rep("Clayton", 36),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Clinton", 36),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Plymouth", 36))),

        Variety=as.factor(rep(

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ c(rep("Tracy", 3),
        rep("Centennial", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-137", 3),
        rep("N72-3058", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-3148", 3),
        rep("R73-81", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("D74-7741", 3),
        rep("N73-693", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-877", 3),
        rep("N73-882", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-1102", 3),
        rep("R75-12", 3)),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 3)),

        Rep=as.factor(rep(c(1, 2, 3),36)),

        Yield=c(1178, 1089, 960, 1187, 1180, 1235, 1451, 1177, 1723, 1318,
        1012, 990,\ 

        \ \ \ \ \ \ \ \ 1345, 1335, 1303, 1175, 1064, 1158, 1111, 1111, 1099,
        1388, 1214, 1222,

        \ \ \ \ \ \ \ \ 1254, 1249, 1135, 1179, 1247, 1096, 1345, 1265, 1178,
        1136, 1161, 1004,

        \ \ \ \ \ \ \ \ 1583, 1841, 1464, 1713, 1684, 1378, 1369, 1608, 1647,
        1547, 1647, 1603,

        \ \ \ \ \ \ \ \ 1622, 1801, 1929, 1800, 1787, 1520, 1820, 1521, 1851,
        1464, 1607, 1642,

        \ \ \ \ \ \ \ \ 1775, 1513, 1570, 1673, 1507, 1390, 1894, 1547, 1751,
        1422, 1393, 1342,

        \ \ \ \ \ \ \ \ 1307, 1365, 1542, 1425, 1475, 1276, 1289, 1671, 1420,
        1250, 1202, 1407,

        \ \ \ \ \ \ \ \ 1546, 1489, 1724, 1344, 1197, 1319, 1280, 1260, 1605,
        1583, 1503, 1303,

        \ \ \ \ \ \ \ \ 1656, 1371, 1107, 1398, 1497, 1583, 1586, 1423,
        \ 1524, 911, 1202, 1012 \ \ \ \ \ \ \ \ \ ))

        \;
      <|unfolded-io>
        Ex16.8.1 \<less\>- data.frame(

        + Trial=as.factor(c(rep("Clayton", 36),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Clinton", 36),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Plymouth", 36))),

        + Variety=as.factor(rep(

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ c(rep("Tracy", 3),
        rep("Centennial", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-137", 3),
        rep("N72-3058", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-3148", 3),
        rep("R73-81", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("D74-7741", 3),
        rep("N73-693", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-877", 3),
        rep("N73-882", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-1102", 3),
        rep("R75-12", 3)),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 3)),

        + Rep=as.factor(rep(c(1, 2, 3),36)),

        + Yield=c(1178, 1089, 960, 1187, 1180, 1235, 1451, 1177, 1723, 1318,
        1012, 99

        \<less\>1187, 1180, 1235, 1451, 1177, 1723, 1318, 1012, 990,\ 

        + \ \ \ \ \ \ \ \ 1345, 1335, 1303, 1175, 1064, 1158, 1111, 1111,
        1099, 1388, 1214, 1

        \<less\> 1175, 1064, 1158, 1111, 1111, 1099, 1388, 1214, 1222,

        + \ \ \ \ \ \ \ \ 1254, 1249, 1135, 1179, 1247, 1096, 1345, 1265,
        1178, 1136, 1161, 1

        \<less\> 1179, 1247, 1096, 1345, 1265, 1178, 1136, 1161, 1004,

        + \ \ \ \ \ \ \ \ 1583, 1841, 1464, 1713, 1684, 1378, 1369, 1608,
        1647, 1547, 1647, 1

        \<less\> 1713, 1684, 1378, 1369, 1608, 1647, 1547, 1647, 1603,

        + \ \ \ \ \ \ \ \ 1622, 1801, 1929, 1800, 1787, 1520, 1820, 1521,
        1851, 1464, 1607, 1

        \<less\> 1800, 1787, 1520, 1820, 1521, 1851, 1464, 1607, 1642,

        + \ \ \ \ \ \ \ \ 1775, 1513, 1570, 1673, 1507, 1390, 1894, 1547,
        1751, 1422, 1393, 1

        \<less\> 1673, 1507, 1390, 1894, 1547, 1751, 1422, 1393, 1342,

        + \ \ \ \ \ \ \ \ 1307, 1365, 1542, 1425, 1475, 1276, 1289, 1671,
        1420, 1250, 1202, 1

        \<less\> 1425, 1475, 1276, 1289, 1671, 1420, 1250, 1202, 1407,

        + \ \ \ \ \ \ \ \ 1546, 1489, 1724, 1344, 1197, 1319, 1280, 1260,
        1605, 1583, 1503, 1

        \<less\> 1344, 1197, 1319, 1280, 1260, 1605, 1583, 1503, 1303,

        + \ \ \ \ \ \ \ \ 1656, 1371, 1107, 1398, 1497, 1583, 1586, 1423,
        \ 1524, 911, 1202, 1

        \<less\> 1398, 1497, 1583, 1586, 1423, \ 1524, 911, 1202, 1012
        \ \ \ \ \ \ \ \ \ ))

        \<gtr\>\ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.treatments \<less\>- length(levels(Ex16.8.1$Variety))
      <|unfolded-io>
        Ex16.8.1.treatments \<less\>- length(levels(Ex16.8.1$Variety))
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Data Entry (Example 3)>

    Example 3 comes from ... . It's a large data set, so it's simpler to load
    from a file.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        setwd("~/Work/git/ASA_CSSA_SSSA/literate")

        rcbd.dat \<less\>- read.csv("sample RCBD data.csv",header=TRUE)
      <|unfolded-io>
        setwd("~/Work/git/ASA_CSSA_SSSA/literate")

        \<gtr\> rcbd.dat \<less\>- read.csv("sample RCBD
        data.csv",header=TRUE)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        head(rcbd.dat)
      <|unfolded-io>
        head(rcbd.dat)

        \ \ Site Country \ \ \ \ Loca Plot Repe BLK Entry \ YLD AD SD \ PH
        \ EH rEPH rEPP nP

        1 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 1 \ \ \ 1 \ \ 1 \ \ \ 21 7.00 54 55
        280 150 0.54 \ 0.9 58

        2 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 2 \ \ \ 1 \ \ 1 \ \ \ 22 8.39 51 52
        270 140 0.52 \ \ \ 1 58

        3 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 3 \ \ \ 1 \ \ 1 \ \ \ 32 6.85 52 53
        265 140 0.53 \ 0.9 54

        4 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 4 \ \ \ 1 \ \ 1 \ \ \ 11 8.09 53 54
        275 140 0.51 \ \ \ 1 53

        5 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 5 \ \ \ 1 \ \ 2 \ \ \ \ 4 6.86 51
        52 260 125 0.48 \ 0.9 58

        6 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 6 \ \ \ 1 \ \ 2 \ \ \ 29 6.45 51 52
        275 130 0.47 \ 0.9 57
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Diagnostics>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        par(mfrow = c(2, 2))\ 

        plot(Table5.7.lm)

        par(mfrow = c(1,1));v()
      <|unfolded-io>
        par(mfrow = c(2, 2))\ 

        \<gtr\> plot(Table5.7.lm)
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Model Building>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.red.lm \<less\>- update(Table5.7.lm, . ~ . - trt)
      <|unfolded-io>
        Table5.7.red.lm \<less\>- update(Table5.7.lm, . ~ . - trt)
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Summary Statistics>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Table5.7.lm)
      <|unfolded-io>
        summary(Table5.7.lm)

        \;

        Call:

        lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Residuals:

        \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

        -1.57367 -0.79233 \ 0.02958 \ 0.76387 \ 1.56967\ 

        \;

        Coefficients:

        \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ \ \ 

        trt1 \ \ 2.4960 \ \ \ \ 1.0255 \ \ 2.434 0.030112 * \ 

        trt2 \ \ 3.4855 \ \ \ \ 0.7252 \ \ 4.807 0.000343 ***

        trt3 \ \ 3.8930 \ \ \ \ 0.7252 \ \ 5.368 0.000128 ***

        trt4 \ \ 3.4530 \ \ \ \ 0.7252 \ \ 4.762 0.000372 ***

        trt5 \ \ 4.1480 \ \ \ \ 0.7252 \ \ 5.720 7.05e-05 ***

        trt6 \ \ 5.6305 \ \ \ \ 0.7252 \ \ 7.764 3.10e-06 ***

        rep2 \ \ 2.6100 \ \ \ \ 0.7252 \ \ 3.599 0.003237 **\ 

        rep3 \ \ 1.3807 \ \ \ \ 0.7099 \ \ 1.945 0.073742 . \ 

        rep4 \ \ 1.6873 \ \ \ \ 0.7099 \ \ 2.377 0.033502 * \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \;

        Residual standard error: 1.147 on 13 degrees of freedom

        Multiple R-squared: \ 0.9754, \ \ \ Adjusted R-squared: \ 0.9583\ 

        F-statistic: 57.21 on 9 and 13 DF, \ p-value: 5.409e-09

        \;
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Summary Statistics (AOV)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(Table5.7.lm)

        anova(Table5.7.red.lm,Table5.7.lm)
      <|unfolded-io>
        anova(Table5.7.lm)

        Analysis of Variance Table

        \;

        Response: obs

        \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ Pr(\<gtr\>F) \ \ \ 

        trt \ \ \ \ \ \ \ 6 659.37 109.895 83.5934 1.26e-09 ***

        rep \ \ \ \ \ \ \ 3 \ 17.57 \ \ 5.858 \ 4.4561 \ 0.02316 * \ 

        Residuals 13 \ 17.09 \ \ 1.315 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \<gtr\> anova(Table5.7.red.lm,Table5.7.lm)

        Analysis of Variance Table

        \;

        Model 1: obs ~ rep - 1

        Model 2: obs ~ 0 + trt + rep

        \ \ Res.Df \ \ \ RSS Df Sum of Sq \ \ \ \ \ F \ Pr(\<gtr\>F) \ 

        1 \ \ \ \ 18 34.222 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        2 \ \ \ \ 13 17.090 \ 5 \ \ \ 17.132 2.6063 0.07619 .

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Summary Statistics (Covariance)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        vcov(Table5.7.lm)
      <|unfolded-io>
        vcov(Table5.7.lm)

        \ \ \ \ \ \ \ \ \ \ \ trt1 \ \ \ \ \ \ trt2 \ \ \ \ \ \ trt3
        \ \ \ \ \ \ trt4 \ \ \ \ \ \ trt5 \ \ \ \ \ \ trt6

        trt1 \ 1.0517130 \ 0.2629283 \ 0.2629283 \ 0.2629283 \ 0.2629283
        \ 0.2629283

        trt2 \ 0.2629283 \ 0.5258565 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt3 \ 0.2629283 \ 0.1971962 \ 0.5258565 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt4 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.5258565 \ 0.1971962
        \ 0.1971962

        trt5 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.5258565
        \ 0.1971962

        trt6 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.5258565

        rep2 -0.2629283 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep3 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep4 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        \ \ \ \ \ \ \ \ \ \ \ rep2 \ \ \ \ \ \ rep3 \ \ \ \ \ \ rep4

        trt1 -0.2629283 -0.3943924 -0.3943924

        trt2 -0.2629283 -0.2629283 -0.2629283

        trt3 -0.2629283 -0.2629283 -0.2629283

        trt4 -0.2629283 -0.2629283 -0.2629283

        trt5 -0.2629283 -0.2629283 -0.2629283

        trt6 -0.2629283 -0.2629283 -0.2629283

        rep2 \ 0.5258565 \ 0.2629283 \ 0.2629283

        rep3 \ 0.2629283 \ 0.5039458 \ 0.2848389

        rep4 \ 0.2629283 \ 0.2848389 \ 0.5039458
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Hypothesis Testing>

    The multcomp package provides an interface for multiple tests and allows
    for user specified contrasts. This package assumes both coef and vcov are
    available for a given model.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(multcomp)

        summary(glht(Table5.7.lm,linfct=mcp(trt="Dunnett")))
      <|unfolded-io>
        library(multcomp)

        Loading required package: mvtnorm

        Loading required package: survival

        Loading required package: TH.data

        Loading required package: MASS

        \;

        Attaching package: 'TH.data'

        \;

        The following object is masked from 'package:MASS':

        \;

        \ \ \ \ geyser

        \;

        \<gtr\> summary(glht(Table5.7.lm,linfct=mcp(trt="Dunnett")))

        \;

        \ \ \ \ \ \ \ \ \ Simultaneous Tests for General Linear Hypotheses

        \;

        Multiple Comparisons of Means: Dunnett Contrasts

        \;

        \;

        Fit: lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Linear Hypotheses:

        \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ 

        2 - 1 == 0 \ \ 0.9895 \ \ \ \ 1.0255 \ \ 0.965 \ \ 0.7220 \ 

        3 - 1 == 0 \ \ 1.3970 \ \ \ \ 1.0255 \ \ 1.362 \ \ 0.4644 \ 

        4 - 1 == 0 \ \ 0.9570 \ \ \ \ 1.0255 \ \ 0.933 \ \ 0.7430 \ 

        5 - 1 == 0 \ \ 1.6520 \ \ \ \ 1.0255 \ \ 1.611 \ \ 0.3320 \ 

        6 - 1 == 0 \ \ 3.1345 \ \ \ \ 1.0255 \ \ 3.056 \ \ 0.0297 *

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        (Adjusted p values reported -- single-step method)

        \;
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        cld(glht(Table5.7.lm,linfct=mcp(trt="Tukey")),decreasing=TRUE)
      <|unfolded-io>
        cld(glht(Table5.7.lm,linfct=mcp(trt="Tukey")),decreasing=TRUE)

        \ \ 1 \ \ 2 \ \ 3 \ \ 4 \ \ 5 \ \ 6\ 

        "a" "a" "a" "a" "a" "a"\ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(glht(Table5.7.lm,linfct=mcp(trt="Tukey"))
      <|unfolded-io>
        summary(glht(Table5.7.lm,linfct=mcp(trt="Tukey"))
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|+ >
      <|unfolded-io>
        )
      <|unfolded-io>
        )

        \;

        \ \ \ \ \ \ \ \ \ Simultaneous Tests for General Linear Hypotheses

        \;

        Multiple Comparisons of Means: Tukey Contrasts

        \;

        \;

        Fit: lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Linear Hypotheses:

        \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ 

        2 - 1 == 0 \ \ 0.9895 \ \ \ \ 1.0255 \ \ 0.965 \ \ 0.9201 \ 

        3 - 1 == 0 \ \ 1.3970 \ \ \ \ 1.0255 \ \ 1.362 \ \ 0.7448 \ 

        4 - 1 == 0 \ \ 0.9570 \ \ \ \ 1.0255 \ \ 0.933 \ \ 0.9297 \ 

        5 - 1 == 0 \ \ 1.6520 \ \ \ \ 1.0255 \ \ 1.611 \ \ 0.6029 \ 

        6 - 1 == 0 \ \ 3.1345 \ \ \ \ 1.0255 \ \ 3.056 \ \ 0.0772 .

        3 - 2 == 0 \ \ 0.4075 \ \ \ \ 0.8107 \ \ 0.503 \ \ 0.9951 \ 

        4 - 2 == 0 \ -0.0325 \ \ \ \ 0.8107 \ -0.040 \ \ 1.0000 \ 

        5 - 2 == 0 \ \ 0.6625 \ \ \ \ 0.8107 \ \ 0.817 \ \ 0.9585 \ 

        6 - 2 == 0 \ \ 2.1450 \ \ \ \ 0.8107 \ \ 2.646 \ \ 0.1521 \ 

        4 - 3 == 0 \ -0.4400 \ \ \ \ 0.8107 \ -0.543 \ \ 0.9930 \ 

        5 - 3 == 0 \ \ 0.2550 \ \ \ \ 0.8107 \ \ 0.315 \ \ 0.9995 \ 

        6 - 3 == 0 \ \ 1.7375 \ \ \ \ 0.8107 \ \ 2.143 \ \ 0.3222 \ 

        5 - 4 == 0 \ \ 0.6950 \ \ \ \ 0.8107 \ \ 0.857 \ \ 0.9496 \ 

        6 - 4 == 0 \ \ 2.1775 \ \ \ \ 0.8107 \ \ 2.686 \ \ 0.1426 \ 

        6 - 5 == 0 \ \ 1.4825 \ \ \ \ 0.8107 \ \ 1.829 \ \ 0.4790 \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        (Adjusted p values reported -- single-step method)

        \;
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Presentation>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(lsmeans)

        lsmeans(Table5.7.lm,cld ~ trt)
      <|unfolded-io>
        library(lsmeans)

        Loading required package: estimability

        \<gtr\> lsmeans(Table5.7.lm,cld ~ trt)

        \ trt lsmean \ \ \ \ \ \ \ SE df lower.CL upper.CL .group

        \ 1 \ \ 3.9155 0.8503251 13 2.078484 5.752516 \ 1 \ \ \ 

        \ 4 \ \ 4.8725 0.5732890 13 3.633984 6.111016 \ 1 \ \ \ 

        \ 2 \ \ 4.9050 0.5732890 13 3.666484 6.143516 \ 1 \ \ \ 

        \ 3 \ \ 5.3125 0.5732890 13 4.073984 6.551016 \ 1 \ \ \ 

        \ 5 \ \ 5.5675 0.5732890 13 4.328984 6.806016 \ 1 \ \ \ 

        \ 6 \ \ 7.0500 0.5732890 13 5.811484 8.288516 \ 1 \ \ \ 

        \;

        Results are averaged over the levels of: rep\ 

        Confidence level used: 0.95\ 

        P value adjustment: tukey method for comparing a family of 6
        estimates\ 

        significance level used: alpha = 0.05\ 
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Presentation (Graphic)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(ggplot2)

        cbPalette \<less\>- c("#999999", "#E69F00", "#56B4E9", "#009E73",
        "#0072B2", "#D55E00",\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#F0E442", "#CC79A7", "#734f80",
        "#2b5a74", "#004f39", "#787221",\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#003959", "#6aaf00", "#663cd3",
        "#000000")
      <|unfolded-io>
        library(ggplot2)

        \<gtr\> cbPalette \<less\>- c("#999999", "#E69F00", "#56B4E9",
        "#009E73", "#0072B2", "#D55

        \<less\> "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00",\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#F0E442", "#CC79A7", "#734f80",
        "#2b5a74", "#004f39", "#787

        \<less\> "#CC79A7", "#734f80", "#2b5a74", "#004f39", "#787221",\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#003959", "#6aaf00", "#663cd3",
        "#000000")
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        make.plot.table \<less\>- function(model,form=NULL,effect=NULL) {

        \ \ \ if(is.null(effect)) {

        \ \ \ \ \ \ effect \<less\>- "trt"

        \ \ \ }

        \ \ \ if(is.null(form)) {

        \ \ \ \ \ \ form \<less\>- formula(paste("cld ~ ",effect))

        \ \ \ }

        \ \ \ model.tbl \<less\>- lsmeans(model,form)

        \ \ \ mcp.list \<less\>- list(effect="Tukey")

        \ \ \ names(mcp.list) \<less\>- effect

        \ \ \ attr(mcp.list, "interaction_average") \<less\>- TRUE

        \ \ \ attr(mcp.list, "covariate_average") \<less\>- TRUE

        \ \ \ class(mcp.list) \<less\>- "mcp"

        \ \ \ letters \<less\>- cld(glht(model,linfct=mcp.list,interaction_average
        = TRUE,\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ covariate_average
        = TRUE),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ decreasing=TRUE)$mcletters$Letters

        \ \ \ model.tbl$letters \<less\>- letters[model.tbl[,effect]]

        \ \ \ names(model.tbl) \<less\>- c("Treatment","Mean","Error","df","Lower","Upper","Group","Letters")

        \ \ \ return(model.tbl)

        }
      <|unfolded-io>
        make.plot.table \<less\>- function(model,form=NULL,effect=NULL) {

        + \ \ \ if(is.null(effect)) {

        + \ \ \ \ \ \ effect \<less\>- "trt"

        + \ \ \ }

        + \ \ \ if(is.null(form)) {

        + \ \ \ \ \ \ form \<less\>- formula(paste("cld ~ ",effect))

        + \ \ \ }

        + \ \ \ model.tbl \<less\>- lsmeans(model,form)

        + \ \ \ mcp.list \<less\>- list(effect="Tukey")

        + \ \ \ names(mcp.list) \<less\>- effect

        + \ \ \ attr(mcp.list, "interaction_average") \<less\>- TRUE

        + \ \ \ attr(mcp.list, "covariate_average") \<less\>- TRUE

        + \ \ \ class(mcp.list) \<less\>- "mcp"

        + \ \ \ letters \<less\>- cld(glht(model,linfct=mcp.list,interaction_average
        = TRUE,\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ covariate_average
        = TRUE),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ decreasing=TRUE)$mcletters$Letters

        + \ \ \ model.tbl$letters \<less\>- letters[model.tbl[,effect]]

        + \ \ \ names(model.tbl) \<less\>-
        c("Treatment","Mean","Error","df","Lower","Upper","G

        \<less\>"Treatment","Mean","Error","df","Lower","Upper","Group","Letters")

        + \ \ \ return(model.tbl)

        + }
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        plot.lsmeans.tbl \<less\>- function(model.tbl,formula=NULL,title="lm")
        {

        \ \ \ dodge \<less\>- position_dodge(width = 0.9)

        \ \ \ upper.lim \<less\>- max(model.tbl$Upper)

        \ \ \ upper.lim \<less\>- \ upper.lim + 0.1*upper.lim\ 

        \ \ \ limits \<less\>- aes(ymax = model.tbl$Upper, ymin =
        model.tbl$Lower)

        \ \ \ return(ggplot(data = model.tbl, aes(x = Treatment, y = Mean,
        fill = Treatment)) +\ 

        \ \ \ \ \ geom_bar(stat = "identity", position = dodge) +

        \ \ \ \ \ coord_cartesian(ylim = c(min(model.tbl$Lower),upper.lim)) +

        \ \ \ \ \ geom_errorbar(limits, position = dodge, width = 0.25) +

        \ \ \ \ \ theme(legend.position = "none") + ggtitle(title) +\ 

        \ \ \ \ \ scale_fill_manual(values=cbPalette) +

        \ \ \ \ \ geom_text(aes(x=model.tbl$Treatment,y=upper.lim,label=Letters))

        \ \ \ )

        }

        plot.lsmeans \<less\>- function(model,form=NULL,effect=NULL,title="lm")
        {

        \ \ \ return(

        \ \ \ \ \ \ plot.lsmeans.tbl(

        \ \ \ \ \ \ \ \ \ make.plot.table(model,form=form,effect=effect),formula=formula,title=title))

        }
      <|unfolded-io>
        plot.lsmeans.tbl \<less\>- function(model.tbl,formula=NULL,title="lm")
        {

        + \ \ \ dodge \<less\>- position_dodge(width = 0.9)

        + \ \ \ upper.lim \<less\>- max(model.tbl$Upper)

        + \ \ \ upper.lim \<less\>- \ upper.lim + 0.1*upper.lim\ 

        + \ \ \ limits \<less\>- aes(ymax = model.tbl$Upper, ymin =
        model.tbl$Lower)

        + \ \ \ return(ggplot(data = model.tbl, aes(x = Treatment, y = Mean,
        fill = Trea

        \<less\>odel.tbl, aes(x = Treatment, y = Mean, fill = Treatment)) +\ 

        + \ \ \ \ \ geom_bar(stat = "identity", position = dodge) +

        + \ \ \ \ \ coord_cartesian(ylim = c(min(model.tbl$Lower),upper.lim))
        +

        + \ \ \ \ \ geom_errorbar(limits, position = dodge, width = 0.25) +

        + \ \ \ \ \ theme(legend.position = "none") + ggtitle(title) +\ 

        + \ \ \ \ \ scale_fill_manual(values=cbPalette) +

        + \ \ \ \ \ geom_text(aes(x=model.tbl$Treatment,y=upper.lim,label=Letters))

        + \ \ \ )

        + }

        \<gtr\> plot.lsmeans \<less\>- function(model,form=NULL,effect=NULL,title="lm")
        {

        + \ \ \ return(

        + \ \ \ \ \ \ plot.lsmeans.tbl(

        + \ \ \ \ \ \ \ \ \ make.plot.table(model,form=form,effect=effect),formula=formula,tit

        \<less\>model,form=form,effect=effect),formula=formula,title=title))

        + }
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Presentation (Graphic)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.lm.tbl \<less\>- make.plot.table(Table5.7.lm)

        Table5.7.lm.plot \<less\>- plot.lsmeans.tbl(Table5.7.lm.tbl)

        Table5.7.lm.plot;v()
      <|unfolded-io>
        Table5.7.lm.tbl \<less\>- make.plot.table(Table5.7.lm)

        \<gtr\> Table5.7.lm.plot \<less\>- plot.lsmeans.tbl(Table5.7.lm.tbl)

        \<gtr\> Table5.7.lm.plot;v()

        <image|<tuple|<#252150532D41646F62652D332E3020455053462D332E300A2525446F63756D656E744E65656465645265736F75726365733A20666F6E742048656C7665746963610A25252B20666F6E742048656C7665746963612D426F6C640A25252B20666F6E742048656C7665746963612D4F626C697175650A25252B20666F6E742048656C7665746963612D426F6C644F626C697175650A25252B20666F6E742053796D626F6C0A25255469746C653A2052204772617068696373204F75747075740A252543726561746F723A205220536F6674776172650A252550616765733A20286174656E64290A2525426F756E64696E67426F783A2030203020323838203238380A2525456E64436F6D6D656E74730A2525426567696E50726F6C6F670A2F627020207B2067732073524742206773207D206465660A2520626567696E202E70732E70726F6C6F670A2F677320207B206773617665207D2062696E64206465660A2F677220207B2067726573746F7265207D2062696E64206465660A2F657020207B2073686F7770616765206772206772207D2062696E64206465660A2F6D2020207B206D6F7665746F207D2062696E64206465660A2F6C20207B20726C696E65746F207D2062696E64206465660A2F6E7020207B206E657770617468207D2062696E64206465660A2F637020207B20636C6F736570617468207D2062696E64206465660A2F662020207B2066696C6C207D2062696E64206465660A2F6F2020207B207374726F6B65207D2062696E64206465660A2F632020207B206E65777061746820302033363020617263207D2062696E64206465660A2F722020207B2034203220726F6C6C206D6F7665746F203120636F70792033202D3120726F6C6C20657863682030206578636820726C696E65746F203020726C696E65746F202D31206D756C2030206578636820726C696E65746F20636C6F736570617468207D2062696E64206465660A2F703120207B207374726F6B65207D2062696E64206465660A2F703220207B2067736176652062672066696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703320207B2067736176652062672066696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F703620207B20677361766520626720656F66696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703720207B20677361766520626720656F66696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F742020207B2035202D3220726F6C6C206D6F7665746F20677361766520726F746174650A202020202020203120696E64657820737472696E67776964746820706F700A202020202020206D756C206E6567203020726D6F7665746F2073686F772067726573746F7265207D2062696E64206465660A2F746120207B2034202D3220726F6C6C206D6F7665746F20677361766520726F746174652073686F77207D2062696E64206465660A2F746220207B2032202D3120726F6C6C203020726D6F7665746F2073686F77207D2062696E64206465660A2F636C20207B2067726573746F7265206773617665206E657770617468203320696E646578203320696E646578206D6F7665746F203120696E6465780A2020202020202034202D3120726F6C6C206C696E65746F202065786368203120696E646578206C696E65746F206C696E65746F0A20202020202020636C6F73657061746820636C6970206E657770617468207D2062696E64206465660A2F726762207B20736574726762636F6C6F72207D2062696E64206465660A2F732020207B207363616C65666F6E7420736574666F6E74207D2062696E64206465660A2520656E642020202E70732E70726F6C6F670A2F73524742207B205B202F43494542617365644142430A202020202020202020203C3C202F4465636F64654C4D4E0A2020202020202020202020202020205B207B2064757020302E3033393238206C650A2020202020202020202020202020202020202020202020207B31322E3932333231206469767D0A2020202020202020202020202020202020202020202020207B302E3035352061646420312E3035352064697620322E3420657870207D0A2020202020202020202020202020202020202020206966656C73650A20202020202020202020202020202020207D2062696E6420647570206475700A2020202020202020202020202020205D0A202020202020202020202020202F4D61747269784C4D4E205B302E34313234353720302E32313236373320302E3031393333340A20202020202020202020202020202020202020202020202020302E33353735373620302E37313531353220302E3131393139320A20202020202020202020202020202020202020202020202020302E31383034333720302E30373231373520302E3935303330315D0A202020202020202020202020202F5768697465506F696E74205B302E3935303520312E3020312E303839305D0A20202020202020202020203E3E0A2020202020202020205D20736574636F6C6F727370616365207D2062696E64206465660A2F73726762207B20736574636F6C6F72207D2062696E64206465660A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963610A2F48656C7665746963612066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7431206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C640A2F48656C7665746963612D426F6C642066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7432206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D4F626C697175650A2F48656C7665746963612D4F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7433206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C644F626C697175650A2F48656C7665746963612D426F6C644F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7434206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742053796D626F6C0A2F53796D626F6C2066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A202063757272656E74646963740A2020656E640A2F466F6E7435206578636820646566696E65666F6E7420706F700A2525456E6450726F6C6F670A2525506167653A203120310A62700A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F6267207B2031203120312073726762207D206465660A312031203120737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A31207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A302E303020302E3030203238382E3030203238382E303020722070330A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A32392E38392033312E3335203238322E3532203236362E363120636C0A2F6267207B20302E3932313620302E3932313620302E393231362073726762207D206465660A32392E38392033312E3335203235322E3633203233352E323620722070320A312031203120737267620A302E3533207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32392E38392037302E3034206D0A3235322E36332030206C0A6F0A6E700A32392E3839203133302E3831206D0A3235322E36332030206C0A6F0A6E700A32392E3839203139312E3538206D0A3235322E36332030206C0A6F0A6E700A32392E3839203235322E3335206D0A3235322E36332030206C0A6F0A312E3037207365746C696E6577696474680A5B5D203020736574646173680A6E700A32392E38392033392E3636206D0A3235322E36332030206C0A6F0A6E700A32392E3839203130302E3433206D0A3235322E36332030206C0A6F0A6E700A32392E3839203136312E3230206D0A3235322E36332030206C0A6F0A6E700A32392E3839203232312E3937206D0A3235322E36332030206C0A6F0A6E700A35342E33342033312E3335206D0A30203233352E3236206C0A6F0A6E700A39352E30382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3133352E38332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3137362E35382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3231372E33332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3235382E30372033312E3335206D0A30203233352E3236206C0A6F0A2F6267207B20302E3630303020302E3630303020302E363030302073726762207D206465660A33362E3030202D32312E31312033362E3637203131382E393720722070320A2F6267207B20302E3930323020302E3632333520302073726762207D206465660A37362E3735202D32312E31312033362E3637203134392E303420722070320A2F6267207B20302E3333373320302E3730353920302E393133372073726762207D206465660A3131372E3439202D32312E31312033362E3637203136312E343220722070320A2F6267207B203020302E3631393620302E343531302073726762207D206465660A3135382E3234202D32312E31312033362E3637203134382E303520722070320A2F6267207B203020302E3434373120302E363938302073726762207D206465660A3139382E3939202D32312E31312033362E3637203136392E313720722070320A2F6267207B20302E3833353320302E3336383620302073726762207D206465660A3233392E3734202D32312E31312033362E3637203231342E323120722070320A302030203020737267620A312E3030207365746D697465726C696D69740A6E700A34392E3234203135332E3638206D0A31302E31392030206C0A6F0A6E700A35342E3334203135332E3638206D0A30202D3131312E3634206C0A6F0A6E700A34392E32342034322E3034206D0A31302E31392030206C0A6F0A6E700A38392E3939203136352E3536206D0A31302E31392030206C0A6F0A6E700A39352E3038203136352E3536206D0A30202D37352E3237206C0A6F0A6E700A38392E39392039302E3239206D0A31302E31392030206C0A6F0A6E700A3133302E3734203137372E3934206D0A31302E31382030206C0A6F0A6E700A3133352E3833203137372E3934206D0A30202D37352E3237206C0A6F0A6E700A3133302E3734203130322E3637206D0A31302E31382030206C0A6F0A6E700A3137312E3438203136342E3537206D0A31302E31392030206C0A6F0A6E700A3137362E3538203136342E3537206D0A30202D37352E3237206C0A6F0A6E700A3137312E34382038392E3330206D0A31302E31392030206C0A6F0A6E700A3231322E3233203138352E3639206D0A31302E31392030206C0A6F0A6E700A3231372E3333203138352E3639206D0A30202D37352E3237206C0A6F0A6E700A3231322E3233203131302E3432206D0A31302E31392030206C0A6F0A6E700A3235322E3938203233302E3733206D0A31302E31392030206C0A6F0A6E700A3235382E3037203233302E3733206D0A30202D37352E3236206C0A6F0A6E700A3235322E3938203135352E3437206D0A31302E31392030206C0A6F0A2F466F6E74312066696E64666F6E7420313120730A35342E3334203235312E393720286129202E35203020740A3137362E3538203235312E393720286129202E35203020740A39352E3038203235312E393720286129202E35203020740A3133352E3833203235312E393720286129202E35203020740A3231372E3333203235312E393720286129202E35203020740A3235382E3037203235312E393720286129202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A32342E39362033362E3432202832292031203020740A32342E39362039372E3139202834292031203020740A32342E3936203135372E3936202836292031203020740A32342E3936203231382E3734202838292031203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32372E31352033392E3636206D0A322E37342030206C0A6F0A6E700A32372E3135203130302E3433206D0A322E37342030206C0A6F0A6E700A32372E3135203136312E3230206D0A322E37342030206C0A6F0A6E700A32372E3135203232312E3937206D0A322E37342030206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A35342E33342032382E3631206D0A3020322E3734206C0A6F0A6E700A39352E30382032382E3631206D0A3020322E3734206C0A6F0A6E700A3133352E38332032382E3631206D0A3020322E3734206C0A6F0A6E700A3137362E35382032382E3631206D0A3020322E3734206C0A6F0A6E700A3231372E33332032382E3631206D0A3020322E3734206C0A6F0A6E700A3235382E30372032382E3631206D0A3020322E3734206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A35342E33342031392E393520283129202E35203020740A39352E30382031392E393520283229202E35203020740A3133352E38332031392E393520283329202E35203020740A3137362E35382031392E393520283429202E35203020740A3231372E33332031392E393520283529202E35203020740A3235382E30372031392E393520283629202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A3133312E313420372E36372028542920302074610A2D312E3332302028726561746D656E74292074622067720A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A31352E3537203134382E393820284D65616E29202E3520393020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313320730A302030203020737267620A3135362E3230203237332E313920286C6D29202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A65700A2525547261696C65720A252550616765733A20310A2525454F460A0A0A20>|ps>|0.8par|||>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Classes and Generic Functions>

    Each of the functions invoked inthe preceding examples are simply the
    <with|font-series|bold|generic> names of a larger family of related
    functions. Every R object has an associated type or class, and when a
    generic function is invoked with an R object as a parameter, the R
    interpreter will dispatch the appropriate specific instance of a generic
    function.

    For example, the result of an lm evaluation is an instance of the lm
    class:

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        class(Table5.7.lm)

        mode(Table5.7.lm)
      <|unfolded-io>
        class(Table5.7.lm)

        [1] "lm"

        \<gtr\> mode(Table5.7.lm)

        [1] "list"
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary
      <|unfolded-io>
        summary

        function (object, ...)\ 

        UseMethod("summary")

        \<less\>bytecode: 0x7f7fea4e5110\<gtr\>

        \<less\>environment: namespace:base\<gtr\>
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary.lm
      <|unfolded-io>
        summary.lm

        function (object, correlation = FALSE, symbolic.cor = FALSE,\ 

        \ \ \ \ ...)\ 

        {

        \ \ \ \ z \<less\>- object

        \ \ \ \ p \<less\>- z$rank

        \ \ \ \ rdf \<less\>- z$df.residual

        \ \ \ \ if (p == 0) {

        \ \ \ \ \ \ \ \ r \<less\>- z$residuals

        \ \ \ \ \ \ \ \ n \<less\>- length(r)

        \ \ \ \ \ \ \ \ w \<less\>- z$weights

        \ \ \ \ \ \ \ \ if (is.null(w)) {

        \ \ \ \ \ \ \ \ \ \ \ \ rss \<less\>- sum(r^2)

        \ \ \ \ \ \ \ \ }

        \ \ \ \ \ \ \ \ else {

        \ \ \ \ \ \ \ \ \ \ \ \ rss \<less\>- sum(w * r^2)

        \ \ \ \ \ \ \ \ \ \ \ \ r \<less\>- sqrt(w) * r

        \ \ \ \ \ \ \ \ }

        \ \ \ \ \ \ \ \ resvar \<less\>- rss/rdf

        \ \ \ \ \ \ \ \ ans \<less\>- z[c("call", "terms", if
        (!is.null(z$weights)) "weights")]

        \ \ \ \ \ \ \ \ class(ans) \<less\>- "summary.lm"

        \ \ \ \ \ \ \ \ ans$aliased \<less\>- is.na(coef(object))

        \ \ \ \ \ \ \ \ ans$residuals \<less\>- r

        \ \ \ \ \ \ \ \ ans$df \<less\>- c(0L, n, length(ans$aliased))

        \ \ \ \ \ \ \ \ ans$coefficients \<less\>- matrix(NA, 0L, 4L)

        \ \ \ \ \ \ \ \ dimnames(ans$coefficients) \<less\>- list(NULL,
        c("Estimate",\ 

        \ \ \ \ \ \ \ \ \ \ \ \ "Std. Error", "t value", "Pr(\<gtr\>\|t\|)"))

        \ \ \ \ \ \ \ \ ans$sigma \<less\>- sqrt(resvar)

        \ \ \ \ \ \ \ \ ans$r.squared \<less\>- ans$adj.r.squared \<less\>- 0

        \ \ \ \ \ \ \ \ return(ans)

        \ \ \ \ }

        \ \ \ \ if (is.null(z$terms))\ 

        \ \ \ \ \ \ \ \ stop("invalid 'lm' object: \ no 'terms' component")

        \ \ \ \ if (!inherits(object, "lm"))\ 

        \ \ \ \ \ \ \ \ warning("calling summary.lm(\<fake-lm-object\>) ...")

        \ \ \ \ Qr \<less\>- qr.lm(object)

        \ \ \ \ n \<less\>- NROW(Qr$qr)

        \ \ \ \ if (is.na(z$df.residual) \|\| n - p != z$df.residual)\ 

        \ \ \ \ \ \ \ \ warning("residual degrees of freedom in object
        suggest this is not an \\"lm\\" fit")

        \ \ \ \ r \<less\>- z$residuals

        \ \ \ \ f \<less\>- z$fitted.values

        \ \ \ \ w \<less\>- z$weights

        \ \ \ \ if (is.null(w)) {

        \ \ \ \ \ \ \ \ mss \<less\>- if (attr(z$terms, "intercept"))\ 

        \ \ \ \ \ \ \ \ \ \ \ \ sum((f - mean(f))^2)

        \ \ \ \ \ \ \ \ else sum(f^2)

        \ \ \ \ \ \ \ \ rss \<less\>- sum(r^2)

        \ \ \ \ }

        \ \ \ \ else {

        \ \ \ \ \ \ \ \ mss \<less\>- if (attr(z$terms, "intercept")) {

        \ \ \ \ \ \ \ \ \ \ \ \ m \<less\>- sum(w * f/sum(w))

        \ \ \ \ \ \ \ \ \ \ \ \ sum(w * (f - m)^2)

        \ \ \ \ \ \ \ \ }

        \ \ \ \ \ \ \ \ else sum(w * f^2)

        \ \ \ \ \ \ \ \ rss \<less\>- sum(w * r^2)

        \ \ \ \ \ \ \ \ r \<less\>- sqrt(w) * r

        \ \ \ \ }

        \ \ \ \ resvar \<less\>- rss/rdf

        \ \ \ \ if (is.finite(resvar) && resvar \<less\> (mean(f)^2 + var(f))
        *\ 

        \ \ \ \ \ \ \ \ 1e-30)\ 

        \ \ \ \ \ \ \ \ warning("essentially perfect fit: summary may be
        unreliable")

        \ \ \ \ p1 \<less\>- 1L:p

        \ \ \ \ R \<less\>- chol2inv(Qr$qr[p1, p1, drop = FALSE])

        \ \ \ \ se \<less\>- sqrt(diag(R) * resvar)

        \ \ \ \ est \<less\>- z$coefficients[Qr$pivot[p1]]

        \ \ \ \ tval \<less\>- est/se

        \ \ \ \ ans \<less\>- z[c("call", "terms", if (!is.null(z$weights))
        "weights")]

        \ \ \ \ ans$residuals \<less\>- r

        \ \ \ \ ans$coefficients \<less\>- cbind(est, se, tval, 2 *
        pt(abs(tval),\ 

        \ \ \ \ \ \ \ \ rdf, lower.tail = FALSE))

        \ \ \ \ dimnames(ans$coefficients) \<less\>-
        list(names(z$coefficients)[Qr$pivot[p1]],\ 

        \ \ \ \ \ \ \ \ c("Estimate", "Std. Error", "t value",
        "Pr(\<gtr\>\|t\|)"))

        \ \ \ \ ans$aliased \<less\>- is.na(coef(object))

        \ \ \ \ ans$sigma \<less\>- sqrt(resvar)

        \ \ \ \ ans$df \<less\>- c(p, rdf, NCOL(Qr$qr))

        \ \ \ \ if (p != attr(z$terms, "intercept")) {

        \ \ \ \ \ \ \ \ df.int \<less\>- if (attr(z$terms, "intercept"))\ 

        \ \ \ \ \ \ \ \ \ \ \ \ 1L

        \ \ \ \ \ \ \ \ else 0L

        \ \ \ \ \ \ \ \ ans$r.squared \<less\>- mss/(mss + rss)

        \ \ \ \ \ \ \ \ ans$adj.r.squared \<less\>- 1 - (1 - ans$r.squared) *
        ((n -\ 

        \ \ \ \ \ \ \ \ \ \ \ \ df.int)/rdf)

        \ \ \ \ \ \ \ \ ans$fstatistic \<less\>- c(value = (mss/(p -
        df.int))/resvar,\ 

        \ \ \ \ \ \ \ \ \ \ \ \ numdf = p - df.int, dendf = rdf)

        \ \ \ \ }

        \ \ \ \ else ans$r.squared \<less\>- ans$adj.r.squared \<less\>- 0

        \ \ \ \ ans$cov.unscaled \<less\>- R

        \ \ \ \ dimnames(ans$cov.unscaled) \<less\>-
        dimnames(ans$coefficients)[c(1,\ 

        \ \ \ \ \ \ \ \ 1)]

        \ \ \ \ if (correlation) {

        \ \ \ \ \ \ \ \ ans$correlation \<less\>- (R * resvar)/outer(se, se)

        \ \ \ \ \ \ \ \ dimnames(ans$correlation) \<less\>-
        dimnames(ans$cov.unscaled)

        \ \ \ \ \ \ \ \ ans$symbolic.cor \<less\>- symbolic.cor

        \ \ \ \ }

        \ \ \ \ if (!is.null(z$na.action))\ 

        \ \ \ \ \ \ \ \ ans$na.action \<less\>- z$na.action

        \ \ \ \ class(ans) \<less\>- "summary.lm"

        \ \ \ \ ans

        }

        \<less\>bytecode: 0x7f7fe9884200\<gtr\>

        \<less\>environment: namespace:stats\<gtr\>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    Note that summary.lm both overrides (by extending to the lm class) and
    overloads (by adding additional parameters) the generic summary function.

    When a workflow is based on generic functions, new packages can be easily
    inserted into the workflow when package authors provide
    appropriaextensions to generic functions.
  </hidden>|<\hidden>
    <tit|Generic Functions>

    Some generic functions have default implementations that work for any
    type of R object.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        print(anova(Table5.7.lm))
      <|unfolded-io>
        print(anova(Table5.7.lm))

        Analysis of Variance Table

        \;

        Response: obs

        \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ Pr(\<gtr\>F) \ \ \ 

        trt \ \ \ \ \ \ \ 6 659.37 109.895 83.5934 1.26e-09 ***

        rep \ \ \ \ \ \ \ 3 \ 17.57 \ \ 5.858 \ 4.4561 \ 0.02316 * \ 

        Residuals 13 \ 17.09 \ \ 1.315 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(anova(Table5.7.lm))
      <|unfolded-io>
        summary(anova(Table5.7.lm))

        \ \ \ \ \ \ \ Df \ \ \ \ \ \ \ \ \ \ \ \ Sum Sq
        \ \ \ \ \ \ \ \ \ Mean Sq \ \ \ \ \ \ \ \ \ \ F value \ \ \ \ \ 

        \ Min. \ \ : 3.000 \ \ Min. \ \ : 17.09 \ \ Min. \ \ : \ 1.315
        \ \ Min. \ \ : 4.456 \ 

        \ 1st Qu.: 4.500 \ \ 1st Qu.: 17.33 \ \ 1st Qu.: \ 3.586 \ \ 1st
        Qu.:24.240 \ 

        \ Median : 6.000 \ \ Median : 17.57 \ \ Median : \ 5.858 \ \ Median
        :44.025 \ 

        \ Mean \ \ : 7.333 \ \ Mean \ \ :231.35 \ \ Mean \ \ : 39.023
        \ \ Mean \ \ :44.025 \ 

        \ 3rd Qu.: 9.500 \ \ 3rd Qu.:338.47 \ \ 3rd Qu.: 57.877 \ \ 3rd
        Qu.:63.809 \ 

        \ Max. \ \ :13.000 \ \ Max. \ \ :659.37 \ \ Max. \ \ :109.895
        \ \ Max. \ \ :83.593 \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ NA's
        \ \ :1 \ \ \ \ \ \ 

        \ \ \ \ \ Pr(\<gtr\>F) \ \ \ \ \ \ \ 

        \ Min. \ \ :0.000000 \ 

        \ 1st Qu.:0.005791 \ 

        \ Median :0.011582 \ 

        \ Mean \ \ :0.011582 \ 

        \ 3rd Qu.:0.017372 \ 

        \ Max. \ \ :0.023163 \ 

        \ NA's \ \ :1 \ \ \ \ \ \ \ \ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        class(anova(Table5.7.lm))
      <|unfolded-io>
        class(anova(Table5.7.lm))

        [1] "anova" \ \ \ \ \ "data.frame"
      </unfolded-io>

      <\textput>
        Some generic functions do not.
      </textput>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        VarCorr(Table5.7.lm)
      <|unfolded-io>
        VarCorr(Table5.7.lm)

        Error: could not find function "VarCorr"
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        \ 
      <|unfolded-io>
        \ 
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Automation>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        automate.analysis \<less\>- function(model) {

        \ \ \ require(lsmeans)

        \ \ \ require(multcomp)

        \ \ \ require(ggplot2)

        \ \ \ print(paste("Analyzing model of class",class(model)))

        \ \ \ print(summary(model))

        \ \ \ print(anova(model))

        \ \ \ print("Variance/Covariance")

        \ \ \ print(vcov(model))

        \ \ \ print("Hypothesis Testing")

        \ \ \ print(cld(glht(model,linfct=mcp(trt="Tukey")),decreasing=TRUE))

        \ \ \ print(lsmeans(model,cld ~ trt))

        \ \ \ return(plot.lsmeans(model,title=class(model)))

        }
      <|unfolded-io>
        automate.analysis \<less\>- function(model) {

        + \ \ \ require(lsmeans)

        + \ \ \ require(multcomp)

        + \ \ \ require(ggplot2)

        + \ \ \ print(paste("Analyzing model of class",class(model)))

        + \ \ \ print(summary(model))

        + \ \ \ print(anova(model))

        + \ \ \ print("Variance/Covariance")

        + \ \ \ print(vcov(model))

        + \ \ \ print("Hypothesis Testing")

        + \ \ \ print(cld(glht(model,linfct=mcp(trt="Tukey")),decreasing=TRUE))

        + \ \ \ print(lsmeans(model,cld ~ trt))

        + \ \ \ return(plot.lsmeans(model,title=class(model)))

        + }
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        automate.analysis(Table5.7.lm);v()
      <|unfolded-io>
        automate.analysis(Table5.7.lm);v()

        [1] "Analyzing model of class lm"

        \;

        Call:

        lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Residuals:

        \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

        -1.57367 -0.79233 \ 0.02958 \ 0.76387 \ 1.56967\ 

        \;

        Coefficients:

        \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ \ \ 

        trt1 \ \ 2.4960 \ \ \ \ 1.0255 \ \ 2.434 0.030112 * \ 

        trt2 \ \ 3.4855 \ \ \ \ 0.7252 \ \ 4.807 0.000343 ***

        trt3 \ \ 3.8930 \ \ \ \ 0.7252 \ \ 5.368 0.000128 ***

        trt4 \ \ 3.4530 \ \ \ \ 0.7252 \ \ 4.762 0.000372 ***

        trt5 \ \ 4.1480 \ \ \ \ 0.7252 \ \ 5.720 7.05e-05 ***

        trt6 \ \ 5.6305 \ \ \ \ 0.7252 \ \ 7.764 3.10e-06 ***

        rep2 \ \ 2.6100 \ \ \ \ 0.7252 \ \ 3.599 0.003237 **\ 

        rep3 \ \ 1.3807 \ \ \ \ 0.7099 \ \ 1.945 0.073742 . \ 

        rep4 \ \ 1.6873 \ \ \ \ 0.7099 \ \ 2.377 0.033502 * \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \;

        Residual standard error: 1.147 on 13 degrees of freedom

        Multiple R-squared: \ 0.9754, \ \ \ Adjusted R-squared: \ 0.9583\ 

        F-statistic: 57.21 on 9 and 13 DF, \ p-value: 5.409e-09

        \;

        Analysis of Variance Table

        \;

        Response: obs

        \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ Pr(\<gtr\>F) \ \ \ 

        trt \ \ \ \ \ \ \ 6 659.37 109.895 83.5934 1.26e-09 ***

        rep \ \ \ \ \ \ \ 3 \ 17.57 \ \ 5.858 \ 4.4561 \ 0.02316 * \ 

        Residuals 13 \ 17.09 \ \ 1.315 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        [1] "Variance/Covariance"

        \ \ \ \ \ \ \ \ \ \ \ trt1 \ \ \ \ \ \ trt2 \ \ \ \ \ \ trt3
        \ \ \ \ \ \ trt4 \ \ \ \ \ \ trt5 \ \ \ \ \ \ trt6

        trt1 \ 1.0517130 \ 0.2629283 \ 0.2629283 \ 0.2629283 \ 0.2629283
        \ 0.2629283

        trt2 \ 0.2629283 \ 0.5258565 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt3 \ 0.2629283 \ 0.1971962 \ 0.5258565 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt4 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.5258565 \ 0.1971962
        \ 0.1971962

        trt5 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.5258565
        \ 0.1971962

        trt6 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.5258565

        rep2 -0.2629283 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep3 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep4 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        \ \ \ \ \ \ \ \ \ \ \ rep2 \ \ \ \ \ \ rep3 \ \ \ \ \ \ rep4

        trt1 -0.2629283 -0.3943924 -0.3943924

        trt2 -0.2629283 -0.2629283 -0.2629283

        trt3 -0.2629283 -0.2629283 -0.2629283

        trt4 -0.2629283 -0.2629283 -0.2629283

        trt5 -0.2629283 -0.2629283 -0.2629283

        trt6 -0.2629283 -0.2629283 -0.2629283

        rep2 \ 0.5258565 \ 0.2629283 \ 0.2629283

        rep3 \ 0.2629283 \ 0.5039458 \ 0.2848389

        rep4 \ 0.2629283 \ 0.2848389 \ 0.5039458

        [1] "Hypothesis Testing"

        \ \ 1 \ \ 2 \ \ 3 \ \ 4 \ \ 5 \ \ 6\ 

        "a" "a" "a" "a" "a" "a"\ 

        \ trt lsmean \ \ \ \ \ \ \ SE df lower.CL upper.CL .group

        \ 1 \ \ 3.9155 0.8503251 13 2.078484 5.752516 \ 1 \ \ \ 

        \ 4 \ \ 4.8725 0.5732890 13 3.633984 6.111016 \ 1 \ \ \ 

        \ 2 \ \ 4.9050 0.5732890 13 3.666484 6.143516 \ 1 \ \ \ 

        \ 3 \ \ 5.3125 0.5732890 13 4.073984 6.551016 \ 1 \ \ \ 

        \ 5 \ \ 5.5675 0.5732890 13 4.328984 6.806016 \ 1 \ \ \ 

        \ 6 \ \ 7.0500 0.5732890 13 5.811484 8.288516 \ 1 \ \ \ 

        \;

        Results are averaged over the levels of: rep\ 

        Confidence level used: 0.95\ 

        P value adjustment: tukey method for comparing a family of 6
        estimates\ 

        significance level used: alpha = 0.05\ 

        <image|<tuple|<#252150532D41646F62652D332E3020455053462D332E300A2525446F63756D656E744E65656465645265736F75726365733A20666F6E742048656C7665746963610A25252B20666F6E742048656C7665746963612D426F6C640A25252B20666F6E742048656C7665746963612D4F626C697175650A25252B20666F6E742048656C7665746963612D426F6C644F626C697175650A25252B20666F6E742053796D626F6C0A25255469746C653A2052204772617068696373204F75747075740A252543726561746F723A205220536F6674776172650A252550616765733A20286174656E64290A2525426F756E64696E67426F783A2030203020323838203238380A2525456E64436F6D6D656E74730A2525426567696E50726F6C6F670A2F627020207B2067732073524742206773207D206465660A2520626567696E202E70732E70726F6C6F670A2F677320207B206773617665207D2062696E64206465660A2F677220207B2067726573746F7265207D2062696E64206465660A2F657020207B2073686F7770616765206772206772207D2062696E64206465660A2F6D2020207B206D6F7665746F207D2062696E64206465660A2F6C20207B20726C696E65746F207D2062696E64206465660A2F6E7020207B206E657770617468207D2062696E64206465660A2F637020207B20636C6F736570617468207D2062696E64206465660A2F662020207B2066696C6C207D2062696E64206465660A2F6F2020207B207374726F6B65207D2062696E64206465660A2F632020207B206E65777061746820302033363020617263207D2062696E64206465660A2F722020207B2034203220726F6C6C206D6F7665746F203120636F70792033202D3120726F6C6C20657863682030206578636820726C696E65746F203020726C696E65746F202D31206D756C2030206578636820726C696E65746F20636C6F736570617468207D2062696E64206465660A2F703120207B207374726F6B65207D2062696E64206465660A2F703220207B2067736176652062672066696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703320207B2067736176652062672066696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F703620207B20677361766520626720656F66696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703720207B20677361766520626720656F66696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F742020207B2035202D3220726F6C6C206D6F7665746F20677361766520726F746174650A202020202020203120696E64657820737472696E67776964746820706F700A202020202020206D756C206E6567203020726D6F7665746F2073686F772067726573746F7265207D2062696E64206465660A2F746120207B2034202D3220726F6C6C206D6F7665746F20677361766520726F746174652073686F77207D2062696E64206465660A2F746220207B2032202D3120726F6C6C203020726D6F7665746F2073686F77207D2062696E64206465660A2F636C20207B2067726573746F7265206773617665206E657770617468203320696E646578203320696E646578206D6F7665746F203120696E6465780A2020202020202034202D3120726F6C6C206C696E65746F202065786368203120696E646578206C696E65746F206C696E65746F0A20202020202020636C6F73657061746820636C6970206E657770617468207D2062696E64206465660A2F726762207B20736574726762636F6C6F72207D2062696E64206465660A2F732020207B207363616C65666F6E7420736574666F6E74207D2062696E64206465660A2520656E642020202E70732E70726F6C6F670A2F73524742207B205B202F43494542617365644142430A0A202020202020202020203C3C202F4465636F64654C4D4E0A2020202020202020202020202020205B207B2064757020302E3033393238206C650A2020202020202020202020202020202020202020202020207B31322E3932333231206469767D0A2020202020202020202020202020202020202020202020207B302E3035352061646420312E3035352064697620322E3420657870207D0A2020202020202020202020202020202020202020206966656C73650A20202020202020202020202020202020207D2062696E6420647570206475700A2020202020202020202020202020205D0A202020202020202020202020202F4D61747269784C4D4E205B302E34313234353720302E32313236373320302E3031393333340A20202020202020202020202020202020202020202020202020302E33353735373620302E37313531353220302E3131393139320A20202020202020202020202020202020202020202020202020302E31383034333720302E30373231373520302E3935303330315D0A202020202020202020202020202F5768697465506F696E74205B302E3935303520312E3020312E303839305D0A20202020202020202020203E3E0A2020202020202020205D20736574636F6C6F727370616365207D2062696E64206465660A2F73726762207B20736574636F6C6F72207D2062696E64206465660A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963610A2F48656C7665746963612066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7431206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C640A2F48656C7665746963612D426F6C642066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7432206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D4F626C697175650A2F48656C7665746963612D4F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7433206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C644F626C697175650A2F48656C7665746963612D426F6C644F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7434206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742053796D626F6C0A2F53796D626F6C2066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A202063757272656E74646963740A2020656E640A2F466F6E7435206578636820646566696E65666F6E7420706F700A2525456E6450726F6C6F670A2525506167653A203120310A62700A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F6267207B2031203120312073726762207D206465660A312031203120737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A31207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A302E303020302E3030203238382E3030203238382E303020722070330A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A32392E38392033312E3335203238322E3532203236362E363120636C0A2F6267207B20302E3932313620302E3932313620302E393231362073726762207D206465660A32392E38392033312E3335203235322E3633203233352E323620722070320A312031203120737267620A302E3533207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32392E38392037302E3034206D0A3235322E36332030206C0A6F0A6E700A32392E3839203133302E3831206D0A3235322E36332030206C0A6F0A6E700A32392E3839203139312E3538206D0A3235322E36332030206C0A6F0A6E700A32392E3839203235322E3335206D0A3235322E36332030206C0A6F0A312E3037207365746C696E6577696474680A5B5D203020736574646173680A6E700A32392E38392033392E3636206D0A3235322E36332030206C0A6F0A6E700A32392E3839203130302E3433206D0A3235322E36332030206C0A6F0A6E700A32392E3839203136312E3230206D0A3235322E36332030206C0A6F0A6E700A32392E3839203232312E3937206D0A3235322E36332030206C0A6F0A6E700A35342E33342033312E3335206D0A30203233352E3236206C0A6F0A6E700A39352E30382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3133352E38332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3137362E35382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3231372E33332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3235382E30372033312E3335206D0A30203233352E3236206C0A6F0A2F6267207B20302E3630303020302E3630303020302E363030302073726762207D206465660A33362E3030202D32312E31312033362E3637203131382E393720722070320A2F6267207B20302E3930323020302E3632333520302073726762207D206465660A37362E3735202D32312E31312033362E3637203134392E303420722070320A2F6267207B20302E3333373320302E3730353920302E393133372073726762207D206465660A3131372E3439202D32312E31312033362E3637203136312E343220722070320A2F6267207B203020302E3631393620302E343531302073726762207D206465660A3135382E3234202D32312E31312033362E3637203134382E303520722070320A2F6267207B203020302E3434373120302E363938302073726762207D206465660A3139382E3939202D32312E31312033362E3637203136392E313720722070320A2F6267207B20302E3833353320302E3336383620302073726762207D206465660A3233392E3734202D32312E31312033362E3637203231342E323120722070320A302030203020737267620A312E3030207365746D697465726C696D69740A6E700A34392E3234203135332E3638206D0A31302E31392030206C0A6F0A6E700A35342E3334203135332E3638206D0A30202D3131312E3634206C0A6F0A6E700A34392E32342034322E3034206D0A31302E31392030206C0A6F0A6E700A38392E3939203136352E3536206D0A31302E31392030206C0A6F0A6E700A39352E3038203136352E3536206D0A30202D37352E3237206C0A6F0A6E700A38392E39392039302E3239206D0A31302E31392030206C0A6F0A6E700A3133302E3734203137372E3934206D0A31302E31382030206C0A6F0A6E700A3133352E3833203137372E3934206D0A30202D37352E3237206C0A6F0A6E700A3133302E3734203130322E3637206D0A31302E31382030206C0A6F0A6E700A3137312E3438203136342E3537206D0A31302E31392030206C0A6F0A6E700A3137362E3538203136342E3537206D0A30202D37352E3237206C0A6F0A6E700A3137312E34382038392E3330206D0A31302E31392030206C0A6F0A6E700A3231322E3233203138352E3639206D0A31302E31392030206C0A6F0A6E700A3231372E3333203138352E3639206D0A30202D37352E3237206C0A6F0A6E700A3231322E3233203131302E3432206D0A31302E31392030206C0A6F0A6E700A3235322E3938203233302E3733206D0A31302E31392030206C0A6F0A6E700A3235382E3037203233302E3733206D0A30202D37352E3236206C0A6F0A6E700A3235322E3938203135352E3437206D0A31302E31392030206C0A6F0A2F466F6E74312066696E64666F6E7420313120730A35342E3334203235312E393720286129202E35203020740A3137362E3538203235312E393720286129202E35203020740A39352E3038203235312E393720286129202E35203020740A3133352E3833203235312E393720286129202E35203020740A3231372E3333203235312E393720286129202E35203020740A3235382E3037203235312E393720286129202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A32342E39362033362E3432202832292031203020740A32342E39362039372E3139202834292031203020740A32342E3936203135372E3936202836292031203020740A32342E3936203231382E3734202838292031203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32372E31352033392E3636206D0A322E37342030206C0A6F0A6E700A32372E3135203130302E3433206D0A322E37342030206C0A6F0A6E700A32372E3135203136312E3230206D0A322E37342030206C0A6F0A6E700A32372E3135203232312E3937206D0A322E37342030206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A35342E33342032382E3631206D0A3020322E3734206C0A6F0A6E700A39352E30382032382E3631206D0A3020322E3734206C0A6F0A6E700A3133352E38332032382E3631206D0A3020322E3734206C0A6F0A6E700A3137362E35382032382E3631206D0A3020322E3734206C0A6F0A6E700A3231372E33332032382E3631206D0A3020322E3734206C0A6F0A6E700A3235382E30372032382E3631206D0A3020322E3734206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A35342E33342031392E393520283129202E35203020740A39352E30382031392E393520283229202E35203020740A3133352E38332031392E393520283329202E35203020740A3137362E35382031392E393520283429202E35203020740A3231372E33332031392E393520283529202E35203020740A3235382E30372031392E393520283629202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A3133312E313420372E36372028542920302074610A2D312E3332302028726561746D656E74292074622067720A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A31352E3537203134382E393820284D65616E29202E3520393020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313320730A302030203020737267620A3135362E3230203237332E313920286C6D29202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A65700A2525547261696C65720A252550616765733A20310A2525454F460A0A0A20>|ps>|0.8par|||>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Comparison - Generic Functions>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|plot>|<cell|summary>|<cell|anova(.)>|<cell|anova(.,.)>|<cell|update>>|<row|<cell|lm>|<cell|yes>|<cell|yes>|<cell|yes>|<cell|yes>|<cell|yes>>|<row|<cell|lme>|<cell|yes
    (a)>|<cell|yes>|<cell|yes>|<cell|yes (d)>|<cell|yes>>|<row|<cell|glmmPQL>|<cell|yes
    (a)>|<cell|yes>|<cell|no>|<cell|no>|<cell|yes>>|<row|<cell|lmer>|<cell|yes
    (b)>|<cell|yes>|<cell|yes>|<cell|yes (g)>|<cell|yes>>|<row|<cell|blmer>|<cell|yes
    (b)>|<cell|yes>|<cell|yes>|<cell|yes (g)>|<cell|yes>>|<row|<cell|glmmadmb
    (k)>|<cell|no>|<cell|yes (l)>|<cell|no (m)>|<cell|yes
    (n)>|<cell|yes>>|<row|<cell|glmmLasso>|<cell|no (p)>|<cell|yes
    (q)>|<cell|no>|<cell|no (s)>|<cell|no
    (r)>>|<row|<cell|lmm>|<cell|no>|<cell|yes
    (o)>|<cell|no>|<cell|no>|<cell|no>>|<row|<cell|MCMCglmm>|<cell|yes
    (h)>|<cell|yes>|<cell|no>|<cell|no>|<cell|no>>|<row|<cell|inla>|yes
    (i)|<cell|yes>|<cell|no>|<cell|no>|<cell|no>>|<row|<cell|brm>|<cell|yes
    (j)>|<cell|>|<cell|>|<cell|>|<cell|>>>>>|>

    <\enumerate-alpha>
      <item>Residual plot only, qqnorm is avaible for QQ plots

      <item>Residual plot only, qqnorm is not avaible

      <item>summary missing logLik, AIC, BIC values; logLik.glmmPQL returns
      NA.

      <item><verbatim|fitted objects with different fixed effects. REML
      comparisons are not meaningful>

      <item><verbatim|'anova' is not available for PQL fits>

      <item>no p-values for F tests

      <item><verbatim|refitting model(s) with ML (instead of REML)>

      <item>requires <verbatim|Hit \<Return\> to see next plot:>

      <item>opens several plot windows simultaneously

      <item>ggplot is used to provide very elegant graphs

      <item><verbatim|In eval(expr, envir, enclos) : sd.est not defined for
      this family.> \ 

      glmmadmb reports Error in svd(x, 0, 0) : a dimension is zero for a 0 +
      (1 \| rep) model.

      <item><verbatim|In .local(x, sigma, ...) :>

      \ \ <verbatim|'sigma' and 'rdig' arguments are present for
      compatibility only: ignored.>\ 

      AIC reported, but not BIC or logLik.

      <item><verbatim|Error in anova.glmmadmb(Table5.7.admb) : Two or more
      model fits required>

      <item>Analysis of Deviance Table, logLik only

      <item>summary.list

      <item>No smooth terms to plot!

      <item>No residual term reported, so Standard Error of fixed effect
      estimates is NA.

      <item>Error in formula.default(object) : invalid formula

      \;
    </enumerate-alpha>

    \;
  </hidden>|<\hidden>
    <tit|Mixed Model Formulation>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|coef>|<cell|vcov>|<cell|glht>|<cell|lsmeans>>|<row|<cell|lm>|<cell|vector>|<cell|>|<cell|>|<cell|>>|<row|<cell|lme>|<cell|matrix>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmadmb>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmLasso>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lmm>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|inla>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|brm>|<cell|>|<cell|>|<cell|>|<cell|>>>>>|>
  </hidden>|<\hidden>
    <tit|Overview of Packages for LMM Solutions>

    <big-table|<tabular|<tformat|<table|<row|<cell|Function>|<cell|Package>|<cell|Version>|<cell|Maintainer>>|<row|<cell|lme>|<cell|nlme>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|MASS>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|lme4>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|blme>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmadmb
    (a)>|<cell|glmmADMB>|<cell|>|<cell|>>|<row|<cell|glmmLasso>|<cell|glmmLasso>|<cell|1.4.4
    2016-05-28>|<cell|Andreas Groll groll@mathematik.uni-muenchen.de>>|<row|<cell|lmm>|<cell|minque>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|MCMCglmm>|<cell|>|<cell|>>|<row|<cell|inla
    (b)>|<cell|INLA>|<cell|>|<cell|>>|<row|<cell|brm
    (c)>|<cell|brms>|<cell|>|<cell|>>>>>|>

    <\enumerate-alpha>
      <item>not on CRAN, install.packages("glmmADMB",
      repos=c("http://glmmadmb.r-forge.r-project.org/repos",
      getOption("repos")),type="source")

      <item>not on CRAN, install from. Source is also available at
      http://bitbucket.org/hrue/r-inla

      <item>uses external C++ compiler; may be difficult for some users.
    </enumerate-alpha>

    http://glmm.wikidot.com/pkg-comparison
  </hidden>|<\hidden>
    <tit|Syntax (Example 1)>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|formula>>|<row|<cell|lm>|<cell|obs
    ~ rep + trt>>|<row|<cell|lme>|<cell|obs ~ 0 + trt, random = ~ 1 \|
    rep>>|<row|<cell|glmmPQL>|<cell|obs ~ 0 + trt, random = ~ 1 \| rep,
    family=gaussian>>|<row|<cell|lmer>|<cell|obs ~ 0 + trt + (1 \|
    rep)>>|<row|<cell|blmer>|<cell|obs ~ 0 + trt + (1 \| rep), fixef.prior =
    normal>>|<row|<cell|glmmadmb >|<cell|obs ~ trt, random = ~ 1 \|
    rep>>|<row|<cell|glmmLasso>|<cell|obs ~ 0 + trt, rnd = list(rep =
    ~1)>>|<row|<cell|lmm>|<cell|obs ~ 0 + trt \|
    rep>>|<row|<cell|MCMCglmm>|<cell|obs ~ 0 + trt, random = ~
    rep>>|<row|<cell|inla>|obs ~ 0 + trt + f(rep,
    model="iid")>|<row|<cell|brm>|<cell|obs ~ 0 + trt + (1 \| rep)>>>>>|>

    \;

    glmmadmb update -trt fails with 0 + trt
  </hidden>|<\shown>
    <tit|Syntax (Example 2)>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|formula>>|<row|<cell|lm>|<cell|>>|<row|<cell|lme>|<cell|Yield
    ~ Variety*Trial, random = ~ 1 \| Block>>|<row|<cell|glmmPQL>|<cell|>>|<row|<cell|lmer>|<cell|Yield
    ~ 0 + Variety + (1 \| Trial/Rep) + (1 \|
    Trial:Variety)>>|<row|<cell|blmer>|<cell|>>|<row|<cell|glmmadmb
    >|<cell|>>|<row|<cell|glmmLasso>|<cell|Yield ~ 0+Variety,
    rnd=list(Trial=~1, Block=~1, Interaction=~1)>>|<row|<cell|lmm>|<cell|Yield
    ~ Variety \| Trial/Rep + Variety:Trial>>|<row|<cell|MCMCglmm>|<cell|>>|<row|<cell|inla>|>|<row|<cell|brm>|<cell|>>>>>|>

    \;

    Ex16.8.1$Block \<less\>- Ex16.8.1$Trial:Ex16.8.1$Rep

    Ex16.8.1$Interaction \<less\>- Ex16.8.1$Trial:Ex16.8.1$Variety
  </shown>|<\hidden>
    <tit|lme (hypothesis)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(glht(Table5.7.lm,linfct=mcp(trt="Dunnett")))\ 
      <|unfolded-io>
        \;
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(glht(Table5.7.lme,linfct=mcp(trt="Dunnett")))
      <|unfolded-io>
        \;
      </unfolded-io>

      \;
    </session>

    \;
  </hidden>|<\hidden>
    <tit|lme (variances)>

    <\session|r|default>
      <\folded-io>
        <with|color|red|\<gtr\> >
      <|folded-io>
        print(vtbl \<less\>- vcov(Table5.7.lme))
      <|folded-io>
        print(vtbl \<less\>- vcov(Table5.7.lme))

        \ \ \ \ \ \ \ \ \ \ trt1 \ \ \ \ \ trt2 \ \ \ \ \ trt3 \ \ \ \ \ trt4
        \ \ \ \ \ trt5 \ \ \ \ \ trt6

        trt1 0.9328210 0.2227121 0.2227121 0.2227121 0.2227121 0.2227121

        trt2 0.2227121 0.5523330 0.2227121 0.2227121 0.2227121 0.2227121

        trt3 0.2227121 0.2227121 0.5523330 0.2227121 0.2227121 0.2227121

        trt4 0.2227121 0.2227121 0.2227121 0.5523330 0.2227121 0.2227121

        trt5 0.2227121 0.2227121 0.2227121 0.2227121 0.5523330 0.2227121

        trt6 0.2227121 0.2227121 0.2227121 0.2227121 0.2227121 0.5523330
      </folded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        sqrt(vtbl[1,1]);sqrt(vtbl[2,2])
      <|unfolded-io>
        sqrt(vtbl[1,1]);sqrt(vtbl[2,2])

        [1] 0.9658266

        [1] 0.7431911
      </unfolded-io>

      <\textput>
        Corresponding errors from lsmeans(Table5.7.lme,cld ~ trt) are
        0.9658266 and 0.7431911
      </textput>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        sqrt(vtbl[1,1]+vtbl[2,2]-vtbl[1,2]-vtbl[2,1])
      <|unfolded-io>
        sqrt(vtbl[1,1]+vtbl[2,2]-vtbl[1,2]-vtbl[2,1])

        [1] 1.019671
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        sqrt(vtbl[3,3]+vtbl[2,2]-vtbl[3,2]-vtbl[2,3])
      <|unfolded-io>
        sqrt(vtbl[3,3]+vtbl[2,2]-vtbl[3,2]-vtbl[2,3])

        [1] 0.8119371
      </unfolded-io>

      <\textput>
        Corresponding errors from glht(Table5.7.lme,linfct=mcp(trt="Tukey"))
        are 1.0197 and 0.8119
      </textput>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Variances (Example 1)>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|Replicate>|<cell|>|<cell|Residual>|<cell|>>|<row|<cell|>|<cell|<math|\<sigma\><rsub|r><rsup|2>>>|<cell|<math|\<sigma\><rsub|r>>>|<cell|<math|\<sigma\><rsup|2>>>|<cell|<math|\<sigma\>>>>|<row|<cell|Expected>|<cell|1>|<cell|>|<cell|1>|<cell|>>|<row|<cell|Published>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lm>|<cell|?>|<cell|>|<cell|1.3146>|<cell|<with|font-shape|italic|1.14656>>>|<row|<cell|lme>|<cell|
    >|<cell|0.9438476>|<cell|<with|font-shape|italic|1.318483>>|<cell|1.148252>>|<row|<cell|glmmPQL>|<cell|0.6701158>|<cell|0.8186060>|<cell|0.9534090>|<cell|0.9764266>>|<row|<cell|lmer>|<cell|>|<cell|0.94384>|<cell|>|<cell|1.14825>>|<row|<cell|blmer>|<cell|2.335>|<cell|1.528>|<cell|1.168>|<cell|1.081>>|<row|<cell|glmmadmb>|<cell|0.97642>|<cell|>|<cell|0.6701>|<cell|0.8186>>|<row|<cell|lmm>|<cell|0.8908509>|<cell|>|<cell|1.3184829>|<cell|>>|<row|<cell|glmmLasso>|<cell|>|<cell|1.463278>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|8.547397e-05>|<cell|>|<cell|2.501073>|<cell|>>|<row|<cell|inla>|<cell|18590.8084>|<cell|>|<cell|0.5174>|<cell|>>|<row|<cell|brm>|<cell|>|<cell|1.65>|<cell|>|<cell|1.28>>>>>|>

    \;

    \;

    \ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ 
  </hidden>|<\hidden>
    <tit|Plots (Example 1)>

    \;

    \;
  </hidden>|<\hidden>
    <tit|Combined Mean Plots >

    \;
  </hidden>|<\hidden>
    <tit|Example 2 lm>

    \;

    <\session|r|default>
      <\output>
        <script-interrupted>
      </output>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.lm \<less\>- lm(Yield ~ Trial:Rep + Trial*Variety,
        data=Ex16.8.1)

        summary(aov(Yield ~ Trial:Rep + Trial + Variety +
        Error(Trial:Variety), data=Ex16.8.1))

        summary(aov(Yield ~ Trial*Variety + Error(Trial:Rep), data=Ex16.8.1))
      <|unfolded-io>
        <script-interrupted>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Variances (Example 2)>

    <\big-table|<tabular|<tformat|<cwith|3|13|2|-1|cell-halign|r>|<table|<row|<cell|>|<cell|Trial>|<cell|Interaction>|<cell|Block>|<cell|Residual>>|<row|<cell|>|<cell|<math|\<sigma\><rsub|e><rsup|2>>>|<cell|<math|\<sigma\><rsub|t
    \ \<times\>e>>>|<cell|<math|\<sigma\><rsub|r<around*|(|e|)>><rsup|2>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|lm>|<cell|>|<cell|>|<cell|>|<cell|19708>>|<row|<cell|lme>|<cell|->|<cell|->|<cell|<with|font-shape|italic|0.00008>>|<cell|<with|font-shape|italic|19027>>>|<row|<cell|glmmPQL>|<cell|->|<cell|->|<cell|<with|font-shape|italic|0.00004>>|<cell|<with|font-shape|italic|12684>>>|<row|<cell|lmer>|<cell|42572>|<cell|1732>|<cell|0>|<cell|19027>>|<row|<cell|blmer>|<cell|31253>|<cell|2079>|<cell|1486>|<cell|18590>>|<row|<cell|glmmadmb>|<cell|28356>|<cell|0.01222>|<cell|0.6992>|<cell|<with|font-shape|italic|18123>>>|<row|<cell|lmm>|<cell|49799>|<cell|1505>|<cell|-0.68043>|<cell|19708>>|<row|<cell|glmmLasso>|<cell|<with|font-shape|italic|338061>>|<cell|<with|font-shape|italic|7693>>|<cell|<with|font-shape|italic|36726>>|<cell|>>|<row|<cell|MCMCglmm>|<cell|265650>|<cell|228.6>|<cell|3.462>|<cell|20372>>|<row|<cell|inla>|<cell|13902>|<cell|68094>|<cell|20427>|<cell|0>>|<row|<cell|brm>|<cell|<with|font-shape|italic|64313>>|<cell|<with|font-shape|italic|1773>>|<cell|<with|font-shape|italic|560>>|<cell|<with|font-shape|italic|19656>>>>>>>
      \;
    </big-table>

    fixef prior=normal with blmer 25292,2603,6772,16276

    two additional runs for mcmc

    \;

    \;

    \;

    \;
  </hidden>|<\hidden>
    <tit|Variances (Example 3)>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|Trial>|<cell|Interaction>|<cell|>|<cell|>|<cell|>|<cell|Block>|<cell|Residual>|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|<math|\<sigma\><rsub|e><rsup|2>>>|<cell|<math|\<sigma\><rsup|2><rsub|t
    \ \<times\>e>>>|<cell|<math|\<sigma\><rsup|2><rsub|t<rsub|1>
    \ \<times\>e>>>|<cell|<math|\<sigma\><rsup|2><rsub|t<rsub|2>
    \ \<times\>e>>>|<cell|<math|\<sigma\><rsup|2><rsub|t<rsub|23>
    \ \<times\>e>>>|<cell|<math|\<sigma\><rsub|r<around*|(|e|)>><rsup|2>>>|<cell|<math|\<sigma\><rsup|2>>>|<cell|>|<cell|>|<cell|>>|<row|<cell|lm>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|0.94>|<cell|>|<cell|>|<cell|>>|<row|<cell|lme>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|>|<cell|>|<cell|0.00>|<cell|0.3448>|<cell|2.9374>|<cell|6.6336>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmadmb>|<cell|7.74>|<cell|0.37>|<cell|>|<cell|>|<cell|>|<cell|0.1417>|<cell|0.97014>|<cell|>|<cell|>|<cell|>>|<row|<cell|lmm>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmLasso>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|inla>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|brm>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>>>>|>
  </hidden>|<\hidden>
    <tit|>

    \;
  </hidden>>
</body>

<\initial>
  <\collection>
    <associate|page-medium|beamer>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|42>>
    <associate|auto-2|<tuple|2|45>>
    <associate|auto-3|<tuple|3|46>>
    <associate|auto-4|<tuple|4|47>>
    <associate|auto-5|<tuple|5|48>>
    <associate|auto-6|<tuple|6|51>>
    <associate|auto-7|<tuple|7|55>>
    <associate|auto-8|<tuple|8|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal||<pageref|auto-1>>

      <tuple|normal||<pageref|auto-2>>

      <tuple|normal||<pageref|auto-3>>

      <tuple|normal||<pageref|auto-4>>

      <tuple|normal||<pageref|auto-5>>

      <tuple|normal||<pageref|auto-6>>

      <tuple|normal||<pageref|auto-7>>

      <tuple|normal||<pageref|auto-8>>
    </associate>
  </collection>
</auxiliary>