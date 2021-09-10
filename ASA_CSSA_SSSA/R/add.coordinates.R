#source("~/Work/git/ASA_CSSA_SSSA/ASA_CSSA_SSSA/R/add.coordinates")
add.coordinates <- function(plan,origin) {
  attr(plan,'Origin') <-  origin
  plot.dim <- attr(plan,'PlotDim')
  buffer.dim <- attr(plan,'BufferDim')
  if(is.null(plot.dim)) {
    plot.dim <-  c(4,6)
  }
  if(is.null(buffer.dim)) {
    buffer.dim <-  c(0.5,1)
  }
  plan$Longitude <- 0
  plan$Latitude <- 0
  
  half.width <- plot.dim[1]/2
  half.height <- plot.dim[2]/2
  
  plan$Longitude <- origin[1] + half.width + (plan$Column-1)*plot.dim[1] + (plan$Column-1)*buffer.dim[1]
  plan$Latitude <- origin[2] + half.height + (plan$Row-1)*plot.dim[2] + (plan$Row-1)*buffer.dim[2]
  return(plan)
}