simulate.plan <- function(plan,field,
                          plot.dim=c(1,1),
                          effects.fn=NULL,
                          analysis.fn=rcb.analysis,
                          row.buffer=0,
                          sample.vgm=NULL,
                          spacing=3,model="rcb") {
  
  trial.dim <- trial.dimensions(plan,plot.dim=plot.dim,row.buffer=row.buffer)
  
  trial.width <- trial.dim[1]
  trial.height <- trial.dim[2]
  
  if(is.null(sample.vgm)) {
    sample.var <- variogram(YldVolDry~1, 
                            locations=~LonM+LatM, 
                            data=map.data)
    sample.vgm <- fit.variogram(sample.var, vgm("Exp"))
  }
  
  sim.dat <- NULL
  
  rightBorder <- max(field$LonM) - (trial.width+2*spacing)
  topBorder <- max(field$LatM) - (trial.height+2*spacing)
  
  row=1
  col=1
  atColEnd=FALSE
  atRowEnd=FALSE
  plans <- NULL
  planNo <- 1
  while(!atColEnd) {
    currentRow <- 3+(row-1)*trial.height + (row-1)*2*spacing
    if(currentRow < topBorder) {
      while(!atRowEnd) {
        currentCol <- 3+(col-1)*trial.width + (col-1)*2*spacing
        if(currentCol<rightBorder) {
          corner <- c(currentCol,currentRow)
          #overlay and analyze
          currentPlan <- superimpose.plan(plan,
                                          map.data=field,
                                          start.point=corner,
                                          plot.dim=plot.dim,
                                          row.buffer=row.buffer,
                                          sample.vgm=sample.vgm
          )

          current.res <- analysis.fn(currentPlan$plan)
          current.res$Number <- planNo
          current.res$Row <- corner[1]
          current.res$Col <- corner[2]

          if(is.null(sim.dat)) {
            sim.dat <- current.res
          } else {
            sim.dat <- rbind(sim.dat,current.res)
          }
          
          #save points
          currentPlan$plan$number <- planNo

          planNo <- planNo+1
          plans <- rbind(plans,currentPlan$plan)
        
          col=col+1  
        } else {
          atRowEnd=TRUE
        }
      }
      col=1
      row=row+1
      atRowEnd=FALSE
    } else {
      atColEnd =TRUE
    }
  }
  
  return(list(aov=sim.dat,
              points=plans))
}

rcb.analysis <- function(current.dat) {
  aov.tbl <- summary(aov(YldVolDry ~ as.factor(trt)+as.factor(rep),data=current.dat))
  aov.mle <- lme(YldVolDry ~ as.factor(trt), random = ~ 1| as.factor(rep), data=current.dat)
  
  var.tbl <- VarCorr(aov.mle)
  
  return(data.frame(
    TrtDF = aov.tbl[[1]][1,1],
    TrtMS = aov.tbl[[1]][1,3],
    TrtP = aov.tbl[[1]][1,5],
    RepDF = aov.tbl[[1]][2,1],
    RepMS = aov.tbl[[1]][2,3],
    RepVar = as.numeric(var.tbl[1]),
    RepP = aov.tbl[[1]][2,5],
    ResDF = aov.tbl[[1]][3,1],
    ResMS = aov.tbl[[1]][3,3],
    ResVar=as.numeric(var.tbl[2])
  ))
}

simulate.plans <- function(pln.list,trial.data,sample.vgm,plot.dim=c(1,1), row.buffer=c(0,0)) {
  
  points <- NULL
  aov <- NULL
  for (idx in 1:length(pln.list)) {
    current.plan <- pln.list[[idx]]
    tmp <- simulate.plan(current.plan,trial.data, 
                         plot.dim=arm.plot.dim, 
                         row.buffer=arm.row.buffer, sample.vgm=sample.vgm)
    tmp$points$plan <- idx
    tmp$aov$plan <- idx
    if(is.null(points)) {
      points <- tmp$points
      aov <- tmp$aov
    } else {
      points <- rbind(points,tmp$points)
      aov <- rbind(aov,tmp$aov)
    }
  }
  return(list(points=points,aov=aov))
}
