sorted.matrix <- function(mat, rowIdx = c(), colIdx = c()) {
  if(length(rowIdx) != dim(mat)[1]) {
    rowIdx = rowMeans(mat)
  }
  if(length(colIdx) != dim(mat)[2]) {
    colIdx = colMeans(mat)
  }
  mat <- mat[order(rowIdx),]
  mat <- mat[,order(colIdx)]
  return(mat)
}