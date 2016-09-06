plot.distance <- function(p1,p2,plot.dim=c(1,1),buffer.dim=c(0,0)) {
  local.plot <- c(plot.dim[2],plot.dim[1])
  local.buffer <- c(buffer.dim[2],buffer.dim[1])
  unit.dist <- p1 - p2
  dist <- unit.dist * local.plot
  dist <- dist + unit.dist * local.buffer
  dist <- dist*dist
  dist <- sqrt(sum(dist))
  return(dist)
}