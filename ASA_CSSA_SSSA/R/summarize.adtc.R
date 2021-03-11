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