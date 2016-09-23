permute.plan <- function(plan,byRow=TRUE,byCol=TRUE,renumber=TRUE) {
  if(byRow) {
    rows <- max(plan$row)
    plan$row = sample(1:rows)[plan$row]
  }
  if(byCol) {
    cols <- max(plan$col)
    plan$col = sample(1:cols)[plan$col]
  }
  if(renumber) {
    plan$rep <- as.factor(plan$row)
    plan$blk <- as.factor(plan$row)
    cols <- max(plan$col)
    plan$plotno <- cols*(plan$row - 1)  + plan$col
    plan <- plan[order(plan$plotno),]
  }
  return(plan)
} 