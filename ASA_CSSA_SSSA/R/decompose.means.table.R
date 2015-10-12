# return a set of four matrices, one for
#  grand mean (mu)
#  row means (alpha)
#  col means (beta)
#  interactions (gamma)
decompose.means.table <- function(means.matrix, ols=FALSE) {
  rows <- dim(means.matrix)[1]
  cols <- dim(means.matrix)[2]
  grand.mean <- mean(unlist(means.matrix),na.rm=TRUE)
  grand.matrix <- matrix(rep(grand.mean,rows*cols),nrow=rows)
  col.effects <- colMeans(means.matrix,na.rm=TRUE) - grand.mean
  row.effects <- rowMeans(means.matrix,na.rm=TRUE) - grand.mean
  
  col.matrix <- matrix(rep(1,rows)) %*% col.effects
  row.matrix <- row.effects %*% t(matrix(rep(1,cols)))
  
  int.matrix <- means.matrix-(col.matrix+row.matrix+grand.mean)
  
  rownames(grand.matrix) <- rownames(int.matrix)
  rownames(row.matrix) <- rownames(int.matrix)
  rownames(col.matrix) <- rownames(int.matrix)
  
  colnames(grand.matrix) <- colnames(int.matrix)
  colnames(row.matrix) <- colnames(int.matrix)
  colnames(col.matrix) <- colnames(int.matrix)
  
  return(list(mu=grand.matrix,
              alpha=row.matrix,
              beta=col.matrix,
              gamma=int.matrix))
}

principal.components <- function(means.matrix) {
  decomp <- decompose.means.table(means.matrix)
  P1 <- decomp$mu + decomp$alpha + decomp$beta + decomp$gamma
  P2 <- decomp$alpha + decomp$beta + decomp$gamma
  P3 <- decomp$beta + decomp$gamma
  P4 <- decomp$alpha + decomp$gamma
  P5 <- decomp$gamma
  
  return(list(P1 = princomp(t(P1)),
              P2 = princomp(t(P2)),
              P3 = princomp(t(P3)),
              P4 = princomp(t(P4)),
              P5 = princomp(t(P5))
  ))
}