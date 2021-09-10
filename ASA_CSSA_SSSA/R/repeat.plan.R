#source("~/Work/git/ASA_CSSA_SSSA/ASA_CSSA_SSSA/R/repeat.plan.R")
repeat.plan <- function(plan,
                        model,
                        analysis.fn=rcb.analysis,
                        spacing=3) {
  
  trial.dim <- trial.dimensions(plan)
  
  trial.width <- trial.dim[1]
  trial.height <- trial.dim[2]
  
  rightBorder <- max(model$model$Longitude) - (trial.width+2*spacing)
  topBorder <- max(model$model$Latitude) - (trial.height+2*spacing)
  
  row=1
  col=1
  
  atColEnd=FALSE
  atRowEnd=FALSE
  plan.tbl <- NULL
  planNo <- 1
  analysis.tbl <- NULL
  while(!atColEnd) {
    currentRow <- 3+(row-1)*trial.height + (row-1)*2*spacing
    if(currentRow < topBorder) {
      while(!atRowEnd) {
        currentCol <- 3+(col-1)*trial.width + (col-1)*2*spacing
        if(currentCol<rightBorder) {
          corner <- c(currentCol,currentRow)
          #overlay and analyze
          currentPlan <- project.yield(plan,
                                       model=model,
                                       origin=corner)
          analysis <- analysis.fn(currentPlan)
          
          #save points
          currentPlan$Residuals <- analysis$Residuals
          currentPlan$Number <- planNo
          currentPlan$FieldRow <- corner[1]
          currentPlan$FieldCol <- corner[2]
          plan.tbl <- rbind(plan.tbl,currentPlan)
          
          analysis$Table$Source <- row.names(analysis$Table)
          analysis$Table$Number <- planNo
          analysis$Table$FieldRow <- corner[1]
          analysis$Table$FieldCol <- corner[2]
          
          analysis.tbl <- rbind(analysis.tbl,analysis$Table)
          
          planNo <- planNo+1
          
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
  
  row.names(analysis.tbl) <- 1:dim(analysis.tbl)[1]
  #not sure why I need to do this to get text in the return table
  #print(row.names(analysis$Table))
  #analysis.tbl$Source <- row.names(analysis$Table)[analysis.tbl$Source]
  
  return(list(Data=plan.tbl,
              Analysis=analysis.tbl))
}