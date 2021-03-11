simulate.plans <- function(plan.list, trial.data, plots.list=NULL, 
                           sample.vgm=NULL,plot.dim=c(1,1), buffer.dim=c(0,0),
                           model="rcb",spacing=3,analysis.fn=rcb.analysis,mean=FALSE) {
  
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
  map.plot <- ggplot(rcbmap.dat, aes(Longitude, Latitude)) + geom_point(aes(colour = trt),size=3) + facet_wrap(~PlanNumber)
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
