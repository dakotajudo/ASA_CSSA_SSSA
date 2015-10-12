# test = c("G","GH1,"GH2","R)
ammi.gei <- function(data=NULL,
                           response = "Plot.Mean",
                           AName = "Treatment",
                           BName = "Trial",test="G",
                           ErrorMS=0,
                           ErrorDF=0,
                           r=3) {
  #start with Tukey 1df
  tdf <- tukey.1df.ARMST(data=data, response = response, AName = AName, BName = BName)
  
  ldat <- tdf$lm$model
  #ldat$Trial.ID <- as.factor(ldat$Trial.ID)
  #ldat$TrtNo <- as.factor(ldat$TrtNo)
  
  decomp <- decompose.means.table(tdf$table)
  
  #TODO better imputation for missing means
  decomp$gamma[is.na(decomp$gamma)] <- 0
  
  #decompose interaction effects
  P5 <- decomp$gamma
  svd.P5 <- svd(P5)
  
  #calculate first two PC scores
  #diagonalize the singular values
  lambda <- diag(svd.P5$d)
  
  #use the square root, since our model is lambda*alpha*beta;
  #our scores will be sqrt(lambda)*alpha and sqrt(lambda)*beta 
  root.lambda <- sqrt(diag(svd.P5$d))
  score.a <- svd.P5$u %*% root.lambda
  score.b <- svd.P5$v %*% root.lambda
  
  PC1a <- score.a[,1]
  PC2a <- score.a[,2]
  PC1b <- score.b[,1]
  PC2b <- score.b[,2]
  
  #copy scores to means data table
  ldat$PC1a <- PC1a[get(AName,ldat)]
  ldat$PC1b <- PC1b[get(BName,ldat)]
  ldat$PC2a <- PC2a[get(AName,ldat)]
  ldat$PC2b <- PC2b[get(BName,ldat)]
  
  #and to full data table
  data$PC1a <- PC1a[get(AName,data)]
  data$PC1b <- PC1b[get(BName,data)]
  data$PC2a <- PC2a[get(AName,data)]
  data$PC2b <- PC2b[get(BName,data)]
  
  modelString1 <- paste(response," ~ ",AName," + ",BName,"+ PC1a:PC1b")
  modelString2 <- paste(response," ~ ",AName," + ",BName,"+ PC1a:PC1b + PC2a:PC2b")
  
  #compute basic aov tables.
  tbl1 <- anova(lm(modelString1,data=ldat))
  tbl2 <- anova(lm(modelString2,data=ldat))
  
  #adjust degrees of freedom for PC
  PC1.df <- tbl1[1,1] + tbl1[2,1] -1
  PC1.SS <- tbl1[3,2]
  
  PC2.df <- PC1.df - 2
  PC2.SS <- tbl2[4,2]
  Res2.df <- tbl2[5,1] - (tbl2[4,1]+tbl2[3,1])
  Res2.SS <- tbl2[5,2]
  
  Res1.df <- tbl1[4,1] - tbl1[3,1]
  Res1.SS <- tbl1[4,2]
  
  PC1.MS <- PC1.SS/PC1.df
  PC2.MS <- Res2.SS/PC2.df
  Res2.MS <- Res2.SS/Res2.df
  Res1.MS <- Res1.SS/Res1.df
  
  #recompute MS, F ratio and p value
  #remember to recompute residual
  
  PC1.F <- PC1.MS/Res1.MS
  PC2.F <- PC2.MS/Res2.MS
  
  PC1.pf<- 1-pf(PC1.F,PC1.df,Res1.df)
  PC2.pf <- 1-pf(PC2.F,PC2.df,Res2.df)
  
  
  if(test=="R") {
    #see s.dias.c-2003 for a start
    n <- reps
    ems <- ErrorMS
    g <- dim(tdf$table)[1]
    e <- dim(tdf$table)[2]
    SS.GEI <- n*sum(svd.P5$d*svd.P5$d)
    SS.R1 <- SS.GEI - n*svd.P5$d[1]*svd.P5$d[1]
    m <- 1
    
    MS.R1 <- (SS.R1)/((g-1-m)*(e-1-m))
    F1 <- MS.R1/ErrorMS
    
    #m <- 2
    #SS.R2 <- SS.GEI - n*(ammi.svd$d[1]*ammi.svd$d[1]+ammi.svd$d[2]*ammi.svd$d[2])
    #MS.R2 <- SS.R2/((g-1-m)*(e-1-m))
    
  }
  
  tbl1[3,2] <- PC1.SS
  tbl2[4,2] <- PC2.SS 
  
  tbl1[3,1] <- PC1.df
  tbl1[4,1] <- Res1.df
  
  tbl2[3,1] <- PC1.df
  tbl2[4,1] <- PC2.df
  tbl2[5,1] <- Res2.df
  
  tbl1[4,2] <- Res1.SS
  
  tbl1[3,3] <- PC1.MS
  tbl1[4,3] <- Res1.MS
  
  tbl2[3,3] <- PC1.MS
  tbl2[4,3] <- PC2.MS
  tbl2[5,3] <- Res2.MS
  
  tbl1[3,4] <-  PC1.F
  tbl2[3,4] <-  PC1.MS/Res2.MS
  tbl2[4,4] <-  PC2.F
  tbl1[3,5] <-  PC1.pf
  
  tbl2[3,5] <-  1-pf(tbl2[3,4],tbl2[3,1],tbl2[5,1])
  tbl2[4,5] <-  PC2.pf
  
  return(list(tdf=tdf,
              pc1=tbl1,
              pc2=tbl2,
              PC1a = PC1a,
              PC2a = PC2a,
              PC1b = PC1b,
              PC2b = PC2b,
              l1=svd.P5$d[1],
              l2=svd.P5$d[2],
              u1=svd.P5$u[,1],
              u2=svd.P5$u[,2],
              v1=svd.P5$v[,1],
              v2=svd.P5$v[,2],
              u=svd.P5$u,
              v=svd.P5$v,
              d=svd.P5$d,
              data=data
  ))
}