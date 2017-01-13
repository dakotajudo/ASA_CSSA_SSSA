augmented.plots <- function(dat) {
dat$ID <- as.factor(as.character(dat$ID))
replicates <- tapply(dat$GY1,list(dat$ID),length)
#in some cases, unreplicated may be duplicated
dat$check <- (replicates>2)[dat$ID]
dat$GYdif <- (dat$GY1 - mean(dat$GY1,na.rm=TRUE))
replicates <- replicates[replicates>1]
replicated <- replicates[replicates>2]
check.cnt <- max(replicates)
dat$y <- dat$FIXED_RANG
dat$x <- dat$FIXED_PASS

trt.lm <- lm(GY1 ~ ID,data=dat)
crd.aov.tbl <- anova(trt.lm)
crd.ems <- crd.aov.tbl[dim(crd.aov.tbl)[1],3]
crd.df <- crd.aov.tbl[dim(crd.aov.tbl)[1],1]
aug.lm <- NA
if(crd.df > 20) {
  aug.lm <- lm(GY1 ~ y + x + I(y^2) + I(x^2) + I(y*x) + I(y^3) + I(x^3) + I(y*x^2) + I(y^2*x)+ID,data=dat)
} else if(crd.df > 15) {
  aug.lm <- lm(GY1 ~ y + x + I(y^2) + I(x^2) + I(y*x)+ID, data=dat)
} else {
  aug.lm <- lm(GY1 ~ y + x + I(y*x) + ID, data=dat)
}


dat$row <- as.factor(dat$y)
rcb.lm <- lm(GY1 ~ row + ID, data=dat)
rcb.lme <- lme(GY1 ~ ID,random= ~ 1 | row, data=dat)



aug.aov.tbl <- anova(aug.lm)
block.aov.tbl <- anova(rcb.lme)
fixed.aov.tbl <- anova(rcb.lm)

comp.tbl <- anova(trt.lm, aug.lm,rcb.lm)

resid.dat <- data.frame(
   resid=c(trt.lm$resid,aug.lm$resid,resid(rcb.lme)),
   source=factor(c(rep("crd",length(trt.lm$resid)),
                   rep("trend",length(aug.lm$resid)),
                   rep("block",length(resid(rcb.lme)))
                   )),
   check=c(dat$check,dat$check,dat$check)
)
means.tbl <- summary(lsmeans(aug.lm, ~ ID))
crd.tbl <- summary(lsmeans(trt.lm, ~ ID))
lme.tbl <- summary(lsmeans(rcb.lme, ~ ID)) 


means.tbl$crd <- crd.tbl$lsmean
means.tbl$crd.se <- crd.tbl$SE

means.tbl$lme <- lme.tbl$lsmean
means.tbl$lme.se <- lme.tbl$SE

means.tbl$check <- FALSE
means.tbl$check[means.tbl$ID %in% names(replicated)] <- TRUE


check.crd <- means.tbl$crd[means.tbl$check]
check.lsmean <- means.tbl$lsmean[means.tbl$check]
check.lme <- means.tbl$lme[means.tbl$check]


aug.ems <- aug.aov.tbl[dim(aug.aov.tbl)[1],3]
trend.df <- aug.aov.tbl[dim(aug.aov.tbl)[1],1]

lme.ems <- as.numeric(VarCorr(rcb.lme)[2,1])
block.df <- fixed.aov.tbl[dim(fixed.aov.tbl)[1],1]

crd.se <- sqrt(((1/check.cnt) + 1)*crd.ems)
aug.se <- sqrt(((1/check.cnt) + 1)*aug.ems)
block.se <- sqrt(((1/check.cnt) + 1)*lme.ems)
crd.lsd <- crd.se*qt(1-0.025,crd.df,lower.tail = TRUE)
aug.lsd <- aug.se*qt(1-0.025,trend.df,lower.tail = TRUE)
block.lsd <- block.se*qt(1-0.025,block.df,lower.tail = TRUE)

#means.tbl$crd.sig <- (means.tbl$crd < (check.crd-crd.lsd)) |
#                       (means.tbl$crd > (check.crd+crd.lsd))
#means.tbl$trend.sig <- (means.tbl$lsmean < (check.lsmean-aug.lsd)) |
#                       (means.tbl$lsmean > (check.lsmean+aug.lsd))

means.tbl$crd.sig <- (means.tbl$crd > (check.crd+crd.lsd)) | (means.tbl$crd < (check.crd-crd.lsd))
means.tbl$trend.sig <- (means.tbl$lsmean > (check.lsmean+aug.lsd)) | (means.tbl$lsmean < (check.lsmean-aug.lsd))
means.tbl$block.sig <- (means.tbl$lme > (check.lme+block.lsd)) | (means.tbl$lme < (check.lme-block.lsd))

means.tbl$difference.trend <- "none"
means.tbl$difference.trend[means.tbl$crd.sig] <- "crd"
means.tbl$difference.trend[means.tbl$trend.sig] <- "spatial (trend)"
means.tbl$difference.trend[means.tbl$crd.sig&means.tbl$trend.sig] <- "both"


means.tbl$difference.block <- "none"
means.tbl$difference.block[means.tbl$crd.sig] <- "crd"
means.tbl$difference.block[means.tbl$block.sig] <- "spatial (block)"
means.tbl$difference.block[means.tbl$crd.sig&means.tbl$block.sig] <- "both"

###Correlated errors
yield.gls <- gls(GY1 ~ 0 + ID, data=dat)

#x.vg <- Variogram(yield.gls, form = ~ x)
#y.vg <- Variogram(yield.gls, form = ~ y)
#xy.vg <- Variogram(yield.gls, form = ~ x + y)

yield.sym.gls <- update(yield.gls, corr = corCompSymm(form = ~ 1 | y))
yield.lin.gls <- update(yield.gls, corr = corLin(form = ~ x + y))
yield.rat.gls <- update(yield.gls, corr = corRatio(form = ~ x + y))
yield.sph.gls <- update(yield.gls, corr = corSpher(form = ~ x + y))
yield.exp.gls <- update(yield.gls, corr = corExp(form = ~ x + y))
yield.gaus.gls <- update(yield.gls, corr = corGaus(form = ~ x + y))
corr.list <- list(yield.sym.gls,yield.lin.gls,yield.rat.gls,yield.sph.gls,yield.exp.gls,yield.gaus.gls)
  comp.tbl <- anova(yield.sym.gls,yield.lin.gls,yield.rat.gls,yield.sph.gls,yield.exp.gls,yield.gaus.gls)
 
  best.corr  <- corr.list[[which(comp.tbl$AIC==min(comp.tbl$AIC))]]

  corr.aov.tbl <- anova(best.corr)

  #print(summary(best.corr))
  #corr.comp.aov.tbl <- anova(yield.gls, best.corr)
  #print(str(best.corr))
  
  corr.tbl <- summary(lsmeans(best.corr, ~ ID,data=dat))
  #print(corr.tbl)
  means.tbl$corr <- corr.tbl$lsmean
  means.tbl$corr.se <- corr.tbl$SE

  check.corr <- means.tbl$corr[means.tbl$check]
  corr.ems <- as.numeric(summary(best.corr)$sigma)
  #print(corr.ems)
  corr.se <- sqrt(((1/check.cnt) + 1)*corr.ems*corr.ems)
  corr.lsd <- corr.se*qt(1-0.025,crd.df,lower.tail = TRUE)
  means.tbl$corr.sig <- (means.tbl$corr < (check.corr-corr.lsd)) | (means.tbl$corr > (check.corr+corr.lsd))
  means.tbl$difference.corr <- "none"
  means.tbl$difference.corr[means.tbl$crd.sig] <- "crd"
  means.tbl$difference.corr[means.tbl$corr.sig] <- "spatial (corr)"
  means.tbl$difference.corr[means.tbl$crd.sig&means.tbl$corr.sig] <- "both"  

#for plot shape size 
means.tbl$check <- as.numeric(means.tbl$check)+1
    
ret <- list(data=dat,
             replicates=replicates,
             check.cnt=check.cnt,
             means.tbl=means.tbl, 
             crd.aov=crd.aov.tbl,
             trend.aov=aug.aov.tbl,
             block.aov=block.aov.tbl,
             corr.aov=corr.aov.tbl,
             comparison.aov=comp.tbl,
             check.crd=check.crd,
             check.trend=check.lsmean,
             check.block=check.lme,
             crd.se=crd.se,
             trend.se=aug.se,
             block.se=block.se,
             crd.df=crd.df,
             trend.df=trend.df,
             block.df=block.df,
             crd.lsd=crd.lsd,
             trend.lsd=aug.lsd,
             block.lsd=block.lsd,
             corr.fit=best.corr,
             map=ggplot(dat, aes(FIXED_PASS,FIXED_RANG)) + 
                        geom_point(aes(colour = check),size=2) +
                        scale_color_manual(values=c("#999999", "#E69F00")),
             effect=ggplot(dat, aes(FIXED_PASS,FIXED_RANG)) + 
                        geom_point(aes(colour = GYdif), size=3) +
                        scale_colour_gradient(low="#999999", high="#E69F00"),
             density=ggplot(dat, aes(GY1,color=check,linetype=check)) + 
                            stat_density(geom="line", 
                                position="identity", size=1) + 
                       scale_color_manual(values=c("#999999", "#E69F00")),
              barplot=ggplot(dat, aes(GY1,..count..,fill=check)) +
                             stat_count(position="dodge") + 
                             scale_fill_manual(values=c("#999999", "#E69F00")),
              residplot=ggplot(resid.dat[resid.dat$check,], 
                    aes(resid,color=source, linetype=source)) +
                    stat_density(geom="line",position="identity",size=1) + 
                    scale_color_manual(values=c("#999999", "#E69F00", "#009E73")),
              trend.meansplot=ggplot(means.tbl, aes(crd, lsmean)) +      
                               geom_point(aes(colour = difference.trend,size = check)) + 
                               scale_color_manual(values=c("#E69F00", "#0072B2", "#009E73", "#D55E00")) +
                               stat_smooth(method="lm", se=FALSE,color="#999999") +
                               #geom_vline(xintercept = (check.crd-crd.lsd),color="#0072B2") +
                               geom_vline(xintercept = (check.crd+crd.lsd),color="#0072B2") +
                               #geom_hline(yintercept = (check.lsmean-aug.lsd),color="#D55E00") +
                               geom_hline(yintercept = (check.lsmean+aug.lsd),color="#D55E00"),
              block.meansplot=ggplot(means.tbl, aes(crd, lme)) +      
                                                geom_point(aes(colour = difference.block,size = check)) + 
                                                scale_color_manual(values=c("#E69F00", "#0072B2", "#009E73", "#D55E00")) +
                                                stat_smooth(method="lm", se=FALSE,color="#999999") +
                                                #geom_vline(xintercept = (check.crd-crd.lsd),color="#0072B2") +
                                                geom_vline(xintercept = (check.crd+crd.lsd),color="#0072B2") +
                                                #geom_hline(yintercept = (check.lsmean-aug.lsd),color="#D55E00") +
                                                geom_hline(yintercept = (check.lme+block.lsd),color="#D55E00"),
              corr.meansplot=ggplot(means.tbl, aes(crd, corr)) + 
                                               geom_point(aes(colour = difference.corr,size = check)) + 
                                               scale_color_manual(values=c("#E69F00", "#0072B2", "#009E73", "#D55E00")) +
                                               stat_smooth(method = "lm", se=FALSE,color="#999999") + 
                                               geom_vline(xintercept = check.crd+crd.lsd,color="#0072B2") + 
                                               geom_hline(yintercept = (check.corr+corr.lsd),color="#D55E00")

          )
class(ret) <- "augmented.analysis"
return(ret)
}

print.augmented.analysis <- function(res) {
  print(res$crd.aov)
  print(res$trend.aov)
  print(res$block.aov)
  print(res$corr.aov)
  print(res$comparison.aov)
  
  comp.tbl <- data.frame(CheckMean=c(res$check.crd,res$check.trend,res$check.block),
                         SE=c(res$crd.se,res$trend.se,res$block.se),
                         DF=c(res$crd.df,res$trend.df,res$block.df),
                         LSD=c(res$crd.lsd,res$trend.lsd,res$block.lsd))
  row.names(comp.tbl) <- c("CRD","Trend","Block")
  print(comp.tbl)
  
  print(res$corr.fit$model)
}