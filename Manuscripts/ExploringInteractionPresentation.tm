<TeXmacs|1.99.5>

<style|generic>

<\body>
  <doc-data|<doc-title|Exploring Treatment <math|\<times\>> Trial
  Interactions using Treatment Stability/Trial Dendrogram plots>>

  <section|Abstract>

  In the analysis of combined agricultural experiments, the interaction
  between treatment and environment is of particular concern. When cross-over
  interactions are present, the recommendation for superior treatment will
  differ depending on environment.

  One common method for analyzing interaction is to plot treatment-in-trial
  means against the grand trial mean. The stability of treatments across
  trials is examined, with highly stable treatments varying less with trial
  mean than low-stability treatments. The treatment stability plot also
  allows trials to be ranked as low or high performing trials.

  Cluster analysis is also used to classify trials based on the performance
  of treatments within those trials. Dendrograms are used to show the
  rankings among trials and the relative distances between groups of trials.
  In the combined treatment stability/trial dendrogram plot, the position of
  "leaves" in the dendrogram is constrained to match the position of trial
  means in the treatment stability plot.\ 

  In the absence of interaction, the ranking and relative distance between
  trials in the dendrogram will be proportional to the trial mean. With
  interaction, trial dendrograms will cross when trial means are out of
  proportion relative the the performance of treatments within trials. For
  example, a low-performing trial may cluster with high-performing trials
  based on relative treatment performance. Other examples will be presented,
  and the use of geospatial mapping to supplement trial cluster analysis will
  be demonstrated.

  <section|Assumptions>

  The model for the analysis of <math|m> combined trials with <math|n>
  treatments replicated <math|l> times is given by an additive model with a
  grand mean <math|\<mu\>>, the additive effects of the <math|i<rsup|th>>
  treatment <math|\<alpha\>> and the <math|j<rsup|th>> environment
  <math|\<beta\>>, plus the interaction of the <math|i<rsup|th>> treatment in
  the <math|j<rsup|th>> environment, <math|\<phi\><rsub|i j>>, block in trial
  effects <math|\<rho\><rsub|k>> and error <math|e<rsub|i j k>>. (Yan 2006)

  <\equation>
    y<rsub|i j k>=\<mu\>+\<alpha\><rsub|i>+\<beta\><rsub|j>+\<phi\><rsub|i
    j>+\<rho\><rsub|k>+e<rsub|i j k>
  </equation>

  Sometimes only the means table is of interest. This may be represented as a
  matrix with treatment in rows and trial in columns, and a residual error
  <math|\<varepsilon\><rsub|i j>>

  <\equation>
    y<rsub|i j >=\<mu\>+\<alpha\><rsub|i>+\<beta\><rsub|j>+\<phi\><rsub|i
    j>+\<varepsilon\><rsub|i j><inactive|<label|two.way>>
  </equation>

  Assume that <math|\<varepsilon\><rsub|i
  j>\<sim\>\<cal-N\><around*|(|0,\<sigma\><rsup|2><rsub|\<phi\>>|)>>. In this
  context, <math|\<alpha\><rsub|g>=\<mu\><rsub|g>-\<mu\>> and
  <math|\<beta\><rsub|e>=\<mu\><rsub|e>-\<mu\>> (Gauch 2008)

  <section|Implementation>

  <subsection|Analysis>

  We implement this analysis in R. We assume a data set with the following
  columns:

  <big-table|<tabular|<tformat|<table|<row|<cell|Name>|<cell|Type>>|<row|<cell|Trial>|<cell|factor>>|<row|<cell|Treatment>|<cell|factor>>|<row|<cell|RepNo>|<cell|factor>>|<row|<cell|Plot.Mean>|<cell|numeric>>>>>|>

  For illustration, we'll use the Multilocation data from the SASMixes
  library

  <\session|r|default>
    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      library(SASmixed)

      data(Multilocation)

      st.dat \<less\>- Multilocation

      st.dat$Trial \<less\>- Multilocation$Location

      st.dat$Treatment \<less\>- Multilocation$Trt

      st.dat$RepNo \<less\>- Multilocation$Block

      st.dat$Plot.Mean \<less\>- Multilocation$Adj
    <|unfolded-io>
      library(SASmixed)

      \<gtr\> data(Multilocation)

      \<gtr\> st.dat \<less\>- Multilocation

      \<gtr\> st.dat$Trial \<less\>- Multilocation$Location

      \<gtr\> st.dat$Treatment \<less\>- Multilocation$Trt

      \<gtr\> st.dat$RepNo \<less\>- Multilocation$Block

      \<gtr\> st.dat$Plot.Mean \<less\>- Multilocation$Adj
    </unfolded-io>

    \;

    Assume we will define a function, <verbatim|armst.txt>, that analyzes
    multiple models (additive, Tukey's 1 d.f. and bundle of slopes, perhaps
    GGE and AMMI later) and returns a list of class <verbatim|armst.txt> with
    the result of each model. We will then write a <verbatim|summary>
    function that extracts AOV tables and means tables. Later, we write a
    <verbatim|plot> function.

    \;

    <\textput>
      Assuming that treatments and trials may not be exactly balanced, there
      are two possible specifications for the linear model. I prefer to list
      Trial first, since we want to be cautious about inference on
      Treatments. If there are an uneven number of observations per trial,
      this will shift more variance to trials and decrease signficance of
      treatment effects.

      \;

      I use the model=FALSE flag to prevent the returned object from carrying
      along the original data. If I wanted to called update, I would need the
      model, but I don't intend to do that. With very large data sets, this
      may impact performance.\ 

      <subsection|Parameters>

      For flexibility, we need to allow users to specify <verbatim|response>,
      <verbatim|treatment>, <verbatim|trial> and <verbatim|block> in trial
      variables. We'll default to strings and assume these are valid for
      input data. However, we also allow a null data object and assume input
      variables are data vectors.\ 

      \;

      We'll start with the simple additive model.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      armst.txt \<less\>- function(data=NULL,\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ response="response",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ treatment="treatment",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trial="trial",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ block="block",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ model=FALSE) {

      \ \ global.variables \<less\>- is.null(data)

      \ \ additive.lm \<less\>- NULL

      \ \ additive.formula \<less\>- NULL

      \ \ if(is.character(response)) {

      \ \ \ \ #TODO: check for response in global or data namespace

      \ \ \ \ additive.formula \<less\>- paste(response," ~ ",trial," *
      ",treatment,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "
      + ",trial,":",block)

      \ \ }

      \ \ if(global.variables) {

      \ \ \ \ \ if(is.null(additive.formula)) {

      \ \ \ \ \ \ \ #if we've gotten this far, the parameter names are mapped
      to\ 

      \ \ \ \ \ \ \ #data variables and we can analyze accordingly.

      \ \ \ \ \ \ \ additive.lm \<less\>- lm(response ~ trial*treatment +
      trial:block)

      \ \ \ \ \ } else {

      \ \ \ \ \ \ \ additive.lm \<less\>- lm(as.formula(additive.formula))

      \ \ \ \ \ }

      \ \ } else {

      \ \ \ \ \ #assume variables name columns in data.

      \ \ \ \ \ additive.lm \<less\>- lm(as.formula(additive.formula),data=data)

      \ \ }

      \ \ ret = list(additive.lm=additive.lm)

      \ \ class(ret)="armst.txt"

      \ \ return(ret)

      }
    <|unfolded-io>
      armst.txt \<less\>- function(data=NULL,\ 

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ response="response",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ treatment="treatment",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trial="trial",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ block="block",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ model=FALSE) {

      + \ \ global.variables \<less\>- is.null(data)

      + \ \ additive.lm \<less\>- NULL

      + \ \ additive.formula \<less\>- NULL

      + \ \ if(is.character(response)) {

      + \ \ \ \ #TODO: check for response in global or data namespace

      + \ \ \ \ additive.formula \<less\>- paste(response," ~ ",trial," *
      ",treatment,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "
      + ",trial,":",block)

      + \ \ }

      + \ \ if(global.variables) {

      + \ \ \ \ \ if(is.null(additive.formula)) {

      + \ \ \ \ \ \ \ #if we've gotten this far, the parameter names are
      mapped to\ 

      + \ \ \ \ \ \ \ #data variables and we can analyze accordingly.

      + \ \ \ \ \ \ \ additive.lm \<less\>- lm(response ~ trial*treatment +
      trial:block)

      + \ \ \ \ \ } else {

      + \ \ \ \ \ \ \ additive.lm \<less\>- lm(as.formula(additive.formula))

      + \ \ \ \ \ }

      + \ \ } else {

      + \ \ \ \ \ #assume variables name columns in data.

      + \ \ \ \ \ additive.lm \<less\>- lm(as.formula(additive.formula),data=data)

      + \ \ }

      + \ \ ret = list(additive.lm=additive.lm)

      + \ \ class(ret)="armst.txt"

      + \ \ return(ret)

      + }
    </unfolded-io>

    <\textput>
      Test with different data parameters
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      res1 \<less\>- armst.txt(trial=Multilocation$Location,

      \ \ \ \ \ \ \ \ \ \ treatment=Multilocation$Trt,

      \ \ \ \ \ \ \ \ \ \ block=Multilocation$Block,

      \ \ \ \ \ \ \ \ \ \ response=Multilocation$Adj)

      names(res1)

      class(res1)
    <|unfolded-io>
      res1 \<less\>- armst.txt(trial=Multilocation$Location,

      + \ \ \ \ \ \ \ \ \ \ treatment=Multilocation$Trt,

      + \ \ \ \ \ \ \ \ \ \ block=Multilocation$Block,

      + \ \ \ \ \ \ \ \ \ \ response=Multilocation$Adj)

      \<gtr\> names(res1)

      [1] "additive.lm"

      \<gtr\> class(res1)

      [1] "armst.txt"
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      res2 \<less\>- armst.txt(data=Multilocation,

      \ \ \ \ \ \ \ \ \ \ trial="Location",

      \ \ \ \ \ \ \ \ \ \ treatment="Trt",

      \ \ \ \ \ \ \ \ \ \ block="Block",

      \ \ \ \ \ \ \ \ \ \ response="Adj")

      names(res2)

      class(res2)
    <|unfolded-io>
      res2 \<less\>- armst.txt(data=Multilocation,

      + \ \ \ \ \ \ \ \ \ \ trial="Location",

      + \ \ \ \ \ \ \ \ \ \ treatment="Trt",

      + \ \ \ \ \ \ \ \ \ \ block="Block",

      + \ \ \ \ \ \ \ \ \ \ response="Adj")

      \<gtr\> names(res2)

      [1] "additive.lm"

      \<gtr\> class(res2)

      [1] "armst.txt"
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      attach(Multilocation)

      res3 \<less\>- armst.txt(trial="Location",

      \ \ \ \ \ \ \ \ \ \ treatment="Trt",

      \ \ \ \ \ \ \ \ \ \ block="Block",

      \ \ \ \ \ \ \ \ \ \ response="Adj")

      names(res3)

      class(res3)

      detach(Multilocation)
    <|unfolded-io>
      attach(Multilocation)

      \<gtr\> res3 \<less\>- armst.txt(trial="Location",

      + \ \ \ \ \ \ \ \ \ \ treatment="Trt",

      + \ \ \ \ \ \ \ \ \ \ block="Block",

      + \ \ \ \ \ \ \ \ \ \ response="Adj")

      \<gtr\> names(res3)

      [1] "additive.lm"

      \<gtr\> class(res3)

      [1] "armst.txt"

      \<gtr\> detach(Multilocation)
    </unfolded-io>

    <\textput>
      Now we extend the analysis to compute means. If the data are balanced,
      we can do simple means tables, but for now, assume missing plots. We'll
      later add checks for missing treatment by trial cells.

      \;

      We want a contrast matrix of the form\ 

      <\equation*>
        L=1<around*|\||L<rsub|>|\<nobracket\>><rsub|e><around*|\||L<rsub|t>|\|>L<rsub|e\<times\>t><around*|\||L<rsub|b<around*|(|t|)>>|\<nobracket\>>
      </equation*>

      were the number of rows in <math|L> match treatments times trials and
      the number of columns in <math|L> match <math|<wide|\<beta\>|^>>, where
      <math|<wide|\<beta\>|^>> is the OLS estimate for <math|y=X\<beta\>> and
      <math|X> is the model matrix from <verbatim|additive.lm>.

      \;
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      \;

      \;

      \;

      \;
    <|unfolded-io>
      \;

      \<gtr\>\ 

      \<gtr\>\ 

      \<gtr\>\ 
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      anova(res2$additive.lm,res3$additive.lm,res1$additive.lm)
    <|unfolded-io>
      anova(res2$additive.lm,res3$additive.lm,res1$additive.lm)

      Analysis of Variance Table

      \;

      Model 1: Adj ~ Location * Trt + Location:Block

      Model 2: Adj ~ Location * Trt + Location:Block

      \ \ Res.Df \ \ \ RSS Df Sum of Sq F Pr(\<gtr\>F)

      1 \ \ \ \ 54 1.8673 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      2 \ \ \ \ 54 1.8673 \ 0 \ \ \ \ \ \ \ \ 0 \ \ \ \ \ \ \ \ 

      Warning message:

      In anova.lmlist(object, ...) :

      \ \ models with response '"response"' removed because response differs
      from model 1
    </unfolded-io>

    <\textput>
      For now, we'll skip model diagnostics - we may generally assume that
      the basic linear model is appropriate, and that later analysis provide
      insight in cases of non-heterogeneous variances or non-normal data.
      Instead, we proceed directly to analysis of variance. I use anova to
      produce a data frame that we will build upon.

      \;
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      additive.lm \<less\>- lm(Plot.Mean ~ Trial+Treatment + Trial:RepNo,
      data=st.dat, model=FALSE)
    <|unfolded-io>
      additive.lm \<less\>- lm(Plot.Mean ~ Trial+Treatment + Trial:RepNo,
      data=st.dat, m

      \<less\>an ~ Trial+Treatment + Trial:RepNo, data=st.dat, model=FALSE)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      print(aov.tbl\<less\>-anova(additive.lm))
    <|unfolded-io>
      print(aov.tbl\<less\>-anova(additive.lm))

      Analysis of Variance Table

      \;

      Response: Plot.Mean

      \ \ \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value \ \ \ Pr(\<gtr\>F)
      \ \ \ 

      Trial \ \ \ \ \ \ \ 8 11.4635 1.43294 \ 39.028 \<less\> 2.2e-16 ***

      Treatment \ \ \ 3 \ 1.2217 0.40725 \ 11.092 3.839e-06 ***

      Trial:RepNo 18 \ 1.0270 0.05706 \ \ 1.554 \ \ 0.09427 . \ 

      Residuals \ \ 78 \ 2.8638 0.03672 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\textput>
      This table assumes all effects are fixed; this is typically not
      appropriate for multienvironment trials. We'll recompute F tests.

      We can take advantage of a trick in R to index into our anova table.\ 
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      TrtDF \<less\>- aov.tbl["Treatment",1]

      TrialDF \<less\>- aov.tbl["Trial",1]

      IntDF \<less\>- aov.tbl["Trial:Treatment",1]

      BlockDF \<less\>- aov.tbl["Trial:RepNo",1]
    <|unfolded-io>
      TrtDF \<less\>- aov.tbl["Treatment",1]

      \<gtr\> TrialDF \<less\>- aov.tbl["Trial",1]

      \<gtr\> IntDF \<less\>- aov.tbl["Trial:Treatment",1]

      \<gtr\> BlockDF \<less\>- aov.tbl["Trial:RepNo",1]
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      Fval \<less\>- aov.tbl["Treatment",3]/aov.tbl["Trial:Treatment",3]

      aov.tbl["Treatment",4] \<less\>- Fval

      aov.tbl["Treatment",5] \<less\>- 1 - pf(Fval, TrtDF, IntDF)
    <|unfolded-io>
      Fval \<less\>- aov.tbl["Treatment",3]/aov.tbl["Trial:Treatment",3]

      \<gtr\> aov.tbl["Treatment",4] \<less\>- Fval

      \<gtr\> aov.tbl["Treatment",5] \<less\>- 1 - pf(Fval, TrtDF, IntDF)
    </unfolded-io>

    <\textput>
      It is possible that the interaction MS will be exactly 0, but that is
      highly unlikely, so we don't need to check.\ 

      Trial significance is tricky. We may choose between Interaction or Rep
      in Trial. We may also choose an alternative test for blocks

      <\verbatim-code>
        Fval \<less\>- aov.tbl["Trial:RepNo",3]/aov.tbl["Trial:Treatment",3]

        aov.tbl["Trial:RepNo",4] \<less\>- Fval

        aov.tbl["Trial:RepNo",5] \<less\>- 1 - pf(Fval, BlockDF, IntDF)
      </verbatim-code>
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      Fval \<less\>- aov.tbl["Trial",3]/aov.tbl["Trial:RepNo",3]

      aov.tbl["Trial",4] \<less\>- Fval

      aov.tbl["Trial",5] \<less\>- 1 - pf(Fval, TrialDF, BlockDF)
    <|unfolded-io>
      Fval \<less\>- aov.tbl["Trial",3]/aov.tbl["Trial:RepNo",3]

      \<gtr\> aov.tbl["Trial",4] \<less\>- Fval

      \<gtr\> aov.tbl["Trial",5] \<less\>- 1 - pf(Fval, TrialDF, BlockDF)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      aov.tbl
    <|unfolded-io>
      aov.tbl

      Analysis of Variance Table

      \;

      Response: Plot.Mean

      \ \ \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value \ \ \ Pr(\<gtr\>F)
      \ \ \ 

      Trial \ \ \ \ \ \ \ 8 11.4635 1.43294 \ 25.115 3.001e-08 ***

      Treatment \ \ \ 3 \ 1.2217 0.40725 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      Trial:RepNo 18 \ 1.0270 0.05706 \ \ 1.554 \ \ 0.09427 . \ 

      Residuals \ \ 78 \ 2.8638 0.03672 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\textput>
      For covenience, we swap some rows.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tmp \<less\>- aov.tbl["Treatment",]

      aov.tbl["Treatment",] \<less\>- aov.tbl["Trial",]

      aov.tbl["Trial",] \<less\>- aov.tbl["Trial:RepNo",]

      aov.tbl["Trial:RepNo",] \<less\>- aov.tbl["Trial:Treatment",]

      aov.tbl["Trial:Treatment",] \<less\>- tmp

      rownames(aov.tbl) \<less\>- c('Trial','Rep in
      Trial','Treatment','Treatment x Trial','Residuals')
    <|unfolded-io>
      tmp \<less\>- aov.tbl["Treatment",]

      \<gtr\> aov.tbl["Treatment",] \<less\>- aov.tbl["Trial",]

      \<gtr\> aov.tbl["Trial",] \<less\>- aov.tbl["Trial:RepNo",]

      \<gtr\> aov.tbl["Trial:RepNo",] \<less\>- aov.tbl["Trial:Treatment",]

      \<gtr\> aov.tbl["Trial:Treatment",] \<less\>- tmp

      \<gtr\> rownames(aov.tbl) \<less\>- c('Trial','Rep in
      Trial','Treatment','Treatment x Tria

      \<less\>rial','Rep in Trial','Treatment','Treatment x
      Trial','Residuals')
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      aov.tbl
    <|unfolded-io>
      aov.tbl

      Analysis of Variance Table

      \;

      Response: Plot.Mean

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value
      \ \ \ Pr(\<gtr\>F) \ \ \ 

      Trial \ \ \ \ \ \ \ \ \ \ \ \ 18 \ 1.0270 0.05706 \ \ 1.554 \ \ 0.09427
      . \ 

      Rep in Trial \ \ \ \ \ \ 8 11.4635 1.43294 \ 25.115 3.001e-08 ***

      Treatment \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      Treatment x Trial 78 \ 2.8638 0.03672
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      Residuals \ \ \ \ \ \ \ \ \ 3 \ 1.2217 0.40725
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      treatments \<less\>-TrtDF+1

      trials \<less\>- TrialDF+1

      #If there are missing replicates, this is invalid

      #reps \<less\>- (BlockDF/trials)+1

      reps \<less\>- length(levels(st.dat$RepNo))
    <|unfolded-io>
      treatments \<less\>-TrtDF+1

      \<gtr\> trials \<less\>- TrialDF+1

      \<gtr\> #If there are missing replicates, this is invalid

      \<gtr\> #reps \<less\>- (BlockDF/trials)+1

      \<gtr\> reps \<less\>- length(levels(st.dat$RepNo))
    </unfolded-io>

    <\textput>
      <section|Least Square Means>

      To compute marginal (least square) means for treatments in trials
      (given replicate effects), we need first a set of contrast matrices
      that match linear encodings used to generate <math|\<beta\> >. From
      this, we can compute treatment and trial means as row and column means.

      \;

      Borrowing from\ 

      \;

      These give us the main effects.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      C.e \<less\>- match.fun(additive.lm$contrasts[['Trial']])(trials)

      C.t \<less\>- match.fun(additive.lm$contrasts[['Treatment']])(treatments)

      C.r \<less\>- match.fun(additive.lm$contrasts[['Trial']])(reps)

      C.full.e \<less\>- match.fun(additive.lm$contrasts[['Trial']])(trials,contrasts=FALSE)

      #C.b \<less\>- kronecker(C.r,C.full.e)
    <|unfolded-io>
      C.e \<less\>- match.fun(additive.lm$contrasts[['Trial']])(trials)

      \<gtr\> C.t \<less\>- match.fun(additive.lm$contrasts[['Treatment']])(treatments)

      \<gtr\> C.r \<less\>- match.fun(additive.lm$contrasts[['Trial']])(reps)

      \<gtr\> C.full.e \<less\>- match.fun(additive.lm$contrasts[['Trial']])(trials,contrasts=FA

      \<less\>itive.lm$contrasts[['Trial']])(trials,contrasts=FALSE)

      \<gtr\> #C.b \<less\>- kronecker(C.r,C.full.e)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      C.b
    <|unfolded-io>
      C.b

      Error: object 'C.b' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      notEstimable \<less\>- FALSE

      coeffs \<less\>- st.lm$coefficients

      if(any(is.na(coeffs))) {

      \ \ \ coeffs[is.na(coeffs)] \<less\>- 0

      \ \ \ notEstimable \<less\>- TRUE

      }
    <|unfolded-io>
      notEstimable \<less\>- FALSE

      \<gtr\> coeffs \<less\>- st.lm$coefficients

      Error: object 'st.lm' not found

      \<gtr\> if(any(is.na(coeffs))) {

      + \ \ \ coeffs[is.na(coeffs)] \<less\>- 0

      + \ \ \ notEstimable \<less\>- TRUE

      + }

      Error: object 'coeffs' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      #if trial by treatment

      L.t \<less\>- kronecker(rep(1,trials),C.t)

      L.e \<less\>- kronecker(C.e,rep(1,treatments))

      #if treatment by trial

      #L.t \<less\>- kronecker(rep(1,trials),C.t)

      #L.e \<less\>- kronecker(C.e,rep(1,treatments))

      L.r \<less\>- kronecker(t(rep(1,reps-1)),C.full.e)

      L.r \<less\>- kronecker(L.r,rep(1,treatments))

      L.r \<less\>- L.r/(reps)

      L.r \ \ 
    <|unfolded-io>
      #if trial by treatment

      \<gtr\> L.t \<less\>- kronecker(rep(1,trials),C.t)

      \<gtr\> L.e \<less\>- kronecker(C.e,rep(1,treatments))

      \<gtr\> #if treatment by trial

      \<gtr\> #L.t \<less\>- kronecker(rep(1,trials),C.t)

      \<gtr\> #L.e \<less\>- kronecker(C.e,rep(1,treatments))

      \<gtr\> L.r \<less\>- kronecker(t(rep(1,reps-1)),C.full.e)

      \<gtr\> L.r \<less\>- kronecker(L.r,rep(1,treatments))

      \<gtr\> L.r \<less\>- L.r/(reps)

      \<gtr\> L.r \ \ 

      \ \ \ \ \ \ \ \ \ \ \ [,1] \ \ \ \ \ [,2] \ \ \ \ \ [,3] \ \ \ \ \ [,4]
      \ \ \ \ \ [,5] \ \ \ \ \ [,6] \ \ \ \ \ [,7]

      \ [1,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [2,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [3,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [4,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [5,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [6,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [7,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [8,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [9,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      [10,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      [11,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      [12,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      [13,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      [14,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      [15,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      [16,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      [17,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [18,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [19,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [20,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [21,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [22,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [23,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [24,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [25,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [26,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [27,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [28,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [29,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [30,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [31,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [32,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [33,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [34,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [35,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [36,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ \ \ \ \ \ \ \ \ \ \ [,8] \ \ \ \ \ [,9] \ \ \ \ [,10] \ \ \ \ [,11]
      \ \ \ \ [,12] \ \ \ \ [,13] \ \ \ \ [,14]

      \ [1,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [2,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [3,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [4,] 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000
      0.0000000

      \ [5,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      \ [6,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      \ [7,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      \ [8,] 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 0.0000000
      0.0000000

      \ [9,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [10,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [11,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [12,] 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000
      0.0000000

      [13,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [14,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [15,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [16,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.3333333
      0.0000000

      [17,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [18,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [19,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [20,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.3333333

      [21,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [22,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [23,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [24,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [25,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [26,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [27,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [28,] 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [29,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [30,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [31,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [32,] 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [33,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [34,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [35,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      [36,] 0.0000000 0.3333333 0.0000000 0.0000000 0.0000000 0.0000000
      0.0000000

      \ \ \ \ \ \ \ \ \ \ [,15] \ \ \ \ [,16] \ \ \ \ [,17] \ \ \ \ [,18]

      \ [1,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [2,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [3,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [4,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [5,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [6,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [7,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [8,] 0.0000000 0.0000000 0.0000000 0.0000000

      \ [9,] 0.0000000 0.0000000 0.0000000 0.0000000

      [10,] 0.0000000 0.0000000 0.0000000 0.0000000

      [11,] 0.0000000 0.0000000 0.0000000 0.0000000

      [12,] 0.0000000 0.0000000 0.0000000 0.0000000

      [13,] 0.0000000 0.0000000 0.0000000 0.0000000

      [14,] 0.0000000 0.0000000 0.0000000 0.0000000

      [15,] 0.0000000 0.0000000 0.0000000 0.0000000

      [16,] 0.0000000 0.0000000 0.0000000 0.0000000

      [17,] 0.0000000 0.0000000 0.0000000 0.0000000

      [18,] 0.0000000 0.0000000 0.0000000 0.0000000

      [19,] 0.0000000 0.0000000 0.0000000 0.0000000

      [20,] 0.0000000 0.0000000 0.0000000 0.0000000

      [21,] 0.3333333 0.0000000 0.0000000 0.0000000

      [22,] 0.3333333 0.0000000 0.0000000 0.0000000

      [23,] 0.3333333 0.0000000 0.0000000 0.0000000

      [24,] 0.3333333 0.0000000 0.0000000 0.0000000

      [25,] 0.0000000 0.3333333 0.0000000 0.0000000

      [26,] 0.0000000 0.3333333 0.0000000 0.0000000

      [27,] 0.0000000 0.3333333 0.0000000 0.0000000

      [28,] 0.0000000 0.3333333 0.0000000 0.0000000

      [29,] 0.0000000 0.0000000 0.3333333 0.0000000

      [30,] 0.0000000 0.0000000 0.3333333 0.0000000

      [31,] 0.0000000 0.0000000 0.3333333 0.0000000

      [32,] 0.0000000 0.0000000 0.3333333 0.0000000

      [33,] 0.0000000 0.0000000 0.0000000 0.3333333

      [34,] 0.0000000 0.0000000 0.0000000 0.3333333

      [35,] 0.0000000 0.0000000 0.0000000 0.3333333

      [36,] 0.0000000 0.0000000 0.0000000 0.3333333
    </unfolded-io>

    <\textput>
      I haven't figured out how to expand with Kronecker,so I wrote a utility
      function
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      expand.incidence \<less\>- function(a, b, byRows=TRUE) {

      \;

      \ \ m = dim(a)[1]

      \ \ n = dim(a)[2]

      \ \ p = dim(b)[1]

      \ \ q = dim(b)[2]

      \ \ ret = matrix(0,nrow=(m * p), ncol=(n * q))

      \;

      \ \ #for each cell in b, create a block in the output matrix

      \ \ for (outerP in 1:p) {

      \ \ \ \ for (outerQ \ in 1:q) {

      \ \ \ \ \ \ currentB = b[outerP, outerQ]

      \ \ \ \ \ \ for (innerM \ in 1:m) {

      \ \ \ \ \ \ \ \ for (innerN \ in 1:n) {

      \ \ \ \ \ \ \ \ \ \ val = a[innerM, innerN] * currentB

      \ \ \ \ \ \ \ \ \ \ if (byRows) {

      \ \ \ \ \ \ \ \ \ \ \ \ #row in the return is the current A block
      (where each A block\ 

      \ \ \ \ \ \ \ \ \ \ \ \ #has p rows) plus the current B row

      \ \ \ \ \ \ \ \ \ \ \ \ i = ((innerM-1) * p) + outerP

      \ \ \ \ \ \ \ \ \ \ \ \ #similarly, current column is the current A
      block (each with

      \ \ \ \ \ \ \ \ \ \ \ \ #Q columns)

      \ \ \ \ \ \ \ \ \ \ \ \ j = ((outerQ-1) * n) + innerN

      \ \ \ \ \ \ \ \ \ \ \ \ ret[i, j] = val

      \ \ \ \ \ \ \ \ \ \ } else {

      \ \ \ \ \ \ \ \ \ \ \ \ #row in the return is the current A block
      (where each A block\ 

      #has p rows)

      \ \ \ \ \ \ \ \ \ \ \ \ #plus the current B row

      \ \ \ \ \ \ \ \ \ \ \ \ i = ((innerM-1) * p) + outerP

      \ \ \ \ \ \ \ \ \ \ \ \ #similarly, current column is the current A
      block (each with Q columns)

      \ \ \ \ \ \ \ \ \ \ \ \ j = ((innerN-1) * q) + outerQ

      \ \ \ \ \ \ \ \ \ \ \ \ ret[i, j] = val

      \ \ \ \ \ \ \ \ \ \ }

      \ \ \ \ \ \ \ \ }

      \ \ \ \ \ \ }

      \ \ \ \ }

      \ \ }

      \ \ return (ret)

      }
    <|unfolded-io>
      expand.incidence \<less\>- function(a, b, byRows=TRUE) {

      +\ 

      + \ \ m = dim(a)[1]

      + \ \ n = dim(a)[2]

      + \ \ p = dim(b)[1]

      + \ \ q = dim(b)[2]

      + \ \ ret = matrix(0,nrow=(m * p), ncol=(n * q))

      +\ 

      + \ \ #for each cell in b, create a block in the output matrix

      + \ \ for (outerP in 1:p) {

      + \ \ \ \ for (outerQ \ in 1:q) {

      + \ \ \ \ \ \ currentB = b[outerP, outerQ]

      + \ \ \ \ \ \ for (innerM \ in 1:m) {

      + \ \ \ \ \ \ \ \ for (innerN \ in 1:n) {

      + \ \ \ \ \ \ \ \ \ \ val = a[innerM, innerN] * currentB

      + \ \ \ \ \ \ \ \ \ \ if (byRows) {

      + \ \ \ \ \ \ \ \ \ \ \ \ #row in the return is the current A block
      (where each A block\ 

      + \ \ \ \ \ \ \ \ \ \ \ \ #has p rows) plus the current B row

      + \ \ \ \ \ \ \ \ \ \ \ \ i = ((innerM-1) * p) + outerP

      + \ \ \ \ \ \ \ \ \ \ \ \ #similarly, current column is the current A
      block (each with

      + \ \ \ \ \ \ \ \ \ \ \ \ #Q columns)

      + \ \ \ \ \ \ \ \ \ \ \ \ j = ((outerQ-1) * n) + innerN

      + \ \ \ \ \ \ \ \ \ \ \ \ ret[i, j] = val

      + \ \ \ \ \ \ \ \ \ \ } else {

      + \ \ \ \ \ \ \ \ \ \ \ \ #row in the return is the current A block
      (where each A block\ 

      + #has p rows)

      + \ \ \ \ \ \ \ \ \ \ \ \ #plus the current B row

      + \ \ \ \ \ \ \ \ \ \ \ \ i = ((innerM-1) * p) + outerP

      + \ \ \ \ \ \ \ \ \ \ \ \ #similarly, current column is the current A
      block (each with Q\ 

      \<less\>urrent column is the current A block (each with Q columns)

      + \ \ \ \ \ \ \ \ \ \ \ \ j = ((innerN-1) * q) + outerQ

      + \ \ \ \ \ \ \ \ \ \ \ \ ret[i, j] = val

      + \ \ \ \ \ \ \ \ \ \ }

      + \ \ \ \ \ \ \ \ }

      + \ \ \ \ \ \ }

      + \ \ \ \ }

      + \ \ }

      + \ \ return (ret)

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      #if trial by treatment

      L.te = expand.incidence(C.e,C.t)

      L.te

      L.txt \<less\>- cbind(rep(1,treatments*trials),L.e,L.t, L.te, L.r)

      #if treatment by trial

      #L.te = expand.incidence(C.e,C.t,byRows=FALSE)

      #L.txt \<less\>- cbind(rep(1,treatments*trials),L.t, L.e,L.te, L.r)
    <|unfolded-io>
      #if trial by treatment

      \<gtr\> L.te = expand.incidence(C.e,C.t)

      \<gtr\> L.te

      \ \ \ \ \ \ [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11]
      [,12] [,13]

      \ [1,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [2,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [3,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [4,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [5,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [6,] \ \ \ 1 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [7,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [8,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [9,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [10,] \ \ \ 0 \ \ \ 1 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [11,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [12,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [13,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [14,] \ \ \ 0 \ \ \ 0 \ \ \ 1 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [15,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0

      [16,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [17,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [18,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 1 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [19,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0

      [20,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [21,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [22,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 1 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [23,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1

      [24,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [25,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [26,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 1 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [27,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [28,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [29,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [30,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 1 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [31,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [32,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [33,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [34,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 1
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [35,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [36,] \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0
      \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ \ \ \ \ \ [,14] [,15] [,16] [,17] [,18] [,19] [,20] [,21] [,22] [,23]
      [,24]

      \ [1,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [2,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [3,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [4,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [5,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [6,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [7,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [8,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      \ [9,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [10,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [11,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [12,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [13,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [14,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [15,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [16,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [17,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [18,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [19,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [20,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [21,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [22,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [23,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [24,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [25,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [26,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [27,] \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [28,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0

      [29,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [30,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [31,] \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [32,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0

      [33,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [34,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [35,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0

      [36,] \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0
      \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 0 \ \ \ \ 1

      \<gtr\> L.txt \<less\>- cbind(rep(1,treatments*trials),L.e,L.t, L.te,
      L.r)

      \<gtr\> #if treatment by trial

      \<gtr\> #L.te = expand.incidence(C.e,C.t,byRows=FALSE)

      \<gtr\> #L.txt \<less\>- cbind(rep(1,treatments*trials),L.t, L.e,L.te,
      L.r)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      txt.lsmeans.tbl \<less\>- t(matrix(L.txt %*% coeffs,nrow=treatments))

      trt.means \<less\>- colMeans(txt.lsmeans.tbl)

      trial.means \<less\>- rowMeans(txt.lsmeans.tbl)
    <|unfolded-io>
      txt.lsmeans.tbl \<less\>- t(matrix(L.txt %*% coeffs,nrow=treatments))

      Error in matrix(L.txt %*% coeffs, nrow = treatments) :\ 

      \ \ object 'coeffs' not found

      \<gtr\> trt.means \<less\>- colMeans(txt.lsmeans.tbl)

      Error in is.data.frame(x) : object 'txt.lsmeans.tbl' not found

      \<gtr\> trial.means \<less\>- rowMeans(txt.lsmeans.tbl)

      Error in is.data.frame(x) : object 'txt.lsmeans.tbl' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      txt.lsmeans.tbl
    <|unfolded-io>
      txt.lsmeans.tbl

      Error: object 'txt.lsmeans.tbl' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      means.tbl \<less\>- data.frame(trt=as.integer(levels(st.dat$Treatment)),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ arith=tapply(st.dat$Plot.Mean,\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ list(st.dat$Treatment),mean),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lsmean=trt.means)
    <|unfolded-io>
      means.tbl \<less\>- data.frame(trt=as.integer(levels(st.dat$Treatment)),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ arith=tapply(st.dat$Plot.Mean,\ 

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ list(st.dat$Treatment),mean),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lsmean=trt.means)

      Error in data.frame(trt = as.integer(levels(st.dat$Treatment)), arith =
      tapply(st.dat$Plot.Mean, \ :\ 

      \ \ object 'trt.means' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      columnIndexes \<less\>- attr(st.lm$x,'assign')
    <|unfolded-io>
      columnIndexes \<less\>- attr(st.lm$x,'assign')

      Error: object 'st.lm' not found
    </unfolded-io>

    <\textput>
      And a utility for design matrix
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      incidence.matrix \<less\>- function(data, effect) {

      \ \ \ cLevels \<less\>- levels(get(effect,data))

      \ \ \ contr \<less\>- contr.treatment(cLevels,contrasts=FALSE)

      \ \ \ idx \<less\>- as.numeric(data[,effect])

      \ \ \ return(as.matrix(t(contr[,idx])))

      }
    <|unfolded-io>
      incidence.matrix \<less\>- function(data, effect) {

      + \ \ \ cLevels \<less\>- levels(get(effect,data))

      + \ \ \ contr \<less\>- contr.treatment(cLevels,contrasts=FALSE)

      + \ \ \ idx \<less\>- as.numeric(data[,effect])

      + \ \ \ return(as.matrix(t(contr[,idx])))

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      coincidence.matrix \<less\>- function(data=NULL, a.name,b.name) {

      \ \ \ a \<less\>- incidence.matrix(data,effect=a.name)

      \ \ \ b \<less\>- incidence.matrix(data,effect=b.name)

      \ \ \ return(t(a) %*% b)

      }
    <|unfolded-io>
      coincidence.matrix \<less\>- function(data=NULL, a.name,b.name) {

      + \ \ \ a \<less\>- incidence.matrix(data,effect=a.name)

      + \ \ \ b \<less\>- incidence.matrix(data,effect=b.name)

      + \ \ \ return(t(a) %*% b)

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      invert.diagonal \<less\>- function(a) {

      \ \ tol \<less\>- 1/ (.Machine$integer.max)

      \ \ for (row in 1:dim(a)[1]) {

      \ \ \ \ val = a[row, row]

      \ \ \ \ if (!(abs(val)\<less\>tol)) {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ a[row, row] \<less\>- 1 / val

      \ \ \ \ \ \ \ \ } else {

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ a[row, row] \<less\>- 0

      \ \ \ \ \ \ \ \ }

      \ \ }

      \ \ return (a)

      }
    <|unfolded-io>
      invert.diagonal \<less\>- function(a) {

      + \ \ tol \<less\>- 1/ (.Machine$integer.max)

      + \ \ for (row in 1:dim(a)[1]) {

      + \ \ \ \ val = a[row, row]

      + \ \ \ \ if (!(abs(val)\<less\>tol)) {

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ a[row, row] \<less\>- 1 / val

      + \ \ \ \ \ \ \ \ } else {

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ a[row, row] \<less\>- 0

      + \ \ \ \ \ \ \ \ }

      + \ \ }

      + \ \ return (a)

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      interaction.matrix \<less\>- function(d=NULL,
      effect1="Treatment",effect2="Trial",useMatrix=FALSE) {

      \ \ \ if(useMatrix) {

      \ \ \ \ \ \ require(Matrix)

      \ \ \ }

      \ \ \ 

      \ \ \ X1 \<less\>- NULL

      \ \ \ X2 \<less\>- NULL

      \;

      \ \ \ if(!is.null(d)) {

      \ \ \ \ \ \ X1 \<less\>- incidence.matrix(d,effect=effect1)

      \ \ \ \ \ \ X2 \<less\>- incidence.matrix(d,effect=effect2)

      \ \ \ } else {

      \ \ \ \ \ \ X1 \<less\>- incidence.matrix(effect=effect1)

      \ \ \ \ \ \ X2 \<less\>- incidence.matrix(effect=effect2)

      \ \ \ }

      \;

      \ \ \ rows \<less\>- dim(X1)[1]

      \ \ \ cols \<less\>- dim(X1)[2]*dim(X2)[2]

      \;

      \ \ \ X \<less\>- matrix(0,nrow=rows, ncol=cols)

      \ \ \ #expand

      \ \ \ for(i in 1:rows) {

      \ \ \ \ \ \ X[i,] \<less\>- kronecker(X1[i,],X2[i,])

      \ \ \ }

      \ \ \ #remove empty rows

      \ \ \ j=1

      \ \ \ while(j \<less\>= cols) {

      \ \ \ \ \ \ if(sum(X[,j])==0) {

      \ \ \ \ \ \ \ \ \ X \<less\>- X[,-j]

      \ \ \ \ \ \ \ \ \ cols \<less\>- cols-1

      \ \ \ \ \ \ }

      \ \ \ \ \ \ j \<less\>- j+1

      \ \ \ }

      \ \ \ return(X)

      }
    <|unfolded-io>
      interaction.matrix \<less\>- function(d=NULL,
      effect1="Treatment",effect2="Trial",

      \<less\>ction(d=NULL, effect1="Treatment",effect2="Trial",useMatrix=FALSE)
      {

      + \ \ \ if(useMatrix) {

      + \ \ \ \ \ \ require(Matrix)

      + \ \ \ }

      + \ \ \ 

      + \ \ \ X1 \<less\>- NULL

      + \ \ \ X2 \<less\>- NULL

      +\ 

      + \ \ \ if(!is.null(d)) {

      + \ \ \ \ \ \ X1 \<less\>- incidence.matrix(d,effect=effect1)

      + \ \ \ \ \ \ X2 \<less\>- incidence.matrix(d,effect=effect2)

      + \ \ \ } else {

      + \ \ \ \ \ \ X1 \<less\>- incidence.matrix(effect=effect1)

      + \ \ \ \ \ \ X2 \<less\>- incidence.matrix(effect=effect2)

      + \ \ \ }

      +\ 

      + \ \ \ rows \<less\>- dim(X1)[1]

      + \ \ \ cols \<less\>- dim(X1)[2]*dim(X2)[2]

      +\ 

      + \ \ \ X \<less\>- matrix(0,nrow=rows, ncol=cols)

      + \ \ \ #expand

      + \ \ \ for(i in 1:rows) {

      + \ \ \ \ \ \ X[i,] \<less\>- kronecker(X1[i,],X2[i,])

      + \ \ \ }

      + \ \ \ #remove empty rows

      + \ \ \ j=1

      + \ \ \ while(j \<less\>= cols) {

      + \ \ \ \ \ \ if(sum(X[,j])==0) {

      + \ \ \ \ \ \ \ \ \ X \<less\>- X[,-j]

      + \ \ \ \ \ \ \ \ \ cols \<less\>- cols-1

      + \ \ \ \ \ \ }

      + \ \ \ \ \ \ j \<less\>- j+1

      + \ \ \ }

      + \ \ \ return(X)

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      TreatmentX \<less\>- incidence.matrix(st.dat,effect='Treatment')

      TrialZ \<less\>- incidence.matrix(st.dat,effect='Trial')

      RepInTrialZ \<less\>- interaction.matrix(st.dat,'Trial','RepNo')
    <|unfolded-io>
      TreatmentX \<less\>- incidence.matrix(st.dat,effect='Treatment')

      \<gtr\> TrialZ \<less\>- incidence.matrix(st.dat,effect='Trial')

      \<gtr\> RepInTrialZ \<less\>- interaction.matrix(st.dat,'Trial','RepNo')
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      N \<less\>- t(TreatmentX) %*% RepInTrialZ

      t_delta \<less\>- t(TreatmentX) %*% TreatmentX

      v_delta \<less\>- t(RepInTrialZ) %*% RepInTrialZ

      v_delta_inv \<less\>- invert.diagonal(v_delta)

      A \<less\>- t_delta + N %*% v_delta_inv %*% t(N)
    <|unfolded-io>
      N \<less\>- t(TreatmentX) %*% RepInTrialZ

      \<gtr\> t_delta \<less\>- t(TreatmentX) %*% TreatmentX

      \<gtr\> v_delta \<less\>- t(RepInTrialZ) %*% RepInTrialZ

      \<gtr\> v_delta_inv \<less\>- invert.diagonal(v_delta)

      \<gtr\> A \<less\>- t_delta + N %*% v_delta_inv %*% t(N)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      A
    <|unfolded-io>
      A

      \ \ \ \ \ \ 1 \ \ \ \ 2 \ \ \ \ 3 \ \ \ \ 4

      1 33.75 \ 6.75 \ 6.75 \ 6.75

      2 \ 6.75 33.75 \ 6.75 \ 6.75

      3 \ 6.75 \ 6.75 33.75 \ 6.75

      4 \ 6.75 \ 6.75 \ 6.75 33.75
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      #mixed effects model

      ems \<less\>- aov.tbl[4,3]

      #fixed effects model

      #ems \<less\>- aov.tbl[5,3]
    <|unfolded-io>
      #mixed effects model

      \<gtr\> ems \<less\>- aov.tbl[4,3]

      \<gtr\> #fixed effects model

      \<gtr\> #ems \<less\>- aov.tbl[5,3]
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      ems
    <|unfolded-io>
      ems

      [1] 0.0367154
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      pseudoinverse \<less\>- function(A) {

      \ \ \ #decompose to U D V' (svd)

      \ \ \ #replace effectively 0 with 0

      \ \ \ #return iM = V D^(-1) U'

      \ \ \ svdRes \<less\>- svd(A)

      \ \ \ #D \<less\>- Matrix(svdRes$d)

      \ \ \ D \<less\>- svdRes$d

      \ \ \ 

      \ \ \ #the returned matrices will have very small real values that need
      to

      \ \ \ #be treated as 0 (these are the singular values or s.v.d.). Use
      R's

      \ \ \ #definition of large integers to define tolerance.

      \ \ \ tol \<less\>- 1/ (.Machine$integer.max)

      \ \ \ D[abs(D)\<less\>tol] \<less\>- 0

      \ \ \ Dinv \<less\>- D

      \ \ \ Dinv[Dinv\<gtr\>0] \<less\>- 1/Dinv[Dinv\<gtr\>0]

      \ \ \ Dinv \<less\>- diag(Dinv)

      \;

      \ \ \ #V \<less\>- Matrix(svdRes$v)

      \ \ \ V \<less\>- svdRes$v

      \ \ \ V[abs(V)\<less\>tol] \<less\>- 0

      \;

      \ \ \ #U \<less\>- Matrix(svdRes$u)

      \ \ \ U \<less\>- svdRes$u

      \ \ \ U[abs(U)\<less\>tol] \<less\>- 0

      \ \ \ 

      \ \ \ #tmp \<less\>- V%*%Dinv%*%t(U)

      \ \ \ #return(tmp)

      \ \ \ return(V%*%Dinv%*%t(U))

      }
    <|unfolded-io>
      pseudoinverse \<less\>- function(A) {

      + \ \ \ #decompose to U D V' (svd)

      + \ \ \ #replace effectively 0 with 0

      + \ \ \ #return iM = V D^(-1) U'

      + \ \ \ svdRes \<less\>- svd(A)

      + \ \ \ #D \<less\>- Matrix(svdRes$d)

      + \ \ \ D \<less\>- svdRes$d

      + \ \ \ 

      + \ \ \ #the returned matrices will have very small real values that
      need to

      + \ \ \ #be treated as 0 (these are the singular values or s.v.d.). Use
      R's

      + \ \ \ #definition of large integers to define tolerance.

      + \ \ \ tol \<less\>- 1/ (.Machine$integer.max)

      + \ \ \ D[abs(D)\<less\>tol] \<less\>- 0

      + \ \ \ Dinv \<less\>- D

      + \ \ \ Dinv[Dinv\<gtr\>0] \<less\>- 1/Dinv[Dinv\<gtr\>0]

      + \ \ \ Dinv \<less\>- diag(Dinv)

      +\ 

      + \ \ \ #V \<less\>- Matrix(svdRes$v)

      + \ \ \ V \<less\>- svdRes$v

      + \ \ \ V[abs(V)\<less\>tol] \<less\>- 0

      +\ 

      + \ \ \ #U \<less\>- Matrix(svdRes$u)

      + \ \ \ U \<less\>- svdRes$u

      + \ \ \ U[abs(U)\<less\>tol] \<less\>- 0

      + \ \ \ 

      + \ \ \ #tmp \<less\>- V%*%Dinv%*%t(U)

      + \ \ \ #return(tmp)

      + \ \ \ return(V%*%Dinv%*%t(U))

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      covA \<less\>- pseudoinverse (A) * ems
    <|unfolded-io>
      covA \<less\>- pseudoinverse (A) * ems
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      covA
    <|unfolded-io>
      covA

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ [,1] \ \ \ \ \ \ \ \ \ [,2]
      \ \ \ \ \ \ \ \ \ [,3] \ \ \ \ \ \ \ \ \ [,4]

      [1,] \ 0.0011898509 -0.0001699787 -0.0001699787 -0.0001699787

      [2,] -0.0001699787 \ 0.0011898509 -0.0001699787 -0.0001699787

      [3,] -0.0001699787 -0.0001699787 \ 0.0011898509 -0.0001699787

      [4,] -0.0001699787 -0.0001699787 -0.0001699787 \ 0.0011898509
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      t_delta
    <|unfolded-io>
      t_delta

      \ \ \ 1 \ 2 \ 3 \ 4

      1 27 \ 0 \ 0 \ 0

      2 \ 0 27 \ 0 \ 0

      3 \ 0 \ 0 27 \ 0

      4 \ 0 \ 0 \ 0 27
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      #if MeanEffects

      grandmean \<less\>- mean(unlist(txt.lsmeans.tbl))

      trial.effects \<less\>- trial.means-grandmean

      trt.effects \<less\>- trt.means-grandmean
    <|unfolded-io>
      #if MeanEffects

      \<gtr\> grandmean \<less\>- mean(unlist(txt.lsmeans.tbl))

      Error in unlist(txt.lsmeans.tbl) : object 'txt.lsmeans.tbl' not found

      \<gtr\> trial.effects \<less\>- trial.means-grandmean

      Error: object 'trial.means' not found

      \<gtr\> trt.effects \<less\>- trt.means-grandmean

      Error: object 'trt.means' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      # if TrialByTreatment

      additive.lm \<less\>- lm(Plot.Mean ~ Trial+Treatment + Trial:RepNo,
      data=st.dat, model=FALSE)

      #otherwise additive.lm \<less\>- lm(Plot.Mean ~ Treatment+Trial +
      Trial:RepNo, data=st.dat, model=FALSE)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
    <|unfolded-io>
      # if TrialByTreatment

      \<gtr\> additive.lm \<less\>- lm(Plot.Mean ~ Trial+Treatment +
      Trial:RepNo, data=st.dat, m

      \<less\>an ~ Trial+Treatment + Trial:RepNo, data=st.dat, model=FALSE)

      \<gtr\> #otherwise additive.lm \<less\>- lm(Plot.Mean ~ Treatment+Trial
      + Trial:RepNo, dat

      \<less\> lm(Plot.Mean ~ Treatment+Trial + Trial:RepNo, data=st.dat,
      model=FALSE)

      \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      additive.labels \<less\>- attr(additive.lm$terms, 'term.labels')

      additive.assign = additive.lm$assign

      additive.coef \<less\>- additive.lm$coefficients
    <|unfolded-io>
      additive.labels \<less\>- attr(additive.lm$terms, 'term.labels')

      \<gtr\> additive.assign = additive.lm$assign

      \<gtr\> additive.coef \<less\>- additive.lm$coefficients
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      e.beta \<less\>- additive.coef[additive.assign ==
      which(additive.labels=='Trial')]

      t.beta \<less\>- additive.coef[additive.assign ==
      which(additive.labels=='Treatment')]
    <|unfolded-io>
      e.beta \<less\>- additive.coef[additive.assign ==
      which(additive.labels=='Trial')]

      \<gtr\> t.beta \<less\>- additive.coef[additive.assign ==
      which(additive.labels=='Treatmen

      \<less\>dditive.assign == which(additive.labels=='Treatment')]
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      e.mat \<less\>- match.fun(additive.lm$contrasts[['Trial']])(length(e.beta)+1)

      t.mat \<less\>- match.fun(additive.lm$contrasts[['Treatment']])(length(t.beta)+1)
    <|unfolded-io>
      e.mat \<less\>- match.fun(additive.lm$contrasts[['Trial']])(length(e.beta)+1)

      \<gtr\> t.mat \<less\>- match.fun(additive.lm$contrasts[['Treatment']])(length(t.beta)+1)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      trial.effects \<less\>- e.mat %*% e.beta

      trt.effects \<less\>- t.mat %*% t.beta
    <|unfolded-io>
      trial.effects \<less\>- e.mat %*% e.beta

      \<gtr\> trt.effects \<less\>- t.mat %*% t.beta
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      trial.effects \<less\>- trial.effects - mean(trial.effects)

      trt.effects \<less\>- trt.effects - mean(trt.effects)

      trial.effects \<less\>- as.vector(trial.effects)

      trt.effects \<less\>- as.vector(trt.effects)

      names(trial.effects) \<less\>- additive.lm$xlevels[['Trial']]

      names(trt.effects) \<less\>- additive.lm$xlevels[['Treatment']]
    <|unfolded-io>
      trial.effects \<less\>- trial.effects - mean(trial.effects)

      \<gtr\> trt.effects \<less\>- trt.effects - mean(trt.effects)

      \<gtr\> trial.effects \<less\>- as.vector(trial.effects)

      \<gtr\> trt.effects \<less\>- as.vector(trt.effects)

      \<gtr\> names(trial.effects) \<less\>- additive.lm$xlevels[['Trial']]

      \<gtr\> names(trt.effects) \<less\>- additive.lm$xlevels[['Treatment']]
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      st.dat$TreatmentIdx \<less\>- as.numeric(st.dat$Treatment)

      st.dat$TrialIdx \<less\>- as.numeric(st.dat$Trial)

      st.dat$a \<less\>- trt.effects[st.dat$TreatmentIdx]

      st.dat$b \<less\>- trial.effects[st.dat$TrialIdx]
    <|unfolded-io>
      st.dat$TreatmentIdx \<less\>- as.numeric(st.dat$Treatment)

      \<gtr\> st.dat$TrialIdx \<less\>- as.numeric(st.dat$Trial)

      \<gtr\> st.dat$a \<less\>- trt.effects[st.dat$TreatmentIdx]

      \<gtr\> st.dat$b \<less\>- trial.effects[st.dat$TrialIdx]
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      gei.table.to.frame \<less\>- function(table,response =
      "Plot.Mean",TreatmentName="Treatment",TrialName="Trial",GinRows=TRUE) {

      \ \ 

      \ \ #keep dimensions and names before stacking.

      \ \ table.dim \<less\>- dim(table)

      \ \ cnames \<less\>- colnames(table)

      \ \ rnames \<less\>- rownames(table)

      \ \ 

      \ \ #stack the data. This is easier using a data frame

      \ \ if(!is.data.frame(table)) {

      \ \ \ \ table \<less\>- data.frame(table)

      \ \ }

      \ \ means.frame \<less\>- stack(table)

      \ \ 

      \ \ #frame should have two columns, values and ind.

      \ \ #ind should have column names if present, but will have an
      arbitrary

      \ \ #name otherwise

      \ \ if(is.null(cnames)) {

      \ \ \ \ means.frame$ind \<less\>- rep(1:table.dim[2],each=table.dim[1])

      \ \ }

      \ \ 

      \ \ #we need to add row names as well. If there are no rows names,

      \ \ #generate some

      \ \ if(is.null(rnames)) {

      \ \ \ \ rnames \<less\>- as.character(1:table.dim[1])

      \ \ }

      \ \ means.frame$newrow \<less\>- rep(rnames,table.dim[2])

      \;

      \ \ if(GinRows) {

      \ \ \ \ #treatments are in rows

      \ \ \ \ colnames(means.frame) \<less\>-
      c(response,TrialName,TreatmentName)

      \ \ } else {

      \ \ \ \ #trials in rows

      \ \ \ \ colnames(means.frame) \<less\>-
      c(response,TreatmentName,TrialName)

      \ \ }

      \ \ #make sure treatment and trial are factors

      \ \ means.frame[,c(TreatmentName,TrialName)] \<less\>-
      lapply(means.frame[,c(TreatmentName,TrialName)] , factor)

      \ \ return(means.frame)

      }
    <|unfolded-io>
      gei.table.to.frame \<less\>- function(table,response =
      "Plot.Mean",TreatmentName="

      \<less\>ction(table,response = "Plot.Mean",TreatmentName="Treatment",TrialName="Tria

      \<less\>ot.Mean",TreatmentName="Treatment",TrialName="Trial",GinRows=TRUE)
      {

      + \ \ 

      + \ \ #keep dimensions and names before stacking.

      + \ \ table.dim \<less\>- dim(table)

      + \ \ cnames \<less\>- colnames(table)

      + \ \ rnames \<less\>- rownames(table)

      + \ \ 

      + \ \ #stack the data. This is easier using a data frame

      + \ \ if(!is.data.frame(table)) {

      + \ \ \ \ table \<less\>- data.frame(table)

      + \ \ }

      + \ \ means.frame \<less\>- stack(table)

      + \ \ 

      + \ \ #frame should have two columns, values and ind.

      + \ \ #ind should have column names if present, but will have an
      arbitrary

      + \ \ #name otherwise

      + \ \ if(is.null(cnames)) {

      + \ \ \ \ means.frame$ind \<less\>-
      rep(1:table.dim[2],each=table.dim[1])

      + \ \ }

      + \ \ 

      + \ \ #we need to add row names as well. If there are no rows names,

      + \ \ #generate some

      + \ \ if(is.null(rnames)) {

      + \ \ \ \ rnames \<less\>- as.character(1:table.dim[1])

      + \ \ }

      + \ \ means.frame$newrow \<less\>- rep(rnames,table.dim[2])

      +\ 

      + \ \ if(GinRows) {

      + \ \ \ \ #treatments are in rows

      + \ \ \ \ colnames(means.frame) \<less\>-
      c(response,TrialName,TreatmentName)

      + \ \ } else {

      + \ \ \ \ #trials in rows

      + \ \ \ \ colnames(means.frame) \<less\>-
      c(response,TreatmentName,TrialName)

      + \ \ }

      + \ \ #make sure treatment and trial are factors

      + \ \ means.frame[,c(TreatmentName,TrialName)] \<less\>-
      lapply(means.frame[,c(Treatme

      \<less\>tName,TrialName)] \<less\>-
      lapply(means.frame[,c(TreatmentName,TrialName)] , facto

      \<less\>y(means.frame[,c(TreatmentName,TrialName)] , factor)

      + \ \ return(means.frame)

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      table.dat \<less\>- gei.table.to.frame(t(txt.lsmeans.tbl), response =
      'Plot.Mean', TreatmentName='Treatment', TrialName='Trial')
    <|unfolded-io>
      table.dat \<less\>- gei.table.to.frame(t(txt.lsmeans.tbl), response =
      'Plot.Mean',

      \<less\>.frame(t(txt.lsmeans.tbl), response = 'Plot.Mean',
      TreatmentName='Treatment'

      \<less\> response = 'Plot.Mean', TreatmentName='Treatment',
      TrialName='Trial')

      Error in t(txt.lsmeans.tbl) : object 'txt.lsmeans.tbl' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      table.dat$a \<less\>- trt.effects[table.dat$Treatment]

      table.dat$b \<less\>- trial.effects[table.dat$Trial]
    <|unfolded-io>
      table.dat$a \<less\>- trt.effects[table.dat$Treatment]

      Error: object 'table.dat' not found

      \<gtr\> table.dat$b \<less\>- trial.effects[table.dat$Trial]

      Error: object 'table.dat' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tdf.st.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment + Trial:RepNo +
      a:b,data=st.dat)

      summary(tdf.st.lm)

      tdf.st.tbl \<less\>- anova(tdf.st.lm)

      tdf.st.tbl
    <|unfolded-io>
      tdf.st.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment + Trial:RepNo +
      a:b,data=st.d

      \<less\> ~ Trial + Treatment + Trial:RepNo + a:b,data=st.dat)

      \<gtr\> summary(tdf.st.lm)

      \;

      Call:

      lm(formula = Plot.Mean ~ Trial + Treatment + Trial:RepNo + a:b,\ 

      \ \ \ \ data = st.dat)

      \;

      Residuals:

      \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

      -0.37605 -0.12428 -0.01798 \ 0.11932 \ 0.43786\ 

      \;

      Coefficients:

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value
      Pr(\<gtr\>\|t\|) \ \ \ 

      (Intercept) \ \ \ 3.245e+00 \ 1.015e-01 \ 31.974 \ \<less\> 2e-16 ***

      TrialB \ \ \ \ \ \ \ -9.411e-01 \ 1.361e-01 \ -6.912 1.22e-09 ***

      TrialC \ \ \ \ \ \ \ -5.245e-02 \ 1.361e-01 \ -0.385 0.701107 \ \ \ 

      TrialD \ \ \ \ \ \ \ -7.573e-01 \ 1.361e-01 \ -5.563 3.69e-07 ***

      TrialE \ \ \ \ \ \ \ -4.590e-01 \ 1.361e-01 \ -3.371 0.001172 **\ 

      TrialF \ \ \ \ \ \ \ -2.723e-02 \ 1.361e-01 \ -0.200 0.842027 \ \ \ 

      TrialG \ \ \ \ \ \ \ -2.003e-01 \ 1.361e-01 \ -1.471 0.145247 \ \ \ 

      TrialH \ \ \ \ \ \ \ \ 1.762e-01 \ 1.361e-01 \ \ 1.294 0.199515 \ \ \ 

      TrialI \ \ \ \ \ \ \ -4.800e-01 \ 1.361e-01 \ -3.526 0.000715 ***

      Treatment2 \ \ \ -2.464e-01 \ 5.240e-02 \ -4.702 1.11e-05 ***

      Treatment3 \ \ \ \ 2.544e-02 \ 5.240e-02 \ \ 0.486 0.628700 \ \ \ 

      Treatment4 \ \ \ -5.834e-02 \ 5.240e-02 \ -1.113 0.268991 \ \ \ 

      TrialA:RepNo2 -2.216e-01 \ 1.361e-01 \ -1.628 0.107671 \ \ \ 

      TrialB:RepNo2 \ 1.214e-01 \ 1.361e-01 \ \ 0.892 0.375421 \ \ \ 

      TrialC:RepNo2 -1.821e-01 \ 1.361e-01 \ -1.337 0.185092 \ \ \ 

      TrialD:RepNo2 \ 2.832e-01 \ 1.361e-01 \ \ 2.080 0.040818 * \ 

      TrialE:RepNo2 \ 1.871e-01 \ 1.361e-01 \ \ 1.374 0.173392 \ \ \ 

      TrialF:RepNo2 \ 9.575e-02 \ 1.361e-01 \ \ 0.703 0.483984 \ \ \ 

      TrialG:RepNo2 -2.384e-01 \ 1.361e-01 \ -1.751 0.083845 . \ 

      TrialH:RepNo2 -8.525e-02 \ 1.361e-01 \ -0.626 0.533046 \ \ \ 

      TrialI:RepNo2 -3.204e-01 \ 1.361e-01 \ -2.353 0.021173 * \ 

      TrialA:RepNo3 -3.036e-01 \ 1.361e-01 \ -2.230 0.028684 * \ 

      TrialB:RepNo3 \ 6.885e-02 \ 1.361e-01 \ \ 0.506 0.614496 \ \ \ 

      TrialC:RepNo3 -3.895e-02 \ 1.361e-01 \ -0.286 0.775571 \ \ \ 

      TrialD:RepNo3 \ 1.162e-01 \ 1.361e-01 \ \ 0.853 0.396119 \ \ \ 

      TrialE:RepNo3 \ 2.063e-01 \ 1.361e-01 \ \ 1.515 0.133876 \ \ \ 

      TrialF:RepNo3 \ 2.375e-01 \ 1.361e-01 \ \ 1.745 0.085062 . \ 

      TrialG:RepNo3 -1.573e-01 \ 1.361e-01 \ -1.156 0.251420 \ \ \ 

      TrialH:RepNo3 -4.532e-17 \ 1.361e-01 \ \ 0.000 1.000000 \ \ \ 

      TrialI:RepNo3 -1.994e-01 \ 1.361e-01 \ -1.464 0.147188 \ \ \ 

      a:b \ \ \ \ \ \ \ \ \ \ \ 2.473e-01 \ 4.894e-01 \ \ 0.505 0.614745
      \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

      \;

      Residual standard error: 0.1925 on 77 degrees of freedom

      Multiple R-squared: \ 0.8278, \ \ \ Adjusted R-squared: \ 0.7607\ 

      F-statistic: 12.34 on 30 and 77 DF, \ p-value: \<less\> 2.2e-16

      \;

      \<gtr\> tdf.st.tbl \<less\>- anova(tdf.st.lm)

      \<gtr\> tdf.st.tbl

      Analysis of Variance Table

      \;

      Response: Plot.Mean

      \ \ \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value \ \ \ Pr(\<gtr\>F)
      \ \ \ 

      Trial \ \ \ \ \ \ \ 8 11.4635 1.43294 38.6558 \<less\> 2.2e-16 ***

      Treatment \ \ \ 3 \ 1.2217 0.40725 10.9862 4.392e-06 ***

      Trial:RepNo 18 \ 1.0270 0.05706 \ 1.5392 \ \ 0.09946 . \ 

      a:b \ \ \ \ \ \ \ \ \ 1 \ 0.0095 0.00947 \ 0.2554 \ \ 0.61475 \ \ \ 

      Residuals \ \ 77 \ 2.8543 0.03707 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tdf.tbl.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment +
      a:b,data=table.dat)

      summary(tdf.tbl.lm)

      tdf.tbl \<less\>-anova(tdf.tbl.lm)

      tdf.tbl
    <|unfolded-io>
      tdf.tbl.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment +
      a:b,data=table.dat)

      Error in is.data.frame(data) : object 'table.dat' not found

      \<gtr\> summary(tdf.tbl.lm)

      Error in summary(tdf.tbl.lm) : object 'tdf.tbl.lm' not found

      \<gtr\> tdf.tbl \<less\>-anova(tdf.tbl.lm)

      Error in anova(tdf.tbl.lm) : object 'tdf.tbl.lm' not found

      \<gtr\> tdf.tbl

      Error: object 'tdf.tbl' not found
    </unfolded-io>

    <\textput>
      \ output must match

      <verbatim|Treatment \ \ \ \ \ \ \ \ 15 \ \ 197.08641 \ \ \ 13.13909
      \ \ \ 14.79081 \ \ \ 6.94977e-37>

      <verbatim|Trial \ \ \ \ \ \ \ \ \ \ \ \ 35 \ 9770.23986 \ \ 279.14971
      \ \ 314.24175 \ \ \ \ 0>

      <verbatim|eTreatment:eTrial \ 1 \ \ \ 70.17963 \ \ \ 70.17963
      \ \ \ 64.19469 \ \ \ 7.32747e-15>

      <verbatim|Residuals \ \ \ \ \ \ \ 524 \ \ 572.85308 \ \ \ \ 1.09323
      \ \ \ \ 1.60248 \ \ \ 2.66642e-12>

      <verbatim|Error \ \ \ \ \ \ \ \ \ \ 1620 \ 1105.18123 \ \ \ \ 0.68221
      \ \ \ NA \ \ \ \ \ \ \ \ NA>
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tmp \<less\>- tdf.st.tbl[2,]

      tdf.st.tbl[2,] \<less\>- tdf.st.tbl[1,]

      tdf.st.tbl[1,] \<less\>- tmp

      tdf.st.tbl[3,] \<less\>- tdf.st.tbl[4,]
    <|unfolded-io>
      tmp \<less\>- tdf.st.tbl[2,]

      \<gtr\> tdf.st.tbl[2,] \<less\>- tdf.st.tbl[1,]

      \<gtr\> tdf.st.tbl[1,] \<less\>- tmp

      \<gtr\> tdf.st.tbl[3,] \<less\>- tdf.st.tbl[4,]
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tdf.st.tbl[5,] \<less\>- aov.tbl[5,]

      tdf.st.tbl[4,] \<less\>- aov.tbl[4,] - tdf.st.tbl[3,]

      tdf.st.tbl[4,3] \<less\>- tdf.st.tbl[4,2]/tdf.st.tbl[4,1]

      Fval \<less\>- tdf.st.tbl[3,3]/tdf.st.tbl[4,3]

      tdf.st.tbl[3,4] \<less\>- Fval

      tdf.st.tbl[3,5] \<less\>- 1 - pf(Fval, tdf.st.tbl[3,1],
      tdf.st.tbl[4,1])

      Fval \<less\>- tdf.st.tbl[4,3]/tdf.st.tbl[5,3]

      tdf.st.tbl[4,4] \<less\>- Fval

      tdf.st.tbl[4,5] \<less\>- 1 - pf(Fval, tdf.st.tbl[4,1],
      tdf.st.tbl[5,1])

      rownames(tdf.st.tbl) \<less\>- c('Treatment','Trial','eTreatment:eTrial','Residuals','Error')
    <|unfolded-io>
      tdf.st.tbl[5,] \<less\>- aov.tbl[5,]

      \<gtr\> tdf.st.tbl[4,] \<less\>- aov.tbl[4,] - tdf.st.tbl[3,]

      \<gtr\> tdf.st.tbl[4,3] \<less\>- tdf.st.tbl[4,2]/tdf.st.tbl[4,1]

      \<gtr\> Fval \<less\>- tdf.st.tbl[3,3]/tdf.st.tbl[4,3]

      \<gtr\> tdf.st.tbl[3,4] \<less\>- Fval

      \<gtr\> tdf.st.tbl[3,5] \<less\>- 1 - pf(Fval, tdf.st.tbl[3,1],
      tdf.st.tbl[4,1])

      \<gtr\> Fval \<less\>- tdf.st.tbl[4,3]/tdf.st.tbl[5,3]

      \<gtr\> tdf.st.tbl[4,4] \<less\>- Fval

      \<gtr\> tdf.st.tbl[4,5] \<less\>- 1 - pf(Fval, tdf.st.tbl[4,1],
      tdf.st.tbl[5,1])

      \<gtr\> rownames(tdf.st.tbl) \<less\>-
      c('Treatment','Trial','eTreatment:eTrial','Residual

      \<less\>('Treatment','Trial','eTreatment:eTrial','Residuals','Error')
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tdf.st.tbl
    <|unfolded-io>
      tdf.st.tbl

      Analysis of Variance Table

      \;

      Response: Plot.Mean

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value
      \ \ \ Pr(\<gtr\>F) \ \ \ 

      Treatment \ \ \ \ \ \ \ \ \ 3 \ 1.2217 0.40725 10.9862 4.392e-06 ***

      Trial \ \ \ \ \ \ \ \ \ \ \ \ \ 8 11.4635 1.43294 38.6558 \<less\>
      2.2e-16 ***

      eTreatment:eTrial \ 1 \ 0.0095 0.00947 \ 0.2554 \ \ \ 0.6147 \ \ \ 

      Residuals \ \ \ \ \ \ \ \ 77 \ 2.8543 0.03707 \ 0.0910 \ \ \ 1.0000
      \ \ \ 

      Error \ \ \ \ \ \ \ \ \ \ \ \ \ 3 \ 1.2217 0.40725
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      het.st.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment + Trial:RepNo +
      Treatment:b,data=st.dat)

      summary(het.st.lm)

      anova(het.st.lm)
    <|unfolded-io>
      het.st.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment + Trial:RepNo +
      Treatment:b,d

      \<less\> ~ Trial + Treatment + Trial:RepNo + Treatment:b,data=st.dat)

      \<gtr\> summary(het.st.lm)

      \;

      Call:

      lm(formula = Plot.Mean ~ Trial + Treatment + Trial:RepNo + Treatment:b,\ 

      \ \ \ \ data = st.dat)

      \;

      Residuals:

      \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

      -0.33457 -0.12065 -0.02561 \ 0.12390 \ 0.40986\ 

      \;

      Coefficients: (1 not defined because of singularities)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value
      Pr(\<gtr\>\|t\|) \ \ \ 

      (Intercept) \ \ \ 3.207e+00 \ 1.049e-01 \ 30.573 \ \<less\> 2e-16 ***

      TrialB \ \ \ \ \ \ \ -8.252e-01 \ 1.601e-01 \ -5.155 1.99e-06 ***

      TrialC \ \ \ \ \ \ \ -4.599e-02 \ 1.359e-01 \ -0.338 \ 0.73606 \ \ \ 

      TrialD \ \ \ \ \ \ \ -6.641e-01 \ 1.520e-01 \ -4.370 3.94e-05 ***

      TrialE \ \ \ \ \ \ \ -4.024e-01 \ 1.420e-01 \ -2.834 \ 0.00590 **\ 

      TrialF \ \ \ \ \ \ \ -2.387e-02 \ 1.359e-01 \ -0.176 \ 0.86101 \ \ \ 

      TrialG \ \ \ \ \ \ \ -1.756e-01 \ 1.370e-01 \ -1.282 \ 0.20387 \ \ \ 

      TrialH \ \ \ \ \ \ \ \ 1.545e-01 \ 1.368e-01 \ \ 1.129 \ 0.26230 \ \ \ 

      TrialI \ \ \ \ \ \ \ -4.209e-01 \ 1.425e-01 \ -2.953 \ 0.00421 **\ 

      Treatment2 \ \ \ -2.464e-01 \ 5.229e-02 \ -4.712 1.11e-05 ***

      Treatment3 \ \ \ \ 2.544e-02 \ 5.229e-02 \ \ 0.487 \ 0.62799 \ \ \ 

      Treatment4 \ \ \ -5.834e-02 \ 5.229e-02 \ -1.116 \ 0.26805 \ \ \ 

      TrialA:RepNo2 -2.216e-01 \ 1.358e-01 \ -1.631 \ 0.10703 \ \ \ 

      TrialB:RepNo2 \ 1.214e-01 \ 1.358e-01 \ \ 0.893 \ 0.37446 \ \ \ 

      TrialC:RepNo2 -1.821e-01 \ 1.358e-01 \ -1.340 \ 0.18425 \ \ \ 

      TrialD:RepNo2 \ 2.832e-01 \ 1.358e-01 \ \ 2.085 \ 0.04048 * \ 

      TrialE:RepNo2 \ 1.871e-01 \ 1.358e-01 \ \ 1.377 \ 0.17257 \ \ \ 

      TrialF:RepNo2 \ 9.575e-02 \ 1.358e-01 \ \ 0.705 \ 0.48309 \ \ \ 

      TrialG:RepNo2 -2.384e-01 \ 1.358e-01 \ -1.755 \ 0.08329 . \ 

      TrialH:RepNo2 -8.525e-02 \ 1.358e-01 \ -0.628 \ 0.53221 \ \ \ 

      TrialI:RepNo2 -3.204e-01 \ 1.358e-01 \ -2.358 \ 0.02097 * \ 

      TrialA:RepNo3 -3.036e-01 \ 1.358e-01 \ -2.235 \ 0.02843 * \ 

      TrialB:RepNo3 \ 6.885e-02 \ 1.358e-01 \ \ 0.507 \ 0.61377 \ \ \ 

      TrialC:RepNo3 -3.895e-02 \ 1.358e-01 \ -0.287 \ 0.77512 \ \ \ 

      TrialD:RepNo3 \ 1.162e-01 \ 1.358e-01 \ \ 0.855 \ 0.39517 \ \ \ 

      TrialE:RepNo3 \ 2.063e-01 \ 1.358e-01 \ \ 1.518 \ 0.13315 \ \ \ 

      TrialF:RepNo3 \ 2.375e-01 \ 1.358e-01 \ \ 1.748 \ 0.08450 . \ 

      TrialG:RepNo3 -1.573e-01 \ 1.358e-01 \ -1.158 \ 0.25049 \ \ \ 

      TrialH:RepNo3 -4.898e-17 \ 1.358e-01 \ \ 0.000 \ 1.00000 \ \ \ 

      TrialI:RepNo3 -1.994e-01 \ 1.358e-01 \ -1.467 \ 0.14643 \ \ \ 

      Treatment1:b \ \ 2.321e-01 \ 1.469e-01 \ \ 1.580 \ 0.11840 \ \ \ 

      Treatment2:b \ \ 1.098e-01 \ 1.469e-01 \ \ 0.747 \ 0.45725 \ \ \ 

      Treatment3:b \ \ 1.509e-01 \ 1.469e-01 \ \ 1.027 \ 0.30776 \ \ \ 

      Treatment4:b \ \ \ \ \ \ \ \ \ NA \ \ \ \ \ \ \ \ NA \ \ \ \ \ NA
      \ \ \ \ \ \ NA \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

      \;

      Residual standard error: 0.1921 on 75 degrees of freedom

      Multiple R-squared: \ 0.833, \ \ \ \ Adjusted R-squared: \ 0.7618\ 

      F-statistic: 11.69 on 32 and 75 DF, \ p-value: \<less\> 2.2e-16

      \;

      \<gtr\> anova(het.st.lm)

      Analysis of Variance Table

      \;

      Response: Plot.Mean

      \ \ \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value \ \ \ Pr(\<gtr\>F)
      \ \ \ 

      Trial \ \ \ \ \ \ \ 8 11.4635 1.43294 38.8244 \<less\> 2.2e-16 ***

      Treatment \ \ \ 3 \ 1.2217 0.40725 11.0341 4.416e-06 ***

      Trial:RepNo 18 \ 1.0270 0.05706 \ 1.5459 \ \ 0.09809 . \ 

      Treatment:b \ 3 \ 0.0957 0.03189 \ 0.8641 \ \ 0.46360 \ \ \ 

      Residuals \ \ 75 \ 2.7681 0.03691 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      het.tbl.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment +
      Treatment:b,data=st.dat)

      summary(het.tbl.lm)

      anova(het.tbl.lm)
    <|unfolded-io>
      het.tbl.lm \<less\>- lm(Plot.Mean ~ Trial + Treatment +
      Treatment:b,data=st.dat)

      \<gtr\> summary(het.tbl.lm)

      \;

      Call:

      lm(formula = Plot.Mean ~ Trial + Treatment + Treatment:b, data =
      st.dat)

      \;

      Residuals:

      \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

      -0.41386 -0.12809 -0.01119 \ 0.11391 \ 0.58309\ 

      \;

      Coefficients: (1 not defined because of singularities)

      \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|)
      \ \ \ 

      (Intercept) \ \ 3.03197 \ \ \ 0.07324 \ 41.397 \ \<less\> 2e-16 ***

      TrialB \ \ \ \ \ \ -0.58670 \ \ \ 0.12135 \ -4.835 5.26e-06 ***

      TrialC \ \ \ \ \ \ \ 0.05539 \ \ \ 0.08262 \ \ 0.670 0.504217 \ \ \ 

      TrialD \ \ \ \ \ \ -0.35588 \ \ \ 0.10924 \ -3.258 0.001569 **\ 

      TrialE \ \ \ \ \ \ -0.09628 \ \ \ 0.09320 \ -1.033 0.304266 \ \ \ 

      TrialF \ \ \ \ \ \ \ 0.26226 \ \ \ 0.08251 \ \ 3.179 0.002010 **\ 

      TrialG \ \ \ \ \ \ -0.13252 \ \ \ 0.08462 \ -1.566 0.120717 \ \ \ 

      TrialH \ \ \ \ \ \ \ 0.30111 \ \ \ 0.08414 \ \ 3.579 0.000551 ***

      TrialI \ \ \ \ \ \ -0.41906 \ \ \ 0.09414 \ -4.451 2.37e-05 ***

      Treatment2 \ \ -0.24637 \ \ \ 0.05498 \ -4.481 2.11e-05 ***

      Treatment3 \ \ \ 0.02544 \ \ \ 0.05498 \ \ 0.463 0.644641 \ \ \ 

      Treatment4 \ \ -0.05834 \ \ \ 0.05498 \ -1.061 0.291350 \ \ \ 

      Treatment1:b \ 0.23207 \ \ \ 0.15448 \ \ 1.502 0.136422 \ \ \ 

      Treatment2:b \ 0.10978 \ \ \ 0.15448 \ \ 0.711 0.479081 \ \ \ 

      Treatment3:b \ 0.15087 \ \ \ 0.15448 \ \ 0.977 0.331295 \ \ \ 

      Treatment4:b \ \ \ \ \ \ NA \ \ \ \ \ \ \ \ NA \ \ \ \ \ NA
      \ \ \ \ \ \ NA \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

      \;

      Residual standard error: 0.202 on 93 degrees of freedom

      Multiple R-squared: \ 0.771, \ \ \ \ Adjusted R-squared: \ 0.7366\ 

      F-statistic: 22.37 on 14 and 93 DF, \ p-value: \<less\> 2.2e-16

      \;

      \<gtr\> anova(het.tbl.lm)

      Analysis of Variance Table

      \;

      Response: Plot.Mean

      \ \ \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value \ \ \ Pr(\<gtr\>F)
      \ \ \ 

      Trial \ \ \ \ \ \ \ 8 11.4635 1.43294 35.1144 \<less\> 2.2e-16 ***

      Treatment \ \ \ 3 \ 1.2217 0.40725 \ 9.9797 9.128e-06 ***

      Treatment:b \ 3 \ 0.0957 0.03189 \ 0.7815 \ \ \ 0.5072 \ \ \ 

      Residuals \ \ 93 \ 3.7951 0.04081 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      het0.tbl.lm \<less\>- lm(Plot.Mean ~ 0+Treatment +
      Treatment:b,data=table.dat)

      summary(het0.tbl.lm)

      anova(het0.tbl.lm)
    <|unfolded-io>
      het0.tbl.lm \<less\>- lm(Plot.Mean ~ 0+Treatment +
      Treatment:b,data=table.dat)

      Error in is.data.frame(data) : object 'table.dat' not found

      \<gtr\> summary(het0.tbl.lm)

      Error in summary(het0.tbl.lm) : object 'het0.tbl.lm' not found

      \<gtr\> anova(het0.tbl.lm)

      Error in anova(het0.tbl.lm) : object 'het0.tbl.lm' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      het.st.tbl \<less\>- anova(het.st.lm)
    <|unfolded-io>
      het.st.tbl \<less\>- anova(het.st.lm)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tmp \<less\>- het.st.tbl[2,]

      het.st.tbl[2,] \<less\>- het.st.tbl[1,]

      het.st.tbl[1,] \<less\>- tmp

      het.st.tbl[3,] \<less\>- het.st.tbl[4,]

      het.st.tbl[5,] \<less\>- aov.tbl[5,]

      het.st.tbl[4,] \<less\>- aov.tbl[4,]-het.st.tbl[3,]

      het.st.tbl[4,3] \<less\>- het.st.tbl[4,2]/het.st.tbl[4,1]

      Fval \<less\>- het.st.tbl[3,3]/het.st.tbl[4,3]

      het.st.tbl[3,4] \<less\>- Fval

      het.st.tbl[3,5] \<less\>- 1 - pf(Fval, het.st.tbl[3,1],
      het.st.tbl[4,1])

      \;

      Fval \<less\>- het.st.tbl[4,3]/het.st.tbl[5,3]

      het.st.tbl[4,4] \<less\>- Fval

      het.st.tbl[4,5] \<less\>- 1 - pf(Fval, het.st.tbl[4,1],
      het.st.tbl[5,1])

      \;

      rownames(het.st.tbl) \<less\>- c('Treatment','Trial','Treatment:eTrial','Residuals','Error')
    <|unfolded-io>
      tmp \<less\>- het.st.tbl[2,]

      \<gtr\> het.st.tbl[2,] \<less\>- het.st.tbl[1,]

      \<gtr\> het.st.tbl[1,] \<less\>- tmp

      \<gtr\> het.st.tbl[3,] \<less\>- het.st.tbl[4,]

      \<gtr\> het.st.tbl[5,] \<less\>- aov.tbl[5,]

      \<gtr\> het.st.tbl[4,] \<less\>- aov.tbl[4,]-het.st.tbl[3,]

      \<gtr\> het.st.tbl[4,3] \<less\>- het.st.tbl[4,2]/het.st.tbl[4,1]

      \<gtr\> Fval \<less\>- het.st.tbl[3,3]/het.st.tbl[4,3]

      \<gtr\> het.st.tbl[3,4] \<less\>- Fval

      \<gtr\> het.st.tbl[3,5] \<less\>- 1 - pf(Fval, het.st.tbl[3,1],
      het.st.tbl[4,1])

      \<gtr\>\ 

      \<gtr\> Fval \<less\>- het.st.tbl[4,3]/het.st.tbl[5,3]

      \<gtr\> het.st.tbl[4,4] \<less\>- Fval

      \<gtr\> het.st.tbl[4,5] \<less\>- 1 - pf(Fval, het.st.tbl[4,1],
      het.st.tbl[5,1])

      \<gtr\>\ 

      \<gtr\> rownames(het.st.tbl) \<less\>-
      c('Treatment','Trial','Treatment:eTrial','Residuals

      \<less\>('Treatment','Trial','Treatment:eTrial','Residuals','Error')
    </unfolded-io>

    \;

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      extract.slopes \<less\>- function(het0.tbl,df) {

      \ \ rows \<less\>- dim(het0.tbl)[1]

      \ \ trts \<less\>- rows/2

      \ \ ret.tbl \<less\>- het0.tbl[(trts+1):rows,]

      \ \ ret.tbl[,3] \<less\>- (ret.tbl[,1]-1)/ret.tbl[,2]

      \ \ ret.tbl[,4] \<less\>- pt(abs(ret.tbl[,3]),df,lower.tail=FALSE)

      \ \ return (ret.tbl)

      }
    <|unfolded-io>
      extract.slopes \<less\>- function(het0.tbl,df) {

      + \ \ rows \<less\>- dim(het0.tbl)[1]

      + \ \ trts \<less\>- rows/2

      + \ \ ret.tbl \<less\>- het0.tbl[(trts+1):rows,]

      + \ \ ret.tbl[,3] \<less\>- (ret.tbl[,1]-1)/ret.tbl[,2]

      + \ \ ret.tbl[,4] \<less\>- pt(abs(ret.tbl[,3]),df,lower.tail=FALSE)

      + \ \ return (ret.tbl)

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      het0.tbl \<less\>- summary(het0.tbl.lm)$coefficients

      het0.tbl

      extract.slopes(het0.tbl,het.st.tbl[(dim(het.st.tbl)[1]-1),1])
    <|unfolded-io>
      het0.tbl \<less\>- summary(het0.tbl.lm)$coefficients

      Error in summary(het0.tbl.lm) : object 'het0.tbl.lm' not found

      \<gtr\> het0.tbl

      Error: object 'het0.tbl' not found

      \<gtr\> extract.slopes(het0.tbl,het.st.tbl[(dim(het.st.tbl)[1]-1),1])

      Error in extract.slopes(het0.tbl, het.st.tbl[(dim(het.st.tbl)[1] - 1),
      \ :\ 

      \ \ object 'het0.tbl' not found
    </unfolded-io>

    <\textput>
      <section|Plotting Results>

      At this point, we have a table of treatment by trial means and a vector
      of trial means.\ 
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      txt.lsmeans.tbl
    <|unfolded-io>
      txt.lsmeans.tbl

      Error: object 'txt.lsmeans.tbl' not found
    </unfolded-io>

    \;

    <\textput>
      We assume, then, that treatments are in columns. The first part of our
      graph is to plot treatment means in trials against trial means. We
      might assume an independent trial mean vector
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      trial.means
    <|unfolded-io>
      trial.means

      Error: object 'trial.means' not found
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      treaments \<less\>- dim(txt.lsmeans.tbl)[2]
    <|unfolded-io>
      treaments \<less\>- dim(txt.lsmeans.tbl)[2]

      Error: object 'txt.lsmeans.tbl' not found
    </unfolded-io>

    <\textput>
      Plot each column. We call plot with the first to establish the plot,
      then points to add additional columns.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      plot(trial.means,txt.lsmeans.tbl[,1])

      for(i in 2:treatments) {

      \ \ points(trial.means,txt.lsmeans.tbl[,i])

      }

      v()
    <|unfolded-io>
      plot(trial.means,txt.lsmeans.tbl[,1])

      Error in plot(trial.means, txt.lsmeans.tbl[, 1]) :\ 

      \ \ object 'trial.means' not found

      \<gtr\> for(i in 2:treatments) {

      + \ \ points(trial.means,txt.lsmeans.tbl[,i])

      + }

      Error in points(trial.means, txt.lsmeans.tbl[, i]) :\ 

      \ \ object 'trial.means' not found

      \<gtr\> v()

      Error in dev.copy2eps(file = op$file, print.it = F, width = width,
      height = height, \ :\ 

      \ \ no device to print from
    </unfolded-io>

    <\textput>
      Clearly, we can't distinguish treatments, so we use points
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      trt.pch = 1:treatments

      #pch 26:31 are unused, so add six if larger

      if(treatments\<gtr\>25) {

      \ \ trt.pch[trt.pch\<gtr\>25] \<less\>- trt.pch[trt.pch\<gtr\>25] + 7

      }

      plot(trial.means,txt.lsmeans.tbl[,1],pch=trt.pch[1])

      for(i in 2:treatments) {

      \ \ points(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i])

      }

      v()
    <|unfolded-io>
      trt.pch = 1:treatments

      \<gtr\> #pch 26:31 are unused, so add six if larger

      \<gtr\> if(treatments\<gtr\>25) {

      + \ \ trt.pch[trt.pch\<gtr\>25] \<less\>- trt.pch[trt.pch\<gtr\>25] + 7

      + }

      \<gtr\> plot(trial.means,txt.lsmeans.tbl[,1],pch=trt.pch[1])

      Error in plot(trial.means, txt.lsmeans.tbl[, 1], pch = trt.pch[1]) :\ 

      \ \ object 'trial.means' not found

      \<gtr\> for(i in 2:treatments) {

      + \ \ points(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i])

      + }

      Error in points(trial.means, txt.lsmeans.tbl[, i], pch = trt.pch[i]) :\ 

      \ \ object 'trial.means' not found

      \<gtr\> v()

      Error in dev.copy2eps(file = op$file, print.it = F, width = width,
      height = height, \ :\ 

      \ \ no device to print from
    </unfolded-io>

    <\textput>
      Add a regression line. This is a fit only the current treatment and
      trial mean. We'll add an if statement inside the loop - it's less
      efficient but will make it easier to add plotting options for the first
      treatment.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      for(i in 1:treatments) {

      \ \ if(i==1) {

      \ \ \ \ plot(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i])

      \ \ } else {

      \ \ \ \ points(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i])

      \ \ }

      \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ abline(trt.coef[1],trt.coef[2])

      }

      v()
    <|unfolded-io>
      for(i in 1:treatments) {

      + \ \ if(i==1) {

      + \ \ \ \ plot(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i])

      + \ \ } else {

      + \ \ \ \ points(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i])

      + \ \ }

      + \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      + \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ abline(trt.coef[1],trt.coef[2])

      + }

      Error in plot(trial.means, txt.lsmeans.tbl[, i], pch = trt.pch[i]) :\ 

      \ \ object 'trial.means' not found

      \<gtr\> v()

      Error in dev.copy2eps(file = op$file, print.it = F, width = width,
      height = height, \ :\ 

      \ \ no device to print from
    </unfolded-io>

    <\textput>
      We can't distinquish lines, and it might be good to add color. For
      color, in this case we'll start with a set of color-blind friendly
      colors, then add from a standard set if there are more colors needed.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      trt.colors \<less\>- c("#999999", "#E69F00", "#56B4E9", "#009E73",
      "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

      if(length(trt.colors)\<less\>treatments) {

      \ \ trt.colors \<less\>- c(trt.colors,rainbow(treatments-length(trt.colors)))

      }

      for(i in 1:treatments) {

      \ \ if(i==1) {

      \ \ \ plot.fn \<less\>- plot

      \ \ } else {

      \ \ \ \ plot.fn \<less\>- points

      \ \ }

      plot.fn(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i],lty=i,col=trt.colors[i])

      \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      }

      v()
    <|unfolded-io>
      trt.colors \<less\>- c("#999999", "#E69F00", "#56B4E9", "#009E73",
      "#F0E442", "#00

      \<less\>, "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2",
      "#D55E00", "#CC79A7

      \<less\>009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

      \<gtr\> if(length(trt.colors)\<less\>treatments) {

      + \ \ trt.colors \<less\>- c(trt.colors,rainbow(treatments-length(trt.colors)))

      + }

      \<gtr\> for(i in 1:treatments) {

      + \ \ if(i==1) {

      + \ \ \ plot.fn \<less\>- plot

      + \ \ } else {

      + \ \ \ \ plot.fn \<less\>- points

      + \ \ }

      + plot.fn(trial.means,txt.lsmeans.tbl[,i],pch=trt.pch[i],lty=i,col=trt.colors

      \<less\>smeans.tbl[,i],pch=trt.pch[i],lty=i,col=trt.colors[i])

      + \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      + \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      + }

      Error in plot.fn(trial.means, txt.lsmeans.tbl[, i], pch = trt.pch[i],
      \ :\ 

      \ \ object 'trial.means' not found

      \<gtr\> v()

      Error in dev.copy2eps(file = op$file, print.it = F, width = width,
      height = height, \ :\ 

      \ \ no device to print from
    </unfolded-io>

    <\textput>
      We've lost some points on the lower portion of the plot. We'll
      calculate minimum and maximum <math|y> values so that everything fits.
      We'll also compute <math|x> extrema for later use.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      min.y \<less\>- min(txt.lsmeans.tbl,na.rm=TRUE)

      max.y \<less\>- max(txt.lsmeans.tbl,na.rm=TRUE)

      min.x \<less\>- min(trial.means,na.rm=TRUE)

      max.x \<less\>- max(trial.means,na.rm=TRUE)

      for(i in 1:treatments) {

      \ \ if(i==1) {

      \ \ \ plot.fn \<less\>- plot

      \ \ \ #plot legend

      \ \ } else {

      \ \ \ \ plot.fn \<less\>- points

      \ \ }

      \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y))

      \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      }

      v()
    <|unfolded-io>
      min.y \<less\>- min(txt.lsmeans.tbl,na.rm=TRUE)

      Error: object 'txt.lsmeans.tbl' not found

      \<gtr\> max.y \<less\>- max(txt.lsmeans.tbl,na.rm=TRUE)

      Error: object 'txt.lsmeans.tbl' not found

      \<gtr\> min.x \<less\>- min(trial.means,na.rm=TRUE)

      Error: object 'trial.means' not found

      \<gtr\> max.x \<less\>- max(trial.means,na.rm=TRUE)

      Error: object 'trial.means' not found

      \<gtr\> for(i in 1:treatments) {

      + \ \ if(i==1) {

      + \ \ \ plot.fn \<less\>- plot

      + \ \ \ #plot legend

      + \ \ } else {

      + \ \ \ \ plot.fn \<less\>- points

      + \ \ }

      + \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      + \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y))

      + \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      + \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      + }

      Error in plot.fn(x = trial.means, y = txt.lsmeans.tbl[, i], pch =
      trt.pch[i], \ :\ 

      \ \ object 'trial.means' not found

      \<gtr\> v()

      Error in dev.copy2eps(file = op$file, print.it = F, width = width,
      height = height, \ :\ 

      \ \ no device to print from
    </unfolded-io>

    <\textput>
      We'll want a legend. I prefer to have it in the frame with the lines;
      this gives us more space for the plot. In most cases, we have lines
      from lower left to upper right, so we can use the upper left corner for
      the legend. However, we want the legend in the background, so we plot
      it in our if clause.

      \;

      I paste a space after treatment number to make the legend look better.

      \;

      I've added a legend title, and removed to border to make it look
      cleaner. We can also define the number of columns.

      \;
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      legend.pos \<less\>- c(.01,.99)

      legend.labels \<less\>- paste(as.character(1:treatments)," ")

      legend.title \<less\>- "Trt. No."

      legend.columns \<less\>- 4

      for(i in 1:treatments) {

      \ \ if(i==1) {

      \ \ \ plot.fn \<less\>- plot

      \ \ \ #plot legend

      \ \ } else {

      \ \ \ \ plot.fn \<less\>- points

      \ \ }

      \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y))

      \ \ if(i==1) {

      \ \ \ \ #plot legend

      \ \ \ \ legend((min.x+(legend.pos[1]*(max.x-min.x))),\ 

      \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.pos[2]*(max.y-min.y))),\ 

      \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      \ \ \ \ \ \ \ \ \ \ \ title=legend.title,

      \ \ \ \ \ \ \ \ \ \ \ bty="n",

      \ \ \ \ \ \ \ \ \ \ \ ncol=legend.columns,

      \ \ \ \ \ \ \ \ \ \ \ col = trt.colors)

      \ \ }

      \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      }

      v()
    <|unfolded-io>
      legend.pos \<less\>- c(.01,.99)

      \<gtr\> legend.labels \<less\>- paste(as.character(1:treatments)," ")

      \<gtr\> legend.title \<less\>- "Trt. No."

      \<gtr\> legend.columns \<less\>- 4

      \<gtr\> for(i in 1:treatments) {

      + \ \ if(i==1) {

      + \ \ \ plot.fn \<less\>- plot

      + \ \ \ #plot legend

      + \ \ } else {

      + \ \ \ \ plot.fn \<less\>- points

      + \ \ }

      + \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      + \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y))

      + \ \ if(i==1) {

      + \ \ \ \ #plot legend

      + \ \ \ \ legend((min.x+(legend.pos[1]*(max.x-min.x))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.pos[2]*(max.y-min.y))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      + \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      + \ \ \ \ \ \ \ \ \ \ \ title=legend.title,

      + \ \ \ \ \ \ \ \ \ \ \ bty="n",

      + \ \ \ \ \ \ \ \ \ \ \ ncol=legend.columns,

      + \ \ \ \ \ \ \ \ \ \ \ col = trt.colors)

      + \ \ }

      + \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      + \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      + }

      Error in plot.fn(x = trial.means, y = txt.lsmeans.tbl[, i], pch =
      trt.pch[i], \ :\ 

      \ \ object 'trial.means' not found

      \<gtr\> v()

      Error in dev.copy2eps(file = op$file, print.it = F, width = width,
      height = height, \ :\ 

      \ \ no device to print from
    </unfolded-io>

    <\textput>
      Asthetics. We can control relative font sizes most easily by setting
      parameters. This will help us later when we combine with dendrograms.

      \;

      We also define constants for main and axes labels.

      \;
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      cex.lab = 0.8\ 

      cex.main = 0.9

      cex.axis = 0.6

      par(ps = 14, cex.lab = cex.lab, cex.main = cex.main, cex.axis =
      cex.axis)

      main="Treatment by Trial Interaction"

      xlab="Trial Mean"

      ylab="Treatment in Trial Mean"

      \ \ \ \ for(i in 1:treatments) {

      \ \ if(i==1) {

      \ \ \ plot.fn \<less\>- plot

      \ \ \ #plot legend

      \ \ } else {

      \ \ \ \ plot.fn \<less\>- points

      \ \ }

      \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y),

      \ \ \ \ \ \ \ \ \ \ xlab="",ylab="")

      \ \ if(i==1) {

      \ \ \ \ #plot legend

      \ \ \ \ legend((min.x+(legend.pos[1]*(max.x-min.x))),\ 

      \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.pos[2]*(max.y-min.y))),\ 

      \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      \ \ \ \ \ \ \ \ \ \ \ title=legend.title,

      \ \ \ \ \ \ \ \ \ \ \ col=trt.colors,

      \ \ \ \ \ \ \ \ \ \ \ bty="n",

      \ \ \ \ \ \ \ \ \ \ \ ncol=legend.columns,

      \ \ \ \ \ \ \ \ \ \ \ cex=cex.axis)

      \ \ }

      \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      }

      title(main=main,xlab=xlab,ylab=ylab);v()
    <|unfolded-io>
      cex.lab = 0.8\ 

      \<gtr\> cex.main = 0.9

      \<gtr\> cex.axis = 0.6

      \<gtr\> par(ps = 14, cex.lab = cex.lab, cex.main = cex.main, cex.axis =
      cex.axis)

      \<gtr\> main="Treatment by Trial Interaction"

      \<gtr\> xlab="Trial Mean"

      \<gtr\> ylab="Treatment in Trial Mean"
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      \ plot.interaction.ARMST \<less\>- function(means.matrix,\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ means.vector,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylab="",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlab="",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ main="",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ regression=TRUE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ show.legend=FALSE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.colors=c(),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.labels=NA,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.labels=c(),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.columns=1,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ style.legend=1,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.main="",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.axis="",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.legend="",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.axis="black",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.lab="black",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.main="black",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.sub="black",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fg="black",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bg="white",

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ left.las=0,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ min.y=NA,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ max.y=NA,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylog=FALSE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlog=FALSE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.pos=c(.90,.55),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lwd
      = 3,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cex=1.0,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight=c(),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hcex=1.5,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fixed.prop=FALSE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ poly=1,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mark.int
      = c(),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ plot.unity=FALSE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight.point=TRUE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ tukey.coeffs=c(),

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ inverse.regression=FALSE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pc.regression=FALSE,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ segments=FALSE)
      {

      \ \ legend.x = legend.pos[1]

      \ \ legend.y = legend.pos[2]

      \ \ 

      \ \ # use this to force means table to use numeric names. This assumes

      \ \ # means are in correct numeric order (Jun 9 15, PMC)

      \ \ colnames(means.matrix) \<less\>-
      as.character(1:dim(means.matrix)[2])

      \ \ rownames(means.matrix) \<less\>-
      as.character(1:dim(means.matrix)[1])

      \ \ names(means.vector) \<less\>- as.character(1:dim(means.matrix)[1])

      \ \ 

      \ \ means.table \<less\>- data.frame(stack(means.matrix))

      \ 

      \ \ means.table$TrtNo \<less\>- as.numeric(as.character(means.table$ind))

      \ \ 

      \ \ trts \<less\>- dim(means.matrix)[2]

      \ \ trials \<less\>- dim(means.matrix)[1]

      \ \ trt.levels \<less\>- levels(means.table$ind)

      \ \ 

      \ \ #we'll return a data table with one row for each treatment.

      \ \ #this table will include the slope, intercept and other stats to be
      added

      \ \ ret.fit \<less\>- data.frame(

      \ \ \ \ Treatment = 1:trts,

      \ \ \ \ Slope = rep(NA,trts),

      \ \ \ \ Intercept = rep(NA,trts),

      \ \ \ \ R2 = rep(NA,trts),

      \ \ \ \ AdjR2 = rep(NA,trts),

      \ \ \ \ Mean = rep(NA,trts),

      \ \ \ \ SD = rep(NA,trts),

      \ \ \ \ PSlope = rep(NA,trts),

      \ \ \ \ b = rep(NA,trts),

      \ \ \ \ Pb = rep(NA,trts),

      \ \ \ \ bR2 = rep(NA,trts)

      \ \ \ \ )

      \ \ 

      \ \ means.table$Trial.ID \<less\>- rep(rownames(means.matrix),trts)

      \ \ means.table$Trial.idx \<less\>- rep(1:trials,trts)

      \ \ means.table$trial.mean \<less\>-
      means.vector[means.table$Trial.idx]

      \ \ 

      \ \ #center on trial mean

      \ \ means.table$centered \<less\>- means.table$values -
      means.vector[means.table$Trial.idx]

      \ \ 

      \ \ if(is.na(min.y)){

      \ \ \ \ min.y \<less\>- min(means.table$values,na.rm=TRUE)

      \ \ }

      \ \ if(is.na(max.y)){

      \ \ \ \ max.y \<less\>- max(means.table$values,na.rm=TRUE)

      \ \ }

      \ \ min.x \<less\>- min(means.table$trial.mean,na.rm=TRUE)

      \ \ max.x \<less\>- max(means.table$trial.mean,na.rm=TRUE)

      \ \ if(fixed.prop) {

      \ \ \ \ min.x \<less\>- min(c(min.x,min.y))

      \ \ \ \ max.x \<less\>- max(c(max.x,max.y))

      \ \ \ \ min.y \<less\>- min.x

      \ \ \ \ max.y \<less\>- max.x

      \ \ }

      \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==1)

      \ \ if(length(trt.colors)\<less\>trts) {

      \ \ \ \ trt.colors \<less\>- c(trt.colors,rainbow(trts-length(trt.colors)))

      \ \ }

      \ \ 

      \ \ trt.pch = 1:trts

      \ \ 

      \ \ #pch 26:31 are unused, so add six if larger

      \ \ if(trts\<gtr\>25) {

      \ \ \ \ trt.pch[trt.pch\<gtr\>25] \<less\>- trt.pch[trt.pch\<gtr\>25] +
      7

      \ \ }

      \ \ 

      \ \ plot.lwd = lwd

      \ \ plot.cex = cex

      \ \ if(1 %in% highlight) {

      \ \ \ \ plot.lwd = 1.5*lwd*hcex

      \ \ \ \ if(highlight.point) {

      \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

      \ \ \ \ }

      \ \ }

      \ \ 

      \ \ ret.fit$Mean[1] = mean(trt.data$values,na.rm=TRUE)

      \ \ ret.fit$SD[1] = sd(trt.data$values,na.rm=TRUE)

      \ \ 

      \ \ if(segments) {

      \ \ \ \ plot(values ~ trial.mean,trt.data,

      \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

      \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

      \ \ \ \ \ \ \ \ \ xlog=xlog,

      \ \ \ \ \ \ \ \ \ ylog=ylog,

      \ \ \ \ \ \ \ \ \ bg=bg,

      \ \ \ \ \ \ \ \ \ #main=main,

      \ \ \ \ \ \ \ \ \ #sub=subtitle,

      \ \ \ \ \ \ \ \ \ col=trt.colors[1],

      \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

      \ \ \ \ \ \ \ \ \ axes=FALSE,

      \ \ \ \ \ \ \ \ \ #las=1,

      \ \ \ \ \ \ \ \ \ #font.main=style.main,

      \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

      \ \ \ \ \ \ \ \ \ col.axis=col.axis,

      \ \ \ \ \ \ \ \ \ col.lab=col.lab,

      \ \ \ \ \ \ \ \ \ xlab=xlab,

      \ \ \ \ \ \ \ \ \ ylab=ylab,

      \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

      \ \ \ \ \ \ \ \ \ cex=plot.cex,

      \ \ \ \ \ \ \ \ \ asp=1

      \ \ \ \ )

      \ \ } else {

      \ \ \ \ plot(values ~ trial.mean,trt.data,

      \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

      \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

      \ \ \ \ \ \ \ \ \ xlog=xlog,

      \ \ \ \ \ \ \ \ \ ylog=ylog,

      \ \ \ \ \ \ \ \ \ bg=bg,

      \ \ \ \ \ \ \ \ \ #main=main,

      \ \ \ \ \ \ \ \ \ #sub=subtitle,

      \ \ \ \ \ \ \ \ \ col=trt.colors[1],

      \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

      \ \ \ \ \ \ \ \ \ axes=FALSE,

      \ \ \ \ \ \ \ \ \ #las=1,

      \ \ \ \ \ \ \ \ \ #font.main=style.main,

      \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

      \ \ \ \ \ \ \ \ \ col.axis=col.axis,

      \ \ \ \ \ \ \ \ \ col.lab=col.lab,

      \ \ \ \ \ \ \ \ \ xlab=xlab,

      \ \ \ \ \ \ \ \ \ ylab=ylab,

      \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

      \ \ \ \ \ \ \ \ \ cex=plot.cex

      \ \ \ \ )

      \ \ }

      \;

      \ \ title(main,

      \ \ \ \ \ \ \ \ family=family.main,

      \ \ \ \ \ \ \ \ col.main=col.main)

      \ \ box(bg=bg,fg=fg)

      \ \ axis(1,tcl=0.02,mgp = c(0, .5, 0),las=1,

      \ \ \ \ \ \ \ las=left.las,

      \ \ \ \ \ \ \ col.axis=col.axis,

      \ \ \ \ \ \ \ xlog=xlog,

      \ \ \ \ \ \ \ ylog=ylog,

      \ \ \ \ \ \ \ family=family.axis,

      \ \ \ \ \ \ \ )

      \ \ axis(2,tcl=0.02,mgp = c(0, .5, 0),las=1,

      \ \ \ \ \ \ \ las=left.las,

      \ \ \ \ \ \ \ col.axis=col.axis,

      \ \ \ \ \ \ \ xlog=xlog,

      \ \ \ \ \ \ \ ylog=ylog,

      \ \ \ \ \ \ \ family=family.axis,

      \ \ \ \ \ \ \ )

      \;

      \ \ #draw legend first so it is in the background

      \ \ if(length(legend.labels)\<less\>trts) {

      \ \ \ \ legend.labels \<less\>- c(legend.labels,
      as.character((length(legend.labels)+1):trts))

      \ \ \ \ #legend.labels \<less\>- c(legend.labels, trt.levels)

      \ \ }

      \ \ if(show.legend) {

      \ \ \ \ current.family = par("family")

      \ \ \ \ par(family=family.legend)

      \ \ \ \ legend((min.x+(legend.x*(max.x-min.x))),\ 

      \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.y*(max.y-min.y))),\ 

      \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      \ \ \ \ \ \ \ \ \ \ \ #family=family.legend,

      \ \ \ \ \ \ \ \ \ \ \ text.font=style.legend,

      \ \ \ \ \ \ \ \ \ \ \ ncol = legend.columns,

      \ \ \ \ \ \ \ \ \ \ \ col = trt.colors)

      \ \ \ \ par(family=current.family)

      \ \ }

      \ \ 

      \ \ #text(means.vector[1],min.y+(max.y-min.y)/6,names(means.vector[1]),srt=90)

      \ \ 

      \ \ if(regression) {

      \ \ \ \ if(poly==1) {

      \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

      \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

      \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1,1]

      \ \ \ \ \ \ ret.fit$R2[1] = sum.lm$r.squared

      \ \ \ \ \ \ ret.fit$AdjR2[1] = sum.lm$adj.r.squared

      \ \ \ \ \ \ ret.fit$PSlope[1] = sum.lm$coefficients[2,4]

      \ \ \ \ \ \ 

      \ \ \ \ \ \ #fit trial adjusted means

      \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

      \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

      \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

      \ \ \ \ \ \ ret.fit$b[1] = fw.coef[2,1]

      \ \ \ \ \ \ ret.fit$Pb[1] = fw.coef[2,4]

      \ \ \ \ \ \ ret.fit$bR2[1] = sum.fw$r.squared

      \ \ \ \ } else {

      \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
      I(trial.mean^2),trt.data)

      \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
      fitted(trt.lm)[order(trt.data$trial.mean)],
      lty=1,lwd=plot.lwd,col=trt.colors[1])\ 

      \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

      \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1]

      \ \ \ \ \ \ ret.fit$R2[1] = sum.lm$r.squared

      \ \ \ \ \ \ ret.fit$AdjR2[1] = sum.lm$adj.r.squared\ 

      \ \ \ \ }

      \ \ \ \ 

      \ \ \ \ if(inverse.regression) {

      \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

      \ \ \ \ \ \ lines(predict(xy.lm), trt.data$values,lty=1,lwd=plot.lwd,
      col=trt.colors[1])

      \ \ \ \ }

      \ \ \ \ if(pc.regression) {

      \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

      \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])

      \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
      -xy.pc$center, scale = FALSE)

      \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

      \ \ \ \ \ \ points(transformed, pch=trt.pch[1],col=trt.colors[1], cex =
      0.5)

      \ \ \ \ }

      \ \ \ \ if(segments) {

      \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
      transformed[,2])

      \ \ \ \ }

      \ \ }

      \ \ 

      \ \ for(trt in 2:trts) {

      \ \ \ \ plot.lwd = lwd

      \ \ \ \ plot.cex = cex

      \ \ \ \ if(trt %in% highlight) {

      \ \ \ \ \ \ plot.lwd = 1.5*lwd*hcex

      \ \ \ \ \ \ if(highlight.point) {

      \ \ \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

      \ \ \ \ \ \ }

      \ \ \ \ }

      \ \ \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==trt)

      \ \ \ \ trt.data \<less\>- subset(trt.data,!is.na(trt.data$values))

      \ \ \ \ 

      \ \ \ \ ret.fit$Mean[trt] = mean(trt.data$values,na.rm=TRUE)

      \ \ \ \ ret.fit$SD[trt] = sd(trt.data$values,na.rm=TRUE)

      \ \ \ \ 

      \ \ \ \ trt.idx = as.numeric(trt)

      \ \ \ \ current.pch \<less\>- trt.pch[trt.idx]

      \ \ \ \ points(values ~ trial.mean,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,cex=plot.cex)

      \ \ \ \ if(regression) {

      \ \ \ \ \ \ if(poly==1) {

      \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

      \ \ \ \ \ \ \ \ #trt.coef \<less\>- coef(trt.lm)

      \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=as.numeric(trt),col=trt.colors[trt],lwd=plot.lwd)

      \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

      \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

      \ \ \ \ \ \ \ \ ret.fit$R2[trt] = sum.lm$r.squared

      \ \ \ \ \ \ \ \ ret.fit$AdjR2[trt] = sum.lm$adj.r.squared

      \ \ \ \ \ \ \ \ ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

      \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ \ \ #fit trial adjusted means

      \ \ \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

      \ \ \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

      \ \ \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

      \ \ \ \ \ \ \ \ ret.fit$b[trt] = fw.coef[2,1]

      \ \ \ \ \ \ \ \ ret.fit$Pb[trt] = fw.coef[2,4]

      \ \ \ \ \ \ \ \ ret.fit$bR2[trt] = sum.fw$r.squared

      \ \ \ \ \ \ \ \ 

      \ \ \ \ \ \ } else {

      \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
      I(trial.mean^2),trt.data)

      \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
      fitted(trt.lm)[order(trt.data$trial.mean)],
      lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])\ 

      \ \ \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

      \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

      \ \ \ \ \ \ \ \ ret.fit$R2[trt] = sum.lm$r.squared

      \ \ \ \ \ \ \ \ ret.fit$AdjR2[trt] = sum.lm$adj.r.squared\ 

      \ \ \ \ \ \ \ \ ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

      \ \ \ \ \ \ }

      \ \ \ \ }

      \ \ \ \ if(inverse.regression) {

      \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

      \ \ \ \ \ \ inv.coef \<less\>- xy.lm$coefficients

      \ \ \ \ \ \ abline(-(inv.coef[1]/inv.coef[2]),(1/inv.coef[2]),lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])

      \ \ \ \ \ \ #lines(predict(xy.lm), trt.data$values,
      lty=as.numeric(trt), lwd=plot.lwd, col=trt.colors[trt])

      \ \ \ \ }

      \ \ \ \ if(pc.regression) {

      \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

      \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])

      \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
      -xy.pc$center, scale = FALSE)

      \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

      \ \ \ \ \ \ points(transformed, pch=trt.pch[trt],col=trt.colors[trt],
      cex = 0.5)

      \ \ \ \ }

      \ \ \ \ if(segments) {

      \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
      transformed[,2])

      \ \ \ \ }

      \ \ }

      \ \ 

      \ \ if(length(mark.int)\<gtr\>0) {

      \ \ \ \ for(idx in 1:length(mark.int)) {

      \ \ \ \ \ \ pair \<less\>- mark.int[[idx]]

      \ \ \ \ \ \ trt \<less\>- pair[1]

      \ \ \ \ \ \ trial \<less\>- pair[2]

      \ \ \ \ \ \ y \<less\>- means.matrix[trial,trt]

      \ \ \ \ \ \ x \<less\>- means.vector[trial]

      \ \ \ \ \ \ current.pch \<less\>- trt.pch[trt]

      \ \ \ \ \ \ #points(x,y,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,)

      \ \ \ \ \ \ points(x,y,cex=plot.cex*2)

      \ \ \ \ }

      \ \ }

      \ \ 

      \ \ if(plot.unity) {

      \ \ \ \ abline(0,1,col="gray",lwd=2)

      \ \ \ \ if(length(tukey.coeffs)\<gtr\>0) {

      \ \ \ \ \ \ max.a \<less\>- max(ret.fit$Mean)-mean(ret.fit$Mean)

      \ \ \ \ \ \ min.a \<less\>- min(ret.fit$Mean)-mean(ret.fit$Mean)

      \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
      tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dashed")

      \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
      tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dashed")

      \ \ \ \ \ \ #abline(tukey.coeffs[2]*max.a, (1 +
      tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

      \ \ \ \ \ \ #abline(tukey.coeffs[2]*min.a, (1 +
      tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

      \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
      tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

      \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
      tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

      \ \ \ \ }

      \ \ }

      \ \ return(list(data=means.table,fit=ret.fit))

      }
    <|unfolded-io>
      \ \ \ \ for(i in 1:treatments) {

      + \ \ if(i==1) {

      + \ \ \ plot.fn \<less\>- plot

      + \ \ \ #plot legend

      + \ \ } else {

      + \ \ \ \ plot.fn \<less\>- points

      + \ \ }

      + \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      + \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y),

      + \ \ \ \ \ \ \ \ \ \ xlab="",ylab="")

      + \ \ if(i==1) {

      + \ \ \ \ #plot legend

      + \ \ \ \ legend((min.x+(legend.pos[1]*(max.x-min.x))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.pos[2]*(max.y-min.y))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      + \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      + \ \ \ \ \ \ \ \ \ \ \ title=legend.title,

      + \ \ \ \ \ \ \ \ \ \ \ col=trt.colors,

      + \ \ \ \ \ \ \ \ \ \ \ bty="n",

      + \ \ \ \ \ \ \ \ \ \ \ ncol=legend.columns,

      + \ \ \ \ \ \ \ \ \ \ \ cex=cex.axis)

      + \ \ }

      + \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      + \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      + }

      Error in plot.fn(x = trial.means, y = txt.lsmeans.tbl[, i], pch =
      trt.pch[i], \ :\ 

      \ \ object 'trial.means' not found

      \<gtr\> title(main=main,xlab=xlab,ylab=ylab);v()

      Error in title(main = main, xlab = xlab, ylab = ylab) :\ 

      \ \ plot.new has not been called yet

      \ plot.interaction.ARMST \<less\>- function(means.matrix,\ 

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ means.vector,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylab="",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlab="",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ main="",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ regression=TRUE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ show.legend=FALSE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.colors=c(),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.labels=NA,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.labels=c(),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.columns=1,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ style.legend=1,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.main="",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.axis="",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.legend="",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.axis="black",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.lab="black",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.main="black",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.sub="black",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fg="black",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bg="white",

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ left.las=0,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ min.y=NA,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ max.y=NA,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylog=FALSE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlog=FALSE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.pos=c(.90,.55),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lwd
      = 3,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cex=1.0,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight=c(),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hcex=1.5,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fixed.prop=FALSE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ poly=1,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mark.int
      = c(),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ plot.unity=FALSE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight.point=TRUE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ tukey.coeffs=c(),

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ inverse.regression=FALSE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pc.regression=FALSE,

      + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ segments=FALSE)
      {

      + \ \ legend.x = legend.pos[1]
    </unfolded-io>

    <\textput>
      We want to control fonts - type and size. We'll can define for title,
      axes and legend.

      cex controls relative point size.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      par(fig = c(0, 1, 0.4, 1), mar = (c(1, 4, 1, 1) + 0.1), ps = 14,
      cex.lab = 0.7142857, cex.main = 0.8571429, cex.axis = 1)

      \ for(i in 1:treatments) {

      \ \ if(i==1) {

      \ \ \ plot.fn \<less\>- plot

      \ \ \ #plot legend

      \ \ } else {

      \ \ \ \ plot.fn \<less\>- points

      \ \ }

      \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y))

      \ \ if(i==1) {

      \ \ \ \ #plot legend

      \ \ \ \ legend((min.x+(legend.pos[1]*(max.x-min.x))),\ 

      \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.pos[2]*(max.y-min.y))),\ 

      \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      \ \ \ \ \ \ \ \ \ \ \ col=trt.colors)

      \ \ }

      \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      \ \ sum.lm \<less\>- summary(trt.lm)

      \ \ trt.coef \<less\>- sum.lm$coefficients

      \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      }

      title(main=main,xlab=xlab,ylab=xlab);v()
    <|unfolded-io>
      + \ \ legend.y = legend.pos[2]

      + \ \ 

      + \ \ # use this to force means table to use numeric names. This
      assumes

      + \ \ # means are in correct numeric order (Jun 9 15, PMC)

      + \ \ colnames(means.matrix) \<less\>-
      as.character(1:dim(means.matrix)[2])

      + \ \ rownames(means.matrix) \<less\>-
      as.character(1:dim(means.matrix)[1])

      + \ \ names(means.vector) \<less\>-
      as.character(1:dim(means.matrix)[1])

      + \ \ 

      + \ \ means.table \<less\>- data.frame(stack(means.matrix))

      + \ 

      + \ \ means.table$TrtNo \<less\>- as.numeric(as.character(means.table$ind))

      + \ \ 

      + \ \ trts \<less\>- dim(means.matrix)[2]

      + \ \ trials \<less\>- dim(means.matrix)[1]

      + \ \ trt.levels \<less\>- levels(means.table$ind)

      + \ \ 

      + \ \ #we'll return a data table with one row for each treatment.

      + \ \ #this table will include the slope, intercept and other stats to
      be added

      + \ \ ret.fit \<less\>- data.frame(

      + \ \ \ \ Treatment = 1:trts,

      + \ \ \ \ Slope = rep(NA,trts),

      + \ \ \ \ Intercept = rep(NA,trts),

      + \ \ \ \ R2 = rep(NA,trts),

      + \ \ \ \ AdjR2 = rep(NA,trts),

      + \ \ \ \ Mean = rep(NA,trts),

      + \ \ \ \ SD = rep(NA,trts),

      + \ \ \ \ PSlope = rep(NA,trts),

      + \ \ \ \ b = rep(NA,trts),

      + \ \ \ \ Pb = rep(NA,trts),

      + \ \ \ \ bR2 = rep(NA,trts)

      + \ \ \ \ )

      + \ \ 

      + \ \ means.table$Trial.ID \<less\>- rep(rownames(means.matrix),trts)

      + \ \ means.table$Trial.idx \<less\>- rep(1:trials,trts)

      + \ \ means.table$trial.mean \<less\>-
      means.vector[means.table$Trial.idx]

      + \ \ 

      + \ \ #center on trial mean

      + \ \ means.table$centered \<less\>- means.table$values -
      means.vector[means.table$Tri

      \<less\> means.table$values - means.vector[means.table$Trial.idx]

      + \ \ 

      + \ \ if(is.na(min.y)){

      + \ \ \ \ min.y \<less\>- min(means.table$values,na.rm=TRUE)

      + \ \ }

      + \ \ if(is.na(max.y)){

      + \ \ \ \ max.y \<less\>- max(means.table$values,na.rm=TRUE)

      + \ \ }

      + \ \ min.x \<less\>- min(means.table$trial.mean,na.rm=TRUE)

      + \ \ max.x \<less\>- max(means.table$trial.mean,na.rm=TRUE)

      + \ \ if(fixed.prop) {

      + \ \ \ \ min.x \<less\>- min(c(min.x,min.y))

      + \ \ \ \ max.x \<less\>- max(c(max.x,max.y))

      + \ \ \ \ min.y \<less\>- min.x

      + \ \ \ \ max.y \<less\>- max.x

      + \ \ }

      + \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==1)

      + \ \ if(length(trt.colors)\<less\>trts) {

      + \ \ \ \ trt.colors \<less\>- c(trt.colors,rainbow(trts-length(trt.colors)))

      + \ \ }

      + \ \ 

      + \ \ trt.pch = 1:trts

      + \ \ 

      + \ \ #pch 26:31 are unused, so add six if larger

      + \ \ if(trts\<gtr\>25) {

      + \ \ \ \ trt.pch[trt.pch\<gtr\>25] \<less\>- trt.pch[trt.pch\<gtr\>25]
      + 7

      + \ \ }

      + \ \ 

      + \ \ plot.lwd = lwd

      + \ \ plot.cex = cex

      + \ \ if(1 %in% highlight) {

      + \ \ \ \ plot.lwd = 1.5*lwd*hcex

      + \ \ \ \ if(highlight.point) {

      + \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

      + \ \ \ \ }

      + \ \ }

      + \ \ 

      + \ \ ret.fit$Mean[1] = mean(trt.data$values,na.rm=TRUE)

      + \ \ ret.fit$SD[1] = sd(trt.data$values,na.rm=TRUE)

      + \ \ 

      + \ \ if(segments) {

      + \ \ \ \ plot(values ~ trial.mean,trt.data,

      + \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

      + \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

      + \ \ \ \ \ \ \ \ \ xlog=xlog,

      + \ \ \ \ \ \ \ \ \ ylog=ylog,

      + \ \ \ \ \ \ \ \ \ bg=bg,

      + \ \ \ \ \ \ \ \ \ #main=main,

      + \ \ \ \ \ \ \ \ \ #sub=subtitle,

      + \ \ \ \ \ \ \ \ \ col=trt.colors[1],

      + \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

      + \ \ \ \ \ \ \ \ \ axes=FALSE,

      + \ \ \ \ \ \ \ \ \ #las=1,

      + \ \ \ \ \ \ \ \ \ #font.main=style.main,

      + \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

      + \ \ \ \ \ \ \ \ \ col.axis=col.axis,

      + \ \ \ \ \ \ \ \ \ col.lab=col.lab,

      + \ \ \ \ \ \ \ \ \ xlab=xlab,

      + \ \ \ \ \ \ \ \ \ ylab=ylab,

      + \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

      + \ \ \ \ \ \ \ \ \ cex=plot.cex,

      + \ \ \ \ \ \ \ \ \ asp=1

      + \ \ \ \ )

      + \ \ } else {

      + \ \ \ \ plot(values ~ trial.mean,trt.data,;;
      \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

      Error: unexpected ';' in:

      " \ } else {

      \ \ \ \ plot(values ~ trial.mean,trt.data,;"

      \<gtr\> \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),"

      \<gtr\> \ \ \ \ \ \ \ \ \ xlog=xlog,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ xlog=xlog,"

      \<gtr\> \ \ \ \ \ \ \ \ \ ylog=ylog,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ ylog=ylog,"

      \<gtr\> \ \ \ \ \ \ \ \ \ bg=bg,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ bg=bg,"

      \<gtr\> \ \ \ \ \ \ \ \ \ #main=main,

      \<gtr\> \ \ \ \ \ \ \ \ \ #sub=subtitle,

      \<gtr\> \ \ \ \ \ \ \ \ \ col=trt.colors[1],

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ col=trt.colors[1],"

      \<gtr\> \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ pch=trt.pch[1],"

      \<gtr\> \ \ \ \ \ \ \ \ \ axes=FALSE,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ axes=FALSE,"

      \<gtr\> \ \ \ \ \ \ \ \ \ #las=1,

      \<gtr\> \ \ \ \ \ \ \ \ \ #font.main=style.main,

      \<gtr\> \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

      \<gtr\> \ \ \ \ \ \ \ \ \ col.axis=col.axis,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ col.axis=col.axis,"

      \<gtr\> \ \ \ \ \ \ \ \ \ col.lab=col.lab,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ col.lab=col.lab,"

      \<gtr\> \ \ \ \ \ \ \ \ \ xlab=xlab,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ xlab=xlab,"

      \<gtr\> \ \ \ \ \ \ \ \ \ ylab=ylab,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ ylab=ylab,"

      \<gtr\> \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

      Error: unexpected ',' in " \ \ \ \ \ \ \ \ lwd=plot.lwd,"

      \<gtr\> \ \ \ \ \ \ \ \ \ cex=plot.cex

      Error: object 'plot.cex' not found

      \<gtr\> \ \ \ \ )

      Error: unexpected ')' in " \ \ \ )"

      \<gtr\> \ \ }

      Error: unexpected '}' in " \ }"

      \<gtr\>\ 

      \<gtr\> \ \ title(main,

      + \ \ \ \ \ \ \ \ family=family.main,

      + \ \ \ \ \ \ \ \ col.main=col.main)

      Error in title(main, family = family.main, col.main = col.main) :\ 

      \ \ object 'family.main' not found

      \<gtr\> \ \ box(bg=bg,fg=fg)

      Error in box(bg = bg, fg = fg) : object 'bg' not found

      \<gtr\> \ \ axis(1,tcl=0.02,mgp = c(0, .5, 0),las=1,

      + \ \ \ \ \ \ \ las=left.las,

      + \ \ \ \ \ \ \ col.axis=col.axis,

      + \ \ \ \ \ \ \ xlog=xlog,

      + \ \ \ \ \ \ \ ylog=ylog,

      + \ \ \ \ \ \ \ family=family.axis,

      + \ \ \ \ \ \ \ )

      Error in axis(1, tcl = 0.02, mgp = c(0, 0.5, 0), las = 1, las =
      left.las, \ :\ 

      \ \ object 'left.las' not found

      \<gtr\> \ \ axis(2,tcl=0.02,mgp = c(0, .5, 0),las=1,

      + \ \ \ \ \ \ \ las=left.las,

      + \ \ \ \ \ \ \ col.axis=col.axis,

      + \ \ \ \ \ \ \ xlog=xlog,

      + \ \ \ \ \ \ \ ylog=ylog,

      + \ \ \ \ \ \ \ family=family.axis,

      + \ \ \ \ \ \ \ )

      Error in axis(2, tcl = 0.02, mgp = c(0, 0.5, 0), las = 1, las =
      left.las, \ :\ 

      \ \ object 'left.las' not found

      \<gtr\>\ 

      \<gtr\> \ \ #draw legend first so it is in the background

      \<gtr\> \ \ if(length(legend.labels)\<less\>trts) {

      + \ \ \ \ legend.labels \<less\>- c(legend.labels,
      as.character((length(legend.labels)+1

      \<less\>gend.labels, as.character((length(legend.labels)+1):trts))

      + \ \ \ \ #legend.labels \<less\>- c(legend.labels, trt.levels)

      + \ \ }

      Error: object 'trts' not found

      \<gtr\> \ \ if(show.legend) {

      + \ \ \ \ current.family = par("family")

      + \ \ \ \ par(family=family.legend)

      + \ \ \ \ legend((min.x+(legend.x*(max.x-min.x))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.y*(max.y-min.y))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      + \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      + \ \ \ \ \ \ \ \ \ \ \ #family=family.legend,

      + \ \ \ \ \ \ \ \ \ \ \ text.font=style.legend,

      + \ \ \ \ \ \ \ \ \ \ \ ncol = legend.columns,

      + \ \ \ \ \ \ \ \ \ \ \ col = trt.colors)

      + \ \ \ \ par(family=current.family)

      + \ \ }

      Error: object 'show.legend' not found

      \<gtr\> \ \ 

      \<gtr\> \ \ #text(means.vector[1],min.y+(max.y-min.y)/6,names(means.vector[1]),srt=90

      \<less\>in.y+(max.y-min.y)/6,names(means.vector[1]),srt=90)

      \<gtr\> \ \ 

      \<gtr\> \ \ if(regression) {

      + \ \ \ \ if(poly==1) {

      + \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

      + \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      + \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

      + \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1,1]

      + \ \ \ \ \ \ ret.fit$R2[1] = sum.lm$r.squared

      + \ \ \ \ \ \ ret.fit$AdjR2[1] = sum.lm$adj.r.squared

      + \ \ \ \ \ \ ret.fit$PSlope[1] = sum.lm$coefficients[2,4]

      + \ \ \ \ \ \ 

      + \ \ \ \ \ \ #fit trial adjusted means

      + \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

      + \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

      + \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

      + \ \ \ \ \ \ ret.fit$b[1] = fw.coef[2,1]

      + \ \ \ \ \ \ ret.fit$Pb[1] = fw.coef[2,4]

      + \ \ \ \ \ \ ret.fit$bR2[1] = sum.fw$r.squared

      + \ \ \ \ } else {

      + \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
      I(trial.mean^2),trt.data)

      + \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
      fitted(trt.lm)[order(trt.data$trial.

      \<less\>$trial.mean), fitted(trt.lm)[order(trt.data$trial.mean)],
      lty=1,lwd=plot.lwd

      \<less\>m)[order(trt.data$trial.mean)],
      lty=1,lwd=plot.lwd,col=trt.colors[1])\ 

      + \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      + \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

      + \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1]

      + \ \ \ \ \ \ ret.fit$R2[1] = sum.lm$r.squared

      + \ \ \ \ \ \ ret.fit$AdjR2[1] = sum.lm$adj.r.squared\ 

      + \ \ \ \ }

      + \ \ \ \ 

      + \ \ \ \ if(inverse.regression) {

      + \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

      + \ \ \ \ \ \ lines(predict(xy.lm), trt.data$values,lty=1,lwd=plot.lwd,
      col=trt.col

      \<less\>), trt.data$values,lty=1,lwd=plot.lwd, col=trt.colors[1])

      + \ \ \ \ }

      + \ \ \ \ if(pc.regression) {

      + \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

      + \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*%
      t(xy.pc$rotation[,1])

      + \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
      -xy.pc$center, scale = FA

      \<less\>e (transformed, center = -xy.pc$center, scale = FALSE)

      + \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      + \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

      + \ \ \ \ \ \ points(transformed, pch=trt.pch[1],col=trt.colors[1], cex
      = 0.5)

      + \ \ \ \ }

      + \ \ \ \ if(segments) {

      + \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
      transformed[,2]

      \<less\>,6],trt.data[,1], transformed[,1], transformed[,2])

      + \ \ \ \ }

      + \ \ }

      Error: object 'regression' not found

      \<gtr\> \ \ 

      \<gtr\> \ \ for(trt in 2:trts) {

      + \ \ \ \ plot.lwd = lwd

      + \ \ \ \ plot.cex = cex

      + \ \ \ \ if(trt %in% highlight) {

      + \ \ \ \ \ \ plot.lwd = 1.5*lwd*hcex

      + \ \ \ \ \ \ if(highlight.point) {

      + \ \ \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

      + \ \ \ \ \ \ }

      + \ \ \ \ }

      + \ \ \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==trt)

      + \ \ \ \ trt.data \<less\>- subset(trt.data,!is.na(trt.data$values))

      + \ \ \ \ 

      + \ \ \ \ ret.fit$Mean[trt] = mean(trt.data$values,na.rm=TRUE)

      + \ \ \ \ ret.fit$SD[trt] = sd(trt.data$values,na.rm=TRUE)

      + \ \ \ \ 

      + \ \ \ \ trt.idx = as.numeric(trt)

      + \ \ \ \ current.pch \<less\>- trt.pch[trt.idx]

      + \ \ \ \ points(values ~ trial.mean,trt.data,pch=current.pch,col=trt.colors[trt]

      \<less\>.mean,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,cex=plot.cex

      \<less\>.pch,col=trt.colors[trt],lwd=plot.lwd,cex=plot.cex)

      + \ \ \ \ if(regression) {

      + \ \ \ \ \ \ if(poly==1) {

      + \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

      + \ \ \ \ \ \ \ \ #trt.coef \<less\>- coef(trt.lm)

      + \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=as.numeric(trt),col=trt.colors[t

      \<less\>],trt.coef[2],lty=as.numeric(trt),col=trt.colors[trt],lwd=plot.lwd)

      + \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

      + \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

      + \ \ \ \ \ \ \ \ ret.fit$R2[trt] = sum.lm$r.squared

      + \ \ \ \ \ \ \ \ ret.fit$AdjR2[trt] = sum.lm$adj.r.squared

      + \ \ \ \ \ \ \ \ ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

      + \ \ \ \ \ \ \ \ 

      + \ \ \ \ \ \ \ \ #fit trial adjusted means

      + \ \ \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

      + \ \ \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

      + \ \ \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

      + \ \ \ \ \ \ \ \ ret.fit$b[trt] = fw.coef[2,1]

      + \ \ \ \ \ \ \ \ ret.fit$Pb[trt] = fw.coef[2,4]

      + \ \ \ \ \ \ \ \ ret.fit$bR2[trt] = sum.fw$r.squared

      + \ \ \ \ \ \ \ \ 

      + \ \ \ \ \ \ } else {

      + \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
      I(trial.mean^2),trt.data)

      + \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
      fitted(trt.lm)[order(trt.data$tria

      \<less\>ta$trial.mean), fitted(trt.lm)[order(trt.data$trial.mean)],
      lty=as.numeric(t

      \<less\>.lm)[order(trt.data$trial.mean)],
      lty=as.numeric(trt),lwd=plot.lwd,col=trt.c

      \<less\>mean)], lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])\ 

      + \ \ \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1

      \<less\>1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      + \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

      + \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

      + \ \ \ \ \ \ \ \ ret.fit$R2[trt] = sum.lm$r.squared

      + \ \ \ \ \ \ \ \ ret.fit$AdjR2[trt] = sum.lm$adj.r.squared\ 

      + \ \ \ \ \ \ \ \ ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

      + \ \ \ \ \ \ }

      + \ \ \ \ }

      + \ \ \ \ if(inverse.regression) {

      + \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

      + \ \ \ \ \ \ inv.coef \<less\>- xy.lm$coefficients

      + \ \ \ \ \ \ abline(-(inv.coef[1]/inv.coef[2]),(1/inv.coef[2]),lty=as.numeric(trt)

      \<less\>]/inv.coef[2]),(1/inv.coef[2]),lty=as.numeric(trt),lwd=plot.lwd,col=trt.colo

      \<less\>[2]),lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])

      + \ \ \ \ \ \ #lines(predict(xy.lm), trt.data$values,
      lty=as.numeric(trt), lwd=plot

      \<less\>m), trt.data$values, lty=as.numeric(trt), lwd=plot.lwd,
      col=trt.colors[trt])

      + \ \ \ \ }

      + \ \ \ \ if(pc.regression) {

      + \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

      + \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*%
      t(xy.pc$rotation[,1])

      + \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
      -xy.pc$center, scale = FA

      \<less\>e (transformed, center = -xy.pc$center, scale = FALSE)

      + \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

      + \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

      + \ \ \ \ \ \ points(transformed, pch=trt.pch[trt],col=trt.colors[trt],
      cex = 0.5)

      + \ \ \ \ }

      + \ \ \ \ if(segments) {

      + \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
      transformed[,2]

      \<less\>,6],trt.data[,1], transformed[,1], transformed[,2])

      + \ \ \ \ }

      + \ \ }

      Error: object 'trts' not found

      \<gtr\> \ \ 

      \<gtr\> \ \ if(length(mark.int)\<gtr\>0) {

      + \ \ \ \ for(idx in 1:length(mark.int)) {

      + \ \ \ \ \ \ pair \<less\>- mark.int[[idx]]

      + \ \ \ \ \ \ trt \<less\>- pair[1]

      + \ \ \ \ \ \ trial \<less\>- pair[2]

      + \ \ \ \ \ \ y \<less\>- means.matrix[trial,trt]

      + \ \ \ \ \ \ x \<less\>- means.vector[trial]

      + \ \ \ \ \ \ current.pch \<less\>- trt.pch[trt]

      + \ \ \ \ \ \ #points(x,y,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd

      \<less\>a,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,)

      + \ \ \ \ \ \ points(x,y,cex=plot.cex*2)

      + \ \ \ \ }

      + \ \ }

      Error: object 'mark.int' not found

      \<gtr\> \ \ 

      \<gtr\> \ \ if(plot.unity) {

      + \ \ \ \ abline(0,1,col="gray",lwd=2)

      + \ \ \ \ if(length(tukey.coeffs)\<gtr\>0) {

      + \ \ \ \ \ \ max.a \<less\>- max(ret.fit$Mean)-mean(ret.fit$Mean)

      + \ \ \ \ \ \ min.a \<less\>- min(ret.fit$Mean)-mean(ret.fit$Mean)

      + \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
      tukey.coeffs[2]*max.a),col="gray",lwd=2,

      \<less\>[1], (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dashed")

      + \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
      tukey.coeffs[2]*min.a),col="gray",lwd=2,

      \<less\>[1], (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dashed")

      + \ \ \ \ \ \ #abline(tukey.coeffs[2]*max.a, (1 +
      tukey.coeffs[2]*max.a),col="gray"

      \<less\>s[2]*max.a, (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

      + \ \ \ \ \ \ #abline(tukey.coeffs[2]*min.a, (1 +
      tukey.coeffs[2]*min.a),col="gray"

      \<less\>s[2]*min.a, (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

      + \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
      tukey.coeffs[2]*max.a

      \<less\>[2]*mean(ret.fit$Mean), (1 +
      tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="do

      \<less\> + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

      + \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
      tukey.coeffs[2]*min.a

      \<less\>[2]*mean(ret.fit$Mean), (1 +
      tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="do

      \<less\> + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

      + \ \ \ \ }

      + \ \ }

      Error: object 'plot.unity' not found

      \<gtr\> \ \ return(list(data=means.table,fit=ret.fit))

      Error: object 'means.table' not found

      \<gtr\> }

      Error: unexpected '}' in "}"

      \<gtr\> par(fig = c(0, 1, 0.4, 1), mar = (c(1, 4, 1, 1) + 0.1), ps =
      14, cex.lab =\ 

      \<less\>, mar = (c(1, 4, 1, 1) + 0.1), ps = 14, cex.lab = 0.7142857,
      cex.main = 0.85

      \<less\>.1), ps = 14, cex.lab = 0.7142857, cex.main = 0.8571429,
      cex.axis = 1)

      \<gtr\> \ for(i in 1:treatments) {

      + \ \ if(i==1) {

      + \ \ \ plot.fn \<less\>- plot

      + \ \ \ #plot legend

      + \ \ } else {

      + \ \ \ \ plot.fn \<less\>- points

      + \ \ }

      + \ \ plot.fn(x=trial.means,y=txt.lsmeans.tbl[,i],

      + \ \ \ \ \ \ \ \ \ \ pch=trt.pch[i],lty=i,col=trt.colors[i],ylim=c(min.y,max.y))

      + \ \ if(i==1) {

      + \ \ \ \ #plot legend

      + \ \ \ \ legend((min.x+(legend.pos[1]*(max.x-min.x))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.pos[2]*(max.y-min.y))),\ 

      + \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

      + \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

      + \ \ \ \ \ \ \ \ \ \ \ col=trt.colors)

      + \ \ }

      + \ \ trt.lm \<less\>- lm(txt.lsmeans.tbl[,i] ~ trial.means)

      + \ \ sum.lm \<less\>- summary(trt.lm)

      + \ \ trt.coef \<less\>- sum.lm$coefficients

      + \ \ abline(trt.coef[1],trt.coef[2],lty=i,col=trt.colors[i])

      + }

      Error in plot.fn(x = trial.means, y = txt.lsmeans.tbl[, i], pch =
      trt.pch[i], \ :\ 

      \ \ object 'trial.means' not found

      \<gtr\> title(main=main,xlab=xlab,ylab=xlab);v()

      Error in title(main = main, xlab = xlab, ylab = xlab) :\ 

      \ \ plot.new has not been called yet
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      warnings()
    <|unfolded-io>
      warnings()

      Warning message:

      In anova.lmlist(object, ...) :

      \ \ models with response '"response"' removed because response differs
      from model 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      postscript()
    <|unfolded-io>
      postscript()

      Error in postscript() : cannot open file 'Rplots.ps'
    </unfolded-io>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>
  </session>

  \ \ \ model.matrix(mt, mf, contrasts)

  sub.mask \<less\>- get("block",res1$additive.lm$model)==levels(get("block",res1$additive.lm$model))[1]
  \ \ \ \ \ \ \ \ \ \ \ 

  mf \<less\>- res1$additive.lm$model[sub.mask,]

  mt \<less\>- res1$additive.lm$terms

  \<gtr\> mf \<less\>- res1$additive.lm$model

  tmp.model \<less\>- model.matrix(res1$additive.lm$terms, mf,
  res1$additive.lm$contrasts)

  beta \<less\>- res1$additive.lm$coefficients

  length(beta)

  blockDF \<less\>- dim(tmp.model)[2] - dim(tmp.model)[1]

  blocks.idx \<less\>- \ (dim(tmp.model)[1]+1):dim(tmp.model)[2]

  \;

  xlevels \<less\>- res1$additive.lm$xlevels \ \ \ \ \ :List of 3

  \ \ .. ..$ trial \ \ \ : chr [1:9] "A" "B" "C" "D" âÂ€\<brokenvert\>

  \ \ .. ..$ treatment: chr [1:4] "1" "2" "3" "4"

  \ \ .. ..$ block \ \ \ : chr [1:3] "1" "2" "3"

  trt.cnt \<less\>- length(xlevels["treatment"][[1]])

  trial.cnt \<less\>- length(xlevels["trial"][[1]])

  rep.cnt \<less\>- length(xlevels["block"][[1]])
  \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

  expected.blocks \<less\>- trial.cnt*rep.cnt

  tmp.model[,blocks.idx] \<less\>- 1/expected.blocks

  tmp.model[,blocks.idx] \<less\>- 1/rep.cnt

  \;

  Partition the matrix

  full.mat \<less\>- model.matrix(res1$additive.lm$terms,
  res1$additive.lm$model, res1$additive.lm$contrasts)

  trial.mat \<less\>- full.mat[,attr(full.mat,"assign")==1]

  trt.mat \<less\>- full.mat[,attr(full.mat,"assign")==2]

  txt.mat \<less\>- full.mat[,attr(full.mat,"assign")==3]

  blk.mat \<less\>- full.mat[,attr(full.mat,"assign")==4]

  \;

  and the interaction matrix

  means.model \<less\>- model.matrix(~ 0+trial:treatment,
  res1$additive.lm$model, res1$additive.lm$contrasts)

  L.r \<less\>- L.r*(1/4)

  L.r \<less\>- (t(means.model) %*% blk.mat) %*% solve(t(blk.mat)%*%blk.mat)

  L.t \<less\>- t(means.model) %*% trt.mat

  L.e \<less\>- t(means.model) %*% trial.mat

  L.te \<less\>- t(means.model) %*% txt.mat

  L.txt \<less\>- cbind(rep(1,dim(means.model)[2]),L.e,L.t, L.te, L.r)

  \;

  \;

  \;

  \;

  \;

  par(fig = c(0, 1, 0.4, 1), mar = (c(1, 4, 1, 1) + 0.1), ps = 14, cex.lab =
  0.7142857, cex.main = 0.8571429, cex.axis = 1)

  plot.interaction.ARMST(means.matrix, means.vector,\ 

  \ \ ylab='Treatment in Trial Mean \\n1Rep',regression=TRUE,\ 

  \ \ main='Treatment Stability and Trial Clusters for Grand Mean 5',\ 

  \ \ show.legend=TRUE,legend.columns=1, legend.pos=c(.01,.98))

  <\unfolded-io>
    <with|color|red|+ >
  <|unfolded-io>
    plot.interaction.ARMST \<less\>- function(means.matrix,\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ means.vector,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylab="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlab="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ main="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ regression=TRUE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ show.legend=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.colors=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.labels=NA,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.labels=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.columns=1,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ style.legend=1,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.main="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #family.lab="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.axis="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.legend="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.axis="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.lab="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.main="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.sub="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fg="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bg="white",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ left.las=0,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ min.y=NA,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ max.y=NA,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylog=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlog=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.pos=c(.90,.55),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lwd
    = 3,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cex=1.0,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hcex=1.5,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fixed.prop=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ poly=1,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mark.int
    = c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ plot.unity=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight.point=TRUE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ tukey.coeffs=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ inverse.regression=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pc.regression=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ segments=FALSE)
    {

    \ \ legend.x = legend.pos[1]

    \ \ legend.y = legend.pos[2]

    \ \ 

    \ \ # use this to force means table to use numeric names. This assumes

    \ \ # means are in correct numeric order (Jun 9 15, PMC)

    \ \ colnames(means.matrix) \<less\>- as.character(1:dim(means.matrix)[2])

    \ \ rownames(means.matrix) \<less\>- as.character(1:dim(means.matrix)[1])

    \ \ names(means.vector) \<less\>- as.character(1:dim(means.matrix)[1])

    \ \ 

    \ \ means.table \<less\>- data.frame(stack(means.matrix))

    \ 

    \ \ means.table$TrtNo \<less\>- as.numeric(as.character(means.table$ind))

    \ \ 

    \ \ trts \<less\>- dim(means.matrix)[2]

    \ \ trials \<less\>- dim(means.matrix)[1]

    \ \ trt.levels \<less\>- levels(means.table$ind)

    \ \ 

    \ \ #we'll return a data table with one row for each treatment.

    \ \ #this table will include the slope, intercept and other stats to be
    added

    \ \ ret.fit \<less\>- data.frame(

    \ \ \ \ Treatment = 1:trts,

    \ \ \ \ Slope = rep(NA,trts),

    \ \ \ \ Intercept = rep(NA,trts),

    \ \ \ \ #R2 = rep(NA,trts),

    \ \ \ \ #AdjR2 = rep(NA,trts),

    \ \ \ \ Mean = rep(NA,trts),

    \ \ \ \ SD = rep(NA,trts),

    \ \ \ \ #PSlope = rep(NA,trts),

    \ \ \ \ b = rep(NA,trts),

    \ \ \ \ Pb = rep(NA,trts),

    \ \ \ \ bR2 = rep(NA,trts)

    \ \ \ \ )

    \ \ 

    \ \ means.table$Trial.ID \<less\>- rep(rownames(means.matrix),trts)

    \ \ means.table$Trial.idx \<less\>- rep(1:trials,trts)

    \ \ means.table$trial.mean \<less\>- means.vector[means.table$Trial.idx]

    \ \ 

    \ \ #center on trial mean

    \ \ means.table$centered \<less\>- means.table$values -
    means.vector[means.table$Trial.idx]

    \ \ 

    \ \ if(is.na(min.y)){

    \ \ \ \ min.y \<less\>- min(means.table$values,na.rm=TRUE)

    \ \ }

    \ \ if(is.na(max.y)){

    \ \ \ \ max.y \<less\>- max(means.table$values,na.rm=TRUE)

    \ \ }

    \ \ min.x \<less\>- min(means.table$trial.mean,na.rm=TRUE)

    \ \ max.x \<less\>- max(means.table$trial.mean,na.rm=TRUE)

    \ \ if(fixed.prop) {

    \ \ \ \ min.x \<less\>- min(c(min.x,min.y))

    \ \ \ \ max.x \<less\>- max(c(max.x,max.y))

    \ \ \ \ min.y \<less\>- min.x

    \ \ \ \ max.y \<less\>- max.x

    \ \ }

    \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==1)

    \ \ if(length(trt.colors)\<less\>trts) {

    \ \ \ \ trt.colors \<less\>- c(trt.colors,rainbow(trts-length(trt.colors)))

    \ \ }

    \ \ 

    \ \ 

    \ \ 

    \ \ plot.lwd = lwd

    \ \ plot.cex = cex

    \ \ if(1 %in% highlight) {

    \ \ \ \ plot.lwd = 1.5*lwd*hcex

    \ \ \ \ if(highlight.point) {

    \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

    \ \ \ \ }

    \ \ }

    \ \ 

    \ \ ret.fit$Mean[1] = mean(trt.data$values,na.rm=TRUE)

    \ \ ret.fit$SD[1] = sd(trt.data$values,na.rm=TRUE)

    \ \ 

    \ \ if(segments) {

    \ \ \ \ plot(values ~ trial.mean,trt.data,

    \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

    \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

    \ \ \ \ \ \ \ \ \ xlog=xlog,

    \ \ \ \ \ \ \ \ \ ylog=ylog,

    \ \ \ \ \ \ \ \ \ bg=bg,

    \ \ \ \ \ \ \ \ \ #main=main,

    \ \ \ \ \ \ \ \ \ #sub=subtitle,

    \ \ \ \ \ \ \ \ \ col=trt.colors[1],

    \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

    \ \ \ \ \ \ \ \ \ axes=FALSE,

    \ \ \ \ \ \ \ \ \ #las=1,

    \ \ \ \ \ \ \ \ \ #font.main=style.main,

    \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

    \ \ \ \ \ \ \ \ \ col.axis=col.axis,

    \ \ \ \ \ \ \ \ \ col.lab=col.lab,

    \ \ \ \ \ \ \ \ \ xlab=xlab,

    \ \ \ \ \ \ \ \ \ ylab=ylab,

    \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

    \ \ \ \ \ \ \ \ \ cex=plot.cex,

    \ \ \ \ \ \ \ \ \ asp=1

    \ \ \ \ )

    \ \ } else {

    \ \ \ \ plot(values ~ trial.mean,trt.data,

    \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

    \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

    \ \ \ \ \ \ \ \ \ xlog=xlog,

    \ \ \ \ \ \ \ \ \ ylog=ylog,

    \ \ \ \ \ \ \ \ \ bg=bg,

    \ \ \ \ \ \ \ \ \ #main=main,

    \ \ \ \ \ \ \ \ \ #sub=subtitle,

    \ \ \ \ \ \ \ \ \ col=trt.colors[1],

    \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

    \ \ \ \ \ \ \ \ \ axes=FALSE,

    \ \ \ \ \ \ \ \ \ #las=1,

    \ \ \ \ \ \ \ \ \ #font.main=style.main,

    \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

    \ \ \ \ \ \ \ \ \ col.axis=col.axis,

    \ \ \ \ \ \ \ \ \ col.lab=col.lab,

    \ \ \ \ \ \ \ \ \ xlab=xlab,

    \ \ \ \ \ \ \ \ \ ylab=ylab,

    \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

    \ \ \ \ \ \ \ \ \ cex=plot.cex

    \ \ \ \ )

    \ \ }

    \;

    \ \ title(main,

    \ \ \ \ \ \ \ \ family=family.main,

    \ \ \ \ \ \ \ \ col.main=col.main)

    \ \ box(bg=bg,fg=fg)

    \ \ axis(1,tcl=0.02,mgp = c(0, .5, 0),las=1,

    \ \ \ \ \ \ \ las=left.las,

    \ \ \ \ \ \ \ col.axis=col.axis,

    \ \ \ \ \ \ \ xlog=xlog,

    \ \ \ \ \ \ \ ylog=ylog,

    \ \ \ \ \ \ \ family=family.axis,

    \ \ \ \ \ \ \ )

    \ \ axis(2,tcl=0.02,mgp = c(0, .5, 0),las=1,

    \ \ \ \ \ \ \ las=left.las,

    \ \ \ \ \ \ \ col.axis=col.axis,

    \ \ \ \ \ \ \ xlog=xlog,

    \ \ \ \ \ \ \ ylog=ylog,

    \ \ \ \ \ \ \ family=family.axis,

    \ \ \ \ \ \ \ )

    \;

    \ \ #draw legend first so it is in the background

    \ \ if(length(legend.labels)\<less\>trts) {

    \ \ \ \ legend.labels \<less\>- c(legend.labels,
    as.character((length(legend.labels)+1):trts))

    \ \ \ \ #legend.labels \<less\>- c(legend.labels, trt.levels)

    \ \ }

    \ \ if(show.legend) {

    \ \ \ \ current.family = par("family")

    \ \ \ \ par(family=family.legend)

    \ \ \ \ legend((min.x+(legend.x*(max.x-min.x))),\ 

    \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.y*(max.y-min.y))),\ 

    \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

    \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

    \ \ \ \ \ \ \ \ \ \ \ #family=family.legend,

    \ \ \ \ \ \ \ \ \ \ \ text.font=style.legend,

    \ \ \ \ \ \ \ \ \ \ \ ncol = legend.columns,

    \ \ \ \ \ \ \ \ \ \ \ col = trt.colors)

    \ \ \ \ par(family=current.family)

    \ \ }

    \ \ 

    \ \ #text(means.vector[1],min.y+(max.y-min.y)/6,names(means.vector[1]),srt=90)

    \ \ 

    \ \ if(regression) {

    \ \ \ \ if(poly==1) {

    \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

    \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

    \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1,1]

    \ \ \ \ \ \ #ret.fit$R2[1] = sum.lm$r.squared

    \ \ \ \ \ \ #ret.fit$AdjR2[1] = sum.lm$adj.r.squared

    \ \ \ \ \ \ #ret.fit$PSlope[1] = sum.lm$coefficients[2,4]

    \ \ \ \ \ \ 

    \ \ \ \ \ \ #fit trial adjusted means

    \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

    \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

    \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

    \ \ \ \ \ \ ret.fit$b[1] = fw.coef[2,1]

    \ \ \ \ \ \ ret.fit$Pb[1] = fw.coef[2,4]

    \ \ \ \ \ \ ret.fit$bR2[1] = sum.fw$r.squared

    \ \ \ \ } else {

    \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
    I(trial.mean^2),trt.data)

    \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
    fitted(trt.lm)[order(trt.data$trial.mean)],
    lty=1,lwd=plot.lwd,col=trt.colors[1])\ 

    \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

    \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1]

    \ \ \ \ \ \ #ret.fit$R2[1] = sum.lm$r.squared

    \ \ \ \ \ \ #ret.fit$AdjR2[1] = sum.lm$adj.r.squared\ 

    \ \ \ \ }

    \ \ \ \ 

    \ \ \ \ if(inverse.regression) {

    \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

    \ \ \ \ \ \ lines(predict(xy.lm), trt.data$values,lty=1,lwd=plot.lwd,
    col=trt.colors[1])

    \ \ \ \ }

    \ \ \ \ if(pc.regression) {

    \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

    \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])

    \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
    -xy.pc$center, scale = FALSE)

    \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

    \ \ \ \ \ \ points(transformed, pch=trt.pch[1],col=trt.colors[1], cex =
    0.5)

    \ \ \ \ }

    \ \ \ \ if(segments) {

    \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
    transformed[,2])

    \ \ \ \ }

    \ \ }

    \ \ 

    \ \ for(trt in 2:trts) {

    \ \ \ \ plot.lwd = lwd

    \ \ \ \ plot.cex = cex

    \ \ \ \ if(trt %in% highlight) {

    \ \ \ \ \ \ plot.lwd = 1.5*lwd*hcex

    \ \ \ \ \ \ if(highlight.point) {

    \ \ \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==trt)

    \ \ \ \ trt.data \<less\>- subset(trt.data,!is.na(trt.data$values))

    \ \ \ \ 

    \ \ \ \ ret.fit$Mean[trt] = mean(trt.data$values,na.rm=TRUE)

    \ \ \ \ ret.fit$SD[trt] = sd(trt.data$values,na.rm=TRUE)

    \ \ \ \ 

    \ \ \ \ trt.idx = as.numeric(trt)

    \ \ \ \ current.pch \<less\>- trt.pch[trt.idx]

    \ \ \ \ points(values ~ trial.mean,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,cex=plot.cex)

    \ \ \ \ if(regression) {

    \ \ \ \ \ \ if(poly==1) {

    \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

    \ \ \ \ \ \ \ \ #trt.coef \<less\>- coef(trt.lm)

    \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    \ \ \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=as.numeric(trt),col=trt.colors[trt],lwd=plot.lwd)

    \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

    \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

    \ \ \ \ \ \ \ \ #ret.fit$R2[trt] = sum.lm$r.squared

    \ \ \ \ \ \ \ \ #ret.fit$AdjR2[trt] = sum.lm$adj.r.squared

    \ \ \ \ \ \ \ \ #ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

    \ \ \ \ \ \ \ \ 

    \ \ \ \ \ \ \ \ #fit trial adjusted means

    \ \ \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

    \ \ \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

    \ \ \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

    \ \ \ \ \ \ \ \ ret.fit$b[trt] = fw.coef[2,1]

    \ \ \ \ \ \ \ \ ret.fit$Pb[trt] = fw.coef[2,4]

    \ \ \ \ \ \ \ \ ret.fit$bR2[trt] = sum.fw$r.squared

    \ \ \ \ \ \ \ \ 

    \ \ \ \ \ \ } else {

    \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
    I(trial.mean^2),trt.data)

    \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    \ \ \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
    fitted(trt.lm)[order(trt.data$trial.mean)],
    lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])\ 

    \ \ \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

    \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

    \ \ \ \ \ \ \ \ #ret.fit$R2[trt] = sum.lm$r.squared

    \ \ \ \ \ \ \ \ #ret.fit$AdjR2[trt] = sum.lm$adj.r.squared\ 

    \ \ \ \ \ \ \ \ #ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ \ \ if(inverse.regression) {

    \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

    \ \ \ \ \ \ inv.coef \<less\>- xy.lm$coefficients

    \ \ \ \ \ \ abline(-(inv.coef[1]/inv.coef[2]),(1/inv.coef[2]),lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])

    \ \ \ \ \ \ #lines(predict(xy.lm), trt.data$values, lty=as.numeric(trt),
    lwd=plot.lwd, col=trt.colors[trt])

    \ \ \ \ }

    \ \ \ \ if(pc.regression) {

    \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

    \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])

    \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
    -xy.pc$center, scale = FALSE)

    \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

    \ \ \ \ \ \ points(transformed, pch=trt.pch[trt],col=trt.colors[trt], cex
    = 0.5)

    \ \ \ \ }

    \ \ \ \ if(segments) {

    \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
    transformed[,2])

    \ \ \ \ }

    \ \ }

    \ \ 

    \ \ if(length(mark.int)\<gtr\>0) {

    \ \ \ \ for(idx in 1:length(mark.int)) {

    \ \ \ \ \ \ pair \<less\>- mark.int[[idx]]

    \ \ \ \ \ \ trt \<less\>- pair[1]

    \ \ \ \ \ \ trial \<less\>- pair[2]

    \ \ \ \ \ \ y \<less\>- means.matrix[trial,trt]

    \ \ \ \ \ \ x \<less\>- means.vector[trial]

    \ \ \ \ \ \ current.pch \<less\>- trt.pch[trt]

    \ \ \ \ \ \ #points(x,y,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,)

    \ \ \ \ \ \ points(x,y,cex=plot.cex*2)

    \ \ \ \ }

    \ \ }

    \ \ 

    \ \ if(plot.unity) {

    \ \ \ \ abline(0,1,col="gray",lwd=2)

    \ \ \ \ if(length(tukey.coeffs)\<gtr\>0) {

    \ \ \ \ \ \ max.a \<less\>- max(ret.fit$Mean)-mean(ret.fit$Mean)

    \ \ \ \ \ \ min.a \<less\>- min(ret.fit$Mean)-mean(ret.fit$Mean)

    \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
    tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dashed")

    \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
    tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dashed")

    \ \ \ \ \ \ #abline(tukey.coeffs[2]*max.a, (1 +
    tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

    \ \ \ \ \ \ #abline(tukey.coeffs[2]*min.a, (1 +
    tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

    \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
    tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

    \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
    tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

    \ \ \ \ }

    \ \ }

    \;

    \ \ #tdf=nonadditivity.gei(means.table,response="values",

    \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TreatmentName="TrtNo",

    \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TrialName="Trial.ID")

    \ \ #het=heterogeneity.gei(means.table,response="values",

    \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TreatmentName="TrtNo",

    \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TrialName="Trial.ID")

    \ \ #return(list(data=means.table,fit=ret.fit,tdf=tdf,het=het))

    \ \ return(list(data=means.table,fit=ret.fit))

    }

    \;

    plot.clusters.ARMST \<less\>- function(means.matrix,\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ means.vector,\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlab="",\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylab="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ main="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.axis="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.lab="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.main="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.sub="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fg="black",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bg="white",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlog=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #style.lab=1,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #style.axis=1,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #family.lab="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.axis="",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pt.lab=12,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pt.axis=12,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cex=1.0,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ verbose=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ method="complete",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fixed.prop=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cld=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.colors=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ leaf.colors=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ use.colors=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ plot.names=c(),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ add=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ reference=NULL,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mark.nodes=FALSE,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cutoff=1.25)
    {

    \ \ 

    \ \ means.hc \<less\>- hclust(dist(means.matrix),method=method)

    \ \ ref.hc \<less\>- NULL

    \ \ has.ref \<less\>- !is.null(reference)

    \ \ matched.idx \<less\>- NULL

    \ \ if(has.ref) {

    \ \ \ \ ref.hc \<less\>- hclust(dist(reference),method=method)

    \ \ \ \ matched.idx \<less\>- compare.merges(means.hc$merge,ref.hc$merge)

    \ \ }

    \ \ wt = 2

    \ \ 

    \ \ #determine clusters

    \ \ x.clfl\<less\>-means.hc$height

    \ \ #assign the fusion levels

    \ \ x.clm\<less\>-mean(x.clfl)

    \ \ #compute the means

    \ \ x.cls\<less\>-sqrt(var(x.clfl))

    \ \ #compute the standard deviation

    \ \ x.score \<less\>- ((x.clfl-x.clm)/x.cls)

    \ \ #Mojena(1977)2.75\<less\>k\<less\>3.5

    \ \ #Milligan and Cooper (1985) k=1.25

    \ \ extra \<less\>- x.score[x.score\<less\>cutoff]

    \ \ clusters \<less\>- cutree(means.hc,h=x.clfl[length(extra)-1])

    \ \ 

    \ \ if(length(leaf.colors)==0) {

    \ \ \ \ if(length(trt.colors)\<less\>max(clusters)) {

    \ \ \ \ \ \ trt.colors \<less\>- c(trt.colors,rainbow(max(clusters)-length(trt.colors)))

    \ \ \ \ }

    \ \ \ \ #trt.colors \<less\>- rainbow(max(clusters))

    \ \ \ \ leaf.colors = trt.colors[clusters]

    \ \ } else if (length(leaf.colors)\<less\>length(clusters)) {

    \ \ \ \ leaf.colors = leaf.colors[clusters]

    \ \ }

    \ \ 

    \ \ min.x \<less\>- min(means.vector,na.rm=TRUE)

    \ \ max.x \<less\>- max(means.vector,na.rm=TRUE)

    \ \ 

    \ \ if(fixed.prop) {

    \ \ \ \ min.y \<less\>- min(means.matrix,na.rm=TRUE)

    \ \ \ \ max.y \<less\>- max(means.matrix,na.rm=TRUE)

    \ \ \ \ min.x \<less\>- min(c(min.x,min.y))

    \ \ \ \ max.x \<less\>- max(c(max.x,max.y))

    \ \ }

    \ \ 

    \ \ min.hc.y \<less\>- min(means.hc$height)

    \ \ max.hc.y \<less\>- max(means.hc$height)

    \ \ min.hc.y \<less\>- 0

    \ \ #print(min.hc.y)

    \ \ base \<less\>- max.hc.y

    \ \ ceiling \<less\>- min.hc.y

    \;

    \ \ #add space

    \ \ required.height = max.hc.y

    \;

    \ \ max.hc.y = max.hc.y+0.2*required.height

    \ \ min.hc.y = 0-0.2*required.height

    \;

    \ \ #if we want to include cld, change required height

    \ \ if(length(cld)\<gtr\>0) {

    \ \ \ \ max.hc.y = max.hc.y+0.3*required.height

    \ \ }

    \ \ if(!add) {

    \ \ \ \ plot(1, type="n", axes=F, xlab=xlab, ylab=ylab,

    \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x), ylim=c(min.hc.y,max.hc.y),cex=cex,

    \ \ \ \ \ \ \ \ \ col.axis=col.axis,

    \ \ \ \ \ \ \ \ \ col.lab=col.lab,

    \ \ \ \ \ \ \ \ \ col.main=col.main,

    \ \ \ \ \ \ \ \ \ xlog=xlog

    \ \ \ \ \ \ \ \ \ #font.lab=style.axis,font.lab=style.axis,

    \ \ \ \ \ \ \ \ \ #family=family.axis

    \ \ \ \ )

    \ \ \ \ 

    \ \ \ \ label.cex = cex

    \ \ \ \ if(length(cld)\<gtr\>0) {

    \ \ \ \ \ \ label.cex = cex*0.9

    \ \ \ \ }

    \ \ \ \ if(length(leaf.colors)\<less\>length(means.vector)) {

    \ \ \ \ \ \ leaf.colors \<less\>- c(leaf.colors,rep(col.axis,length(means.vector)-length(leaf.colors)))

    \ \ \ \ }

    \ \ \ \ for(trial in 1:length(means.vector)) {

    \ \ \ \ \ \ n.text = as.character(trial)

    \ \ \ \ \ \ if(length(plot.names)\<gtr\>0) {

    \ \ \ \ \ \ \ \ n.text \<less\>- plot.names[trial]

    \ \ \ \ \ \ }

    \ \ \ \ \ \ if(use.colors) {

    \ \ \ \ \ \ \ \ text(means.vector[trial],base+0.08*required.height,n.text,col=leaf.colors[trial],family=family.axis,cex=label.cex)

    \ \ \ \ \ \ } else {

    \ \ \ \ \ \ \ \ text(means.vector[trial],base+0.08*required.height,n.text,family=family.axis,cex=label.cex)

    \ \ \ \ \ \ }

    \ \ \ \ \ \ 

    \ \ \ \ }

    \ \ \ \ if(length(cld)\<gtr\>0) {

    \ \ \ \ \ \ for(l in 1:length(cld)) {

    \ \ \ \ \ \ \ \ text(means.vector[l],base+0.28*required.height,cld[l],col=col.axis,family=family.axis,cex=label.cex*0.8)

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ }

    \ \ 

    \ \ rows \<less\>- dim(means.hc$merge)[1]

    \ \ endpoints \<less\>- matrix(0,nrow=rows,ncol=4)

    \ \ 

    \ \ #plot horizontal lines

    \ \ max.plotted.y = 0

    \ \ for (row in 1:rows) {

    \ \ \ \ current.pair \<less\>- means.hc$merge[row,]

    \ \ \ \ current.distance \<less\>- means.hc$height[row]

    \ \ 

    \ \ \ \ y \<less\>- c(current.distance,current.distance)

    \;

    \ \ \ \ x \<less\>- hc.xpoints(row, means.hc, means.vector)

    \ \ \ \ #print(x) #x's look correct

    \ \ \ \ y \<less\>- base - y #+ (base/10)

    \ \ \ \ #print(y)

    \ \ \ \ if(max(y)\<gtr\>max.plotted.y) {

    \ \ \ \ \ \ max.plotted.y \<less\>- max(y)

    \ \ \ \ }

    \ \ \ \ endpoints[row,1] \<less\>- x[1]

    \ \ \ \ endpoints[row,2] \<less\>- y[1]

    \ \ \ \ endpoints[row,3] \<less\>- x[2]

    \ \ \ \ endpoints[row,4] \<less\>- y[2]

    \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    \ \ \ \ if(has.ref) {

    \ \ \ \ \ \ if(matched.idx[row] == 0) {

    \ \ \ \ \ \ \ \ current.clfl\<less\>-means.hc$height[row]

    \ \ \ \ \ \ \ \ #compute the standard deviation

    \ \ \ \ \ \ \ \ x.score \<less\>- (current.clfl/x.cls)\ 

    \ \ \ \ \ \ \ \ 

    \ \ \ \ \ \ \ \ #ratio = x.score #means.hc$height[row]/ref.hc$height[matched.idx[row]]

    \ \ \ \ \ \ \ \ #if((ratio\<gtr\>3) \|\| (ratio\<less\>0.3)) {

    \ \ \ \ \ \ \ \ if(mark.nodes) {

    \ \ \ \ \ \ \ \ \ \ if(x.score\<gtr\>cutoff) {

    \ \ \ \ \ \ \ \ \ \ \ \ mid \<less\>- c(x[1]+(x[2]-x[1])/2,y[1])

    \ \ \ \ \ \ \ \ \ \ \ \ #points(xy.coords(x,y))

    \ \ \ \ \ \ \ \ \ \ \ \ plot.xy(xy.coords(mid[1],mid[2]),type="p",lwd=wt,col=fg)

    \ \ \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ }

    \ \ \ \ \ \ #means.hc$height

    \ \ \ \ \ \ #res3$means.hc$height

    \ \ \ \ \ \ #ref.hc$height[matched.idx]

    \ \ \ \ }

    \ \ }

    \ \ 

    \ \ if(verbose) {

    \ \ \ \ print("endpoints")

    \ \ \ \ print(endpoints)

    \ \ }

    \ \ for (row in 2:rows) {

    \ \ \ \ current.pair \<less\>- means.hc$merge[row,] \ \ \ 

    \ \ \ \ x \<less\>- c(endpoints[row,1],endpoints[row,1])

    \ \ \ \ #scan for crossing point

    \ \ \ \ inner.row = row-1

    \ \ \ \ x.bound = endpoints[row,1]

    \ \ \ \ while(inner.row\<gtr\>1) {

    \ \ \ \ \ \ if( (endpoints[inner.row,1]\<less\>x.bound &&
    endpoints[inner.row,3]\<gtr\>x.bound) \ \|\|

    \ \ \ \ \ \ \ \ (endpoints[inner.row,1]\<gtr\>x.bound &&
    endpoints[inner.row,3]\<less\>x.bound) ) {

    \ \ \ \ \ \ \ \ #this point is on either side of our x, so we will

    \ \ \ \ \ \ \ \ #cross this line

    \ \ \ \ \ \ \ \ break;

    \ \ \ \ \ \ }

    \ \ \ \ \ \ inner.row = inner.row-1

    \ \ \ \ }

    \;

    \ \ \ \ y \<less\>- c(endpoints[row,2],endpoints[inner.row,2])

    \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    \ \ \ \ 

    \ \ \ \ x \<less\>- c(endpoints[row,3],endpoints[row,3])

    \ \ \ \ inner.row = row-1

    \ \ \ \ x.bound = endpoints[row,3]

    \ \ \ \ while(inner.row\<gtr\>1) {

    \ \ \ \ \ \ if((endpoints[inner.row,1]\<less\>x.bound &&
    endpoints[inner.row,3]\<gtr\>x.bound) \|\|

    \ \ \ \ \ \ \ \ \ \ \ endpoints[inner.row,1]\<gtr\>x.bound &&
    endpoints[inner.row,3]\<less\>x.bound) {

    \ \ \ \ \ \ \ \ #this point is on either side of our x, so we will

    \ \ \ \ \ \ \ \ #cross this line

    \ \ \ \ \ \ \ \ break;

    \ \ \ \ \ \ }

    \ \ \ \ \ \ inner.row = inner.row-1

    \ \ \ \ }

    \ \ \ \ 

    \ \ \ \ y \<less\>- c(endpoints[row,4],endpoints[inner.row,4])

    \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    \ \ }

    \ \ 

    \ \ for(trial in 1:length(means.vector)) {

    \ \ \ \ x = c(means.vector[trial],means.vector[trial])

    \ \ \ \ y = c(max.plotted.y, base-0.04*required.height) #c(max.plotted.y,
    base+0.06*required.height)

    \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    \ \ }

    \;

    \ \ return(list(means.hc=means.hc,

    \ \ \ \ \ \ \ \ \ clusters=clusters,

    \ \ \ \ \ \ \ \ \ score=x.score,

    \ \ \ \ \ \ \ \ \ cls = x.cls

    \ \ \ \ \ \ \ \ \ ))

    }

    \;

    hc.midpoint \<less\>- function(row, hc, means) {

    \ \ hc.pair \<less\>- hc$merge[row,]

    \ \ x1 \<less\>- 0

    \ \ x2 \<less\>- 0

    \ \ if(hc.pair[1]\<gtr\>0) {

    \ \ \ \ x1 \<less\>- hc.midpoint(hc.pair[1],hc,means)

    \ \ } else {

    \ \ \ \ x1 \<less\>- means[-hc.pair[1]]

    \ \ }

    \ \ if(hc.pair[2]\<gtr\>0) {

    \ \ \ \ x2 \<less\>- hc.midpoint(hc.pair[2],hc,means)

    \ \ } else {

    \ \ \ \ x2 \<less\>- means[-hc.pair[2]]

    \ \ }

    \ \ return((x1+x2)/2)

    }

    \;

    hc.xpoints \<less\>- function(row, hc, means) {

    \ \ hc.pair \<less\>- hc$merge[row,]

    \ \ x1 \<less\>- 0

    \ \ x2 \<less\>- 0

    \ \ if(hc.pair[1]\<gtr\>0) {

    \ \ \ \ x1 \<less\>- hc.midpoint(hc.pair[1],hc,means)

    \ \ } else {

    \ \ \ \ x1 \<less\>- means[-hc.pair[1]]

    \ \ }

    \ \ if(hc.pair[2]\<gtr\>0) {

    \ \ \ \ x2 \<less\>- hc.midpoint(hc.pair[2],hc,means)

    \ \ } else {

    \ \ \ \ x2 \<less\>- means[-hc.pair[2]]

    \ \ }

    \ \ return(c(x1,x2))

    }

    \;

    \;

    compare.merges \<less\>- function(merge1,merge2) {

    \ \ dim1 \<less\>- dim(merge1)

    \ \ dim2 \<less\>- dim(merge2)

    \ \ matched \<less\>- rep(0,dim1[1])

    \ \ if(dim1[1]==dim2[1]) {

    \ \ \ \ for(idx1 in 1:dim1[1]) {

    \ \ \ \ \ \ for(idx2 in 1:dim2[1]) {

    \ \ \ \ \ \ \ \ if((merge1[idx1,1]==merge2[idx2,1]) &&
    (merge1[idx1,2]==merge2[idx2,2]) \|\|

    \ \ \ \ \ \ \ \ \ \ \ (merge2[idx2,1]==merge1[idx1,1]) &&
    (merge2[idx2,2])==merge1[idx1,2]) {

    \ \ \ \ \ \ \ \ \ \ matched[idx1]=idx2

    \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ }

    \ \ return(matched)

    }
  <|unfolded-io>
    plot.interaction.ARMST \<less\>- function(means.matrix,\ 

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ means.vector,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylab="",

    Error: unexpected string constant in:

    " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ means.vector,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylab=""

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlab="",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlab="","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ main="",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ main="","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ regression=TRUE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ regression=TRUE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ show.legend=FALSE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ show.legend=FALSE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.colors=c(),

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.colors=c(),"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.labels=NA,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.labels=NA,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.labels=c(),

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.labels=c(),"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.columns=1,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.columns=1,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ style.legend=1,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ style.legend=1,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.main="",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.main="","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #family.lab="",

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.axis="",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.axis="","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.legend="",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.legend="","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.axis="black",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.axis="black","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.lab="black",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.lab="black","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.main="black",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.main="black","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.sub="black",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.sub="black","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fg="black",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fg="black","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bg="white",

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bg="white","

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ left.las=0,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ left.las=0,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ min.y=NA,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ min.y=NA,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ max.y=NA,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ max.y=NA,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylog=FALSE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylog=FALSE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlog=FALSE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlog=FALSE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.pos=c(.90,.55),

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ legend.pos=c(.90,.55),"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lwd
    = 3,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lwd
    = 3,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cex=1.0,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cex=1.0,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight=c(),

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight=c(),"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hcex=1.5,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hcex=1.5,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fixed.prop=FALSE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fixed.prop=FALSE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ poly=1,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ poly=1,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mark.int
    = c(),

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mark.int
    = c(),"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ plot.unity=FALSE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ plot.unity=FALSE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight.point=TRUE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ highlight.point=TRUE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ tukey.coeffs=c(),

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ tukey.coeffs=c(),"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ inverse.regression=FALSE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ inverse.regression=FALSE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pc.regression=FALSE,

    Error: unexpected ',' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pc.regression=FALSE,"

    \<gtr\> \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ segments=FALSE)
    {

    Error: unexpected ')' in " \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ segments=FALSE)"

    \<gtr\> \ \ legend.x = legend.pos[1]

    Error: object 'legend.pos' not found

    \<gtr\> \ \ legend.y = legend.pos[2]

    Error: object 'legend.pos' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ # use this to force means table to use numeric names. This
    assumes

    \<gtr\> \ \ # means are in correct numeric order (Jun 9 15, PMC)

    \<gtr\> \ \ colnames(means.matrix) \<less\>-
    as.character(1:dim(means.matrix)[2])

    Error: object 'means.matrix' not found

    \<gtr\> \ \ rownames(means.matrix) \<less\>-
    as.character(1:dim(means.matrix)[1])

    Error: object 'means.matrix' not found

    \<gtr\> \ \ names(means.vector) \<less\>-
    as.character(1:dim(means.matrix)[1])

    Error: object 'means.matrix' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ means.table \<less\>- data.frame(stack(means.matrix))

    Error in stack(means.matrix) : object 'means.matrix' not found

    \<gtr\> \ 

    \<gtr\> \ \ means.table$TrtNo \<less\>-
    as.numeric(as.character(means.table$ind))

    Error: object 'means.table' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ trts \<less\>- dim(means.matrix)[2]

    Error: object 'means.matrix' not found

    \<gtr\> \ \ trials \<less\>- dim(means.matrix)[1]

    Error: object 'means.matrix' not found

    \<gtr\> \ \ trt.levels \<less\>- levels(means.table$ind)

    Error in levels(means.table$ind) : object 'means.table' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ #we'll return a data table with one row for each treatment.

    \<gtr\> \ \ #this table will include the slope, intercept and other stats
    to be added

    \<gtr\> \ \ ret.fit \<less\>- data.frame(

    + \ \ \ \ Treatment = 1:trts,

    + \ \ \ \ Slope = rep(NA,trts),

    + \ \ \ \ Intercept = rep(NA,trts),

    + \ \ \ \ #R2 = rep(NA,trts),

    + \ \ \ \ #AdjR2 = rep(NA,trts),

    + \ \ \ \ Mean = rep(NA,trts),

    + \ \ \ \ SD = rep(NA,trts),

    + \ \ \ \ #PSlope = rep(NA,trts),

    + \ \ \ \ b = rep(NA,trts),

    + \ \ \ \ Pb = rep(NA,trts),

    + \ \ \ \ bR2 = rep(NA,trts)

    + \ \ \ \ )

    Error in data.frame(Treatment = 1:trts, Slope = rep(NA, trts), Intercept
    = rep(NA, \ :\ 

    \ \ object 'trts' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ means.table$Trial.ID \<less\>-
    rep(rownames(means.matrix),trts)

    Error in rownames(means.matrix) : object 'means.matrix' not found

    \<gtr\> \ \ means.table$Trial.idx \<less\>- rep(1:trials,trts)

    Error: object 'trts' not found

    \<gtr\> \ \ means.table$trial.mean \<less\>-
    means.vector[means.table$Trial.idx]

    Error: object 'means.vector' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ #center on trial mean

    \<gtr\> \ \ means.table$centered \<less\>- means.table$values -
    means.vector[means.table$Tri

    \<less\> means.table$values - means.vector[means.table$Trial.idx]

    Error: object 'means.table' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ if(is.na(min.y)){

    + \ \ \ \ min.y \<less\>- min(means.table$values,na.rm=TRUE)

    + \ \ }

    Error: object 'min.y' not found

    \<gtr\> \ \ if(is.na(max.y)){

    + \ \ \ \ max.y \<less\>- max(means.table$values,na.rm=TRUE)

    + \ \ }

    Error: object 'max.y' not found

    \<gtr\> \ \ min.x \<less\>- min(means.table$trial.mean,na.rm=TRUE)

    Error: object 'means.table' not found

    \<gtr\> \ \ max.x \<less\>- max(means.table$trial.mean,na.rm=TRUE)

    Error: object 'means.table' not found

    \<gtr\> \ \ if(fixed.prop) {

    + \ \ \ \ min.x \<less\>- min(c(min.x,min.y))

    + \ \ \ \ max.x \<less\>- max(c(max.x,max.y))

    + \ \ \ \ min.y \<less\>- min.x

    + \ \ \ \ max.y \<less\>- max.x

    + \ \ }

    Error: object 'fixed.prop' not found

    \<gtr\> \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==1)

    Error in subset(means.table, means.table$TrtNo == 1) :\ 

    \ \ object 'means.table' not found

    \<gtr\> \ \ if(length(trt.colors)\<less\>trts) {

    + \ \ \ \ trt.colors \<less\>- c(trt.colors,rainbow(trts-length(trt.colors)))

    + \ \ }

    Error: object 'trt.colors' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ trt.pch = 1:trts

    Error: object 'trts' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ #pch 26:31 are unused, so add six if larger

    \<gtr\> \ \ if(trts\<gtr\>25) {

    + \ \ \ \ trt.pch[trt.pch\<gtr\>25] \<less\>- trt.pch[trt.pch\<gtr\>25] +
    7

    + \ \ }

    Error: object 'trts' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ plot.lwd = lwd

    Error: object 'lwd' not found

    \<gtr\> \ \ plot.cex = cex

    Error: object 'cex' not found

    \<gtr\> \ \ if(1 %in% highlight) {

    + \ \ \ \ plot.lwd = 1.5*lwd*hcex

    + \ \ \ \ if(highlight.point) {

    + \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

    + \ \ \ \ }

    + \ \ }

    Error in match(x, table, nomatch = 0L) : object 'highlight' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ ret.fit$Mean[1] = mean(trt.data$values,na.rm=TRUE)

    Error in mean(trt.data$values, na.rm = TRUE) :\ 

    \ \ object 'trt.data' not found

    \<gtr\> \ \ ret.fit$SD[1] = sd(trt.data$values,na.rm=TRUE)

    Error in is.data.frame(x) : object 'trt.data' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ if(segments) {

    + \ \ \ \ plot(values ~ trial.mean,trt.data,

    + \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

    + \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

    + \ \ \ \ \ \ \ \ \ xlog=xlog,

    + \ \ \ \ \ \ \ \ \ ylog=ylog,

    + \ \ \ \ \ \ \ \ \ bg=bg,

    + \ \ \ \ \ \ \ \ \ #main=main,

    + \ \ \ \ \ \ \ \ \ #sub=subtitle,

    + \ \ \ \ \ \ \ \ \ col=trt.colors[1],

    + \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

    + \ \ \ \ \ \ \ \ \ axes=FALSE,

    + \ \ \ \ \ \ \ \ \ #las=1,

    + \ \ \ \ \ \ \ \ \ #font.main=style.main,

    + \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

    + \ \ \ \ \ \ \ \ \ col.axis=col.axis,

    + \ \ \ \ \ \ \ \ \ col.lab=col.lab,

    + \ \ \ \ \ \ \ \ \ xlab=xlab,

    + \ \ \ \ \ \ \ \ \ ylab=ylab,

    + \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

    + \ \ \ \ \ \ \ \ \ cex=plot.cex,

    + \ \ \ \ \ \ \ \ \ asp=1

    + \ \ \ \ )

    + \ \ } else {

    + \ \ \ \ plot(values ~ trial.mean,trt.data,

    + \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),\ 

    + \ \ \ \ \ \ \ \ \ ylim=c(min.y,max.y),

    + \ \ \ \ \ \ \ \ \ xlog=xlog,

    + \ \ \ \ \ \ \ \ \ ylog=ylog,

    + \ \ \ \ \ \ \ \ \ bg=bg,

    + \ \ \ \ \ \ \ \ \ #main=main,

    + \ \ \ \ \ \ \ \ \ #sub=subtitle,

    + \ \ \ \ \ \ \ \ \ col=trt.colors[1],

    + \ \ \ \ \ \ \ \ \ pch=trt.pch[1],

    + \ \ \ \ \ \ \ \ \ axes=FALSE,

    + \ \ \ \ \ \ \ \ \ #las=1,

    + \ \ \ \ \ \ \ \ \ #font.main=style.main,

    + \ \ \ \ \ \ \ \ \ #font.lab=style.axis,

    + \ \ \ \ \ \ \ \ \ col.axis=col.axis,

    + \ \ \ \ \ \ \ \ \ col.lab=col.lab,

    + \ \ \ \ \ \ \ \ \ xlab=xlab,

    + \ \ \ \ \ \ \ \ \ ylab=ylab,

    + \ \ \ \ \ \ \ \ \ lwd=plot.lwd,

    + \ \ \ \ \ \ \ \ \ cex=plot.cex

    + \ \ \ \ )

    + \ \ }

    Error in if (segments) { : argument is not interpretable as logical

    \<gtr\>\ 

    \<gtr\> \ \ title(main,

    + \ \ \ \ \ \ \ \ family=family.main,

    + \ \ \ \ \ \ \ \ col.main=col.main)

    Error in as.graphicsAnnot(main) : object 'main' not found

    \<gtr\> \ \ box(bg=bg,fg=fg)

    Error in box(bg = bg, fg = fg) : object 'bg' not found

    \<gtr\> \ \ axis(1,tcl=0.02,mgp = c(0, .5, 0),las=1,

    + \ \ \ \ \ \ \ las=left.las,

    + \ \ \ \ \ \ \ col.axis=col.axis,

    + \ \ \ \ \ \ \ xlog=xlog,

    + \ \ \ \ \ \ \ ylog=ylog,

    + \ \ \ \ \ \ \ family=family.axis,

    + \ \ \ \ \ \ \ )

    Error in axis(1, tcl = 0.02, mgp = c(0, 0.5, 0), las = 1, las = left.las,
    \ :\ 

    \ \ object 'left.las' not found

    \<gtr\> \ \ axis(2,tcl=0.02,mgp = c(0, .5, 0),las=1,

    + \ \ \ \ \ \ \ las=left.las,

    + \ \ \ \ \ \ \ col.axis=col.axis,

    + \ \ \ \ \ \ \ xlog=xlog,

    + \ \ \ \ \ \ \ ylog=ylog,

    + \ \ \ \ \ \ \ family=family.axis,

    + \ \ \ \ \ \ \ )

    Error in axis(2, tcl = 0.02, mgp = c(0, 0.5, 0), las = 1, las = left.las,
    \ :\ 

    \ \ object 'left.las' not found

    \<gtr\>\ 

    \<gtr\> \ \ #draw legend first so it is in the background

    \<gtr\> \ \ if(length(legend.labels)\<less\>trts) {

    + \ \ \ \ legend.labels \<less\>- c(legend.labels,
    as.character((length(legend.labels)+1

    \<less\>gend.labels, as.character((length(legend.labels)+1):trts))

    + \ \ \ \ #legend.labels \<less\>- c(legend.labels, trt.levels)

    + \ \ }

    Error: object 'legend.labels' not found

    \<gtr\> \ \ if(show.legend) {

    + \ \ \ \ current.family = par("family")

    + \ \ \ \ par(family=family.legend)

    + \ \ \ \ legend((min.x+(legend.x*(max.x-min.x))),\ 

    + \ \ \ \ \ \ \ \ \ \ \ (min.y+(legend.y*(max.y-min.y))),\ 

    + \ \ \ \ \ \ \ \ \ \ \ pch=trt.pch,\ 

    + \ \ \ \ \ \ \ \ \ \ \ legend=legend.labels,

    + \ \ \ \ \ \ \ \ \ \ \ #family=family.legend,

    + \ \ \ \ \ \ \ \ \ \ \ text.font=style.legend,

    + \ \ \ \ \ \ \ \ \ \ \ ncol = legend.columns,

    + \ \ \ \ \ \ \ \ \ \ \ col = trt.colors)

    + \ \ \ \ par(family=current.family)

    + \ \ }

    Error: object 'show.legend' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ #text(means.vector[1],min.y+(max.y-min.y)/6,names(means.vector[1]),srt=90

    \<less\>in.y+(max.y-min.y)/6,names(means.vector[1]),srt=90)

    \<gtr\> \ \ 

    \<gtr\> \ \ if(regression) {

    + \ \ \ \ if(poly==1) {

    + \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

    + \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    + \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    + \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    + \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

    + \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1,1]

    + \ \ \ \ \ \ #ret.fit$R2[1] = sum.lm$r.squared

    + \ \ \ \ \ \ #ret.fit$AdjR2[1] = sum.lm$adj.r.squared

    + \ \ \ \ \ \ #ret.fit$PSlope[1] = sum.lm$coefficients[2,4]

    + \ \ \ \ \ \ 

    + \ \ \ \ \ \ #fit trial adjusted means

    + \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

    + \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

    + \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

    + \ \ \ \ \ \ ret.fit$b[1] = fw.coef[2,1]

    + \ \ \ \ \ \ ret.fit$Pb[1] = fw.coef[2,4]

    + \ \ \ \ \ \ ret.fit$bR2[1] = sum.fw$r.squared

    + \ \ \ \ } else {

    + \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
    I(trial.mean^2),trt.data)

    + \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    + \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    + \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
    fitted(trt.lm)[order(trt.data$trial.

    \<less\>$trial.mean), fitted(trt.lm)[order(trt.data$trial.mean)],
    lty=1,lwd=plot.lwd

    \<less\>m)[order(trt.data$trial.mean)],
    lty=1,lwd=plot.lwd,col=trt.colors[1])\ 

    + \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    + \ \ \ \ \ \ ret.fit$Slope[1] = trt.coef[2]

    + \ \ \ \ \ \ ret.fit$Intercept[1] = trt.coef[1]

    + \ \ \ \ \ \ #ret.fit$R2[1] = sum.lm$r.squared

    + \ \ \ \ \ \ #ret.fit$AdjR2[1] = sum.lm$adj.r.squared\ 

    + \ \ \ \ }

    + \ \ \ \ 

    + \ \ \ \ if(inverse.regression) {

    + \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

    + \ \ \ \ \ \ lines(predict(xy.lm), trt.data$values,lty=1,lwd=plot.lwd,
    col=trt.col

    \<less\>), trt.data$values,lty=1,lwd=plot.lwd, col=trt.colors[1])

    + \ \ \ \ }

    + \ \ \ \ if(pc.regression) {

    + \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

    + \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])

    + \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
    -xy.pc$center, scale = FA

    \<less\>e (transformed, center = -xy.pc$center, scale = FALSE)

    + \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    + \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

    + \ \ \ \ \ \ points(transformed, pch=trt.pch[1],col=trt.colors[1], cex =
    0.5)

    + \ \ \ \ }

    + \ \ \ \ if(segments) {

    + \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
    transformed[,2]

    \<less\>,6],trt.data[,1], transformed[,1], transformed[,2])

    + \ \ \ \ }

    + \ \ }

    Error: object 'regression' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ for(trt in 2:trts) {

    + \ \ \ \ plot.lwd = lwd

    + \ \ \ \ plot.cex = cex

    + \ \ \ \ if(trt %in% highlight) {

    + \ \ \ \ \ \ plot.lwd = 1.5*lwd*hcex

    + \ \ \ \ \ \ if(highlight.point) {

    + \ \ \ \ \ \ \ \ plot.cex = plot.cex*hcex*0.8

    + \ \ \ \ \ \ }

    + \ \ \ \ }

    + \ \ \ \ trt.data \<less\>- subset(means.table,means.table$TrtNo==trt)

    + \ \ \ \ trt.data \<less\>- subset(trt.data,!is.na(trt.data$values));;
    \ \ \ 

    + \ \ \ \ ret.fit$Mean[trt] = mean(trt.data$values,na.rm=TRUE)

    + \ \ \ \ ret.fit$SD[trt] = sd(trt.data$values,na.rm=TRUE)

    + \ \ \ \ 

    + \ \ \ \ trt.idx = as.numeric(trt)

    + \ \ \ \ current.pch \<less\>- trt.pch[trt.idx]

    + \ \ \ \ points(values ~ trial.mean,trt.data,pch=current.pch,col=trt.colors[trt]

    \<less\>.mean,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,cex=plot.cex

    \<less\>.pch,col=trt.colors[trt],lwd=plot.lwd,cex=plot.cex)

    + \ \ \ \ if(regression) {

    + \ \ \ \ \ \ if(poly==1) {

    + \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean,trt.data)

    + \ \ \ \ \ \ \ \ #trt.coef \<less\>- coef(trt.lm)

    + \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    + \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    + \ \ \ \ \ \ \ \ abline(trt.coef[1],trt.coef[2],lty=as.numeric(trt),col=trt.colors[t

    \<less\>],trt.coef[2],lty=as.numeric(trt),col=trt.colors[trt],lwd=plot.lwd)

    + \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

    + \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

    + \ \ \ \ \ \ \ \ #ret.fit$R2[trt] = sum.lm$r.squared

    + \ \ \ \ \ \ \ \ #ret.fit$AdjR2[trt] = sum.lm$adj.r.squared

    + \ \ \ \ \ \ \ \ #ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

    + \ \ \ \ \ \ \ \ 

    + \ \ \ \ \ \ \ \ #fit trial adjusted means

    + \ \ \ \ \ \ \ \ fw.lm \<less\>- lm(centered ~ trial.mean, trt.data)

    + \ \ \ \ \ \ \ \ sum.fw \<less\>- summary(fw.lm)

    + \ \ \ \ \ \ \ \ fw.coef \<less\>- sum.fw$coefficients

    + \ \ \ \ \ \ \ \ ret.fit$b[trt] = fw.coef[2,1]

    + \ \ \ \ \ \ \ \ ret.fit$Pb[trt] = fw.coef[2,4]

    + \ \ \ \ \ \ \ \ ret.fit$bR2[trt] = sum.fw$r.squared

    + \ \ \ \ \ \ \ \ 

    + \ \ \ \ \ \ } else {

    + \ \ \ \ \ \ \ \ trt.lm \<less\>- lm(values ~ trial.mean +
    I(trial.mean^2),trt.data)

    + \ \ \ \ \ \ \ \ sum.lm \<less\>- summary(trt.lm)

    + \ \ \ \ \ \ \ \ trt.coef \<less\>- sum.lm$coefficients

    + \ \ \ \ \ \ \ \ lines(sort(trt.data$trial.mean),
    fitted(trt.lm)[order(trt.data$tria

    \<less\>ta$trial.mean), fitted(trt.lm)[order(trt.data$trial.mean)],
    lty=as.numeric(t

    \<less\>.lm)[order(trt.data$trial.mean)],
    lty=as.numeric(trt),lwd=plot.lwd,col=trt.c

    \<less\>mean)], lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])\ 

    + \ \ \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trolors[1

    \<less\>1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    + \ \ \ \ \ \ \ \ ret.fit$Slope[trt] = trt.coef[2,1]

    + \ \ \ \ \ \ \ \ ret.fit$Intercept[trt] = trt.coef[1,1]

    + \ \ \ \ \ \ \ \ #ret.fit$R2[trt] = sum.lm$r.squared

    + \ \ \ \ \ \ \ \ #ret.fit$AdjR2[trt] = sum.lm$adj.r.squared\ 

    + \ \ \ \ \ \ \ \ #ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]

    + \ \ \ \ \ \ }

    + \ \ \ \ }

    + \ \ \ \ if(inverse.regression) {

    + \ \ \ \ \ \ xy.lm \<less\>- lm(trial.mean ~ values,trt.data)

    + \ \ \ \ \ \ inv.coef \<less\>- xy.lm$coefficients

    + \ \ \ \ \ \ abline(-(inv.coef[1]/inv.coef[2]),(1/inv.coef[2]),lty=as.numeric(trt)

    \<less\>]/inv.coef[2]),(1/inv.coef[2]),lty=as.numeric(trt),lwd=plot.lwd,col=trt.colo

    \<less\>[2]),lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])

    + \ \ \ \ \ \ #lines(predict(xy.lm), trt.data$values,
    lty=as.numeric(trt), lwd=plot

    \<less\>m), trt.data$values, lty=as.numeric(trt), lwd=plot.lwd,
    col=trt.colors[trt])

    + \ \ \ \ }

    + \ \ \ \ if(pc.regression) {

    + \ \ \ \ \ \ xy.pc \<less\>- prcomp(trt.data[,c(6,1)])

    + \ \ \ \ \ \ transformed \<less\>- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])

    + \ \ \ \ \ \ transformed \<less\>- scale (transformed, center =
    -xy.pc$center, scale = FA

    \<less\>e (transformed, center = -xy.pc$center, scale = FALSE)

    + \ \ \ \ \ \ #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])

    + \ \ \ \ \ \ lines(transformed, col = "gray", cex = 0.5)

    + \ \ \ \ \ \ points(transformed, pch=trt.pch[trt],col=trt.colors[trt],
    cex = 0.5)

    + \ \ \ \ }

    + \ \ \ \ if(segment{

    + \ \ \ \ \ \ segments (trt.data[,6],trt.data[,1], transformed[,1],
    transformed[,2]

    \<less\>,6],trt.data[,1], transformed[,1], transformed[,2])

    + \ \ \ \ }

    + \ \ }

    Error: object 'trts' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ if(length(mark.int)\<gtr\>0) {

    + \ \ \ \ for(idx in 1:length(mark.int)) {

    + \ \ \ \ \ \ pair \<less\>- mark.int[[idx]]

    + \ \ \ \ \ \ trt \<less\>- pair[1]

    + \ \ \ \ \ \ trial \<less\>- pair[2]

    + \ \ \ \ \ \ y \<less\>- means.matrix[trial,trt]

    + \ \ \ \ \ \ x \<less\>- means.vector[trial]

    + \ \ \ \ \ \ current.pch \<less\>- trt.pch[trt]

    + \ \ \ \ \ \ #points(x,y,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd

    \<less\>a,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,)

    + \ \ \ \ \ \ points(x,y,cex=plot.cex*2)

    + \ \ \ \ }

    + \ \ }

    Error: object 'mark.int' not found

    \<gtr\> \ \ 

    \<gtr\> \ \ if(plot.unity) {

    + \ \ \ \ abline(0,1,col="gray",lwd=2)

    + \ \ \ \ if(length(tukey.coeffs)\<gtr\>0) {

    + \ \ \ \ \ \ max.a \<less\>- max(ret.fit$Mean)-mean(ret.fit$Mean)

    + \ \ \ \ \ \ min.a \<less\>- min(ret.fit$Mean)-mean(ret.fit$Mean)

    + \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
    tukey.coeffs[2]*max.a),col="gray",lwd=2,

    \<less\>[1], (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dashed")

    + \ \ \ \ \ \ abline(tukey.coeffs[1], (1 +
    tukey.coeffs[2]*min.a),col="gray",lwd=2,

    \<less\>[1], (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dashed")

    + \ \ \ \ \ \ #abline(tukey.coeffs[2]*max.a, (1 +
    tukey.coeffs[2]*max.a),col="gray"

    \<less\>s[2]*max.a, (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

    + \ \ \ \ \ \ #abline(tukey.coeffs[2]*min.a, (1 +
    tukey.coeffs[2]*min.a),col="gray"

    \<less\>s[2]*min.a, (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

    + \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
    tukey.coeffs[2]*max.a

    \<less\>[2]*mean(ret.fit$Mean), (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="do

    \<less\> + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")

    + \ \ \ \ \ \ abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 +
    tukey.coeffs[2]*min.a

    \<less\>[2]*mean(ret.fit$Mean), (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="do

    \<less\> + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")

    + \ \ \ \ }

    + \ \ }

    Error: object 'plot.unity' not found

    \<gtr\>\ 

    \<gtr\> \ \ #tdf=nonadditivity.gei(means.table,response="values",

    \<gtr\> \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TreatmentName="TrtNo",

    \<gtr\> \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TrialName="Trial.ID")

    \<gtr\> \ \ #het=heterogeneity.gei(means.table,response="values",

    \<gtr\> \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TreatmentName="TrtNo",

    \<gtr\> \ \ # \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TrialName="Trial.ID")

    \<gtr\> \ \ #return(list(data=means.table,fit=ret.fit,tdf=tdf,het=het))

    \<gtr\> \ \ return(list(data=means.table,fit=ret.fit))

    Error: object 'means.table' not found

    \<gtr\> }

    Error: unexpected '}' in "}"

    \<gtr\>\ 

    \<gtr\> plot.clusters.ARMST \<less\>- function(means.matrix,\ 

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ means.vector,\ 

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlab="",\ 

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ylab="",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ main="",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.axis="black",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.lab="black",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.main="black",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ col.sub="black",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fg="black",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bg="white",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ xlog=FALSE,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #style.lab=1,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #style.axis=1,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ #family.lab="",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ family.axis="",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pt.lab=12,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ pt.axis=12,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cex=1.0,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ verbose=FALSE,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ method="complete",

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fixed.prop=FALSE,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cld=c(),

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ trt.colors=c(),

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ leaf.colors=c(),

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ use.colors=FALSE,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ plot.names=c(),

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ add=FALSE,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ reference=NULL,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mark.nodes=FALSE,

    + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ cutoff=1.25)
    {

    + \ \ 

    + \ \ means.hc \<less\>- hclust(dist(means.matrix),method=method)

    + \ \ ref.hc \<less\>- NULL

    + \ \ has.ref \<less\>- !is.null(reference)

    + \ \ matched.idx \<less\>- NULL

    + \ \ if(has.ref) {

    + \ \ \ \ ref.hc \<less\>- hclust(dist(reference),method=method)

    + \ \ \ \ matched.idx \<less\>- compare.merges(means.hc$merge,ref.hc$merge)

    + \ \ }

    + \ \ wt = 2

    + \ \ 

    + \ \ #determine clusters

    + \ \ x.clfl\<less\>-means.hc$height

    + \ \ #assign the fusion levels

    + \ \ x.clm\<less\>-mean(x.clfl)

    + \ \ #compute the means

    + \ \ x.cls\<less\>-sqrt(var(x.clfl))

    + \ \ #compute the standard deviation

    + \ \ x.score \<less\>- ((x.clfl-x.clm)/x.cls)

    + \ \ #Mojena(1977)2.75\<less\>k\<less\>3.5

    + \ \ #Milligan and Cooper (1985) k=1.25

    + \ \ extra \<less\>- x.score[x.score\<less\>cutoff]

    + \ \ clusters \<less\>- cutree(means.hc,h=x.clfl[length(extra)-1])

    + \ \ 

    + \ \ if(length(leaf.colors)==0) {

    + \ \ \ \ if(length(trt.colors)\<less\>max(clusters)) {

    + \ \ \ \ \ \ trt.colors \<less\>- c(trt.colors,rainbow(max(clusters)-length(trt.colors)))

    + \ \ \ \ }

    + \ \ \ \ #trt.colors \<less\>- rainbow(max(clusters))

    + \ \ \ \ leaf.colors = trt.colors[clusters]

    + \ \ } else if (length(leaf.colors)\<less\>length(clusters)) {

    + \ \ \ \ leaf.colors = leaf.colors[clusters]

    + \ \ }

    + \ \ 

    + \ \ min.x \<less\>- min(means.vector,na.rm=TRUE)

    + \ \ max.x \<less\>- max(means.vector,na.rm=TRUE)

    + \ \ 

    + \ \ if(fixed.prop) {

    + \ \ \ \ min.y \<less\>- min(means.matrix,na.rm=TRUE)

    + \ \ \ \ max.y \<less\>- max(means.matrix,na.rm=TRUE)

    + \ \ \ \ min.x \<less\>- min(c(min.x,min.y))

    + \ \ \ \ max.x \<less\>- max(c(max.x,max.y))

    + \ \ }

    + \ \ 

    + \ \ min.hc.y \<less\>- min(means.hc$height)

    + \ \ max.hc.y \<less\>- max(means.hc$height)

    + \ \ min.hc.y \<less\>- 0

    + \ \ #print(min.hc.y)

    + \ \ base \<less\>- max.hc.y

    + \ \ ceiling \<less\>- min.hc.y

    +\ 

    + \ \ #add space

    + \ \ required.height = max.hc.y

    +\ 

    + \ \ max.hc.y = max.hc.y+0.2*required.height

    + \ \ min.hc.y = 0-0.2*required.height

    +\ 

    + \ \ #if we want to include cld, change required height

    + \ \ if(length(cld)\<gtr\>0) {

    + \ \ \ \ max.hc.y = max.hc.y+0.3*required.height

    + \ \ }

    + \ \ if(!add) {

    + \ \ \ \ plot(1, type="n", axes=F, xlab=xlab, ylab=ylab,

    + \ \ \ \ \ \ \ \ \ xlim=c(min.x,max.x),
    ylim=c(min.hc.y,max.hc.y),cex=cex,

    + \ \ \ \ \ \ \ \ \ col.axis=col.axis,

    + \ \ \ \ \ \ \ \ \ col.lab=col.lab,

    + \ \ \ \ \ \ \ \ \ col.main=col.main,

    + \ \ \ \ \ \ \ \ \ xlog=xlog

    + \ \ \ \ \ \ \ \ \ #font.lab=style.axis,font.lab=style.axis,

    + \ \ \ \ \ \ \ \ \ #family=family.axis

    + \ \ \ \ )

    + \ \ \ \ 

    + \ \ \ \ label.cex = cex

    + \ \ \ \ if(length(cld)\<gtr\>0) {

    + \ \ \ \ \ \ label.cex = cex+ \ \ \ \ }

    + \ \ \ \ if(length(leaf.colors)\<less\>length(means.vector)) {

    + \ \ \ \ \ \ leaf.colors \<less\>- c(leaf.colors,rep(col.axis,length(means.vector)-length

    \<less\>af.colors,rep(col.axis,length(means.vector)-length(leaf.colors)))

    + \ \ \ \ }

    + \ \ \ \ for(trial in 1:length(means.vector)) {

    + \ \ \ \ \ \ n.text = as.character(trial)

    + \ \ \ \ \ \ if(length(plot.names)\<gtr\>0) {

    + \ \ \ \ \ \ \ \ n.text \<less\>- plot.names[trial]

    + \ \ \ \ \ \ }

    + \ \ \ \ \ \ if(use.colors) {

    + \ \ \ \ \ \ \ \ text(means.vector[trial],base+0.08*required.height,n.text,col=leaf.

    \<less\>[trial],base+0.08*required.height,n.text,col=leaf.colors[trial],family=famil

    \<less\>.height,n.text,col=leaf.colors[trial],family=family.axis,cex=label.cex)

    + \ \ \ \ \ \ } else {

    + \ \ \ \ \ \ \ \ text(means.vector[trial],base+0.08*required.height,n.text,family=fa

    \<less\>[trial],base+0.08*required.height,n.text,family=family.axis,cex=label.cex)

    + \ \ \ \ \ \ }

    + \ \ \ \ \ \ 

    + \ \ \ \ }

    + \ \ \ \ if(length(cld)\<gtr\>0) {

    + \ \ \ \ \ \ for(l in 1:length(cld)) {

    + \ \ \ \ \ \ \ \ text(means.vector[l],base+0.28*required.height,cld[l],col=col.axis,

    \<less\>[l],base+0.28*required.height,cld[l],col=col.axis,family=family.axis,cex=lab

    \<less\>ght,cld[l],col=col.axis,family=family.axis,cex=label.cex*0.8)

    + \ \ \ \ \ \ }

    + \ \ \ \ }

    + \ \ }

    + \ \ 

    + \ \ rows \<less\>- dim(means.hc$merge)[1]

    + \ \ endpoints \<less\>- matrix(0,nrow=rows,ncol=4)

    + \ \ 

    + \ \ #plot horizontal lines

    + \ \ max.plotted.y = 0

    + \ \ for (row in 1:rows) {

    + \ \ \ \ current.pair \<less\>- means.hc$merge[row,]

    + \ \ \ \ current.distance \<less\>- means.hc$height[row]

    + \ \ 

    + \ \ \ \ y \<less\>- c(current.distance,current.distance)

    +\ 

    + \ \ \ \ x \<less\>- hc.xpoints(row, means.hc, means.vector)

    + \ \ \ \ #print(x) #x's look correct

    + \ \ \ \ y \<less\>- base - y #+ (base/10)

    + \ \ \ \ #print(y)

    + \ \ \ \ if(max(y)\<gtr\>max.plotted.y) {

    + \ \ \ \ \ \ max.plotted.y \<less\>- max(y)

    + \ \ \ \ }

    + \ \ \ \ endpoints[row,1] \<less\>- x[1]

    + \ \ \ \ endpoints[row,2] \<less\>- y[1]

    + \ \ \ \ endpoints[row,3] \<less\>- x[2]

    + \ \ \ \ endpoints[row,4] \<less\>- y[2]

    + \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    + \ \ \ \ if(has.ref) {

    + \ \ \ \ \ \ if(matched.idx[row] == 0) {

    + \ \ \ \ \ \ \ \ current.clfl\<less\>-means.hc$height[row]

    + \ \ \ \ \ \ \ \ #compute the standard deviation

    + \ \ \ \ \ \ \ \ x.score \<less\>- (current.clfl/x.cls)\ 

    + \ \ \ \ \ \ \ \ 

    + \ \ \ \ \ \ \ \ #ratio = x.score #means.hc$height[row]/ref.hc$height[matched.idx[ro

    \<less\>#means.hc$height[row]/ref.hc$height[matched.idx[row]]

    + \ \ \ \ \ \ \ \ #if((ratio\<gtr\>3) \|\| (ratio\<less\>0.3)) {

    + \ \ \ \ \ \ \ \ if(mark.nodes) {

    + \ \ \ \ \ \ \ \ \ \ if(x.score\<gtr\>cutoff) {

    + \ \ \ \ \ \ \ \ \ \ \ \ mid \<less\>- c(x[1]+(x[2]-x[1])/2,y[1])

    + \ \ \ \ \ \ \ \ \ \ \ \ #points(xy.coords(x,y))

    + \ \ \ \ \ \ \ \ \ \ \ \ plot.xy(xy.coords(mid[1],mid[2]),type="p",lwd=wt,col=fg)

    + \ \ \ \ \ \ \ \ \ \ }

    + \ \ \ \ \ \ \ \ }

    + \ \ \ \ \ \ }

    + \ \ \ \ \ \ #means.hc$height

    + \ \ \ \ \ \ #res3$means.hc$height

    + \ \ \ \ \ \ #ref.hc$height[matcheddx]

    + \ \ \ \ }

    + \ \ }

    + \ \ 

    + \ \ if(verbose) {

    + \ \ \ \ print("endpoints")

    + \ \ \ \ print(endpoints)

    + \ \ }

    + \ \ for (row in 2:rows) {

    + \ \ \ \ current.pair \<less\>- means.hc$merge[row,] \ \ \ 

    + \ \ \ \ x \<less\>- c(endpoints[row,1],endpoints[row,1])

    + \ \ \ \ #scan for crossing point

    + \ \ \ \ inner.row = row-1

    + \ \ \ \ x.bound = endpoints[row,1]

    + \ \ \ \ while(inner.row\<gtr\>1) {

    + \ \ \ \ \ \ if( (endpoints[inner.row,1]\<less\>x.bound &&
    endpoints[inner.row,3]\<gtr\>x.bound

    \<less\>r.row,1]\<less\>x.bound && endpoints[inner.row,3]\<gtr\>x.bound)
    \ \|\|

    + \ \ \ \ \ \ \ \ (endpoints[inner.row,1]\<gtr\>x.bound &&
    endpoints[inner.row,3]\<less\>x.bound)\ 

    \<less\>row,1]\<gtr\>x.bound && endpoints[inner.row,3]\<less\>x.bound) )
    {

    + \ \ \ \ \ \ \ \ #this point is on either side of our x, so we will

    + \ \ \ \ \ \ \ \ #cross this line

    + \ \ \ \ \ \ \ \ break

    + ; \ \ \ \ \ }

    + \ \ \ \ \ \ inner.row = inner.row-1

    + \ \ \ \ }

    +\ 

    + \ \ \ \ y \<less\>- c(endpoints[row,2],endpoints[inner.row,2])

    + \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    + \ \ \ \ 

    + \ \ \ \ x \<less\>- c(endpoints[row,3],endpoints[row,3])

    + \ \ \ \ inner.row = row-1

    + \ \ \ \ x.bound = endpoints[row,3]

    + \ \ \ \ while(inner.row\<gtr\>1) {

    + \ \ \ \ \ \ if((endpoints[inner.row,1]\<less\>x.bound &&
    endpoints[inner.row,3]\<gtr\>x.bound)

    \<less\>.row,1]\<less\>x.bound && endpoints[inner.row,3]\<gtr\>x.bound)
    \|\|

    + \ \ \ \ \ \ \ \ \ \ \ endpoints[inner.row,1]\<gtr\>x.bound &&
    endpoints[inner.row,3]\<less\>x.bound

    \<less\>r.row,1]\<gtr\>x.bound && endpoints[inner.row,3]\<less\>x.bound)
    {

    + \ \ \ \ \ \ \ \ #this point is on either side of our x, so we will

    + \ \ \ \ \ \ \ \ #cross this line

    + \ \ \ \ \ \ \ \ break

    + ; \ \ \ \ \ }

    + \ \ \ \ \ \ inner.row = inner.row-1

    + \ \ \ \ }

    + \ \ \ \ 

    + \ \ \ \ y \<less\>- c(endpoints[row,4],endpoints[inner.row,4])

    + \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    + \ \ }

    + \ \ 

    + \ \ for(trial in 1:length(means.vector)) {

    + \ \ \ \ x = c(means.vector[trial],means.vector[trial])

    + \ \ \ \ y = c(max.plotted.y, base-0.04*required.height)
    #c(max.plotted.y, base+

    \<less\>base-0.04*required.height) #c(max.plotted.y,
    base+0.06*required.height)

    + \ \ \ \ plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)

    + \ \ }

    +\ 

    + \ \ return(list(means.hc=means.hc,

    + \ \ \ \ \ \ \ \ \ clusters=clusters,

    + \ \ \ \ \ \ \ \ \ score=x.score,

    + \ \ \ \ \ \ \ \ \ cls = x.cls

    + \ \ \ \ \ \ \ \ \ ))

    + }

    \<gtr\>\ 

    \<gtr\> hc.midpoint \<less\>- function(row, hc, means) {

    + \ \ hc.pair \<less\>- hc$merge[row,]

    + \ \ x1 \<less\>- 0

    + \ \ x2 \<less\>- 0

    + \ \ if(hc.pair[1]\<gtr\>0) {

    + \ \ \ \ x1 \<less\>- hc.midpoint(hc.pair[1],hc,means)

    + \ \ } else {

    + \ \ \ \ x1 \<less\>- means[-hc.pair[1]]

    + \ \ }

    + \ \ if(hc.pair[2]\<gtr\>0) {

    + \ \ \ \ x2 \<less\>- hc.midpoint(hc.pair[2],hc,means)

    + \ \ } else {

    + \ \ \ \ x2 \<less\>- means[-hc.pair[2]]

    + \ \ }

    + \ \ return((x1+x2)/2)

    + }

    \<gtr\>\ 

    \<gtr\> hc.xpoints \<less\>- function(row, hc, means) {

    + \ \ hc.pair \<less\>- hc$merge[row,]

    + \ \ x1 \<less\>- 0

    + \ \ x2 \<less\>- 0

    + \ \ if(hc.pair[1]\<gtr\>0) {

    + \ \ \ \ x1 \<less\>- hc.midpoint(hc.pair[1],hc,means)

    + \ \ } else {

    + \ \ \ \ x1 \<less\>- means[-hc.pair[1]]

    + \ \ }

    + \ \ if(hc.pair[2]\<gtr\>0) {

    + \ \ \ \ x2 \<less\>- hc.midpoint(hc.pair[2],hc,means)

    + \ \ } else {

    + \ \ \ \ x2 \<less\>- means[-hc.pair[2]]

    + \ \ }

    + \ \ return(c(x1,x2))

    + }

    \<gtr\>\ 

    \<gtr\>\ 

    \<gtr\> compare.merges \<less\>- function(merge1,merge2) {

    + \ \ dim1 \<less\>- dim(merge1)

    + \ \ dim2 \<less\>- dim(merge2)

    + \ \ matched \<less\>- rep(0,dim1[1])

    + \ \ if(dim1[1]==dim2[1]) {

    + \ \ \ \ for(idx1 in 1:dim1[1]) {

    + \ \ \ \ \ \ for(idx2 in 1:dim2[1]) {

    + \ \ \ \ \ \ \ \ if((merge1[idx1,1]==merge2[idx2,1]) &&
    (merge1[idx1,2]==merge2[idx2

    \<less\>]==merge2[idx2,1]) && (merge1[idx1,2]==merge2[idx2,2]) \|\|

    + \ \ \ \ \ \ \ \ \ \ \ (merge2[idx2,1]==merge1[idx1,1]) &&
    (merge2[idx2,2])==merge1[idx

    \<less\>]==merge1[idx1,1]) && (merge2[idx2,2])==merge1[idx1,2]) {

    + \ \ \ \ \ \ \ \ \ \ matched[idx1]=idx2

    + \ \ \ \ \ \ \ \ }

    + \ \ \ \ \ \ }

    + \ \ \ \ }

    + \ \ }

    + \ \ return(matched)

    + }
  </unfolded-io>

  \;

  <section|Decomposing Interaction>

  <subsection|Random Effect>

  In most cases, trials are assumed to be random effects. This forces
  interaction to be a random effect, <math|\<phi\><rsub|i
  j>\<sim\>\<cal-N\><around*|(|0,\<sigma\><rsup|2><rsub|GEI>|)>> and can be
  regarded as another level of error. However, treatments may exhibit
  heterogeneous interactions (Steel p.399)

  <subsection|Fixed Effect>

  <paragraph|Non additivity>

  Tukey proposed a one degree of freedom test for interaction in a two-way
  table, analogous to <inactive|<reference|two.way>>. His argument, in brief:

  We start with the assumption of perfect additivity. The <math|i j> entry in
  the table is a simple sum of the <math|i> row effect and the <math|j>
  column effect,

  \ 

  <\equation>
    y<rsub|i j>=\<alpha\><rsub|i> +\<beta\><rsub|j><inactive|<label|simple.additive>>
  </equation>

  Next, consider a function of <math|y>

  <\equation>
    f<around*|(|y<rsub|i j>|)>=y<rsub|i j>+\<lambda\><around*|(|y<rsub|i
    j>-y|)><rsup|2><inactive|<label|non.linear>>
  </equation>

  where <math|\<lambda\>> is a constant and
  <math|y=<wide|\<alpha\>|\<bar\>>+<wide|\<beta\>|\<bar\>>>. Substituting
  <inactive|<reference|simple.additive>> into
  <inactive|<reference|non.linear>>, we find

  <\eqnarray*>
    <tformat|<table|<row|<cell|f<around*|(|y<rsub|i
    j>|)>>|<cell|=>|<cell|y<rsub|i j>+\<lambda\><around*|(|y<rsub|i
    j>-y|)><rsup|2>>>|<row|<cell|>|<cell|=>|<cell|\<alpha\><rsub|i>
    +\<beta\><rsub|j>+\<lambda\><around*|(|\<alpha\><rsub|i>
    +\<beta\><rsub|j>-<around*|(|<wide|\<alpha\>|\<bar\>>+<wide|\<beta\>|\<bar\>>|)>|)><rsup|2>>>|<row|<cell|>|<cell|>|<cell|\<alpha\><rsub|i>
    +\<beta\><rsub|j>+\<lambda\><around*|(|<around*|(|\<alpha\><rsub|i>
    -<wide|\<alpha\>|\<bar\>>|)>+<around*|(|\<beta\><rsub|j>-<wide|\<beta\>|\<bar\>>|)>|)><rsup|2>>>|<row|<cell|>|<cell|>|<cell|\<alpha\><rsub|i>
    +\<beta\><rsub|j>+\<lambda\><around*|[|<around*|(|\<alpha\><rsub|i>
    -<wide|\<alpha\>|\<bar\>>|)><rsup|2>+<around*|(|\<beta\><rsub|j>-<wide|\<beta\>|\<bar\>>|)><rsup|2>
    +2<around*|(|\<beta\><rsub|j>-<wide|\<beta\>|\<bar\>>|)>|]>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|=>|<cell|<around*|[|\<alpha\><rsub|i>
    +\<lambda\><around*|(|\<alpha\><rsub|i>
    -<wide|\<alpha\>|\<bar\>>|)><rsup|2>|]>+<around*|[|\<beta\><rsub|j>+\<lambda\><around*|(|\<beta\><rsub|j>-<wide|\<beta\>|\<bar\>>|)><rsup|2>|]>+<around*|[|2\<lambda\><around*|(|\<alpha\><rsub|i>
    -<wide|\<alpha\>|\<bar\>>|)><around*|(|\<beta\><rsub|j>-<wide|\<beta\>|\<bar\>>|)>|]>>>>>
  </eqnarray*>

  The first term depends on rows only, the second on columns only. When we
  analyze in terms of <math|f<around*|(|a|)>> instead of <math|a>, any
  non-additivity arises from the third term. Since the third term is a
  product, there is one degree of freedom associated with this term.

  See snee.r-09-1982

  Compare synergistic with antagonistic interactions.

  Mandel (mandel.j-12-1961) includes Tukey's as a special case.

  \;

  Johnson and Graybill (johnson.d-06-1972,johnson.d-12-1972) generalize
  Tukey's model from

  <\equation*>
    y<rsub|i j>=\<tau\><rsub|i>+\<beta\><rsub|j>+\<lambda\>\<tau\><rsub|i>\<beta\><rsub|j>+\<varepsilon\><rsub|i
    j>
  </equation*>

  to

  <\equation*>
    y<rsub|i j>=\<tau\><rsub|i>+\<beta\><rsub|j>+\<lambda\>\<alpha\><rsub|i>\<gamma\><rsub|j>+\<varepsilon\><rsub|i
    j>
  </equation*>

  where they are explicitly model interaction for treatments and blocks. They
  argue the second model is more suitable when interaction is present, but
  treatments are not significant; when interaction is present for only a few
  outliers; when interaction is due to only one or two treatments; for
  theoretical reasons or when data are observational and not experimental.
  They go on to prove that maximum likelihood estimators of
  <math|\<lambda\>,\<alpha\>> and <math|\<gamma\>> derive from the root and
  characteristic vector of the matrix <math|Z Z<rprime|'>>, defining <math|Z>
  to be a matrix of residuals from additivity, <math|Z=<around*|{|z<rsub|i
  j>|}>=<around*|{|y<rsub|i j>-y<rsub|i .>-y<rsub|\<nosymbol\>j>+y<rsub|\<nosymbol\>\<nosymbol\>\<ldots\>>|}>>

  <paragraph|Bilinear Model>

  aastveit 1986

  We consider <math|\<phi\>> is a product of two values associated with, but
  independent from, main effects, such that

  <\equation*>
    \<phi\><rsub|i j>=\<gamma\><rsub|g>\<delta\><rsub|e>+\<varepsilon\><rsub|i
    j>
  </equation*>

  If we assume <math|\<delta\>> is equal to <math|\<beta\>>, (that is, the
  interaction is a result of the genotypes response to the environment) then

  <\eqnarray*>
    <tformat|<table|<row|<cell|y<rsub|i j
    >>|<cell|=>|<cell|\<mu\>+\<alpha\><rsub|i>+\<beta\><rsub|j>
    <around*|(|1+\<gamma\><rsub|g>|)>+\<varepsilon\><rsub|i
    j>>>|<row|<cell|y<rsub|i j k>>|<cell|=>|<cell|\<mu\>+\<alpha\><rsub|i>+\<beta\><rsub|j>
    <around*|(|1+\<gamma\><rsub|g>|)>+\<rho\><rsub|k>+e<rsub|i j k>>>>>
  </eqnarray*>

  \;

  \;

  Multiplicative model: The yield of a treatment in trial is proportional to
  the fertility of the trial itself; the best measure of fertility of a trial
  is the trial mean, averaged over all treatments. The proportionality
  constant is a function of the treatment, and is best measured as
  proportional to treatment mean across all trials.

  \;

  <section|Model Diagnostics>

  print(summary(st.lm))

  \;

  <section|Questions>

  <subsection|Stability/Regression>

  What are the slopes of the lines in the trial stability plot? Which are
  significant?

  <paragraph|Eberhart and Russell>(Regression on the mean)

  Stability is estimated from regression of each variety against
  environmental index (mean of all varieties minus grand mean -
  <math|\<beta\><rsub|j>= <below|<big|sum>|i>y<rsub|i
  j>/v-><math|<below|<big|sum>|i><below|<big|sum>|j><below|y<rsub|i j>/v n|>>

  <\equation*>
    y<rsub|i j>=\<mu\><rsub|i>+b<rsub|i>\<beta\><rsub|j>+\<phi\><rsub|i j>
  </equation*>

  where <math|y<rsub|i j>> is the mean of the <math|i<rsup|th>> variety at
  the <math|j<rsup|th>> environment. From predicted values
  <math|<wide|y|^><rsub|i j>=x<rsub|i>+b<rsub|i>\<beta\><rsub|j>>, we
  estimate deviations <math|<wide|\<phi\>|^><rsub|i j>=<around*|(|y<rsub|i
  j>-<wide|y|^><rsub|i j>|)>>, we estimate a stability parameter
  <math|\<sigma\><rsub|d><rsup|2>>,

  <\equation*>
    s<rsub|d<rsub|i>><rsup|2>=<around*|[|<below|<big|sum>|j><wide|\<phi\>|^><rsup|2><rsub|i
    j>/<around*|(|n-2|)>-s<rsup|2><rsub|e>/r|]>
  </equation*>

  Malosetti (2013) use the notation

  <\equation*>
    y<rsub|i j>=\<alpha\><rprime|'><rsub|i>+b<rprime|'><rsub|>\<beta\><rsub|j>+\<varepsilon\><rsub|i
    j>
  </equation*>

  where <math|a<rprime|'><rsub|i>=\<mu\>+a<rsub|i>> and
  <math|b<rprime|'>=*<around*|(|1+b<rsub|i>|)>>, then decompose interaction
  into heterogeneity of slopes

  <subsection|Decomposition of interaction by nonadditivity>

  Do the treatment means diverge or converge as trial means get larger (which
  trials are more discriminating?).\ 

  muir.w-01-1992 - heteregenous variance vs imperfect correlation

  gauch.h-09-2013 - says that both Gollob and <math|F<rsub|R>> are used.

  <subsection|Cluster Identification>

  <\quote-env>
    Which trials belong to statistically different groups?
  </quote-env>

  <subsection|Principal Components and Biplots>

  <\quote-env>
    Do the treatment-by-trial interactions observed in this set of
    experiments warrant biplot analysis?
  </quote-env>

  johnson.d-12-1972 lay theoretical foundations for a model where interaction
  is not a function of main effects. They show an example where the 1 d.f.
  test suggests additivity, while their likelihood ratio test does suggest
  nonadditivity.

  Mandel mandel.j-10-1969 also shows the application of principal component
  decomposition

  \;

  <subsection|Significant Pairs/Outliers>

  <\quotation>
    Do one or more trial show an unusual level of treatment-by-trial
    interaction?
  </quotation>

  <\quotation>
    Will excluding these trials (as outliers) reduce the significance of
    interaction?
  </quotation>

  <subsection|Alternative Regression>

  <\quotation>
    Are the lines fitting treatment means to trial means straight, convex
    (suggesting an asymptote) or concave?
  </quotation>

  <subsection|Dendrogram Cross-over>

  <\quotation>
    When are differences in groups between trial means and dendrogram
    distances an indication of significant interaction?
  </quotation>

  We relate conventional clustering to crossa-1995.

  <subsubsection|Euclidean distance>

  Given two vectors <with|font-series|bold|<math|a>> and
  <with|font-series|bold|<math|b>>,\ 

  <\equation*>
    <with|font-series|bold|a>=<around*|{|a<rsub|j>:j=1,2,\<ldots\>,m|}>
  </equation*>

  and

  <\equation*>
    <with|font-series|bold|b>=<around*|{|b<rsub|j>:j=1,2,\<ldots\>,m|}>
  </equation*>

  the unweighted, squared, Euclidean distance is given by

  <\equation*>
    d<rsup|2><around*|(|a,b|)>=<big|sum><around*|(|a<rsub|j>-b<rsub|j>|)><rsup|2>=<around*|(|<with|font-series|bold|a>-<with|font-series|bold|b>|)><rsup|<rprime|'>><around*|(|<with|font-series|bold|a>-<with|font-series|bold|b>|)>
  </equation*>

  When <with|font-series|bold|<math|a>> and <math|<with|font-series|bold|b>>
  represent treatment in trial means from two trials, then

  <\eqnarray*>
    <tformat|<table|<row|<cell|<with|font-series|bold|a>>|<cell|=>|<cell|<around*|{|y<rsub|i
    1> :i=1,2,\<ldots\>,m|}>>>|<row|<cell|<with|font-series|bold|b>>|<cell|=>|<cell|<around*|{|y<rsub|i
    2> :i=1,2,\<ldots\>,m|}>>>|<row|<cell|<around*|(|<with|font-series|bold|a>-<with|font-series|bold|b>|)>>|<cell|=>|<cell|<around*|{|y<rsub|i
    1>-y<rsub|i 2>|}>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|<around*|(|\<mu\>+\<alpha\><rsub|i>+\<beta\><rsub|1>+\<phi\><rsub|i
    1>+\<varepsilon\><rsub|i 1>|)>-<around*|(|\<mu\>+\<alpha\><rsub|i>+\<beta\><rsub|2>+\<phi\><rsub|i
    2>+\<varepsilon\><rsub|i 2>|)>|}>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|<around*|(|\<beta\><rsub|1>+\<phi\><rsub|i
    1>+\<varepsilon\><rsub|i 1>|)>-<around*|(|\<beta\><rsub|2>+\<phi\><rsub|i
    2>+\<varepsilon\><rsub|i 2>|)>|}>>>>>
  </eqnarray*>

  In the absence of interactions (<math|\<phi\><rsub|11>=\<phi\><rsub|2
  1>=\<ldots\>=\<phi\><rsub|i j>=0>), then the difference is

  <\eqnarray*>
    <tformat|<table|<row|<cell|<around*|(|<with|font-series|bold|a>-<with|font-series|bold|b>|)>>|<cell|=>|<cell|<around*|{|<around*|(|\<beta\><rsub|1>+\<varepsilon\><rsub|i
    1>|)>-<around*|(|\<beta\><rsub|2>+\<varepsilon\><rsub|i
    2>|)>|}>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|\<beta\><rsub|1>-\<beta\><rsub|2>+\<varepsilon\><rsub|i
    1>-\<varepsilon\><rsub|i 2>|}>>>|<row|<cell|<around*|(|<with|font-series|bold|a>-<with|font-series|bold|b>|)><rsup|<rprime|'>><around*|(|<with|font-series|bold|a>-<with|font-series|bold|b>|)>>|<cell|=>|<cell|n<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)><rsup|2>>>>>
  </eqnarray*>

  <\eqnarray*>
    <tformat|<table|<row|<cell|<around*|\<\|\|\>|T<rsub|1>-T<rsub|2>|\<\|\|\>>>|<cell|=>|<cell|<sqrt|<big|sum><around*|{|<around*|(|t<rsub|1
    1>-t<rsub|1 2>|)><rsup|2>,<around*|(|t<rsub|2 1>-t<rsub|2
    2>|)><rsup|2>\<nocomma\>,\<ldots\> ,<around*|(|t<rsub|m 1>-t<rsub|m
    2>|)><rsup|2>|}>>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|<around*|[|<around*|(|\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|1
    1>|)>-<around*|(|\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|1
    2>|)>|]>, <around*|[|<around*|(|\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|2
    1>|)>-<around*|(|\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|2
    2>|)>|]>,\<ldots\> ,<around*|(|\<mu\>+\<alpha\><rsub|2m>+\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|m
    1>|)>-<around*|(|\<mu\>+\<alpha\><rsub|m>+\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|m
    2>|)>|}><rsup|1/2>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|<around*|(|\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|1>+0|)>-<around*|(|\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|2>+0|)>,
    <around*|(|\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|1>+0|)>-<around*|(|\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|2>+0|)>,\<ldots\>
    ,<around*|(|\<mu\>+\<alpha\><rsub|m>+\<beta\><rsub|1>+0|)>-<around*|(|\<mu\>+\<alpha\><rsub|m>+\<beta\><rsub|2>+0|)>|}><rsup|1/2>>>|<row|<cell|>|<cell|=>|<cell|<sqrt|<around*|{|<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)>,
    <around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)>,\<ldots\>
    ,<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)>|}>>>>|<row|<cell|>|<cell|=>|<cell|<sqrt|m<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)><rsup|2>>>>|<row|<cell|>|<cell|=>|<cell|<sqrt|m><sqrt|<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)><rsup|2>>>>>>
  </eqnarray*>

  <\eqnarray*>
    <tformat|<table|<row|<cell|<around*|\<\|\|\>|T<rsub|1>-T<rsub|2>|\<\|\|\>>>|<cell|=>|<cell|<sqrt|<big|sum><around*|{|<around*|(|t<rsub|1
    1>-t<rsub|1 2>|)><rsup|2>,<around*|(|t<rsub|2 1>-t<rsub|2
    2>|)><rsup|2>\<nocomma\>,\<ldots\> ,<around*|(|t<rsub|m 1>-t<rsub|m
    2>|)><rsup|2>|}>>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|<around*|[|<around*|(|\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|1
    1>|)>-<around*|(|\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|1
    2>|)>|]>, <around*|[|<around*|(|\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|2
    1>|)>-<around*|(|\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|2
    2>|)>|]>,\<ldots\> ,<around*|(|\<mu\>+\<alpha\><rsub|2m>+\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|m
    1>|)>-<around*|(|\<mu\>+\<alpha\><rsub|m>+\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|m
    2>|)>|}>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|<around*|(|<around*|(|\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|1
    1>|)>-<around*|(|\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|1
    2>|)>|)>, <around*|(|<around*|(|\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|2
    1>|)>-<around*|(|\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|2
    2>|)>|)>,\<ldots\> ,<around*|(|<around*|(|\<beta\><rsub|1>+<around*|(|\<alpha\>\<beta\>|)><rsub|m
    1>|)>-<around*|(|\<beta\><rsub|2>+<around*|(|\<alpha\>\<beta\>|)><rsub|m
    2>|)>|)>|}>>>|<row|<cell|>|<cell|=>|<cell|<around*|{|<around*|(|<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)>+<around*|(|<around*|(|\<alpha\>\<beta\>|)><rsub|1
    1>-<around*|(|\<alpha\>\<beta\>|)><rsub|1 2>|)>|)>,
    <around*|(|<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)>-<around*|(|<around*|(|\<alpha\>\<beta\>|)><rsub|2
    1>-<around*|(|\<alpha\>\<beta\>|)><rsub|2 2>|)>|)>,\<ldots\>
    ,<around*|(|<around*|(|\<beta\><rsub|1>-\<beta\><rsub|2>|)>-<around*|(|<around*|(|\<alpha\>\<beta\>|)><rsub|m
    1>-<around*|(|\<alpha\>\<beta\>|)><rsub|m
    2>|)>|)>|}>>>|<row|<cell|>|<cell|=>|<cell|>>>>
  </eqnarray*>

  <\eqnarray*>
    <tformat|<table|<row|<cell|<around*|\<\|\|\>|y<rsub|1\<bullet\>>-y<rsub|2\<bullet\>>|\<\|\|\>>>|<cell|=>|<cell|<sqrt|<big|sum><around*|(|y<rsub|1i>-y<rsub|2i>|)><rsup|2>>>>|<row|<cell|y<rsub|1\<bullet\>>-y<rsub|2\<bullet\>>>|<cell|=>|<cell|<around*|(|y<rsub|11>,y<rsub|12>,y<rsub|13>|)>-<around*|(|y<rsub|21>,y<rsub|22>,y<rsub|33>|)>>>|<row|<cell|>|<cell|=>|<cell|<around*|(|\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|1>+\<phi\><rsub|11>,\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|2>+\<phi\><rsub|12>,\<mu\>+\<alpha\><rsub|1>+\<beta\><rsub|3>+\<phi\><rsub|13>|)>-<around*|(|\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|1>+\<phi\><rsub|21>,\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|2>+\<phi\><rsub|22>,\<mu\>+\<alpha\><rsub|2>+\<beta\><rsub|3>+\<phi\><rsub|23>|)>>>|<row|<cell|>|<cell|=>|<cell|<around*|(|\<alpha\><rsub|1>+\<phi\><rsub|11>-\<alpha\><rsub|2>-\<phi\><rsub|21>,\<alpha\><rsub|1>+\<phi\><rsub|12>-\<alpha\><rsub|2>-\<phi\><rsub|22>,\<alpha\><rsub|1>+\<phi\><rsub|13>-\<alpha\><rsub|2>-\<phi\><rsub|23>|)>>>|<row|<cell|>|<cell|=>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<phi\><rsub|11>-\<phi\><rsub|21>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<phi\><rsub|12>-\<phi\><rsub|22>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<phi\><rsub|13>-\<phi\><rsub|23>|)>|)>>>|<row|<cell|>|<cell|>|<cell|no
    interaction>>|<row|<cell|y<rsub|1\<bullet\>>-y<rsub|2\<bullet\>>>|<cell|=>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>|)>>>|<row|<cell|H<rsub|0>=<around*|\<\|\|\>|y<rsub|1\<bullet\>>-y<rsub|2\<bullet\>>|\<\|\|\>><rsup|2>>|<cell|=>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>|)>>>|<row|<cell|>|<cell|>|<cell|simple
    nonadditivity>>|<row|<cell|y<rsub|1\<bullet\>>-y<rsub|2\<bullet\>>>|<cell|=>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<lambda\>\<alpha\><rsub|1><rsub|>\<beta\><rsub|1>-\<lambda\>\<alpha\><rsub|2><rsub|>\<beta\><rsub|1>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<lambda\>\<alpha\><rsub|1><rsub|>\<beta\><rsub|2>-\<lambda\>\<alpha\><rsub|2><rsub|>\<beta\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<lambda\>\<alpha\><rsub|1><rsub|>\<beta\><rsub|3>-\<lambda\>\<alpha\><rsub|2><rsub|>\<beta\><rsub|3>|)>|)>>>|<row|<cell|>|<cell|>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+\<lambda\>\<beta\><rsub|1><around*|(|\<alpha\><rsub|1><rsub|>-\<alpha\><rsub|2><rsub|>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+\<lambda\>\<beta\><rsub|2><around*|(|\<alpha\><rsub|1><rsub|>-\<alpha\><rsub|2><rsub|>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+\<lambda\>\<beta\><rsub|3><around*|(|\<alpha\><rsub|1><rsub|>-\<alpha\><rsub|2><rsub|>|)>|)>>>|<row|<cell|>|<cell|>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)><around*|(|1+\<lambda\>\<beta\><rsub|1>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)><around*|(|1+\<lambda\>\<beta\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)><around*|(|1+\<lambda\>\<beta\><rsub|3>|)>|)>>>|<row|<cell|>|<cell|>|<cell|if
    \<lambda\>=0,>>|<row|<cell|>|<cell|>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)><around*|(|1|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)><around*|(|1|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)><around*|(|1|)>|)>>>|<row|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|heterogenous
    slopes>>|<row|<cell|y<rsub|1\<bullet\>>-y<rsub|2\<bullet\>>>|<cell|=>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<lambda\><rsub|1><rsub|>\<beta\><rsub|1>-\<lambda\><rsub|2><rsub|>\<beta\><rsub|1>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<lambda\><rsub|1><rsub|>\<beta\><rsub|2>-\<lambda\><rsub|2><rsub|>\<beta\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+<around*|(|\<lambda\><rsub|1><rsub|>\<beta\><rsub|3>-\<lambda\><rsub|2><rsub|>\<beta\><rsub|3>|)>|)>>>|<row|<cell|>|<cell|>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+\<beta\><rsub|1><around*|(|\<lambda\><rsub|1><rsub|>-\<lambda\><rsub|2><rsub|>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+\<beta\><rsub|2><around*|(|\<lambda\><rsub|1><rsub|>-\<lambda\><rsub|2><rsub|>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>+\<beta\><rsub|3><around*|(|\<lambda\><rsub|1><rsub|>-\<lambda\><rsub|2><rsub|>|)>|)>>>|<row|<cell|>|<cell|>|<cell|if
    \<lambda\><rsub|1><rsub|>-\<lambda\><rsub|2>\<nocomma\>,\<nocomma\>\<nocomma\>then>>|<row|<cell|>|<cell|=>|<cell|<around*|(|<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>,<around*|(|\<alpha\><rsub|1>-\<alpha\><rsub|2>|)>|)>>>>>
  </eqnarray*>

  Corsten 1990 - simultaneous clustering of genotypes and environments

  <section|Types of interactions>

  <big-table|<tabular|<tformat|<table|<row|<cell|<with|font-series|bold|Term>>|<cell|<with|font-series|bold|Trial>>|<cell|<with|font-series|bold|Treatment>>|<cell|<with|font-series|bold|Block>>|<cell|<with|font-series|bold|Interaction>>|<cell|<with|font-series|bold|Residual>>>|<row|<cell|No
  Significant effects<tabular|<tformat|<table|<row|<cell|>|<cell|>>>>>>|<cell|0>|<cell|0>|<cell|0>|<cell|0>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Only
  replicates non-zero>|<cell|0>|<cell|0>|<cell|<math|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>>|<cell|0>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Significant
  trial effects>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|0>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|0>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Significant
  treatments effects>|<cell|0>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|0>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Sign.
  treatment and trial>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|0>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|0>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Sign.
  treatment <math|\<times\>> trial>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<theta\><rsub|L\<times\>T><rsup|2>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Sign.
  random trial>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|0>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Sign.
  random interaction>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<sigma\><rsub|L\<times\>T><rsup|2>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Fully
  random>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<sigma\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<sigma\><rsub|L\<times\>T><rsup|2>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Multiplicative
  random>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<sigma\><rsub|L\<times\>T><rsup|2>=\<sigma\><rsub|L><rsup|2>\<times\>\<alpha\>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Multiplicative
  (Synergistic)>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<theta\><rsub|L\<times\>T><rsup|2>=\<lambda\>\<alpha\>\<times\>\<beta\>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Multiplicative
  (Antagonistic)>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<theta\><rsub|L\<times\>T><rsup|2>=-\<lambda\>\<alpha\>\<times\>\<beta\>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Reciprocal
  (Treatment)>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<theta\><rsub|L\<times\>T><rsup|2>=\<alpha\>/\<beta\>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Reciprocal
  (Trial)>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<theta\><rsub|L\<times\>T><rsup|2>=\<beta\>/\<alpha\>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Quadratic>|<cell|<math|\<theta\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<theta\><rsub|L\<times\>T><rsup|2>=\<lambda\>\<alpha\>\<times\>\<beta\>+\<alpha\>\<times\>\<beta\><rsup|2>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Heterogeneous
  Treatment>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|\<sigma\><rsup|2><rsub|R<around*|(|L|)>>>|<cell|<math|\<sigma\><rsub|L\<times\>T<rsub|1>><rsup|2>,\<sigma\><rsub|L\<times\>T<rsub|2>><rsup|2>,\<ldots\>\<sigma\><rsub|L\<times\>T<rsub|n>><rsup|2>,>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|Heterogeneous
  Multiplicative>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|>|<cell|>|<cell|>>|<row|<cell|Heterogeneous
  Reciprocal (Treatment)>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|>|<cell|>|<cell|>>|<row|<cell|Heterogeneous
  Reciprocal (Trial)>|<cell|<math|\<sigma\><rsub|L><rsup|2>>>|<cell|<math|\<theta\><rsub|T><rsup|2>>>|<cell|>|<cell|>|<cell|>>>>>|>

  \;

  \;

  Bibliography

  vargas_2001
</body>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|6.1|?>>
    <associate|auto-11|<tuple|6.2|?>>
    <associate|auto-12|<tuple|1|?>>
    <associate|auto-13|<tuple|2|?>>
    <associate|auto-14|<tuple|7|?>>
    <associate|auto-15|<tuple|8|?>>
    <associate|auto-16|<tuple|8.1|?>>
    <associate|auto-17|<tuple|3|?>>
    <associate|auto-18|<tuple|8.2|?>>
    <associate|auto-19|<tuple|8.3|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-20|<tuple|8.4|?>>
    <associate|auto-21|<tuple|8.5|?>>
    <associate|auto-22|<tuple|8.6|?>>
    <associate|auto-23|<tuple|8.7|?>>
    <associate|auto-24|<tuple|8.7.1|?>>
    <associate|auto-25|<tuple|9|?>>
    <associate|auto-26|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|3.1|?>>
    <associate|auto-5|<tuple|1|?>>
    <associate|auto-6|<tuple|3.2|?>>
    <associate|auto-7|<tuple|4|?>>
    <associate|auto-8|<tuple|5|?>>
    <associate|auto-9|<tuple|6|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal||<pageref|auto-5>>

      <tuple|normal||<pageref|auto-25>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Abstract>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Assumptions>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Implementation>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc>Analysis
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|3.2<space|2spc>Parameters
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Plotting
      Results> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>Decomposing
      Interaction> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8><vspace|0.5fn>

      <with|par-left|<quote|1tab>|5.1<space|2spc>Random Effect
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|5.2<space|2spc>Fixed Effect
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|4tab>|Non additivity
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Bilinear Model
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12><vspace|0.15fn>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Model
      Diagnostics> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|7<space|2spc>Questions>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14><vspace|0.5fn>

      <with|par-left|<quote|1tab>|7.1<space|2spc>Stability/Regression
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|4tab>|Eberhart and Russell
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16><vspace|0.15fn>>

      <with|par-left|<quote|1tab>|7.2<space|2spc>Decomposition of interaction
      by nonadditivity <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|1tab>|7.3<space|2spc>Cluster Identification
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|1tab>|7.4<space|2spc>Principal Components and
      Biplots <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|1tab>|7.5<space|2spc>Significant Pairs/Outliers
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|1tab>|7.6<space|2spc>Alternative Regression
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|1tab>|7.7<space|2spc>Dendrogram Cross-over
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|2tab>|7.7.1<space|2spc>Euclidean distance
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|8<space|2spc>Types
      of interactions> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>