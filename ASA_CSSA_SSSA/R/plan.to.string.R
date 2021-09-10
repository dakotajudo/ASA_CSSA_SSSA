plan.to.string <- function(plan) {
  ret <- ""
  for(idx in 1:dim(plan)[1]) {
    ret <- paste(ret,plan$Treatment[idx],sep="")
  }
  return(ret)
}