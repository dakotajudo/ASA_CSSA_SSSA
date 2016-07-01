simulate.plan <- function(plan,field,plot.dim=c(1,1),
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
  
  TrtMS <- c()
  TrtDF <- c()
  TrtP <- c()
  RepMS <- c()
  RepDF <- c()
  RepP <- c()
  RepVar <- c()
  ResMS <- c()
  ResP <- c()
  ResDF <- c()
  ResVar <- c()
  Row <- c()
  Col <- c()
  Number <- c()
  
  rightBorder <- max(field$LonM) - (trial.width+2*spacing)
  topBorder <- max(field$LatM) - (trial.height+2*spacing)
  
  row=1
  col=1
  atColEnd=FALSE
  atRowEnd=FALSE
  plans <- NA
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
          aov.tbl <- summary(aov(YldVolDry ~ as.factor(trt)+as.factor(blk),data=currentPlan$plan))
          aov.mle <- aov.mle <- lme(YldVolDry ~ as.factor(trt), random = ~ 1| as.factor(blk), data=currentPlan$plan)
          
          var.tbl <- VarCorr(aov.mle)
          
          
          #save points
          currentPlan$plan$number <- planNo
          Number <- c(Number,planNo)
          
          planNo <- planNo+1
          plans <- rbind(plans,currentPlan$plan)
          
          TrtDF <- c(TrtDF,aov.tbl[[1]][1,1])
          TrtMS <- c(TrtMS,aov.tbl[[1]][1,3])
          TrtP <- c(TrtP,aov.tbl[[1]][1,5])
          RepDF <- c(RepDF,aov.tbl[[1]][2,1])
          RepMS <- c(RepMS,aov.tbl[[1]][2,3])
          RepP <- c(RepP,aov.tbl[[1]][2,5])
          RepVar <- c(RepVar,as.numeric(var.tbl[1]))
          
          
          ResDF <- c(ResDF,aov.tbl[[1]][3,1])
          ResMS <- c(ResMS,aov.tbl[[1]][3,3])
          ResP <- c(ResP,aov.tbl[[1]][3,5])
          ResVar <- c(ResVar,as.numeric(var.tbl[2]))
          
          Row <- c(Row,corner[1])
          Col <- c(Col,corner[2])
          
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
  sim.dat <- data.frame(
    TrtDF = TrtDF,
    TrtMS = TrtMS,
    TrtP = TrtP,
    RepDF = RepDF,
    RepMS = RepMS,
    RepVar = RepVar,
    RepP = RepP,
    ResDF = ResDF,
    ResMS = ResMS,
    ResVar=ResVar,
    Row = Row,
    Col = Col,
    Number=Number
  )
  return(list(aov=sim.dat,
              points=plans))
}