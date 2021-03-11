overlay.field <- function(plan, field,
                          plot.dim=c(1,1),
                          buffer.dim=c(0,0),
                          sample.vgm=NULL,
                          spacing=3,model="rcb",mean=FALSE) {
  require(gstat)
  
  trial.dim <- trial.dimensions(plan=plan, plot.dim=plot.dim,buffer.dim=buffer.dim)
  
  trial.width <- trial.dim[1]
  trial.height <- trial.dim[2]
  
  if(!mean) {
    if(is.null(sample.vgm)) {
      sample.var <- variogram(Yield~1, 
                              locations=~Longitude+Latitude, 
                              data=field)
      sample.vgm <- fit.variogram(sample.var, vgm("Exp"))
    }
  }
  rightBorder <- max(field$Longitude) - (trial.width+2*spacing)
  topBorder <- max(field$Latitude) - (trial.height+2*spacing)
  
  row=1
  col=1
  atColEnd=FALSE
  atRowEnd=FALSE
  plots <- NULL
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
                                          buffer.dim=buffer.dim,
                                          sample.vgm=sample.vgm,
                                          mean=mean
                                      
          )
          
          #save points
          current.plots <- NA
          #if(mean) {
          #  current.plots <- currentPlan$mean
          #} else {
            current.plots <- currentPlan$plan
          #}
          current.plots$number <- planNo
          current.plots$Row <- currentRow
          current.plots$Col <- currentCol
          current.plots$Model <- model
        
          planNo <- planNo+1
          plots <- rbind(plots,current.plots)
          
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
  return(plots)
}
