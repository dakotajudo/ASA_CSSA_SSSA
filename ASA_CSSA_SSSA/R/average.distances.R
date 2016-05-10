average.distances <- function(plan,include.treatments=TRUE,multiple=FALSE,reference=c()) {
  pairs.dat <- pair.distances(plan,reference=reference)
  contrasts.dat <- contrast.distances(plan,multiple=multiple,reference=reference)
  sd.plan <- sd(contrasts.dat$distance)
  
  contrasts.dat <- reshape(contrasts.dat, idvar = "contrast", varying = list(1:2),
                           v.names = "trt", direction = "long")
  #if we have augmented or unreplicated treatments
  contrasts.dat <- subset(contrasts.dat,contrasts.dat$distance>0)
  
  m.pair <- tapply(pairs.dat$distance,list(pairs.dat$contrast),mean,na.rm=TRUE)
  sd.pair <- tapply(pairs.dat$distance,list(pairs.dat$contrast),sd,na.rm=TRUE)
  
  m.cont <- tapply(contrasts.dat$distance,list(contrasts.dat$trt),mean,na.rm=TRUE)
  sd.cont <- tapply(contrasts.dat$distance,list(contrasts.dat$trt),sd,na.rm=TRUE)
  expected.sd <- expected.adtc(plan)
  if(include.treatments) {
    return(list(means.pair=m.pair,
             expected.sd=expected.sd,
             sd.plan=sd.plan,
             grand.m.pair=mean(m.pair,na.rm=TRUE),
             grand.sd.pair=sd(m.pair,na.rm=TRUE),
             sd.pair=mean(sd.pair,na.rm=TRUE),
             max.sd.pair=max(sd.pair,na.rm=TRUE),
             #f.pair=f.pair,
             #p.pair=p.pair,
             means.cont=m.cont,
             grand.m.cont=mean(m.cont,na.rm=TRUE),
             sd.means.cont=sd(m.cont,na.rm=TRUE),
             sd.cont=mean(sd.cont,na.rm=TRUE),
             max.sd.cont=max(sd.cont,na.rm=TRUE)
             #f.cont=f.cont,
             #p.cont=p.cont
    ))
  } else {
    return(list(expected.sd=expected.sd,
             sd.plan=sd.plan,
             grand.m.pair=mean(m.pair,na.rm=TRUE),
             grand.sd.pair=sd(m.pair,na.rm=TRUE),
             sd.pair=mean(sd.pair,na.rm=TRUE),
             max.sd.pair=max(sd.pair,na.rm=TRUE),
             grand.m.cont=mean(m.cont,na.rm=TRUE),
             sd.means.cont=sd(m.cont,na.rm=TRUE),
             sd.cont=mean(sd.cont,na.rm=TRUE),
             max.sd.cont=max(sd.cont,na.rm=TRUE)
    ))
  }
}