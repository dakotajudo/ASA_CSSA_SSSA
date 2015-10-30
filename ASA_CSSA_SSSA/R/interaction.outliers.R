interaction.outliers <- function(means.matrix, 
                                 means.vector,
                                 fixed=FALSE,
                                 multiplicative=TRUE,
                                 sigma=1.96,
                                 rms=NA) {
  
  decomp <- decompose.means.table(means.matrix)
  #decomp$mu

  treatment.matrix <- decomp$alpha
  trial.matrix <- decomp$beta
  txt.matrix <- decomp$gamma
  
  txt.effects <- unlist(txt.matrix)
  
  add.matrix <- treatment.matrix+trial.matrix
  add.effects <- unlist(add.matrix)
  
  #mult.matrix <- t(treatment.matrix*trial.matrix)
  mult.matrix <- treatment.matrix*trial.matrix + add.matrix
  mult.effects <- unlist(mult.matrix)
  
  z.mult <- mult.matrix/sd(mult.effects,na.rm=TRUE)
  z.txt <- add.matrix+txt.matrix
  z.txt <- z.txt/sd(unlist(z.txt),na.rm=TRUE)
  
  #z.mult <- mult.matrix/sd(mult.effects,na.rm=TRUE)
  #z.txt <- txt.matrix/sd(txt.effects,na.rm=TRUE)
  
  #trt.names <- colnames(means.matrix)
  #trial.names <- rownames(means.matrix)
  norm.mat = NA
  crit = sigma
  trt = c()
  trial = c()
  i.vec = c()
  j.vec = c()
  
  expected = c()
  actual = c()
  
  pairs <- list()
  mat.dim <- dim(txt.matrix)
  int.sd <- sqrt(sum(txt.effects*txt.effects)/((mat.dim[1]-1)*(mat.dim[2]-1)-1))
  
  err.sd <- sqrt(rms)
  if(!fixed) {
    if(is.na(rms)) {
      max <- int.sd
      norm.mat <- abs(txt.matrix)
      crit <- sigma*max
      int.sd <- max
    } else {
      max=err.sd
      norm.mat <- abs(txt.matrix)
      crit <- sigma*max
    }
    #outliers=txt.effects[abs(txt.effects) > sigma*max]
  } else {
    if(multiplicative) {
      z.dev <- z.txt-z.mult
      #z.dev <- z.dev/sd(unlist(z.dev))
      norm.mat <- abs(z.dev)
      #outliers=txt.effects[which(abs(z.txt-z.mult)>sigma)]
    } else {
      svd.gamma <- svd(txt.matrix)
      lambda <- sqrt(diag(svd.gamma$d))[1]
      theta = svd.gamma$u[,1]
      delta = svd.gamma$v[,1]
      
      theta2 = svd.gamma$u[,2]
      delta2 = svd.gamma$v[,2]
      lambda2 = sqrt(svd.gamma$d)[2]
      #ammi <- (theta %*% t(delta) * lambda)
      #ammi.diffs <- decomp$gamma - ammi
      #ammi.diffs <- unlist(ammi.diffs)      
      ammi2 <- (theta %*% t(delta) * lambda) + (theta2 %*% t(delta2) * lambda2)
      
      ammi2.diffs <- txt.matrix - ammi2
      norm.mat <- ammi2.diffs/sd(unlist(ammi2.diffs),na.rm=TRUE)
    }
  }
  
  #print(norm.mat)
  for (i in 1:dim(norm.mat)[1]) {
    for (j in 1:dim(norm.mat)[2]) {
      if(!is.na(norm.mat[i,j])) {
        if(norm.mat[i,j]>crit) {
          #trt <- c(trt,trt.names[j])
          #trial <- c(trial,trial.names[i])
          i.vec = c(i.vec,i)
          j.vec = c(j.vec,j)
          if(!fixed) {
            expected = c(expected,sigma*max)
            actual = c(actual,norm.mat[i,j])
          } else {
            expected = c(expected,z.mult[i,j])
            actual = c(actual,z.txt[i,j])
          }
          pairs <- append(pairs, list(c(j,i)))
        }
      }
    }
  }
  return(list(outliers=data.frame(trt.no=j.vec,
                                  trial.no=i.vec,
                                  expected=expected,
                                  actual=actual),
              crit=crit,
              int.sd=int.sd,
              err.sd=err.sd,
              pairs=pairs,
              z.mult=z.mult,
              z.txt=z.txt,
              scale = sd(mult.effects,na.rm=TRUE)/sd(txt.effects,na.rm=TRUE)
  ))
}