<TeXmacs|1.99.5>

<style|generic>

<\body>
  <doc-data|<doc-title|Mixed Model>>

  <section|Data>

  <\program|r|default>
    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      set.seed(1000)

      source("~/Work/git/ASA_CSSA_SSSA/ASA_CSSA_SSSA/R/plot.lsmeans.R")
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      dat \<less\>- data.frame(

      \ \ \ \ \ \ \ \ plot = c(101,102,103,104,105,106,201,202,203,204,205,206,301,302,303,304,305,306,401,402,403,404,405,406),

      \ \ \ \ \ \ \ \ rep = as.factor(c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4)),

      \ \ \ \ \ \ \ \ col = as.factor(c(1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6)),

      \ \ \ \ \ \ \ \ trt = as.factor(c(4,5,6,3,1,2,6,4,2,5,3,1,2,3,1,6,5,4,3,6,2,5,4,1)),

      \ \ \ \ \ \ \ \ obs = c(3.43,5.25,6.47,2.8,NA,2.66,8.43,6.09,6.41,5.69,7.04,NA,6.07,6.19,4.93,5.95,4.99,3.26,5.22,7.35,4.48,6.34,6.71,3.13)

      \ \ \ )
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      dat \<less\>- subset(dat, !is.na(dat$obs))
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      treatments \<less\>- length(levels(dat$trt))
    </input>

    <\textput>
      \;
    </textput>

    \;

    <\textput>
      <section|lm>

      <subsection|Model Fitting>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.lm \<less\>- lm(obs ~ 0 + trt+rep, data = Table5.7)
    </input>

    <\textput>
      <subsection|<paragraph|Diagnostics>>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      par(mfrow = c(2, 2))\ 

      plot(Table5.7.lm)

      par(mfrow = c(1,1));v()
    </input>

    <\textput>
      <subsection|Model Building>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.lm \<less\>- update(Table5.7.lm, . ~ . - trt)
    </input>

    <\textput>
      <subsection|Summary Statistics>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.lm)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      anova(Table5.7.lm)

      anova(Table5.7.red.lm,Table5.7.lm)
    </input>

    \;

    <subsection|Presentation>

    \;

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(lsmeans)

      lsmeans(Table5.7.lm,cld ~ trt)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(ggplot2)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.lm.tbl \<less\>- make.plot.table(Table5.7.lm)

      Table5.7.lm.plot \<less\>- plot.lsmeans.tbl(Table5.7.lm.tbl)

      Table5.7.lm.plot;v()
    </input>

    \;

    \;

    <\textput>
      <section|lme>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(nlme)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.lme \<less\>- lme(obs ~ trt, random = ~ 1 \| rep,
      data=Table5.7)

      summary(Table5.7.lme)

      anova(Table5.7.lme)

      lsmeans(Table5.7.lme,cld ~ trt)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.lme \<less\>- update(Table5.7.lme, . ~ . - trt)

      anova(Table5.7.red.lme,Table5.7.lme)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(glht(Table5.7.lme,linfct=mcp(trt="Dunnett")))

      cld(glht(Table5.7.lme,linfct=mcp(trt="Tukey")),decreasing=TRUE)

      \;

      lsmeans(Table5.7.lme,pairwise ~ trt)

      summary(glht(Table5.7.lme,linfct=mcp(trt="Tukey")))
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      plot(Table5.7.lme);v()

      qqnorm(Table5.7.lme);v()

      qqnorm(resid(Table5.7.lme))
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      lme.plot \<less\>- plot.lsmeans(Table5.7.lme,cld ~ trt,title="lme")

      lme.plot;v()
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      plot.lsmeans(Table5.7.b.lme,cld ~ trt,title="lme b");v()
    </input>

    \;

    <\textput>
      <\textput>
        <section|glmmPQL>
      </textput>

      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(MASS)

      packageDescription("MASS")
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.glmmPQL \<less\>- glmmPQL(obs ~ trt, random = ~ 1 \|
      rep,family=gaussian, data = Table5.7)

      Table5.7.b.glmmPQL \<less\>- glmmPQL(obs ~ 0 + trt, random = ~ 1 \|
      rep,family=gaussian, data = Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      plot(Table5.7.glmmPQL);v()
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      qqnorm(Table5.7.glmmPQL);v()
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.glmmPQL)

      summary(Table5.7.b.glmmPQL)
    </input>

    \;

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.glmmPQL \<less\>- update(Table5.7.glmmPQL, . ~ . -trt)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      anova(Table5.7.glmmPQL)

      anova(Table5.7.glmmPQL,Table5.7.red.glmmPQL)
    </input>

    \;

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(aov(Table5.7.glmmPQL))

      summary(glht(Table5.7.glmmPQL,linfct=mcp(trt="Dunnett")))

      summary(glht(Table5.7.b.glmmPQL,linfct=mcp(trt="Dunnett")))

      cld(glht(Table5.7.glmmPQL,linfct=mcp(trt="Tukey")),decreasing=TRUE)

      lsmeans(Table5.7.glmmPQL,cld ~ trt)

      lsmeans(Table5.7.b.glmmPQL,cld ~ trt)
    </input>

    \;

    <\textput>
      <section|lmer>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(lme4)

      packageDescription("lme4")
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.lmer \<less\>- lmer(obs ~ trt + (1 \| rep), data=Table5.7)

      Table5.7.b.lmer \<less\>- lmer(obs ~ 0+trt + (1 \| rep), data=Table5.7)

      anova(Table5.7.lmer,Table5.7.b.lmer)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      plot(Table5.7.lmer);v()

      qqnorm(Table5.7.lmer);v()
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.lmer \<less\>- update(Table5.7.lmer, . ~ . -trt)

      anova(Table5.7.red.lmer,Table5.7.lmer)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      anova(Table5.7.lmer)

      anova(Table5.7.b.lmer)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      class(Table5.7.lmer)

      summary(glht(Table5.7.lmer,linfct=mcp(trt="Dunnett")))

      cld(glht(Table5.7.lmer,linfct=mcp(trt="Tukey")),decreasing=TRUE)

      lsmeans(Table5.7.lmer,cld ~ trt)

      lsmeans(Table5.7.b.lmer,cld ~ trt)
    </input>

    \;

    <\textput>
      <section|blmer>

      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(blme)

      packageDescription("blme")
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.blmer \<less\>- blmer(obs ~ trt + (1 \| rep), fixef.prior =
      normal, data=Table5.7)

      Table5.7.default.blmer \<less\>- blmer(obs ~ trt + (1 \| rep),
      data=Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      plot(Table5.7.blmer);v()

      qqnorm(Table5.7.blmer);v()
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.blmer)

      anova(Table5.7.blmer)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.blmer \<less\>- update(Table5.7.blmer, . ~ . -trt)

      anova(Table5.7.red.blmer,Table5.7.blmer)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.b.blmer \<less\>- blmer(obs ~ 0 + trt + (1 \| rep),
      fixef.prior = normal, data=Table5.7)

      summary(Table5.7.b.blmer)

      anova(Table5.7.b.blmer)

      anova(Table5.7.blmer,Table5.7.b.blmer)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      class(Table5.7.blmer)

      anova(Table5.7.default.blmer,Table5.7.blmer)
    </input>

    \;

    \;

    <\textput>
      <section|glmmADMB>

      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(glmmADMB)
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.admb \<less\>- glmmadmb(obs ~ trt, random = ~ 1 \| rep, family
      = "gaussian", data = Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.admb)

      anova(Table5.7.admb)
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.admb \<less\>- update(Table5.7.admb, . ~ . -trt)

      anova(Table5.7.admb,Table5.7.red.admb)
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      VarCorr(Table5.7.admb)

      summary(glht(Table5.7.admb,linfct=mcp(trt="Dunnett")))

      cld(glht(Table5.7.admb,linfct=mcp(trt="Tukey")),decreasing=TRUE)

      lsmeans(Table5.7.admb,cld ~ trt)
    </input>

    <\textput>
      \;
    </textput>

    <\textput>
      <section|glmmLasso>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(glmmLasso)
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.glmmLasso \<less\>- glmmLasso(fix = obs ~ trt, rnd = list(rep
      = ~1), lambda = 200, data = Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      plot(Table5.7.glmmLasso)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.glmmLasso)

      anova(Table5.7.glmmLasso)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.glmmLasso \<less\>- update(Table5.7.glmmLasso, . ~ . -trt)

      Table5.7.red.glmmLasso \<less\>- glmmLasso(fix = obs ~ 0, rnd =
      list(rep = ~1), lambda = 200, data = Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.glmmLasso \<less\>- update(Table5.7.glmmLasso, . ~ . -trt)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      glmmLasso(fix = obs ~ 0 + trt, rnd = list(rep = ~1), lambda = 200,
      control=list(center=FALSE), data = Table5.7)

      glmmLasso(fix = obs ~ trt, rnd = list(rep = ~1), lambda = 200, data =
      Table5.7,final.re=TRUE)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      plot(Table5.7.glmmLasso)
    </input>

    \;

    <\textput>
      <section|minque>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(minque)

      packageDescription("minque")\ 

      Table5.7.minque \<less\>- lmm(obs ~ trt \| rep, data=Table5.7,
      method="reml")

      \;

      Table5.7.minque[[1]]$Var

      Table5.7.minque[[1]]$FixedEffect

      Table5.7.minque[[1]]$RandomEffect
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.minque)

      anova(Table5.7.minque)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.minque \<less\>- update(Table5.7.red.minque, .~ . - trt)

      Table5.7.red.minque \<less\>- lmm(obs ~ 1 \| rep, data=Table5.7,
      method="reml")

      anova(Table5.7.minque,Table5.7.red.minque)
    </input>

    \;

    <\textput>
      <section|MCMCglmm>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(MCMCglmm)

      packageDescription("MCMCglmm")
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.mcmc \<less\>- MCMCglmm(fixed=obs ~ trt, random = ~ rep,
      data=Table5.7, verbose=FALSE)

      Table5.7.b.mcmc \<less\>- MCMCglmm(fixed=obs ~ 0+trt, random = ~ rep,
      data=Table5.7, verbose=FALSE)

      Table5.7.red.mcmc \<less\>- MCMCglmm(fixed=obs ~ 1, random = ~ rep,
      data=Table5.7, verbose=FALSE)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.mcmc)

      summary(Table5.7.b.mcmc)
    </input>

    \;

    \;

    <\textput>
      <section|INLA>

      Also not on CRAN, install via

      <verbatim|install.packages("INLA", repos="http://www.math.ntnu.no/inla/R/stable")>
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(INLA)

      Table5.7.inla \<less\>- inla(obs ~ trt + f(rep, model="iid"),
      data=Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.inla)

      \;
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;

      Table5.7.red.inla \<less\>- inla(obs ~ 1 + f(rep, model="iid"),
      data=Table5.7)

      #Table5.7.red.inla \<less\>- update(Table5.7.inla, . ~ . -trt)

      anova(Table5.7.inla)

      summary(aov(Table5.7.inla))

      vcov(Table5.7.inla)

      \;
    </input>

    <\textput>
      Note the interval widths (95% CI)
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      inla.tbl \<less\>- summary(Table5.7.inla)$fixed
    </input>

    \;

    <\textput>
      <section|brms>

      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      library(brms)

      packageDescription("brms")
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.brms \<less\>- brm(obs ~ trt + (1 \| rep), data=Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Table5.7.brms)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      anova(Table5.7.brms)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.brms \<less\>- update(Table5.7.brms, . ~ . - trt + 1)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      Table5.7.red.brms \ \<less\>- brm(obs ~ 1 + (1 \| rep), data=Table5.7)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      anova(Table5.7.brms,Table5.7.red.brms)
    </input>

    \;

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      summary(Ex16.8.1.brms)
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>
  </program>

  \;
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?|RMixedModels.tm>>
    <associate|auto-10|<tuple|2.5|?|RMixedModels.tm>>
    <associate|auto-11|<tuple|3|?|RMixedModels.tm>>
    <associate|auto-12|<tuple|4|?|RMixedModels.tm>>
    <associate|auto-13|<tuple|5|?|RMixedModels.tm>>
    <associate|auto-14|<tuple|6|?|RMixedModels.tm>>
    <associate|auto-15|<tuple|7|?|RMixedModels.tm>>
    <associate|auto-16|<tuple|8|?|RMixedModels.tm>>
    <associate|auto-17|<tuple|9|?|RMixedModels.tm>>
    <associate|auto-18|<tuple|10|?|RMixedModels.tm>>
    <associate|auto-19|<tuple|11|?|RMixedModels.tm>>
    <associate|auto-2|<tuple|2|?|RMixedModels.tm>>
    <associate|auto-20|<tuple|12|?|RMixedModels.tm>>
    <associate|auto-21|<tuple|12|?|RMixedModels.tm>>
    <associate|auto-22|<tuple|15|?|RMixedModels.tm>>
    <associate|auto-23|<tuple|1|?|RMixedModels.tm>>
    <associate|auto-24|<tuple|15|?|RMixedModels.tm>>
    <associate|auto-25|<tuple|16|?|RMixedModels.tm>>
    <associate|auto-26|<tuple|1|?|RMixedModels.tm>>
    <associate|auto-27|<tuple|15|?|RMixedModels.tm>>
    <associate|auto-28|<tuple|16|?|RMixedModels.tm>>
    <associate|auto-29|<tuple|17|?|RMixedModels.tm>>
    <associate|auto-3|<tuple|2.1|?|RMixedModels.tm>>
    <associate|auto-30|<tuple|2|?|RMixedModels.tm>>
    <associate|auto-31|<tuple|17|?|RMixedModels.tm>>
    <associate|auto-32|<tuple|18|?|RMixedModels.tm>>
    <associate|auto-33|<tuple|2|?|RMixedModels.tm>>
    <associate|auto-34|<tuple|2|?|RMixedModels.tm>>
    <associate|auto-35|<tuple|2|?|RMixedModels.tm>>
    <associate|auto-36|<tuple|15|?|RMixedModels.tm>>
    <associate|auto-37|<tuple|16|?|RMixedModels.tm>>
    <associate|auto-38|<tuple|17|?|RMixedModels.tm>>
    <associate|auto-39|<tuple|18|?|RMixedModels.tm>>
    <associate|auto-4|<tuple|2.2|?|RMixedModels.tm>>
    <associate|auto-40|<tuple|19|?|RMixedModels.tm>>
    <associate|auto-41|<tuple|20|?|RMixedModels.tm>>
    <associate|auto-42|<tuple|3|?|RMixedModels.tm>>
    <associate|auto-5|<tuple|2|?|RMixedModels.tm>>
    <associate|auto-6|<tuple|3|?|RMixedModels.tm>>
    <associate|auto-7|<tuple|3|?|RMixedModels.tm>>
    <associate|auto-8|<tuple|2.3|?|RMixedModels.tm>>
    <associate|auto-9|<tuple|2.4|?|RMixedModels.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal||<pageref|auto-7>>

      <tuple|normal||<pageref|auto-25>>

      <\tuple|normal>
        \;
      </tuple|<pageref|auto-42>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Introduction>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <with|par-left|<quote|1tab>|1.1<space|2spc>Theory
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>

      <with|par-left|<quote|1tab>|1.2<space|2spc>Single Trial
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|2tab>|1.2.1<space|2spc>Combined Trials
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|1.3<space|2spc>Workflow
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Data
      Entry> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6><vspace|0.5fn>

      <with|par-left|<quote|1tab>|2.1<space|2spc>Simulated Data for an RCBD
      with Two Missing Observations <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|2.2<space|2spc>Series of Similar
      Experiments <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|2.3<space|2spc>Sample RCBD Data
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Model
      Fitting> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc><assign|paragraph-numbered|false><assign|paragraph-prefix|<macro|<compound|the-paragraph>.>><assign|paragraph-nr|1><hidden|<tuple>><assign|subparagraph-nr|0><flag|table
      of contents|dark green|what><assign|auto-nr|13><write|toc|<with|par-left|<quote|4tab>|Diagnostics
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13><vspace|0.15fn>>><toc-notify|toc-4|Diagnostics><no-indent><with|font-series|<quote|bold>|math-font-series|<quote|bold>|<vspace*|0.5fn>Diagnostics<space|2spc>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13><vspace|0.5fn>

      <with|par-left|<quote|4tab>|Diagnostics
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15><vspace|0.15fn>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>Model
      Building> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Summary
      Statistics> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|7<space|2spc>Hypothesis
      Testing> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|8<space|2spc>Presentation>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|9<space|2spc>Architecture>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20><vspace|0.5fn>

      <with|par-left|<quote|1tab>|9.1<space|2spc>Classes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|1tab>|9.2<space|2spc>Generic Functions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|1tab>|9.3<space|2spc>Automation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|10<space|2spc>Advantages
      of Mixed Model Analysis.> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24><vspace|0.5fn>

      <with|par-left|<quote|1tab>|10.1<space|2spc>Advantage of linear models
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|1tab>|10.2<space|2spc>Problems with the linear
      model <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|1tab>|10.3<space|2spc>Mixed Model Specific
      Generic Methods <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|4tab>|Variance Components
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29><vspace|0.15fn>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|11<space|2spc>lme>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30><vspace|0.5fn>

      <with|par-left|<quote|1tab>|11.1<space|2spc>Example 2
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|1tab>|11.2<space|2spc>Model 3
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|12<space|2spc>glmmPQL>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|13<space|2spc>lmer>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|14<space|2spc>blmer>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|15<space|2spc>glmmADMB>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|16<space|2spc>glmmLasso>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|17<space|2spc>minque>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|18<space|2spc>MCMCglmm>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|19<space|2spc>INLA>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|20<space|2spc>brms>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>