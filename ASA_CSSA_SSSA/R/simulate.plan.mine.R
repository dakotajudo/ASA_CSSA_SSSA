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
