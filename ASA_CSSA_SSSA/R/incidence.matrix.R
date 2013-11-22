incidence.matrix <- function(data, effect) {
   cLevels <- levels(get(effect,data))
   contr <- contr.treatment(cLevels,contrasts=FALSE)
   idx <- as.numeric(data[,effect])
   return(as.matrix(t(contr[,idx])))
}


