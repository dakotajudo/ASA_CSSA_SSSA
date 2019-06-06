#assume plan has row, col, plotno and columns required for analysis.fn 
#if given, plots has row, col, plotno, number and columns required for analysis fn
#row, col, plotno, number are numeric, not factors
simulate.plan <- function(plan,
                          field=NULL,
                          plots=NULL,
                          effects.fn=NULL,
                          analysis.fn=rcb.analysis,
                          map.function=rcb.map,
                          plot.dim=c(1,1),
                          buffer.dim=c(0,0),
                          sample.vgm=NULL,
                          spacing=3,
                          model="rcb",
                          verbose=FALSE,
                          mean=TRUE) {
  
  res.dat = NULL
  
  original.plan = FALSE
  if(is.null(plots)) {
    plots <- overlay.field(plan=plan, field=field,plot.dim=plot.dim,
                          buffer.dim=buffer.dim,sample.vgm=sample.vgm,spacing=spacing,
                          mean=mean)
    original.plan = TRUE
    
  }
  for(number in 1:max(plots$number)) {
    currentPlots <- plots[plots$number==number,]
    if(!original.plan) {
      #map function copies treatment list to current data
      if(verbose) {print("mapping plots")}
      currentPlots <- map.function(plan,currentPlots)
      plots[plots$number==number,] <- currentPlots
    }
    current.res <- analysis.fn(currentPlots)
    if(!is.null(current.res)) {
      current.res$Number <- number
      current.res$Row <- currentPlots$Row[1]
      current.res$Col <- currentPlots$Col[1]
      current.res$Model <- model
    
      if(is.null(res.dat)) {
        res.dat <- current.res
      } else {
        res.dat <- rbind(res.dat,current.res)
      }
    }
  }
  
  #copy over model
  plots$Model <- model
  
  return(list(aov=res.dat,
              plots=plots))
}

rcb.analysis <- function(current.dat,REML=TRUE) {
  require(nlme)
  #is there valid data?
  current.dat <- subset(current.dat,!is.na(current.dat$YldVolDry))
  if(dim(current.dat)[1]<4) {
    return(NULL)
  }
  aov.tbl <- summary(aov(YldVolDry ~ as.factor(trt)+as.factor(rep),data=current.dat))
  RepVar <- NA
  ResVar <- NA
  if(REML) {
    aov.mle <- lme(YldVolDry ~ as.factor(trt), random = ~ 1| as.factor(rep), data=current.dat)
    var.tbl <- VarCorr(aov.mle)
    RepVar = as.numeric(var.tbl[1])
    ResVar = as.numeric(var.tbl[2])
  }

  #posthoc power
  means <- tapply(current.dat$YldVolDry,list(current.dat$trt),mean)
  GrandMean=mean(current.dat$YldVolDry)
  ResMS = aov.tbl[[1]][3,3]
  SD <- sqrt(ResMS)
  CV=100*SD/GrandMean
  PerMeanDiff=100*(max(means)-min(means))/GrandMean
  
  RepDF <- aov.tbl[[1]][2,1]
  TrtDF = aov.tbl[[1]][1,1]
  ResDF = aov.tbl[[1]][3,1]
  
  effect.size <-PerMeanDiff/CV

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

rcb.map <- function(plan,plots) {
  #do we assume plotno is number?
  row.names(plan) <- as.character(plan$plotno)
  row.names(plots) <- as.character(plots$plotno)
  #print(plan[row.names(plots),'trt'])
  plots[row.names(plots),'trt'] <-plan[row.names(plots),'trt']
  #for(p in min(plan$plotno):max(plan$plotno)) {
  #  mask <- plots$plotno==p
  #  if()
  #  plots$trt[mask] <- plan$trt[mask]
  #}
  return(plots)
}

overlay.field <- function(plan, field,
                          plot.dim=c(1,1),
                          buffer.dim=c(0,0),
                          sample.vgm=NULL,
                          spacing=3,model="rcb",mean=TRUE) {
  require(gstat)
  
  trial.dim <- trial.dimensions(plan=plan, plot.dim=plot.dim,buffer.dim=buffer.dim)
  
  trial.width <- trial.dim[1]
  trial.height <- trial.dim[2]
  
  if(!mean) {
    if(is.null(sample.vgm)) {
      sample.var <- variogram(YldVolDry~1, 
                              locations=~LonM+LatM, 
                              data=field)
      sample.vgm <- fit.variogram(sample.var, vgm("Exp"))
    }
  }
  rightBorder <- max(field$LonM) - (trial.width+2*spacing)
  topBorder <- max(field$LatM) - (trial.height+2*spacing)
  
  row=1
  col=1
  atColEnd=FALSE
  atRowEnd=FALSE
  plots <- NULL
  planNo <- 1
  while(!atColEnd) {
    currentRow <- 3+(row-1)*trial.height + (row-1)*2*spacing
    if(currentRow < topBorder) {
      while(!atRowEnd) {
        currentCol <- 3+(col-1)*trial.width + (col-1)*2*spacing
        if(currentCol<rightBorder) {
          corner <- c(currentCol,currentRow)
          #overlay and analyze
          currentPlan <- superimpose.plan(plan,
                                          map.data=field,
                                          start.point=corner,
                                          plot.dim=plot.dim,
                                          buffer.dim=buffer.dim,
                                          sample.vgm=sample.vgm,
                                          mean=mean
                                      
          )
          
          #save points
          current.plots <- NA
          #if(mean) {
          #  current.plots <- currentPlan$mean
          #} else {
            current.plots <- currentPlan$plan
          #}
          current.plots$number <- planNo
          current.plots$Row <- currentRow
          current.plots$Col <- currentCol
          current.plots$Model <- model
        
          planNo <- planNo+1
          plots <- rbind(plots,current.plots)
          
          col=col+1  
        } else {
          atRowEnd=TRUE
        }
      }
      col=1
      row=row+1
      atRowEnd=FALSE
    } else {
      atColEnd =TRUE
    }
  }
  return(plots)
}

simulate.plans <- function(plan.list, trial.data, plots.list=NULL, 
                           sample.vgm=NULL,plot.dim=c(1,1), buffer.dim=c(0,0),
                           model="rcb",spacing=3,analysis.fn=rcb.analysis,mean=TRUE) {
  
  tmp.plots <- NULL
  aov <- NULL
  plan.names <- names(plan.list)

  if(is.null(plots.list)) {
    plots <- overlay.field(plan=plan.list[[1]], field=trial.data, plot.dim=plot.dim,
                             buffer.dim=buffer.dim,sample.vgm=sample.vgm,spacing=spacing,mean=mean)
    plots.list <- list(plots=plots)
  }
  
  if(!is.list(plots.list)) {
    
  }

  plot.names <- names(plots.list)
  #print(plot.names)
  for(plot.idx in 1:length(plots.list)) {
    for (idx in 1:length(plan.list)) {
      current.plan <- plan.list[[idx]]
      tmp <- simulate.plan(current.plan,field=NULL,plots=plots.list[[plot.idx]],model=model,analysis.fn=analysis.fn)
      
      if(!is.null(plan.names)) {
        tmp$plots$plan <- plan.names[idx]
        tmp$aov$plan <- plan.names[idx]
        #print(plan.names[idx])
      } else {
        tmp$plots$plan <- idx
        tmp$aov$plan <- idx
      }
      
      tmp$aov$PlanNumber <- idx
      tmp$plots$PlanNumber <- idx
      
      if(!is.null(plot.names)) {
        tmp$plots$Source <- plot.names[plot.idx]
        tmp$aov$Source <- plot.names[plot.idx]
      } else {
        tmp$plots$Source <- plot.idx
        tmp$aov$Source <- plot.idx
      }
      
      tmp$aov$SourceNumber <- plot.idx
      tmp$plots$SourceNumber <- plot.idx
  
      if(is.null(tmp.plots)) {
        tmp.plots <- tmp$plots
        aov <- tmp$aov
      } else {
        tmp.plots <- rbind(tmp.plots,tmp$plots)
        aov <- rbind(aov,tmp$aov)
      }
    }
  }
  
  
  require(ggplot2)
  #aov$plan <- as.factor(aov$plan)
  rcbmap.dat <- subset(tmp.plots, tmp.plots$number==1)
  rcbmap.dat$Source <- as.factor(rcbmap.dat$Source)
  rcbmap.dat <- subset(rcbmap.dat,rcbmap.dat$Source==levels(rcbmap.dat$Source)[1])
  
  rcbmap.dat$plan <- as.factor(rcbmap.dat$plan)
  rcbmap.dat$PlanNumber <- as.factor(rcbmap.dat$PlanNumber)
  map.plot <- ggplot(rcbmap.dat, aes(LonM, LatM)) + geom_point(aes(colour = trt),size=3) + facet_wrap(~PlanNumber)
  aov$PlanNumber <- as.factor(aov$PlanNumber)
  
  plan.plot <- ggplot(aov, aes(TrtP,color=PlanNumber,linetype=PlanNumber)) + 
                      stat_density(geom="line",position="identity",size=1) + 
                      facet_wrap(~Source)
  
  ret <- list(plots=tmp.plots,
              aov=aov,
              trt.p.plot=plan.plot,
              map.plot=map.plot)
  class(ret) <- "plan.simulations"
  return(ret)
}

summary.plan.simulations <- function(res,alpha=0.05) {
  TypeIError <- res$aov$TrtP <= alpha
  ErrorCounts <- tapply(TypeIError, list(res$aov$Source,res$aov$plan), sum)
  TrialCounts <- tapply(TypeIError, list(res$aov$Source,res$aov$plan), length)
  tbl <- data.frame(100*ErrorCounts/TrialCounts)

  row.means <- apply(tbl,1,mean)
  row.sd <- apply(tbl,1,sd)
  
  col.means <- apply(tbl,2,mean)
  col.sd <- apply(tbl,2,sd)
  
  if(dim(tbl)[2]>1) {
    tbl$Mean <- row.means
    tbl$SD <- row.sd
  }
  return(list(
    TypeIError=tbl
  ))
}
