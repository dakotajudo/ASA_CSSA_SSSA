rcb.analysis <- function(current.dat,REML=TRUE) {
  require(nlme)
  #is there valid data?
  current.dat <- subset(current.dat,!is.na(current.dat$Yield))
  if(dim(current.dat)[1]<4) {
    return(NULL)
  }
  aov.tbl <- summary(aov(Yield ~ as.factor(trt)+as.factor(rep),data=current.dat))
  RepVar <- NA
  ResVar <- NA
  aov.mle <- NULL
  if(REML) {
    try(aov.mle <- lme(Yield ~ as.factor(trt), random = ~ 1| as.factor(rep), data=current.dat))
    if(!is.null(aov.mle)) {
      var.tbl <- VarCorr(aov.mle)
      RepVar = as.numeric(var.tbl[1])
      ResVar = as.numeric(var.tbl[2])
    }
  }

  #posthoc power
  means <- tapply(current.dat$Yield,list(current.dat$trt),mean)
  GrandMean=mean(current.dat$Yield)
  ResMS = aov.tbl[[1]][3,3]
  SD <- sqrt(ResMS)
  CV=100*SD/GrandMean
  PerMeanDiff=100*(max(means)-min(means))/GrandMean
  
  RepDF <- aov.tbl[[1]][2,1]
  TrtDF = aov.tbl[[1]][1,1]
  ResDF = aov.tbl[[1]][3,1]
  
  effect.size <- PerMeanDiff/CV

  return(data.frame(
    TrtDF = TrtDF,
    TrtMS = aov.tbl[[1]][1,3],
    TrtP = aov.tbl[[1]][1,5],
    RepDF = RepDF,
    RepMS = aov.tbl[[1]][2,3],
    RepVar = RepVar,
    RepP = aov.tbl[[1]][2,5],
    ResDF = aov.tbl[[1]][3,1],
    ResMS = ResMS,
    ResVar = ResVar,
    GrandMean=GrandMean,
    SD=SD,
    CV=CV,
    PerMeanDiff=PerMeanDiff,
    EffectSize=effect.size
  ))
}
