make.plan <- function(mat) {
  rows <- dim(mat)[1]
  cols <- dim(mat)[2]
  col <- rep((1:cols),rows)
  row <- c()
  for (idx in 1:rows) {
    row <- c(row, rep(idx,cols))
  }
  ret <- data.frame(
    row=row,
    col=col,
    trt=rep(0,rows*cols)
  )
  for(idx in 1:dim(ret)[1]) {
    ret$trt[idx] <- mat[ret$row[idx],ret$col[idx]]
  }
  return(ret)
}