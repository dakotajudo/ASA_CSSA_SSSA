coincidence.matrix <- function(data=NULL, a.name,b.name) {
   a <- incidence.matrix(data,effect=a.name)
   b <- incidence.matrix(data,effect=b.name)
   return(t(a) %*% b)
}

