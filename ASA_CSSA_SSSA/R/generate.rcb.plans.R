generate.rcb.plan <- function(reps,treatments) {
  row <- c()
  trt <- c()
  for (i in 1:reps) {
    row <- c(row,rep(i,treatments))
    trt <- c(trt,sample(1:treatments))
  }
  base.plan <- data.frame(
    plotno = 1:(reps*treatments),
    row = row,
    col = rep(1:treatments,reps),
    trt = trt
  )
  base.plan$trt <- as.factor(base.plan$trt)
  base.plan$blk <- as.factor(base.plan$row)
  base.plan$rep <- as.factor(base.plan$row)
  class(base.plan) <- c("trial.map",class(base.plan))
  return(base.plan)
 
}


generate.rcb.plans <- function(reps,treatments,count,hash=TRUE) {

  base.plan <- generate.rcb.plan(reps,treatments)
  
  rcb.list <- vector("list", count)
  cnt=1
  hashes <- c()
  
  while (cnt <= count) {
    current.plan <- base.plan
    trt <- c()
    for (i in 1:reps) {
      trt <- c(trt,sample(1:treatments))
    }
    current.plan$trt <- as.factor(trt)
    if(hash) {
      hash.key <- plan.to.string(current.plan)
      if(!(hash.key %in% hashes)) {
        hashes <- c(hashes,hash.key)
        rcb.list[[cnt]] <- current.plan
        cnt <- cnt + 1
      }
    } else {
      rcb.list[[cnt]] <- current.plan
      cnt <- cnt +1
    }
  }
  
  if(hash) {
    names(rcb.list) <- hashes
  } else {
    names(rcb.list) <- as.character(1:count)
  }

  return(rcb.list)
}