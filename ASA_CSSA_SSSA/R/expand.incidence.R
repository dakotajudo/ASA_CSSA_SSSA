#Each row (or column) in A, expanded by multiplying by corresponding entry in B
#added to support least square means for trials and treatment x trial (Feb 20 15, PMC)
expand.incidence <- function(a, b, byRows=TRUE) {

  m = dim(a)[1]
  n = dim(a)[2]
  p = dim(b)[1]
  q = dim(b)[2]
  ret = matrix(0,nrow=(m * p), ncol=(n * q))

  #for each cell in b, create a block in the output matrix
  for (outerP in 1:p) {
    for (outerQ  in 1:q) {
      currentB = b[outerP, outerQ]
      for (innerM  in 1:m) {
        for (innerN  in 1:n) {
          val = a[innerM, innerN] * currentB
          if (byRows) {
            #row in the return is the current A block (where each A block has p rows)
            #plus the current B row
            i = ((innerM-1) * p) + outerP
            #similarly, current column is the current A block (each with Q columns)
            j = ((outerQ-1) * n) + innerN
            ret[i, j] = val
          } else {
            #row in the return is the current A block (where each A block has p rows)
            #plus the current B row
            i = ((innerM-1) * p) + outerP
            #similarly, current column is the current A block (each with Q columns)
            j = ((innerN-1) * q) + outerQ
            ret[i, j] = val
          }
        }
      }
    }
  }
  return (ret)
}



#Complements expandIncidence, by restricting substitutions to rows.
expand.incidence.rows <- function(a, b) {
  m = dim(a)[1]
  n = dim(a)[2]
  p = dim(b)[1]
  q = dim(b)[2]
 
  if (m != dim(b)[1]) {
    return(expand.incidence(a, b))
  } else {
    n = dim(a)[2]
    q = dim(b)[2]
    ret = matrix(0,nrow=m, ncol(n * q))
    #for each cell in b, create a block in the output matrix
      for (outerQ  in 1:q) {
        for (innerM  in 1:m) {
           i = innerM
           for (innerN in 1:n) {
             currentB = b[innerM, outerQ]
             val = a[innerM, innerN] * currentB
            #Current column is the current A block (each with Q columns)
            j = ((outerQ-1) * n) + innerN
            ret[i, j] = val
          }
        }
      }
    return(ret)
  }
}

rep.cols <- function(a, reps) {
  rMax = dim(a)[1]
  originalCols = dim(a)[2]
  #increase coumns by number of reps
  cMax = originalCols * reps
  ret = matrix(0,nrow=rMax, ncol=cMax)
  for (rIdx in 1:rMax) {
    for (cIdx in 1:originalCols) {
      cell = a[rIdx, cIdx]
      for (repIdx in 1:reps) {
        ret[rIdx, (cIdx-1) * reps + repIdx] = cell
      }
    }
  }
  return(ret)
}

rep.rows <- function(a, reps) {
  cMax = dim(a)[2]
  originalRows = dim(a)[1]
  #increase coumns by number of reps
  rMax = originalRows * reps
  ret = matrix(0,nrow=rMax, ncol=cMax)
  for (cIdx in 1:cMax) {
    for (rIdx in 1:originalRows) {
      cell = a[rIdx, cIdx]
      for (repIdx in 1:reps) {
        ret[(rIdx-1) * reps + repIdx, cIdx] = cell
      }
    }
  }
  return(ret)
}

