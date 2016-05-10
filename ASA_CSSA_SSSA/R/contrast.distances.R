contrast.distances <- function(plan,multiple=FALSE,plot.dim=c(1,1),buffer.dim=c(0,0),reference=c()) {
  trts <- max(plan$trt)
  #define vectors of possible contrasts.
  trt1 <- c()
  trt2 <- c()
  if(length(reference)>0) {
    for(i in 1:trts) {
      trt1 <- c(trt1,rep(i,length(reference)))
      trt2 <- c(trt2,reference)
    }
  } else {
    for(i in 1:(trts-1)) {
      trt1 <- c(trt1,rep(i,trts-i))
      trt2 <- c(trt2,(i+1):trts)
    }
  }
  
  cont <- data.frame(
    trt1=trt1,
    trt2=trt2,
    distance=rep(0,length(trt1)),
    dist.sd=rep(0,length(trt1))
  )
  
  #for each treatment
  for (trt1 in 1:(trts-1)) {
    this.trt <- plan[plan$trt==trt1,]
    #for every other treatment
    for (trt2 in (trt1+1):trts) {
      other.trt <- plan[plan$trt==trt2,]
      #compare every plot in the current treatment list with
      #plots for the other treatment
      dists <- c()
      for (idx1 in 1:(dim(this.trt)[1])) {
        if(is.na(this.trt$row[idx1])) {
          print(idx1)
        }
        p1 <- c(this.trt$row[idx1],this.trt$col[idx1])
        for (idx2 in 1:(dim(other.trt)[1])) {
          p2 <- c(other.trt$row[idx2],other.trt$col[idx2])
          if(multiple || p1[1]==p2[1]) {
            dist <- plot.distance(p1,p2,plot.dim,buffer.dim)
            dists <- c(dists,dist)
          }
        }
      }
      #print(paste("Trt",trt1,"vs Trt",trt2))
      #print(dists)
      #dists now has the distances for all treatment pairs in this specific pair contrast.
      mask <- cont$trt1==trt1 & cont$trt2==trt2
      if(trt2<trt1) {
        mask <- cont$trt2==trt1 & cont$trt1==trt2 
      }
      if(!is.null(dists)) {
        cont$distance[mask] <- mean(dists,na.rm=TRUE)
        cont$dist.sd[mask] <- sd(dists,na.rm=TRUE)     
      }
    }
  }
  return(cont)
}