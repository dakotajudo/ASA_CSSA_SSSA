cycle <- function(a, start) {
  max = length(a)
  if (start > max) {
    start = start - max
  }
  
  if (start == 1) {
    return (a)
  } else {
    b <- c(a[start:max],a[1:(start-1)])
    return (b)
  }
}