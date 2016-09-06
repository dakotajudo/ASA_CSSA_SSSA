expected.adtc <- function(plan, multiple=TRUE) {
  
  trts <- 0
  if(is.factor(plan$trt)) {
    trts <- length(levels(plan$trt))
  } else {
    trts <- max(as.numeric(plan$trt))
  }

  reps <- 1
  if(multiple) {
    reps <- max(plan$row)
  }
  return((trts-2)*(trts+1)/(18*reps))
}