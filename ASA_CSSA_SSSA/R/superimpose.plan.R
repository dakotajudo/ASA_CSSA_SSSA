superimpose.plan <- function(plan,map.data,start.point,plot.dim=c(1,1),
                             buffer.dim=c(0,0),
                             sample.vgm=NULL,
                             mean=TRUE) {
  
  require(gstat)
  
  trial.dim <- trial.dimensions(plan,plot.dim,buffer.dim)
  
  trial.dat <- subset(map.data,map.data$LonM<(start.point[1]+trial.dim[1]+3))
  trial.dat <- subset(trial.dat,trial.dat$LatM<(start.point[2]+trial.dim[2]+3))
  
  trial.dat <- subset(trial.dat,trial.dat$LonM>=(start.point[1]-3))
  trial.dat <- subset(trial.dat,trial.dat$LatM>=(start.point[2]-3))
  
  plan$LonM <- 0
  plan$LatM <- 0
  
  half.width <- plot.dim[1]/2
  half.heigth <- plot.dim[2]/2
  
  for(idx in 1:dim(plan)[1]) {
    row <- plan$row[idx]
    col <- plan$col[idx]
    plan$LonM[idx] <- start.point[1] + half.width + (col-1)*plot.dim[1] + (col-1)*buffer.dim[1]
    plan$LatM[idx] <- start.point[2] + half.heigth + (row-1)*plot.dim[2] + (row-1)*buffer.dim[2]
  }
  
  plan$n <- plan$LatM+half.heigth
  plan$s <- plan$LatM-half.heigth
  plan$e <- plan$LonM-half.width
  plan$w <- plan$LonM+half.width
  
  sample.krig = NULL
  if(!mean) {
    if(is.null(sample.vgm)) {
      sample.var <- variogram(YldVolDry~1, 
                              locations=~LonM+LatM, 
                              data=map.data)
      sample.vgm <- fit.variogram(sample.var, vgm("Exp"))
    }
    sample.krig <- krige(id="YldVolDry", 
                         formula=YldVolDry~1, 
                         data = trial.dat, 
                         newdata = plan, 
                         model = sample.vgm,
                         locations=~LonM+LatM)
    plan$YldVolDry <- sample.krig$YldVolDry.pred
  } else {
    for(idx in 1:dim(plan)[1]) {
      points.dat <- subset(trial.dat, trial.dat$LatM <= plan$n[idx])
      points.dat <- subset(points.dat, points.dat$LatM >= plan$s[idx])
      points.dat <- subset(points.dat, points.dat$LonM >= plan$e[idx])
      points.dat <- subset(points.dat, points.dat$LonM <= plan$w[idx])
      plan$YldVolDry[idx] <- mean(points.dat$YldVolDry,na.rm=TRUE)
    }
  }

  return(list(
    trial.dim=trial.dim,
    plan=plan,
    trial=trial.dat,
    krig=sample.krig,
    #mean=mean,
    pooled = data.frame(
      LonM = c(trial.dat$LonM,plan$LonM),
      LatM = c(trial.dat$LatM,plan$LatM),
      YldVolDry = c(trial.dat$YldVolDry,plan$YldVolDry),
      Sample = as.factor(c(rep("Original",length(trial.dat$YldVolDry)),
                           rep("Estimated",length(plan$YldVolDry))))
    )
  ))
}