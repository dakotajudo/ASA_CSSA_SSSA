generate.rcb.plan <- function(reps,treatments) {
  Row <- c()
  Treatment <- c()
  for (i in 1:reps) {
    Row <- c(Row,rep(i,treatments))
    Treatment <- c(Treatment,sample(1:treatments))
  }
  base.plan <- data.frame(
    Plot = 1:(reps*treatments),
    Row = Row,
    Column = rep(1:treatments,reps),
    Treatment = Treatment
  )
  base.plan$Replicate <- base.plan$Row
  #base.plan$trt <- as.factor(base.plan$trt)
  #base.plan$blk <- as.factor(base.plan$row)
  #base.plan$rep <- as.factor(base.plan$row)
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
    Treatment <- c()
    for (i in 1:reps) {
      Treatment <- c(Treatment,sample(1:treatments))
    }
    current.plan$Treatment <- Treatment
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