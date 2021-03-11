summary.plan.simulations <- function(res,alpha=0.05) {
  TypeIError <- res$aov$TrtP <= alpha
  ErrorCounts <- tapply(TypeIError, list(res$aov$Source,res$aov$plan), sum)
  TrialCounts <- tapply(TypeIError, list(res$aov$Source,res$aov$plan), length)
  tbl <- data.frame(100*ErrorCounts/TrialCounts)

  row.means <- apply(tbl,1,mean)
  row.sd <- apply(tbl,1,sd)
  
  col.means <- apply(tbl,2,mean)
  col.sd <- apply(tbl,2,sd)
  
  if(dim(tbl)[2]>1) {
    tbl$Mean <- row.means
    tbl$SD <- row.sd
  }
  return(list(
    TypeIError=tbl
  ))
}
