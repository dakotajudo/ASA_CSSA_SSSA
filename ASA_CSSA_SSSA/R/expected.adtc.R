expected.adtc <- function(plan, multiple=TRUE) {
  trts <- max(plan$trt)
  reps <- 1
  if(multiple) {
    reps <- max(plan$row)
  }
  return((trts-2)*(trts+1)/(18*reps))
}