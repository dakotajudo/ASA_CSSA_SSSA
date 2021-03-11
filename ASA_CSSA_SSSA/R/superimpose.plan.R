superimpose.plan <- function(plan,map.data,start.point,plot.dim=c(1,1),
                             buffer.dim=c(0,0),
                             sample.vgm=NULL,
                             mean=FALSE) {
  
  #require(gstat)
  require(splines)
  trial.dim <- trial.dimensions(plan,plot.dim,buffer.dim)
  #trial.dat <- map.data
 trial.dat <- subset(map.data,map.data$Longitude<(start.point[1]+trial.dim[1]+3))
  trial.dat <- subset(trial.dat,trial.dat$Latitude<(start.point[2]+trial.dim[2]+3))
  
  trial.dat <- subset(trial.dat,trial.dat$Longitude>=(start.point[1]-3))
  trial.dat <- subset(trial.dat,trial.dat$Latitude>=(start.point[2]-3))
  
  plan$Longitude <- 0
  plan$Latitude <- 0
  
  half.width <- plot.dim[1]/2
  half.heigth <- plot.dim[2]/2
  
  for(idx in 1:dim(plan)[1]) {
    row <- plan$row[idx]
    col <- plan$col[idx]
    plan$Longitude[idx] <- start.point[1] + half.width + (col-1)*plot.dim[1] + (col-1)*buffer.dim[1]
    plan$Latitude[idx] <- start.point[2] + half.heigth + (row-1)*plot.dim[2] + (row-1)*buffer.dim[2]
  }
  
  plan$n <- plan$Latitude+half.heigth
  plan$s <- plan$Latitude-half.heigth
  plan$e <- plan$Longitude-half.width
  plan$w <- plan$Longitude+half.width
  
  sample.krig = NULL
  if(!mean) {
   
    require(mgcv)
    sample.gam <- gam(Yield ~ s(Longitude,Latitude,k=10),data=trial.dat)
    #print(predict(sample.gam,newdata=plan))
    plan$Yield <- predict(sample.gam,newdata=plan)
    #sample.lm <- lm(Yield ~ bs(Longitude,df=3)*bs(Latitude,df=3),data=trial.dat)
    #plan$Yield <- predict(sample.lm,newdata=plan)
    #require(glm)
    #sample.glm <- glm(Yield ~ s(Longitude,Latitude,k=10),data=trial.dat)
    #plan$Yield <- predict(sample.glm,newdata=plan)
    
   # if(is.null(sample.vgm)) {
  #    sample.var <- variogram(Yield~1, 
  #                            locations=~Longitude+Latitude, 
  #                            data=map.data)
  #    sample.vgm <- fit.variogram(sample.var, vgm("Exp"))
  #  }
  #  sample.krig <- krige(id="Yield", 
  #                       formula=Yield~1, 
  #                       data = trial.dat, 
  #                       newdata = plan, 
  #                       model = sample.vgm,
  #                       locations=~Longitude+Latitude)
  #  plan$Yield <- sample.krig$Yield.pred
  } else {
    for(idx in 1:dim(plan)[1]) {
      points.dat <- subset(trial.dat, trial.dat$Latitude <= plan$n[idx])
      points.dat <- subset(points.dat, points.dat$Latitude >= plan$s[idx])
      points.dat <- subset(points.dat, points.dat$Longitude >= plan$e[idx])
      points.dat <- subset(points.dat, points.dat$Longitude <= plan$w[idx])
      plan$Yield[idx] <- mean(points.dat$Yield,na.rm=TRUE)
    }
  }

  return(list(
    trial.dim=trial.dim,
    plan=plan,
    trial=trial.dat,
    krig=sample.krig,
    #mean=mean,
    pooled = data.frame(
      Longitude = c(trial.dat$Longitude,plan$Longitude),
      Latitude = c(trial.dat$Latitude,plan$Latitude),
      Yield = c(trial.dat$Yield,plan$Yield),
      Sample = as.factor(c(rep("Original",length(trial.dat$Yield)),
                           rep("Estimated",length(plan$Yield))))
    )
  ))
}