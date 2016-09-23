sample.adtc <- function(trts=7,reps=5,max.plans=100,multiple=FALSE,plot.dim=c(1,1),buffer.dim=c(0,0)) {
  col <- c(rep(1:trts,reps))
  row <- c()
  cnt <- 0
  for (i in 1:reps) {
    row <- c(rep(i,trts),row)
  }
  trt <- rep(0,trts*reps)
  base.plan <- data.frame(row,col,trt)
  for (i in 1:reps) {
    base.plan$trt[base.plan$row==i] <- sample(1:trts)
  }
  
  ret <- NULL
  hashes <- c()

  while (cnt < max.plans) {
    current.plan <- base.plan
    for (i in 1:reps) {
      current.plan$trt[current.plan$row==i] <- sample(1:trts)
    }
    hash.key <- plan.to.string(current.plan)
    if(!(hash.key %in% hashes)) {
      current.summary <- summarize.adtc(current.plan,multiple=multiple,plot.dim=plot.dim,buffer.dim=buffer.dim)
      #current.cont <- contrast.distances(current.plan,plot.dim=plot.dim,buffer.dim=buffer.dim)
      current.summary$hash <- hash.key
      current.summary$cnt <- cnt
      if(is.null(ret)) {
        ret <- current.summary
      } else {
        ret <- rbind(ret,current.summary)
      }
      hashes <- c(hashes,hash.key)
      cnt <- cnt +1
    }
  }
  return(ret)
}

summarize.adtc <- function(current.plan,multiple=FALSE,plot.dim=c(1,1),buffer.dim=c(0,0)) {
   rcb.distances <- pair.distances(current.plan,plot.dim=plot.dim,buffer.dim=buffer.dim)
  if(!multiple) {
    rcb.distances <-subset(rcb.distances,rcb.distances$rep1==rcb.distances$rep2)
  }
  rcb.table <- make.pairs.table(rcb.distances)
  rcb.matrices <- make.pairs.matrices(rcb.table)
  trtMeans <- apply(rcb.matrices$mean,1,mean,na.rm=TRUE)
  trtSD <- apply(rcb.matrices$mean,1,sd,na.rm=TRUE)
    
  return(data.frame(
    Mean=mean(trtMeans),
    SDofMeans=sd(trtMeans),
    MeanOfSD=mean(trtSD),
    Min=min(trtMeans),
    Max=max(trtMeans)
  ))
}


compare.adtc <- function(plan.list,multiple=FALSE,plot.dim=c(1,1),buffer.dim=c(0,0)) {
  ret <- NULL
  for(idx in 1:length(plan.list)) {
    current.plan <- plan.list[[idx]]
    current.summary <- summarize.adtc(current.plan,multiple=multiple,plot.dim=plot.dim,buffer.dim=buffer.dim)
    current.summary$plan <- names(plan.list)[idx]
    if(is.null(ret)) {
      ret <- current.summary
    } else {
      ret <- rbind(ret,current.summary)
    }
  }
  return(ret)
}


plan.to.string <- function(plan) {
  ret <- ""
  for(idx in 1:dim(plan)[1]) {
    ret <- paste(ret,plan$trt[idx],sep="")
  }
  return(ret)
}




#sample.adtc <- function(trts=7,reps=5,max.plans=100,plot.dim=c(1,1),buffer.dim=c(0,0)) {
#  col <- c(rep(1:trts,reps))
#  row <- c()
#  cnt <- 0
#  for (i in 1:reps) {
#    row <- c(rep(i,trts),row)
#  }
#  trt <- rep(0,trts*reps)
#  base.plan <- data.frame(row,col,trt)
#  for (i in 1:reps) {
#    base.plan$trt[base.plan$row==i] <- sample(1:trts)
#  }
  
#  ret <- contrast.distances(base.plan,plot.dim=plot.dim,buffer.dim=buffer.dim)$means
#  current.hash <- plan.to.string(base.plan)
#  hashes <- c(current.hash)
#  ret$hash <- current.hash
#  ret$cnt <- cnt
#  
#  while (cnt < max.plans) {
#    current.plan <- base.plan
#    for (i in 1:reps) {
#      current.plan$trt[current.plan$row==i] <- sample(1:trts)
#    }
#    hash.key <- plan.to.string(current.plan)
#    if(!(hash.key %in% hashes)) {
#      current.cont <- contrast.distances(current.plan,plot.dim=plot.dim,buffer.dim=buffer.dim)
#      current.cont$means$hash <- hash.key
#      current.cont$means$cnt <- cnt
#      ret <- rbind(ret,current.cont$means)
#      hashes <- c(hashes,hash.key)
#      cnt <- cnt +1
#    }
#  }
#  return(ret)
#}

#sample.adtc <- function(trts=7,reps=5,max.plans=100,plot.dim=c(1,1),buffer.dim=c(0,0)) {
#  col <- c(rep(1:trts,reps))
#  row <- c()
#  for (i in 1:reps) {
#    row <- c(rep(i,trts),row)
#  }
#  trt <- rep(0,trts*reps)
#  base.plan <- data.frame(row,col,trt)
#  for (i in 1:reps) {
#    base.plan$trt[base.plan$row==i] <- sample(1:trts)
#  }
#  ret <- data.frame(t(average.distances(base.plan,plot.dim=plot.dim,buffer.dim=buffer.dim,include.treatments=FALSE)))
#  hashes <- c(plan.to.string(base.plan))
#  cnt <- 0
#  while (cnt < max.plans) {
#    current.plan <- base.plan
#    for (i in 1:reps) {
#      current.plan$trt[current.plan$row==i] <- sample(1:trts)
#    }
#    hash.key <- plan.to.string(current.plan)
#    if(!(hash.key %in% hashes)) {
#      row <- average.distances(current.plan,plot.dim=plot.dim,buffer.dim=buffer.dim,include.treatments=FALSE)
#      ret <- rbind(ret,row)
#      hashes <- c(hashes,hash.key)
#      cnt <- cnt +1
#    }
#  }
#  return(ret)
#}