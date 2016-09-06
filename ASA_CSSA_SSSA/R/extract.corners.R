extract.corners <- function(points.sim) {
  max.LonM <- max(points.sim$LonM, na.rm=TRUE)
  max.LatM <- max(points.sim$LatM, na.rm=TRUE)
  min.LonM <- min(points.sim$LonM, na.rm=TRUE)
  min.LatM <- min(points.sim$LatM, na.rm=TRUE)
  corners <- subset(points.sim, points.sim$LatM==max.LatM | points.sim$LatM==min.LatM)
  corners <- subset(corners, corners$LonM==max.LonM | corners$LonM==min.LonM)
  return(list(
    se=subset(points.sim,points.sim$number==corners$number[1]),
    sw=subset(points.sim,points.sim$number==corners$number[2]),
    ne=subset(points.sim,points.sim$number==corners$number[3]),
    nw=subset(points.sim,points.sim$number==corners$number[4])
  ))
}