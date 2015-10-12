standard.plot <- function(plot.dat,fixed.prop=FALSE,fixed.trials=FALSE,dual.dendrogram=FALSE,plot.outliers=FALSE,legend.columns=4) {
  m.matrix <- data.frame(tapply(plot.dat$Value,list(plot.dat$Trial,plot.dat$Treatment),mean))
  m.vector <- tapply(plot.dat$Value,list(plot.dat$Trial),mean)
  
  random.outliers <- interaction.outliers(m.matrix, m.vector,fixed=FALSE)
  fixed.outliers <- interaction.outliers(m.matrix, m.vector,fixed=TRUE)
  
  par(fig = c(0, 1, 0.4, 1), mar = (c(1, 4, 1, 1) + 0.1))
  m.table <- NA
  if(plot.outliers) {
    m.table <- plot.interaction.ARMST(m.matrix, m.vector, ylab='Treatment in Trial Mean',
                                      regression=TRUE, main='Yield', show.legend=TRUE,legend.pos=c(.01,.98),
                                      legend.columns=legend.columns,lwd = 2,fixed.prop=fixed.prop,mark.int=random.outliers$pairs
    )
  } else {
    m.table <- plot.interaction.ARMST(m.matrix, m.vector, ylab='Treatment in Trial Mean',
                                      regression=TRUE, main='Yield', show.legend=TRUE,legend.pos=c(.01,.98),
                                      legend.columns=legend.columns,lwd = 2,fixed.prop=fixed.prop
    )
  }
  
  par(fig=c(0,1,0,.4),mar=(c(5, 4, 0, 1) + 0.1), new=TRUE)
  
  fg="black"
  if(dual.dendrogram) {
    fg="gray"
  }
  m.hc <- plot.clusters.ARMST(m.matrix, m.vector, xlab='Trial Mean', ylab='',fixed.prop=fixed.prop,
                              plot.names=names(m.vector),fg=fg)
  if(dual.dendrogram) {
    decomp <- decompose.means.table(m.matrix)
    P6 <- decomp$mu + decomp$alpha
    m.hc <- plot.clusters.ARMST(P6, m.vector, xlab='Trial Mean',add=TRUE, ylab='')
  }
  par(fig = c(0, 1, 0, 1))
  
  
  
  m.lmer <- NULL
  if(fixed.trials) {
    m.lmer <- lmer(Value ~ Treatment*Trial + (1 | Trial:Replicate),data=plot.dat)
  } else {
    m.lmer <- lmer(Value ~ Treatment + (1 | Trial/Replicate) + (1 | Trial:Treatment),data=plot.dat)
  }
  
  
  return(list(data=m.table$data,
              fit=m.table$fit,
              table=m.matrix,
              vector=m.vector,
              cluster=m.hc,
              aov= anova(lm(Value ~ Treatment*Trial + Trial:Replicate,data=plot.dat)),
              varcor=VarCorr(m.lmer),
              #varcor=confint(lmer(Value ~ Treatment + (1 | Trial/Replicate) + (1 | Trial:Treatment),data=plot.dat)),
              tdf=tukey.1df.ARMST(data=m.table$data,AName="TrtNo",BName="Trial.ID",response="values"),
              het=heterogeneity.gei(d=m.table$data,AName="TrtNo",BName="Trial.ID",response="values",BlockName="Replicate"),
              ammi=ammi.1df.ARMST(data=m.table$data,AName="TrtNo",BName="Trial.ID",response="values"),
              random.outliers=random.outliers,
              fixed.outliers=fixed.outliers
  ))
}

standard.plot.reduced <- function(plot.dat,fixed.prop=FALSE,fixed.trials=FALSE,dual.dendrogram=FALSE,plot.outliers=FALSE,legend.columns=4) {
  m.matrix <- data.frame(plot.dat)
  m.vector <- rowMeans(m.matrix)
  
  random.outliers <- interaction.outliers(m.matrix, m.vector,fixed=FALSE)
  fixed.outliers <- interaction.outliers(m.matrix, m.vector,fixed=TRUE)
  
  par(fig = c(0, 1, 0.4, 1), mar = (c(1, 4, 1, 1) + 0.1))
  m.table <- NA
  if(plot.outliers) {
    m.table <- plot.interaction.ARMST(m.matrix, m.vector, ylab='Treatment in Trial Mean',
                                      regression=TRUE, main='Yield', show.legend=TRUE,legend.pos=c(.01,.98),
                                      legend.columns=legend.columns,lwd = 2,fixed.prop=fixed.prop,mark.int=random.outliers$pairs
    )
  } else {
    m.table <- plot.interaction.ARMST(m.matrix, m.vector, ylab='Treatment in Trial Mean',
                                      regression=TRUE, main='Yield', show.legend=TRUE,legend.pos=c(.01,.98),
                                      legend.columns=legend.columns,lwd = 2,fixed.prop=fixed.prop
    )
  }
  
  par(fig=c(0,1,0,.4),mar=(c(5, 4, 0, 1) + 0.1), new=TRUE)
  
  fg="black"
  if(dual.dendrogram) {
    fg="gray"
  }
  m.hc <- plot.clusters.ARMST(m.matrix, m.vector, xlab='Trial Mean', ylab='',fixed.prop=fixed.prop,
                              plot.names=names(m.vector),fg=fg)
  if(dual.dendrogram) {
    decomp <- decompose.means.table(m.matrix)
    P6 <- decomp$mu + decomp$alpha
    m.hc <- plot.clusters.ARMST(P6, m.vector, xlab='Trial Mean',add=TRUE, ylab='')
  }
  par(fig = c(0, 1, 0, 1))
  
  response="values"
  AName="TrtNo"
  BName="Trial.ID"
  
  modelString <- paste(response," ~ as.factor(",AName,") * ",BName)
  ab.lm <- lm(as.formula(modelString),data=m.table$data)
  
  return(list(data=m.table$data,
              fit=m.table$fit,
              table=m.matrix,
              vector=m.vector,
              cluster=m.hc,
              aov= anova(ab.lm),
              tdf=tukey.1df.ARMST(data=m.table$data,AName=AName,BName=BName,response=response),
              het=heterogeneity.gei(d=m.table$data,TreatmentName=AName,TrialName=BName,response=response),
              ammi=ammi.1df.ARMST(data=m.table$data,AName=AName,BName=BName,response=response),
              random.outliers=random.outliers,
              fixed.outliers=fixed.outliers
  ))
}

print.stdplot <- function(fit) {
  print("AOV",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$aov)
  print("Variances",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$varcor)
  print("",quote = FALSE)
  print("Stability",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$fit)
  print("",quote = FALSE)
  print("Tukey's 1 d.f.",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(summary(fit$tdf$lm))
  print(summary(aov(fit$tdf$lm)))
  print("",quote = FALSE)
  print("Heterogenous Slopes",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  #print(summary(fit$het$lm))
  print(summary(fit$het$lm0))
  print(summary(aov(fit$het$lm0)))
  print(fit$het$aov)
  print("",quote = FALSE)
  print("AMMI AOV",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$pc1)
  print(fit$ammi$pc2)
  print("",quote = FALSE)
  print("SVD U",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$u1)
  print("",quote = FALSE)
  print("SVD V",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$v1)
  print("SVD d",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$d1)
  print(fit$ammi$d2)
  print("",quote = FALSE)
  print("Random Outliers",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$random.outliers$pairs)
  print("",quote = FALSE)
  print("Fixed Outliers",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$fixed.outliers$pairs)
  print("",quote = FALSE)
}

print.stdplot.reduced <- function(fit) {
  print("AOV",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$aov)
  print("",quote = FALSE)
  print("Tukey's 1 d.f.",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(summary(fit$tdf$lm))
  print(summary(aov(fit$tdf$lm)))
  print("",quote = FALSE)
  print("Heterogenous Slopes",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(summary(fit$het$lm0))
  print(summary(aov(fit$het$lm0)))
  print(fit$het$aov)
  print("Stability",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$fit)
  print("",quote = FALSE)
  print("AMMI AOV",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$pc1)
  print(fit$ammi$pc2)
  print("",quote = FALSE)
  print("SVD U",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$u1)
  print("",quote = FALSE)
  print("SVD V",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$v1)
  print("SVD d",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$ammi$d)
  print("Characteristic root test",quote = FALSE)
  print(fit$ammi$d*fit$ammi$d/sum(fit$ammi$d*fit$ammi$d))
  print("",quote = FALSE)
  print("Random Outliers",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$random.outliers$pairs)
  print("",quote = FALSE)
  print("Fixed Outliers",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$fixed.outliers$pairs)
  print("",quote = FALSE)
}