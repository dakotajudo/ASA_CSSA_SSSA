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