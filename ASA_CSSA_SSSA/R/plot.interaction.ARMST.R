#TFS 7204 - Treatment x Trial Interaction Graph - R
#Parameters
#scale
#tcl
#mgp
#legend.x = .90
#legend.y = .55
# cex
#   A numerical value giving the amount by which plotting text and symbols should be magnified relative to the default. This starts as 1 when a device is opened, and is reset when the layout is changed, e.g. by setting mfrow.
# lwd (Added May 25 15, PMC)
#   weight used for lines and points.
# highlight (Added May 28 15, PMC)
#   uses cex value to enlarge lines and symbols for specified treatment numbers
# TFS 7998 (May 25 15, PMC) Corrected error with pch for linear plots
# TFS 8043 changed how means are stacked. This correctly maps treatment numbers in numeric order. 
#   Previously, the wrong treatment number would be plotted in the legend, creating a mismatch between
#   the treatment number shown in the legend and the symbol used to plot means for that treatment. (Jun 15 15, PMC)
# Added parameter for polynomial plotting (Jun 16 15, PMC)
# Added parameter to mark specific interactions. This is a list of pairs, treatment number:trial number (Jun 16 15, PMC)
plot.interaction.ARMST <- function(means.matrix, 
                                   means.vector,
                                   ylab="",
                                   xlab="",
                                   main="",
                                   regression=TRUE,
                                   show.legend=FALSE,
                                   trt.colors=c(),
                                   trt.labels=NA,
                                   legend.labels=c(),
                                   legend.columns=1,
                                   style.legend=1,
                                   family.main="",
                                   #family.lab="",
                                   family.axis="",
                                   family.legend="",
                                   col.axis="black",
                                   col.lab="black",
                                   col.main="black",
                                   col.sub="black",
                                   fg="black",
                                   bg="white",
                                   left.las=0,
                                   min.y=NA,
                                   max.y=NA,
                                   ylog=FALSE,
                                   xlog=FALSE,
                                   legend.pos=c(.90,.55),
                                   lwd = 3,
                                   cex=1.0,
                                   highlight=c(),
                                   hcex=1.5,
                                   fixed.prop=FALSE,
                                   poly=1,
                                   mark.int = c(),
                                   plot.unity=FALSE,
                                   highlight.point=TRUE,
                                   tukey.coeffs=c(),
                                   inverse.regression=FALSE,
                                   pc.regression=FALSE,
                                   segments=FALSE) {
  legend.x = legend.pos[1]
  legend.y = legend.pos[2]
  
  # use this to force means table to use numeric names. This assumes
  # means are in correct numeric order (Jun 9 15, PMC)
  colnames(means.matrix) <- as.character(1:dim(means.matrix)[2])
  rownames(means.matrix) <- as.character(1:dim(means.matrix)[1])
  names(means.vector) <- as.character(1:dim(means.matrix)[1])
  
  means.table <- data.frame(stack(means.matrix))
 
  means.table$TrtNo <- as.numeric(as.character(means.table$ind))
  
  trts <- dim(means.matrix)[2]
  trials <- dim(means.matrix)[1]
  trt.levels <- levels(means.table$ind)
  
  #we'll return a data table with one row for each treatment.
  #this table will include the slope, intercept and other stats to be added
  ret.fit <- data.frame(
    Treatment = 1:trts,
    Slope = rep(NA,trts),
    Intercept = rep(NA,trts),
    R2 = rep(NA,trts),
    AdjR2 = rep(NA,trts),
    Mean = rep(NA,trts),
    SD = rep(NA,trts),
    PSlope = rep(NA,trts),
    b = rep(NA,trts),
    Pb = rep(NA,trts),
    bR2 = rep(NA,trts)
    )
  
  means.table$Trial.ID <- rep(rownames(means.matrix),trts)
  means.table$Trial.idx <- rep(1:trials,trts)
  means.table$trial.mean <- means.vector[means.table$Trial.idx]
  
  #center on trial mean
  means.table$centered <- means.table$values - means.vector[means.table$Trial.idx]
  
  if(is.na(min.y)){
    min.y <- min(means.table$values,na.rm=TRUE)
  }
  if(is.na(max.y)){
    max.y <- max(means.table$values,na.rm=TRUE)
  }
  min.x <- min(means.table$trial.mean,na.rm=TRUE)
  max.x <- max(means.table$trial.mean,na.rm=TRUE)
  if(fixed.prop) {
    min.x <- min(c(min.x,min.y))
    max.x <- max(c(max.x,max.y))
    min.y <- min.x
    max.y <- max.x
  }
  trt.data <- subset(means.table,means.table$TrtNo==1)
  if(length(trt.colors)<trts) {
    trt.colors <- c(trt.colors,rainbow(trts-length(trt.colors)))
  }
  
  trt.pch = 1:trts
  
  #pch 26:31 are unused, so add six if larger
  if(trts>25) {
    trt.pch[trt.pch>25] <- trt.pch[trt.pch>25] + 7
  }
  
  plot.lwd = lwd
  plot.cex = cex
  if(1 %in% highlight) {
    plot.lwd = 1.5*lwd*hcex
    if(highlight.point) {
      plot.cex = plot.cex*hcex*0.8
    }
  }
  
  ret.fit$Mean[1] = mean(trt.data$values,na.rm=TRUE)
  ret.fit$SD[1] = sd(trt.data$values,na.rm=TRUE)
  
  if(segments) {
    plot(values ~ trial.mean,trt.data,
         xlim=c(min.x,max.x), 
         ylim=c(min.y,max.y),
         xlog=xlog,
         ylog=ylog,
         bg=bg,
         #main=main,
         #sub=subtitle,
         col=trt.colors[1],
         pch=trt.pch[1],
         axes=FALSE,
         #las=1,
         #font.main=style.main,
         #font.lab=style.axis,
         col.axis=col.axis,
         col.lab=col.lab,
         xlab=xlab,
         ylab=ylab,
         lwd=plot.lwd,
         cex=plot.cex,
         asp=1
    )
  } else {
    plot(values ~ trial.mean,trt.data,
         xlim=c(min.x,max.x), 
         ylim=c(min.y,max.y),
         xlog=xlog,
         ylog=ylog,
         bg=bg,
         #main=main,
         #sub=subtitle,
         col=trt.colors[1],
         pch=trt.pch[1],
         axes=FALSE,
         #las=1,
         #font.main=style.main,
         #font.lab=style.axis,
         col.axis=col.axis,
         col.lab=col.lab,
         xlab=xlab,
         ylab=ylab,
         lwd=plot.lwd,
         cex=plot.cex
    )
  }

  title(main,
        family=family.main,
        col.main=col.main)
  box(bg=bg,fg=fg)
  axis(1,tcl=0.02,mgp = c(0, .5, 0),las=1,
       las=left.las,
       col.axis=col.axis,
       xlog=xlog,
       ylog=ylog,
       family=family.axis,
       )
  axis(2,tcl=0.02,mgp = c(0, .5, 0),las=1,
       las=left.las,
       col.axis=col.axis,
       xlog=xlog,
       ylog=ylog,
       family=family.axis,
       )

  #draw legend first so it is in the background
  if(length(legend.labels)<trts) {
    legend.labels <- c(legend.labels, as.character((length(legend.labels)+1):trts))
    #legend.labels <- c(legend.labels, trt.levels)
  }
  if(show.legend) {
    current.family = par("family")
    par(family=family.legend)
    legend((min.x+(legend.x*(max.x-min.x))), 
           (min.y+(legend.y*(max.y-min.y))), 
           pch=trt.pch, 
           legend=legend.labels,
           #family=family.legend,
           text.font=style.legend,
           ncol = legend.columns,
           col = trt.colors)
    par(family=current.family)
  }
  
  #text(means.vector[1],min.y+(max.y-min.y)/6,names(means.vector[1]),srt=90)
  
  if(regression) {
    if(poly==1) {
      trt.lm <- lm(values ~ trial.mean,trt.data)
      sum.lm <- summary(trt.lm)
      trt.coef <- sum.lm$coefficients
      abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])
      ret.fit$Slope[1] = trt.coef[2]
      ret.fit$Intercept[1] = trt.coef[1,1]
      ret.fit$R2[1] = sum.lm$r.squared
      ret.fit$AdjR2[1] = sum.lm$adj.r.squared
      ret.fit$PSlope[1] = sum.lm$coefficients[2,4]
      
      #fit trial adjusted means
      fw.lm <- lm(centered ~ trial.mean, trt.data)
      sum.fw <- summary(fw.lm)
      fw.coef <- sum.fw$coefficients
      ret.fit$b[1] = fw.coef[2,1]
      ret.fit$Pb[1] = fw.coef[2,4]
      ret.fit$bR2[1] = sum.fw$r.squared
    } else {
      trt.lm <- lm(values ~ trial.mean + I(trial.mean^2),trt.data)
      sum.lm <- summary(trt.lm)
      trt.coef <- sum.lm$coefficients
      lines(sort(trt.data$trial.mean), fitted(trt.lm)[order(trt.data$trial.mean)], lty=1,lwd=plot.lwd,col=trt.colors[1]) 
      #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])
      ret.fit$Slope[1] = trt.coef[2]
      ret.fit$Intercept[1] = trt.coef[1]
      ret.fit$R2[1] = sum.lm$r.squared
      ret.fit$AdjR2[1] = sum.lm$adj.r.squared 
    }
    
    if(inverse.regression) {
      xy.lm <- lm(trial.mean ~ values,trt.data)
      lines(predict(xy.lm), trt.data$values,lty=1,lwd=plot.lwd, col=trt.colors[1])
    }
    if(pc.regression) {
      xy.pc <- prcomp(trt.data[,c(6,1)])
      transformed <- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])
      transformed <- scale (transformed, center = -xy.pc$center, scale = FALSE)
      #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])
      lines(transformed, col = "gray", cex = 0.5)
      points(transformed, pch=trt.pch[1],col=trt.colors[1], cex = 0.5)
    }
    if(segments) {
      segments (trt.data[,6],trt.data[,1], transformed[,1], transformed[,2])
    }
  }
  
  for(trt in 2:trts) {
    plot.lwd = lwd
    plot.cex = cex
    if(trt %in% highlight) {
      plot.lwd = 1.5*lwd*hcex
      if(highlight.point) {
        plot.cex = plot.cex*hcex*0.8
      }
    }
    trt.data <- subset(means.table,means.table$TrtNo==trt)
    trt.data <- subset(trt.data,!is.na(trt.data$values))
    
    ret.fit$Mean[trt] = mean(trt.data$values,na.rm=TRUE)
    ret.fit$SD[trt] = sd(trt.data$values,na.rm=TRUE)
    
    trt.idx = as.numeric(trt)
    current.pch <- trt.pch[trt.idx]
    points(values ~ trial.mean,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,cex=plot.cex)
    if(regression) {
      if(poly==1) {
        trt.lm <- lm(values ~ trial.mean,trt.data)
        #trt.coef <- coef(trt.lm)
        sum.lm <- summary(trt.lm)
        trt.coef <- sum.lm$coefficients
        abline(trt.coef[1],trt.coef[2],lty=as.numeric(trt),col=trt.colors[trt],lwd=plot.lwd)
        ret.fit$Slope[trt] = trt.coef[2,1]
        ret.fit$Intercept[trt] = trt.coef[1,1]
        ret.fit$R2[trt] = sum.lm$r.squared
        ret.fit$AdjR2[trt] = sum.lm$adj.r.squared
        ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]
        
        #fit trial adjusted means
        fw.lm <- lm(centered ~ trial.mean, trt.data)
        sum.fw <- summary(fw.lm)
        fw.coef <- sum.fw$coefficients
        ret.fit$b[trt] = fw.coef[2,1]
        ret.fit$Pb[trt] = fw.coef[2,4]
        ret.fit$bR2[trt] = sum.fw$r.squared
        
      } else {
        trt.lm <- lm(values ~ trial.mean + I(trial.mean^2),trt.data)
        sum.lm <- summary(trt.lm)
        trt.coef <- sum.lm$coefficients
        lines(sort(trt.data$trial.mean), fitted(trt.lm)[order(trt.data$trial.mean)], lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt]) 
        #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])
        ret.fit$Slope[trt] = trt.coef[2,1]
        ret.fit$Intercept[trt] = trt.coef[1,1]
        ret.fit$R2[trt] = sum.lm$r.squared
        ret.fit$AdjR2[trt] = sum.lm$adj.r.squared 
        ret.fit$PSlope[trt] = sum.lm$coefficients[2,4]
      }
    }
    if(inverse.regression) {
      xy.lm <- lm(trial.mean ~ values,trt.data)
      inv.coef <- xy.lm$coefficients
      abline(-(inv.coef[1]/inv.coef[2]),(1/inv.coef[2]),lty=as.numeric(trt),lwd=plot.lwd,col=trt.colors[trt])
      #lines(predict(xy.lm), trt.data$values, lty=as.numeric(trt), lwd=plot.lwd, col=trt.colors[trt])
    }
    if(pc.regression) {
      xy.pc <- prcomp(trt.data[,c(6,1)])
      transformed <- xy.pc$x[,1] %*% t(xy.pc$rotation[,1])
      transformed <- scale (transformed, center = -xy.pc$center, scale = FALSE)
      #abline(trt.coef[1],trt.coef[2],lty=1,lwd=plot.lwd,col=trt.colors[1])
      lines(transformed, col = "gray", cex = 0.5)
      points(transformed, pch=trt.pch[trt],col=trt.colors[trt], cex = 0.5)
    }
    if(segments) {
      segments (trt.data[,6],trt.data[,1], transformed[,1], transformed[,2])
    }
  }
  
  if(length(mark.int)>0) {
    for(idx in 1:length(mark.int)) {
      pair <- mark.int[[idx]]
      trt <- pair[1]
      trial <- pair[2]
      y <- means.matrix[trial,trt]
      x <- means.vector[trial]
      current.pch <- trt.pch[trt]
      #points(x,y,trt.data,pch=current.pch,col=trt.colors[trt],lwd=plot.lwd,)
      points(x,y,cex=plot.cex*2)
    }
  }
  
  if(plot.unity) {
    abline(0,1,col="gray",lwd=2)
    if(length(tukey.coeffs)>0) {
      max.a <- max(ret.fit$Mean)-mean(ret.fit$Mean)
      min.a <- min(ret.fit$Mean)-mean(ret.fit$Mean)
      abline(tukey.coeffs[1], (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dashed")
      abline(tukey.coeffs[1], (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dashed")
      #abline(tukey.coeffs[2]*max.a, (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")
      #abline(tukey.coeffs[2]*min.a, (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")
      abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 + tukey.coeffs[2]*max.a),col="gray",lwd=2,lty="dotted")
      abline(tukey.coeffs[2]*mean(ret.fit$Mean), (1 + tukey.coeffs[2]*min.a),col="gray",lwd=2,lty="dotted")
    }
  }
  return(list(data=means.table,fit=ret.fit))
}

plot.clusters.ARMST <- function(means.matrix, 
                                means.vector, 
                                xlab="", 
                                ylab="",
                                main="",
                                col.axis="black",
                                col.lab="black",
                                col.main="black",
                                col.sub="black",
                                fg="black",
                                bg="white",
                                xlog=FALSE,
                                #style.lab=1,
                                #style.axis=1,
                                #family.lab="",
                                family.axis="",
                                pt.lab=12,
                                pt.axis=12,
                                cex=1.0,
                                verbose=FALSE,
                                method="complete",
                                fixed.prop=FALSE,
                                cld=c(),
                                leaf.colors=c(),
                                plot.names=c(),
                                add=FALSE,
                                reference=NULL,
                                cutoff=1.25) {
  
  means.hc <- hclust(dist(means.matrix),method=method)
  ref.hc <- NULL
  has.ref <- !is.null(reference)
  matched.idx <- NULL
  if(has.ref) {
    ref.hc <- hclust(dist(reference),method=method)
    matched.idx <- compare.merges(means.hc$merge,ref.hc$merge)
  }
  wt = 2
  
  #determine clusters
  x.clfl<-means.hc$height
  #assign the fusion levels
  x.clm<-mean(x.clfl)
  #compute the means
  x.cls<-sqrt(var(x.clfl))
  #compute the standard deviation
  x.score <- ((x.clfl-x.clm)/x.cls)
  #Mojena(1977)2.75<k<3.5
  #Milligan and Cooper (1985) k=1.25
  extra <- x.score[x.score<cutoff]
  clusters <- cutree(means.hc,h=x.clfl[length(extra)-1])
  
  if(length(leaf.colors)==0) {
    cols <- rainbow(max(clusters))
    leaf.colors = cols[clusters]
  } else if (length(leaf.colors)<length(clusters)) {
    leaf.colors = leaf.colors[clusters]
  }
  
  min.x <- min(means.vector,na.rm=TRUE)
  max.x <- max(means.vector,na.rm=TRUE)
  
  if(fixed.prop) {
    min.y <- min(means.matrix,na.rm=TRUE)
    max.y <- max(means.matrix,na.rm=TRUE)
    min.x <- min(c(min.x,min.y))
    max.x <- max(c(max.x,max.y))
  }
  
  min.hc.y <- min(means.hc$height)
  max.hc.y <- max(means.hc$height)
  min.hc.y <- 0
  #print(min.hc.y)
  base <- max.hc.y
  ceiling <- min.hc.y

  #add space
  required.height = max.hc.y

  max.hc.y = max.hc.y+0.2*required.height
  min.hc.y = 0-0.2*required.height

  #if we want to include cld, change required height
  if(length(cld)>0) {
    max.hc.y = max.hc.y+0.3*required.height
  }
  if(!add) {
    plot(1, type="n", axes=F, xlab=xlab, ylab=ylab,
         xlim=c(min.x,max.x), ylim=c(min.hc.y,max.hc.y),cex=cex,
         col.axis=col.axis,
         col.lab=col.lab,
         col.main=col.main,
         xlog=xlog
         #font.lab=style.axis,font.lab=style.axis,
         #family=family.axis
    )
    
    label.cex = cex
    if(length(cld)>0) {
      label.cex = cex*0.9
    }
    if(length(leaf.colors)<length(means.vector)) {
      leaf.colors <- c(leaf.colors,rep(col.axis,length(means.vector)-length(leaf.colors)))
    }
    for(trial in 1:length(means.vector)) {
      n.text = as.character(trial)
      if(length(plot.names)>0) {
        n.text <- plot.names[trial]
      }
      text(means.vector[trial],base+0.08*required.height,n.text,col=leaf.colors[trial],family=family.axis,cex=label.cex)
    }
    if(length(cld)>0) {
      for(l in 1:length(cld)) {
        text(means.vector[l],base+0.28*required.height,cld[l],col=col.axis,family=family.axis,cex=label.cex*0.8)
      }
    }
  }
  
  rows <- dim(means.hc$merge)[1]
  endpoints <- matrix(0,nrow=rows,ncol=4)
  
  #plot horizontal lines
  max.plotted.y = 0
  for (row in 1:rows) {
    current.pair <- means.hc$merge[row,]
    current.distance <- means.hc$height[row]
  
    y <- c(current.distance,current.distance)

    x <- hc.xpoints(row, means.hc, means.vector)
    #print(x) #x's look correct
    y <- base - y #+ (base/10)
    #print(y)
    if(max(y)>max.plotted.y) {
      max.plotted.y <- max(y)
    }
    endpoints[row,1] <- x[1]
    endpoints[row,2] <- y[1]
    endpoints[row,3] <- x[2]
    endpoints[row,4] <- y[2]
    plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)
    if(has.ref) {
      if(matched.idx[row] == 0) {
        current.clfl<-means.hc$height[row]
        #compute the standard deviation
        x.score <- (current.clfl/x.cls) 
        
        #ratio = x.score #means.hc$height[row]/ref.hc$height[matched.idx[row]]
        #if((ratio>3) || (ratio<0.3)) {
        if(x.score>cutoff) {
          mid <- c(x[1]+(x[2]-x[1])/2,y[1])
          #points(xy.coords(x,y))
          plot.xy(xy.coords(mid[1],mid[2]),type="p",lwd=wt,col=fg)
        }
      }
      #means.hc$height
      #res3$means.hc$height
      #ref.hc$height[matched.idx]
    }
  }
  
  if(verbose) {
    print("endpoints")
    print(endpoints)
  }
  for (row in 2:rows) {
    current.pair <- means.hc$merge[row,]    
    x <- c(endpoints[row,1],endpoints[row,1])
    #scan for crossing point
    inner.row = row-1
    x.bound = endpoints[row,1]
    while(inner.row>1) {
      if( (endpoints[inner.row,1]<x.bound && endpoints[inner.row,3]>x.bound)  ||
        (endpoints[inner.row,1]>x.bound && endpoints[inner.row,3]<x.bound) ) {
        #this point is on either side of our x, so we will
        #cross this line
        break;
      }
      inner.row = inner.row-1
    }

    y <- c(endpoints[row,2],endpoints[inner.row,2])
    plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)
    
    x <- c(endpoints[row,3],endpoints[row,3])
    inner.row = row-1
    x.bound = endpoints[row,3]
    while(inner.row>1) {
      if((endpoints[inner.row,1]<x.bound && endpoints[inner.row,3]>x.bound) ||
           endpoints[inner.row,1]>x.bound && endpoints[inner.row,3]<x.bound) {
        #this point is on either side of our x, so we will
        #cross this line
        break;
      }
      inner.row = inner.row-1
    }
    
    y <- c(endpoints[row,4],endpoints[inner.row,4])
    plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)
  }
  
  for(trial in 1:length(means.vector)) {
    x = c(means.vector[trial],means.vector[trial])
    y = c(max.plotted.y, base-0.04*required.height) #c(max.plotted.y, base+0.06*required.height)
    plot.xy(xy.coords(x,y),type="l",lwd=wt,col=fg)
  }

  return(list(means.hc=means.hc,
         clusters=clusters,
         score=x.score,
         cls = x.cls
         ))
}

hc.midpoint <- function(row, hc, means) {
  hc.pair <- hc$merge[row,]
  x1 <- 0
  x2 <- 0
  if(hc.pair[1]>0) {
    x1 <- hc.midpoint(hc.pair[1],hc,means)
  } else {
    x1 <- means[-hc.pair[1]]
  }
  if(hc.pair[2]>0) {
    x2 <- hc.midpoint(hc.pair[2],hc,means)
  } else {
    x2 <- means[-hc.pair[2]]
  }
  return((x1+x2)/2)
}

hc.xpoints <- function(row, hc, means) {
  hc.pair <- hc$merge[row,]
  x1 <- 0
  x2 <- 0
  if(hc.pair[1]>0) {
    x1 <- hc.midpoint(hc.pair[1],hc,means)
  } else {
    x1 <- means[-hc.pair[1]]
  }
  if(hc.pair[2]>0) {
    x2 <- hc.midpoint(hc.pair[2],hc,means)
  } else {
    x2 <- means[-hc.pair[2]]
  }
  return(c(x1,x2))
}


compare.merges <- function(merge1,merge2) {
  dim1 <- dim(merge1)
  dim2 <- dim(merge2)
  matched <- rep(0,dim1[1])
  if(dim1[1]==dim2[1]) {
    for(idx1 in 1:dim1[1]) {
      for(idx2 in 1:dim2[1]) {
        if((merge1[idx1,1]==merge2[idx2,1]) && (merge1[idx1,2]==merge2[idx2,2]) ||
           (merge2[idx2,1]==merge1[idx1,1]) && (merge2[idx2,2])==merge1[idx1,2]) {
          matched[idx1]=idx2
        }
      }
    }
  }
  return(matched)
}











