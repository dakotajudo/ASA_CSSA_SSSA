source('c:/code/ARM/bin/ARMSTr.r')
setwd('C:/Users/peter/AppData/Local/Temp/ARM/3044/')
options(OutDec='.')
st.dat <- read.delim('C:/Users/peter/AppData/Local/Temp/ARM/3044/st.dat',header=TRUE)
st.dat$Trial <- as.factor(st.dat$Trial)
st.dat$Treatment <- as.factor(st.dat$Treatment)
st.dat$RepNo <- as.factor(st.dat$RepNo)
tryCatch({
   res <- analyze.ARMST.rcb.1df(st.dat,trialRandom=TRUE)
   aov.tbl <- tryCatch({
      means.tbl <- tryCatch({
         data.frame(trt=as.integer(levels(st.dat$Treatment)),arith=res$raw_means,lsmean=res$ls_means$means)
         }, error = function(e) {
         cat(geterrmessage(),file='R.err')
         cat("means.tbl <- data.frame(trt=as.integer(levels(st.dat$Treatment)),arith=res$raw_means,lsmean=res$ls_means$means)\r",file='R.out')
      })
      write.table(means.tbl,file='means.tab',row.names=FALSE,col.names=FALSE,sep='\t')
      make.table(res$AovVar)
      }, error = function(e) {
      cat(geterrmessage(),file='R.err')
      cat("aov.tbl <- make.table(res$AovVar)\r",file='R.out')
   })
   write.table(aov.tbl,file='aov.tab',row.names=TRUE,col.names=FALSE,sep='\t')
   write.table(res$varCov,file='varCov.tab',row.names=FALSE,col.names=FALSE,sep='\t')
   write.table(res$concurrence,file='concurrence.tab',row.names=FALSE,col.names=FALSE,sep='\t')
   means.vector <- res$ls_means$trial
   means.matrix <- matrix(res$ls_means$txt,nrow=length(means.vector),byrow=TRUE)
   write.table(means.vector,file='trialMeans.SmyCol1.tab',row.names=FALSE,col.names=FALSE,sep='\t')
   write.table(means.matrix,file='trialTable.SmyCol1.tab',row.names=FALSE,col.names=FALSE,sep='\t')
   tdf = nonadditivity.gei(st.dat)
   het = heterogeneity.gei(st.dat)
   tdf.tbl <- anova(tdf$multiplicative.lm)
   het.tbl <- anova(het$heterogeneous.lm)
   tdf.tbl <- recompute.tdf.aov(tdf.tbl,aov.tbl)
   het.tbl <- recompute.tdf.aov(het.tbl,aov.tbl)
   write.table(tdf.tbl,file='tdf.tab',row.names=TRUE,col.names=FALSE,sep='\t')
   write.table(het.tbl,file='het.tab',row.names=TRUE,col.names=FALSE,sep='\t')
   write.table(summary(tdf$multiplicative.lm)$coefficients,file='tdfcoef.tab',row.names=TRUE,col.names=FALSE,sep='\t')
   write.table(summary(het$heterogeneous0.lm)$coefficients,file='hetcoef.tab',row.names=TRUE,col.names=FALSE,sep='\t')
   }, error = function(e) {
   cat(geterrmessage(),file='R.err')
   cat("res <- analyze.ARMST.rcb.1df(st.dat,trialRandom=TRUE)\r",file='R.out')
})
