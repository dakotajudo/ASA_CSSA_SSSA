plot.distance <- function(p1,p2,plot.dim=c(1,1),buffer.dim=c(0,0)) {
  unit.dist <- p1 - p2
  dist <- unit.dist * plot.dim
  dist <- dist + unit.dist * buffer.dim
  dist <- dist*dist
  dist <- sqrt(sum(dist))
  return(dist)
}