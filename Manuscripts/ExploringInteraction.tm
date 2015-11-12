<TeXmacs|1.99.2>

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

  <subsection|Decomposing Interaction>

  <subsubsection|Random Effect>

  In most cases, trials are assumed to be random effects. This forces
  interaction to be a random effect, <math|\<phi\><rsub|i
  j>\<sim\>\<cal-N\><around*|(|0,\<sigma\><rsup|2><rsub|GEI>|)>> and can be
  regarded as another level of error. However, treatments may exhibit
  heterogeneous interactions (Steel p.399)

  <subsubsection|Fixed Effect>

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
    <associate|auto-10|<tuple|3.1.0.3|?>>
    <associate|auto-11|<tuple|3.2|?>>
    <associate|auto-12|<tuple|3.3|?>>
    <associate|auto-13|<tuple|3.4|?>>
    <associate|auto-14|<tuple|3.5|?>>
    <associate|auto-15|<tuple|3.6|?>>
    <associate|auto-16|<tuple|3.7|?>>
    <associate|auto-17|<tuple|3.7.1|?>>
    <associate|auto-18|<tuple|4|?>>
    <associate|auto-19|<tuple|1|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|2.1|?>>
    <associate|auto-4|<tuple|2.1.1|?>>
    <associate|auto-5|<tuple|2.1.2|?>>
    <associate|auto-6|<tuple|2.1.2.1|?>>
    <associate|auto-7|<tuple|2.1.2.2|?>>
    <associate|auto-8|<tuple|3|?>>
    <associate|auto-9|<tuple|3.1|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal||<pageref|auto-19>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Abstract>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Assumptions>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <with|par-left|<quote|1tab>|2.1<space|2spc>Decomposing Interaction
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|2tab>|2.1.1<space|2spc>Random Effect
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|2tab>|2.1.2<space|2spc>Fixed Effect
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|4tab>|Non additivity
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Bilinear Model
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.15fn>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Questions>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc>Stability/Regression
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|4tab>|Eberhart and Russell
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10><vspace|0.15fn>>

      <with|par-left|<quote|1tab>|3.2<space|2spc>Decomposition of interaction
      by nonadditivity <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1tab>|3.3<space|2spc>Cluster Identification
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|3.4<space|2spc>Principal Components and
      Biplots <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|1tab>|3.5<space|2spc>Significant Pairs/Outliers
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1tab>|3.6<space|2spc>Alternative Regression
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1tab>|3.7<space|2spc>Dendrogram Cross-over
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|2tab>|3.7.1<space|2spc>Euclidean distance
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Types
      of interactions> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>