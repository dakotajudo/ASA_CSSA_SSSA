###
# Utility functions to map data between matrix and table format, enforcing a common naming scheme.
###
gei.table.to.frame <- function(table,response = "Plot.Mean",TreatmentName="Treatment",TrialName="Trial",GinRows=TRUE) {
  
  #keep dimensions and names before stacking.
  table.dim <- dim(table)
  cnames <- colnames(table)
  rnames <- rownames(table)
  
  #stack the data. This is easier using a data frame
  if(!is.data.frame(table)) {
    table <- data.frame(table)
  }
  means.frame <- stack(table)
  
  #frame should have two columns, values and ind.
  #ind should have column names if present, but will have an arbitrary
  #name otherwise
  if(is.null(cnames)) {
    means.frame$ind <- rep(1:table.dim[2],each=table.dim[1])
  }
  
  #we need to add row names as well. If there are no rows names,
  #generate some
  if(is.null(rnames)) {
    rnames <- as.character(1:table.dim[1])
  }
  means.frame$newrow <- rep(rnames,table.dim[2])

  if(GinRows) {
    #treatments are in rows
    colnames(means.frame) <- c(response,TrialName,TreatmentName)
  } else {
    #trials in rows
    colnames(means.frame) <- c(response,TreatmentName,TrialName)
  }
  #make sure treatment and trial are factors
  means.frame[,c(TreatmentName,TrialName)] <- lapply(means.frame[,c(TreatmentName,TrialName)] , factor)
  return(means.frame)
}

gei.frame.to.table <- function(frame,response = "Plot.Mean",TreatmentName="Treatment",TrialName="Trial",GinRows=TRUE) {
  if(GinRows) {
    return(tapply(frame[,response],list(frame[,TreatmentName],frame[,TrialName]),mean,na.rm=TRUE))
  } else {
    return(tapply(get(response,frame),list(get(TrialName,frame),get(TreatmentName,frame)),mean,na.rm=TRUE))
  }
  #TODO : lsmeans
}