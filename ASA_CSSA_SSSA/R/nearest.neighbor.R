#assume a data file with x,y and trt
#plot.dim is width, height
#buffer is between plots in rows, between rows
neighbor.matrix <- function(dat,plot.dim = c(1,1), plot.buffer=c(0,0)) {
  plots <- dim(dat)[1]
  cols <- max(dat$x)
  rows <- max(dat$y)
  width <- plot.dim[1]
  height <- plot.dim[2]
  col.space <- width+plot.buffer[1]
  row.space <- height+plot.buffer[2]
  Wp <- matrix(rep(0,plots*plots),nrow=plots)
  for (i in 1:plots) {
    r <- dat$y[i]
    c <- dat$x[i]
    if(in.range(r,1,rows) & in.range(c-1,1,cols)) {
       idx <- cols*(r-1)+(c-1)
       Wp[i,idx] <- 1/col.space
    }
    if(in.range(r,1,rows) & in.range(c+1,1,cols)) {
       idx <- cols*(r-1)+(c+1)
       Wp[i,idx] <- 1/col.space
    }
    if(in.range(r-1,1,rows) & in.range(c,1,cols)) {
       idx <- cols*(r-2)+c
       Wp[i,idx] <- 1/row.space
    }
    if(in.range(r+1,1,rows) & in.range(c,1,cols)) {
       idx <- cols*(r)+c
       Wp[i,idx] <- 1/row.space
    }
  }
  for (i in 1:plots) {
    Wp[i,] <- Wp[i,]/sum(Wp[i,])
  }
  return(Wp)
}



in.range <- function(x,a,b) {
  if(a>b) {
     tmp <- a
     a <- b
     b <- tmp
  }
  return((x>=a) & (x<=b))
}

neighbor.effects <- function(dat,plot.dim = c(1,1), plot.buffer=c(0,0)) {
  Wn <- neighbor.matrix(dat,plot.dim, plot.buffer)
  crd.lm <- lm(yield ~ trt,data=dat)
  return(list(X=Wn %*% crd.lm$resid,
              lm=crd.lm,
              Wn=Wn))
}

neighbor.analysis <- function(dat,plot.dim = c(1,1), plot.buffer=c(0,0)) {
  nn.res <- neighbor.effects(dat,plot.dim, plot.buffer)
  dat$X <- nn.res$X
  nn.lm <- update(nn.res$lm, . ~ . + X, data=dat)
  ret <- list(crd=nn.res$lm,nn=nn.lm,Wn=nn.res$Wn)
  class(ret) = "NN"
  return(ret)
}

print.NN <- function(obj) {
  print(summary(aov(obj$crd)))
  print(summary(aov(obj$nn)))
  print(anova(obj$crd,obj$nn))
}

