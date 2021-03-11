plan.to.string <- function(plan) {
  ret <- ""
  for(idx in 1:dim(plan)[1]) {
    ret <- paste(ret,plan$trt[idx],sep="")
  }
  return(ret)
}