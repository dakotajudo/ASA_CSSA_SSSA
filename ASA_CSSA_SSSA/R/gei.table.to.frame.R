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

gei.frame.to.table <- function(frame,response = "Plot.Mean",TreatmentName="Treatment",TrialName="Trial",RepName=NA,GinRows=TRUE,lsmeans=TRUE) {
 if(!lsmeans) {
   if(GinRows) {
     return(tapply(frame[,response],list(frame[,TreatmentName],frame[,TrialName]),mean,na.rm=TRUE))
   } else {
     return(tapply(get(response,frame),list(get(TrialName,frame),get(TreatmentName,frame)),mean,na.rm=TRUE))
   }
 } else {
   res <- gei.table.and.effects(frame,
                                response = response,
                                TreatmentName=TreatmentName,
                                TrialName=TrialName,
                                RepName=RepName,
                                GinRows=GinRows)
   return(res$table)
 }
}

###
# Compute a least squares means table and provide the estimated effects.
# 
gei.table.and.effects <- function(frame,response = "Plot.Mean",TreatmentName="Treatment",TrialName="Trial",RepName=NULL,GinRows=TRUE){
  blocked <- !is.null(RepName)
  frm <- paste(response, "~",TrialName,"*",TreatmentName)
  if(blocked) {
    frm <- paste(frm,"+",TrialName,":",RepName)
  }
  base.lm <- lm(frm,data=frame)
  
  #extract the least squares estimates. we can use labels to map 
  #the correct positions
  labels <- attr(base.lm$terms, "term.labels")
  trialIdx <- which(labels==TrialName)
  treatmentIdx <- which(labels==TreatmentName)
  
  intName <- paste(TrialName,":",TreatmentName,sep="")
  interactionIdx <- which(labels==intName)
  
  beta.e <- base.lm$coefficients[base.lm$assign == trialIdx]
  beta.t <- base.lm$coefficients[base.lm$assign == treatmentIdx]
  beta.te <- base.lm$coefficients[base.lm$assign == interactionIdx]
  beta.b <- NA
  
  if(blocked) {
    blkName <- paste(TrialName,":",RepName,sep="")
    blockIdx <- which(labels==blkName)
    beta.b <- base.lm$coefficients[base.lm$assign == blockIdx]
  }
  
  #note that beta may be a reduced dummy encoding, but we want to return a full length beta for each,
  #so we need to map to the correct encoding function
  treatments <- length(beta.t)+1
  trials <- length(beta.e)+1
  reps <- 0
  if(blocked) {
    reps <- (length(beta.b)/trials)+1
  }

  C.e <- match.fun(base.lm$contrasts[[TrialName]])(trials)
  C.t <- match.fun(base.lm$contrasts[[TreatmentName]])(treatments)
  C.r <- NA
  if(blocked) {
    C.r <- match.fun(base.lm$contrasts[[TrialName]])(reps)
  }
  #I'm making an assumption here about order, but we control that in this function. If
  #we decide to accept an existing linear model, this should be checked.
  C.te <- kronecker(C.t,C.e)

  #since reps are nested, we need a full encoding for trials to generate the block contrasts
  C.full.e <- match.fun(base.lm$contrasts[[TrialName]])(trials,contrasts=FALSE)
  C.b <- NA
  if(blocked) {
    C.b <- kronecker(C.r,C.full.e)
  }
  trl.effects <- C.e %*% beta.e
  trt.effects <- C.t %*% beta.t
  int.effects <- C.te %*% beta.te
  blk.effects<- NA
  if(blocked) {
    blk.effects <- C.b %*% beta.b
  }
  #and since these include an intercept, we need to center
  trl.effects <- trl.effects - mean(trl.effects)
  trt.effects <- trt.effects - mean(trt.effects)
  int.effects <- int.effects - mean(int.effects)
  if(blocked) {
    blk.effects <- blk.effects - mean(blk.effects)
  }
  ##Least Squares Means
  # We'll used the contrast matrices to create a set of linear contrasts that
  # when multiplied by our coefficients provide the treatment and trial means.
  
  includeIntercept = base.lm$assign[1] == 0
  notEstimable <- FALSE
  coeffs.1 <- base.lm$coefficients
  
  if(any(is.na(coeffs.1))) {
    coeffs.1[is.na(coeffs.1)] <- 0
    notEstimable <- TRUE
  }
  
  #Treatment means.
  L.e <- matrix(1,ncol=(trials-1),nrow=treatments)
  L.e <- L.e/trials
  
  L.r <- NA
  if(blocked) {
    L.r <- matrix(1,nrow=treatments,ncol=((reps-1)*trials))
    L.r <- L.r/(reps*trials)
  }

  L.te <- kronecker(C.t,t(rep(1,(trials-1))))
  L.te <- L.te/trials
  
  L.trt <- NA
  if(includeIntercept) {
    if(blocked) {
      L.trt <- cbind(rep(1,treatments),L.e,C.t,L.te,L.r)
    } else {
      L.trt <- cbind(rep(1,treatments),L.e,C.t,L.te)
    }
  } else {
    if(blocked) {
      L.trt <- cbind(L.e,C.t,L.te,L.r)
    } else {
      L.trt <- cbind(L.e,C.t,L.te)
    }
  }
  trt.lsmeans <- L.trt %*% coeffs.1

  #trial means
  L.t <- matrix(1,ncol=(treatments-1),nrow=trials)
  L.t <- L.t/treatments
  
  if(blocked) {
    L.r <- matrix(rep(C.full.e,reps-1),nrow=trials)
    L.r <- L.r/(reps)
  }
  L.te <- kronecker(C.e,t(rep(1,(treatments-1))))
  L.te <- L.te/treatments
  L.trial <- NA
  if(includeIntercept) {
    if(blocked) {
      L.trial <- cbind(rep(1,trials),C.e,L.t,L.te,L.r)
    } else {
      L.trial <- cbind(rep(1,trials),C.e,L.t,L.te)
    }
  } else {
    if(blocked) {
      L.trial <- cbind(C.e,L.t,L.te,L.r)
    } else {
      L.trial <- cbind(C.e,L.t,L.te)
    } 
  }
  trial.lsmeans <- L.trial %*% coeffs.1
  
  #Treatment by trial means
  L.t <- kronecker(rep(1,trials),C.t)

  L.e <- kronecker(C.e,rep(1,treatments))
  if(blocked) {
    L.r <- kronecker(t(rep(1,reps-1)),C.full.e)
    L.r <- kronecker(L.r,rep(1,treatments))
    L.r <- L.r/(reps)
  }
  
  L.te <- expand.incidence(C.e,C.t,byRows=TRUE)
  L.txt <- NA
  if(includeIntercept) {
    if(blocked) {
      L.txt <- cbind(rep(1,treatments*trials),L.e,L.t, L.te, L.r)
    } else {
      L.txt <- cbind(rep(1,treatments*trials),L.e,L.t, L.te)
    }
  } else {
    if(blocked) {
      L.txt <- cbind(L.e,L.t, L.te, L.r)
    } else {
      L.txt <- cbind(L.e,L.t, L.te)
    }
  }
  
  txt.lsmeans <- L.txt %*% coeffs.1
  trt.lsmeans.tbl <- matrix(txt.lsmeans,nrow=treatments)
  if(!GinRows) {
    trt.lsmeans.tbl <- t(trt.lsmeans.tbl)
  }
  
  if(blocked) {
    return(list(trl.effects=trl.effects,
                trt.effects=trt.effects,
                int.effects=int.effects,
                blk.effects=blk.effects,
                trt.means=trt.lsmeans,
                trial.means=trial.lsmeans,
                means.table=trt.lsmeans.tbl))
  } else {
    return(list(trl.effects,
                trt.effects,
                int.effects,
                trt.means=trt.lsmeans,
                trial.means=trial.lsmeans,
                means.table=trt.lsmeans.tbl))
  }
  
}