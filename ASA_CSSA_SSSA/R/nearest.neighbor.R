#assume a data file with x,y and trt
#plot.dim is width, height
#buffer is between plots in rows, between rows
neighbor.matrix <- function(dat,plot.dim = c(1,1), plot.buffer=c(0,0),rowOnly=FALSE,split=FALSE) {
  plots <- dim(dat)[1]
  cols <- max(dat$x)
  rows <- max(dat$y)
  width <- plot.dim[1]
  height <- plot.dim[2]
  col.space <- width+plot.buffer[1]
  row.space <- height+plot.buffer[2]
  mat.dim <- rows*cols
  
  #create an index for rows and columns, map to cells in data
  trial.map <- data.frame(x=dat$x,y=dat$y,cell=rep(0,length(dat$x)))
  
  #Wp <- matrix(rep(0,mat.dim*mat.dim),nrow=mat.dim)
  
  W.row <- matrix(rep(0,mat.dim*mat.dim),nrow=mat.dim)
  W.col <- matrix(rep(0,mat.dim*mat.dim),nrow=mat.dim)
  
  for (i in 1:plots) {
    r <- dat$y[i]
    c <- dat$x[i]
    trial.map$cell[trial.map$x==c & trial.map$y==r] <- i
  }
  
  for (i in 1:plots) {
    r <- dat$y[i]
    c <- dat$x[i]
    if(in.range(r,1,rows) & in.range(c-1,1,cols)) {
       #idx <- cols*(r-1)+(c-1)
       idx <-trial.map$cell[trial.map$x==(c-1) & trial.map$y==r]
       W.row[i,idx] <- 1/col.space
       #Wp[i,idx] <- 1/col.space
    }
    if(in.range(r,1,rows) & in.range(c+1,1,cols)) {
       #idx <- cols*(r-1)+(c+1)
       idx <-trial.map$cell[trial.map$x==(c+1) & trial.map$y==r]
       W.row[i,idx] <- 1/col.space
       #Wp[i,idx] <- 1/col.space
    }
    if(!rowOnly) {
      if(in.range(r-1,1,rows) & in.range(c,1,cols)) {
         #idx <- cols*(r-2)+c
         idx <-trial.map$cell[trial.map$x==c & trial.map$y==(r-1)]

        W.col[i,idx] <- 1/row.space

         #Wp[i,idx] <- 1/row.space
      }
      if(in.range(r+1,1,rows) & in.range(c,1,cols)) {
         #idx <- cols*(r)+c
         idx <-trial.map$cell[trial.map$x==c & trial.map$y==(r+1)]
         W.col[i,idx] <- 1/row.space
         #Wp[i,idx] <- 1/row.space
      }
    }
  }
  
  Wp <- W.col + W.row
  
  for (i in 1:mat.dim) {
    tmp <- sum(Wp[i,])
    if(tmp>0) {
      Wp[i,] <- Wp[i,]/tmp
    }
    if(split) {
      tmp <- sum(W.col[i,])
      if(tmp>0) {
        W.col[i,] <- W.col[i,]/tmp
      }
      tmp <- sum(W.row[i,])
      if(tmp>0) {
        W.row[i,] <- W.row[i,]/tmp
      }
    }
  }
  empty <- which(rowSums(Wp)==0)
  if(length(empty)>0) {
    Wp <- Wp[-empty,-empty]
  }
  if(split) {
    empty <- which(rowSums(W.col)==0)
    if(length(empty)>0) {
      W.col <- W.col[-empty,-empty]
    }
    empty <- which(rowSums(W.row)==0)
    if(length(empty)>0) {
      W.row <- W.row[-empty,-empty]
    }
  }
  return(list(W=Wp,W.row=W.row,W.col=W.col))
}



in.range <- function(x,a,b) {
  if(a>b) {
     tmp <- a
     a <- b
     b <- tmp
  }
  return((x>=a) & (x<=b))
}

neighbor.effects <- function(dat,plot.dim = c(1,1), plot.buffer=c(0,0),rowOnly=FALSE,split=FALSE) {
  mat <- neighbor.matrix(dat,plot.dim, plot.buffer,rowOnly=rowOnly,split=split)
  crd.lm <- lm(yield ~ trt,data=dat)
  X= mat$W %*% crd.lm$resid
  M= mat$W %*% dat$yield
  X.row <- NA
  X.col <- NA
  M.row <- NA
  M.col <- NA
  if(split) {
    X.row <- mat$W.row %*% crd.lm$resid
    X.col <- mat$W.col %*% crd.lm$resid
    M.row <- mat$W.row %*% dat$yield
    M.col <- mat$W.col %*% dat$yield
  }
  return(list(X=X,
              M=M,
              X.row=X.row,
              X.col=X.col,
              M.row=M.row,
              M.col=M.col,
              lm=crd.lm,
              W=mat))
}

neighbor.analysis <- function(dat,plot.dim = c(1,1), plot.buffer=c(0,0),rowOnly=FALSE,split=FALSE) {
  nn.res <- neighbor.effects(dat,plot.dim, plot.buffer,rowOnly=rowOnly,split=split)
  
  nn.lm <- NA
  avg.lm <- NA
  
  if(split) {
    dat$X.row <- nn.res$X.row
    dat$X.col <- nn.res$X.col
    dat$M.row <- nn.res$M.row
    dat$M.col <- nn.res$M.col
    nn.lm <- update(nn.res$lm, . ~ . + X.row + X.col, data=dat)
    avg.lm <- update(nn.res$lm, . ~ . + M.row + M.col, data=dat)
    #dat$X <- nn.res$X
    #dat$M <- nn.res$M
    #nn.lm <- update(nn.res$lm, . ~ . + X, data=dat)
    #avg.lm <- update(nn.res$lm, . ~ . + M, data=dat)
    
  } else {
    dat$X <- nn.res$X
    dat$M <- nn.res$M
    nn.lm <- update(nn.res$lm, . ~ . + X, data=dat)
    avg.lm <- update(nn.res$lm, . ~ . + M, data=dat)
  }
  ret <- list(crd=nn.res$lm,nn.effect=nn.lm,nn.mean=avg.lm,
    X=nn.res$X, X.row=nn.res$X.row, X.col=nn.res$X.col,
    M=nn.res$M, M.row=nn.res$M.row, M.col=nn.res$M.col,
    W=nn.res$W$W, W.row=nn.res$W$W.row,W.col=nn.res$W$W.col
    )
  class(ret) = "NN"
  return(ret)
}

print.NN <- function(obj) {
  print(summary(aov(obj$crd)))
  print(summary(aov(obj$nn.effect)))
  print(summary(aov(obj$nn.mean)))
  print(anova(obj$crd,obj$nn.effect,obj$nn.mean))
}

