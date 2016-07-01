add.plot.centers <- function(plan,plot.dim=c(1,1),row.buffer=c(0,0)) {
  plan$x <- 0
  plan$y <- 0
  
  half.width <- plot.dim[1]/2
  half.heigth <- plot.dim[2]/2
  for(idx in 1:dim(plan)[1]) {
    row <- plan$row[idx]
    col <- plan$col[idx]
    plan$x[idx] <- half.width + (col-1)*plot.dim[1] + (col-1)*row.buffer[1]
    plan$y[idx] <- half.heigth + (row-1)*plot.dim[2] + (row-1)*row.buffer[2]
  }
  return(plan)
}