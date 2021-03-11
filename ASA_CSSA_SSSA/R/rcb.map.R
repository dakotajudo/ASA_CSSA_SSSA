rcb.map <- function(plan,plots) {
  #do we assume plotno is number?
  row.names(plan) <- as.character(plan$plotno)
  row.names(plots) <- as.character(plots$plotno)
  #print(plan[row.names(plots),'trt'])
  plots[row.names(plots),'trt'] <-plan[row.names(plots),'trt']
  #for(p in min(plan$plotno):max(plan$plotno)) {
  #  mask <- plots$plotno==p
  #  if()
  #  plots$trt[mask] <- plan$trt[mask]
  #}
  return(plots)
}

