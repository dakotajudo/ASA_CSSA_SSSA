calculate.power.efficiency <- function(cv=NULL, power=NULL, osl=NULL, meandiff=NULL, reps=NULL, error.df=NULL, treatment.df=1,non.central.t=TRUE) {
  
  
  #compute error degrees of freedom if possible
  if(!is.null(reps)) {
    error.df = treatment.df * (reps-1)
  }
  
  #precalculate za and zb, using qnorm or qt depending on if we have error DF 
  zb  = 0.0
  za = 0.0
  ncp=0
  
  if (!is.null(error.df)) {
    if(non.central.t) {
      if(!is.null(meandiff)) {
       #ncp = sqrt(error.df+1)*meandiff/cv
      }
    } 
    za = qt(1- osl / 2, error.df)
    zb = qt(1 - power, error.df,ncp=ncp)
  } else {
    za = qnorm(osl / 2)
    zb = qnorm(1 - power)
  }
  
  effect.size = (cv / meandiff)
  effect.sizeSqr = effect.size * effect.size
  if (is.null(reps)) {
    
    tmp1 = (za + zb)
    reps = (2 * (tmp1 * tmp1)) * (effect.sizeSqr)
    
    tmp.reps = reps
    if (treatment.df>1) {
      for(i in 1:20) {
        reps=ceiling(reps)
        if(reps<2) {
          reps=2
        }
        error.df = treatment.df * (reps-1)
        #ncp = sqrt(error.df+1)*meandiff/cv
        za = qt(1- osl / 2, error.df)
        zb = qt(1 - power, error.df,ncp=ncp)
        tmp1 = (za + zb)
        reps = (2 * (tmp1 * tmp1)) * (effect.sizeSqr)
        #if we use less than non-integer reps, for iteration, we better match Table 2.1 in Cochran and Cox
        if (abs((tmp.reps - reps)) < 0.1) {
          return(ceiling(reps))
        }
        tmp.reps = reps
      }
    }
    return(ceiling(tmp.reps))
  } else if (is.null(power)) {
    #zb = (meandiff / cv) * sqrt(reps / 2) + za
    d <- meandiff/cv
    ncp <- d*sqrt(reps/2)
    df <- (reps-1)+(reps-1)
    q = qt(1-osl/2,df)
    if (!is.null(error.df)) {
      #return(pt(zb, error.df, ncp=ncp))
      #zb = (meandiff / cv) * sqrt(reps / 2) + za
      return(1-pt(q=q,df=df,ncp=ncp)+pt(q=-q,df=df,ncp=ncp))
      #return(1-pt(zb, error.df, ncp=ncp) + pt(-zb, error.df, ncp=ncp))
      #return(pt(zb, error.df))
    } else {
      return(pnorm(zb))
    }
  } else if (is.null(osl)) {
    za = (meandiff / cv) * Math.Sqrt((reps / 2)) + zb
    if (!is.null(error.df)) {
      return((1 - pt(za, error.df)) * 2)
    } else {
      return((1 - pnorm(za)) * 2)
    }
  } else if (is.null(cv)) {
    return(cv = abs(sqrt(reps / 2) * (meandiff / (za + zb))))
  } else if (is.null(meandiff)) {
    return(abs(((za + zb) * cv) / (sqrt(reps / 2))))
  } else {
    #all five parameters are non-zero. Do nothing for now.
  }
}


#effect.size = meandiff / cv
a.priori <- function(effect.size, osl, power, error.df = 0) {
  reps = 0
  for (i in 2:100) {
    res = post.hoc(effect.size, i, osl,error.df=error.df)
    if (res$power > power) {
      reps = i
      break;
    }
  }
  
  if (reps == 0) {
    reps = NA
  }
  
  return(list(effect.size=effect.size,
              osl=osl,
              power=res$power,
              reps=reps,
              crit.t=res$crit.t,
              ncp=res$ncp,
              p1=res$p1,
              p2=res$p2))
}

post.hoc <- function(effect.size, reps, osl, error.df = 0) {
  #assume we wish to use the non-central t
  ncp = effect.size * sqrt(reps / 2)
  #If we haven't been given an error degrees of freedom, assume paired t-test
  if (error.df <= 0) {
    error.df = (reps - 1) + (reps - 1)
  }

  #Compute a critical t value
  crit.t = qt(1 - (osl / 2), error.df)
  #Calculate achieved power?
  p1 = pt(crit.t, error.df, ncp)
  p2 = pt(-crit.t, error.df, ncp)
  return(list(
    reps=reps,
    effect.size=effect.size,
    osl=osl,
    power=(1 - p1 + p2),
    ncp=ncp,
    crit.t=crit.t,
    p1=p1,
    p2=p2))
}

#osl
criterion <- function(effectSize, reps, error.df = 0) {
  #Brute force. Iterate over different levels of alpha until we get to close enough power
  #Determine alpha, bounded below by 0
  #First, use effect size 1 and decide if we need to iterate up or down from there
  magnitude = 10
  current.alpha = 0.0
  current.power = 0.0
  for (current.alpha in 1:10) {
    current.power = post.hoc(effectSize, reps, current.alpha / magnitude, error.df)
    if (current.power > power) {
      break;
    }
  }
  
  #alpha is between 1 and 10, so map to between 0 and 9, then
  # 0.0 <= current.alpha / magnitude <= 0.90
  current.alpha = current.alpha - 1
  #and convert 
  current.alpha = current.alpha / magnitude
  #Now iterate at increasingly higher magnitudes (smaller digits)
  
  for (magnitude in 2:8) {
    digit = 0
    tenth = 1 / (10 ^ magnitude)
    for (digit in 1:9) {
      working.alpha = current.alpha + digit * tenth
      current.power = post.hoc(effectSize, reps, working.alpha)
      if (current.power$power > power) {
        break;
      }
    }
    current.alpha = current.alpha + (digit - 1) * tenth
  }
  return(list(
    reps=reps,
    effect.size=effect.size,
    osl=current.alpha,
    power=current.power$power,
    ncp=current.power$ncp,
    crit.t=current.power$crit.t,
    p1=current.power$p1,
    p2=current.power$p2))
}


#calculate effect size
sensitivity <- function(osl, reps, power=0.80, error.df = 0) {
  #Brute force. Iterate over different levels of effect sizes until we get to close enough power
  #Determine intial effect size
  #First, use effect size 1 and decide if we need to iterate up or down from there
  intial.effect.size = 1.0
  current.power = 0.0
  #we need to iterate up over larger effect sizes
  #we start with values from 1 to 100
  for (i in 1:100) {
    current.power = post.hoc(i, reps, osl,error.df=error.df)
    if (current.power$power > power) {
      break;
    }
  }
  #required effect size is bounded by I-1 and I
  current.effect.size  = i - 1
  magnitude = 1
  #iterate over 8 powers of 10
  for (magnitude in 1:8) {
    digit = 0
    tenth = 1 / (10 ^ magnitude)
    for (digit in 1:9) {
      working.effect.size = current.effect.size + digit * tenth
      current.power = post.hoc(working.effect.size, reps, osl,error.df=error.df)
      if (current.power$power > power) {
        break;
      }
    }
    current.effect.size = current.effect.size + (digit - 1) * tenth
  }

  return(list(
    reps=reps,
    effect.size=current.effect.size,
    osl=osl,
    power=current.power$power,
    ncp=current.power$ncp,
    crit.t=current.power$crit.t,
    p1=current.power$p1,
    p2=current.power$p2))
}




