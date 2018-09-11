<TeXmacs|1.99.5>

<style|generic>

<\body>
  <doc-data|<doc-title|Spatial Analysis of Lattice Squares>>

  What is the best analysis for this dat set?

  <\session|r|default>
    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tbl12.3 \<less\>- data.frame(

      \ \ rep=c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,

      \ \ \ \ \ \ \ 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,

      \ \ \ \ \ \ \ 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3),

      \ \ trt=as.factor(c(18,24,12,6,5,9,15,3,22,16,11,17,10,4,23,2,

      \ \ \ \ \ \ \ 8,21,20,14,25,1,19,13,7,20,15,25,5,10,17,12,22,2,7,19,

      \ \ \ \ \ \ \ 14,24,4,9,16,11,21,1,6,18,13,23,3,8,19,11,22,5,8,15,7,

      \ \ \ \ \ \ \ 18,21,4,23,20,1,9,12,6,3,14,17,25,2,24,10,13,16)),

      \ \ blk=c(1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,

      \ \ \ \ \ \ \ \ 1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,

      \ \ \ \ \ \ \ \ 1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5),

      \ \ col=c(1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,

      \ \ \ \ \ \ \ \ 1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,

      \ \ \ \ \ \ \ \ 1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5),

      \ \ yield=c(33.3,24.6,28.5,26.7,40.1,30.7,30.8,24.0,27.2,35.7,35.4,

      \ \ \ \ \ \ \ \ \ \ 28.8,28.4,25.6,30.1,30.1,34.8,25.0,25.0,30.3,29.6,32.5,

      \ \ \ \ \ \ \ \ \ \ 35.1,29.4,33.5,30.9,37.2,32.7,32.0,39.8,33.3,31.2,43.0,

      \ \ \ \ \ \ \ \ \ \ 32.8,37.3,38.8,27.9,28.5,31.8,31.9,27.7,27.3,24.7,28.7,

      \ \ \ \ \ \ \ \ \ \ 34.0,34.4,21.6,22.7,32.3,34.3,28.7,19.4,18.3,30.2,34.4,

      \ \ \ \ \ \ \ \ \ \ 26.3,17.3,22.1,27.5,32.8,21.7,16.9,17.5,30.7,31.9,21.9,

      \ \ \ \ \ \ \ \ \ \ 22.6,25.0,28.1,28.8,26.0,24.2,26.9,27.6,30.6)

      )

      \;
    <|unfolded-io>
      tbl12.3 \<less\>- data.frame(

      + \ \ rep=c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,

      + \ \ \ \ \ \ \ 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,

      + \ \ \ \ \ \ \ 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3),

      + \ \ trt=as.factor(c(18,24,12,6,5,9,15,3,22,16,11,17,10,4,23,2,

      + \ \ \ \ \ \ \ 8,21,20,14,25,1,19,13,7,20,15,25,5,10,17,12,22,2,7,19,

      + \ \ \ \ \ \ \ 14,24,4,9,16,11,21,1,6,18,13,23,3,8,19,11,22,5,8,15,7,

      + \ \ \ \ \ \ \ 18,21,4,23,20,1,9,12,6,3,14,17,25,2,24,10,13,16)),

      + \ \ blk=c(1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,

      + \ \ \ \ \ \ \ \ 1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,

      + \ \ \ \ \ \ \ \ 1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5),

      + \ \ col=c(1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,

      + \ \ \ \ \ \ \ \ 1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,

      + \ \ \ \ \ \ \ \ 1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5),

      + \ \ yield=c(33.3,24.6,28.5,26.7,40.1,30.7,30.8,24.0,27.2,35.7,35.4,

      + \ \ \ \ \ \ \ \ \ \ 28.8,28.4,25.6,30.1,30.1,34.8,25.0,25.0,30.3,29.6,32.5,

      + \ \ \ \ \ \ \ \ \ \ 35.1,29.4,33.5,30.9,37.2,32.7,32.0,39.8,33.3,31.2,43.0,

      + \ \ \ \ \ \ \ \ \ \ 32.8,37.3,38.8,27.9,28.5,31.8,31.9,27.7,27.3,24.7,28.7,

      + \ \ \ \ \ \ \ \ \ \ 34.0,34.4,21.6,22.7,32.3,34.3,28.7,19.4,18.3,30.2,34.4,

      + \ \ \ \ \ \ \ \ \ \ 26.3,17.3,22.1,27.5,32.8,21.7,16.9,17.5,30.7,31.9,21.9,

      + \ \ \ \ \ \ \ \ \ \ 22.6,25.0,28.1,28.8,26.0,24.2,26.9,27.6,30.6)

      + )

      \<gtr\>\ 
    </unfolded-io>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    \;

    <\textput>
      This document outlines the functionality required for a function to
      automate comparative spatial analysis of lattice squares. \ This
      function will assume a data set with yield, rep, row and col and will\ 

      <\enumerate-numeric>
        <item>fit mixed effects model

        <item>fit fixed effect spatial trend model

        <item>fit neighbor model

        <item>fit correlated errors spatial model

        <item>plot means for spatial models against mixed effects model
      </enumerate-numeric>

      We will use row and col as factors and assume x,y as spatial
      covariates. We convert, outside the function, from rows to x and y. We
      might not know inside the function how replicates are stacked.

      \;

      We also need to check if we can assume reps increment in the same
      direction as blocks.\ 

      \;
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      tbl12.3$row \<less\>- tbl12.3$blk

      tbl12.3$x \<less\>- tbl12.3$col

      rows \<less\>- max(tbl12.3$row)

      tbl12.3$y \<less\>- (tbl12.3$rep-1)*rows + tbl12.3$row

      tbl12.3$rep \<less\>- as.factor(tbl12.3$rep)

      tbl12.3$row \<less\>- as.factor(tbl12.3$row)

      tbl12.3$col \<less\>- as.factor(tbl12.3$col)
    <|unfolded-io>
      tbl12.3$row \<less\>- tbl12.3$blk

      \<gtr\> tbl12.3$x \<less\>- tbl12.3$col

      \<gtr\> rows \<less\>- max(tbl12.3$row)

      \<gtr\> tbl12.3$y \<less\>- (tbl12.3$rep-1)*rows + tbl12.3$row

      \<gtr\> tbl12.3$rep \<less\>- as.factor(tbl12.3$rep)

      \<gtr\> tbl12.3$row \<less\>- as.factor(tbl12.3$row)

      \<gtr\> tbl12.3$col \<less\>- as.factor(tbl12.3$col)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      arm.dat \<less\>- tbl12.3
    <|unfolded-io>
      arm.dat \<less\>- tbl12.3
    </unfolded-io>

    <\textput>
      \;

      \;

      <section|Fixed Effects Model>

      We'll want a baseline for unadjusted means. We do this with a simple
      linear model.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      ls11.lm \<less\>- lm(yield ~ rep + row:rep + col:rep + trt,
      data=arm.dat)

      anova(ls11.lm)

      \;
    <|unfolded-io>
      ls11.lm \<less\>- lm(yield ~ rep + row:rep + col:rep + trt,
      data=arm.dat)

      \<gtr\> anova(ls11.lm)

      Analysis of Variance Table

      \;

      Response: yield

      \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ \ Pr(\<gtr\>F) \ \ \ 

      rep \ \ \ \ \ \ \ 2 546.88 273.438 28.5581 \ \ 4.5e-07 ***

      trt \ \ \ \ \ \ 24 611.08 \ 25.462 \ 2.6592 0.0099961 **\ 

      rep:row \ \ 12 585.63 \ 48.803 \ 5.0970 0.0003468 ***

      rep:col \ \ 12 238.21 \ 19.851 \ 2.0732 0.0620832 . \ 

      Residuals 24 229.80 \ \ 9.575 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

      \<gtr\>\ 
    </unfolded-io>

    \;

    <\textput>
      <section|Mixed Models>

      \;

      Start with the mixed model analysis.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      library(lme4)

      ls11.lmer \<less\>- lmer(yield ~ trt + (1\|rep) + (1\|row:rep) +
      (1\|col:rep), data=arm.dat)
    <|unfolded-io>
      library(lme4)

      Loading required package: Matrix

      \<gtr\> ls11.lmer \<less\>- lmer(yield ~ trt + (1\|rep) + (1\|row:rep)
      + (1\|col:rep), data=a

      \<less\> trt + (1\|rep) + (1\|row:rep) + (1\|col:rep), data=arm.dat)
    </unfolded-io>

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
      \;
    </input>

    <\textput>
      \;

      <section|Trend Analysis>

      \;
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      crd.lm \<less\>- lm(yield~trt,data=arm.dat)

      print(crd.aov.tbl \<less\>- anova(crd.lm))
    <|unfolded-io>
      crd.lm \<less\>- lm(yield~trt,data=arm.dat)

      \<gtr\> print(crd.aov.tbl \<less\>- anova(crd.lm))

      Analysis of Variance Table

      \;

      Response: yield

      \ \ \ \ \ \ \ \ \ \ Df \ Sum Sq Mean Sq F value Pr(\<gtr\>F)

      trt \ \ \ \ \ \ 24 \ 611.08 \ 25.462 \ 0.7954 0.7246

      Residuals 50 1600.51 \ 32.010 \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
    </unfolded-io>

    <\textput>
      Residuals from the treatment only model.
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      trend1.lm \<less\>- update(crd.lm, . ~ y + x + . )

      trend2.lm \<less\>- update(crd.lm, . ~ y + x + I(y^2) + I(x^2) + I(y*x)
      + . )

      trend3.lm \<less\>- update(crd.lm, . ~ y + x + I(y^2) + I(x^2) + I(y*x)
      + I(y^3) + I(x^3) + I(y*x^2) + I(y^2*x) + . )
    <|unfolded-io>
      trend1.lm \<less\>- update(crd.lm, . ~ y + x + . )

      \<gtr\> trend2.lm \<less\>- update(crd.lm, . ~ y + x + I(y^2) + I(x^2)
      + I(y*x) + . )

      \<gtr\> trend3.lm \<less\>- update(crd.lm, . ~ y + x + I(y^2) + I(x^2)
      + I(y*x) + I(y^3) +

      \<less\>m, . ~ y + x + I(y^2) + I(x^2) + I(y*x) + I(y^3) + I(x^3) +
      I(y*x^2) + I(y^2

      \<less\>x^2) + I(y*x) + I(y^3) + I(x^3) + I(y*x^2) + I(y^2*x) + . )
    </unfolded-io>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\textput>
      \;
    </textput>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
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
      \;
    </input>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    <\textput>
      <section|Nearest Neighbor>

      \;
    </textput>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      in.range \<less\>- function(x,a,b) {

      \ \ if (a \<gtr\> b) {

      \ \ \ \ return((x\<gtr\>=b) & (x\<less\>=a))

      \ \ } else {

      \ \ \ \ return((x\<gtr\>=a) & (x\<less\>=b))

      \ \ }

      }
    <|unfolded-io>
      in.range \<less\>- function(x,a,b) {

      + \ \ if (a \<gtr\> b) {

      + \ \ \ \ return((x\<gtr\>=b) & (x\<less\>=a))

      + \ \ } else {

      + \ \ \ \ return((x\<gtr\>=a) & (x\<less\>=b))

      + \ \ }

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      plots \<less\>- dim(arm.dat)[1]

      cols \<less\>- max(arm.dat$x)

      rows \<less\>- max(arm.dat$y)

      col.space \<less\>- 1

      row.space \<less\>- 1

      mat.dim \<less\>- rows*cols
    <|unfolded-io>
      plots \<less\>- dim(arm.dat)[1]

      \<gtr\> cols \<less\>- max(arm.dat$x)

      \<gtr\> rows \<less\>- max(arm.dat$y)

      \<gtr\> col.space \<less\>- 1

      \<gtr\> row.space \<less\>- 1

      \<gtr\> mat.dim \<less\>- rows*cols
    </unfolded-io>

    \;

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      trial.map \<less\>- data.frame(x=arm.dat$x,y=arm.dat$y,cell=rep(0,length(arm.dat$x)))

      W.row \<less\>- matrix(rep(0, mat.dim*mat.dim),nrow=mat.dim)

      W.col \<less\>- matrix(rep(0, mat.dim*mat.dim),nrow=mat.dim)

      for (i in 1: plots) {

      \ \ r \<less\>- arm.dat$y[i]

      \ \ c \<less\>- arm.dat$x[i]

      \ \ trial.map$cell[trial.map$x==c & trial.map$y==r] \<less\>- i

      }

      \;

      for (i in 1:plots) {

      \ \ r \<less\>- arm.dat$y[i]

      \ \ c \<less\>- arm.dat$x[i]

      \ \ if(in.range(r,1,rows) & in.range(c-1,1,cols)) {

      \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==(c-1) &
      trial.map$y==r]

      \ \ \ \ \ W.row[i,idx] \<less\>- 1/col.space

      \ \ }

      \ \ if(in.range(r,1,rows) & in.range(c+1,1,cols)) {

      \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==(c+1) &
      trial.map$y==r]

      \ \ \ \ \ W.row[i,idx] \<less\>- 1/col.space

      \ \ }

      \ \ if(in.range(r-1,1,rows) & in.range(c,1,cols)) {

      \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==c &
      trial.map$y==(r-1)]

      \ \ \ \ \ W.col[i,idx] \<less\>- 1/row.space

      \ \ }

      \ \ if(in.range(r+1,1,rows) & in.range(c,1,cols)) {

      \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==c &
      trial.map$y==(r+1)]

      \ \ \ \ \ W.col[i,idx] \<less\>- 1/row.space

      \ \ }

      }
    <|unfolded-io>
      trial.map \<less\>- data.frame(x=arm.dat$x,y=arm.dat$y,cell=rep(0,length(arm.dat$x

      \<less\>=arm.dat$x,y=arm.dat$y,cell=rep(0,length(arm.dat$x)))

      \<gtr\> W.row \<less\>- matrix(rep(0, mat.dim*mat.dim),nrow=mat.dim)

      \<gtr\> W.col \<less\>- matrix(rep(0, mat.dim*mat.dim),nrow=mat.dim)

      \<gtr\> for (i in 1: plots) {

      + \ \ r \<less\>- arm.dat$y[i]

      + \ \ c \<less\>- arm.dat$x[i]

      + \ \ trial.map$cell[trial.map$x==c & trial.map$y==r] \<less\>- i

      + }

      \<gtr\>\ 

      \<gtr\> for (i in 1:plots) {

      + \ \ r \<less\>- arm.dat$y[i]

      + \ \ c \<less\>- arm.dat$x[i]

      + \ \ if(in.range(r,1,rows) & in.range(c-1,1,cols)) {

      + \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==(c-1) &
      trial.map$y==r]

      + \ \ \ \ \ W.row[i,idx] \<less\>- 1/col.space

      + \ \ }

      + \ \ if(in.range(r,1,rows) & in.range(c+1,1,cols)) {

      + \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==(c+1) &
      trial.map$y==r]

      + \ \ \ \ \ W.row[i,idx] \<less\>- 1/col.space

      + \ \ }

      + \ \ if(in.range(r-1,1,rows) & in.range(c,1,cols)) {

      + \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==c &
      trial.map$y==(r-1)]

      + \ \ \ \ \ W.col[i,idx] \<less\>- 1/row.space

      + \ \ }

      + \ \ if(in.range(r+1,1,rows) & in.range(c,1,cols)) {

      + \ \ \ \ \ idx \<less\>-trial.map$cell[trial.map$x==c &
      trial.map$y==(r+1)]

      + \ \ \ \ \ W.col[i,idx] \<less\>- 1/row.space

      + \ \ }

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      W \<less\>- W.col + W.row

      for (i in 1: mat.dim) {

      \ \ tmp \<less\>- sum(W[i,])

      \ \ if(tmp\<gtr\>0) {

      \ \ \ \ W[i,] \<less\>- W[i,]/tmp

      \ \ }

      \ \ tmp \<less\>- sum(W.col[i,])

      \ \ if(tmp\<gtr\>0) { \ \ \ \ 

      \ \ \ \ \ W.col[i,] \<less\>- W.col[i,]/tmp

      \ \ }

      \ \ tmp \<less\>- sum(W.row[i,])

      \ \ if(tmp\<gtr\>0) {

      \ \ \ \ W.row[i,] \<less\>- W.row[i,]/tmp

      \ \ }

      }
    <|unfolded-io>
      W \<less\>- W.col + W.row

      \<gtr\> for (i in 1: mat.dim) {

      + \ \ tmp \<less\>- sum(W[i,])

      + \ \ if(tmp\<gtr\>0) {

      + \ \ \ \ W[i,] \<less\>- W[i,]/tmp

      + \ \ }

      + \ \ tmp \<less\>- sum(W.col[i,])

      + \ \ if(tmp\<gtr\>0) { \ \ \ \ 

      + \ \ \ \ \ W.col[i,] \<less\>- W.col[i,]/tmp

      + \ \ }

      + \ \ tmp \<less\>- sum(W.row[i,])

      + \ \ if(tmp\<gtr\>0) {

      + \ \ \ \ W.row[i,] \<less\>- W.row[i,]/tmp

      + \ \ }

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      empty \<less\>- which(rowSums(W) == 0)

      if(length(empty)\<gtr\>0) {

      \ \ W \<less\>- W[-empty,-empty]

      }

      empty \<less\>- which(rowSums(W.col) == 0)

      if(length(empty)\<gtr\>0) {

      \ \ W.col \<less\>- W.col[-empty,-empty]

      }

      empty \<less\>- which(rowSums(W.row)==0)

      if(length(empty)\<gtr\>0) {

      \ \ W.row \<less\>- W.row[-empty,-empty]

      }
    <|unfolded-io>
      empty \<less\>- which(rowSums(W) == 0)

      \<gtr\> if(length(empty)\<gtr\>0) {

      + \ \ W \<less\>- W[-empty,-empty]

      + }

      \<gtr\> empty \<less\>- which(rowSums(W.col) == 0)

      \<gtr\> if(length(empty)\<gtr\>0) {

      + \ \ W.col \<less\>- W.col[-empty,-empty]

      + }

      \<gtr\> empty \<less\>- which(rowSums(W.row)==0)

      \<gtr\> if(length(empty)\<gtr\>0) {

      + \ \ W.row \<less\>- W.row[-empty,-empty]

      + }
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      arm.dat$X = W %*% crd.lm$resid

      arm.dat$X.row = W.row %*% crd.lm$resid

      arm.dat$X.col = W.col %*% crd.lm$resid
    <|unfolded-io>
      arm.dat$X = W %*% crd.lm$resid

      \<gtr\> arm.dat$X.row = W.row %*% crd.lm$resid

      \<gtr\> arm.dat$X.col = W.col %*% crd.lm$resid
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      nnx.lm \<less\>- update(crd.lm, . ~ X.col + . , data=arm.dat)

      nny.lm \<less\>- update(crd.lm, . ~ X.row + . , data=arm.dat)

      nnxy.lm \<less\>- update(crd.lm, . ~ X + . , data=arm.dat)

      nns.lm \<less\>- update(crd.lm, . ~ X.col + X.row + . , data=arm.dat)
    <|unfolded-io>
      nnx.lm \<less\>- update(crd.lm, . ~ X.col + . , data=arm.dat)

      \<gtr\> nny.lm \<less\>- update(crd.lm, . ~ X.row + . , data=arm.dat)

      \<gtr\> nnxy.lm \<less\>- update(crd.lm, . ~ X + . , data=arm.dat)

      \<gtr\> nns.lm \<less\>- update(crd.lm, . ~ X.col + X.row + . ,
      data=arm.dat)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      print(anova.tbl \<less\>- anova(crd.lm, ls11.lm, trend1.lm, trend2.lm,
      trend3.lm, nnx.lm, nny.lm, nnxy.lm, nns.lm,test="F"))

      anova(crd.lm, ls11.lm, trend1.lm, trend2.lm, trend3.lm, nnx.lm, nny.lm,
      nnxy.lm, nns.lm,test="Chi")
    <|unfolded-io>
      print(anova.tbl \<less\>- anova(crd.lm, ls11.lm, trend1.lm, trend2.lm,
      trend3.lm,\ 

      \<less\>crd.lm, ls11.lm, trend1.lm, trend2.lm, trend3.lm, nnx.lm,
      nny.lm, nnxy.lm, n

      \<less\>, trend2.lm, trend3.lm, nnx.lm, nny.lm, nnxy.lm,
      nns.lm,test="F"))

      Analysis of Variance Table

      \;

      Model 1: yield ~ trt

      Model 2: yield ~ rep + row:rep + col:rep + trt

      Model 3: yield ~ y + x + trt

      Model 4: yield ~ y + x + I(y^2) + I(x^2) + I(y * x) + trt

      Model 5: yield ~ y + x + I(y^2) + I(x^2) + I(y * x) + I(y^3) + I(x^3) +\ 

      \ \ \ \ I(y * x^2) + I(y^2 * x) + trt

      Model 6: yield ~ X.col + trt

      Model 7: yield ~ X.row + trt

      Model 8: yield ~ X + trt

      Model 9: yield ~ X.col + X.row + trt

      \ \ Res.Df \ \ \ \ RSS \ Df Sum of Sq \ \ \ \ \ \ F \ \ \ Pr(\<gtr\>F)
      \ \ \ 

      1 \ \ \ \ 50 1600.51 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      2 \ \ \ \ 24 \ 229.80 \ 26 \ \ 1370.72 \ 5.5061 3.805e-05 ***

      3 \ \ \ \ 48 1437.23 -24 \ -1207.43 \ 5.2544 6.584e-05 ***

      4 \ \ \ \ 45 1384.45 \ \ 3 \ \ \ \ 52.78 \ 1.8373 \ 0.167340 \ \ \ 

      5 \ \ \ \ 41 1201.28 \ \ 4 \ \ \ 183.17 \ 4.7827 \ 0.005572 **\ 

      6 \ \ \ \ 49 1171.28 \ -8 \ \ \ \ 30.00
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      7 \ \ \ \ 49 \ 627.68 \ \ 0 \ \ \ 543.60
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      8 \ \ \ \ 49 \ 737.64 \ \ 0 \ \ -109.96
      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      9 \ \ \ \ 48 \ 604.36 \ \ 1 \ \ \ 133.28 13.9201 \ 0.001037 **\ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

      \<gtr\> anova(crd.lm, ls11.lm, trend1.lm, trend2.lm, trend3.lm, nnx.lm,
      nny.lm, nnx

      \<less\>end1.lm, trend2.lm, trend3.lm, nnx.lm, nny.lm, nnxy.lm,
      nns.lm,test="Chi")

      Analysis of Variance Table

      \;

      Model 1: yield ~ trt

      Model 2: yield ~ rep + row:rep + col:rep + trt

      Model 3: yield ~ y + x + trt

      Model 4: yield ~ y + x + I(y^2) + I(x^2) + I(y * x) + trt

      Model 5: yield ~ y + x + I(y^2) + I(x^2) + I(y * x) + I(y^3) + I(x^3) +\ 

      \ \ \ \ I(y * x^2) + I(y^2 * x) + trt

      Model 6: yield ~ X.col + trt

      Model 7: yield ~ X.row + trt

      Model 8: yield ~ X + trt

      Model 9: yield ~ X.col + X.row + trt

      \ \ Res.Df \ \ \ \ RSS \ Df Sum of Sq \ Pr(\<gtr\>Chi) \ \ \ 

      1 \ \ \ \ 50 1600.51 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      2 \ \ \ \ 24 \ 229.80 \ 26 \ \ 1370.72 \<less\> 2.2e-16 ***

      3 \ \ \ \ 48 1437.23 -24 \ -1207.43 \ 7.83e-16 ***

      4 \ \ \ \ 45 1384.45 \ \ 3 \ \ \ \ 52.78 0.1379259 \ \ \ 

      5 \ \ \ \ 41 1201.28 \ \ 4 \ \ \ 183.17 0.0007408 ***

      6 \ \ \ \ 49 1171.28 \ -8 \ \ \ \ 30.00 \ \ \ \ \ \ \ \ \ \ \ \ \ 

      7 \ \ \ \ 49 \ 627.68 \ \ 0 \ \ \ 543.60 \ \ \ \ \ \ \ \ \ \ \ \ \ 

      8 \ \ \ \ 49 \ 737.64 \ \ 0 \ \ -109.96 \ \ \ \ \ \ \ \ \ \ \ \ \ 

      9 \ \ \ \ 48 \ 604.36 \ \ 1 \ \ \ 133.28 0.0001908 ***

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      anova.tbl$AIC \<less\>- c(AIC(crd.lm), AIC(ls11.lm), AIC(trend1.lm),
      AIC(trend2.lm), AIC(trend3.lm), AIC(nnx.lm), AIC(nny.lm), AIC(nnxy.lm),
      AIC(nns.lm))

      anova.tbl$BIC \<less\>- c(BIC(crd.lm), BIC(ls11.lm), BIC(trend1.lm),
      BIC(trend2.lm), BIC(trend3.lm), BIC(nnx.lm), BIC(nny.lm), BIC(nnxy.lm),
      BIC(nns.lm))

      anova.tbl$RMS \<less\>- anova.tbl$RSS/anova.tbl$Res.Df

      anova.tbl$logLik \<less\>- c(logLik(crd.lm), logLik(ls11.lm),
      logLik(trend1.lm), logLik(trend2.lm), logLik(trend3.lm),
      logLik(nnx.lm), logLik(nny.lm), logLik(nnxy.lm), logLik(nns.lm))

      anova.tbl$LR = 2*(anova.tbl$logLik - anova.tbl$logLik[2])

      anova.tbl$LRdf = anova.tbl$Res.Df - anova.tbl$Res.Df[2]

      anova.tbl$LRP = pchisq(q=anova.tbl$LR,df=anova.tbl$LRdf)

      print(best.tbl \<less\>- anova.tbl[,c("RMS","AIC","BIC","logLik","LR","LRdf")])
    <|unfolded-io>
      anova.tbl$AIC \<less\>- c(AIC(crd.lm), AIC(ls11.lm), AIC(trend1.lm),
      AIC(trend2.lm

      \<less\>d.lm), AIC(ls11.lm), AIC(trend1.lm), AIC(trend2.lm),
      AIC(trend3.lm), AIC(nnx

      \<less\>rend1.lm), AIC(trend2.lm), AIC(trend3.lm), AIC(nnx.lm),
      AIC(nny.lm), AIC(nnx

      \<less\> AIC(trend3.lm), AIC(nnx.lm), AIC(nny.lm), AIC(nnxy.lm),
      AIC(nns.lm))

      \<gtr\> anova.tbl$BIC \<less\>- c(BIC(crd.lm), BIC(ls11.lm),
      BIC(trend1.lm), BIC(trend2.lm

      \<less\>d.lm), BIC(ls11.lm), BIC(trend1.lm), BIC(trend2.lm),
      BIC(trend3.lm), BIC(nnx

      \<less\>rend1.lm), BIC(trend2.lm), BIC(trend3.lm), BIC(nnx.lm),
      BIC(nny.lm), BIC(nnx

      \<less\> BIC(trend3.lm), BIC(nnx.lm), BIC(nny.lm), BIC(nnxy.lm),
      BIC(nns.lm))

      \<gtr\> anova.tbl$RMS \<less\>- anova.tbl$RSS/anova.tbl$Res.Df

      \<gtr\> anova.tbl$logLik \<less\>- c(logLik(crd.lm), logLik(ls11.lm),
      logLik(trend1.lm), l

      \<less\>Lik(crd.lm), logLik(ls11.lm), logLik(trend1.lm),
      logLik(trend2.lm), logLik(t

      \<less\>m), logLik(trend1.lm), logLik(trend2.lm), logLik(trend3.lm),
      logLik(nnx.lm),

      \<less\>Lik(trend2.lm), logLik(trend3.lm), logLik(nnx.lm),
      logLik(nny.lm), logLik(nn

      \<less\>nd3.lm), logLik(nnx.lm), logLik(nny.lm), logLik(nnxy.lm),
      logLik(nns.lm))

      \<gtr\> anova.tbl$LR = 2*(anova.tbl$logLik - anova.tbl$logLik[2])

      \<gtr\> anova.tbl$LRdf = anova.tbl$Res.Df - anova.tbl$Res.Df[2]

      \<gtr\> anova.tbl$LRP = pchisq(q=anova.tbl$LR,df=anova.tbl$LRdf)

      \<gtr\> print(best.tbl \<less\>- anova.tbl[,c("RMS","AIC","BIC","logLik","LR","LRdf")])

      \ \ \ \ \ RMS \ \ \ AIC \ \ \ BIC \ logLik \ \ \ \ \ \ LR LRdf

      1 32.010 494.39 554.64 -221.19 -145.567 \ \ 26

      2 \ 9.575 400.82 521.33 -148.41 \ \ \ 0.000 \ \ \ 0

      3 29.942 490.31 555.20 -217.16 -137.496 \ \ 24

      4 30.766 493.51 565.35 -215.75 -134.690 \ \ 21

      5 29.300 490.86 571.98 -210.43 -124.046 \ \ 17

      6 23.904 472.97 535.54 -209.48 -122.150 \ \ 25

      7 12.810 426.18 488.75 -186.09 \ -75.363 \ \ 25

      8 15.054 438.29 500.86 -192.14 \ -87.470 \ \ 25

      9 12.591 425.34 490.23 -184.67 \ -72.523 \ \ 24
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      min.aic \<less\>- min(anova.tbl$AIC)

      min.bic \<less\>- min(anova.tbl$BIC)

      min.rms \<less\>- min(anova.tbl$RMS)

      best.aic \<less\>- which(anova.tbl$AIC==min.aic)

      best.bic \<less\>- which(anova.tbl$BIC==min.bic)

      best.rms \<less\>- which(anova.tbl$RMS==min.rms)
    <|unfolded-io>
      min.aic \<less\>- min(anova.tbl$AIC)

      \<gtr\> min.bic \<less\>- min(anova.tbl$BIC)

      \<gtr\> min.rms \<less\>- min(anova.tbl$RMS)

      \<gtr\> best.aic \<less\>- which(anova.tbl$AIC==min.aic)

      \<gtr\> best.bic \<less\>- which(anova.tbl$BIC==min.bic)

      \<gtr\> best.rms \<less\>- which(anova.tbl$RMS==min.rms)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      model.list \<less\>- list(crd.lm, ls11.lm, trend1.lm, trend2.lm,
      trend3.lm, nnx.lm, nny.lm, nnxy.lm, nns.lm)
    <|unfolded-io>
      model.list \<less\>- list(crd.lm, ls11.lm, trend1.lm, trend2.lm,
      trend3.lm, nnx.lm

      \<less\>, ls11.lm, trend1.lm, trend2.lm, trend3.lm, nnx.lm, nny.lm,
      nnxy.lm, nns.lm)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      best.lm \<less\>- model.list[[which(anova.tbl$AIC==min.aic)]]
    <|unfolded-io>
      best.lm \<less\>- model.list[[which(anova.tbl$AIC==min.aic)]]
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      anova(best.lm)
    <|unfolded-io>
      anova(best.lm)

      Analysis of Variance Table

      \;

      Response: yield

      \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ \ Pr(\<gtr\>F) \ \ \ 

      rep \ \ \ \ \ \ \ 2 546.88 273.438 28.5581 \ \ 4.5e-07 ***

      trt \ \ \ \ \ \ 24 611.08 \ 25.462 \ 2.6592 0.0099961 **\ 

      rep:row \ \ 12 585.63 \ 48.803 \ 5.0970 0.0003468 ***

      rep:col \ \ 12 238.21 \ 19.851 \ 2.0732 0.0620832 . \ 

      Residuals 24 229.80 \ \ 9.575 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

      ---

      Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      AIC(ls11.lmer)
    <|unfolded-io>
      AIC(ls11.lmer)

      [1] 375.313
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      BIC(ls11.lmer)
    <|unfolded-io>
      BIC(ls11.lmer)

      [1] 442.5201
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      AIC(update(ls11.lmer,REML=FALSE))
    <|unfolded-io>
      AIC(update(ls11.lmer,REML=FALSE))

      [1] 452.3804
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      <code|<code*|best.tbl \<less\>- rbind(c(best.rms,best.aic,best.bic),best.tbl)>>
    <|unfolded-io>
      best.tbl \<less\>- rbind(c(best.rms,best.aic,best.bic),best.tbl)
    </unfolded-io>

    <\unfolded-io>
      <with|color|red|\<gtr\> >
    <|unfolded-io>
      best.tbl
    <|unfolded-io>
      best.tbl

      \ \ \ \ \ \ RMS \ \ \ AIC \ \ \ BIC

      1 \ \ 2.000 \ \ 2.00 \ \ 7.00

      11 32.010 494.39 554.64

      2 \ \ 9.575 400.82 521.33

      3 \ 29.942 490.31 555.20

      4 \ 30.766 493.51 565.35

      5 \ 29.300 490.86 571.98

      6 \ 23.904 472.97 535.54

      7 \ 12.810 426.18 488.75

      8 \ 15.054 438.29 500.86

      9 \ 12.591 425.34 490.23
    </unfolded-io>

    <\input>
      <with|color|red|\<gtr\> >
    <|input>
      \;
    </input>

    \;
  </session>

  \;

  \;
</body>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|4|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Fixed
      Effects Model> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Mixed
      Models> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Trend
      Analysis> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Nearest
      Neighbor> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>