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