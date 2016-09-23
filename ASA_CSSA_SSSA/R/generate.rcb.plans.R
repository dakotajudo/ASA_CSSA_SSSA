generate.rcb.plans <- function(reps,treatments,count) {
  row <- c()
  trt <- c()
  for (i in 1:reps) {
    row <- c(row,rep(i,treatments))
    trt <- c(trt,sample(1:treatments))
  }
  base.plan <- data.frame(
    row = row,
    col = rep(1:treatments,reps),
    trt = trt,
    plotno = 1:(reps*treatments)
  )
  base.plan$trt <- as.factor(base.plan$trt)
  base.plan$blk <- as.factor(base.plan$row)
  base.plan$rep <- as.factor(base.plan$row)
  
  rcb.list <- vector("list", count)
  cnt=1
  hashes <- c()
  
  while (cnt <= count) {
    current.plan <- rcb.plan
    trt <- c()
    for (i in 1:reps) {
      trt <- c(trt,sample(1:treatments))
    }
    current.plan$trt <- as.factor(trt)
    
    hash.key <- plan.to.string(current.plan)
    if(!(hash.key %in% hashes)) {
      rcb.list[[cnt]] <- current.plan
      hashes <- c(hashes,hash.key)
      cnt <- cnt +1
    }
  }
  
  names(rcb.list) <- as.character(1:count)
  return(rcb.list)
}