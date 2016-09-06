<TeXmacs|1.99.4>

<style|generic>

<\body>
  <doc-data|<doc-title|Making Sense of the Mixed Model Analyses Available in
  R>|<doc-author|<author-data|<author-name|Peter Claussen>>>>

  <abstract-data|<\abstract>
    The R programming language and software environment is becoming
    increasingly popular among statisticians and researchers, and this has
    driven a proliferation of functions available to fit linear mixed models.
    This provides a great deal of flexibility in choosing a mixed model
    solution appropriate for data set, but this comes at the expense of
    simplicity and ease of use for experimentalists.\ 

    Many package authors, particularly those of the well established packages
    <verbatim|nlme> and <verbatim|lme4>, support a standard model syntax and
    common set of generic functions for extracting results. This allows code
    based on previous analyses to be easily updated to take advantage of
    different algorithms. Other package authors choose idiosyncratic syntax
    for specifying fixed and random effects and produce model objects that
    are not interoperable with other widely used packages.\ 

    Standard mixed model analysis the <verbatim|nlme> and <verbatim|lme4>
    libraries is illustrated using data sets representing common agricultural
    experiments. These analyses are contrasted with analyses from a selection
    of newer packages using different parameter estimation algorithms. The
    ease by which results from different packages can be incorporated into
    reusable code is demonstrated by plotting mean estimates with error bars
    and compact letter displays using custom code integrating multiple R
    functions.
  </abstract>>

  \;

  <section|Introduction>

  Workflow for a typical user (SAS)

  Workflow in R, using lm.

  <\algorithm>
    model \<less\>- lm()
  </algorithm>

  <tabbed|<tformat|<cwith|1|-1|2|2|cell-hpart|.2>|<table|<row|<cell|>|<cell|1<space|1em>>|<cell|>|<cell|>|<cell|model
  \<less\>- lm>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|2>|<cell|>|<cell|>|<cell|plot(model) (so an
  Jannink 2009 recommend examining mixed models for
  outliers)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|3>|<cell|>|<cell|>|<cell|anova(var4.lm)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|4>|<cell|>|<cell|>|<cell|summary(aov(var4.lm))>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|summary(var4.lm)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|confint(var4.lm)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|library(multcomp)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|summary(glht(var4.lme,linfct=mcp(trt="Dunnett")))>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|cld(glht(var4.lme,linfct=mcp(trt="Tukey")),decreasing=TRUE)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|library(lsmeans)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|lsmeans(var4.lm, cld ~
  trt)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|plot(lsmeans(var4.lm,cld
  ~ trt))>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|library(ggplot2)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|lm.tbl \<less\>-
  lsmeans(var4.lm,cld ~ trt)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|limits \<less\>-
  aes(ymax = lm.tbl$lsmean + lm.tbl$SE, ymin = lm.tbl$lsmean -
  lm.tbl$SE)>|<cell|>|<\cell>
    \;
  </cell>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<\cell>
    \;
  </cell>>>>>

  \;

  <\enumerate-numeric>
    <item>Fit model

    <item>Examine fit

    This may involve goodness of fit statistics, although some prefer that
    visual inspection.

    <item>Compare models

    <item>Summarize estimates

    <item>Analysis of variance

    <item>
  </enumerate-numeric>

  <big-table|<tabular|<tformat|<table|<row|<cell|Function>|<cell|Package>|<cell|Dependencies>|<cell|>>|<row|<cell|lm>|<cell|base>|<cell|>|<cell|>>|<row|<cell|lme>|<cell|nlme>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|lme4>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|blme>|<cell|>|<cell|>>|<row|<cell|lmm>|<cell|minque>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|MCMCglmm>|<cell|>|<cell|>>|<row|<cell|glmmadmb>|<cell|glmmADMB>|<cell|>|<cell|>>|<row|<cell|glmmLasso>|<cell|glmmLasso>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|MASS>|<cell|>|<cell|>>|<row|<cell|inla>|<cell|INLA>|<cell|>|<cell|>>|<row|<cell|brms>|<cell|brms>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|asreml>|<cell|>|<cell|>|<cell|>>>>>|>

  <big-table|<tabular|<tformat|<table|<row|<cell|Function>|<cell|Syntax>|<cell|Control>|<cell|>>|<row|<cell|lm>|<cell|<verbatim|obs
  ~ trt + rep>>|<cell|>|<cell|>>|<row|<cell|lme>|<cell|obs ~ trt +
  rep>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|lme4>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|blme>|<cell|>|<cell|>>|<row|<cell|lmm>|<cell|minque>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|MCMCglmm>|<cell|>|<cell|>>|<row|<cell|glmmadmb>|<cell|glmmADMB>|<cell|>|<cell|>>|<row|<cell|glmmLasso>|<cell|glmmLasso>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|MASS>|<cell|>|<cell|>>|<row|<cell|inla>|<cell|INLA>|<cell|>|<cell|>>|<row|<cell|brms>|<cell|brms>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|asreml>|<cell|>|<cell|>|<cell|>>>>>|>

  <\big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|lme>|<cell|lmer>|<cell|blmer>|<cell|lmm>|<cell|MCMC>|<cell|admb>|<cell|Lasso>|<cell|PQL>|<cell|inla>|<cell|brms>>|<row|<cell|update>|<cell|X>|<cell|X>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|ML/REML>|<cell|X>|<cell|X>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|aov>|<cell|X>|<cell|X>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|anova()>|<cell|X>|<cell|X>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|anova(,)>|<cell|X>|<cell|X>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>>>>>
    \;

    <\enumerate-numeric>
      <item>Warning if models differ in fixed effects

      <item>Recompute
    </enumerate-numeric>
  </big-table>

  \;

  <\big-table|<tabular|<tformat|<cwith|1|-1|2|2|cell-row-span|1>|<cwith|1|-1|2|2|cell-col-span|2>|<cwith|10|10|2|2|cell-row-span|1>|<cwith|10|10|2|2|cell-col-span|2>|<table|<row|<cell|Function>|<cell|<math|>Error>|<cell|>|<cell|>|<cell|Trial>|<cell|>|<cell|Treatment:Trial>|<cell|>|<cell|Trial:Rep>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lm>|<cell|19708>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lme
  - REML>|<cell|20243>|<cell|>|<cell|142>|<cell|42682>|<cell|206>|<cell|->|<cell|>|<cell|0.0001>|<cell|0.01>>|<row|<cell|lme
  -ML>|<cell|18122>|<cell|>|<cell|134>|<cell|28326>|<cell|168>|<cell|->|<cell|>|<cell|0.0001>|<cell|0.01>>|<row|<cell|lmer
  - REML>|<cell|>|<cell|>|<cell|138>|<cell|>|<cell|206>|<cell|>|<cell|42>|<cell|>|<cell|0.00>>|<row|<cell|lmer
  - ML>|<cell|>|<cell|>|<cell|134>|<cell|>|<cell|168>|<cell|>|<cell|0>|<cell|>|<cell|0>>|<row|<cell|blmer>|<cell|>|<cell|>|<cell|136>|<cell|>|<cell|177>|<cell|>|<cell|46>|<cell|>|<cell|38>>|<row|<cell|lmm
  - REML>|<cell|19708>|<cell|>|<cell|>|<cell|42798>|<cell|>|<cell|1504>|<cell|>|<cell|-0.680>|<cell|>>|<row|<cell|lmm
  - ML>|<cell|19708>|<cell|>|<cell|>|<cell|42798>|<cell|>|<cell|1504>|<cell|>|<cell|-0.680>|<cell|>>|<row|<cell|MCMCglmm>|<cell|20882>|<cell|>|<cell|>|<cell|409148>|<cell|>|<cell|109>|<cell|>|<cell|26>|<cell|>>|<row|<cell|glmmadmb>|<cell|52255>|<cell|>|<cell|>|<cell|28356>|<cell|168>|<cell|0.6992>|<cell|0.83>|<cell|0.0122>|<cell|.110>>|<row|<cell|glmmLasso>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|523>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|18122>|<cell|>|<cell|134>|<cell|28326>|<cell|168>|<cell|>|<cell|>|<cell|0.00009>|<cell|0.009>>|<row|<cell|inla>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|brms>|<cell|19739>|<cell|>|<cell|140>|<cell|75806>|<cell|251>|<cell|2408>|<cell|41>|<cell|927.55>|<cell|22.79>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|asreml>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>>>>>
    Variance components, Steel and Tori.

    1. lmm ml Even with the help example, there are negative variances and no
    difference between ML and REML.

    2. admb doesn't report a variance for residual, this is MS from anova
  </big-table>

  \;

  \;

  Repeated Measures

  <\big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|<math|\<beta\><rsub|0>>>|<cell|<math|\<beta\><rsub|1>>>|<cell|intercept>|<cell|slope>|<cell|residual>|<cell|logLik>|<cell|AIC>|<cell|BIC>>|<row|<cell|SAS>|<cell|2.8345>|<cell|0.02849>|<cell|0.008547>|<cell|0.000056>|<cell|0.000257>|<cell|948.9>|<cell|-1891.7>|<cell|-1884.5>>|<row|<cell|lme>|<cell|2.8344>|<cell|0.02858>|<cell|0.007951>|<cell|0.000053>|<cell|0.000261>|<cell|956.6>|<cell|-1901.1>|<cell|-1876.5>>|<row|<cell|lmer>|<cell|2.8344>|<cell|0.02858>|<cell|0.007951>|<cell|0.000053>|<cell|0.000261>|<cell|956.6>|<cell|-1901.1>|<cell|-1876.5>>|<row|<cell|MCMCglmm>|<cell|2.8345>|<cell|0.02853>|<cell|0.008746>|<cell|0.000058>|<cell|0.000259>|<cell|>|<cell|>|<cell|>>>>>>
    \;
  </big-table>

  \;

  \;

  Using the standard fixed-effect linear model function <verbatim|lm>, m

  \;

  Further, the results of fitting mixed models are frequently not compatible
  with other functions that extend the analysis of mixed models, i.e.
  analysis of variance or multiple treatment comparisons. Several popular R
  libraries for mixed model analysis are compared, using data from
  agricultural trials that depart from the common assumptions for the
  analysis of variance. The packages are compared for ease of
  interoperability with other R libraries.

  \;
</body>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-3|<tuple|2|?>>
    <associate|auto-4|<tuple|3|?>>
    <associate|auto-5|<tuple|4|?>>
    <associate|auto-6|<tuple|5|?>>
    <associate|footnote-1|<tuple|1|?>>
    <associate|footnr-1|<tuple|1|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal||<pageref|auto-2>>

      <tuple|normal||<pageref|auto-3>>

      <\tuple|normal>
        \;

        <\with|current-item|<quote|<macro|name|<aligned-item|<arg|name>.>>>|transform-item|<quote|<macro|x|<arg|x>>>|item-nr|<quote|0>>
          <\surround|<vspace*|0.5fn><no-indent>|<htab|0fn|first><vspace|0.5fn>>
            <\with|par-left|<quote|<tmlen|26912|53823.9|80736>>>
              <\surround|<no-page-break*>|<no-indent*>>
                <assign|item-nr|1><hidden|<tuple>><assign|last-item|1><vspace*|0.5fn><with|par-first|<quote|<tmlen|-26912|-53823.9|-80736>>|<yes-indent>><resize|1.|<tmlen|-22426.7|-44853.2|-67280>||<tmlen|4485.34|8970.65|13456>|>Warning
                if models differ in fixed effects

                <assign|item-nr|2><hidden|<tuple>><assign|last-item|2><vspace*|0.5fn><with|par-first|<quote|<tmlen|-26912|-53823.9|-80736>>|<yes-indent>><resize|2.|<tmlen|-22426.7|-44853.2|-67280>||<tmlen|4485.34|8970.65|13456>|>Recompute
              </surround>
            </with>
          </surround>
        </with>
      </tuple|<pageref|auto-4>>

      <\tuple|normal>
        Variance components, Steel and Tori.

        1. lmm ml Even with the help example, there are negative variances
        and no difference between ML and REML.

        2. admb doesn't report a variance for residual, this is MS from anova
      </tuple|<pageref|auto-5>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Introduction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>