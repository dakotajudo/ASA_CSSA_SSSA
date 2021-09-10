#source("~/Work/git/ASA_CSSA_SSSA/ASA_CSSA_SSSA/R/trial.dimensions.R")
trial.dimensions <- function(plan) {
  plot.dim <- attr(plan,'PlotDim')
  buffer.dim <- attr(plan,'BufferDim')
  rows <- max(plan$Row)-min(plan$Row)+1
  cols <-  max(plan$Column)-min(plan$Column)+1
  plot.width <- plot.dim[1]*cols + (cols-1)*buffer.dim[1]
  plot.height <- plot.dim[2]*rows + (rows-1)*buffer.dim[2]
  return(c(plot.width,plot.height))
}