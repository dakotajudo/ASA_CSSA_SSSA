<TeXmacs|1.99.5>

<style|generic>

<\body>
  <doc-data|<doc-title|Making Sense of the Mixed Model Analyses Available in
  R>|<doc-author|<author-data|<author-name|Peter Claussen>>>>

  <section|Profiling>

  <\program|r|default>
    <\textput>
      <subsection|Sample RCBD Data>
    </textput>

    \;

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      setwd("~/Work/git/ASA_CSSA_SSSA/literate")

      rcbd.dat \<less\>- read.csv("sample RCBD data.csv",header=TRUE)

      setwd("~/Work/git/ASA_CSSA_SSSA/working")
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
    <|unfolded-prog-io>
      setwd("~/Work/git/ASA_CSSA_SSSA/literate")

      \<gtr\> rcbd.dat \<less\>- read.csv("sample RCBD data.csv",header=TRUE)

      \<gtr\> setwd("~/Work/git/ASA_CSSA_SSSA/working")
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      head(rcbd.dat)
    <|unfolded-prog-io>
      head(rcbd.dat)

      \ \ Site Country \ \ \ \ Loca Plot Repe BLK Entry \ YLD AD SD \ PH \ EH
      rEPH rEPP nP

      1 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 1 \ \ \ 1 \ \ 1 \ \ \ 21 7.00 54 55
      280 150 0.54 \ 0.9 58

      2 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 2 \ \ \ 1 \ \ 1 \ \ \ 22 8.39 51 52
      270 140 0.52 \ \ \ 1 58

      3 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 3 \ \ \ 1 \ \ 1 \ \ \ 32 6.85 52 53
      265 140 0.53 \ 0.9 54

      4 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 4 \ \ \ 1 \ \ 1 \ \ \ 11 8.09 53 54
      275 140 0.51 \ \ \ 1 53

      5 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 5 \ \ \ 1 \ \ 2 \ \ \ \ 4 6.86 51 52
      260 125 0.48 \ 0.9 58

      6 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 6 \ \ \ 1 \ \ 2 \ \ \ 29 6.45 51 52
      275 130 0.47 \ 0.9 57
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      rcbd.dat$Repe \<less\>- as.factor(rcbd.dat$Repe)

      rcbd.dat$BLK \<less\>- as.factor(rcbd.dat$BLK)

      rcbd.dat$Entry \<less\>- as.factor(rcbd.dat$Entry)
    <|unfolded-prog-io>
      rcbd.dat$Repe \<less\>- as.factor(rcbd.dat$Repe)

      \<gtr\> rcbd.dat$BLK \<less\>- as.factor(rcbd.dat$BLK)

      \<gtr\> rcbd.dat$Entry \<less\>- as.factor(rcbd.dat$Entry)
    </unfolded-prog-io|>

    <\textput>
      <subsection|lm>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.lm.Rda")) {

      \ \ Rprof("META.lm.prof")

      \ \ rcbd.dat.lm \<less\>- lm(YLD ~ Loca:Repe + Entry*Loca,
      data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(meta.glmmPQL, file="meta.lm.Rda")

      } else {

      \ \ load(file="meta.lm.Rda")

      }

      current.prof \<less\>- summaryRprof("META.lm.prof")

      current.prof

      \;

      anova(rcbd.dat.lm)
    <|unfolded-prog-io>
      if(!file.exists("meta.lm.Rda")) {

      + \ \ Rprof("META.lm.prof")

      + \ \ rcbd.dat.lm \<less\>- lm(YLD ~ Loca:Repe + Entry*Loca,
      data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(meta.glmmPQL, file="meta.lm.Rda")

      + } else {

      + \ \ load(file="meta.lm.Rda")

      + }

      Error in save(meta.glmmPQL, file = "meta.lm.Rda") :\ 

      \ \ object 'meta.glmmPQL' not found

      \<gtr\> current.prof \<less\>- summaryRprof("META.lm.prof")

      \<gtr\> current.prof

      $by.self

      \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time total.pct

      "lm.fit" \ \ \ \ \ \ \ \ \ 0.22 \ \ \ 78.57 \ \ \ \ \ \ 0.22
      \ \ \ \ 78.57

      ".External2" \ \ \ \ \ 0.06 \ \ \ 21.43 \ \ \ \ \ \ 0.06 \ \ \ \ 21.43

      \;

      $by.total

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct
      self.time self.pct

      "lm" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.28 \ \ \ 100.00
      \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "lm.fit" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.22 \ \ \ \ 78.57
      \ \ \ \ \ 0.22 \ \ \ 78.57

      ".External2" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.06 \ \ \ \ 21.43
      \ \ \ \ \ 0.06 \ \ \ 21.43

      "model.matrix" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.06 \ \ \ \ 21.43
      \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "model.matrix.default" \ \ \ \ \ \ 0.06 \ \ \ \ 21.43 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      \;

      $sample.interval

      [1] 0.02

      \;

      $sampling.time

      [1] 0.28

      \;

      \<gtr\>\ 

      \<gtr\> anova(rcbd.dat.lm)

      Analysis of Variance Table

      \;

      Response: YLD

      \ \ \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq \ F value \ \ \ Pr(\<gtr\>F)
      \ \ \ 

      Entry \ \ \ \ \ \ 31 \ 971.5 \ \ 31.34 \ 33.2976 \<less\> 2.2e-16 ***

      Loca \ \ \ \ \ \ \ 11 8994.8 \ 817.71 868.8207 \<less\> 2.2e-16 ***

      Loca:Repe \ \ 24 \ 131.4 \ \ \ 5.47 \ \ 5.8166 \<less\> 2.2e-16 ***

      Loca:Entry 341 \ 763.1 \ \ \ 2.24 \ \ 2.3776 \<less\> 2.2e-16 ***

      Residuals \ 744 \ 700.2 \ \ \ 0.94 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-prog-io|>

    <\textput>
      <section|lme>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(nlme)
    <|unfolded-prog-io>
      library(nlme)
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      rcbd.dat$Block \<less\>- rcbd.dat$Loca:rcbd.dat$Repe
    <|unfolded-prog-io>
      rcbd.dat$Block \<less\>- rcbd.dat$Loca:rcbd.dat$Repe
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.lme.Rda")) {

      \ \ Rprof("meta.lme.prof")

      \ \ meta.lme \<less\>- lme(YLD ~ Loca*Entry, random = ~ 1 \| Block,
      data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ Rprof("cotes.lme.prof")

      \ \ 

      \ \ cotes.lme \<less\>- lme(YLD ~ Loca*Entry, random = ~ 1 \| Block,
      weights = varIdent(form = ~ Plot \| Loca), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(meta.lme, file="meta.lme.Rda")

      \ \ \ save(cotes.lme, file="cotes.lme.Rda")

      \ } else {

      \ \ \ load(file="meta.lme.Rda")

      \ \ \ load(file="cotes.lme.Rda")

      \ }

      summary(meta.lme)

      meta.lme.summary \<less\>- summaryRprof("meta.lme.prof")

      head(meta.lme.summary[[1]])

      head(meta.lme.summary[[2]])

      summary(cotes.lme)

      cotes.lme.summary \<less\>- summaryRprof("cotes.lme.prof")

      head(cotes.lme.summary[[1]])

      head(cotes.lme.summary[[2]])

      \;
    <|unfolded-prog-io>
      if(!file.exists("meta.lme.Rda")) {

      + \ \ Rprof("meta.lme.prof")

      + \ \ meta.lme \<less\>- lme(YLD ~ Loca*Entry, random = ~ 1 \| Block,
      data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ Rprof("cotes.lme.prof")

      + \ \ 

      + \ \ cotes.lme \<less\>- lme(YLD ~ Loca*Entry, random = ~ 1 \| Block,
      weights = varIde

      \<less\>Loca*Entry, random = ~ 1 \| Block, weights = varIdent(form = ~
      Plot \| Loca),\ 

      \<less\> Block, weights = varIdent(form = ~ Plot \| Loca),
      data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(meta.lme, file="meta.lme.Rda")

      + \ \ \ save(cotes.lme, file="cotes.lme.Rda")

      + \ } else {

      + \ \ \ load(file="meta.lme.Rda")

      + \ \ \ load(file="cotes.lme.Rda")

      + \ }

      \<gtr\> summary(meta.lme)

      Linear mixed-effects model fit by REML

      \ Data: rcbd.dat\ 

      \ \ \ \ \ \ \ AIC \ \ \ \ BIC \ \ \ logLik

      \ \ 3369.047 5161.55 -1298.524

      \;

      Random effects:

      \ Formula: ~1 \| Block

      \ \ \ \ \ \ \ \ (Intercept) \ Residual

      StdDev: \ \ 0.3763806 0.9701382

      \;

      Fixed effects: YLD ~ Loca * Entry\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Value Std.Error
      \ DF \ \ t-value p-value

      (Intercept) \ \ \ \ \ \ \ \ \ \ \ \ \ 6.160000 0.6007858 744 10.253239
      \ 0.0000

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ 0.916667 0.8496394 \ 24 \ 1.078889
      \ 0.2914

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.836667 0.8496394 \ 24
      \ 3.338671 \ 0.0027

      LocaManagua \ \ \ \ \ \ \ \ \ \ \ \ -1.700000 0.8496394 \ 24 -2.000849
      \ 0.0568

      LocaPalmira \ \ \ \ \ \ \ \ \ \ \ \ \ 1.783333 0.8496394 \ 24
      \ 2.098930 \ 0.0465

      LocaSabana \ \ \ \ \ \ \ \ \ \ \ \ \ -5.240000 0.8496394 \ 24 -6.167323
      \ 0.0000

      LocaSan Andres \ \ \ \ \ \ \ \ \ -2.086667 0.8496394 \ 24 -2.455944
      \ 0.0217

      LocaSanta Cruz \ \ \ \ \ \ \ \ \ \ 1.213333 0.8496394 \ 24 \ 1.428057
      \ 0.1662

      LocaTiucal \ \ \ \ \ \ \ \ \ \ \ \ \ -3.483333 0.8496394 \ 24 -4.099779
      \ 0.0004

      LocaTlaltizapan \ \ \ \ \ \ \ \ \ 3.900000 0.8496394 \ 24 \ 4.590183
      \ 0.0001

      LocaToco \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.793333 0.8496394 \ 24
      \ 0.933729 \ 0.3597

      LocaYoro \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -2.643333 0.8496394 \ 24
      -3.111124 \ 0.0048

      Entry2 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.600000 0.7921145 744
      \ 0.757466 \ 0.4490

      Entry3 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.706667 0.7921145 744
      \ 0.892127 \ 0.3726

      Entry4 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.563333 0.7921145 744
      \ 0.711177 \ 0.4772

      Entry5 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.290000 0.7921145 744
      \ 1.628552 \ 0.1038

      Entry6 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.856667 0.7921145 744
      \ 1.081493 \ 0.2798

      Entry7 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.146667 0.7921145 744
      \ 0.185158 \ 0.8532

      Entry8 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.836667 0.7921145 744
      \ 2.318688 \ 0.0207

      Entry9 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.170000 0.7921145 744
      \ 0.214615 \ 0.8301

      Entry10 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.680000 0.7921145 744
      \ 0.858462 \ 0.3909

      Entry11 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.260000 0.7921145 744
      \ 2.853123 \ 0.0044

      Entry12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.860000 0.7921145 744
      \ 1.085702 \ 0.2780

      Entry13 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.213333 0.7921145 744
      \ 1.531765 \ 0.1260

      Entry14 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -1.480000 0.7921145 744
      -1.868417 \ 0.0621

      Entry15 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.270000 0.7921145 744
      \ 0.340860 \ 0.7333

      Entry16 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.270000 0.7921145 744
      -0.340860 \ 0.7333

      Entry17 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.916667 0.7921145 744
      \ 1.157240 \ 0.2475

      Entry18 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.433333 0.7921145 744
      \ 0.547059 \ 0.5845

      Entry19 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -1.750000 0.7921145 744
      -2.209276 \ 0.0275

      Entry20 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.706667 0.7921145 744
      \ 0.892127 \ 0.3726

      Entry21 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.303333 0.7921145 744
      -0.382941 \ 0.7019

      Entry22 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.560000 0.7921145 744
      \ 0.706968 \ 0.4798

      Entry23 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -2.186667 0.7921145 744
      -2.760544 \ 0.0059

      Entry24 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.573333 0.7921145 744
      \ 0.723801 \ 0.4694

      Entry25 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.116667 0.7921145 744
      -0.147285 \ 0.8829

      Entry26 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.470000 0.7921145 744
      \ 3.118236 \ 0.0019

      Entry27 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.976667 0.7921145 744
      \ 1.232987 \ 0.2180

      Entry28 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.090000 0.7921145 744
      \ 0.113620 \ 0.9096

      Entry29 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.143333 0.7921145 744
      \ 0.180950 \ 0.8565

      Entry30 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.496667 0.7921145 744
      -0.627014 \ 0.5308

      \;

      Entry31 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.800000 0.7921145 744
      \ 2.272399 \ 0.0233

      Entry32 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.140000 0.7921145 744
      \ 1.439186 \ 0.1505

      LocaCotaxtla:Entry2 \ \ \ \ -0.550000 1.1202191 744 -0.490975 \ 0.6236

      LocaIguala:Entry2 \ \ \ \ \ \ \ 0.383333 1.1202191 744 \ 0.342195
      \ 0.7323

      LocaManagua:Entry2 \ \ \ \ \ -0.813333 1.1202191 744 -0.726048 \ 0.4680

      LocaPalmira :Entry2 \ \ \ \ \ 0.473333 1.1202191 744 \ 0.422536
      \ 0.6728

      LocaSabana :Entry2 \ \ \ \ \ -0.420000 1.1202191 744 -0.374927 \ 0.7078

      LocaSan Andres:Entry2 \ \ -0.606667 1.1202191 744 -0.541561 \ 0.5883

      LocaSanta Cruz:Entry2 \ \ \ 0.106667 1.1202191 744 \ 0.095219 \ 0.9242

      LocaTiucal:Entry2 \ \ \ \ \ \ -1.283333 1.1202191 744 -1.145609
      \ 0.2523

      LocaTlaltizapan:Entry2 \ -0.900000 1.1202191 744 -0.803414 \ 0.4220

      LocaToco:Entry2 \ \ \ \ \ \ \ \ -0.883333 1.1202191 744 -0.788536
      \ 0.4306

      LocaYoro:Entry2 \ \ \ \ \ \ \ \ -0.453333 1.1202191 744 -0.404683
      \ 0.6858

      LocaCotaxtla:Entry3 \ \ \ \ \ 0.320000 1.1202191 744 \ 0.285658
      \ 0.7752

      LocaIguala:Entry3 \ \ \ \ \ \ \ 0.176667 1.1202191 744 \ 0.157707
      \ 0.8747

      LocaManagua:Entry3 \ \ \ \ \ -0.736667 1.1202191 744 -0.657609 \ 0.5110

      LocaPalmira :Entry3 \ \ \ \ -0.150000 1.1202191 744 -0.133902 \ 0.8935

      LocaSabana :Entry3 \ \ \ \ \ -0.350000 1.1202191 744 -0.312439 \ 0.7548

      LocaSan Andres:Entry3 \ \ -0.440000 1.1202191 744 -0.392780 \ 0.6946

      LocaSanta Cruz:Entry3 \ \ -0.280000 1.1202191 744 -0.249951 \ 0.8027

      LocaTiucal:Entry3 \ \ \ \ \ \ \ 0.490000 1.1202191 744 \ 0.437414
      \ 0.6619

      LocaTlaltizapan:Entry3 \ \ 1.453333 1.1202191 744 \ 1.297365 \ 0.1949

      LocaToco:Entry3 \ \ \ \ \ \ \ \ \ 1.080000 1.1202191 744 \ 0.964097
      \ 0.3353

      LocaYoro:Entry3 \ \ \ \ \ \ \ \ \ 0.153333 1.1202191 744 \ 0.136878
      \ 0.8912

      LocaCotaxtla:Entry4 \ \ \ \ -0.910000 1.1202191 744 -0.812341 \ 0.4169

      LocaIguala:Entry4 \ \ \ \ \ \ -0.100000 1.1202191 744 -0.089268
      \ 0.9289

      LocaManagua:Entry4 \ \ \ \ \ \ 0.350000 1.1202191 744 \ 0.312439
      \ 0.7548

      LocaPalmira :Entry4 \ \ \ \ \ 1.060000 1.1202191 744 \ 0.946243
      \ 0.3443

      LocaSabana :Entry4 \ \ \ \ \ -0.106667 1.1202191 744 -0.095219 \ 0.9242

      LocaSan Andres:Entry4 \ \ -0.420000 1.1202191 744 -0.374927 \ 0.7078

      LocaSanta Cruz:Entry4 \ \ -0.983333 1.1202191 744 -0.877804 \ 0.3803

      LocaTiucal:Entry4 \ \ \ \ \ \ \ 0.000000 1.1202191 744 \ 0.000000
      \ 1.0000

      LocaTlaltizapan:Entry4 \ \ 1.836667 1.1202191 744 \ 1.639560 \ 0.1015

      LocaToco:Entry4 \ \ \ \ \ \ \ \ \ 0.553333 1.1202191 744 \ 0.493951
      \ 0.6215

      LocaYoro:Entry4 \ \ \ \ \ \ \ \ -0.583333 1.1202191 744 -0.520731
      \ 0.6027

      LocaCotaxtla:Entry5 \ \ \ \ -0.906667 1.1202191 744 -0.809365 \ 0.4186

      LocaIguala:Entry5 \ \ \ \ \ \ \ 0.343333 1.1202191 744 \ 0.306488
      \ 0.7593

      LocaManagua:Entry5 \ \ \ \ \ -1.876667 1.1202191 744 -1.675267 \ 0.0943

      LocaPalmira :Entry5 \ \ \ \ \ 0.356667 1.1202191 744 \ 0.318390
      \ 0.7503

      LocaSabana :Entry5 \ \ \ \ \ -1.376667 1.1202191 744 -1.228926 \ 0.2195

      LocaSan Andres:Entry5 \ \ -1.436667 1.1202191 744 -1.282487 \ 0.2001

      LocaSanta Cruz:Entry5 \ \ -1.196667 1.1202191 744 -1.068243 \ 0.2858

      LocaTiucal:Entry5 \ \ \ \ \ \ -1.876667 1.1202191 744 -1.675267
      \ 0.0943

      LocaTlaltizapan:Entry5 \ \ 0.506667 1.1202191 744 \ 0.452292 \ 0.6512

      LocaToco:Entry5 \ \ \ \ \ \ \ \ \ 0.533333 1.1202191 744 \ 0.476097
      \ 0.6341

      LocaYoro:Entry5 \ \ \ \ \ \ \ \ -0.800000 1.1202191 744 -0.714146
      \ 0.4754

      LocaCotaxtla:Entry6 \ \ \ \ -1.476667 1.1202191 744 -1.318194 \ 0.1878

      LocaIguala:Entry6 \ \ \ \ \ \ -0.350000 1.1202191 744 -0.312439
      \ 0.7548

      LocaManagua:Entry6 \ \ \ \ \ -0.146667 1.1202191 744 -0.130927 \ 0.8959

      LocaPalmira :Entry6 \ \ \ \ \ 0.200000 1.1202191 744 \ 0.178536
      \ 0.8584

      LocaSabana :Entry6 \ \ \ \ \ -0.430000 1.1202191 744 -0.383853 \ 0.7012

      LocaSan Andres:Entry6 \ \ -0.663333 1.1202191 744 -0.592146 \ 0.5539

      LocaSanta Cruz:Entry6 \ \ \ 0.093333 1.1202191 744 \ 0.083317 \ 0.9336

      LocaTiucal:Entry6 \ \ \ \ \ \ -0.563333 1.1202191 744 -0.502878
      \ 0.6152

      LocaTlaltizapan:Entry6 \ \ 1.106667 1.1202191 744 \ 0.987902 \ 0.3235

      LocaToco:Entry6 \ \ \ \ \ \ \ \ -0.436667 1.1202191 744 -0.389805
      \ 0.6968

      LocaYoro:Entry6 \ \ \ \ \ \ \ \ -0.220000 1.1202191 744 -0.196390
      \ 0.8444

      LocaCotaxtla:Entry7 \ \ \ \ -1.040000 1.1202191 744 -0.928390 \ 0.3535

      LocaIguala:Entry7 \ \ \ \ \ \ \ 1.423333 1.1202191 744 \ 1.270585
      \ 0.2043

      LocaManagua:Entry7 \ \ \ \ \ -0.696667 1.1202191 744 -0.621902 \ 0.5342

      LocaPalmira :Entry7 \ \ \ \ \ 0.043333 1.1202191 744 \ 0.038683
      \ 0.9692

      LocaSabana :Entry7 \ \ \ \ \ -0.143333 1.1202191 744 -0.127951 \ 0.8982

      LocaSan Andres:Entry7 \ \ -0.116667 1.1202191 744 -0.104146 \ 0.9171

      LocaSanta Cruz:Entry7 \ \ -0.050000 1.1202191 744 -0.044634 \ 0.9644

      LocaTiucal:Entry7 \ \ \ \ \ \ -0.476667 1.1202191 744 -0.425512
      \ 0.6706

      LocaTlaltizapan:Entry7 \ -0.290000 1.1202191 744 -0.258878 \ 0.7958

      LocaToco:Entry7 \ \ \ \ \ \ \ \ -0.570000 1.1202191 744 -0.508829
      \ 0.6110

      LocaYoro:Entry7 \ \ \ \ \ \ \ \ -0.713333 1.1202191 744 -0.636780
      \ 0.5245

      LocaCotaxtla:Entry8 \ \ \ \ -0.910000 1.1202191 744 -0.812341 \ 0.4169

      LocaIguala:Entry8 \ \ \ \ \ \ -0.760000 1.1202191 744 -0.678439
      \ 0.4977

      LocaManagua:Entry8 \ \ \ \ \ -2.170000 1.1202191 744 -1.937121 \ 0.0531

      LocaPalmira :Entry8 \ \ \ \ \ 0.423333 1.1202191 744 \ 0.377902
      \ 0.7056

      LocaSabana :Entry8 \ \ \ \ \ -1.866667 1.1202191 744 -1.666341 \ 0.0961

      LocaSan Andres:Entry8 \ \ -1.733333 1.1202191 744 -1.547316 \ 0.1222

      LocaSanta Cruz:Entry8 \ \ -1.623333 1.1202191 744 -1.449121 \ 0.1477

      LocaTiucal:Entry8 \ \ \ \ \ \ -2.726667 1.1202191 744 -2.434048
      \ 0.0152

      LocaTlaltizapan:Entry8 \ \ 1.083333 1.1202191 744 \ 0.967073 \ 0.3338

      LocaToco:Entry8 \ \ \ \ \ \ \ \ -1.260000 1.1202191 744 -1.124780
      \ 0.2610

      LocaYoro:Entry8 \ \ \ \ \ \ \ \ -1.240000 1.1202191 744 -1.106926
      \ 0.2687

      LocaCotaxtla:Entry9 \ \ \ \ -1.126667 1.1202191 744 -1.005756 \ 0.3149

      LocaIguala:Entry9 \ \ \ \ \ \ -0.493333 1.1202191 744 -0.440390
      \ 0.6598

      LocaManagua:Entry9 \ \ \ \ \ \ 0.283333 1.1202191 744 \ 0.252927
      \ 0.8004

      LocaPalmira :Entry9 \ \ \ \ \ 0.216667 1.1202191 744 \ 0.193415
      \ 0.8467

      LocaSabana :Entry9 \ \ \ \ \ -0.086667 1.1202191 744 -0.077366 \ 0.9384

      LocaSan Andres:Entry9 \ \ -2.250000 1.1202191 744 -2.008536 \ 0.0449

      LocaSanta Cruz:Entry9 \ \ -2.383333 1.1202191 744 -2.127560 \ 0.0337

      LocaTiucal:Entry9 \ \ \ \ \ \ -0.563333 1.1202191 744 -0.502878
      \ 0.6152

      LocaTlaltizapan:Entry9 \ \ 1.610000 1.1202191 744 \ 1.437219 \ 0.1511

      LocaToco:Entry9 \ \ \ \ \ \ \ \ \ 0.076667 1.1202191 744 \ 0.068439
      \ 0.9455

      LocaYoro:Entry9 \ \ \ \ \ \ \ \ -0.193333 1.1202191 744 -0.172585
      \ 0.8630

      LocaCotaxtla:Entry10 \ \ \ -0.416667 1.1202191 744 -0.371951 \ 0.7100

      LocaIguala:Entry10 \ \ \ \ \ \ 0.523333 1.1202191 744 \ 0.467170
      \ 0.6405

      LocaManagua:Entry10 \ \ \ \ \ 0.630000 1.1202191 744 \ 0.562390
      \ 0.5740

      LocaPalmira :Entry10 \ \ \ \ 0.593333 1.1202191 744 \ 0.529658 \ 0.5965

      LocaSabana :Entry10 \ \ \ \ -0.596667 1.1202191 744 -0.532634 \ 0.5944

      LocaSan Andres:Entry10 \ -2.243333 1.1202191 744 -2.002584 \ 0.0456

      LocaSanta Cruz:Entry10 \ -0.970000 1.1202191 744 -0.865902 \ 0.3868

      LocaTiucal:Entry10 \ \ \ \ \ -0.310000 1.1202191 744 -0.276732 \ 0.7821

      LocaTlaltizapan:Entry10 \ 1.866667 1.1202191 744 \ 1.666341 \ 0.0961

      LocaToco:Entry10 \ \ \ \ \ \ \ -0.983333 1.1202191 744 -0.877804
      \ 0.3803

      LocaYoro:Entry10 \ \ \ \ \ \ \ -0.520000 1.1202191 744 -0.464195
      \ 0.6426

      LocaCotaxtla:Entry11 \ \ \ -1.343333 1.1202191 744 -1.199170 \ 0.2308

      LocaIguala:Entry11 \ \ \ \ \ -1.170000 1.1202191 744 -1.044439 \ 0.2966

      LocaManagua:Entry11 \ \ \ \ -1.716667 1.1202191 744 -1.532438 \ 0.1258

      LocaPalmira :Entry11 \ \ \ -1.763333 1.1202191 744 -1.574097 \ 0.1159

      LocaSabana :Entry11 \ \ \ \ -1.360000 1.1202191 744 -1.214048 \ 0.2251

      LocaSan Andres:Entry11 \ -1.580000 1.1202191 744 -1.410438 \ 0.1588

      LocaSanta Cruz:Entry11 \ -1.903333 1.1202191 744 -1.699072 \ 0.0897

      LocaTiucal:Entry11 \ \ \ \ \ -2.560000 1.1202191 744 -2.285267 \ 0.0226

      LocaTlaltizapan:Entry11 \ 1.076667 1.1202191 744 \ 0.961121 \ 0.3368

      LocaToco:Entry11 \ \ \ \ \ \ \ -2.086667 1.1202191 744 -1.862731
      \ 0.0629

      LocaYoro:Entry11 \ \ \ \ \ \ \ -0.330000 1.1202191 744 -0.294585
      \ 0.7684

      LocaCotaxtla:Entry12 \ \ \ -1.100000 1.1202191 744 -0.981951 \ 0.3264

      LocaIguala:Entry12 \ \ \ \ \ -1.750000 1.1202191 744 -1.562194 \ 0.1187

      LocaManagua:Entry12 \ \ \ \ -0.186667 1.1202191 744 -0.166634 \ 0.8677

      LocaPalmira :Entry12 \ \ \ -0.393333 1.1202191 744 -0.351122 \ 0.7256

      LocaSabana :Entry12 \ \ \ \ -0.550000 1.1202191 744 -0.490975 \ 0.6236

      LocaSan Andres:Entry12 \ -1.783333 1.1202191 744 -1.591950 \ 0.1118

      LocaSanta Cruz:Entry12 \ -1.636667 1.1202191 744 -1.461024 \ 0.1444

      LocaTiucal:Entry12 \ \ \ \ \ -0.983333 1.1202191 744 -0.877804 \ 0.3803

      LocaTlaltizapan:Entry12 \ 0.690000 1.1202191 744 \ 0.615951 \ 0.5381

      LocaToco:Entry12 \ \ \ \ \ \ \ \ 0.776667 1.1202191 744 \ 0.693317
      \ 0.4883

      LocaYoro:Entry12 \ \ \ \ \ \ \ -1.313333 1.1202191 744 -1.172390
      \ 0.2414

      LocaCotaxtla:Entry13 \ \ \ -0.806667 1.1202191 744 -0.720097 \ 0.4717

      LocaIguala:Entry13 \ \ \ \ \ \ 0.656667 1.1202191 744 \ 0.586195
      \ 0.5579

      LocaManagua:Entry13 \ \ \ \ -1.060000 1.1202191 744 -0.946243 \ 0.3443

      LocaPalmira :Entry13 \ \ \ -1.213333 1.1202191 744 -1.083121 \ 0.2791

      LocaSabana :Entry13 \ \ \ \ -1.050000 1.1202191 744 -0.937317 \ 0.3489

      LocaSan Andres:Entry13 \ -2.393333 1.1202191 744 -2.136487 \ 0.0330

      LocaSanta Cruz:Entry13 \ -0.923333 1.1202191 744 -0.824243 \ 0.4101

      LocaTiucal:Entry13 \ \ \ \ \ -2.120000 1.1202191 744 -1.892487 \ 0.0588

      LocaTlaltizapan:Entry13 \ 1.426667 1.1202191 744 \ 1.273560 \ 0.2032

      LocaToco:Entry13 \ \ \ \ \ \ \ -1.773333 1.1202191 744 -1.583024
      \ 0.1138

      LocaYoro:Entry13 \ \ \ \ \ \ \ -1.460000 1.1202191 744 -1.303316
      \ 0.1929

      LocaCotaxtla:Entry14 \ \ \ -2.670000 1.1202191 744 -2.383462 \ 0.0174

      LocaIguala:Entry14 \ \ \ \ \ -1.620000 1.1202191 744 -1.446146 \ 0.1486

      LocaManagua:Entry14 \ \ \ \ \ 1.026667 1.1202191 744 \ 0.916487
      \ 0.3597

      LocaPalmira :Entry14 \ \ \ -2.086667 1.1202191 744 -1.862731 \ 0.0629

      LocaSabana :Entry14 \ \ \ \ \ 1.386667 1.1202191 744 \ 1.237853
      \ 0.2162

      LocaSan Andres:Entry14 \ -1.653333 1.1202191 744 -1.475902 \ 0.1404

      LocaSanta Cruz:Entry14 \ -2.496667 1.1202191 744 -2.228731 \ 0.0261

      LocaTiucal:Entry14 \ \ \ \ \ \ 0.830000 1.1202191 744 \ 0.740926
      \ 0.4590

      LocaTlaltizapan:Entry14 -2.313333 1.1202191 744 -2.065072 \ 0.0393

      LocaToco:Entry14 \ \ \ \ \ \ \ -0.216667 1.1202191 744 -0.193415
      \ 0.8467

      LocaYoro:Entry14 \ \ \ \ \ \ \ \ 0.263333 1.1202191 744 \ 0.235073
      \ 0.8142

      LocaCotaxtla:Entry15 \ \ \ -0.010000 1.1202191 744 -0.008927 \ 0.9929

      LocaIguala:Entry15 \ \ \ \ \ -0.763333 1.1202191 744 -0.681414 \ 0.4958

      LocaManagua:Entry15 \ \ \ \ -0.453333 1.1202191 744 -0.404683 \ 0.6858

      LocaPalmira :Entry15 \ \ \ -0.496667 1.1202191 744 -0.443366 \ 0.6576

      LocaSabana :Entry15 \ \ \ \ -0.046667 1.1202191 744 -0.041659 \ 0.9668

      LocaSan Andres:Entry15 \ \ 0.003333 1.1202191 744 \ 0.002976 \ 0.9976

      LocaSanta Cruz:Entry15 \ -0.956667 1.1202191 744 -0.854000 \ 0.3934

      LocaTiucal:Entry15 \ \ \ \ \ \ 0.890000 1.1202191 744 \ 0.794487
      \ 0.4272

      LocaTlaltizapan:Entry15 \ 0.963333 1.1202191 744 \ 0.859951 \ 0.3901

      LocaToco:Entry15 \ \ \ \ \ \ \ \ 0.290000 1.1202191 744 \ 0.258878
      \ 0.7958

      LocaYoro:Entry15 \ \ \ \ \ \ \ -0.356667 1.1202191 744 -0.318390
      \ 0.7503

      LocaCotaxtla:Entry16 \ \ \ -1.376667 1.1202191 744 -1.228926 \ 0.2195

      LocaIguala:Entry16 \ \ \ \ \ -0.846667 1.1202191 744 -0.755805 \ 0.4500

      LocaManagua:Entry16 \ \ \ \ -0.523333 1.1202191 744 -0.467170 \ 0.6405

      \ [ reached getOption("max.print") -- omitted 184 rows ]

      \ Correlation:\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (Intr) LcCtxt LocIgl
      LocMng LcPlmr LocSbn LcSnAn

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ -0.707
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcSntC LocTcl LcTllt
      LocaTc LocaYr Entry2 Entry3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entry4 Entry5 Entry6
      Entry7 Entry8 Entry9 Entr10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr11 Entr12 Entr13
      Entr14 Entr15 Entr16 Entr17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr18 Entr19 Entr20
      Entr21 Entr22 Entr23 Entr24

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr25 Entr26 Entr27
      Entr28 Entr29 Entr30 Entr31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr32 LcC:E2 LcI:E2
      LcM:E2 LcP:E2 LcS:E2 LcSA:E2

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcSC:E2 LcTcl:E2
      LcTl:E2 LcTc:En2 LcY:E2 LcC:E3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcI:E3 LcM:E3 LcP:E3
      LcS:E3 LcSA:E3 LcSC:E3 LcTcl:E3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E3 LcTc:En3 LcY:E3
      LcC:E4 LcI:E4 LcM:E4 LcP:E4

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcS:E4 LSA:E4 LSC:E4
      LcTcl:E4 LcTl:E4 LcTc:En4 LcY:E4

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcC:E5 LcI:E5 LcM:E5
      LcP:E5 LcS:E5 LSA:E5 LSC:E5

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTcl:E5 LcTl:E5
      LcTc:En5 LcY:E5 LcC:E6 LcI:E6 LcM:E6

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcP:E6 LcS:E6 LSA:E6
      LSC:E6 LcTcl:E6 LcTl:E6 LcTc:En6

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcY:E6 LcC:E7 LcI:E7
      LcM:E7 LcP:E7 LcS:E7 LSA:E7

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E7 LcTcl:E7 LcTl:E7
      LcTc:En7 LcY:E7 LcC:E8 LcI:E8

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcM:E8 LcP:E8 LcS:E8
      LSA:E8 LSC:E8 LcTcl:E8 LcTl:E8

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTc:En8 LcY:E8 LcC:E9
      LcI:E9 LcM:E9 LcP:E9 LcS:E9

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSA:E9 LSC:E9 LcTcl:E9
      LcTl:E9 LcTc:En9 LcY:E9 LC:E10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E10 LM:E10 LP:E10
      LS:E10 LSA:E10 LSC:E10 LcTcl:E10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E10 LcTc:En10
      LY:E10 LC:E11 LI:E11 LM:E11 LP:E11

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E11 LSA:E11 LSC:E11
      LcTcl:E11 LcTl:E11 LcTc:En11

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E11 LC:E12 LI:E12
      LM:E12 LP:E12 LS:E12 LSA:E12

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E12 LcTcl:E12
      LcTl:E12 LcTc:En12 LY:E12 LC:E13

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E13 LM:E13 LP:E13
      LS:E13 LSA:E13 LSC:E13 LcTcl:E13

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E13 LcTc:En13
      LY:E13 LC:E14 LI:E14 LM:E14 LP:E14

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E14 LSA:E14 LSC:E14
      LcTcl:E14 LcTl:E14 LcTc:En14

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E14 LC:E15 LI:E15
      LM:E15 LP:E15 LS:E15 LSA:E15

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E15 LcTcl:E15
      LcTl:E15 LcTc:En15 LY:E15 LC:E16

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E16 LM:E16 LP:E16
      LS:E16 LSA:E16 LSC:E16 LcTcl:E16

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E16 LcTc:En16
      LY:E16 LC:E17 LI:E17 LM:E17 LP:E17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E17 LSA:E17 LSC:E17
      LcTcl:E17 LcTl:E17 LcTc:En17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E17 LC:E18 LI:E18
      LM:E18 LP:E18 LS:E18 LSA:E18

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E18 LcTcl:E18
      LcTl:E18 LcTc:En18 LY:E18 LC:E19

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E19 LM:E19 LP:E19
      LS:E19 LSA:E19 LSC:E19 LcTcl:E19

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E19 LcTc:En19
      LY:E19 LC:E20 LI:E20 LM:E20 LP:E20

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E20 LSA:E20 LSC:E20
      LcTcl:E20 LcTl:E20 LcTc:En20

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E20 LC:E21 LI:E21
      LM:E21 LP:E21 LS:E21 LSA:E21

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E21 LcTcl:E21
      LcTl:E21 LcTc:En21 LY:E21 LC:E22

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E22 LM:E22 LP:E22
      LS:E22 LSA:E22 LSC:E22 LcTcl:E22

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E22 LcTc:En22
      LY:E22 LC:E23 LI:E23 LM:E23 LP:E23

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E23 LSA:E23 LSC:E23
      LcTcl:E23 LcTl:E23 LcTc:En23

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E23 LC:E24 LI:E24
      LM:E24 LP:E24 LS:E24 LSA:E24

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E24 LcTcl:E24
      LcTl:E24 LcTc:En24 LY:E24 LC:E25

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E25 LM:E25 LP:E25
      LS:E25 LSA:E25 LSC:E25 LcTcl:E25

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E25 LcTc:En25
      LY:E25 LC:E26 LI:E26 LM:E26 LP:E26

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E26 LSA:E26 LSC:E26
      LcTcl:E26 LcTl:E26 LcTc:En26

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E26 LC:E27 LI:E27
      LM:E27 LP:E27 LS:E27 LSA:E27

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E27 LcTcl:E27
      LcTl:E27 LcTc:En27 LY:E27 LC:E28

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E28 LM:E28 LP:E28
      LS:E28 LSA:E28 LSC:E28 LcTcl:E28

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E28 LcTc:En28
      LY:E28 LC:E29 LI:E29 LM:E29 LP:E29

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E29 LSA:E29 LSC:E29
      LcTcl:E29 LcTl:E29 LcTc:En29

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E29 LC:E30 LI:E30
      LM:E30 LP:E30 LS:E30 LSA:E30

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E30 LcTcl:E30
      LcTl:E30 LcTc:En30 LY:E30 LC:E31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E31 LM:E31 LP:E31
      LS:E31 LSA:E31 LSC:E31 LcTcl:E31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E31 LcTc:En31
      LY:E31 LC:E32 LI:E32 LM:E32 LP:E32

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E32 LSA:E32 LSC:E32
      LcTcl:E32 LcTl:E32 LcTc:En32

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ [ reached getOption("max.print") -- omitted 381 rows ]

      \;

      Standardized Within-Group Residuals:

      \ \ \ \ \ \ \ \ Min \ \ \ \ \ \ \ \ \ Q1 \ \ \ \ \ \ \ \ Med
      \ \ \ \ \ \ \ \ \ Q3 \ \ \ \ \ \ \ \ Max\ 

      -4.01058152 -0.43152425 -0.02333939 \ 0.43570289 \ 3.92656128\ 

      \;

      Number of Observations: 1152

      Number of Groups: 36\ 

      \<gtr\> meta.lme.summary \<less\>- summaryRprof("meta.lme.prof")

      \<gtr\> head(meta.lme.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time total.pct

      ".C" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.28 \ \ \ 92.63 \ \ \ \ \ \ 6.28
      \ \ \ \ 92.63

      "match.fun" \ \ \ \ \ \ \ \ \ 0.14 \ \ \ \ 2.06 \ \ \ \ \ \ 0.14
      \ \ \ \ \ 2.06

      "solve.default" \ \ \ \ \ 0.06 \ \ \ \ 0.88 \ \ \ \ \ \ 0.40
      \ \ \ \ \ 5.90

      "as.double" \ \ \ \ \ \ \ \ \ 0.06 \ \ \ \ 0.88 \ \ \ \ \ \ 0.06
      \ \ \ \ \ 0.88

      "crossprod" \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 0.59 \ \ \ \ \ \ 0.04
      \ \ \ \ \ 0.59

      "lme.formula" \ \ \ \ \ \ \ 0.02 \ \ \ \ 0.29 \ \ \ \ \ \ 6.78
      \ \ \ 100.00

      \<gtr\> head(meta.lme.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "lme.formula" \ \ \ \ \ \ 6.78 \ \ \ 100.00 \ \ \ \ \ 0.02 \ \ \ \ 0.29

      "lme" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.78 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      ".C" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.28 \ \ \ \ 92.63 \ \ \ \ \ 6.28
      \ \ \ 92.63

      "FUN" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 5.64 \ \ \ \ 83.19 \ \ \ \ \ 0.02
      \ \ \ \ 0.29

      "lapply" \ \ \ \ \ \ \ \ \ \ \ 5.26 \ \ \ \ 77.58 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "Initialize" \ \ \ \ \ \ \ 5.10 \ \ \ \ 75.22 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      \<gtr\> summary(cotes.lme)

      Linear mixed-effects model fit by REML

      \ Data: rcbd.dat\ 

      \ \ \ \ \ \ \ AIC \ \ \ BIC \ \ \ logLik

      \ \ 3108.315 4951.9 -1157.158

      \;

      Random effects:

      \ Formula: ~1 \| Block

      \ \ \ \ \ \ \ \ (Intercept) Residual

      StdDev: \ \ 0.2469055 0.673387

      \;

      Variance function:

      \ Structure: Different standard deviations per stratum

      \ Formula: ~Plot \| Loca\ 

      \ Parameter estimates:

      \ \ Agua Fria \ \ \ Cotaxtla \ \ \ \ \ Iguala \ \ \ \ Managua
      \ \ \ Palmira \ \ \ \ \ Sabana \ 

      \ \ 1.0000000 \ \ 0.8071041 \ \ 2.3342284 \ \ 0.8883137 \ \ 1.7008043
      \ \ 0.6831979\ 

      \ San Andres \ Santa Cruz \ \ \ \ \ Tiucal Tlaltizapan
      \ \ \ \ \ \ \ Toco \ \ \ \ \ \ \ Yoro\ 

      \ \ 0.6474379 \ \ 1.5408759 \ \ 1.1216128 \ \ 1.6909085 \ \ 2.6019884
      \ \ 0.9715357\ 

      Fixed effects: YLD ~ Loca * Entry\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Value Std.Error
      \ DF \ \ \ t-value p-value

      (Intercept) \ \ \ \ \ \ \ \ \ \ \ \ \ 6.160000 0.4140903 744
      \ 14.875983 \ 0.0000

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ 0.916667 0.5387515 \ 24
      \ \ 1.701465 \ 0.1018

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.836667 1.0076461 \ 24
      \ \ 2.815142 \ 0.0096

      LocaManagua \ \ \ \ \ \ \ \ \ \ \ \ -1.700000 0.5577313 \ 24
      \ -3.048063 \ 0.0055

      LocaPalmira \ \ \ \ \ \ \ \ \ \ \ \ \ 1.783333 0.7931132 \ 24
      \ \ 2.248523 \ 0.0340

      LocaSabana \ \ \ \ \ \ \ \ \ \ \ \ \ -5.240000 0.5121935 \ 24
      -10.230508 \ 0.0000

      LocaSan Andres \ \ \ \ \ \ \ \ \ -2.086667 0.5051237 \ 24 \ -4.131001
      \ 0.0004

      LocaSanta Cruz \ \ \ \ \ \ \ \ \ \ 1.213333 0.7420692 \ 24 \ \ 1.635068
      \ 0.1151

      LocaTiucal \ \ \ \ \ \ \ \ \ \ \ \ \ -3.483333 0.6180134 \ 24
      \ -5.636340 \ 0.0000

      LocaTlaltizapan \ \ \ \ \ \ \ \ \ 3.900000 0.7899084 \ 24 \ \ 4.937281
      \ 0.0000

      LocaToco \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.793333 1.1023289 \ 24
      \ \ 0.719688 \ 0.4787

      LocaYoro \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -2.643333 0.5783245 \ 24
      \ -4.570675 \ 0.0001

      Entry2 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.600000 0.5498181 744
      \ \ 1.091270 \ 0.2755

      Entry3 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.706667 0.5498181 744
      \ \ 1.285273 \ 0.1991

      Entry4 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.563333 0.5498181 744
      \ \ 1.024581 \ 0.3059

      Entry5 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.290000 0.5498181 744
      \ \ 2.346230 \ 0.0192

      Entry6 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.856667 0.5498181 744
      \ \ 1.558091 \ 0.1196

      Entry7 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.146667 0.5498181 744
      \ \ 0.266755 \ 0.7897

      Entry8 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.836667 0.5498181 744
      \ \ 3.340498 \ 0.0009

      Entry9 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.170000 0.5498181 744
      \ \ 0.309193 \ 0.7573

      Entry10 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.680000 0.5498181 744
      \ \ 1.236773 \ 0.2166

      Entry11 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.260000 0.5498181 744
      \ \ 4.110450 \ 0.0000

      Entry12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.860000 0.5498181 744
      \ \ 1.564154 \ 0.1182

      Entry13 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.213333 0.5498181 744
      \ \ 2.206790 \ 0.0276

      Entry14 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -1.480000 0.5498181 744
      \ -2.691799 \ 0.0073

      Entry15 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.270000 0.5498181 744
      \ \ 0.491071 \ 0.6235

      Entry16 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.270000 0.5498181 744
      \ -0.491071 \ 0.6235

      Entry17 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.916667 0.5498181 744
      \ \ 1.667218 \ 0.0959

      Entry18 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.433333 0.5498181 744
      \ \ 0.788139 \ 0.4309

      Entry19 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -1.750000 0.5498181 744
      \ -3.182871 \ 0.0015

      Entry20 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.706667 0.5498181 744
      \ \ 1.285273 \ 0.1991

      Entry21 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.303333 0.5498181 744
      \ -0.551698 \ 0.5813

      Entry22 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.560000 0.5498181 744
      \ \ 1.018519 \ 0.3088

      Entry23 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -2.186667 0.5498181 744
      \ -3.977073 \ 0.0001

      Entry24 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.573333 0.5498181 744
      \ \ 1.042769 \ 0.2974

      Entry25 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.116667 0.5498181 744
      \ -0.212191 \ 0.8320

      Entry26 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.470000 0.5498181 744
      \ \ 4.492394 \ 0.0000

      Entry27 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.976667 0.5498181 744
      \ \ 1.776345 \ 0.0761

      Entry28 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.090000 0.5498181 744
      \ \ 0.163690 \ 0.8700

      Entry29 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.143333 0.5498181 744
      \ \ 0.260692 \ 0.7944

      Entry30 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.496667 0.5498181 744
      \ -0.903329 \ 0.3666

      Entry31 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.800000 0.5498181 744
      \ \ 3.273810 \ 0.0011

      Entry32 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.140000 0.5498181 744
      \ \ 2.073413 \ 0.0385

      LocaCotaxtla:Entry2 \ \ \ \ -0.550000 0.7065574 744 \ -0.778422
      \ 0.4366

      LocaIguala:Entry2 \ \ \ \ \ \ \ 0.383333 1.3962158 744 \ \ 0.274552
      \ 0.7837

      LocaManagua:Entry2 \ \ \ \ \ -0.813333 0.7354219 744 \ -1.105941
      \ 0.2691

      LocaPalmira :Entry2 \ \ \ \ \ 0.473333 1.0847921 744 \ \ 0.436336
      \ 0.6627

      LocaSabana :Entry2 \ \ \ \ \ -0.420000 0.6658839 744 \ -0.630741
      \ 0.5284

      LocaSan Andres:Entry2 \ \ -0.606667 0.6549938 744 \ -0.926217 \ 0.3546

      LocaSanta Cruz:Entry2 \ \ \ 0.106667 1.0099754 744 \ \ 0.105613
      \ 0.9159

      LocaTiucal:Entry2 \ \ \ \ \ \ -1.283333 0.8261949 744 \ -1.553306
      \ 0.1208

      LocaTlaltizapan:Entry2 \ -0.900000 1.0801053 744 \ -0.833252 \ 0.4050

      LocaToco:Entry2 \ \ \ \ \ \ \ \ -0.883333 1.5326366 744 \ -0.576349
      \ 0.5646

      LocaYoro:Entry2 \ \ \ \ \ \ \ \ -0.453333 0.7665738 744 \ -0.591376
      \ 0.5544

      LocaCotaxtla:Entry3 \ \ \ \ \ 0.320000 0.7065574 744 \ \ 0.452900
      \ 0.6508

      LocaIguala:Entry3 \ \ \ \ \ \ \ 0.176667 1.3962158 744 \ \ 0.126532
      \ 0.8993

      LocaManagua:Entry3 \ \ \ \ \ -0.736667 0.7354219 744 \ -1.001693
      \ 0.3168

      LocaPalmira :Entry3 \ \ \ \ -0.150000 1.0847921 744 \ -0.138275
      \ 0.8901

      LocaSabana :Entry3 \ \ \ \ \ -0.350000 0.6658839 744 \ -0.525617
      \ 0.5993

      LocaSan Andres:Entry3 \ \ -0.440000 0.6549938 744 \ -0.671762 \ 0.5019

      LocaSanta Cruz:Entry3 \ \ -0.280000 1.0099754 744 \ -0.277234 \ 0.7817

      LocaTiucal:Entry3 \ \ \ \ \ \ \ 0.490000 0.8261949 744 \ \ 0.593080
      \ 0.5533

      LocaTlaltizapan:Entry3 \ \ 1.453333 1.0801053 744 \ \ 1.345548 \ 0.1789

      LocaToco:Entry3 \ \ \ \ \ \ \ \ \ 1.080000 1.5326366 744 \ \ 0.704668
      \ 0.4812

      LocaYoro:Entry3 \ \ \ \ \ \ \ \ \ 0.153333 0.7665738 744 \ \ 0.200024
      \ 0.8415

      LocaCotaxtla:Entry4 \ \ \ \ -0.910000 0.7065574 744 \ -1.287935
      \ 0.1982

      LocaIguala:Entry4 \ \ \ \ \ \ -0.100000 1.3962158 744 \ -0.071622
      \ 0.9429

      LocaManagua:Entry4 \ \ \ \ \ \ 0.350000 0.7354219 744 \ \ 0.475917
      \ 0.6343

      LocaPalmira :Entry4 \ \ \ \ \ 1.060000 1.0847921 744 \ \ 0.977146
      \ 0.3288

      LocaSabana :Entry4 \ \ \ \ \ -0.106667 0.6658839 744 \ -0.160188
      \ 0.8728

      LocaSan Andres:Entry4 \ \ -0.420000 0.6549938 744 \ -0.641227 \ 0.5216

      LocaSanta Cruz:Entry4 \ \ -0.983333 1.0099754 744 \ -0.973621 \ 0.3306

      LocaTiucal:Entry4 \ \ \ \ \ \ \ 0.000000 0.8261949 744 \ \ 0.000000
      \ 1.0000

      LocaTlaltizapan:Entry4 \ \ 1.836667 1.0801053 744 \ \ 1.700451 \ 0.0895

      LocaToco:Entry4 \ \ \ \ \ \ \ \ \ 0.553333 1.5326366 744 \ \ 0.361034
      \ 0.7182

      LocaYoro:Entry4 \ \ \ \ \ \ \ \ -0.583333 0.7665738 744 \ -0.760962
      \ 0.4469

      LocaCotaxtla:Entry5 \ \ \ \ -0.906667 0.7065574 744 \ -1.283217
      \ 0.1998

      LocaIguala:Entry5 \ \ \ \ \ \ \ 0.343333 1.3962158 744 \ \ 0.245903
      \ 0.8058

      LocaManagua:Entry5 \ \ \ \ \ -1.876667 0.7354219 744 \ -2.551823
      \ 0.0109

      LocaPalmira :Entry5 \ \ \ \ \ 0.356667 1.0847921 744 \ \ 0.328788
      \ 0.7424

      LocaSabana :Entry5 \ \ \ \ \ -1.376667 0.6658839 744 \ -2.067428
      \ 0.0390

      LocaSan Andres:Entry5 \ \ -1.436667 0.6549938 744 \ -2.193405 \ 0.0286

      LocaSanta Cruz:Entry5 \ \ -1.196667 1.0099754 744 \ -1.184847 \ 0.2365

      LocaTiucal:Entry5 \ \ \ \ \ \ -1.876667 0.8261949 744 \ -2.271458
      \ 0.0234

      LocaTlaltizapan:Entry5 \ \ 0.506667 1.0801053 744 \ \ 0.469090 \ 0.6391

      LocaToco:Entry5 \ \ \ \ \ \ \ \ \ 0.533333 1.5326366 744 \ \ 0.347984
      \ 0.7280

      LocaYoro:Entry5 \ \ \ \ \ \ \ \ -0.800000 0.7665738 744 \ -1.043605
      \ 0.2970

      LocaCotaxtla:Entry6 \ \ \ \ -1.476667 0.7065574 744 \ -2.089946
      \ 0.0370

      LocaIguala:Entry6 \ \ \ \ \ \ -0.350000 1.3962158 744 \ -0.250678
      \ 0.8021

      LocaManagua:Entry6 \ \ \ \ \ -0.146667 0.7354219 744 \ -0.199432
      \ 0.8420

      LocaPalmira :Entry6 \ \ \ \ \ 0.200000 1.0847921 744 \ \ 0.184367
      \ 0.8538

      LocaSabana :Entry6 \ \ \ \ \ -0.430000 0.6658839 744 \ -0.645758
      \ 0.5186

      LocaSan Andres:Entry6 \ \ -0.663333 0.6549938 744 \ -1.012732 \ 0.3115

      LocaSanta Cruz:Entry6 \ \ \ 0.093333 1.0099754 744 \ \ 0.092411
      \ 0.9264

      LocaTiucal:Entry6 \ \ \ \ \ \ -0.563333 0.8261949 744 \ -0.681841
      \ 0.4956

      LocaTlaltizapan:Entry6 \ \ 1.106667 1.0801053 744 \ \ 1.024591 \ 0.3059

      LocaToco:Entry6 \ \ \ \ \ \ \ \ -0.436667 1.5326366 744 \ -0.284912
      \ 0.7758

      LocaYoro:Entry6 \ \ \ \ \ \ \ \ -0.220000 0.7665738 744 \ -0.286991
      \ 0.7742

      LocaCotaxtla:Entry7 \ \ \ \ -1.040000 0.7065574 744 \ -1.471926
      \ 0.1415

      LocaIguala:Entry7 \ \ \ \ \ \ \ 1.423333 1.3962158 744 \ \ 1.019422
      \ 0.3083

      LocaManagua:Entry7 \ \ \ \ \ -0.696667 0.7354219 744 \ -0.947302
      \ 0.3438

      LocaPalmira :Entry7 \ \ \ \ \ 0.043333 1.0847921 744 \ \ 0.039946
      \ 0.9681

      LocaSabana :Entry7 \ \ \ \ \ -0.143333 0.6658839 744 \ -0.215253
      \ 0.8296

      LocaSan Andres:Entry7 \ \ -0.116667 0.6549938 744 \ -0.178119 \ 0.8587

      LocaSanta Cruz:Entry7 \ \ -0.050000 1.0099754 744 \ -0.049506 \ 0.9605

      LocaTiucal:Entry7 \ \ \ \ \ \ -0.476667 0.8261949 744 \ -0.576942
      \ 0.5642

      LocaTlaltizapan:Entry7 \ -0.290000 1.0801053 744 \ -0.268492 \ 0.7884

      LocaToco:Entry7 \ \ \ \ \ \ \ \ -0.570000 1.5326366 744 \ -0.371908
      \ 0.7101

      LocaYoro:Entry7 \ \ \ \ \ \ \ \ -0.713333 0.7665738 744 \ -0.930547
      \ 0.3524

      LocaCotaxtla:Entry8 \ \ \ \ -0.910000 0.7065574 744 \ -1.287935
      \ 0.1982

      LocaIguala:Entry8 \ \ \ \ \ \ -0.760000 1.3962158 744 \ -0.544328
      \ 0.5864

      LocaManagua:Entry8 \ \ \ \ \ -2.170000 0.7354219 744 \ -2.950687
      \ 0.0033

      LocaPalmira :Entry8 \ \ \ \ \ 0.423333 1.0847921 744 \ \ 0.390244
      \ 0.6965

      LocaSabana :Entry8 \ \ \ \ \ -1.866667 0.6658839 744 \ -2.803292
      \ 0.0052

      LocaSan Andres:Entry8 \ \ -1.733333 0.6549938 744 \ -2.646336 \ 0.0083

      LocaSanta Cruz:Entry8 \ \ -1.623333 1.0099754 744 \ -1.607300 \ 0.1084

      LocaTiucal:Entry8 \ \ \ \ \ \ -2.726667 0.8261949 744 \ -3.300270
      \ 0.0010

      LocaTlaltizapan:Entry8 \ \ 1.083333 1.0801053 744 \ \ 1.002989 \ 0.3162

      LocaToco:Entry8 \ \ \ \ \ \ \ \ -1.260000 1.5326366 744 \ -0.822113
      \ 0.4113

      LocaYoro:Entry8 \ \ \ \ \ \ \ \ -1.240000 0.7665738 744 \ -1.617587
      \ 0.1062

      LocaCotaxtla:Entry9 \ \ \ \ -1.126667 0.7065574 744 \ -1.594586
      \ 0.1112

      LocaIguala:Entry9 \ \ \ \ \ \ -0.493333 1.3962158 744 \ -0.353336
      \ 0.7239

      LocaManagua:Entry9 \ \ \ \ \ \ 0.283333 0.7354219 744 \ \ 0.385266
      \ 0.7002

      LocaPalmira :Entry9 \ \ \ \ \ 0.216667 1.0847921 744 \ \ 0.199731
      \ 0.8417

      LocaSabana :Entry9 \ \ \ \ \ -0.086667 0.6658839 744 \ -0.130153
      \ 0.8965

      LocaSan Andres:Entry9 \ \ -2.250000 0.6549938 744 \ -3.435147 \ 0.0006

      LocaSanta Cruz:Entry9 \ \ -2.383333 1.0099754 744 \ -2.359793 \ 0.0185

      LocaTiucal:Entry9 \ \ \ \ \ \ -0.563333 0.8261949 744 \ -0.681841
      \ 0.4956

      LocaTlaltizapan:Entry9 \ \ 1.610000 1.0801053 744 \ \ 1.490595 \ 0.1365

      LocaToco:Entry9 \ \ \ \ \ \ \ \ \ 0.076667 1.5326366 744 \ \ 0.050023
      \ 0.9601

      LocaYoro:Entry9 \ \ \ \ \ \ \ \ -0.193333 0.7665738 744 \ -0.252204
      \ 0.8010

      LocaCotaxtla:Entry10 \ \ \ -0.416667 0.7065574 744 \ -0.589714 \ 0.5556

      LocaIguala:Entry10 \ \ \ \ \ \ 0.523333 1.3962158 744 \ \ 0.374823
      \ 0.7079

      LocaManagua:Entry10 \ \ \ \ \ 0.630000 0.7354219 744 \ \ 0.856651
      \ 0.3919

      LocaPalmira :Entry10 \ \ \ \ 0.593333 1.0847921 744 \ \ 0.546956
      \ 0.5846

      LocaSabana :Entry10 \ \ \ \ -0.596667 0.6658839 744 \ -0.896052
      \ 0.3705

      LocaSan Andres:Entry10 \ -2.243333 0.6549938 744 \ -3.424969 \ 0.0006

      LocaSanta Cruz:Entry10 \ -0.970000 1.0099754 744 \ -0.960419 \ 0.3372

      LocaTiucal:Entry10 \ \ \ \ \ -0.310000 0.8261949 744 \ -0.375214
      \ 0.7076

      LocaTlaltizapan:Entry10 \ 1.866667 1.0801053 744 \ \ 1.728227 \ 0.0844

      LocaToco:Entry10 \ \ \ \ \ \ \ -0.983333 1.5326366 744 \ -0.641596
      \ 0.5213

      LocaYoro:Entry10 \ \ \ \ \ \ \ -0.520000 0.7665738 744 \ -0.678343
      \ 0.4978

      LocaCotaxtla:Entry11 \ \ \ -1.343333 0.7065574 744 \ -1.901237 \ 0.0577

      LocaIguala:Entry11 \ \ \ \ \ -1.170000 1.3962158 744 \ -0.837979
      \ 0.4023

      LocaManagua:Entry11 \ \ \ \ -1.716667 0.7354219 744 \ -2.334261
      \ 0.0198

      LocaPalmira :Entry11 \ \ \ -1.763333 1.0847921 744 \ -1.625504 \ 0.1045

      LocaSabana :Entry11 \ \ \ \ -1.360000 0.6658839 744 \ -2.042398
      \ 0.0415

      LocaSan Andres:Entry11 \ -1.580000 0.6549938 744 \ -2.412237 \ 0.0161

      LocaSanta Cruz:Entry11 \ -1.903333 1.0099754 744 \ -1.884534 \ 0.0599

      LocaTiucal:Entry11 \ \ \ \ \ -2.560000 0.8261949 744 \ -3.098542
      \ 0.0020

      LocaTlaltizapan:Entry11 \ 1.076667 1.0801053 744 \ \ 0.996816 \ 0.3192

      LocaToco:Entry11 \ \ \ \ \ \ \ -2.086667 1.5326366 744 \ -1.361488
      \ 0.1738

      LocaYoro:Entry11 \ \ \ \ \ \ \ -0.330000 0.7665738 744 \ -0.430487
      \ 0.6670

      LocaCotaxtla:Entry12 \ \ \ -1.100000 0.7065574 744 \ -1.556844 \ 0.1199

      LocaIguala:Entry12 \ \ \ \ \ -1.750000 1.3962158 744 \ -1.253388
      \ 0.2105

      LocaManagua:Entry12 \ \ \ \ -0.186667 0.7354219 744 \ -0.253823
      \ 0.7997

      LocaPalmira :Entry12 \ \ \ -0.393333 1.0847921 744 \ -0.362589 \ 0.7170

      LocaSabana :Entry12 \ \ \ \ -0.550000 0.6658839 744 \ -0.825970
      \ 0.4091

      LocaSan Andres:Entry12 \ -1.783333 0.6549938 744 \ -2.722672 \ 0.0066

      LocaSanta Cruz:Entry12 \ -1.636667 1.0099754 744 \ -1.620501 \ 0.1055

      LocaTiucal:Entry12 \ \ \ \ \ -0.983333 0.8261949 744 \ -1.190195
      \ 0.2343

      LocaTlaltizapan:Entry12 \ 0.690000 1.0801053 744 \ \ 0.638827 \ 0.5231

      LocaToco:Entry12 \ \ \ \ \ \ \ \ 0.776667 1.5326366 744 \ \ 0.506752
      \ 0.6125

      LocaYoro:Entry12 \ \ \ \ \ \ \ -1.313333 0.7665738 744 \ -1.713251
      \ 0.0871

      LocaCotaxtla:Entry13 \ \ \ -0.806667 0.7065574 744 \ -1.141686 \ 0.2540

      LocaIguala:Entry13 \ \ \ \ \ \ 0.656667 1.3962158 744 \ \ 0.470319
      \ 0.6383

      LocaManagua:Entry13 \ \ \ \ -1.060000 0.7354219 744 \ -1.441350
      \ 0.1499

      LocaPalmira :Entry13 \ \ \ -1.213333 1.0847921 744 \ -1.118494 \ 0.2637

      LocaSabana :Entry13 \ \ \ \ -1.050000 0.6658839 744 \ -1.576852
      \ 0.1153

      LocaSan Andres:Entry13 \ -2.393333 0.6549938 744 \ -3.653979 \ 0.0003

      LocaSanta Cruz:Entry13 \ -0.923333 1.0099754 744 \ -0.914214 \ 0.3609

      LocaTiucal:Entry13 \ \ \ \ \ -2.120000 0.8261949 744 \ -2.565980
      \ 0.0105

      LocaTlaltizapan:Entry13 \ 1.426667 1.0801053 744 \ \ 1.320859 \ 0.1870

      LocaToco:Entry13 \ \ \ \ \ \ \ -1.773333 1.5326366 744 \ -1.157048
      \ 0.2476

      LocaYoro:Entry13 \ \ \ \ \ \ \ -1.460000 0.7665738 744 \ -1.904578
      \ 0.0572

      LocaCotaxtla:Entry14 \ \ \ -2.670000 0.7065574 744 \ -3.778886 \ 0.0002

      LocaIguala:Entry14 \ \ \ \ \ -1.620000 1.3962158 744 \ -1.160279
      \ 0.2463

      LocaManagua:Entry14 \ \ \ \ \ 1.026667 0.7354219 744 \ \ 1.396024
      \ 0.1631

      LocaPalmira :Entry14 \ \ \ -2.086667 1.0847921 744 \ -1.923564 \ 0.0548

      LocaSabana :Entry14 \ \ \ \ \ 1.386667 0.6658839 744 \ \ 2.082445
      \ 0.0376

      LocaSan Andres:Entry14 \ -1.653333 0.6549938 744 \ -2.524197 \ 0.0118

      LocaSanta Cruz:Entry14 \ -2.496667 1.0099754 744 \ -2.472007 \ 0.0137

      LocaTiucal:Entry14 \ \ \ \ \ \ 0.830000 0.8261949 744 \ \ 1.004606
      \ 0.3154

      LocaTlaltizapan:Entry14 -2.313333 1.0801053 744 \ -2.141766 \ 0.0325

      LocaToco:Entry14 \ \ \ \ \ \ \ -0.216667 1.5326366 744 \ -0.141369
      \ 0.8876

      LocaYoro:Entry14 \ \ \ \ \ \ \ \ 0.263333 0.7665738 744 \ \ 0.343520
      \ 0.7313

      LocaCotaxtla:Entry15 \ \ \ -0.010000 0.7065574 744 \ -0.014153 \ 0.9887

      LocaIguala:Entry15 \ \ \ \ \ -0.763333 1.3962158 744 \ -0.546716
      \ 0.5847

      LocaManagua:Entry15 \ \ \ \ -0.453333 0.7354219 744 \ -0.616426
      \ 0.5378

      LocaPalmira :Entry15 \ \ \ -0.496667 1.0847921 744 \ -0.457845 \ 0.6472

      LocaSabana :Entry15 \ \ \ \ -0.046667 0.6658839 744 \ -0.070082
      \ 0.9441

      LocaSan Andres:Entry15 \ \ 0.003333 0.6549938 744 \ \ 0.005089 \ 0.9959

      LocaSanta Cruz:Entry15 \ -0.956667 1.0099754 744 \ -0.947218 \ 0.3438

      LocaTiucal:Entry15 \ \ \ \ \ \ 0.890000 0.8261949 744 \ \ 1.077228
      \ 0.2817

      LocaTlaltizapan:Entry15 \ 0.963333 1.0801053 744 \ \ 0.891888 \ 0.3727

      LocaToco:Entry15 \ \ \ \ \ \ \ \ 0.290000 1.5326366 744 \ \ 0.189216
      \ 0.8500

      LocaYoro:Entry15 \ \ \ \ \ \ \ -0.356667 0.7665738 744 \ -0.465274
      \ 0.6419

      LocaCotaxtla:Entry16 \ \ \ -1.376667 0.7065574 744 \ -1.948414 \ 0.0517

      LocaIguala:Entry16 \ \ \ \ \ -0.846667 1.3962158 744 \ -0.606401
      \ 0.5444

      LocaManagua:Entry16 \ \ \ \ -0.523333 0.7354219 744 \ -0.711610
      \ 0.4769

      \ [ reached getOption("max.print") -- omitted 184 rows ]

      \ Correlation:\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (Intr) LcCtxt LocIgl
      LocMng LcPlmr LocSbn LcSnAn

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ -0.769
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ -0.411 \ 0.316
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcSntC LocTcl LcTllt
      LocaTc LocaYr Entry2 Entry3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entry4 Entry5 Entry6
      Entry7 Entry8 Entry9 Entr10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr11 Entr12 Entr13
      Entr14 Entr15 Entr16 Entr17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr18 Entr19 Entr20
      Entr21 Entr22 Entr23 Entr24

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr25 Entr26 Entr27
      Entr28 Entr29 Entr30 Entr31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr32 LcC:E2 LcI:E2
      LcM:E2 LcP:E2 LcS:E2 LcSA:E2

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcSC:E2 LcTcl:E2
      LcTl:E2 LcTc:En2 LcY:E2 LcC:E3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcI:E3 LcM:E3 LcP:E3
      LcS:E3 LcSA:E3 LcSC:E3 LcTcl:E3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E3 LcTc:En3 LcY:E3
      LcC:E4 LcI:E4 LcM:E4 LcP:E4

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcS:E4 LSA:E4 LSC:E4
      LcTcl:E4 LcTl:E4 LcTc:En4 LcY:E4

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcC:E5 LcI:E5 LcM:E5
      LcP:E5 LcS:E5 LSA:E5 LSC:E5

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTcl:E5 LcTl:E5
      LcTc:En5 LcY:E5 LcC:E6 LcI:E6 LcM:E6

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcP:E6 LcS:E6 LSA:E6
      LSC:E6 LcTcl:E6 LcTl:E6 LcTc:En6

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcY:E6 LcC:E7 LcI:E7
      LcM:E7 LcP:E7 LcS:E7 LSA:E7

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E7 LcTcl:E7 LcTl:E7
      LcTc:En7 LcY:E7 LcC:E8 LcI:E8

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcM:E8 LcP:E8 LcS:E8
      LSA:E8 LSC:E8 LcTcl:E8 LcTl:E8

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTc:En8 LcY:E8 LcC:E9
      LcI:E9 LcM:E9 LcP:E9 LcS:E9

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSA:E9 LSC:E9 LcTcl:E9
      LcTl:E9 LcTc:En9 LcY:E9 LC:E10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E10 LM:E10 LP:E10
      LS:E10 LSA:E10 LSC:E10 LcTcl:E10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E10 LcTc:En10
      LY:E10 LC:E11 LI:E11 LM:E11 LP:E11

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E11 LSA:E11 LSC:E11
      LcTcl:E11 LcTl:E11 LcTc:En11

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E11 LC:E12 LI:E12
      LM:E12 LP:E12 LS:E12 LSA:E12

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E12 LcTcl:E12
      LcTl:E12 LcTc:En12 LY:E12 LC:E13

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E13 LM:E13 LP:E13
      LS:E13 LSA:E13 LSC:E13 LcTcl:E13

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E13 LcTc:En13
      LY:E13 LC:E14 LI:E14 LM:E14 LP:E14

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E14 LSA:E14 LSC:E14
      LcTcl:E14 LcTl:E14 LcTc:En14

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E14 LC:E15 LI:E15
      LM:E15 LP:E15 LS:E15 LSA:E15

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E15 LcTcl:E15
      LcTl:E15 LcTc:En15 LY:E15 LC:E16

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E16 LM:E16 LP:E16
      LS:E16 LSA:E16 LSC:E16 LcTcl:E16

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E16 LcTc:En16
      LY:E16 LC:E17 LI:E17 LM:E17 LP:E17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E17 LSA:E17 LSC:E17
      LcTcl:E17 LcTl:E17 LcTc:En17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E17 LC:E18 LI:E18
      LM:E18 LP:E18 LS:E18 LSA:E18

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E18 LcTcl:E18
      LcTl:E18 LcTc:En18 LY:E18 LC:E19

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E19 LM:E19 LP:E19
      LS:E19 LSA:E19 LSC:E19 LcTcl:E19

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E19 LcTc:En19
      LY:E19 LC:E20 LI:E20 LM:E20 LP:E20

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E20 LSA:E20 LSC:E20
      LcTcl:E20 LcTl:E20 LcTc:En20

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E20 LC:E21 LI:E21
      LM:E21 LP:E21 LS:E21 LSA:E21

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E21 LcTcl:E21
      LcTl:E21 LcTc:En21 LY:E21 LC:E22

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E22 LM:E22 LP:E22
      LS:E22 LSA:E22 LSC:E22 LcTcl:E22

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E22 LcTc:En22
      LY:E22 LC:E23 LI:E23 LM:E23 LP:E23

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E23 LSA:E23 LSC:E23
      LcTcl:E23 LcTl:E23 LcTc:En23

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E23 LC:E24 LI:E24
      LM:E24 LP:E24 LS:E24 LSA:E24

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E24 LcTcl:E24
      LcTl:E24 LcTc:En24 LY:E24 LC:E25

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E25 LM:E25 LP:E25
      LS:E25 LSA:E25 LSC:E25 LcTcl:E25

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E25 LcTc:En25
      LY:E25 LC:E26 LI:E26 LM:E26 LP:E26

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E26 LSA:E26 LSC:E26
      LcTcl:E26 LcTl:E26 LcTc:En26

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E26 LC:E27 LI:E27
      LM:E27 LP:E27 LS:E27 LSA:E27

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E27 LcTcl:E27
      LcTl:E27 LcTc:En27 LY:E27 LC:E28

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E28 LM:E28 LP:E28
      LS:E28 LSA:E28 LSC:E28 LcTcl:E28

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E28 LcTc:En28
      LY:E28 LC:E29 LI:E29 LM:E29 LP:E29

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E29 LSA:E29 LSC:E29
      LcTcl:E29 LcTl:E29 LcTc:En29

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E29 LC:E30 LI:E30
      LM:E30 LP:E30 LS:E30 LSA:E30

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E30 LcTcl:E30
      LcTl:E30 LcTc:En30 LY:E30 LC:E31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E31 LM:E31 LP:E31
      LS:E31 LSA:E31 LSC:E31 LcTcl:E31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E31 LcTc:En31
      LY:E31 LC:E32 LI:E32 LM:E32 LP:E32

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E32 LSA:E32 LSC:E32
      LcTcl:E32 LcTl:E32 LcTc:En32

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ [ reached getOption("max.print") -- omitted 381 rows ]

      \;

      Standardized Within-Group Residuals:

      \ \ \ \ \ \ \ \ Min \ \ \ \ \ \ \ \ \ Q1 \ \ \ \ \ \ \ \ Med
      \ \ \ \ \ \ \ \ \ Q3 \ \ \ \ \ \ \ \ Max\ 

      -2.62533380 -0.54317389 -0.02509418 \ 0.53698264 \ 3.70346569\ 

      \;

      Number of Observations: 1152

      Number of Groups: 36\ 

      \<gtr\> cotes.lme.summary \<less\>- summaryRprof("cotes.lme.prof")

      \<gtr\> head(cotes.lme.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      ".C" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 105.30 \ \ \ 89.68 \ \ \ \ 105.30
      \ \ \ \ 89.68

      "recalc.varFunc" \ \ \ \ \ \ 5.32 \ \ \ \ 4.53 \ \ \ \ \ \ 5.40
      \ \ \ \ \ 4.60

      "as.double" \ \ \ \ \ \ \ \ \ \ \ 3.14 \ \ \ \ 2.67 \ \ \ \ \ \ 3.14
      \ \ \ \ \ 2.67

      "is.finite" \ \ \ \ \ \ \ \ \ \ \ 1.18 \ \ \ \ 1.00 \ \ \ \ \ \ 1.18
      \ \ \ \ \ 1.00

      "logLik.reStruct" \ \ \ \ \ 0.88 \ \ \ \ 0.75 \ \ \ \ \ 89.58
      \ \ \ \ 76.29

      "getwd" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.42 \ \ \ \ 0.36
      \ \ \ \ \ \ 0.42 \ \ \ \ \ 0.36

      \<gtr\> head(cotes.lme.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "lme" \ \ \ \ \ \ \ \ \ \ \ \ 117.42 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "lme.formula" \ \ \ \ 117.42 \ \ \ 100.00 \ \ \ \ \ 0.00 \ \ \ \ 0.00

      ".C" \ \ \ \ \ \ \ \ \ \ \ \ \ 105.30 \ \ \ \ 89.68 \ \ \ 105.30
      \ \ \ 89.68

      "recalc" \ \ \ \ \ \ \ \ \ \ 95.02 \ \ \ \ 80.92 \ \ \ \ \ 0.02
      \ \ \ \ 0.02

      "logLik" \ \ \ \ \ \ \ \ \ \ 94.94 \ \ \ \ 80.86 \ \ \ \ \ 0.02
      \ \ \ \ 0.02

      ".Call" \ \ \ \ \ \ \ \ \ \ \ 94.78 \ \ \ \ 80.72 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      \<gtr\>\ 
    </unfolded-prog-io|>

    \;

    <\textput>
      <\textput>
        <section|glmmPQL>
      </textput>

      \;
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(MASS)
    <|unfolded-prog-io>
      library(MASS)
    </unfolded-prog-io|>

    \;

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.glmmPQL.Rda")) {

      \ \ Rprof("meta.glmmPQL.prof")

      \ \ meta.glmmPQL \<less\>- glmmPQL(YLD ~ Loca*Entry, random = ~ 1 \|
      Block, data=rcbd.dat, family="gaussian")

      \ \ Rprof(NULL)

      \ \ save(meta.glmmPQL, file="meta.glmmPQL.Rda")

      \ } else {

      \ \ \ load(file="meta.glmmPQL.Rda")

      \ }

      summary(meta.glmmPQL)

      meta.glmmPQL.summary \<less\>- summaryRprof("meta.glmmPQL.prof")

      head(meta.glmmPQL.summary[[1]])

      head(meta.glmmPQL.summary[[2]])

      \;
    <|unfolded-prog-io>
      if(!file.exists("meta.glmmPQL.Rda")) {

      + \ \ Rprof("meta.glmmPQL.prof")

      + \ \ meta.glmmPQL \<less\>- glmmPQL(YLD ~ Loca*Entry, random = ~ 1 \|
      Block, data=rcbd

      \<less\>(YLD ~ Loca*Entry, random = ~ 1 \| Block, data=rcbd.dat,
      family="gaussian")

      + \ \ Rprof(NULL)

      + \ \ save(meta.glmmPQL, file="meta.glmmPQL.Rda")

      + \ } else {

      + \ \ \ load(file="meta.glmmPQL.Rda")

      + \ }

      \<gtr\> summary(meta.glmmPQL)

      Linear mixed-effects model fit by maximum likelihood

      \ Data: rcbd.dat\ 

      \ \ AIC BIC logLik

      \ \ \ NA \ NA \ \ \ \ NA

      \;

      Random effects:

      \ Formula: ~1 \| Block

      \ \ \ \ \ \ \ \ (Intercept) \ Residual

      StdDev: \ \ 0.3073135 0.7921145

      \;

      Variance function:

      \ Structure: fixed weights

      \ Formula: ~invwt\ 

      Fixed effects: YLD ~ Loca * Entry\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Value Std.Error
      \ DF \ \ t-value p-value

      (Intercept) \ \ \ \ \ \ \ \ \ \ \ \ \ 6.160000 0.6007858 744 10.253239
      \ 0.0000

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ 0.916667 0.8496394 \ 24 \ 1.078889
      \ 0.2914

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.836667 0.8496394 \ 24
      \ 3.338671 \ 0.0027

      LocaManagua \ \ \ \ \ \ \ \ \ \ \ \ -1.700000 0.8496394 \ 24 -2.000849
      \ 0.0568

      LocaPalmira \ \ \ \ \ \ \ \ \ \ \ \ \ 1.783333 0.8496394 \ 24
      \ 2.098930 \ 0.0465

      LocaSabana \ \ \ \ \ \ \ \ \ \ \ \ \ -5.240000 0.8496394 \ 24 -6.167323
      \ 0.0000

      LocaSan Andres \ \ \ \ \ \ \ \ \ -2.086667 0.8496394 \ 24 -2.455944
      \ 0.0217

      LocaSanta Cruz \ \ \ \ \ \ \ \ \ \ 1.213333 0.8496394 \ 24 \ 1.428057
      \ 0.1662

      LocaTiucal \ \ \ \ \ \ \ \ \ \ \ \ \ -3.483333 0.8496394 \ 24 -4.099779
      \ 0.0004

      LocaTlaltizapan \ \ \ \ \ \ \ \ \ 3.900000 0.8496394 \ 24 \ 4.590183
      \ 0.0001

      LocaToco \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.793333 0.8496394 \ 24
      \ 0.933730 \ 0.3597

      LocaYoro \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -2.643333 0.8496394 \ 24
      -3.111124 \ 0.0048

      Entry2 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.600000 0.7921145 744
      \ 0.757466 \ 0.4490

      Entry3 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.706667 0.7921145 744
      \ 0.892127 \ 0.3726

      Entry4 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.563333 0.7921145 744
      \ 0.711177 \ 0.4772

      Entry5 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.290000 0.7921145 744
      \ 1.628552 \ 0.1038

      Entry6 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.856667 0.7921145 744
      \ 1.081493 \ 0.2798

      Entry7 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.146667 0.7921145 744
      \ 0.185158 \ 0.8532

      Entry8 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.836667 0.7921145 744
      \ 2.318688 \ 0.0207

      Entry9 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.170000 0.7921145 744
      \ 0.214615 \ 0.8301

      Entry10 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.680000 0.7921145 744
      \ 0.858462 \ 0.3909

      Entry11 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.260000 0.7921145 744
      \ 2.853123 \ 0.0044

      Entry12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.860000 0.7921145 744
      \ 1.085702 \ 0.2780

      Entry13 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.213333 0.7921145 744
      \ 1.531765 \ 0.1260

      Entry14 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -1.480000 0.7921145 744
      -1.868417 \ 0.0621

      Entry15 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.270000 0.7921145 744
      \ 0.340860 \ 0.7333

      Entry16 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.270000 0.7921145 744
      -0.340860 \ 0.7333

      Entry17 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.916667 0.7921145 744
      \ 1.157240 \ 0.2475

      Entry18 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.433333 0.7921145 744
      \ 0.547059 \ 0.5845

      Entry19 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -1.750000 0.7921145 744
      -2.209276 \ 0.0275

      Entry20 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.706667 0.7921145 744
      \ 0.892127 \ 0.3726

      Entry21 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.303333 0.7921145 744
      -0.382941 \ 0.7019

      Entry22 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.560000 0.7921145 744
      \ 0.706968 \ 0.4798

      Entry23 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -2.186667 0.7921145 744
      -2.760543 \ 0.0059

      Entry24 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.573333 0.7921145 744
      \ 0.723801 \ 0.4694

      Entry25 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.116667 0.7921145 744
      -0.147285 \ 0.8829

      Entry26 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.470000 0.7921145 744
      \ 3.118236 \ 0.0019

      Entry27 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.976667 0.7921145 744
      \ 1.232987 \ 0.2180

      Entry28 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.090000 0.7921145 744
      \ 0.113620 \ 0.9096

      Entry29 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.143333 0.7921145 744
      \ 0.180950 \ 0.8565

      Entry30 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.496667 0.7921145 744
      -0.627014 \ 0.5308

      Entry31 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.800000 0.7921145 744
      \ 2.272399 \ 0.0233

      Entry32 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.140000 0.7921145 744
      \ 1.439186 \ 0.1505

      LocaCotaxtla:Entry2 \ \ \ \ -0.550000 1.1202191 744 -0.490975 \ 0.6236

      LocaIguala:Entry2 \ \ \ \ \ \ \ 0.383333 1.1202191 744 \ 0.342195
      \ 0.7323

      LocaManagua:Entry2 \ \ \ \ \ -0.813333 1.1202191 744 -0.726048 \ 0.4680

      LocaPalmira :Entry2 \ \ \ \ \ 0.473333 1.1202191 744 \ 0.422536
      \ 0.6728

      LocaSabana :Entry2 \ \ \ \ \ -0.420000 1.1202191 744 -0.374927 \ 0.7078

      LocaSan Andres:Entry2 \ \ -0.606667 1.1202191 744 -0.541561 \ 0.5883

      LocaSanta Cruz:Entry2 \ \ \ 0.106667 1.1202191 744 \ 0.095219 \ 0.9242

      LocaTiucal:Entry2 \ \ \ \ \ \ -1.283333 1.1202191 744 -1.145609
      \ 0.2523

      LocaTlaltizapan:Entry2 \ -0.900000 1.1202191 744 -0.803414 \ 0.4220

      LocaToco:Entry2 \ \ \ \ \ \ \ \ -0.883333 1.1202191 744 -0.788536
      \ 0.4306

      LocaYoro:Entry2 \ \ \ \ \ \ \ \ -0.453333 1.1202191 744 -0.404683
      \ 0.6858

      LocaCotaxtla:Entry3 \ \ \ \ \ 0.320000 1.1202191 744 \ 0.285658
      \ 0.7752

      LocaIguala:Entry3 \ \ \ \ \ \ \ 0.176667 1.1202191 744 \ 0.157707
      \ 0.8747

      LocaManagua:Entry3 \ \ \ \ \ -0.736667 1.1202191 744 -0.657609 \ 0.5110

      LocaPalmira :Entry3 \ \ \ \ -0.150000 1.1202191 744 -0.133902 \ 0.8935

      LocaSabana :Entry3 \ \ \ \ \ -0.350000 1.1202191 744 -0.312439 \ 0.7548

      LocaSan Andres:Entry3 \ \ -0.440000 1.1202191 744 -0.392780 \ 0.6946

      LocaSanta Cruz:Entry3 \ \ -0.280000 1.1202191 744 -0.249951 \ 0.8027

      LocaTiucal:Entry3 \ \ \ \ \ \ \ 0.490000 1.1202191 744 \ 0.437414
      \ 0.6619

      LocaTlaltizapan:Entry3 \ \ 1.453333 1.1202191 744 \ 1.297365 \ 0.1949

      LocaToco:Entry3 \ \ \ \ \ \ \ \ \ 1.080000 1.1202191 744 \ 0.964097
      \ 0.3353

      LocaYoro:Entry3 \ \ \ \ \ \ \ \ \ 0.153333 1.1202191 744 \ 0.136878
      \ 0.8912

      LocaCotaxtla:Entry4 \ \ \ \ -0.910000 1.1202191 744 -0.812341 \ 0.4169

      LocaIguala:Entry4 \ \ \ \ \ \ -0.100000 1.1202191 744 -0.089268
      \ 0.9289

      LocaManagua:Entry4 \ \ \ \ \ \ 0.350000 1.1202191 744 \ 0.312439
      \ 0.7548

      LocaPalmira :Entry4 \ \ \ \ \ 1.060000 1.1202191 744 \ 0.946243
      \ 0.3443

      LocaSabana :Entry4 \ \ \ \ \ -0.106667 1.1202191 744 -0.095219 \ 0.9242

      LocaSan Andres:Entry4 \ \ -0.420000 1.1202191 744 -0.374927 \ 0.7078

      LocaSanta Cruz:Entry4 \ \ -0.983333 1.1202191 744 -0.877804 \ 0.3803

      LocaTiucal:Entry4 \ \ \ \ \ \ \ 0.000000 1.1202191 744 \ 0.000000
      \ 1.0000

      LocaTlaltizapan:Entry4 \ \ 1.836667 1.1202191 744 \ 1.639560 \ 0.1015

      LocaToco:Entry4 \ \ \ \ \ \ \ \ \ 0.553333 1.1202191 744 \ 0.493951
      \ 0.6215

      LocaYoro:Entry4 \ \ \ \ \ \ \ \ -0.583333 1.1202191 744 -0.520731
      \ 0.6027

      LocaCotaxtla:Entry5 \ \ \ \ -0.906667 1.1202191 744 -0.809365 \ 0.4186

      LocaIguala:Entry5 \ \ \ \ \ \ \ 0.343333 1.1202191 744 \ 0.306488
      \ 0.7593

      LocaManagua:Entry5 \ \ \ \ \ -1.876667 1.1202191 744 -1.675267 \ 0.0943

      LocaPalmira :Entry5 \ \ \ \ \ 0.356667 1.1202191 744 \ 0.318390
      \ 0.7503

      LocaSabana :Entry5 \ \ \ \ \ -1.376667 1.1202191 744 -1.228926 \ 0.2195

      LocaSan Andres:Entry5 \ \ -1.436667 1.1202191 744 -1.282487 \ 0.2001

      LocaSanta Cruz:Entry5 \ \ -1.196667 1.1202191 744 -1.068243 \ 0.2858

      LocaTiucal:Entry5 \ \ \ \ \ \ -1.876667 1.1202191 744 -1.675267
      \ 0.0943

      LocaTlaltizapan:Entry5 \ \ 0.506667 1.1202191 744 \ 0.452292 \ 0.6512

      LocaToco:Entry5 \ \ \ \ \ \ \ \ \ 0.533333 1.1202191 744 \ 0.476097
      \ 0.6341

      LocaYoro:Entry5 \ \ \ \ \ \ \ \ -0.800000 1.1202191 744 -0.714146
      \ 0.4754

      LocaCotaxtla:Entry6 \ \ \ \ -1.476667 1.1202191 744 -1.318194 \ 0.1878

      LocaIguala:Entry6 \ \ \ \ \ \ -0.350000 1.1202191 744 -0.312439
      \ 0.7548

      LocaManagua:Entry6 \ \ \ \ \ -0.146667 1.1202191 744 -0.130927 \ 0.8959

      LocaPalmira :Entry6 \ \ \ \ \ 0.200000 1.1202191 744 \ 0.178536
      \ 0.8584

      LocaSabana :Entry6 \ \ \ \ \ -0.430000 1.1202191 744 -0.383853 \ 0.7012

      LocaSan Andres:Entry6 \ \ -0.663333 1.1202191 744 -0.592146 \ 0.5539

      LocaSanta Cruz:Entry6 \ \ \ 0.093333 1.1202191 744 \ 0.083317 \ 0.9336

      LocaTiucal:Entry6 \ \ \ \ \ \ -0.563333 1.1202191 744 -0.502878
      \ 0.6152

      LocaTlaltizapan:Entry6 \ \ 1.106667 1.1202191 744 \ 0.987902 \ 0.3235

      LocaToco:Entry6 \ \ \ \ \ \ \ \ -0.436667 1.1202191 744 -0.389805
      \ 0.6968

      LocaYoro:Entry6 \ \ \ \ \ \ \ \ -0.220000 1.1202191 744 -0.196390
      \ 0.8444

      LocaCotaxtla:Entry7 \ \ \ \ -1.040000 1.1202191 744 -0.928390 \ 0.3535

      LocaIguala:Entry7 \ \ \ \ \ \ \ 1.423333 1.1202191 744 \ 1.270585
      \ 0.2043

      LocaManagua:Entry7 \ \ \ \ \ -0.696667 1.1202191 744 -0.621902 \ 0.5342

      LocaPalmira :Entry7 \ \ \ \ \ 0.043333 1.1202191 744 \ 0.038683
      \ 0.9692

      LocaSabana :Entry7 \ \ \ \ \ -0.143333 1.1202191 744 -0.127951 \ 0.8982

      LocaSan Andres:Entry7 \ \ -0.116667 1.1202191 744 -0.104146 \ 0.9171

      LocaSanta Cruz:Entry7 \ \ -0.050000 1.1202191 744 -0.044634 \ 0.9644

      LocaTiucal:Entry7 \ \ \ \ \ \ -0.476667 1.1202191 744 -0.425512
      \ 0.6706

      LocaTlaltizapan:Entry7 \ -0.290000 1.1202191 744 -0.258878 \ 0.7958

      LocaToco:Entry7 \ \ \ \ \ \ \ \ -0.570000 1.1202191 744 -0.508829
      \ 0.6110

      LocaYoro:Entry7 \ \ \ \ \ \ \ \ -0.713333 1.1202191 744 -0.636780
      \ 0.5245

      LocaCotaxtla:Entry8 \ \ \ \ -0.910000 1.1202191 744 -0.812341 \ 0.4169

      LocaIguala:Entry8 \ \ \ \ \ \ -0.760000 1.1202191 744 -0.678439
      \ 0.4977

      LocaManagua:Entry8 \ \ \ \ \ -2.170000 1.1202191 744 -1.937121 \ 0.0531

      LocaPalmira :Entry8 \ \ \ \ \ 0.423333 1.1202191 744 \ 0.377902
      \ 0.7056

      LocaSabana :Entry8 \ \ \ \ \ -1.866667 1.1202191 744 -1.666341 \ 0.0961

      LocaSan Andres:Entry8 \ \ -1.733333 1.1202191 744 -1.547316 \ 0.1222

      LocaSanta Cruz:Entry8 \ \ -1.623333 1.1202191 744 -1.449121 \ 0.1477

      LocaTiucal:Entry8 \ \ \ \ \ \ -2.726667 1.1202191 744 -2.434048
      \ 0.0152

      LocaTlaltizapan:Entry8 \ \ 1.083333 1.1202191 744 \ 0.967073 \ 0.3338

      LocaToco:Entry8 \ \ \ \ \ \ \ \ -1.260000 1.1202191 744 -1.124780
      \ 0.2610

      LocaYoro:Entry8 \ \ \ \ \ \ \ \ -1.240000 1.1202191 744 -1.106926
      \ 0.2687

      LocaCotaxtla:Entry9 \ \ \ \ -1.126667 1.1202191 744 -1.005756 \ 0.3149

      LocaIguala:Entry9 \ \ \ \ \ \ -0.493333 1.1202191 744 -0.440390
      \ 0.6598

      LocaManagua:Entry9 \ \ \ \ \ \ 0.283333 1.1202191 744 \ 0.252927
      \ 0.8004

      LocaPalmira :Entry9 \ \ \ \ \ 0.216667 1.1202191 744 \ 0.193415
      \ 0.8467

      LocaSabana :Entry9 \ \ \ \ \ -0.086667 1.1202191 744 -0.077366 \ 0.9384

      LocaSan Andres:Entry9 \ \ -2.250000 1.1202191 744 -2.008536 \ 0.0449

      LocaSanta Cruz:Entry9 \ \ -2.383333 1.1202191 744 -2.127560 \ 0.0337

      LocaTiucal:Entry9 \ \ \ \ \ \ -0.563333 1.1202191 744 -0.502878
      \ 0.6152

      LocaTlaltizapan:Entry9 \ \ 1.610000 1.1202191 744 \ 1.437219 \ 0.1511

      LocaToco:Entry9 \ \ \ \ \ \ \ \ \ 0.076667 1.1202191 744 \ 0.068439
      \ 0.9455

      LocaYoro:Entry9 \ \ \ \ \ \ \ \ -0.193333 1.1202191 744 -0.172585
      \ 0.8630

      LocaCotaxtla:Entry10 \ \ \ -0.416667 1.1202191 744 -0.371951 \ 0.7100

      LocaIguala:Entry10 \ \ \ \ \ \ 0.523333 1.1202191 744 \ 0.467170
      \ 0.6405

      LocaManagua:Entry10 \ \ \ \ \ 0.630000 1.1202191 744 \ 0.562390
      \ 0.5740

      LocaPalmira :Entry10 \ \ \ \ 0.593333 1.1202191 744 \ 0.529658 \ 0.5965

      LocaSabana :Entry10 \ \ \ \ -0.596667 1.1202191 744 -0.532634 \ 0.5944

      LocaSan Andres:Entry10 \ -2.243333 1.1202191 744 -2.002584 \ 0.0456

      LocaSanta Cruz:Entry10 \ -0.970000 1.1202191 744 -0.865902 \ 0.3868

      LocaTiucal:Entry10 \ \ \ \ \ -0.310000 1.1202191 744 -0.276732 \ 0.7821

      LocaTlaltizapan:Entry10 \ 1.866667 1.1202191 744 \ 1.666341 \ 0.0961

      LocaToco:Entry10 \ \ \ \ \ \ \ -0.983333 1.1202191 744 -0.877804
      \ 0.3803

      LocaYoro:Entry10 \ \ \ \ \ \ \ -0.520000 1.1202191 744 -0.464195
      \ 0.6426

      LocaCotaxtla:Entry11 \ \ \ -1.343333 1.1202191 744 -1.199170 \ 0.2308

      LocaIguala:Entry11 \ \ \ \ \ -1.170000 1.1202191 744 -1.044439 \ 0.2966

      LocaManagua:Entry11 \ \ \ \ -1.716667 1.1202191 744 -1.532438 \ 0.1258

      LocaPalmira :Entry11 \ \ \ -1.763333 1.1202191 744 -1.574097 \ 0.1159

      LocaSabana :Entry11 \ \ \ \ -1.360000 1.1202191 744 -1.214048 \ 0.2251

      LocaSan Andres:Entry11 \ -1.580000 1.1202191 744 -1.410438 \ 0.1588

      LocaSanta Cruz:Entry11 \ -1.903333 1.1202191 744 -1.699072 \ 0.0897

      LocaTiucal:Entry11 \ \ \ \ \ -2.560000 1.1202191 744 -2.285267 \ 0.0226

      LocaTlaltizapan:Entry11 \ 1.076667 1.1202191 744 \ 0.961121 \ 0.3368

      LocaToco:Entry11 \ \ \ \ \ \ \ -2.086667 1.1202191 744 -1.862731
      \ 0.0629

      LocaYoro:Entry11 \ \ \ \ \ \ \ -0.330000 1.1202191 744 -0.294585
      \ 0.7684

      LocaCotaxtla:Entry12 \ \ \ -1.100000 1.1202191 744 -0.981951 \ 0.3264

      LocaIguala:Entry12 \ \ \ \ \ -1.750000 1.1202191 744 -1.562194 \ 0.1187

      LocaManagua:Entry12 \ \ \ \ -0.186667 1.1202191 744 -0.166634 \ 0.8677

      LocaPalmira :Entry12 \ \ \ -0.393333 1.1202191 744 -0.351122 \ 0.7256

      LocaSabana :Entry12 \ \ \ \ -0.550000 1.1202191 744 -0.490975 \ 0.6236

      LocaSan Andres:Entry12 \ -1.783333 1.1202191 744 -1.591950 \ 0.1118

      LocaSanta Cruz:Entry12 \ -1.636667 1.1202191 744 -1.461024 \ 0.1444

      LocaTiucal:Entry12 \ \ \ \ \ -0.983333 1.1202191 744 -0.877804 \ 0.3803

      LocaTlaltizapan:Entry12 \ 0.690000 1.1202191 744 \ 0.615951 \ 0.5381

      LocaToco:Entry12 \ \ \ \ \ \ \ \ 0.776667 1.1202191 744 \ 0.693317
      \ 0.4883

      LocaYoro:Entry12 \ \ \ \ \ \ \ -1.313333 1.1202191 744 -1.172390
      \ 0.2414

      LocaCotaxtla:Entry13 \ \ \ -0.806667 1.1202191 744 -0.720097 \ 0.4717

      LocaIguala:Entry13 \ \ \ \ \ \ 0.656667 1.1202191 744 \ 0.586195
      \ 0.5579

      LocaManagua:Entry13 \ \ \ \ -1.060000 1.1202191 744 -0.946243 \ 0.3443

      LocaPalmira :Entry13 \ \ \ -1.213333 1.1202191 744 -1.083121 \ 0.2791

      LocaSabana :Entry13 \ \ \ \ -1.050000 1.1202191 744 -0.937317 \ 0.3489

      LocaSan Andres:Entry13 \ -2.393333 1.1202191 744 -2.136487 \ 0.0330

      LocaSanta Cruz:Entry13 \ -0.923333 1.1202191 744 -0.824243 \ 0.4101

      LocaTiucal:Entry13 \ \ \ \ \ -2.120000 1.1202191 744 -1.892487 \ 0.0588

      LocaTlaltizapan:Entry13 \ 1.426667 1.1202191 744 \ 1.273560 \ 0.2032

      LocaToco:Entry13 \ \ \ \ \ \ \ -1.773333 1.1202191 744 -1.583024
      \ 0.1138

      LocaYoro:Entry13 \ \ \ \ \ \ \ -1.460000 1.1202191 744 -1.303316
      \ 0.1929

      LocaCotaxtla:Entry14 \ \ \ -2.670000 1.1202191 744 -2.383462 \ 0.0174

      LocaIguala:Entry14 \ \ \ \ \ -1.620000 1.1202191 744 -1.446146 \ 0.1486

      LocaManagua:Entry14 \ \ \ \ \ 1.026667 1.1202191 744 \ 0.916487
      \ 0.3597

      LocaPalmira :Entry14 \ \ \ -2.086667 1.1202191 744 -1.862731 \ 0.0629

      LocaSabana :Entry14 \ \ \ \ \ 1.386667 1.1202191 744 \ 1.237853
      \ 0.2162

      LocaSan Andres:Entry14 \ -1.653333 1.1202191 744 -1.475902 \ 0.1404

      LocaSanta Cruz:Entry14 \ -2.496667 1.1202191 744 -2.228731 \ 0.0261

      LocaTiucal:Entry14 \ \ \ \ \ \ 0.830000 1.1202191 744 \ 0.740926
      \ 0.4590

      LocaTlaltizapan:Entry14 -2.313333 1.1202191 744 -2.065072 \ 0.0393

      LocaToco:Entry14 \ \ \ \ \ \ \ -0.216667 1.1202191 744 -0.193415
      \ 0.8467

      LocaYoro:Entry14 \ \ \ \ \ \ \ \ 0.263333 1.1202191 744 \ 0.235073
      \ 0.8142

      LocaCotaxtla:Entry15 \ \ \ -0.010000 1.1202191 744 -0.008927 \ 0.9929

      LocaIguala:Entry15 \ \ \ \ \ -0.763333 1.1202191 744 -0.681414 \ 0.4958

      LocaManagua:Entry15 \ \ \ \ -0.453333 1.1202191 744 -0.404683 \ 0.6858

      LocaPalmira :Entry15 \ \ \ -0.496667 1.1202191 744 -0.443366 \ 0.6576

      LocaSabana :Entry15 \ \ \ \ -0.046667 1.1202191 744 -0.041659 \ 0.9668

      LocaSan Andres:Entry15 \ \ 0.003333 1.1202191 744 \ 0.002976 \ 0.9976

      LocaSanta Cruz:Entry15 \ -0.956667 1.1202191 744 -0.854000 \ 0.3934

      \;

      LocaTiucal:Entry15 \ \ \ \ \ \ 0.890000 1.1202191 744 \ 0.794487
      \ 0.4272

      LocaTlaltizapan:Entry15 \ 0.963333 1.1202191 744 \ 0.859951 \ 0.3901

      LocaToco:Entry15 \ \ \ \ \ \ \ \ 0.290000 1.1202191 744 \ 0.258878
      \ 0.7958

      LocaYoro:Entry15 \ \ \ \ \ \ \ -0.356667 1.1202191 744 -0.318390
      \ 0.7503

      LocaCotaxtla:Entry16 \ \ \ -1.376667 1.1202191 744 -1.228926 \ 0.2195

      LocaIguala:Entry16 \ \ \ \ \ -0.846667 1.1202191 744 -0.755805 \ 0.4500

      LocaManagua:Entry16 \ \ \ \ -0.523333 1.1202191 744 -0.467170 \ 0.6405

      \ [ reached getOption("max.print") -- omitted 184 rows ]

      \ Correlation:\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (Intr) LcCtxt LocIgl
      LocMng LcPlmr LocSbn LcSnAn

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ -0.707
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcSntC LocTcl LcTllt
      LocaTc LocaYr Entry2 Entry3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entry4 Entry5 Entry6
      Entry7 Entry8 Entry9 Entr10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr11 Entr12 Entr13
      Entr14 Entr15 Entr16 Entr17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr18 Entr19 Entr20
      Entr21 Entr22 Entr23 Entr24

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr25 Entr26 Entr27
      Entr28 Entr29 Entr30 Entr31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Entr32 LcC:E2 LcI:E2
      LcM:E2 LcP:E2 LcS:E2 LcSA:E2

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcSC:E2 LcTcl:E2
      LcTl:E2 LcTc:En2 LcY:E2 LcC:E3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcI:E3 LcM:E3 LcP:E3
      LcS:E3 LcSA:E3 LcSC:E3 LcTcl:E3

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E3 LcTc:En3 LcY:E3
      LcC:E4 LcI:E4 LcM:E4 LcP:E4

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcS:E4 LSA:E4 LSC:E4
      LcTcl:E4 LcTl:E4 LcTc:En4 LcY:E4

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcC:E5 LcI:E5 LcM:E5
      LcP:E5 LcS:E5 LSA:E5 LSC:E5

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTcl:E5 LcTl:E5
      LcTc:En5 LcY:E5 LcC:E6 LcI:E6 LcM:E6

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcP:E6 LcS:E6 LSA:E6
      LSC:E6 LcTcl:E6 LcTl:E6 LcTc:En6

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcY:E6 LcC:E7 LcI:E7
      LcM:E7 LcP:E7 LcS:E7 LSA:E7

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E7 LcTcl:E7 LcTl:E7
      LcTc:En7 LcY:E7 LcC:E8 LcI:E8

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcM:E8 LcP:E8 LcS:E8
      LSA:E8 LSC:E8 LcTcl:E8 LcTl:E8

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTc:En8 LcY:E8 LcC:E9
      LcI:E9 LcM:E9 LcP:E9 LcS:E9

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSA:E9 LSC:E9 LcTcl:E9
      LcTl:E9 LcTc:En9 LcY:E9 LC:E10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E10 LM:E10 LP:E10
      LS:E10 LSA:E10 LSC:E10 LcTcl:E10

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E10 LcTc:En10
      LY:E10 LC:E11 LI:E11 LM:E11 LP:E11

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E11 LSA:E11 LSC:E11
      LcTcl:E11 LcTl:E11 LcTc:En11

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E11 LC:E12 LI:E12
      LM:E12 LP:E12 LS:E12 LSA:E12

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E12 LcTcl:E12
      LcTl:E12 LcTc:En12 LY:E12 LC:E13

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E13 LM:E13 LP:E13
      LS:E13 LSA:E13 LSC:E13 LcTcl:E13

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E13 LcTc:En13
      LY:E13 LC:E14 LI:E14 LM:E14 LP:E14

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E14 LSA:E14 LSC:E14
      LcTcl:E14 LcTl:E14 LcTc:En14

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E14 LC:E15 LI:E15
      LM:E15 LP:E15 LS:E15 LSA:E15

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E15 LcTcl:E15
      LcTl:E15 LcTc:En15 LY:E15 LC:E16

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E16 LM:E16 LP:E16
      LS:E16 LSA:E16 LSC:E16 LcTcl:E16

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E16 LcTc:En16
      LY:E16 LC:E17 LI:E17 LM:E17 LP:E17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E17 LSA:E17 LSC:E17
      LcTcl:E17 LcTl:E17 LcTc:En17

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E17 LC:E18 LI:E18
      LM:E18 LP:E18 LS:E18 LSA:E18

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E18 LcTcl:E18
      LcTl:E18 LcTc:En18 LY:E18 LC:E19

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E19 LM:E19 LP:E19
      LS:E19 LSA:E19 LSC:E19 LcTcl:E19

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E19 LcTc:En19
      LY:E19 LC:E20 LI:E20 LM:E20 LP:E20

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E20 LSA:E20 LSC:E20
      LcTcl:E20 LcTl:E20 LcTc:En20

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E20 LC:E21 LI:E21
      LM:E21 LP:E21 LS:E21 LSA:E21

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E21 LcTcl:E21
      LcTl:E21 LcTc:En21 LY:E21 LC:E22

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E22 LM:E22 LP:E22
      LS:E22 LSA:E22 LSC:E22 LcTcl:E22

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E22 LcTc:En22
      LY:E22 LC:E23 LI:E23 LM:E23 LP:E23

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E23 LSA:E23 LSC:E23
      LcTcl:E23 LcTl:E23 LcTc:En23

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E23 LC:E24 LI:E24
      LM:E24 LP:E24 LS:E24 LSA:E24

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E24 LcTcl:E24
      LcTl:E24 LcTc:En24 LY:E24 LC:E25

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E25 LM:E25 LP:E25
      LS:E25 LSA:E25 LSC:E25 LcTcl:E25

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E25 LcTc:En25
      LY:E25 LC:E26 LI:E26 LM:E26 LP:E26

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E26 LSA:E26 LSC:E26
      LcTcl:E26 LcTl:E26 LcTc:En26

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E26 LC:E27 LI:E27
      LM:E27 LP:E27 LS:E27 LSA:E27

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E27 LcTcl:E27
      LcTl:E27 LcTc:En27 LY:E27 LC:E28

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E28 LM:E28 LP:E28
      LS:E28 LSA:E28 LSC:E28 LcTcl:E28

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E28 LcTc:En28
      LY:E28 LC:E29 LI:E29 LM:E29 LP:E29

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E29 LSA:E29 LSC:E29
      LcTcl:E29 LcTl:E29 LcTc:En29

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LY:E29 LC:E30 LI:E30
      LM:E30 LP:E30 LS:E30 LSA:E30

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LSC:E30 LcTcl:E30
      LcTl:E30 LcTc:En30 LY:E30 LC:E31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LI:E31 LM:E31 LP:E31
      LS:E31 LSA:E31 LSC:E31 LcTcl:E31

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LcTl:E31 LcTc:En31
      LY:E31 LC:E32 LI:E32 LM:E32 LP:E32

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LS:E32 LSA:E32 LSC:E32
      LcTcl:E32 LcTl:E32 LcTc:En32

      LocaCotaxtla \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      LocaIguala \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ [ reached getOption("max.print") -- omitted 381 rows ]

      \;

      Standardized Within-Group Residuals:

      \ \ \ \ \ \ \ Min \ \ \ \ \ \ \ \ Q1 \ \ \ \ \ \ \ Med
      \ \ \ \ \ \ \ \ Q3 \ \ \ \ \ \ \ Max\ 

      -4.9119391 -0.5285071 -0.0285848 \ 0.5336249 \ 4.8090358\ 

      \;

      Number of Observations: 1152

      Number of Groups: 36\ 

      \<gtr\> meta.glmmPQL.summary \<less\>-
      summaryRprof("meta.glmmPQL.prof")

      \<gtr\> head(meta.glmmPQL.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      ".C" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 12.68 \ \ \ 92.15 \ \ \ \ \ 12.68
      \ \ \ \ 92.15

      ".Call" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.40 \ \ \ \ 2.91 \ \ \ \ \ \ 1.70
      \ \ \ \ 12.35

      "recalc.varFunc" \ \ \ \ \ 0.26 \ \ \ \ 1.89 \ \ \ \ \ \ 0.26
      \ \ \ \ \ 1.89

      "solve.default" \ \ \ \ \ \ 0.10 \ \ \ \ 0.73 \ \ \ \ \ \ 2.04
      \ \ \ \ 14.83

      "as.double" \ \ \ \ \ \ \ \ \ \ 0.08 \ \ \ \ 0.58 \ \ \ \ \ \ 0.08
      \ \ \ \ \ 0.58

      "crossprod" \ \ \ \ \ \ \ \ \ \ 0.08 \ \ \ \ 0.58 \ \ \ \ \ \ 0.08
      \ \ \ \ \ 0.58

      \<gtr\> head(meta.glmmPQL.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "eval" \ \ \ \ \ \ \ \ \ \ \ \ 13.76 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "glmmPQL" \ \ \ \ \ \ \ \ \ 13.76 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "lme.formula" \ \ \ \ \ 13.36 \ \ \ \ 97.09 \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "nlme::lme" \ \ \ \ \ \ \ 13.36 \ \ \ \ 97.09 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      ".C" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 12.68 \ \ \ \ 92.15 \ \ \ \ 12.68
      \ \ \ 92.15

      "FUN" \ \ \ \ \ \ \ \ \ \ \ \ \ 11.12 \ \ \ \ 80.81 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      \<gtr\>\ 
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("cotes.glmmPQL.Rda")) {

      \ \ Rprof("cotes.glmmPQL.prof")

      \ \ cotes.glmmPQL \<less\>- glmmPQL(YLD ~ Loca*Entry, random = ~ 1 \|
      Block, weights = varIdent(form = ~ Plot \| Loca), data=rcbd.dat,
      family="gaussian")

      \ \ Rprof(NULL)

      \ \ \ save(cotes.glmmPQL, file="cotes.glmmPQL.Rda")

      \ } else {

      \ \ \ load(file="cotes.glmmPQL.Rda")

      \ }

      summary(cotes.glmmPQL)

      cotes.glmmPQL.summary \<less\>- summaryRprof("cotes.glmmPQL.prof")

      head(cotes.glmmPQL.summary[[1]])

      head(cotes.glmmPQL.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("cotes.glmmPQL.Rda")) {

      + \ \ Rprof("cotes.glmmPQL.prof")

      + \ \ cotes.glmmPQL \<less\>- glmmPQL(YLD ~ Loca*Entry, random = ~ 1 \|
      Block, weights\ 

      \<less\>L(YLD ~ Loca*Entry, random = ~ 1 \| Block, weights =
      varIdent(form = ~ Plot \|

      \<less\> = ~ 1 \| Block, weights = varIdent(form = ~ Plot \| Loca),
      data=rcbd.dat, fam

      \<less\>varIdent(form = ~ Plot \| Loca), data=rcbd.dat,
      family="gaussian")

      + \ \ Rprof(NULL)

      + \ \ \ save(cotes.glmmPQL, file="cotes.glmmPQL.Rda")

      + \ } else {

      + \ \ \ load(file="cotes.glmmPQL.Rda")

      + \ }

      Error in model.frame.default(data = rcbd.dat, weights = varIdent(form =
      ~Plot \| \ :\ 

      \ \ variable lengths differ (found for '(weights)')

      \<gtr\> summary(cotes.glmmPQL)

      Error in summary(cotes.glmmPQL) : object 'cotes.glmmPQL' not found

      \<gtr\> cotes.glmmPQL.summary \<less\>-
      summaryRprof("cotes.glmmPQL.prof")

      Error in summaryRprof("cotes.glmmPQL.prof") :\ 

      \ \ no lines found in 'cotes.glmmPQL.prof'

      \<gtr\> head(cotes.glmmPQL.summary[[1]])

      Error in head(cotes.glmmPQL.summary[[1]]) :\ 

      \ \ object 'cotes.glmmPQL.summary' not found

      \<gtr\> head(cotes.glmmPQL.summary[[2]])

      Error in head(cotes.glmmPQL.summary[[2]]) :\ 

      \ \ object 'cotes.glmmPQL.summary' not found
    </unfolded-prog-io|>

    <\textput>
      <section|lmer>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(lme4)
    <|unfolded-prog-io>
      library(lme4)

      Loading required package: Matrix

      \;

      Attaching package: 'lme4'

      \;

      The following object is masked from 'package:nlme':

      \;

      \ \ \ \ lmList

      \;
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.lmer.Rda")) {

      \ \ Rprof("meta.lmer.prof")

      \ \ meta.lmer \<less\>- lmer(YLD ~ Entry + (1 \| Loca/Repe) + (1 \|
      Loca:Entry), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(meta.lmer,file="meta.lmer.Rda")

      \ } else {

      \ \ \ \ load(file="meta.lmer.Rda")

      }

      summary(meta.lmer)

      meta.lmer.summary \<less\>- summaryRprof("meta.lmer.prof")

      head(meta.lmer.summary[[1]])

      head(meta.lmer.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("meta.lmer.Rda")) {

      + \ \ Rprof("meta.lmer.prof")

      + \ \ meta.lmer \<less\>- lmer(YLD ~ Entry + (1 \| Loca/Repe) + (1 \|
      Loca:Entry), data=

      \<less\> Entry + (1 \| Loca/Repe) + (1 \| Loca:Entry), data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(meta.lmer,file="meta.lmer.Rda")

      + \ } else {

      + \ \ \ \ load(file="meta.lmer.Rda")

      + }

      \<gtr\> summary(meta.lmer)

      Linear mixed model fit by REML ['lmerMod']

      Formula: YLD ~ Entry + (1 \| Loca/Repe) + (1 \| Loca:Entry)

      \ \ \ Data: rcbd.dat

      \;

      REML criterion at convergence: 3637.2

      \;

      Scaled residuals:\ 

      \ \ \ \ Min \ \ \ \ \ 1Q \ Median \ \ \ \ \ 3Q \ \ \ \ Max\ 

      -3.1325 -0.4835 \ 0.0147 \ 0.5127 \ 3.9624\ 

      \;

      Random effects:

      \ Groups \ \ \ \ Name \ \ \ \ \ \ \ Variance Std.Dev.

      \ Loca:Entry (Intercept) 0.4322 \ \ 0.6574 \ 

      \ Repe:Loca \ (Intercept) 0.1417 \ \ 0.3764 \ 

      \ Loca \ \ \ \ \ \ (Intercept) 8.4472 \ \ 2.9064 \ 

      \ Residual \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.9412 \ \ 0.9701 \ 

      Number of obs: 1152, groups: \ Loca:Entry, 384; Repe:Loca, 36; Loca, 12

      \;

      Fixed effects:

      \ \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value

      (Intercept) \ 5.85083 \ \ \ 0.87751 \ \ 6.668

      Entry2 \ \ \ \ \ \ 0.18778 \ \ \ 0.35258 \ \ 0.533

      Entry3 \ \ \ \ \ \ 0.84972 \ \ \ 0.35258 \ \ 2.410

      Entry4 \ \ \ \ \ \ 0.62139 \ \ \ 0.35258 \ \ 1.762

      Entry5 \ \ \ \ \ \ 0.64583 \ \ \ 0.35258 \ \ 1.832

      Entry6 \ \ \ \ \ \ 0.61611 \ \ \ 0.35258 \ \ 1.747

      Entry7 \ \ \ \ \ -0.07250 \ \ \ 0.35258 \ -0.206

      Entry8 \ \ \ \ \ \ 0.77139 \ \ \ 0.35258 \ \ 2.188

      Entry9 \ \ \ \ \ -0.23917 \ \ \ 0.35258 \ -0.678

      Entry10 \ \ \ \ \ 0.47778 \ \ \ 0.35258 \ \ 1.355

      Entry11 \ \ \ \ \ 1.03194 \ \ \ 0.35258 \ \ 2.927

      Entry12 \ \ \ \ \ 0.17417 \ \ \ 0.35258 \ \ 0.494

      Entry13 \ \ \ \ \ 0.32028 \ \ \ 0.35258 \ \ 0.908

      Entry14 \ \ \ \ -2.27583 \ \ \ 0.35258 \ -6.455

      Entry15 \ \ \ \ \ 0.19194 \ \ \ 0.35258 \ \ 0.544

      Entry16 \ \ \ \ -0.90722 \ \ \ 0.35258 \ -2.573

      Entry17 \ \ \ \ \ 0.74472 \ \ \ 0.35258 \ \ 2.112

      Entry18 \ \ \ \ \ 0.65194 \ \ \ 0.35258 \ \ 1.849

      Entry19 \ \ \ \ -2.54722 \ \ \ 0.35258 \ -7.224

      Entry20 \ \ \ \ \ 0.04694 \ \ \ 0.35258 \ \ 0.133

      Entry21 \ \ \ \ -0.98694 \ \ \ 0.35258 \ -2.799

      Entry22 \ \ \ \ \ 0.77000 \ \ \ 0.35258 \ \ 2.184

      Entry23 \ \ \ \ -2.09111 \ \ \ 0.35258 \ -5.931

      Entry24 \ \ \ \ \ 0.03139 \ \ \ 0.35258 \ \ 0.089

      Entry25 \ \ \ \ -0.99944 \ \ \ 0.35258 \ -2.835

      Entry26 \ \ \ \ \ 1.00417 \ \ \ 0.35258 \ \ 2.848

      Entry27 \ \ \ \ \ 0.89222 \ \ \ 0.35258 \ \ 2.531

      Entry28 \ \ \ \ \ 0.49944 \ \ \ 0.35258 \ \ 1.417

      Entry29 \ \ \ \ -0.04861 \ \ \ 0.35258 \ -0.138

      Entry30 \ \ \ \ -0.54667 \ \ \ 0.35258 \ -1.550

      Entry31 \ \ \ \ \ 0.35083 \ \ \ 0.35258 \ \ 0.995

      Entry32 \ \ \ \ -0.18750 \ \ \ 0.35258 \ -0.532

      \;

      Correlation matrix not shown by default, as p = 32 \<gtr\> 12.

      Use print(x, correlation=TRUE) \ or

      \ \ \ \ \ \ \ \ \ vcov(x) \ \ \ \ \ \ \ \ if you need it

      \;

      \<gtr\> meta.lmer.summary \<less\>- summaryRprof("meta.lmer.prof")

      \<gtr\> head(meta.lmer.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      ".Call" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.28 \ \ \ 87.50
      \ \ \ \ \ \ 0.28 \ \ \ \ 87.50

      ".findMethodInTable" \ \ \ \ \ 0.02 \ \ \ \ 6.25 \ \ \ \ \ \ 0.02
      \ \ \ \ \ 6.25

      "levels" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.02 \ \ \ \ 6.25
      \ \ \ \ \ \ 0.02 \ \ \ \ \ 6.25

      \<gtr\> head(meta.lmer.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "lmer" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.32 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ \ 0.0

      ".Call" \ \ \ \ \ \ \ \ \ \ \ \ \ 0.28 \ \ \ \ 87.50 \ \ \ \ \ 0.28
      \ \ \ \ 87.5

      "optimizeLmer" \ \ \ \ \ \ 0.26 \ \ \ \ 81.25 \ \ \ \ \ 0.00
      \ \ \ \ \ 0.0

      "optwrap" \ \ \ \ \ \ \ \ \ \ \ 0.26 \ \ \ \ 81.25 \ \ \ \ \ 0.00
      \ \ \ \ \ 0.0

      "\<Anonymous\>" \ \ \ \ \ \ \ 0.24 \ \ \ \ 75.00 \ \ \ \ \ 0.00
      \ \ \ \ \ 0.0

      "do.call" \ \ \ \ \ \ \ \ \ \ \ 0.24 \ \ \ \ 75.00 \ \ \ \ \ 0.00
      \ \ \ \ \ 0.0
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("cotes.lmer.Rda")) {

      \ \ Rprof("cotes.lmer.prof")

      \ \ cotes.lmer \<less\>- lmer(YLD ~ 0 + Entry + (1 \| Loca:Repe) + (0 +
      Entry \| Loca), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(cotes.lmer,file="cotes.lmer.Rda")

      } else {

      \ \ load(file="cotes.lmer.Rda")

      }

      summary(cotes.lmer)

      cotes.lmer.summary \<less\>- summaryRprof("cotes.lmer.prof")

      head(cotes.lmer.summary[[1]])

      head(cotes.lmer.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("cotes.lmer.Rda")) {

      + \ \ Rprof("cotes.lmer.prof")

      + \ \ cotes.lmer \<less\>- lmer(YLD ~ 0 + Entry + (1 \| Loca:Repe) + (0
      + Entry \| Loca)

      \<less\>~ 0 + Entry + (1 \| Loca:Repe) + (0 + Entry \| Loca),
      data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(cotes.lmer,file="cotes.lmer.Rda")

      + } else {

      + \ \ load(file="cotes.lmer.Rda")

      + }

      \<gtr\> summary(cotes.lmer)

      Linear mixed model fit by REML ['lmerMod']

      Formula: YLD ~ 0 + Entry + (1 \| Loca:Repe) + (0 + Entry \| Loca)

      \ \ \ Data: rcbd.dat

      \;

      REML criterion at convergence: 3306.4

      \;

      Scaled residuals:\ 

      \ \ \ \ Min \ \ \ \ \ 1Q \ Median \ \ \ \ \ 3Q \ \ \ \ Max\ 

      -4.5271 -0.5026 -0.0163 \ 0.4911 \ 4.6645\ 

      \;

      Random effects:

      \ Groups \ \ \ Name \ \ \ \ \ \ \ Variance Std.Dev. Corr
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ Loca:Repe (Intercept) 6.6336 \ \ 2.5756
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ Loca \ \ \ \ \ Entry1 \ \ \ \ \ 0.0000 \ \ 0.0000
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ Entry2 \ \ \ \ \ 0.3448 \ \ 0.5872 \ \ \ \ NaN
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ Entry3 \ \ \ \ \ 0.3491 \ \ 0.5909 \ \ \ \ NaN
      -0.18 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ Entry4 \ \ \ \ \ 0.5438 \ \ 0.7374 \ \ \ \ NaN
      \ 0.02 \ 0.63 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ Entry5 \ \ \ \ \ 0.8039 \ \ 0.8966 \ \ \ \ NaN
      \ 0.48 \ 0.64 \ 0.63 \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ Entry6 \ \ \ \ \ 0.2791 \ \ 0.5283 \ \ \ \ NaN
      \ 0.31 \ 0.35 \ 0.78 \ 0.54 \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ Entry7 \ \ \ \ \ 0.3579 \ \ 0.5982 \ \ \ \ NaN
      \ 0.77 \ 0.01 \ 0.14 \ 0.52 \ 0.35

      \ \ \ \ \ \ \ \ \ \ \ Entry8 \ \ \ \ \ 1.0905 \ \ 1.0443 \ \ \ \ NaN
      \ 0.42 \ 0.46 \ 0.64 \ 0.84 \ 0.64

      \ \ \ \ \ \ \ \ \ \ \ Entry9 \ \ \ \ \ 0.9724 \ \ 0.9861 \ \ \ \ NaN
      -0.05 \ 0.53 \ 0.84 \ 0.50 \ 0.59

      \ \ \ \ \ \ \ \ \ \ \ Entry10 \ \ \ \ 0.9243 \ \ 0.9614 \ \ \ \ NaN
      \ 0.25 \ 0.38 \ 0.76 \ 0.50 \ 0.72

      \ \ \ \ \ \ \ \ \ \ \ Entry11 \ \ \ \ 0.7929 \ \ 0.8905 \ \ \ \ NaN
      \ 0.07 \ 0.30 \ 0.37 \ 0.47 \ 0.52

      \ \ \ \ \ \ \ \ \ \ \ Entry12 \ \ \ \ 0.6183 \ \ 0.7863 \ \ \ \ NaN
      -0.24 \ 0.61 \ 0.82 \ 0.53 \ 0.49

      \ \ \ \ \ \ \ \ \ \ \ Entry13 \ \ \ \ 1.0566 \ \ 1.0279 \ \ \ \ NaN
      \ 0.32 \ 0.32 \ 0.46 \ 0.61 \ 0.58

      \ \ \ \ \ \ \ \ \ \ \ Entry14 \ \ \ \ 1.6846 \ \ 1.2979 \ \ \ \ NaN
      -0.29 -0.27 -0.10 -0.45 -0.22

      \ \ \ \ \ \ \ \ \ \ \ Entry15 \ \ \ \ 0.2388 \ \ 0.4887 \ \ \ \ NaN
      -0.70 \ 0.75 \ 0.56 \ 0.16 \ 0.14

      \ \ \ \ \ \ \ \ \ \ \ Entry16 \ \ \ \ 0.8737 \ \ 0.9347 \ \ \ \ NaN
      \ 0.08 \ 0.43 \ 0.49 \ 0.49 \ 0.24

      \ \ \ \ \ \ \ \ \ \ \ Entry17 \ \ \ \ 0.7791 \ \ 0.8827 \ \ \ \ NaN
      -0.02 \ 0.51 \ 0.51 \ 0.48 \ 0.53

      \ \ \ \ \ \ \ \ \ \ \ Entry18 \ \ \ \ 0.8775 \ \ 0.9368 \ \ \ \ NaN
      -0.29 \ 0.56 \ 0.66 \ 0.27 \ 0.53

      \ \ \ \ \ \ \ \ \ \ \ Entry19 \ \ \ \ 2.3598 \ \ 1.5362 \ \ \ \ NaN
      -0.04 -0.50 -0.21 -0.54 -0.15

      \ \ \ \ \ \ \ \ \ \ \ Entry20 \ \ \ \ 0.3068 \ \ 0.5539 \ \ \ \ NaN
      \ 0.00 -0.38 -0.27 -0.29 \ 0.10

      \ \ \ \ \ \ \ \ \ \ \ Entry21 \ \ \ \ 0.3222 \ \ 0.5677 \ \ \ \ NaN
      \ 0.06 \ 0.35 \ 0.45 \ 0.44 \ 0.23

      \ \ \ \ \ \ \ \ \ \ \ Entry22 \ \ \ \ 0.6260 \ \ 0.7912 \ \ \ \ NaN
      \ 0.23 \ 0.49 \ 0.53 \ 0.54 \ 0.47

      \ \ \ \ \ \ \ \ \ \ \ Entry23 \ \ \ \ 2.9374 \ \ 1.7139 \ \ \ \ NaN
      -0.11 \ 0.00 \ 0.12 -0.11 -0.08

      \ \ \ \ \ \ \ \ \ \ \ Entry24 \ \ \ \ 0.2989 \ \ 0.5468 \ \ \ \ NaN
      -0.41 \ 0.44 \ 0.37 \ 0.23 \ 0.21

      \ \ \ \ \ \ \ \ \ \ \ Entry25 \ \ \ \ 1.1287 \ \ 1.0624 \ \ \ \ NaN
      -0.10 \ 0.36 \ 0.58 \ 0.35 \ 0.22

      \ \ \ \ \ \ \ \ \ \ \ Entry26 \ \ \ \ 1.4007 \ \ 1.1835 \ \ \ \ NaN
      \ 0.23 \ 0.56 \ 0.75 \ 0.87 \ 0.60

      \ \ \ \ \ \ \ \ \ \ \ Entry27 \ \ \ \ 0.6286 \ \ 0.7928 \ \ \ \ NaN
      \ 0.19 \ 0.41 \ 0.81 \ 0.53 \ 0.82

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.30 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.02 \ 0.53 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.29 \ 0.64 \ 0.82 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.04 \ 0.75 \ 0.49 \ 0.55 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.19 \ 0.47 \ 0.83 \ 0.55 \ 0.30
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.47 \ 0.72 \ 0.51 \ 0.79 \ 0.77 \ 0.30
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.25 -0.61 \ 0.24 -0.08 -0.35 \ 0.14 -0.40
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.45 \ 0.19 \ 0.48 \ 0.26 \ 0.20 \ 0.61 \ 0.09 -0.09
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.01 \ 0.27 \ 0.74 \ 0.34 \ 0.18 \ 0.70 \ 0.09 \ 0.49 \ 0.17
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.05 \ 0.80 \ 0.49 \ 0.62 \ 0.88 \ 0.34 \ 0.71 -0.57 \ 0.46 \ 0.03
      \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.42 \ 0.53 \ 0.60 \ 0.43 \ 0.55 \ 0.55 \ 0.16 -0.18 \ 0.66 \ 0.30
      \ 0.73 \ \ \ \ \ 

      \ -0.15 -0.60 \ 0.09 -0.11 -0.38 -0.10 -0.45 \ 0.92 -0.37 \ 0.34 -0.60
      -0.22

      \ \ 0.20 -0.09 -0.10 \ 0.23 \ 0.40 -0.35 \ 0.52 \ 0.01 -0.28 -0.42
      \ 0.19 -0.28

      \ \ 0.07 \ 0.36 \ 0.83 \ 0.64 \ 0.45 \ 0.62 \ 0.52 \ 0.40 \ 0.19 \ 0.80
      \ 0.29 \ 0.21

      \ -0.03 \ 0.73 \ 0.43 \ 0.38 \ 0.55 \ 0.28 \ 0.23 -0.42 \ 0.30 \ 0.30
      \ 0.71 \ 0.81

      \ -0.19 -0.35 \ 0.38 -0.06 -0.32 \ 0.32 -0.45 \ 0.87 -0.02 \ 0.76 -0.47
      \ 0.05

      \ \ 0.04 \ 0.26 \ 0.39 \ 0.48 \ 0.47 \ 0.39 \ 0.67 -0.18 \ 0.59 -0.06
      \ 0.51 \ 0.14

      \ -0.24 \ 0.29 \ 0.82 \ 0.40 \ 0.19 \ 0.77 \ 0.03 \ 0.50 \ 0.34 \ 0.92
      \ 0.13 \ 0.48

      \ \ 0.31 \ 0.89 \ 0.74 \ 0.72 \ 0.70 \ 0.70 \ 0.78 -0.32 \ 0.33 \ 0.50
      \ 0.68 \ 0.43

      \ \ 0.04 \ 0.81 \ 0.67 \ 0.76 \ 0.62 \ 0.55 \ 0.53 -0.39 \ 0.36 \ 0.22
      \ 0.77 \ 0.80

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.06 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.22 \ 0.07 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.35 -0.40 \ 0.16 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.80 -0.41 \ 0.45 -0.05 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.45 \ 0.47 \ 0.37 -0.14 -0.39 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ 0.34 -0.47 \ 0.77 \ 0.37 \ 0.73 -0.02
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.46 -0.04 \ 0.64 \ 0.50 -0.13 \ 0.52 \ 0.49
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ -0.33 -0.11 \ 0.26 \ 0.77 -0.18 \ 0.19 \ 0.37 \ 0.68
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ \ \ \ \ \ 

      \ [ reached getOption("max.print") -- omitted 6 rows ]

      Number of obs: 1152, groups: \ Loca:Repe, 36; Loca, 12

      \;

      Fixed effects:

      \ \ \ \ \ \ \ \ Estimate Std. Error t value

      Entry1 \ \ \ 5.8508 \ \ \ \ 0.4520 \ 12.943

      Entry2 \ \ \ 6.0386 \ \ \ \ 0.4828 \ 12.508

      Entry3 \ \ \ 6.7006 \ \ \ \ 0.4831 \ 13.869

      Entry4 \ \ \ 6.4722 \ \ \ \ 0.4997 \ 12.953

      Entry5 \ \ \ 6.4967 \ \ \ \ 0.5209 \ 12.472

      Entry6 \ \ \ 6.4669 \ \ \ \ 0.4771 \ 13.555

      Entry7 \ \ \ 5.7783 \ \ \ \ 0.4839 \ 11.941

      Entry8 \ \ \ 6.6222 \ \ \ \ 0.5433 \ 12.188

      Entry9 \ \ \ 5.6117 \ \ \ \ 0.5342 \ 10.505

      Entry10 \ \ 6.3286 \ \ \ \ 0.5304 \ 11.931

      Entry11 \ \ 6.8828 \ \ \ \ 0.5200 \ 13.236

      Entry12 \ \ 6.0250 \ \ \ \ 0.5058 \ 11.911

      Entry13 \ \ 6.1711 \ \ \ \ 0.5407 \ 11.413

      Entry14 \ \ 3.5750 \ \ \ \ 0.5871 \ \ 6.089

      Entry15 \ \ 6.0428 \ \ \ \ 0.4735 \ 12.761

      Entry16 \ \ 4.9436 \ \ \ \ 0.5264 \ \ 9.391

      Entry17 \ \ 6.5956 \ \ \ \ 0.5189 \ 12.710

      Entry18 \ \ 6.5028 \ \ \ \ 0.5268 \ 12.345

      Entry19 \ \ 3.3036 \ \ \ \ 0.6332 \ \ 5.217

      Entry20 \ \ 5.8978 \ \ \ \ 0.4795 \ 12.300

      Entry21 \ \ 4.8639 \ \ \ \ 0.4808 \ 10.116

      Entry22 \ \ 6.6208 \ \ \ \ 0.5065 \ 13.073

      Entry23 \ \ 3.7597 \ \ \ \ 0.6702 \ \ 5.610

      Entry24 \ \ 5.8822 \ \ \ \ 0.4788 \ 12.285

      Entry25 \ \ 4.8514 \ \ \ \ 0.5463 \ \ 8.881

      Entry26 \ \ 6.8550 \ \ \ \ 0.5666 \ 12.098

      Entry27 \ \ 6.7431 \ \ \ \ 0.5067 \ 13.308

      Entry28 \ \ 6.3503 \ \ \ \ 0.5012 \ 12.669

      Entry29 \ \ 5.8022 \ \ \ \ 0.4950 \ 11.722

      Entry30 \ \ 5.3042 \ \ \ \ 0.5003 \ 10.603

      Entry31 \ \ 6.2017 \ \ \ \ 0.5472 \ 11.334

      Entry32 \ \ 5.6633 \ \ \ \ 0.5588 \ 10.134

      \;

      Correlation matrix not shown by default, as p = 32 \<gtr\> 12.

      Use print(x, correlation=TRUE) \ or

      \ \ \ \ \ \ \ \ \ vcov(x) \ \ \ \ \ \ \ \ if you need it

      \;

      convergence code: 1

      unable to evaluate scaled gradient

      Model failed to converge: degenerate \ Hessian with 9 negative
      eigenvalues

      maxfun \<less\> 10 * length(par)^2 is not recommended.

      \;

      \<gtr\> cotes.lmer.summary \<less\>- summaryRprof("cotes.lmer.prof")

      \<gtr\> head(cotes.lmer.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      ".Call" \ \ \ \ \ \ \ \ \ \ \ 7928.46 \ \ \ 97.20 \ \ \ 7939.60
      \ \ \ \ 97.34

      "as.environment" \ \ \ \ 53.42 \ \ \ \ 0.65 \ \ \ \ \ 53.42
      \ \ \ \ \ 0.65

      "spos" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 38.68 \ \ \ \ 0.47 \ \ \ \ \ 39.88
      \ \ \ \ \ 0.49

      "$" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 28.26 \ \ \ \ 0.35 \ \ \ \ 104.36
      \ \ \ \ \ 1.28

      "deriv12" \ \ \ \ \ \ \ \ \ \ \ 21.38 \ \ \ \ 0.26 \ \ \ 7709.58
      \ \ \ \ 94.52

      "\<Anonymous\>" \ \ \ \ \ \ \ 18.34 \ \ \ \ 0.22 \ \ \ \ 462.66
      \ \ \ \ \ 5.67

      \<gtr\> head(cotes.lmer.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "lmer" \ \ \ \ \ \ \ \ \ \ \ 8156.80 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "optimizeLmer" \ \ \ 8156.60 \ \ \ 100.00 \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "optwrap" \ \ \ \ \ \ \ \ 8156.52 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      ".Call" \ \ \ \ \ \ \ \ \ \ 7939.60 \ \ \ \ 97.34 \ \ 7928.46
      \ \ \ 97.20

      "deriv12" \ \ \ \ \ \ \ \ 7709.58 \ \ \ \ 94.52 \ \ \ \ 21.38
      \ \ \ \ 0.26

      "fun" \ \ \ \ \ \ \ \ \ \ \ \ 7646.98 \ \ \ \ 93.75 \ \ \ \ 18.32
      \ \ \ \ 0.22
    </unfolded-prog-io|>

    from cotes.lmer

    <\textput>
      Warning messages:

      1: In commonArgs(par, fn, control, environment()) :

      \ \ maxfun \<less\> 10 * length(par)^2 is not recommended.

      2: In optwrap(optimizer, devfun, getStart(start, rho$lower, rho$pp),
      \ :

      \ \ convergence code 1 from bobyqa: bobyqa -- maximum number of
      function evaluations exceeded

      3: In commonArgs(par, fn, control, environment()) :

      \ \ maxfun \<less\> 10 * length(par)^2 is not recommended.

      4: In optwrap(optimizer, devfun, opt$par, lower = rho$lower, control =
      control, \ :

      \ \ convergence code 1 from bobyqa: bobyqa -- maximum number of
      function evaluations exceeded

      5: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,
      \ :

      \ \ unable to evaluate scaled gradient

      6: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,
      \ :

      \ \ Model failed to converge: degenerate \ Hessian with 4 negative
      eigenvalues

      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\textput>
      <section|blmer>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(blme)
    <|unfolded-prog-io>
      library(blme)
    </unfolded-prog-io|>

    \;

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.blmer.Rda")) {

      \ \ Rprof("meta.blmer.prof")

      \ \ meta.blmer \<less\>- blmer(YLD ~ Entry + (1 \| Loca/Repe) + (1 \|
      Loca:Entry), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(meta.blmer,file="meta.blmer.Rda")

      }

      summary(meta.blmer)

      meta.blmer.summary \<less\>- summaryRprof("meta.blmer.prof")

      head(meta.blmer.summary[[1]])

      head(meta.blmer.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("meta.blmer.Rda")) {

      + \ \ Rprof("meta.blmer.prof")

      + \ \ meta.blmer \<less\>- blmer(YLD ~ Entry + (1 \| Loca/Repe) + (1 \|
      Loca:Entry), dat

      \<less\> ~ Entry + (1 \| Loca/Repe) + (1 \| Loca:Entry), data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(meta.blmer,file="meta.blmer.Rda")

      + }

      \<gtr\> summary(meta.blmer)

      Error in summary(meta.blmer) : object 'meta.blmer' not found

      \<gtr\> meta.blmer.summary \<less\>- summaryRprof("meta.blmer.prof")

      \<gtr\> head(meta.blmer.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      ".Call" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.12 \ \ \ 17.14 \ \ \ \ \ \ 0.48
      \ \ \ \ 68.57

      "as.environment" \ \ \ \ \ 0.08 \ \ \ 11.43 \ \ \ \ \ \ 0.08
      \ \ \ \ 11.43

      "\<Anonymous\>" \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 5.71 \ \ \ \ \ \ 0.54
      \ \ \ \ 77.14

      "as.matrix" \ \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 5.71 \ \ \ \ \ \ 0.22
      \ \ \ \ 31.43

      "is" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 5.71
      \ \ \ \ \ \ 0.10 \ \ \ \ 14.29

      "structure" \ \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 5.71 \ \ \ \ \ \ 0.04
      \ \ \ \ \ 5.71

      \<gtr\> head(meta.blmer.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "blmer" \ \ \ \ \ \ \ \ \ \ \ \ \ 0.70 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "do.call" \ \ \ \ \ \ \ \ \ \ \ 0.58 \ \ \ \ 82.86 \ \ \ \ \ 0.02
      \ \ \ \ 2.86

      "\<Anonymous\>" \ \ \ \ \ \ \ 0.54 \ \ \ \ 77.14 \ \ \ \ \ 0.04
      \ \ \ \ 5.71

      "optimizeLmer" \ \ \ \ \ \ 0.54 \ \ \ \ 77.14 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "optwrap" \ \ \ \ \ \ \ \ \ \ \ 0.54 \ \ \ \ 77.14 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      ".Call" \ \ \ \ \ \ \ \ \ \ \ \ \ 0.48 \ \ \ \ 68.57 \ \ \ \ \ 0.12
      \ \ \ 17.14
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("cotes.blmer.Rda")) {

      \ \ Rprof("cotes.blmer.prof")

      \ \ cotes.lmer \<less\>- lmer(YLD ~ Entry + (1 \| Loca/Repe) + (0 +
      Entry \| Loca), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(cotes.lmer,file="cotes.blmer.Rda")

      }

      summary(cotes.blmer)

      cotes.blmer.summary \<less\>- summaryRprof("cotes.blmer.prof")

      head(cotes.blmer.summary[[1]])

      head(cotes.blmer.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("cotes.blmer.Rda")) {

      + \ \ Rprof("cotes.blmer.prof")

      + \ \ cotes.lmer \<less\>- lmer(YLD ~ Entry + (1 \| Loca/Repe) + (0 +
      Entry \| Loca), da

      \<less\>~ Entry + (1 \| Loca/Repe) + (0 + Entry \| Loca),
      data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(cotes.lmer,file="cotes.blmer.Rda")

      + }

      \<gtr\> summary(cotes.blmer)

      Error in summary(cotes.blmer) : object 'cotes.blmer' not found

      \<gtr\> cotes.blmer.summary \<less\>- summaryRprof("cotes.blmer.prof")

      \<gtr\> head(cotes.blmer.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      ".Call" \ \ \ \ \ \ \ \ \ \ \ 4301.48 \ \ \ 96.68 \ \ \ 4304.90
      \ \ \ \ 96.76

      "as.environment" \ \ \ \ 35.02 \ \ \ \ 0.79 \ \ \ \ \ 35.02
      \ \ \ \ \ 0.79

      "spos" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 26.66 \ \ \ \ 0.60 \ \ \ \ \ 27.46
      \ \ \ \ \ 0.62

      "$" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 18.06 \ \ \ \ 0.41
      \ \ \ \ \ 67.12 \ \ \ \ \ 1.51

      "deriv12" \ \ \ \ \ \ \ \ \ \ \ 16.34 \ \ \ \ 0.37 \ \ \ 4212.90
      \ \ \ \ 94.69

      "fun" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 12.00 \ \ \ \ 0.27 \ \ \ 4168.36
      \ \ \ \ 93.69

      \<gtr\> head(cotes.blmer.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "lmer" \ \ \ \ \ \ \ \ \ \ \ 4449.20 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "optimizeLmer" \ \ \ 4448.98 \ \ \ 100.00 \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "optwrap" \ \ \ \ \ \ \ \ 4448.94 \ \ \ \ 99.99 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      ".Call" \ \ \ \ \ \ \ \ \ \ 4304.90 \ \ \ \ 96.76 \ \ 4301.48
      \ \ \ 96.68

      "deriv12" \ \ \ \ \ \ \ \ 4212.90 \ \ \ \ 94.69 \ \ \ \ 16.34
      \ \ \ \ 0.37

      "fun" \ \ \ \ \ \ \ \ \ \ \ \ 4168.36 \ \ \ \ 93.69 \ \ \ \ 12.00
      \ \ \ \ 0.27
    </unfolded-prog-io|>

    <\textput>
      \;
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      #detach("package:blme")
    <|unfolded-prog-io>
      #detach("package:blme")
    </unfolded-prog-io|>

    <\textput>
      <section|glmmADMB>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(glmmADMB)
    <|unfolded-prog-io>
      library(glmmADMB)

      \;

      Attaching package: 'glmmADMB'

      \;

      The following object is masked from 'package:MASS':

      \;

      \ \ \ \ stepAIC

      \;

      The following object is masked from 'package:stats':

      \;

      \ \ \ \ step

      \;
    </unfolded-prog-io|>

    <\textput>
      We need to remember the the default family is \Ppoisson\Q
    </textput>

    \;

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.admb.Rda")) {

      \ \ Rprof("meta.admb.prof")

      \ \ meta.admb \<less\>- glmmadmb(YLD ~ 0 + Entry,random= ~ (1 \|
      Loca/Repe) + (1 \| Loca:Entry), family = "gaussian", data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(meta.admb,file="meta.admb.Rda")

      } else {

      \ \ load(file="meta.admb.Rda")

      }

      summary(meta.admb)

      meta.admb.summary \<less\>- summaryRprof("meta.admb.prof")

      head(meta.admb.summary[[1]])

      head(meta.admb.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("meta.admb.Rda")) {

      + \ \ Rprof("meta.admb.prof")

      + \ \ meta.admb \<less\>- glmmadmb(YLD ~ 0 + Entry,random= ~ (1 \|
      Loca/Repe) + (1 \| Lo

      \<less\>LD ~ 0 + Entry,random= ~ (1 \| Loca/Repe) + (1 \| Loca:Entry),
      family = "gauss

      \<less\>1 \| Loca/Repe) + (1 \| Loca:Entry), family = "gaussian",
      data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(meta.admb,file="meta.admb.Rda")

      + } else {

      + \ \ load(file="meta.admb.Rda")

      + }

      \<gtr\> summary(meta.admb)

      \;

      Call:

      glmmadmb(formula = YLD ~ 0 + Entry, data = rcbd.dat, family =
      "gaussian",\ 

      \ \ \ \ random = ~(1 \| Loca/Repe) + (1 \| Loca:Entry))

      \;

      AIC: 3683.6\ 

      \;

      Coefficients:

      \ \ \ \ \ \ \ \ Estimate Std. Error z value Pr(\<gtr\>\|z\|) \ \ \ 

      Entry1 \ \ \ \ \ 5.85 \ \ \ \ \ \ 0.84 \ \ \ 6.96 \ 3.3e-12 ***

      Entry2 \ \ \ \ \ 6.04 \ \ \ \ \ \ 0.84 \ \ \ 7.19 \ 6.6e-13 ***

      Entry3 \ \ \ \ \ 6.70 \ \ \ \ \ \ 0.84 \ \ \ 7.98 \ 1.5e-15 ***

      Entry4 \ \ \ \ \ 6.47 \ \ \ \ \ \ 0.84 \ \ \ 7.70 \ 1.3e-14 ***

      Entry5 \ \ \ \ \ 6.50 \ \ \ \ \ \ 0.84 \ \ \ 7.73 \ 1.1e-14 ***

      Entry6 \ \ \ \ \ 6.47 \ \ \ \ \ \ 0.84 \ \ \ 7.70 \ 1.4e-14 ***

      Entry7 \ \ \ \ \ 5.78 \ \ \ \ \ \ 0.84 \ \ \ 6.88 \ 6.1e-12 ***

      Entry8 \ \ \ \ \ 6.62 \ \ \ \ \ \ 0.84 \ \ \ 7.88 \ 3.2e-15 ***

      Entry9 \ \ \ \ \ 5.61 \ \ \ \ \ \ 0.84 \ \ \ 6.68 \ 2.4e-11 ***

      Entry10 \ \ \ \ 6.33 \ \ \ \ \ \ 0.84 \ \ \ 7.53 \ 5.0e-14 ***

      Entry11 \ \ \ \ 6.88 \ \ \ \ \ \ 0.84 \ \ \ 8.19 \ 2.6e-16 ***

      Entry12 \ \ \ \ 6.03 \ \ \ \ \ \ 0.84 \ \ \ 7.17 \ 7.4e-13 ***

      Entry13 \ \ \ \ 6.17 \ \ \ \ \ \ 0.84 \ \ \ 7.35 \ 2.1e-13 ***

      Entry14 \ \ \ \ 3.58 \ \ \ \ \ \ 0.84 \ \ \ 4.26 \ 2.1e-05 ***

      Entry15 \ \ \ \ 6.04 \ \ \ \ \ \ 0.84 \ \ \ 7.19 \ 6.4e-13 ***

      Entry16 \ \ \ \ 4.94 \ \ \ \ \ \ 0.84 \ \ \ 5.88 \ 4.0e-09 ***

      Entry17 \ \ \ \ 6.60 \ \ \ \ \ \ 0.84 \ \ \ 7.85 \ 4.1e-15 ***

      Entry18 \ \ \ \ 6.50 \ \ \ \ \ \ 0.84 \ \ \ 7.74 \ 9.9e-15 ***

      Entry19 \ \ \ \ 3.30 \ \ \ \ \ \ 0.84 \ \ \ 3.93 \ 8.4e-05 ***

      Entry20 \ \ \ \ 5.90 \ \ \ \ \ \ 0.84 \ \ \ 7.02 \ 2.2e-12 ***

      Entry21 \ \ \ \ 4.86 \ \ \ \ \ \ 0.84 \ \ \ 5.79 \ 7.1e-09 ***

      Entry22 \ \ \ \ 6.62 \ \ \ \ \ \ 0.84 \ \ \ 7.88 \ 3.3e-15 ***

      Entry23 \ \ \ \ 3.76 \ \ \ \ \ \ 0.84 \ \ \ 4.48 \ 7.6e-06 ***

      Entry24 \ \ \ \ 5.88 \ \ \ \ \ \ 0.84 \ \ \ 7.00 \ 2.5e-12 ***

      Entry25 \ \ \ \ 4.85 \ \ \ \ \ \ 0.84 \ \ \ 5.77 \ 7.7e-09 ***

      Entry26 \ \ \ \ 6.86 \ \ \ \ \ \ 0.84 \ \ \ 8.16 \ 3.4e-16 ***

      Entry27 \ \ \ \ 6.74 \ \ \ \ \ \ 0.84 \ \ \ 8.03 \ 1.0e-15 ***

      Entry28 \ \ \ \ 6.35 \ \ \ \ \ \ 0.84 \ \ \ 7.56 \ 4.1e-14 ***

      Entry29 \ \ \ \ 5.80 \ \ \ \ \ \ 0.84 \ \ \ 6.91 \ 5.0e-12 ***

      Entry30 \ \ \ \ 5.30 \ \ \ \ \ \ 0.84 \ \ \ 6.31 \ 2.7e-10 ***

      Entry31 \ \ \ \ 6.20 \ \ \ \ \ \ 0.84 \ \ \ 7.38 \ 1.6e-13 ***

      Entry32 \ \ \ \ 5.66 \ \ \ \ \ \ 0.84 \ \ \ 6.74 \ 1.6e-11 ***

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

      \;

      Number of observations: total=1152, Loca=12, Loca:Repe=36,
      Loca:Entry=384\ 

      Random effect variance(s):

      Group=Loca

      \ \ \ \ \ \ \ \ \ \ \ \ Variance StdDev

      (Intercept) \ \ \ \ 7.74 \ 2.782

      Group=Loca:Repe

      \ \ \ \ \ \ \ \ \ \ \ \ Variance StdDev

      (Intercept) \ \ 0.1417 0.3764

      Group=Loca:Entry

      \ \ \ \ \ \ \ \ \ \ \ \ Variance StdDev

      (Intercept) \ \ \ \ 0.37 0.6083

      \;

      Residual variance: 0.97014 (std. err.: 0.02515)

      \;

      Log-likelihood: -1805.81\ 

      Warning message:

      In .local(x, sigma, ...) :

      \ \ 'sigma' and 'rdig' arguments are present for compatibility only:
      ignored

      \<gtr\> meta.admb.summary \<less\>- summaryRprof("meta.admb.prof")

      \<gtr\> head(meta.admb.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time total.pct

      "scan" \ \ \ \ \ \ \ \ \ \ \ 0.14 \ \ \ 30.43 \ \ \ \ \ \ 0.14
      \ \ \ \ 30.43

      "readLines" \ \ \ \ \ \ 0.12 \ \ \ 26.09 \ \ \ \ \ \ 0.12 \ \ \ \ 26.09

      ".External2" \ \ \ \ \ 0.04 \ \ \ \ 8.70 \ \ \ \ \ \ 0.04
      \ \ \ \ \ 8.70

      "pmatch" \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 8.70 \ \ \ \ \ \ 0.04
      \ \ \ \ \ 8.70

      "system" \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 8.70 \ \ \ \ \ \ 0.04
      \ \ \ \ \ 8.70

      "Sys.chmod" \ \ \ \ \ \ 0.02 \ \ \ \ 4.35 \ \ \ \ \ \ 0.02
      \ \ \ \ \ 4.35

      \<gtr\> head(meta.admb.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "glmmadmb" \ \ \ \ \ \ \ \ 0.46 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "par_read" \ \ \ \ \ \ \ \ 0.30 \ \ \ \ 65.22 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "read.table" \ \ \ \ \ \ 0.18 \ \ \ \ 39.13 \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "rt" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.18 \ \ \ \ 39.13 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "scan" \ \ \ \ \ \ \ \ \ \ \ \ 0.14 \ \ \ \ 30.43 \ \ \ \ \ 0.14
      \ \ \ 30.43

      "readLines" \ \ \ \ \ \ \ 0.12 \ \ \ \ 26.09 \ \ \ \ \ 0.12 \ \ \ 26.09
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("cotes.admb.Rda")) {

      \ \ Rprof("cotes.admb.prof")

      \ \ cotes.admb \<less\>- glmmadmb(YLD ~ 0 + Entry,random= ~ (1 \|
      Loca/Repe) + (0 + Entry \| Loca), family = "gaussian",
      data=rcbd.dat,save.dir="~/Work/git/ASA_CSSA_SSSA/working/admb")

      \ \ Rprof(NULL)

      \ \ save(cotes.admb,file="cotes.admb.Rda")

      } else {

      \ \ load(file="cotes.admb.Rda")

      }

      summary(cotes.admb)

      cotes.admb.summary \<less\>- summaryRprof("cotes.admb.prof")

      head(cotes.admb.summary[[1]])

      head(cotes.admb.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("cotes.admb.Rda")) {

      + \ \ Rprof("cotes.admb.prof")

      + \ \ cotes.admb \<less\>- glmmadmb(YLD ~ 0 + Entry,random= ~ (1 \|
      Loca/Repe) + (0 + E

      \<less\>YLD ~ 0 + Entry,random= ~ (1 \| Loca/Repe) + (0 + Entry \|
      Loca), family = "ga

      \<less\>(1 \| Loca/Repe) + (0 + Entry \| Loca), family = "gaussian",
      data=rcbd.dat,sav

      \<less\>ry \| Loca), family = "gaussian",
      data=rcbd.dat,save.dir="~/Work/git/ASA_CSSA

      \<less\>sian", data=rcbd.dat,save.dir="~/Work/git/ASA_CSSA_SSSA/working/admb")

      + \ \ Rprof(NULL)

      + \ \ save(cotes.admb,file="cotes.admb.Rda")

      + } else {

      + \ \ load(file="cotes.admb.Rda")

      + }

      Error in glmmadmb(YLD ~ 0 + Entry, random = ~(1 \| Loca/Repe) + (0 +
      Entry \| \ :\ 

      \ \ The function maximizer failed (couldn't find parameter file)
      Troubleshooting steps include (1) run with 'save.dir' set and inspect
      output files; (2) change run parameters: see '?admbControl';(3) re-run
      with debug=TRUE for more information on failure mode

      \<gtr\> summary(cotes.admb)

      Error in summary(cotes.admb) : object 'cotes.admb' not found

      \<gtr\> cotes.admb.summary \<less\>- summaryRprof("cotes.admb.prof")

      Error in summaryRprof("cotes.admb.prof") :\ 

      \ \ no lines found in 'cotes.admb.prof'

      \<gtr\> head(cotes.admb.summary[[1]])

      Error in head(cotes.admb.summary[[1]]) :\ 

      \ \ object 'cotes.admb.summary' not found

      \<gtr\> head(cotes.admb.summary[[2]])

      Error in head(cotes.admb.summary[[2]]) :\ 

      \ \ object 'cotes.admb.summary' not found
    </unfolded-prog-io|>

    <\textput>
      Error in glmmadmb(YLD ~ 0 + Entry, random = ~(1 \| Loca/Repe) + (0 +
      Entry \| \ :\ 

      \ \ The function maximizer failed (couldn't find parameter file)
      Troubleshooting steps include (1) run with 'save.dir' set and inspect
      output files; (2) change run parameters: see '?admbControl';(3) re-run
      with debug=TRUE for more information on failure mode
    </textput>

    <\textput>
      <section|glmmLasso>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(glmmLasso)
    <|unfolded-prog-io>
      library(glmmLasso)
    </unfolded-prog-io|>

    \;

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      rcbd.dat$Interaction \<less\>- rcbd.dat$Loca:rcbd.dat$Entry

      \;

      if(!file.exists("meta.glmmLasso.Rda")) {

      \ \ Rprof("meta.glmmLasso.prof")

      \ \ meta.glmmLasso \<less\>- glmmLasso(fix = YLD ~ 0+Entry, rnd =
      list(Loca = ~1, Block = ~1,Interaction=~1), lambda = 200, data =
      rcbd.dat,control=glmmLassoControl(center=FALSE))

      \ \ Rprof(NULL)

      \ \ save(meta.glmmLasso,file="meta.glmmLasso.Rda")

      } else {

      \ \ load(file="meta.glmmLasso.Rda")

      }

      summary(meta.glmmLasso)

      meta.glmmLasso.summary \<less\>- summaryRprof("meta.glmmLasso.prof")

      head(meta.glmmLasso.summary[[1]])

      head(meta.glmmLasso.summary[[2]])

      meta2.glmmLasso \<less\>- glmmLasso(fix = YLD ~ 0+Entry, rnd =
      list(Loca = ~1, Block = ~1,Interaction=~1), lambda = 200, data =
      rcbd.dat)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      summary(meta2.glmmLasso)
    <|unfolded-prog-io>
      rcbd.dat$Interaction \<less\>- rcbd.dat$Loca:rcbd.dat$Entry

      \<gtr\>\ 

      \<gtr\> if(!file.exists("meta.glmmLasso.Rda")) {

      + \ \ Rprof("meta.glmmLasso.prof")

      + \ \ meta.glmmLasso \<less\>- glmmLasso(fix = YLD ~ 0+Entry, rnd =
      list(Loca = ~1, Bl

      \<less\>asso(fix = YLD ~ 0+Entry, rnd = list(Loca = ~1, Block =
      ~1,Interaction=~1),\ 

      \<less\>rnd = list(Loca = ~1, Block = ~1,Interaction=~1), lambda = 200,
      data = rcbd.

      \<less\>k = ~1,Interaction=~1), lambda = 200, data =
      rcbd.dat,control=glmmLassoContr

      \<less\>mbda = 200, data = rcbd.dat,control=glmmLassoControl(center=FALSE))

      + \ \ Rprof(NULL)

      + \ \ save(meta.glmmLasso,file="meta.glmmLasso.Rda")

      + } else {

      + \ \ load(file="meta.glmmLasso.Rda")

      + }

      \<gtr\> summary(meta.glmmLasso)

      Call:

      glmmLasso(fix = YLD ~ 0 + Entry, rnd = list(Loca = ~1, Block = ~1,\ 

      \ \ \ \ Interaction = ~1), data = rcbd.dat, lambda = 200, control =
      glmmLassoControl(center = FALSE))

      \;

      \;

      Fixed Effects:

      \;

      Coefficients:

      \ \ \ \ \ \ \ \ Estimate StdErr z.value p.value

      Entry1 \ \ \ 3.7593 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry2 \ \ \ 3.9481 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry3 \ \ \ 4.6134 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry4 \ \ \ 4.3839 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry5 \ \ \ 4.4085 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry6 \ \ \ 4.3786 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry7 \ \ \ 3.6864 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry8 \ \ \ 4.5347 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry9 \ \ \ 3.5189 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry10 \ \ 4.2396 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry11 \ \ 4.7966 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry12 \ \ 3.9344 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry13 \ \ 4.0813 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry14 \ \ 1.4717 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry15 \ \ 3.9523 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry16 \ \ 2.8474 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry17 \ \ 4.5079 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry18 \ \ 4.4146 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry19 \ \ 0.0000 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry20 \ \ 3.8065 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry21 \ \ 2.7672 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry22 \ \ 4.5333 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry23 \ \ 1.6573 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry24 \ \ 3.7909 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry25 \ \ 2.7547 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry26 \ \ 4.7687 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry27 \ \ 4.6562 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry28 \ \ 4.2614 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry29 \ \ 3.7104 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry30 \ \ 3.2098 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry31 \ \ 4.1120 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry32 \ \ 3.5708 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      \;

      Random Effects:

      \;

      StdDev:

      [[1]]

      \ \ \ \ \ \ \ \ \ Loca

      Loca 1.892442

      \;

      [[2]]

      \ \ \ \ \ \ \ \ \ \ Block

      Block 0.7391712

      \;

      [[3]]

      \ \ \ \ \ \ \ \ \ \ \ \ Interaction

      Interaction \ \ 0.2094442

      \;

      \<gtr\> meta.glmmLasso.summary \<less\>-
      summaryRprof("meta.glmmLasso.prof")

      \<gtr\> head(meta.glmmLasso.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      "%*%" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.88 \ \ \ 62.07
      \ \ \ \ \ \ 2.88 \ \ \ \ 62.07

      "matrix" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.38 \ \ \ \ 8.19
      \ \ \ \ \ \ 0.38 \ \ \ \ \ 8.19

      "est.glmmLasso.RE" \ \ \ \ \ 0.30 \ \ \ \ 6.47 \ \ \ \ \ \ 4.62
      \ \ \ \ 99.57

      "*" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.30 \ \ \ \ 6.47
      \ \ \ \ \ \ 0.30 \ \ \ \ \ 6.47

      "chol2inv" \ \ \ \ \ \ \ \ \ \ \ \ \ 0.22 \ \ \ \ 4.74 \ \ \ \ \ \ 0.36
      \ \ \ \ \ 7.76

      "chol.default" \ \ \ \ \ \ \ \ \ 0.14 \ \ \ \ 3.02 \ \ \ \ \ \ 0.14
      \ \ \ \ \ 3.02

      \<gtr\> head(meta.glmmLasso.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time
      self.pct

      "est.glmmLasso" \ \ \ \ \ \ \ \ \ 4.64 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "glmmLasso" \ \ \ \ \ \ \ \ \ \ \ \ \ 4.64 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "est.glmmLasso.RE" \ \ \ \ \ \ 4.62 \ \ \ \ 99.57 \ \ \ \ \ 0.30
      \ \ \ \ 6.47

      "%*%" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.88 \ \ \ \ 62.07
      \ \ \ \ \ 2.88 \ \ \ 62.07

      "matrix" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.38 \ \ \ \ \ 8.19
      \ \ \ \ \ 0.38 \ \ \ \ 8.19

      "chol2inv" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.36 \ \ \ \ \ 7.76
      \ \ \ \ \ 0.22 \ \ \ \ 4.74

      \<gtr\> meta2.glmmLasso \<less\>- glmmLasso(fix = YLD ~ 0+Entry, rnd =
      list(Loca = ~1, Blo

      \<less\>sso(fix = YLD ~ 0+Entry, rnd = list(Loca = ~1, Block =
      ~1,Interaction=~1), l

      \<less\>nd = list(Loca = ~1, Block = ~1,Interaction=~1), lambda = 200,
      data = rcbd.d

      \<less\> = ~1,Interaction=~1), lambda = 200, data = rcbd.dat)

      Error in est.glmmLasso.RE(fix = fix, rnd = rnd, data = data, lambda =
      lambda, \ :\ 

      \ \ Need intercept term when using center = TRUE

      \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      \<gtr\> summary(meta2.glmmLasso)

      Error in summary(meta2.glmmLasso) : object 'meta2.glmmLasso' not found
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("cotes.glmmLasso.Rda")) {

      \ \ Rprof("cotes.glmmLasso.prof")

      \ \ cotes.glmmLasso \<less\>- glmmLasso(fix = YLD ~ 0+Entry, rnd =
      list(Loca = ~1, Block = ~1,Loca=~ 0 + Entry), lambda = 200, data =
      rcbd.dat,control=glmmLassoControl(center=FALSE))

      \ \ Rprof(NULL)

      \ \ save(cotes.glmmLasso,file="cotes.glmmLasso.Rda")

      } else {

      \ \ load(file="cotes.glmmLasso.Rda")

      }
    <|unfolded-prog-io>
      if(!file.exists("cotes.glmmLasso.Rda")) {

      + \ \ Rprof("cotes.glmmLasso.prof")

      + \ \ cotes.glmmLasso \<less\>- glmmLasso(fix = YLD ~ 0+Entry, rnd =
      list(Loca = ~1, B

      \<less\>Lasso(fix = YLD ~ 0+Entry, rnd = list(Loca = ~1, Block =
      ~1,Loca=~ 0 + Entry

      \<less\> rnd = list(Loca = ~1, Block = ~1,Loca=~ 0 + Entry), lambda =
      200, data = rc

      \<less\>ck = ~1,Loca=~ 0 + Entry), lambda = 200, data =
      rcbd.dat,control=glmmLassoCo

      \<less\> lambda = 200, data = rcbd.dat,control=glmmLassoControl(center=FALSE))

      + \ \ Rprof(NULL)

      + \ \ save(cotes.glmmLasso,file="cotes.glmmLasso.Rda")

      + } else {

      + \ \ load(file="cotes.glmmLasso.Rda")

      + }
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      summary(cotes.glmmLasso)

      cotes.glmmLasso.summary \<less\>- summaryRprof("cotes.glmmLasso.prof")

      head(cotes.glmmLasso.summary[[1]])

      head(cotes.glmmLasso.summary[[2]])
    <|unfolded-prog-io>
      summary(cotes.glmmLasso)

      Call:

      glmmLasso(fix = YLD ~ 0 + Entry, rnd = list(Loca = ~1, Block = ~1,\ 

      \ \ \ \ Loca = ~0 + Entry), data = rcbd.dat, lambda = 200, control =
      glmmLassoControl(center = FALSE))

      \;

      \;

      Fixed Effects:

      \;

      Coefficients:

      \ \ \ \ \ \ \ \ Estimate StdErr z.value p.value

      Entry1 \ \ \ 3.7584 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry2 \ \ \ 3.9472 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry3 \ \ \ 4.6126 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry4 \ \ \ 4.3830 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry5 \ \ \ 4.4075 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry6 \ \ \ 4.3777 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry7 \ \ \ 3.6856 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry8 \ \ \ 4.5337 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry9 \ \ \ 3.5180 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry10 \ \ 4.2387 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry11 \ \ 4.7958 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry12 \ \ 3.9335 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry13 \ \ 4.0805 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry14 \ \ 1.4709 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry15 \ \ 3.9515 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry16 \ \ 2.8466 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry17 \ \ 4.5071 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry18 \ \ 4.4139 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry19 \ \ 0.0000 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry20 \ \ 3.8057 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry21 \ \ 2.7664 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry22 \ \ 4.5325 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry23 \ \ 1.6566 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry24 \ \ 3.7901 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry25 \ \ 2.7538 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry26 \ \ 4.7679 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry27 \ \ 4.6554 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry28 \ \ 4.2605 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry29 \ \ 3.7098 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry30 \ \ 3.2092 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry31 \ \ 4.1114 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      Entry32 \ \ 3.5702 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

      \;

      Random Effects:

      \;

      StdDev:

      [[1]]

      \ \ \ \ \ \ \ \ \ Loca

      Loca 1.892113

      \;

      [[2]]

      \ \ \ \ \ \ \ \ \ \ Block

      Block 0.7389701

      \;

      [[3]]

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca \ \ Loca:Entry2
      \ \ Loca:Entry3 \ \ Loca:Entry4

      Loca \ \ \ \ \ \ \ \ \ 0.0407871215 \ 0.0051585445 \ 0.0058518342
      \ 4.541678e-03

      Loca:Entry2 \ \ 0.0051585445 \ 0.0401121538 \ 0.0054161523
      \ 4.277147e-03

      Loca:Entry3 \ \ 0.0058518342 \ 0.0054161523 \ 0.0421658565
      \ 5.306322e-03

      Loca:Entry4 \ \ 0.0045416785 \ 0.0042771472 \ 0.0053063220
      \ 4.103444e-02

      Loca:Entry5 \ \ 0.0044308755 \ 0.0040297460 \ 0.0049698457
      \ 5.164367e-03

      Loca:Entry6 \ \ 0.0080571228 \ 0.0069559100 \ 0.0086127216
      \ 8.253307e-03

      Loca:Entry7 \ \ 0.0075241655 \ 0.0072079139 \ 0.0083529423
      \ 7.346710e-03

      Loca:Entry8 \ \ 0.0082017160 \ 0.0072909429 \ 0.0090132567
      \ 8.000931e-03

      Loca:Entry9 \ \ 0.0037157250 \ 0.0009787862 \ 0.0010018721
      \ 8.407332e-04

      Loca:Entry10 \ 0.0019353696 \ 0.0044925376 \ 0.0024318957
      \ 1.891082e-03

      Loca:Entry11 \ 0.0033028931 \ 0.0026799692 \ 0.0062074284
      \ 2.612048e-03

      Loca:Entry12 \ 0.0068515420 \ 0.0066687990 \ 0.0074804512
      \ 1.015625e-02

      Loca:Entry13 \ 0.0068975231 \ 0.0061100027 \ 0.0078814822
      \ 6.760768e-03

      Loca:Entry14 -0.0017870374 -0.0005362207 -0.0016332906 -6.512359e-04

      Loca:Entry15 -0.0034272604 -0.0036282931 -0.0041214559 -3.335517e-03

      Loca:Entry16 -0.0039856503 -0.0034949348 -0.0044925516 -3.921804e-03

      Loca:Entry17 \ 0.0025899627 -0.0001224582 -0.0001915903 -4.873646e-05

      Loca:Entry18 -0.0002666012 \ 0.0023379037 -0.0005519263 -8.777810e-04

      Loca:Entry19 \ 0.0014057930 \ 0.0007973166 \ 0.0042299179
      \ 7.629652e-04

      Loca:Entry20 \ 0.0044969226 \ 0.0044306954 \ 0.0054099451
      \ 7.786305e-03

      Loca:Entry21 \ 0.0038311391 \ 0.0034598595 \ 0.0039060276
      \ 3.885022e-03

      Loca:Entry22 -0.0008794826 -0.0002232376 -0.0003800019 -4.495182e-04

      Loca:Entry23 -0.0015532586 -0.0017357298 -0.0016682409 -1.479738e-03

      Loca:Entry24 -0.0017762847 -0.0014991048 -0.0019771171 -1.975506e-03

      Loca:Entry25 \ 0.0152026404 \ 0.0112035368 \ 0.0133177961
      \ 1.197947e-02

      Loca:Entry26 \ 0.0100489774 \ 0.0124305686 \ 0.0104449710
      \ 9.706043e-03

      Loca:Entry27 \ 0.0104124826 \ 0.0100428742 \ 0.0146372413
      \ 1.067508e-02

      Loca:Entry28 \ 0.0056212998 \ 0.0051960417 \ 0.0060723102
      \ 8.120033e-03

      Loca:Entry29 \ 0.0053310800 \ 0.0049613352 \ 0.0061871764
      \ 5.184987e-03

      Loca:Entry30 \ 0.0010218807 \ 0.0017234100 \ 0.0015784632
      \ 1.575086e-03

      Loca:Entry31 \ 0.0005575074 \ 0.0001637337 \ 0.0005843379
      \ 3.205891e-04

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca:Entry5 \ \ Loca:Entry6
      \ \ Loca:Entry7 \ \ Loca:Entry8

      Loca \ \ \ \ \ \ \ \ \ 0.0044308755 \ 0.0080571228 \ 0.0075241655
      \ 0.0082017160

      Loca:Entry2 \ \ 0.0040297460 \ 0.0069559100 \ 0.0072079139
      \ 0.0072909429

      Loca:Entry3 \ \ 0.0049698457 \ 0.0086127216 \ 0.0083529423
      \ 0.0090132567

      Loca:Entry4 \ \ 0.0051643672 \ 0.0082533074 \ 0.0073467103
      \ 0.0080009315

      Loca:Entry5 \ \ 0.0413800756 \ 0.0076509801 \ 0.0069252449
      \ 0.0080987531

      Loca:Entry6 \ \ 0.0076509801 \ 0.0505966204 \ 0.0129167162
      \ 0.0147557852

      Loca:Entry7 \ \ 0.0069252449 \ 0.0129167162 \ 0.0494004998
      \ 0.0134643562

      Loca:Entry8 \ \ 0.0080987531 \ 0.0147557852 \ 0.0134643562
      \ 0.0511694011

      Loca:Entry9 \ \ 0.0010841380 \ 0.0017650149 \ 0.0011579011
      \ 0.0019136408

      Loca:Entry10 \ 0.0012145463 \ 0.0027273425 \ 0.0027143915
      \ 0.0030010219

      Loca:Entry11 \ 0.0030652463 \ 0.0061851609 \ 0.0044128708
      \ 0.0058678006

      Loca:Entry12 \ 0.0069551509 \ 0.0113634182 \ 0.0117784727
      \ 0.0121547299

      Loca:Entry13 \ 0.0095435456 \ 0.0121774695 \ 0.0108929156
      \ 0.0126158158

      Loca:Entry14 -0.0009892825 -0.0016736290 -0.0012290619 -0.0019137708

      Loca:Entry15 -0.0031232065 -0.0053716579 -0.0035438843 -0.0056390532

      Loca:Entry16 -0.0038807921 -0.0067584758 -0.0057166811 -0.0043003483

      Loca:Entry17 -0.0003932852 -0.0008085563 -0.0004518097 -0.0004747991

      Loca:Entry18 -0.0005529943 -0.0007030530 -0.0006428403 -0.0008807248

      Loca:Entry19 \ 0.0009550032 \ 0.0031587534 \ 0.0014406627
      \ 0.0024741004

      Loca:Entry20 \ 0.0041376438 \ 0.0074756505 \ 0.0077127255
      \ 0.0080536244

      Loca:Entry21 \ 0.0070604214 \ 0.0060519190 \ 0.0060643897
      \ 0.0070260000

      Loca:Entry22 -0.0005846466 \ 0.0003310624 -0.0003836329 -0.0010350105

      Loca:Entry23 -0.0014190276 -0.0021150134 -0.0004474278 -0.0020013626

      Loca:Entry24 -0.0018072832 -0.0031957467 -0.0025650954 -0.0004903462

      Loca:Entry25 \ 0.0114886040 \ 0.0212319577 \ 0.0194297037
      \ 0.0216569228

      Loca:Entry26 \ 0.0104421684 \ 0.0171519716 \ 0.0172198956
      \ 0.0176765367

      Loca:Entry27 \ 0.0092529104 \ 0.0164393486 \ 0.0180602509
      \ 0.0178425799

      Loca:Entry28 \ 0.0057517870 \ 0.0091364701 \ 0.0091280188
      \ 0.0096668041

      Loca:Entry29 \ 0.0073687971 \ 0.0095302557 \ 0.0087961402
      \ 0.0090430730

      Loca:Entry30 \ 0.0013119074 \ 0.0038151212 \ 0.0030622660
      \ 0.0024954939

      Loca:Entry31 \ 0.0003493658 \ 0.0012414136 \ 0.0031543409
      \ 0.0012787277

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca:Entry9 \ Loca:Entry10 \ Loca:Entry11
      \ Loca:Entry12

      Loca \ \ \ \ \ \ \ \ \ 3.715725e-03 \ 1.935370e-03 \ 3.302893e-03
      \ 6.851542e-03

      Loca:Entry2 \ \ 9.787862e-04 \ 4.492538e-03 \ 2.679969e-03
      \ 6.668799e-03

      Loca:Entry3 \ \ 1.001872e-03 \ 2.431896e-03 \ 6.207428e-03
      \ 7.480451e-03

      Loca:Entry4 \ \ 8.407332e-04 \ 1.891082e-03 \ 2.612048e-03
      \ 1.015625e-02

      Loca:Entry5 \ \ 1.084138e-03 \ 1.214546e-03 \ 3.065246e-03
      \ 6.955151e-03

      Loca:Entry6 \ \ 1.765015e-03 \ 2.727343e-03 \ 6.185161e-03
      \ 1.136342e-02

      Loca:Entry7 \ \ 1.157901e-03 \ 2.714392e-03 \ 4.412871e-03
      \ 1.177847e-02

      Loca:Entry8 \ \ 1.913641e-03 \ 3.001022e-03 \ 5.867801e-03
      \ 1.215473e-02

      Loca:Entry9 \ \ 3.672046e-02 \ 1.039321e-03 \ 2.110217e-03
      \ 1.265037e-03

      Loca:Entry10 \ 1.039321e-03 \ 3.752398e-02 \ 1.227949e-03
      \ 2.529315e-03

      Loca:Entry11 \ 2.110217e-03 \ 1.227949e-03 \ 4.070989e-02
      \ 4.007414e-03

      Loca:Entry12 \ 1.265037e-03 \ 2.529315e-03 \ 4.007414e-03
      \ 4.745512e-02

      Loca:Entry13 \ 1.702499e-03 \ 2.542497e-03 \ 5.596308e-03
      \ 1.091735e-02

      Loca:Entry14 -3.644621e-04 -3.900199e-04 -2.929936e-03 \ 5.877539e-04

      Loca:Entry15 -7.716785e-04 -1.305728e-03 -2.202771e-03 -5.481768e-03

      Loca:Entry16 -9.449295e-04 -1.933451e-03 -2.724134e-03 -5.645141e-03

      Loca:Entry17 \ 2.508372e-03 \ 4.276272e-04 -9.955238e-04 -8.904398e-05

      Loca:Entry18 -8.539801e-05 \ 2.292422e-03 \ 1.926506e-05 -9.134798e-04

      Loca:Entry19 \ 1.133273e-03 \ 1.209010e-05 \ 6.302201e-03
      \ 6.466843e-04

      Loca:Entry20 \ 8.742840e-04 \ 2.084886e-03 \ 2.533671e-03
      \ 1.028390e-02

      Loca:Entry21 \ 6.868970e-04 \ 1.160334e-03 \ 2.310969e-03
      \ 6.390815e-03

      Loca:Entry22 -4.989529e-04 \ 1.176781e-04 -1.981036e-03 -3.505416e-05

      Loca:Entry23 -1.471624e-04 -2.660147e-04 -8.125882e-04 -2.676998e-03

      Loca:Entry24 -3.613912e-04 -8.961189e-04 -9.452370e-04 -2.728165e-03

      Loca:Entry25 \ 5.547715e-03 \ 4.102608e-03 \ 9.010796e-03
      \ 1.816370e-02

      Loca:Entry26 \ 2.416190e-03 \ 4.827282e-03 \ 7.085549e-03
      \ 1.601718e-02

      Loca:Entry27 \ 1.201379e-03 \ 4.624348e-03 \ 6.999362e-03
      \ 1.700630e-02

      Loca:Entry28 \ 1.019303e-03 \ 1.869433e-03 \ 3.959880e-03
      \ 1.129016e-02

      Loca:Entry29 \ 1.293298e-03 \ 2.151284e-03 \ 4.349759e-03
      \ 7.570127e-03

      Loca:Entry30 \ 2.522509e-04 \ 5.298604e-04 -9.825012e-05 \ 3.241118e-03

      Loca:Entry31 \ 8.470189e-05 \ 2.163773e-05 \ 8.437182e-04
      \ 2.773180e-04

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca:Entry13 \ Loca:Entry14 \ Loca:Entry15
      \ Loca:Entry16

      Loca \ \ \ \ \ \ \ \ \ 0.0068975231 -0.0017870374 -0.0034272604
      -0.0039856503

      Loca:Entry2 \ \ 0.0061100027 -0.0005362207 -0.0036282931 -0.0034949348

      Loca:Entry3 \ \ 0.0078814822 -0.0016332906 -0.0041214559 -0.0044925516

      Loca:Entry4 \ \ 0.0067607683 -0.0006512359 -0.0033355169 -0.0039218037

      Loca:Entry5 \ \ 0.0095435456 -0.0009892825 -0.0031232065 -0.0038807921

      Loca:Entry6 \ \ 0.0121774695 -0.0016736290 -0.0053716579 -0.0067584758

      Loca:Entry7 \ \ 0.0108929156 -0.0012290619 -0.0035438843 -0.0057166811

      Loca:Entry8 \ \ 0.0126158158 -0.0019137708 -0.0056390532 -0.0043003483

      Loca:Entry9 \ \ 0.0017024988 -0.0003644621 -0.0007716785 -0.0009449295

      Loca:Entry10 \ 0.0025424965 -0.0003900199 -0.0013057283 -0.0019334514

      Loca:Entry11 \ 0.0055963076 -0.0029299359 -0.0022027705 -0.0027241339

      Loca:Entry12 \ 0.0109173543 \ 0.0005877539 -0.0054817680 -0.0056451413

      Loca:Entry13 \ 0.0472675348 -0.0024475953 -0.0049913543 -0.0061168289

      Loca:Entry14 -0.0024475953 \ 0.0451956567 \ 0.0005862030 \ 0.0023915036

      Loca:Entry15 -0.0049913543 \ 0.0005862030 \ 0.0395118355 \ 0.0035037180

      Loca:Entry16 -0.0061168289 \ 0.0023915036 \ 0.0035037180 \ 0.0397363491

      Loca:Entry17 -0.0006060396 \ 0.0009443315 \ 0.0003785807 \ 0.0001054113

      Loca:Entry18 -0.0007705290 -0.0008391476 \ 0.0002721379 \ 0.0005325094

      Loca:Entry19 \ 0.0027744054 -0.0025009639 -0.0009569284 -0.0011762831

      Loca:Entry20 \ 0.0070678467 \ 0.0005846797 -0.0037932667 -0.0038548763

      Loca:Entry21 \ 0.0081951916 \ 0.0008674375 -0.0027178764 -0.0031035190

      Loca:Entry22 -0.0012058741 \ 0.0072497324 -0.0001001224 \ 0.0009450638

      Loca:Entry23 -0.0017492493 -0.0005334801 \ 0.0046682612 \ 0.0007594990

      Loca:Entry24 -0.0031565217 \ 0.0008816402 \ 0.0009476603 \ 0.0046155895

      Loca:Entry25 \ 0.0179875282 -0.0034171934 -0.0091897685 -0.0099621568

      Loca:Entry26 \ 0.0149247208 -0.0020025396 -0.0081038439 -0.0074442646

      Loca:Entry27 \ 0.0148511169 \ 0.0003462027 -0.0085297334 -0.0084360547

      Loca:Entry28 \ 0.0079345937 -0.0012311949 -0.0043058067 -0.0044358337

      Loca:Entry29 \ 0.0110246991 -0.0035254188 -0.0044585904 -0.0046722289

      Loca:Entry30 \ 0.0018891191 \ 0.0071798300 -0.0017731095 -0.0005656330

      Loca:Entry31 \ 0.0009776812 -0.0006844662 \ 0.0028766253 -0.0003173219

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca:Entry17 \ Loca:Entry18 \ Loca:Entry19
      \ Loca:Entry20

      Loca \ \ \ \ \ \ \ \ \ 2.589963e-03 -2.666012e-04 \ 0.0014057930
      \ 4.496923e-03

      Loca:Entry2 \ -1.224582e-04 \ 2.337904e-03 \ 0.0007973166
      \ 4.430695e-03

      Loca:Entry3 \ -1.915903e-04 -5.519263e-04 \ 0.0042299179 \ 5.409945e-03

      Loca:Entry4 \ -4.873646e-05 -8.777810e-04 \ 0.0007629652 \ 7.786305e-03

      Loca:Entry5 \ -3.932852e-04 -5.529943e-04 \ 0.0009550032 \ 4.137644e-03

      Loca:Entry6 \ -8.085563e-04 -7.030530e-04 \ 0.0031587534 \ 7.475650e-03

      Loca:Entry7 \ -4.518097e-04 -6.428403e-04 \ 0.0014406627 \ 7.712725e-03

      Loca:Entry8 \ -4.747991e-04 -8.807248e-04 \ 0.0024741004 \ 8.053624e-03

      Loca:Entry9 \ \ 2.508372e-03 -8.539801e-05 \ 0.0011332727
      \ 8.742840e-04

      Loca:Entry10 \ 4.276272e-04 \ 2.292422e-03 \ 0.0000120901
      \ 2.084886e-03

      Loca:Entry11 -9.955238e-04 \ 1.926506e-05 \ 0.0063022013 \ 2.533671e-03

      Loca:Entry12 -8.904398e-05 -9.134798e-04 \ 0.0006466843 \ 1.028390e-02

      Loca:Entry13 -6.060396e-04 -7.705290e-04 \ 0.0027744054 \ 7.067847e-03

      Loca:Entry14 \ 9.443315e-04 -8.391476e-04 -0.0025009639 \ 5.846797e-04

      Loca:Entry15 \ 3.785807e-04 \ 2.721379e-04 -0.0009569284 -3.793267e-03

      Loca:Entry16 \ 1.054113e-04 \ 5.325094e-04 -0.0011762831 -3.854876e-03

      Loca:Entry17 \ 3.652669e-02 \ 7.543296e-04 -0.0004391779 -7.078763e-05

      Loca:Entry18 \ 7.543296e-04 \ 3.665842e-02 \ 0.0004810693 -8.429764e-04

      Loca:Entry19 -4.391779e-04 \ 4.810693e-04 \ 0.0396586213 \ 9.977657e-04

      Loca:Entry20 -7.078763e-05 -8.429764e-04 \ 0.0009977657 \ 4.153212e-02

      Loca:Entry21 -4.513870e-05 -4.069010e-04 \ 0.0007284173 \ 4.718682e-03

      Loca:Entry22 \ 6.797497e-04 -4.422540e-04 -0.0017198447 \ 6.513758e-04

      Loca:Entry23 \ 2.672274e-04 -6.567606e-05 -0.0002200131 -1.707896e-03

      Loca:Entry24 -1.892526e-04 \ 3.421666e-04 -0.0003922054 -1.857198e-03

      Loca:Entry25 \ 1.692631e-03 -7.637795e-04 \ 0.0041456893 \ 1.198552e-02

      Loca:Entry26 -1.014385e-03 \ 2.726864e-03 \ 0.0024028999 \ 9.645575e-03

      Loca:Entry27 \ 4.249608e-04 -8.981676e-04 \ 0.0027461313 \ 1.144075e-02

      Loca:Entry28 -3.559131e-04 -3.505828e-04 \ 0.0011904863 \ 8.028182e-03

      Loca:Entry29 -6.982475e-04 -3.999188e-04 \ 0.0022710825 \ 5.200656e-03

      Loca:Entry30 \ 3.383435e-04 -6.022675e-04 -0.0007611940 \ 2.518067e-03

      Loca:Entry31 -1.795556e-04 \ 1.243233e-04 \ 0.0005676135 \ 4.112814e-04

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca:Entry21 \ Loca:Entry22 \ Loca:Entry23
      \ Loca:Entry24

      Loca \ \ \ \ \ \ \ \ \ 0.0038311391 -8.794826e-04 -1.553259e-03
      -0.0017762847

      Loca:Entry2 \ \ 0.0034598595 -2.232376e-04 -1.735730e-03 -0.0014991048

      Loca:Entry3 \ \ 0.0039060276 -3.800019e-04 -1.668241e-03 -0.0019771171

      Loca:Entry4 \ \ 0.0038850215 -4.495182e-04 -1.479738e-03 -0.0019755055

      Loca:Entry5 \ \ 0.0070604214 -5.846466e-04 -1.419028e-03 -0.0018072832

      Loca:Entry6 \ \ 0.0060519190 \ 3.310624e-04 -2.115013e-03 -0.0031957467

      Loca:Entry7 \ \ 0.0060643897 -3.836329e-04 -4.474278e-04 -0.0025650954

      Loca:Entry8 \ \ 0.0070260000 -1.035011e-03 -2.001363e-03 -0.0004903462

      Loca:Entry9 \ \ 0.0006868970 -4.989529e-04 -1.471624e-04 -0.0003613912

      Loca:Entry10 \ 0.0011603336 \ 1.176781e-04 -2.660147e-04 -0.0008961189

      Loca:Entry11 \ 0.0023109690 -1.981036e-03 -8.125882e-04 -0.0009452370

      Loca:Entry12 \ 0.0063908153 -3.505416e-05 -2.676998e-03 -0.0027281652

      Loca:Entry13 \ 0.0081951916 -1.205874e-03 -1.749249e-03 -0.0031565217

      Loca:Entry14 \ 0.0008674375 \ 7.249732e-03 -5.334801e-04 \ 0.0008816402

      Loca:Entry15 -0.0027178764 -1.001224e-04 \ 4.668261e-03 \ 0.0009476603

      Loca:Entry16 -0.0031035190 \ 9.450638e-04 \ 7.594990e-04 \ 0.0046155895

      Loca:Entry17 -0.0000451387 \ 6.797497e-04 \ 2.672274e-04 -0.0001892526

      Loca:Entry18 -0.0004069010 -4.422540e-04 -6.567606e-05 \ 0.0003421666

      Loca:Entry19 \ 0.0007284173 -1.719845e-03 -2.200131e-04 -0.0003922054

      Loca:Entry20 \ 0.0047186823 \ 6.513758e-04 -1.707896e-03 -0.0018571975

      Loca:Entry21 \ 0.0400681239 \ 4.290436e-04 -1.440484e-03 -0.0013818789

      Loca:Entry22 \ 0.0004290436 \ 3.871853e-02 \ 3.616582e-04
      \ 0.0009347310

      Loca:Entry23 -0.0014404841 \ 3.616582e-04 \ 3.740597e-02 \ 0.0009461208

      Loca:Entry24 -0.0013818789 \ 9.347310e-04 \ 9.461208e-04 \ 0.0372227345

      Loca:Entry25 \ 0.0102091086 -2.258817e-03 -4.323864e-03 -0.0042876272

      Loca:Entry26 \ 0.0088550823 -1.411838e-03 -4.361192e-03 -0.0035775507

      Loca:Entry27 \ 0.0089099949 \ 6.667847e-04 -4.009804e-03 -0.0041086297

      Loca:Entry28 \ 0.0050710893 -5.236792e-04 -2.156696e-03 -0.0017583260

      Loca:Entry29 \ 0.0062771546 -1.636977e-03 -1.687138e-03 -0.0019413076

      Loca:Entry30 \ 0.0018650238 \ 5.198850e-03 -1.024021e-03 -0.0003196947

      Loca:Entry31 \ 0.0003834601 -2.796502e-04 \ 2.894305e-03 -0.0001261627

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca:Entry25 \ Loca:Entry26 \ Loca:Entry27
      \ Loca:Entry28

      Loca \ \ \ \ \ \ \ \ \ 0.0152026404 \ 0.0100489774 \ 0.0104124826
      \ 0.0056212998

      Loca:Entry2 \ \ 0.0112035368 \ 0.0124305686 \ 0.0100428742
      \ 0.0051960417

      Loca:Entry3 \ \ 0.0133177961 \ 0.0104449710 \ 0.0146372413
      \ 0.0060723102

      Loca:Entry4 \ \ 0.0119794697 \ 0.0097060426 \ 0.0106750779
      \ 0.0081200329

      Loca:Entry5 \ \ 0.0114886040 \ 0.0104421684 \ 0.0092529104
      \ 0.0057517870

      Loca:Entry6 \ \ 0.0212319577 \ 0.0171519716 \ 0.0164393486
      \ 0.0091364701

      Loca:Entry7 \ \ 0.0194297037 \ 0.0172198956 \ 0.0180602509
      \ 0.0091280188

      Loca:Entry8 \ \ 0.0216569228 \ 0.0176765367 \ 0.0178425799
      \ 0.0096668041

      Loca:Entry9 \ \ 0.0055477146 \ 0.0024161896 \ 0.0012013789
      \ 0.0010193029

      Loca:Entry10 \ 0.0041026075 \ 0.0048272817 \ 0.0046243485
      \ 0.0018694332

      Loca:Entry11 \ 0.0090107958 \ 0.0070855491 \ 0.0069993619
      \ 0.0039598800

      Loca:Entry12 \ 0.0181637018 \ 0.0160171754 \ 0.0170063034
      \ 0.0112901607

      Loca:Entry13 \ 0.0179875282 \ 0.0149247208 \ 0.0148511169
      \ 0.0079345937

      Loca:Entry14 -0.0034171934 -0.0020025396 \ 0.0003462027 -0.0012311949

      Loca:Entry15 -0.0091897685 -0.0081038439 -0.0085297334 -0.0043058067

      Loca:Entry16 -0.0099621568 -0.0074442646 -0.0084360547 -0.0044358337

      Loca:Entry17 \ 0.0016926311 -0.0010143852 \ 0.0004249608 -0.0003559131

      \;

      Loca:Entry18 -0.0007637795 \ 0.0027268643 -0.0008981676 -0.0003505828

      Loca:Entry19 \ 0.0041456893 \ 0.0024028999 \ 0.0027461313
      \ 0.0011904863

      Loca:Entry20 \ 0.0119855245 \ 0.0096455751 \ 0.0114407497
      \ 0.0080281824

      Loca:Entry21 \ 0.0102091086 \ 0.0088550823 \ 0.0089099949
      \ 0.0050710893

      Loca:Entry22 -0.0022588174 -0.0014118378 \ 0.0006667847 -0.0005236792

      Loca:Entry23 -0.0043238641 -0.0043611919 -0.0040098037 -0.0021566956

      Loca:Entry24 -0.0042876272 -0.0035775507 -0.0041086297 -0.0017583260

      Loca:Entry25 \ 0.0690425463 \ 0.0282667702 \ 0.0272916425
      \ 0.0144665366

      Loca:Entry26 \ 0.0282667702 \ 0.0626261673 \ 0.0234666935
      \ 0.0126149562

      Loca:Entry27 \ 0.0272916425 \ 0.0234666935 \ 0.0634823553
      \ 0.0124884944

      Loca:Entry28 \ 0.0144665366 \ 0.0126149562 \ 0.0124884944
      \ 0.0433486072

      Loca:Entry29 \ 0.0137861990 \ 0.0111679927 \ 0.0116793333
      \ 0.0071560811

      Loca:Entry30 \ 0.0032666608 \ 0.0037900895 \ 0.0049228271
      \ 0.0021339828

      Loca:Entry31 \ 0.0016264104 \ 0.0009341754 \ 0.0004256785
      \ 0.0005201007

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Loca:Entry29 \ Loca:Entry30 \ Loca:Entry31
      \ Loca:Entry32

      Loca \ \ \ \ \ \ \ \ \ 0.0053310800 \ 1.021881e-03 \ 5.575074e-04
      -0.0008028929

      Loca:Entry2 \ \ 0.0049613352 \ 1.723410e-03 \ 1.637337e-04
      -0.0005642125

      Loca:Entry3 \ \ 0.0061871764 \ 1.578463e-03 \ 5.843379e-04
      -0.0006261920

      Loca:Entry4 \ \ 0.0051849869 \ 1.575086e-03 \ 3.205891e-04
      -0.0008555673

      Loca:Entry5 \ \ 0.0073687971 \ 1.311907e-03 \ 3.493658e-04
      -0.0012166500

      Loca:Entry6 \ \ 0.0095302557 \ 3.815121e-03 \ 1.241414e-03
      -0.0018816093

      Loca:Entry7 \ \ 0.0087961402 \ 3.062266e-03 \ 3.154341e-03
      -0.0003268068

      Loca:Entry8 \ \ 0.0090430730 \ 2.495494e-03 \ 1.278728e-03
      \ 0.0011479190

      Loca:Entry9 \ \ 0.0012932980 \ 2.522509e-04 \ 8.470189e-05
      -0.0006507093

      Loca:Entry10 \ 0.0021512837 \ 5.298604e-04 \ 2.163773e-05 -0.0001569059

      Loca:Entry11 \ 0.0043497593 -9.825012e-05 \ 8.437182e-04 -0.0014253126

      Loca:Entry12 \ 0.0075701271 \ 3.241118e-03 \ 2.773180e-04 -0.0008267709

      Loca:Entry13 \ 0.0110246991 \ 1.889119e-03 \ 9.776812e-04 -0.0013392386

      Loca:Entry14 -0.0035254188 \ 7.179830e-03 -6.844662e-04 \ 0.0016029700

      Loca:Entry15 -0.0044585904 -1.773110e-03 \ 2.876625e-03 \ 0.0001827420

      Loca:Entry16 -0.0046722289 -5.656330e-04 -3.173219e-04 \ 0.0038895006

      Loca:Entry17 -0.0006982475 \ 3.383435e-04 -1.795556e-04 \ 0.0002803831

      Loca:Entry18 -0.0003999188 -6.022675e-04 \ 1.243233e-04 \ 0.0001904199

      Loca:Entry19 \ 0.0022710825 -7.611940e-04 \ 5.676135e-04 -0.0010432655

      Loca:Entry20 \ 0.0052006556 \ 2.518067e-03 \ 4.112814e-04 -0.0002732776

      Loca:Entry21 \ 0.0062771546 \ 1.865024e-03 \ 3.834601e-04 -0.0006192325

      Loca:Entry22 -0.0016369771 \ 5.198850e-03 -2.796502e-04 \ 0.0012414825

      Loca:Entry23 -0.0016871383 -1.024021e-03 \ 2.894305e-03 -0.0001898376

      Loca:Entry24 -0.0019413076 -3.196947e-04 -1.261627e-04 \ 0.0032676792

      Loca:Entry25 \ 0.0137861990 \ 3.266661e-03 \ 1.626410e-03 -0.0022353818

      Loca:Entry26 \ 0.0111679927 \ 3.790089e-03 \ 9.341754e-04 -0.0014662413

      Loca:Entry27 \ 0.0116793333 \ 4.922827e-03 \ 4.256785e-04 -0.0001414308

      Loca:Entry28 \ 0.0071560811 \ 2.133983e-03 \ 5.201007e-04 -0.0008961558

      Loca:Entry29 \ 0.0433988526 \ 1.084728e-03 \ 3.156679e-04 -0.0010826423

      Loca:Entry30 \ 0.0010847276 \ 3.924568e-02 \ 4.008909e-04
      \ 0.0013861058

      Loca:Entry31 \ 0.0003156679 \ 4.008909e-04 \ 3.659197e-02
      \ 0.0007621810

      \ [ reached getOption("max.print") -- omitted 1 row ]

      \;

      \<gtr\> cotes.glmmLasso.summary \<less\>-
      summaryRprof("cotes.glmmLasso.prof")

      \<gtr\> head(cotes.glmmLasso.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      "%*%" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.82 \ \ \ 71.94
      \ \ \ \ \ \ 2.82 \ \ \ \ 71.94

      "chol.default" \ \ \ \ \ \ \ \ \ 0.28 \ \ \ \ 7.14 \ \ \ \ \ \ 0.28
      \ \ \ \ \ 7.14

      "chol2inv" \ \ \ \ \ \ \ \ \ \ \ \ \ 0.22 \ \ \ \ 5.61 \ \ \ \ \ \ 0.50
      \ \ \ \ 12.76

      "rownames\<less\>-" \ \ \ \ \ \ \ \ \ \ \ 0.16 \ \ \ \ 4.08
      \ \ \ \ \ \ 0.16 \ \ \ \ \ 4.08

      "est.glmmLasso.RE" \ \ \ \ \ 0.12 \ \ \ \ 3.06 \ \ \ \ \ \ 3.92
      \ \ \ 100.00

      "*" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.06 \ \ \ \ 1.53
      \ \ \ \ \ \ 0.06 \ \ \ \ \ 1.53

      \<gtr\> head(cotes.glmmLasso.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time
      self.pct

      "est.glmmLasso.RE" \ \ \ \ \ \ 3.92 \ \ \ 100.00 \ \ \ \ \ 0.12
      \ \ \ \ 3.06

      "est.glmmLasso" \ \ \ \ \ \ \ \ \ 3.92 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "glmmLasso" \ \ \ \ \ \ \ \ \ \ \ \ \ 3.92 \ \ \ 100.00 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "%*%" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.82 \ \ \ \ 71.94
      \ \ \ \ \ 2.82 \ \ \ 71.94

      "chol2inv" \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.50 \ \ \ \ 12.76
      \ \ \ \ \ 0.22 \ \ \ \ 5.61

      "doTryCatch" \ \ \ \ \ \ \ \ \ \ \ \ 0.50 \ \ \ \ 12.76 \ \ \ \ \ 0.00
      \ \ \ \ 0.00
    </unfolded-prog-io|>

    \;

    <\textput>
      <section|minque>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(minque)
    <|unfolded-prog-io>
      library(minque)

      Loading required package: klaR
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.minque.Rda")) {

      \ \ Rprof("meta.minque.prof")

      \ \ meta.minque \<less\>- lmm(YLD ~ Entry \| Loca/Repe + Loca:Entry,
      data=rcbd.dat, method="reml")

      \ \ Rprof(NULL)

      \ \ save(meta.minque,file="meta.minque.Rda")

      } else {

      \ \ load(file="meta.minque.Rda")

      }

      meta.minque.summary \<less\>- summaryRprof("meta.minque.prof")

      head(meta.minque.summary[[1]])

      head(meta.minque.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("meta.minque.Rda")) {

      + \ \ Rprof("meta.minque.prof")

      + \ \ meta.minque \<less\>- lmm(YLD ~ Entry \| Loca/Repe + Loca:Entry,
      data=rcbd.dat, m

      \<less\>~ Entry \| Loca/Repe + Loca:Entry, data=rcbd.dat,
      method="reml")

      + \ \ Rprof(NULL)

      + \ \ save(meta.minque,file="meta.minque.Rda")

      + } else {

      + \ \ load(file="meta.minque.Rda")

      + }

      \<gtr\> meta.minque.summary \<less\>- summaryRprof("meta.minque.prof")

      \<gtr\> head(meta.minque.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time total.pct

      "%*%" \ \ \ \ \ \ \ \ \ \ \ 15.70 \ \ \ 95.62 \ \ \ \ \ 15.70
      \ \ \ \ 95.62

      "sort.int" \ \ \ \ \ \ \ 0.12 \ \ \ \ 0.73 \ \ \ \ \ \ 0.14
      \ \ \ \ \ 0.85

      "t.default" \ \ \ \ \ \ 0.12 \ \ \ \ 0.73 \ \ \ \ \ \ 0.12
      \ \ \ \ \ 0.73

      "Ops.factor" \ \ \ \ \ 0.10 \ \ \ \ 0.61 \ \ \ \ \ \ 0.40
      \ \ \ \ \ 2.44

      "NextMethod" \ \ \ \ \ 0.08 \ \ \ \ 0.49 \ \ \ \ \ \ 0.08
      \ \ \ \ \ 0.49

      "is.na" \ \ \ \ \ \ \ \ \ \ 0.08 \ \ \ \ 0.49 \ \ \ \ \ \ 0.08
      \ \ \ \ \ 0.49

      \<gtr\> head(meta.minque.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time self.pct

      "lmm" \ \ \ \ \ \ \ \ \ \ \ \ \ 16.42 \ \ \ 100.00 \ \ \ \ \ \ 0.0
      \ \ \ \ 0.00

      "lmm1" \ \ \ \ \ \ \ \ \ \ \ \ 16.42 \ \ \ 100.00 \ \ \ \ \ \ 0.0
      \ \ \ \ 0.00

      "genmod.reml" \ \ \ \ \ 15.92 \ \ \ \ 96.95 \ \ \ \ \ \ 0.0
      \ \ \ \ 0.00

      "reml0" \ \ \ \ \ \ \ \ \ \ \ 15.92 \ \ \ \ 96.95 \ \ \ \ \ \ 0.0
      \ \ \ \ 0.00

      "%*%" \ \ \ \ \ \ \ \ \ \ \ \ \ 15.70 \ \ \ \ 95.62 \ \ \ \ \ 15.7
      \ \ \ 95.62

      "genmod" \ \ \ \ \ \ \ \ \ \ 15.00 \ \ \ \ 91.35 \ \ \ \ \ \ 0.0
      \ \ \ \ 0.00
    </unfolded-prog-io|>

    <\textput>
      <section|MCMCglmm>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.mcmc.Rda")) {

      \ \ \ Rprof("meta.MCMCglmm.prof")

      \ \ \ meta.mcmc \<less\>- MCMCglmm(fixed=YLD ~ 0 + Entry, random = ~
      Loca + Loca:Entry + Loca:Repe, data=rcbd.dat,verbose=FALSE)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ YLD ~ Entry
      + (1 \| Loca/Repe) + (1 \| Loca:Entry)

      \ \ \ Rprof(NULL)

      \ \ \ Rprof("meta.cotes.MCMCglmm.prof")

      \ \ \ cotes.mcmc \<less\>- MCMCglmm(fixed=YLD ~ 0 + Entry, random = ~
      Loca + idh(Entry):Loca + \ Loca:Repe,rcov=~idh(Loca):units,data=rcbd.dat,verbose=FALSE)

      \ \ \ Rprof(NULL)

      \ \ \ save(meta.mcmc,file="meta.mcmc.Rda")

      \ \ \ save(cotes.mcmc,file="cotes.mcmc.Rda")

      \ \ \ 

      } else {

      \ \ \ load(file="meta.mcmc.Rda")

      \ \ \ load(file="cotes.mcmc.Rda")

      }
    <|unfolded-prog-io>
      if(!file.exists("meta.mcmc.Rda")) {

      + \ \ \ Rprof("meta.MCMCglmm.prof")

      + \ \ \ meta.mcmc \<less\>- MCMCglmm(fixed=YLD ~ 0 + Entry, random = ~
      Loca + Loca:Entr

      \<less\>fixed=YLD ~ 0 + Entry, random = ~ Loca + Loca:Entry +
      Loca:Repe, data=rcbd.d

      \<less\>dom = ~ Loca + Loca:Entry + Loca:Repe,
      data=rcbd.dat,verbose=FALSE)

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ YLD ~
      Entry + (1 \| Loca/Repe) + (1 \| Loca:Ent

      \<less\> \ \ \ \ YLD ~ Entry + (1 \| Loca/Repe) + (1 \| Loca:Entry)

      + \ \ \ Rprof(NULL)

      + \ \ \ Rprof("meta.cotes.MCMCglmm.prof")

      + \ \ \ cotes.mcmc \<less\>- MCMCglmm(fixed=YLD ~ 0 + Entry, random = ~
      Loca + idh(Entr

      \<less\>(fixed=YLD ~ 0 + Entry, random = ~ Loca + idh(Entry):Loca +
      \ Loca:Repe,rcov=

      \<less\>ndom = ~ Loca + idh(Entry):Loca +
      \ Loca:Repe,rcov=~idh(Loca):units,data=rcbd

      \<less\>:Loca + \ Loca:Repe,rcov=~idh(Loca):units,data=rcbd.dat,verbose=FALSE)

      + \ \ \ Rprof(NULL)

      + \ \ \ save(meta.mcmc,file="meta.mcmc.Rda")

      + \ \ \ save(cotes.mcmc,file="cotes.mcmc.Rda")

      + \ \ \ 

      + } else {

      + \ \ \ load(file="meta.mcmc.Rda")

      + \ \ \ load(file="cotes.mcmc.Rda")

      + }

      Error: could not find function "MCMCglmm"
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      summary(meta.mcmc)

      meta.MCMCglmm.summary \<less\>- summaryRprof("meta.MCMCglmm.prof")

      head(meta.MCMCglmm.summary[[1]])

      head(meta.MCMCglmm.summary[[2]])
    <|unfolded-prog-io>
      summary(meta.mcmc)

      Error in summary(meta.mcmc) : object 'meta.mcmc' not found

      \<gtr\> meta.MCMCglmm.summary \<less\>-
      summaryRprof("meta.MCMCglmm.prof")

      Error in summaryRprof("meta.MCMCglmm.prof") :\ 

      \ \ no lines found in 'meta.MCMCglmm.prof'

      \<gtr\> head(meta.MCMCglmm.summary[[1]])

      Error in head(meta.MCMCglmm.summary[[1]]) :\ 

      \ \ object 'meta.MCMCglmm.summary' not found

      \<gtr\> head(meta.MCMCglmm.summary[[2]])

      Error in head(meta.MCMCglmm.summary[[2]]) :\ 

      \ \ object 'meta.MCMCglmm.summary' not found
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      summary(cotes.mcmc)

      meta.cotes.MCMCglmm.summary \<less\>-
      summaryRprof("meta.cotes.MCMCglmm.prof")

      head(meta.cotes.MCMCglmm.summary[[1]])

      head(meta.cotes.MCMCglmm.summary[[2]])
    <|unfolded-prog-io>
      summary(cotes.mcmc)

      Error in summary(cotes.mcmc) : object 'cotes.mcmc' not found

      \<gtr\> meta.cotes.MCMCglmm.summary \<less\>-
      summaryRprof("meta.cotes.MCMCglmm.prof")

      Error in file(filename, "rt") : cannot open the connection

      In addition: Warning message:

      In file(filename, "rt") :

      \ \ cannot open file 'meta.cotes.MCMCglmm.prof': No such file or
      directory

      \<gtr\> head(meta.cotes.MCMCglmm.summary[[1]])

      Error in head(meta.cotes.MCMCglmm.summary[[1]]) :\ 

      \ \ object 'meta.cotes.MCMCglmm.summary' not found

      \<gtr\> head(meta.cotes.MCMCglmm.summary[[2]])

      Error in head(meta.cotes.MCMCglmm.summary[[2]]) :\ 

      \ \ object 'meta.cotes.MCMCglmm.summary' not found
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      #detach("package:MCMCglmm")
    <|unfolded-prog-io>
      #detach("package:MCMCglmm")
    </unfolded-prog-io|>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    \;

    <\textput>
      <section|INLA>
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(INLA)
    <|unfolded-prog-io>
      library(INLA)

      Loading required package: sp

      Loading required package: splines

      This is INLA 0.0-1468872408, dated 2016-07-18 (14:43:05+0100).

      See www.r-inla.org/contact-us for how to get help.
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("meta.inla.Rda")) {

      \ \ Rprof("meta.inla.prof")

      \ \ meta.inla \<less\>- inla(YLD ~ 0 + Entry + f(Loca, model="iid") +
      f(Loca:Repe, model="iid") + f(Loca:Entry, model="iid"), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(meta.inla,file="meta.inla.Rda")

      } else {

      \ \ load(file="meta.inla.Rda")

      }

      summary(meta.inla)

      meta.inla.summary \<less\>- summaryRprof("meta.inla.prof")

      head(meta.inla.summary[[1]])

      head(meta.inla.summary[[2]])\ 
    <|unfolded-prog-io>
      if(!file.exists("meta.inla.Rda")) {

      + \ \ Rprof("meta.inla.prof")

      + \ \ meta.inla \<less\>- inla(YLD ~ 0 + Entry + f(Loca, model="iid") +
      f(Loca:Repe, m

      \<less\> 0 + Entry + f(Loca, model="iid") + f(Loca:Repe, model="iid") +
      f(Loca:Entry

      \<less\>="iid") + f(Loca:Repe, model="iid") + f(Loca:Entry,
      model="iid"), data=rcbd.

      \<less\>el="iid") + f(Loca:Entry, model="iid"), data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(meta.inla,file="meta.inla.Rda")

      + } else {

      + \ \ load(file="meta.inla.Rda")

      + }

      \<gtr\> summary(meta.inla)

      \;

      Call:

      c("inla(formula = YLD ~ 0 + Entry + f(Loca, model = \\"iid\\") +
      f(Loca:Repe, ", \ " \ \ \ model = \\"iid\\") + f(Loca:Entry, model =
      \\"iid\\"), data = rcbd.dat)" )

      \;

      Time used:

      \ Pre-processing \ \ \ Running inla Post-processing
      \ \ \ \ \ \ \ \ \ \ Total\ 

      \ \ \ \ \ \ \ \ \ 3.0042 \ \ \ \ \ \ \ \ \ 4.4318
      \ \ \ \ \ \ \ \ \ 0.1661 \ \ \ \ \ \ \ \ \ 7.6021\ 

      \;

      Fixed effects:

      \ \ \ \ \ \ \ \ \ \ mean \ \ \ \ sd 0.025quant 0.5quant 0.975quant
      \ \ mode kld

      Entry1 \ 5.7289 0.8322 \ \ \ \ 4.0521 \ \ 5.7369 \ \ \ \ 7.3572 5.7501
      \ \ 0

      Entry2 \ 5.9167 0.8322 \ \ \ \ 4.2399 \ \ 5.9247 \ \ \ \ 7.5450 5.9379
      \ \ 0

      Entry3 \ 6.5786 0.8322 \ \ \ \ 4.9018 \ \ 6.5866 \ \ \ \ 8.2069 6.5998
      \ \ 0

      Entry4 \ 6.3503 0.8322 \ \ \ \ 4.6735 \ \ 6.3583 \ \ \ \ 7.9786 6.3715
      \ \ 0

      Entry5 \ 6.3747 0.8322 \ \ \ \ 4.6980 \ \ 6.3827 \ \ \ \ 8.0030 6.3959
      \ \ 0

      Entry6 \ 6.3450 0.8322 \ \ \ \ 4.6682 \ \ 6.3530 \ \ \ \ 7.9733 6.3662
      \ \ 0

      Entry7 \ 5.6564 0.8322 \ \ \ \ 3.9796 \ \ 5.6644 \ \ \ \ 7.2847 5.6776
      \ \ 0

      Entry8 \ 6.5003 0.8322 \ \ \ \ 4.8235 \ \ 6.5082 \ \ \ \ 8.1286 6.5215
      \ \ 0

      Entry9 \ 5.4897 0.8322 \ \ \ \ 3.8130 \ \ 5.4977 \ \ \ \ 7.1181 5.5110
      \ \ 0

      Entry10 6.2067 0.8322 \ \ \ \ 4.5299 \ \ 6.2146 \ \ \ \ 7.8350 6.2279
      \ \ 0

      Entry11 6.7608 0.8322 \ \ \ \ 5.0840 \ \ 6.7688 \ \ \ \ 8.3891 6.7820
      \ \ 0

      Entry12 5.9031 0.8322 \ \ \ \ 4.2263 \ \ 5.9110 \ \ \ \ 7.5314 5.9243
      \ \ 0

      Entry13 6.0492 0.8322 \ \ \ \ 4.3724 \ \ 6.0572 \ \ \ \ 7.6775 6.0704
      \ \ 0

      Entry14 3.4532 0.8322 \ \ \ \ 1.7764 \ \ 3.4611 \ \ \ \ 5.0815 3.4744
      \ \ 0

      Entry15 5.9208 0.8322 \ \ \ \ 4.2441 \ \ 5.9288 \ \ \ \ 7.5491 5.9421
      \ \ 0

      Entry16 4.8217 0.8322 \ \ \ \ 3.1450 \ \ 4.8297 \ \ \ \ 6.4500 4.8429
      \ \ 0

      Entry17 6.4736 0.8322 \ \ \ \ 4.7968 \ \ 6.4816 \ \ \ \ 8.1019 6.4948
      \ \ 0

      Entry18 6.3808 0.8322 \ \ \ \ 4.7041 \ \ 6.3888 \ \ \ \ 8.0091 6.4020
      \ \ 0

      Entry19 3.1818 0.8322 \ \ \ \ 1.5050 \ \ 3.1898 \ \ \ \ 4.8101 3.2030
      \ \ 0

      Entry20 5.7758 0.8322 \ \ \ \ 4.0991 \ \ 5.7838 \ \ \ \ 7.4042 5.7971
      \ \ 0

      Entry21 4.7420 0.8322 \ \ \ \ 3.0652 \ \ 4.7500 \ \ \ \ 6.3703 4.7632
      \ \ 0

      Entry22 6.4989 0.8322 \ \ \ \ 4.8221 \ \ 6.5069 \ \ \ \ 8.1272 6.5201
      \ \ 0

      Entry23 3.6379 0.8322 \ \ \ \ 1.9611 \ \ 3.6459 \ \ \ \ 5.2662 3.6591
      \ \ 0

      Entry24 5.7603 0.8322 \ \ \ \ 4.0835 \ \ 5.7683 \ \ \ \ 7.3886 5.7815
      \ \ 0

      Entry25 4.7295 0.8322 \ \ \ \ 3.0527 \ \ 4.7375 \ \ \ \ 6.3578 4.7507
      \ \ 0

      Entry26 6.7330 0.8322 \ \ \ \ 5.0563 \ \ 6.7410 \ \ \ \ 8.3613 6.7543
      \ \ 0

      Entry27 6.6211 0.8322 \ \ \ \ 4.9443 \ \ 6.6291 \ \ \ \ 8.2494 6.6423
      \ \ 0

      Entry28 6.2283 0.8322 \ \ \ \ 4.5516 \ \ 6.2363 \ \ \ \ 7.8566 6.2496
      \ \ 0

      Entry29 5.6803 0.8322 \ \ \ \ 4.0035 \ \ 5.6883 \ \ \ \ 7.3086 5.7015
      \ \ 0

      Entry30 5.1823 0.8322 \ \ \ \ 3.5055 \ \ 5.1902 \ \ \ \ 6.8106 5.2035
      \ \ 0

      Entry31 6.0797 0.8322 \ \ \ \ 4.4030 \ \ 6.0877 \ \ \ \ 7.7080 6.1009
      \ \ 0

      Entry32 5.5414 0.8322 \ \ \ \ 3.8647 \ \ 5.5494 \ \ \ \ 7.1697 5.5626
      \ \ 0

      \;

      Random effects:

      Name \ \ \ \ \ Model

      \ Loca \ \ IID model\ 

      Loca:Repe \ \ IID model\ 

      Loca:Entry \ \ IID model\ 

      \;

      Model hyperparameters:

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mean
      \ \ \ \ \ \ \ sd 0.025quant

      Precision for the Gaussian observations 6.968e-01 2.960e-02
      \ \ \ \ 0.6401

      Precision for Loca \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.378e-01
      5.460e-02 \ \ \ \ 0.0569

      Precision for Loca:Repe \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.660e+04
      1.747e+04 \ \ 876.8812

      Precision for Loca:Entry \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.901e+04
      1.859e+04 \ 1273.4929

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.5quant
      0.975quant \ \ \ \ \ mode

      Precision for the Gaussian observations 6.963e-01 \ 7.564e-01
      \ \ \ 0.6954

      Precision for Loca \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.296e-01
      \ 2.671e-01 \ \ \ 0.1134

      Precision for Loca:Repe \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.126e+04
      \ 6.298e+04 2216.1623

      Precision for Loca:Entry \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.356e+04
      \ 6.793e+04 3462.3238

      \;

      Expected number of effective parameters(std dev): 43.06(0.1225)

      Number of equivalent replicates : 26.75\ 

      \;

      Marginal log-Likelihood: \ -2049.89\ 

      \<gtr\> meta.inla.summary \<less\>- summaryRprof("meta.inla.prof")

      \<gtr\> head(meta.inla.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time total.pct

      "gsub" \ \ \ \ \ \ \ \ \ \ \ \ 0.10 \ \ \ 12.82 \ \ \ \ \ \ 0.12
      \ \ \ \ 15.38

      "file" \ \ \ \ \ \ \ \ \ \ \ \ 0.10 \ \ \ 12.82 \ \ \ \ \ \ 0.10
      \ \ \ \ 12.82

      "inla.models" \ \ \ \ \ 0.08 \ \ \ 10.26 \ \ \ \ \ \ 0.14 \ \ \ \ 17.95

      "file.exists" \ \ \ \ \ 0.06 \ \ \ \ 7.69 \ \ \ \ \ \ 0.06
      \ \ \ \ \ 7.69

      "system" \ \ \ \ \ \ \ \ \ \ 0.06 \ \ \ \ 7.69 \ \ \ \ \ \ 0.06
      \ \ \ \ \ 7.69

      "getwd" \ \ \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 5.13 \ \ \ \ \ \ 0.04
      \ \ \ \ \ 5.13

      \<gtr\> head(meta.inla.summary[[2]])\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct
      self.time self.pct

      "inla" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.78 \ \ \ 100.00
      \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "eval" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.20 \ \ \ \ 25.64
      \ \ \ \ \ 0.02 \ \ \ \ 2.56

      "doTryCatch" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.16 \ \ \ \ 20.51
      \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "inla.model.properties" \ \ \ \ \ \ 0.16 \ \ \ \ 20.51 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "try" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.16
      \ \ \ \ 20.51 \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "tryCatch" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.16 \ \ \ \ 20.51
      \ \ \ \ \ 0.00 \ \ \ \ 0.00
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      #detach("package:INLA")
    <|unfolded-prog-io>
      #detach("package:INLA")
    </unfolded-prog-io|>

    <\textput>
      <section|brms>

      \;
    </textput>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      library(brms)

      if(!file.exists("meta.brms.Rda")) {

      \ \ Rprof("meta.brms.prof")

      \ \ meta.brms \<less\>- brm(YLD ~ 0 + Entry + (1 \| Loca/Repe) + (1 \|
      Loca:Entry), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(meta.brms,file="meta.brms.Rda")

      } else {

      \ \ load(file="meta.brms.Rda")

      }

      summary(meta.brms)

      \;

      meta.brms.summary \<less\>- summaryRprof("meta.brms.prof")

      head(meta.brms.summary[[1]])

      head(meta.brms.summary[[2]])\ 
    <|unfolded-prog-io>
      library(brms)

      Loading required package: rstan

      Loading required package: ggplot2

      Loading required package: StanHeaders

      rstan (Version 2.12.1, packaged: 2016-09-11 13:07:50 UTC, GitRev:
      85f7a56811da)

      For execution on a local, multicore CPU with excess RAM we recommend
      calling

      rstan_options(auto_write = TRUE)

      options(mc.cores = parallel::detectCores())

      Loading 'brms' package (version 0.10.0). Useful instructions\ 

      can be found by typing help('brms'). A more detailed introduction\ 

      to the package is available through vignette('brms').

      \;

      Attaching package: 'brms'

      \;

      The following objects are masked from 'package:glmmLasso':

      \;

      \ \ \ \ acat, cumulative

      \;

      The following object is masked from 'package:glmmADMB':

      \;

      \ \ \ \ VarCorr

      \;

      \<gtr\> if(!file.exists("meta.brms.Rda")) {

      + \ \ Rprof("meta.brms.prof")

      + \ \ meta.brms \<less\>- brm(YLD ~ 0 + Entry + (1 \| Loca/Repe) + (1
      \| Loca:Entry), da

      \<less\>0 + Entry + (1 \| Loca/Repe) + (1 \| Loca:Entry),
      data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(meta.brms,file="meta.brms.Rda")

      + } else {

      + \ \ load(file="meta.brms.Rda")

      + }

      Compiling the C++ model

      In file included from filed6ae5da45e65.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:42:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints.hpp:14:17:
      warning: unused function 'set_zero_all_adjoints' [-Wunused-function]

      \ \ \ \ static void set_zero_all_adjoints() {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae5da45e65.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:43:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints_nested.hpp:17:17:
      warning: 'static' function 'set_zero_all_adjoints_nested' declared in
      header file should be declared 'static inline'
      [-Wunneeded-internal-declaration]

      \ \ \ \ static void set_zero_all_adjoints_nested() {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae5da45e65.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:54:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/autocorrelation.hpp:17:14:
      warning: function 'fft_next_good_size' is not needed and will not be
      emitted [-Wunneeded-internal-declaration]

      \ \ \ \ \ \ size_t fft_next_good_size(size_t N) {

      \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae5da45e65.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:235:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr.hpp:36:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr/functor/integrate_ode_rk45.hpp:13:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint.hpp:61:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint/util/multi_array_adaption.hpp:29:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array.hpp:21:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/base.hpp:28:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:42:43:
      warning: unused typedef 'index_range' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index_range index_range;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:43:37:
      warning: unused typedef 'index' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index index;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:53:43:
      warning: unused typedef 'index_range' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index_range index_range;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:54:37:
      warning: unused typedef 'index' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index index;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      7 warnings generated.

      \;

      SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 1).

      \;

      Chain 1, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

      Chain 1, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

      Chain 1, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

      Chain 1, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

      Chain 1, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

      Chain 1, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

      Chain 1, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

      Chain 1, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

      Chain 1, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

      Chain 1, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

      Chain 1, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

      Chain 1, Iteration: 2000 / 2000 [100%] \ (Sampling)

      \ Elapsed Time: 47.5195 seconds (Warm-up)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 46.5375 seconds (Sampling)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 94.0571 seconds (Total)

      \;

      \;

      SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 2).

      \;

      Chain 2, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

      Chain 2, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

      Chain 2, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

      Chain 2, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

      Chain 2, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

      Chain 2, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

      Chain 2, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

      Chain 2, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

      Chain 2, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

      Chain 2, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

      Chain 2, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

      Chain 2, Iteration: 2000 / 2000 [100%] \ (Sampling)

      \ Elapsed Time: 53.1433 seconds (Warm-up)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 56.7158 seconds (Sampling)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 109.859 seconds (Total)

      \;

      \;

      SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 3).

      \;

      Chain 3, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

      Chain 3, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

      Chain 3, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

      Chain 3, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

      Chain 3, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

      Chain 3, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

      Chain 3, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

      Chain 3, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

      Chain 3, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

      Chain 3, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

      Chain 3, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

      Chain 3, Iteration: 2000 / 2000 [100%] \ (Sampling)

      \ Elapsed Time: 44.8726 seconds (Warm-up)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 47.5954 seconds (Sampling)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 92.468 seconds (Total)

      \;

      \;

      SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 4).

      \;

      Chain 4, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

      Chain 4, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

      Chain 4, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

      Chain 4, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

      Chain 4, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

      Chain 4, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

      Chain 4, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

      Chain 4, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

      Chain 4, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

      Chain 4, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

      Chain 4, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

      Chain 4, Iteration: 2000 / 2000 [100%] \ (Sampling)

      \ Elapsed Time: 46.3648 seconds (Warm-up)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 47.4589 seconds (Sampling)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 93.8237 seconds (Total)

      \;

      \<gtr\> summary(meta.brms)

      \ Family: gaussian (identity)\ 

      Formula: YLD ~ 0 + Entry + (1 \| Loca/Repe) + (1 \| Loca:Entry)\ 

      \ \ \ Data: rcbd.dat (Number of observations: 1152)\ 

      Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;\ 

      \ \ \ \ \ \ \ \ \ total post-warmup samples = 4000

      \ \ \ WAIC: Not computed

      \ 

      Group-Level Effects:\ 

      ~Loca (Number of levels: 12)\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Est.Error l-95% CI u-95% CI
      Eff.Sample Rhat

      sd(Intercept) \ \ \ \ \ 3.3 \ \ \ \ \ 0.83 \ \ \ \ 2.13 \ \ \ \ \ 5.3
      \ \ \ \ \ \ 1031 1.01

      \;

      ~Loca:Entry (Number of levels: 384)\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Est.Error l-95% CI u-95% CI
      Eff.Sample Rhat

      sd(Intercept) \ \ \ \ 0.66 \ \ \ \ \ 0.05 \ \ \ \ 0.57 \ \ \ \ 0.75
      \ \ \ \ \ \ 1235 \ \ \ 1

      \;

      ~Loca:Repe (Number of levels: 36)\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Est.Error l-95% CI u-95% CI
      Eff.Sample Rhat

      sd(Intercept) \ \ \ \ \ 0.4 \ \ \ \ \ 0.07 \ \ \ \ 0.27 \ \ \ \ 0.57
      \ \ \ \ \ \ 1544 \ \ \ 1

      \;

      Population-Level Effects:\ 

      \ \ \ \ \ \ \ \ Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat

      Entry1 \ \ \ \ \ 5.93 \ \ \ \ \ 1.04 \ \ \ \ 3.92 \ \ \ \ 7.99
      \ \ \ \ \ \ \ 119 1.02

      Entry2 \ \ \ \ \ 6.13 \ \ \ \ \ 1.04 \ \ \ \ 4.13 \ \ \ \ 8.26
      \ \ \ \ \ \ \ 117 1.02

      Entry3 \ \ \ \ \ 6.78 \ \ \ \ \ 1.03 \ \ \ \ 4.81 \ \ \ \ 8.86
      \ \ \ \ \ \ \ 121 1.02

      Entry4 \ \ \ \ \ 6.56 \ \ \ \ \ 1.04 \ \ \ \ 4.56 \ \ \ \ 8.64
      \ \ \ \ \ \ \ 117 1.02

      Entry5 \ \ \ \ \ 6.57 \ \ \ \ \ 1.03 \ \ \ \ 4.59 \ \ \ \ 8.68
      \ \ \ \ \ \ \ 119 1.02

      Entry6 \ \ \ \ \ 6.54 \ \ \ \ \ 1.03 \ \ \ \ 4.51 \ \ \ \ 8.64
      \ \ \ \ \ \ \ 116 1.02

      Entry7 \ \ \ \ \ 5.86 \ \ \ \ \ 1.04 \ \ \ \ 3.89 \ \ \ \ 8.01
      \ \ \ \ \ \ \ 117 1.02

      Entry8 \ \ \ \ \ 6.70 \ \ \ \ \ 1.04 \ \ \ \ 4.71 \ \ \ \ 8.76
      \ \ \ \ \ \ \ 121 1.02

      Entry9 \ \ \ \ \ 5.70 \ \ \ \ \ 1.04 \ \ \ \ 3.68 \ \ \ \ 7.75
      \ \ \ \ \ \ \ 117 1.02

      Entry10 \ \ \ \ 6.41 \ \ \ \ \ 1.04 \ \ \ \ 4.42 \ \ \ \ 8.48
      \ \ \ \ \ \ \ 119 1.02

      Entry11 \ \ \ \ 6.96 \ \ \ \ \ 1.03 \ \ \ \ 4.96 \ \ \ \ 9.03
      \ \ \ \ \ \ \ 118 1.02

      Entry12 \ \ \ \ 6.11 \ \ \ \ \ 1.04 \ \ \ \ 4.09 \ \ \ \ 8.19
      \ \ \ \ \ \ \ 118 1.02

      Entry13 \ \ \ \ 6.26 \ \ \ \ \ 1.04 \ \ \ \ 4.31 \ \ \ \ 8.33
      \ \ \ \ \ \ \ 117 1.02

      Entry14 \ \ \ \ 3.66 \ \ \ \ \ 1.04 \ \ \ \ 1.67 \ \ \ \ 5.76
      \ \ \ \ \ \ \ 120 1.02

      Entry15 \ \ \ \ 6.13 \ \ \ \ \ 1.03 \ \ \ \ 4.12 \ \ \ \ 8.20
      \ \ \ \ \ \ \ 119 1.02

      Entry16 \ \ \ \ 5.03 \ \ \ \ \ 1.04 \ \ \ \ 2.98 \ \ \ \ 7.10
      \ \ \ \ \ \ \ 118 1.02

      Entry17 \ \ \ \ 6.67 \ \ \ \ \ 1.05 \ \ \ \ 4.66 \ \ \ \ 8.77
      \ \ \ \ \ \ \ 118 1.02

      Entry18 \ \ \ \ 6.59 \ \ \ \ \ 1.04 \ \ \ \ 4.57 \ \ \ \ 8.67
      \ \ \ \ \ \ \ 117 1.02

      Entry19 \ \ \ \ 3.39 \ \ \ \ \ 1.05 \ \ \ \ 1.37 \ \ \ \ 5.44
      \ \ \ \ \ \ \ 115 1.02

      Entry20 \ \ \ \ 5.98 \ \ \ \ \ 1.04 \ \ \ \ 3.99 \ \ \ \ 8.04
      \ \ \ \ \ \ \ 117 1.02

      Entry21 \ \ \ \ 4.94 \ \ \ \ \ 1.04 \ \ \ \ 2.94 \ \ \ \ 7.03
      \ \ \ \ \ \ \ 115 1.02

      Entry22 \ \ \ \ 6.70 \ \ \ \ \ 1.04 \ \ \ \ 4.70 \ \ \ \ 8.76
      \ \ \ \ \ \ \ 120 1.02

      Entry23 \ \ \ \ 3.85 \ \ \ \ \ 1.03 \ \ \ \ 1.87 \ \ \ \ 5.92
      \ \ \ \ \ \ \ 120 1.02

      Entry24 \ \ \ \ 5.97 \ \ \ \ \ 1.04 \ \ \ \ 3.96 \ \ \ \ 8.01
      \ \ \ \ \ \ \ 120 1.02

      Entry25 \ \ \ \ 4.94 \ \ \ \ \ 1.04 \ \ \ \ 2.96 \ \ \ \ 7.01
      \ \ \ \ \ \ \ 117 1.02

      Entry26 \ \ \ \ 6.94 \ \ \ \ \ 1.04 \ \ \ \ 4.94 \ \ \ \ 8.98
      \ \ \ \ \ \ \ 118 1.02

      Entry27 \ \ \ \ 6.83 \ \ \ \ \ 1.04 \ \ \ \ 4.84 \ \ \ \ 8.93
      \ \ \ \ \ \ \ 119 1.02

      Entry28 \ \ \ \ 6.44 \ \ \ \ \ 1.04 \ \ \ \ 4.47 \ \ \ \ 8.51
      \ \ \ \ \ \ \ 116 1.02

      Entry29 \ \ \ \ 5.89 \ \ \ \ \ 1.04 \ \ \ \ 3.92 \ \ \ \ 7.95
      \ \ \ \ \ \ \ 117 1.02

      Entry30 \ \ \ \ 5.39 \ \ \ \ \ 1.04 \ \ \ \ 3.44 \ \ \ \ 7.52
      \ \ \ \ \ \ \ 117 1.02

      Entry31 \ \ \ \ 6.29 \ \ \ \ \ 1.04 \ \ \ \ 4.28 \ \ \ \ 8.33
      \ \ \ \ \ \ \ 115 1.02

      Entry32 \ \ \ \ 5.75 \ \ \ \ \ 1.04 \ \ \ \ 3.74 \ \ \ \ 7.85
      \ \ \ \ \ \ \ 116 1.02

      \;

      Family Specific Parameters:\ 

      \ \ \ \ \ \ Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat

      sigma \ \ \ \ 0.97 \ \ \ \ \ 0.03 \ \ \ \ 0.93 \ \ \ \ 1.02
      \ \ \ \ \ \ 4000 \ \ \ 1

      \;

      Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample\ 

      is a crude measure of effective sample size, and Rhat is the potential\ 

      scale reduction factor on split chains (at convergence, Rhat =
      1).\<gtr\>\ 

      \<gtr\> meta.brms.summary \<less\>- summaryRprof("meta.brms.prof")

      \<gtr\> head(meta.brms.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time
      total.pct

      ".External" \ \ \ \ \ \ \ \ \ 385.92 \ \ \ 99.74 \ \ \ \ 385.92
      \ \ \ \ 99.74

      "is.na" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.26 \ \ \ \ 0.07
      \ \ \ \ \ \ 0.26 \ \ \ \ \ 0.07

      "saveRDS" \ \ \ \ \ \ \ \ \ \ \ \ \ 0.24 \ \ \ \ 0.06 \ \ \ \ \ \ 0.24
      \ \ \ \ \ 0.06

      ".Call" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.08 \ \ \ \ 0.02
      \ \ \ \ \ \ 0.12 \ \ \ \ \ 0.03

      "lazyLoadDBfetch" \ \ \ \ \ 0.06 \ \ \ \ 0.02 \ \ \ \ \ \ 0.06
      \ \ \ \ \ 0.02

      "grepl" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 0.01
      \ \ \ \ \ \ 0.04 \ \ \ \ \ 0.01

      \<gtr\> head(meta.brms.summary[[2]])\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time
      self.pct

      "brm" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 386.94 \ \ \ 100.00
      \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "\<Anonymous\>" \ \ \ \ \ \ \ \ 386.42 \ \ \ \ 99.87 \ \ \ \ \ 0.02
      \ \ \ \ 0.01

      "do.call" \ \ \ \ \ \ \ \ \ \ \ \ 386.42 \ \ \ \ 99.87 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      ".local" \ \ \ \ \ \ \ \ \ \ \ \ \ 386.32 \ \ \ \ 99.84 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "standardGeneric" \ \ \ \ 386.32 \ \ \ \ 99.84 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "doTryCatch" \ \ \ \ \ \ \ \ \ 385.96 \ \ \ \ 99.75 \ \ \ \ \ 0.00
      \ \ \ \ 0.00
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      cotes.brms \<less\>- brm(YLD ~ Entry + (1 \| Loca/Repe) + (Entry \|
      Loca), data=rcbd.dat)
    <|unfolded-prog-io>
      cotes.brms \<less\>- brm(YLD ~ Entry + (1 \| Loca/Repe) + (Entry \|
      Loca), data=rcbd

      \<less\>ntry + (1 \| Loca/Repe) + (Entry \| Loca), data=rcbd.dat)

      Error: Duplicated random effects detected for group Loca
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      cotes.brms \<less\>- brm(YLD ~ Entry + (1 \| Loca/Repe) + (0 + Entry \|
      Loca), data=rcbd.dat)
    <|unfolded-prog-io>
      cotes.brms \<less\>- brm(YLD ~ Entry + (1 \| Loca/Repe) + (0 + Entry \|
      Loca), data=

      \<less\>ntry + (1 \| Loca/Repe) + (0 + Entry \| Loca), data=rcbd.dat)

      Compiling the C++ model

      In file included from filed6ae4e523402.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:42:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints.hpp:14:17:
      warning: unused function 'set_zero_all_adjoints' [-Wunused-function]

      \ \ \ \ static void set_zero_all_adjoints() {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae4e523402.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:43:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints_nested.hpp:17:17:
      warning: 'static' function 'set_zero_all_adjoints_nested' declared in
      header file should be declared 'static inline'
      [-Wunneeded-internal-declaration]

      \ \ \ \ static void set_zero_all_adjoints_nested() {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae4e523402.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:54:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/autocorrelation.hpp:17:14:
      warning: function 'fft_next_good_size' is not needed and will not be
      emitted [-Wunneeded-internal-declaration]

      \ \ \ \ \ \ size_t fft_next_good_size(size_t N) {

      \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae4e523402.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:235:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr.hpp:36:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr/functor/integrate_ode_rk45.hpp:13:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint.hpp:61:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint/util/multi_array_adaption.hpp:29:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array.hpp:21:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/base.hpp:28:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:42:43:
      warning: unused typedef 'index_range' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index_range index_range;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:43:37:
      warning: unused typedef 'index' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index index;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:53:43:
      warning: unused typedef 'index_range' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index_range index_range;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:54:37:
      warning: unused typedef 'index' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index index;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      7 warnings generated.

      \;

      SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 1).

      [1] "Rejecting initial value:" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      [2] " \ Log probability evaluates to log(0), i.e. negative infinity."
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      [3] " \ Stan can't start sampling from this initial value."
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      [4] "Error : modeld6ae696c7090_filed6ae77aab950_namespace::write_array:
      y is not positive definite."

      error occurred during calling the sampler; sampling not done
    </unfolded-prog-io|>

    <\unfolded-prog-io>
      <with|color|red|\<gtr\> >
    <|unfolded-prog-io>
      if(!file.exists("cotes.brms.Rda")) {

      \ \ Rprof("cotes.brms.prof")

      \ \ cotes.brms \<less\>- brm(YLD ~ Entry + (1 \| Loca:Repe) + (Entry \|
      Loca), data=rcbd.dat)

      \ \ Rprof(NULL)

      \ \ save(cotes.brms,file="cotes.brms.Rda")

      } else {

      \ \ load(file="cotes.brms.Rda")

      }

      summary(cotes.brms)

      cotes.brms.summary \<less\>- summaryRprof("cotes.brms.prof")

      head(cotes.brms.summary[[1]])

      head(cotes.brms.summary[[2]])
    <|unfolded-prog-io>
      if(!file.exists("cotes.brms.Rda")) {

      + \ \ Rprof("cotes.brms.prof")

      + \ \ cotes.brms \<less\>- brm(YLD ~ Entry + (1 \| Loca:Repe) + (Entry
      \| Loca), data=rc

      \<less\> Entry + (1 \| Loca:Repe) + (Entry \| Loca), data=rcbd.dat)

      + \ \ Rprof(NULL)

      + \ \ save(cotes.brms,file="cotes.brms.Rda")

      + } else {

      + \ \ load(file="cotes.brms.Rda")

      + }

      Compiling the C++ model

      In file included from filed6ae2f07ee66.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:42:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints.hpp:14:17:
      warning: unused function 'set_zero_all_adjoints' [-Wunused-function]

      \ \ \ \ static void set_zero_all_adjoints() {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae2f07ee66.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:43:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints_nested.hpp:17:17:
      warning: 'static' function 'set_zero_all_adjoints_nested' declared in
      header file should be declared 'static inline'
      [-Wunneeded-internal-declaration]

      \ \ \ \ static void set_zero_all_adjoints_nested() {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae2f07ee66.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:54:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/autocorrelation.hpp:17:14:
      warning: function 'fft_next_good_size' is not needed and will not be
      emitted [-Wunneeded-internal-declaration]

      \ \ \ \ \ \ size_t fft_next_good_size(size_t N) {

      \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      In file included from filed6ae2f07ee66.cpp:8:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:235:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr.hpp:36:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr/functor/integrate_ode_rk45.hpp:13:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint.hpp:61:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint/util/multi_array_adaption.hpp:29:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array.hpp:21:

      In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/base.hpp:28:

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:42:43:
      warning: unused typedef 'index_range' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index_range index_range;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:43:37:
      warning: unused typedef 'index' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index index;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:53:43:
      warning: unused typedef 'index_range' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index_range index_range;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:54:37:
      warning: unused typedef 'index' [-Wunused-local-typedef]

      \ \ \ \ \ \ typedef typename Array::index index;

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

      7 warnings generated.

      \;

      SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 1).

      [1] "Rejecting initial value:" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      [2] " \ Log probability evaluates to log(0), i.e. negative infinity."
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      [3] " \ Stan can't start sampling from this initial value."
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      [4] "Error : modeld6ae1142a794_filed6ae473b77fd_namespace::write_array:
      y is not positive definite."

      error occurred during calling the sampler; sampling not done

      \<gtr\> summary(cotes.brms)

      \ Family: gaussian (identity)\ 

      Formula: YLD ~ Entry + (1 \| Loca:Repe) + (Entry \| Loca)\ 

      \ \ \ Data: rcbd.dat (Number of observations: 1152)\ 

      \;

      The model does not contain posterior samples.\<gtr\> cotes.brms.summary
      \<less\>- summaryRprof("cotes.brms.prof")

      \<gtr\> head(cotes.brms.summary[[1]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ self.time self.pct total.time total.pct

      "saveRDS" \ \ \ \ \ \ \ \ \ 0.30 \ \ \ 34.88 \ \ \ \ \ \ 0.30
      \ \ \ \ 34.88

      ".Call" \ \ \ \ \ \ \ \ \ \ \ 0.18 \ \ \ 20.93 \ \ \ \ \ \ 0.22
      \ \ \ \ 25.58

      "grepl" \ \ \ \ \ \ \ \ \ \ \ 0.04 \ \ \ \ 4.65 \ \ \ \ \ \ 0.06
      \ \ \ \ \ 6.98

      "$" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.02 \ \ \ \ 2.33 \ \ \ \ \ \ 0.10
      \ \ \ \ 11.63

      "doTryCatch" \ \ \ \ \ \ 0.02 \ \ \ \ 2.33 \ \ \ \ \ \ 0.08
      \ \ \ \ \ 9.30

      "getClassDef" \ \ \ \ \ 0.02 \ \ \ \ 2.33 \ \ \ \ \ \ 0.04
      \ \ \ \ \ 4.65

      \<gtr\> head(cotes.brms.summary[[2]])

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ total.time total.pct self.time
      self.pct

      "brm" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.86 \ \ \ 100.00
      \ \ \ \ \ 0.00 \ \ \ \ 0.00

      "rstan::stan_model" \ \ \ \ \ \ 0.34 \ \ \ \ 39.53 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "saveRDS" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.30 \ \ \ \ 34.88
      \ \ \ \ \ 0.30 \ \ \ 34.88

      ".Call" \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.22 \ \ \ \ 25.58
      \ \ \ \ \ 0.18 \ \ \ 20.93

      "make_stancode" \ \ \ \ \ \ \ \ \ \ 0.22 \ \ \ \ 25.58 \ \ \ \ \ 0.00
      \ \ \ \ 0.00

      "\<Anonymous\>" \ \ \ \ \ \ \ \ \ \ \ \ 0.20 \ \ \ \ 23.26
      \ \ \ \ \ 0.00 \ \ \ \ 0.00
    </unfolded-prog-io|>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>
  </program>

  \;
</body>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|8|?>>
    <associate|auto-11|<tuple|9|?>>
    <associate|auto-12|<tuple|10|?>>
    <associate|auto-13|<tuple|11|?>>
    <associate|auto-2|<tuple|1.1|?>>
    <associate|auto-3|<tuple|1.2|?>>
    <associate|auto-4|<tuple|2|?>>
    <associate|auto-5|<tuple|3|?>>
    <associate|auto-6|<tuple|4|?>>
    <associate|auto-7|<tuple|5|?>>
    <associate|auto-8|<tuple|6|?>>
    <associate|auto-9|<tuple|7|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Profiling>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <with|par-left|<quote|1tab>|1.1<space|2spc>Sample RCBD Data
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>

      <with|par-left|<quote|1tab>|1.2<space|2spc>lm
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>lme>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>glmmPQL>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>lmer>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>blmer>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>glmmADMB>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|7<space|2spc>glmmLasso>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|8<space|2spc>minque>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|9<space|2spc>MCMCglmm>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|10<space|2spc>INLA>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|11<space|2spc>brms>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>