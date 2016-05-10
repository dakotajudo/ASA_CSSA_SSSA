pair.distances <- function(plan,plot.dim=c(1,1),buffer.dim=c(0,0),reference=c(),multiple=TRUE) {
  trts <- max(plan$trt)
  #define vectors of possible contrasts.
  trt1 <- c()
  trt2 <- c()
  row1 <- c()
  row2 <- c()
  col1 <- c()
  col2 <- c()
  
  pair <- c()
  dist <- c()
  cont <- c()
  ref <- c()
  #for each treatment
  
  all.treatments <- 1:trts
  reference.treatments <- 1:trts
  if((length(reference) > 0)) {
    reference.treatments <- reference
  }
  current.contrasts <- c()
  
  for (t1 in all.treatments) {
    this.trt <- plan[plan$trt==t1,]
    if(dim(this.trt)[1]>0) {
    #for every other treatment
    for (t2 in reference.treatments) {
      if(t1 != t2) {
      current.contrast <- paste(t1,"-",t2)
      if(t2<t1) {
        current.contrast <- paste(t2,"-",t1)
      }
      if(!(current.contrast %in% current.contrasts)) {
        #print(current.contrast)
        #print(current.contrasts)
        current.contrasts <- c(current.contrasts,current.contrast)
        other.trt <- plan[plan$trt==t2,]
        #compare every plot in the current treatment list with
        #plots for the other treatment
        for (idx1 in 1:(dim(this.trt)[1])) {
          r1 <- this.trt$row[idx1]
          c1 <- this.trt$col[idx1]
          p1 <- c(r1,c1)
          for (idx2 in 1:(dim(other.trt)[1])) {
            r2 <- other.trt$row[idx2]
            c2 <- other.trt$col[idx2]
            
            if(multiple || r1==r2) {
            p2 <- c(r2,c2)
            d <- plot.distance(p1,p2,plot.dim,buffer.dim)
            
            dist <- c(dist,d)
            if(t2<t1) {
              trt1 <- c(trt1,t2)
              trt2 <- c(trt2,t1)
            } else {
              trt1 <- c(trt1,t1)
              trt2 <- c(trt2,t2)
            }
            

            row1 <- c(row1,r1)
            row2 <- c(row2,r2)
            
            col1 <- c(col1,c1)
            col2 <- c(col2,c2)
            
            cont <- c(cont,current.contrast)
            pair <- c(pair,1)
            ref <- c(ref,paste("r",p1[1],"c",p1[2],sep=""))
            }
          }
        }
      }
      }
    }
    }
  }
  #print(length(trt1))
  #print(length(trt2))
  #print(length(pair))
  #print(length(dist))
  #print(length(cont))
  #print(length(ref))
  #print(length(row1))
  #print(length(row2))
  #print(length(col1))
  #print(length(col2))
  return(data.frame(trt1=trt1,trt2=trt2,
                    pair=pair,distance=dist,
                    contrast=cont,reference=ref,
                    row1=row1,
                    row2=row2,
                    col1=col1,
                    col2=col2
                    ))
}

make.pairs.table <- function(pairs.dat) {
  min.d  <- c()
  max.d <- c()
  mean.d <- c()
  sd.d <- c()
  count.d <- c()
  trt1 <- c()
  trt2 <- c()
  contrast <- c()
  for (cont in levels(pairs.dat$contrast)) {
    current.dat <- subset(pairs.dat,pairs.dat$contrast==cont)
    min.d  <- c(min.d,min(current.dat$d))
    max.d <- c(max.d,max(current.dat$d))
    mean.d <- c(mean.d,mean(current.dat$d))
    sd.d <- c(sd.d,sd(current.dat$d))
    count.d <- c(count.d,length(current.dat$d))
    trt1 <- c(trt1,current.dat$trt1[1])
    trt2 <- c(trt2,current.dat$trt2[1])
    contrast <- c(contrast,cont)
  }
  
  pairs.tbl <- data.frame(
    contrast=contrast,
    trt1=trt1,
    trt2=trt2,
    min.d=min.d,
    max.d=max.d,
    mean.d=mean.d,
    sd.d=sd.d,
    count.d=count.d
  )
  
  return(pairs.tbl)
}

make.pairs.matrices <- function(pairs.tbl) {
  trt1.max <- max(pairs.tbl$trt1)
  trt2.max <- max(pairs.tbl$trt2)
  
  #assuming all pairs comparison
  if(trt1.max == (trt2.max-1)) {
    trt1.max=trt2.max
  }
  ret.min <- matrix(rep(NA,trt1.max*trt2.max),nrow=trt2.max)
  ret.max <- matrix(rep(NA,trt1.max*trt2.max),nrow=trt2.max)
  ret.mean <- matrix(rep(NA,trt1.max*trt2.max),nrow=trt2.max)
  ret.sd <- matrix(rep(NA,trt1.max*trt2.max),nrow=trt2.max)
  ret.count <- matrix(rep(NA,trt1.max*trt2.max),nrow=trt2.max)
  for(idx in 1:length(pairs.tbl$trt1)) {
    t1 <- pairs.tbl$trt1[idx]
    t2 <- pairs.tbl$trt2[idx]
    ret.min[t2,t1] <- pairs.tbl$min.d[idx]
    ret.max[t2,t1] <- pairs.tbl$max.d[idx]
    ret.mean[t2,t1] <- pairs.tbl$mean.d[idx]
    ret.sd[t2,t1] <- pairs.tbl$sd.d[idx]
    ret.count[t2,t1] <- pairs.tbl$count.d[idx]
    if(t2<=dim(ret.min)[2]) {
      ret.min[t1,t2] <- pairs.tbl$min.d[idx]
      ret.max[t1,t2] <- pairs.tbl$max.d[idx]
      ret.mean[t1,t2] <- pairs.tbl$mean.d[idx]
      ret.sd[t1,t2] <- pairs.tbl$sd.d[idx]
      ret.count[t1,t2] <- pairs.tbl$count.d[idx]
    }
  }
  return(list(min=ret.min,
              max=ret.max,
              mean=ret.mean,
              sd=ret.sd,
              count=ret.count))
}