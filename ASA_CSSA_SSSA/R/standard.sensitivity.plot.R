standard.sensitivity.plot <- function(plot.dat,
                          response = "Plot.Mean",
                          TreatmentName = "Treatment",
                          TrialName = "Trial",
                          RepName = NULL,
                          dual.dendrogram=FALSE,
                          mark.branches=FALSE,
                          plot.outliers=FALSE,
                          outliers=3,
                          legend.columns=4,
                          method="complete",
                          fixed.prop=FALSE,
                          fixed.trials=FALSE) {
 
  require(lme4)
  
  estimates <- gei.table.and.effects(plot.dat,response=response,
                                     TreatmentName=TreatmentName,
                                     TrialName=TrialName,
                                     RepName=RepName,GinRows=FALSE)
  blocked <- !is.null(RepName)
  
  frm <- paste(response, "~",TrialName,"*",TreatmentName)
  if(blocked) {
    frm <- paste(frm,"+",TrialName,":",RepName)
  }
  base.lm <- lm(frm,data=plot.dat)
  base.aov <- anova(base.lm)
  
  rms <- base.aov[4,3]
  if(blocked) {
    rms <- base.aov[5,3]
  }
  
  m.matrix <- data.frame(estimates$means.table)
  m.vector <- rowMeans(m.matrix) #estimates$trial.means
  
  random.outliers <- interaction.outliers(m.matrix, m.vector,fixed=FALSE,sigma=outliers,rms=rms)
  #fixed.outliers <- interaction.outliers(m.matrix, m.vector,fixed=TRUE,sigma=outliers)
  
  par(fig = c(0, 1, 0.4, 1), mar = (c(1, 4, 1, 1) + 0.1))
  m.table <- NA
  if(plot.outliers) {
    m.table <- plot.interaction.ARMST(m.matrix, m.vector, ylab='Treatment in Trial Mean',
                                      regression=TRUE, main=response, show.legend=TRUE,legend.pos=c(.01,.98),
                                      legend.columns=legend.columns,lwd = 2,fixed.prop=fixed.prop,mark.int=random.outliers$pairs
    )
  } else {
    m.table <- plot.interaction.ARMST(m.matrix, m.vector, ylab='Treatment in Trial Mean',
                                      regression=TRUE, main=response, show.legend=TRUE,legend.pos=c(.01,.98),
                                      legend.columns=legend.columns,lwd = 2,fixed.prop=fixed.prop
    )
  }
  
  par(fig=c(0,1,0,.4),mar=(c(5, 4, 0, 1) + 0.1), new=TRUE)
  
  fg="black"
  decomp <- decompose.means.table(m.matrix)
  P6 <- decomp$mu + decomp$alpha + decomp$beta
  m.hc.int <- NA
  
  m.hc.add <- NA
  if(dual.dendrogram) {
    #fg="yellow"
    fg="gray"
    m.hc.add <- plot.clusters.ARMST(P6, m.vector, xlab='Trial Mean',fg=fg,fixed.prop=fixed.prop, ylab='',method=method)
  }
  fg="black"
  reference=NULL
  if(dual.dendrogram) {
    if(mark.branches) {
      reference=P6
    }
    #fg="gray"
    m.hc.int <- plot.clusters.ARMST(m.matrix, m.vector, xlab='Trial Mean', ylab='',fixed.prop=fixed.prop,
                        plot.names=names(m.vector),fg=fg,add=TRUE,method=method,reference=reference)
    #m.hc.int <- plot.clusters.ARMST(m.matrix, m.vector, xlab='Trial Mean', ylab='',fixed.prop=fixed.prop,
    #                                plot.names=names(m.vector),fg=fg,method=method,reference=P6)
  } else {
    m.hc.int <- plot.clusters.ARMST(m.matrix, m.vector, xlab='Trial Mean', ylab='',fixed.prop=fixed.prop,
                        plot.names=names(m.vector),fg=fg,method=method)
  }
  #if(dual.dendrogram) {
  #  fg="yellow"
  #  m.hc.add <- plot.clusters.ARMST(P6, m.vector,xlab='',fg=fg, fixed.prop=fixed.prop,add=TRUE, ylab='',method=method)
  #}
  

  par(fig = c(0, 1, 0, 1))
  
  m.lmer <- NULL
  if(fixed.trials) {
    frm <- paste(response, "~",TrialName,"*",TreatmentName)
    if(blocked) {
      frm <- paste(frm," + (1 | ",TrialName,":",RepName,")")
    }
    m.lmer <- lmer(frm,data=plot.dat)
  } else {
    frm <- paste(response, "~",TrialName)
    if(blocked) {
      frm <- paste(frm," + (1 | ",TrialName,"/",RepName,") + (1 | ",TrialName,":",TreatmentName,")")
    } else {
      frm <- paste(frm," + (1 | ",TrialName,")")
    }
    m.lmer <- lmer(frm,data=plot.dat)
  }
  
  return(list(data=m.table$data,
              fit=m.table$fit,
              table=m.matrix,
              vector=m.vector,
              cluster=m.hc.int,
              add.cluster=m.hc.add,
              lm=base.lm,
              aov=base.aov,
              lmer=m.lmer,
              varcor=VarCorr(m.lmer),
              #varcor=confint(lmer(Value ~ Treatment + (1 | Trial/Replicate) + (1 | Trial:Treatment),data=plot.dat)),
              tdf=nonadditivity.gei(data=plot.dat,response=response,
                                  TreatmentName=TreatmentName,
                                  TrialName=TrialName,
                                  BlockName=RepName),
              het=heterogeneity.gei(d=plot.dat,response=response,
                                    TreatmentName=TreatmentName,
                                    TrialName=TrialName,
                                    BlockName=RepName),
              #ammi=ammi.1df.ARMST(data=m.table$data,AName="TrtNo",BName="Trial.ID",response="values"),
              random.outliers=random.outliers
              #fixed.outliers=fixed.outliers
  ))
}

standard.plot.reduced <- function(plot.dat,fixed.prop=FALSE,fixed.trials=FALSE,dual.dendrogram=FALSE,plot.outliers=FALSE,legend.columns=4) {
  estimates <- gei.table.and.effects(plot.dat,response=response,
                                     TreatmentName=TreatmentName,
                                     TrialName=TrialName,
                                     RepName=RepName,GinRows=TRUE)
  
  response="values"
  AName="TrtNo"
  BName="Trial.ID"
  
  modelString <- paste(response," ~ as.factor(",AName,") * ",BName)
  ab.lm <- lm(as.formula(modelString),data=m.table$data)
  ab.aov <- anova(ab.lm)
  
  m.matrix <- estimates$means.table
  m.vector <- estimates$trial.means
  
  random.outliers <- interaction.outliers(m.matrix, m.vector,fixed=FALSE)
  #fixed.outliers <- interaction.outliers(m.matrix, m.vector,fixed=TRUE)
  
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
  
  return(list(data=m.table$data,
              fit=m.table$fit,
              table=m.matrix,
              vector=m.vector,
              cluster=m.hc,
              lm=av.lm,
              aov=ab.aov,
              tdf=tukey.1df.ARMST(data=m.table$data,AName=AName,BName=BName,response=response),
              het=heterogeneity.gei(d=m.table$data,TreatmentName=AName,TrialName=BName,response=response),
              ammi=ammi.1df.ARMST(data=m.table$data,AName=AName,BName=BName,response=response),
              random.outliers=random.outliers
             # fixed.outliers=fixed.outliers
  ))
}

print.stdplot <- function(fit) {
  print("AOV",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$aov)
  print("Mixed Model",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(summary(fit$lmer))
  #print("Variances",quote = FALSE)
  #print("----------------------------------------------------",quote = FALSE)
  #print(fit$varcor)
  print("",quote = FALSE)
  print("Stability",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(fit$fit)
  print("",quote = FALSE)
  print("Tukey's 1 d.f.",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print(summary(fit$tdf$multiplicative.lm))
  print(summary(aov(fit$tdf$multiplicative.lm)))
  print("",quote = FALSE)
  print("Heterogenous Slopes",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  #print(summary(fit$het$lm))
  print(summary(fit$het$heterogeneous.lm))
  print(summary(fit$het$heterogeneous0.lm))
  print(summary(aov(fit$het$heterogeneous0.lm)))
  print(summary(aov(fit$het$heterogeneous.lm)))
  print("",quote = FALSE)
  #print("AMMI AOV",quote = FALSE)
  #print("----------------------------------------------------",quote = FALSE)
  #print(fit$ammi$pc1)
  #print(fit$ammi$pc2)
  #print("",quote = FALSE)
  #print("SVD U",quote = FALSE)
  #print("----------------------------------------------------",quote = FALSE)
  #print(fit$ammi$u1)
  #print("",quote = FALSE)
  #print("SVD V",quote = FALSE)
  #print("----------------------------------------------------",quote = FALSE)
  #print(fit$ammi$v1)
  #print("SVD d",quote = FALSE)
  #print("----------------------------------------------------",quote = FALSE)
  #print(fit$ammi$d1)
  #print(fit$ammi$d2)
  #print("",quote = FALSE)
  print("Random Outliers",quote = FALSE)
  print("----------------------------------------------------",quote = FALSE)
  print("Critical Value:",quote = FALSE)
  print(fit$random.outliers$crit)
  print("Interaction sd Value:",quote = FALSE)
  print(fit$random.outliers$int.sd)
  print("Error sd Value:",quote = FALSE)
  print(fit$random.outliers$err.sd)
  print("Pairs:",quote = FALSE)
  print(fit$random.outliers$pairs)
  print("",quote = FALSE)
  #print("Fixed Outliers",quote = FALSE)
  #print("----------------------------------------------------",quote = FALSE)
  #print(fit$fixed.outliers$pairs)
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