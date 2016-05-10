weave <- function(a,b,random=FALSE) {
  m <- length(a)
  n <- length(b)
  
  longer <- c()
  shorter <- c()
  if(m>n) {
    longer <- c(a)
    shorter <- c(b)
    
  } else {
    longer <- c(b)
    shorter <- c(a)
  }
  
  res <- c()
  #start with the shorter list, and add 
  r <- length(shorter)
  max = r-1
  for(i in 1:max) {
    j <- ceiling(length(longer)/r)
    if(random) {
      if (runif(1) < 0.5) {
        j = ceiling(length(longer) / r)
      } else {
        j = floor(length(longer) / r)
      }
    }
    remaining <- length(longer) - j
    res <- c(res, shorter[i], longer[1:j])
    longer <- longer[j+1:remaining]
    r = r-1
  }
  res <- c(res, shorter[max+1], longer)
  return(res)
}