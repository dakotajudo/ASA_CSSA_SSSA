heterogeneity.gei <- function(data=NULL,
                                       response = "Plot.Mean",
                                       TreatmentName = "Treatment",
                                       TrialName = "Trial",
                                       BlockName = NULL
) {
  #start with non-addivity model
  nonadditivity.res <- nonadditivity.gei(data=data,
                                response = response,
                                TreatmentName = TreatmentName,
                                TrialName = TrialName,
                                BlockName = BlockName
  )
  return(update.for.heterogeneity(nonadditivity.res,heterogeneousEffect=TreatmentName,covariateEffect=TrialName))
}

update.for.heterogeneity <- function(nonadditivity.res,
                                     heterogeneousEffect="Treatment",
                                     covariateEffect="Trial") {

  #get the formula from the additive model
  form <- as.formula(nonadditivity.res$additive.lm$terms)
  #update with the appropriate crossed effects
  form <- update(form, paste(". ~ . + ",heterogeneousEffect,":e",covariateEffect,sep=""))
  #I woudl prefer to use update on the lm, but I haven't figured that out.
  heterogeneous.lm <- lm(form,data=nonadditivity.res$multiplicative.lm$model)
  #form <- update(form, paste(". ~ 0 + ",heterogeneousEffect,":e",covariateEffect,sep=""))
  form <- update(form, paste(". ~ 0 + ",heterogeneousEffect," + ",heterogeneousEffect,":e",covariateEffect,sep=""))
  
  heterogeneous0.lm <- lm(form,data=nonadditivity.res$multiplicative.lm$model)

  return(list(additive.lm=nonadditivity.res$additive.lm,
              multiplicative.lm=nonadditivity.res$multiplicative.lm,
              heterogeneous.lm=heterogeneous.lm,
              heterogeneous0.lm=heterogeneous0.lm,
              t=nonadditivity.res$t,
              e=nonadditivity.res$e))
}

extract.slopes <- function(het0.tbl,df) {
  rows <- dim(het0.tbl)[1]
  trts <- rows/2
  ret.tbl <- het0.tbl[(trts+1):rows,]
  ret.tbl[,3] <- (ret.tbl[,1]-1)/ret.tbl[,2]
  ret.tbl[,4] <- pt(abs(ret.tbl[,3]),df,lower.tail=FALSE)
  return(ret.tbl)
} 

################################################
# Assume tdf.tbl
#                Df         SS         MS      Fval          prF
#   Trial         
#   Treatment     
#   Error        
#     Additivity  
#     Residual   
#
# and het.tbl
#                   Df Sum Sq Mean Sq F value    Pr(>F)    
#   Treatment         
#   Trial             
#   Treatment:eTrial      
#   Residuals    
#
# This function replaces  Addivity rows with Heterogeneity rows
recompute.het.aov <- function(het.tbl,tdf.tbl) {
  
  ret <- tdf.tbl
  #use an index for the new last row
  last = dim(ret)[1]
  #this is assumed from requirements
  resid.row <- 3
  #copy the interaction term (heterogeneity of slopes)
  ret[(last-1),] <- het.tbl[3,]
  
  #subtract SS and DF
  ret[last,1] <- tdf.tbl[resid.row,1] - ret[(last-1),1]
  ret[last,2] <- tdf.tbl[resid.row,2] - ret[(last-1),2]
  #recompute residual MS
  if(ret[last,1]>0) {
    ret[last,3] <- ret[last,2]/ret[last,1]
    #compute signficance
    ret[last-1,4] <- ret[last-1,3]/ret[last,3]
    ret[last-1,5] <- 1-pf(ret[last-1,4],ret[last-1,1],ret[last,1])
  } else {
    ret[last,3] <- NA
    ret[last-1,4] <- NA
    ret[last-1,5] <- NA
    ret[last,4] <- NA
    ret[last,5] <- NA
  }
  
  rownames(ret)[last-1] <- "  Heterogeneity"
  rownames(ret)[last] <- "  Heterogeneity Residual"
  return(ret)
}

print.heterogeneity.gei <- function(res) {
  print.nonadditivity.gei(res)
  print("",quote = FALSE)
  print("Heterogeneous Linear model",quote = FALSE)
  print(summary(res$heterogeneous.lm))
  print(summary(aov(res$heterogeneous.lm)))
  print(summary(res$heterogeneous0.lm))
  print(summary(aov(res$heterogeneous0.lm)))
  
  #tbl3 <- anova(lm3)
  #tbl4 <- anova(lm4)
  
  #don' need this if we are computing from the reduced model, since
  #the residuals are correct.
  #hetSS <- tbl3[3,2]
  #hetDF <- tbl3[3,1]
  #intSS <- tbl4[3,2]
  #intDF <- tbl4[3,1]
  #hetResSS <- intSS - hetSS
  #hetResDF <- intDF - hetDF
  #hetMS <- hetSS/hetDF
  #hetResMS <- hetResSS/hetResDF
  #hetF <- hetMS/hetResMS
  #hetPf <- 1-pf(hetMS/hetResMS,hetDF,hetResDF)
  
  #ret <- rbind(tbl3,c(0,0,0,0,0))
  #ret[5,] <- tbl3[4,]
  #ret[3,] <- tbl4[3,]
  #ret[4,] <- tbl3[3,]
  #rownames(ret) <- c(rownames(tbl4)[1:2],paste(rownames(tbl4)[1],rownames(tbl4)[2],sep=":"),rownames(tbl3)[3],rownames(tbl3)[4])
  #return(list(lm=lm3,lm0=lm0,aov=ret))
}
