trial.dimensions <- function(plan,plot.dim,buffer.dim) {
  rows <- max(plan$row)-min(plan$row)+1
  cols <-  max(plan$col)-min(plan$col)+1
  plot.width <- plot.dim[1]*cols + (cols-1)*buffer.dim[1]
  plot.height <- plot.dim[2]*rows + (rows-1)*buffer.dim[2]
  return(c(plot.width,plot.height))
}