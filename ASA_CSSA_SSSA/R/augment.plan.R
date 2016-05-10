augment.plan <- function(plan,v_1,stagger=-1) {
  rows <- max(plan$row)
  cols <- max(plan$col)
  v_t <- max(plan$trt)
  plan.matrix <- matrix(rep(0,rows*cols),nrow=rows)
  
  for(idx in 1:length(plan$row)) {
    r = plan$row[idx]
    c = plan$col[idx]
    plan.matrix[r,c] = plan$trt[idx]
  }
  
  v_star = length(v_1)
  
  blocks <- dim(plan.matrix)[1]
  cols <- dim(plan.matrix)[2]
  
  k_u = ceiling(v_star / blocks)
  
  neededChecks = k_u * blocks - v_star
  
  if (neededChecks > 0) {
    padding = sample(v_r, neededChecks)
    v_1 <- c(v_1,padding)
  }

  v_1 = sample(v_1)

  k_r = cols
  
  k  = k_u + k_r

  aug.matrix <- matrix(rep(0,rows*k),nrow=rows)

  startOffset  = sample(k)[1]
  
  a = 1
  b = k_u
  
  if(stagger<0) {
    stagger  = floor(sqrt(k_u / k_r))
  }
  
  for (row in 1:rows) {
    V_r = plan.matrix[row,]
    lines = v_1[a:(a+b-1)]
    a = a + b
    
    entries <- c()
    
    #how many lines do we need to pad out the block?
    needed = k - length(V_r)
    if (length(lines) < (needed)) {
      #pad with controls
      tmp = sample(V_r, needed - length(lines))
      print(tmp)
      lines <- c(lines,tmp)
      lines = sample(lines)
      print(lines)
    }
    
    entries = weave(V_r, lines, random=TRUE)
    
    entries = cycle(entries, startOffset)
    startOffset = startOffset - stagger
    if (startOffset < 1) {
      startOffset = k_u + k_r + startOffset
    }
    aug.matrix[row,] <- entries    
  }
  return(aug.matrix)
}