###
# Compute Tukey's 1 d.f. test of non-additivity for a typical GEI experiment. 
# For generality, Treatment and Trial names are used, but alternative names are allowed.
# If this is an unreplicated, or when only cell means are available, BlockName should be null.
# This may produce slightly different results, because the current version uses trial
# main effects and not trial means for regression.
# data may also be null; this function assumes names refer to the global space.
#
# This function returns two linear models. additivity.lm is used to estimate main effects from the original data.
# multiplicative.lm adds main effect estimates to the original data set and fits to the crossed main effect estimates.
# Main effect estimates are also returned.
#
# This file includes a print function that may be used to produce an appropriate anova table.
#
nonadditivity.gei <- function(data=NULL,
                            response = "Plot.Mean",
                            TreatmentName = "Treatment",
                            TrialName = "Trial",
                            BlockName = NULL
                            ) {
  
  blocked <- !is.null(BlockName)
  #create a local data frame so we can append ab estimates if necessary
  if(is.null(data)) {
    if(!blocked) {
      data <- data.frame(get(response),as.factor(get(TreatmentName)),as.factor(get(TrialName)))
      names(data) <- c(response,TreatmentName,TrialName)
    } else {
      data <- data.frame(get(response),as.factor(get(TreatmentName)),as.factor(get(TrialName),as.factor(get(BlockName))))
      names(data) <- c(response,TreatmentName,TrialName,BlockName)
    }
  } else {
    #TODO: check for valid names in input data
    #TODO: check that trial and treatment are factors
  }
  
  #fit additive model
  additive.lm <- NULL
  modelString <- paste(response," ~ ",TreatmentName," + ",TrialName)
  if(blocked) {
    modelString <- paste(modelString, " + ",TrialName,":",BlockName)
  }
  additive.lm <- lm(as.formula(modelString),data=data)
  
  #extract coefficients, referring to this as a beta vector
  additive.labels <- attr(additive.lm$terms, "term.labels")
  additive.assign = additive.lm$assign
  additive.coef <- additive.lm$coefficients
  e.beta <- additive.coef[additive.assign == which(additive.labels==TrialName)]
  t.beta <- additive.coef[additive.assign == which(additive.labels==TreatmentName)]

  #convert the model encoding to a full encoding.
  e.mat <- match.fun(additive.lm$contrasts[[TrialName]])(length(e.beta)+1)
  t.mat <- match.fun(additive.lm$contrasts[[TreatmentName]])(length(t.beta)+1)

  #multiply by the contrast to map to non-encoded effect estimates
  e.effects <- e.mat %*% e.beta
  t.effects <- t.mat %*% t.beta

  #subtract mean to center
  e.effects <- e.effects - mean(e.effects)
  t.effects <- t.effects - mean(t.effects)

  #put the names back in so we can index
  e.effects <- as.vector(e.effects)
  t.effects <- as.vector(t.effects)
  names(e.effects) <- additive.lm$xlevels[[TrialName]]
  names(t.effects) <- additive.lm$xlevels[[TreatmentName]]
  data$t <- t.effects[data[,TreatmentName]]
  data$e <- e.effects[data[,TrialName]]
  
  #use a consistent naming convention for estimates to allow returned data 
  #to be processed by other functions
  colnames(data)[colnames(data) == 't'] <- paste("e",TreatmentName,sep="")
  colnames(data)[colnames(data) == 'e'] <- paste("e",TrialName,sep="")
  
  #analyze with additional terms
  modelString <- paste(modelString," + e",TreatmentName,":e",TrialName,sep="")
  
  multiplicative.lm <- lm(as.formula(modelString),data=data)
  
  return(list(additive.lm=additive.lm,multiplicative.lm=multiplicative.lm,t=t.effects,e=e.effects))
}

recompute.tdf.aov <- function(tdf.tbl,aov.tbl) {
  # assume the tdf table has full aov residuals, while the second to last row in aov.tbl
  # is assumed to be treatment by trial interaction
  #we append the residual row
  last = dim(aov.tbl)[1]
  last.row <- aov.tbl[last,]
  tdf.last <- dim(tdf.tbl)[1]
  colnames(last.row) <- colnames(tdf.tbl)
  tdf.tbl <- rbind(tdf.tbl,last.row)
  #compute interaction residuals by subtracting 1df row from txt row
  tdf.tbl[tdf.last,] <- aov.tbl[last-1,] - tdf.tbl[tdf.last-1,]
  #recompute residuals
  tdf.tbl[tdf.last,3] <- tdf.tbl[tdf.last,2]/tdf.tbl[tdf.last,1]
  #test treatment:trial against interaction residual
  tdf.tbl[tdf.last-1,4] <- tdf.tbl[tdf.last-1,3]/tdf.tbl[tdf.last,3]
  tdf.tbl[tdf.last-1,5] <- 1-pf(tdf.tbl[tdf.last-1,4],tdf.tbl[tdf.last-1,1],tdf.tbl[tdf.last,1])
  
  #test interaction residual against experimental residual
  tdf.tbl[tdf.last,4] <- tdf.tbl[tdf.last,3]/last.row[3]
  tdf.tbl[tdf.last,5] <- 1-pf(tdf.tbl[tdf.last,4],tdf.tbl[tdf.last,1],as.numeric(last.row[1]))
  return(tdf.tbl)
}

print.nonadditivity.gei <- function(res) {
  print("One d.f. test for non-additivity",quote = FALSE)
  print("",quote = FALSE)
  print("Treatment effects",quote = FALSE)
  print(res$t)
  print("Trial Effects",quote = FALSE)
  print(res$e)
  print("",quote = FALSE)
  print("Additive Linear model",quote = FALSE)
  print(summary(res$additive.lm))
  print(summary(aov(res$additive.lm)))
  print("",quote = FALSE)
  print("Multiplicative Linear model",quote = FALSE)
  print(summary(res$multiplicative.lm))
  print(summary(aov(res$multiplicative.lm)))
}
