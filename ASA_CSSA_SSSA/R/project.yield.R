#source("~/Work/git/ASA_CSSA_SSSA/ASA_CSSA_SSSA/R/project.yield.R")
project.yield <- function(plan, model, origin) {
  plan <- add.coordinates(plan,origin)
  plan$Yield <- predict(model,newdata=plan)
  return(plan=plan)
}