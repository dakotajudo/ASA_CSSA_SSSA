automate.analysis <- function(model) {
   require(lsmeans)
   require(multcomp)
   require(ggplot2)
   print(paste,"Analyzing model of class",class(model),"\n")
   print(summary(model))
   print(anova(model))
   print("Variance/Covariance\n")
   vcov(model)
   print("Hypothesis Testing\n")
   print(cld(glht(model,linfct=mcp(trt="Tukey")),decreasing=TRUE))
   print(lsmeans(model,cld ~ trt))
   return(plot.lsmeans(model))
}