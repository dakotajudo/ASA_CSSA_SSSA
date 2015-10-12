ggplot.matrix <- function(mat) {
  require(ggplot2)
  col.means <- colMeans(mat)
  row.means <- rowMeans(mat)
  rowIdx <- 1:length(row.means)
  colIdx <- 1:length(col.means)
  names(colIdx) <- names(col.means)
  names(rowIdx) <- names(row.means)
  mat.stack <- stack(mat)
  #ind is G (col.means)
  mat.stack$genotype <- mat.stack$ind
  mat.stack$environment <- rep(names(row.means),length(col.means))
  #mat.stack$genmean <- row.means[mat.stack$environment]
  #mat.stack$envmean <- col.means[mat.stack$genotype]
  mat.stack$row <- rowIdx[mat.stack$environment]
  mat.stack$col <- colIdx[mat.stack$genotype]
  return(ggplot(mat.stack, aes(x=col, y=row)) + geom_point(shape=19,size=8,aes(color=values)) + scale_colour_gradient(low="green",high="red"))
}

ggplots.decomposed.table <- function(mat) {
  decomp <- decompose.means.table(mat)
  return(list(mu=ggplot.matrix(decomp$mu),
              alpha=ggplot.matrix(decomp$alpha),
              beta=ggplot.matrix(decomp$beta),
              gamma=ggplot.matrix(decomp$gamma))
  )
}