#source("~/Work/git/ASA_CSSA_SSSA/ASA_CSSA_SSSA/R/rcb.analysis.R")
rcb.analysis <- function(rcb.dat) {
  rcb.dat$Treatment <- as.factor(rcb.dat$Treatment)
  rcb.dat$Replicate <- as.factor(rcb.dat$Replicate)
  qq.dat <- rcb.dat
  gy.lm <- lm(Yield ~ Treatment + Replicate, data=rcb.dat)
  qq.dat$Yield <- residuals(gy.lm)
  rcb.dat$Source <- 'Data'
  qq.dat$Source <- 'Residuals'
  qq.dat <- rbind(rcb.dat,qq.dat)
  tbl <- anova(gy.lm)
  p <- ggplot(qq.dat, aes(sample = Yield)) + 
    stat_qq() + stat_qq_line() + 
    facet_wrap(~ Source, scales="free_y")
  return(list(Table=tbl,
              Plot=p,
              Residuals=residuals(gy.lm)))
}