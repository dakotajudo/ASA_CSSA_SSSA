library(ggplot2)
library(gridExtra)
library(maps)

min.count <- 10

load.if.needed <- function(name){
  need.load = FALSE
  if(exists(name)) {
    #print('does exist')
    if(is.null(get(name))) {
      #print('is null')
      need.load=TRUE
    }
  } else {
    #print('does not exist')
    need.load=TRUE
  }
  if(need.load) {
    #print('loading')
    #print(paste(name,".Rda",sep=""))
    load(file=paste(name,".Rda",sep=""),.GlobalEnv)
  }
}

#from http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

gg.default.theme <- theme_bw()
gg.default.theme$legend.position = "none"

strip.underscores <- function(text) {
   return(gsub("_", " ", text))
} 
mapstates <- c("texas","oklahoma","kansas","nebraska","south dakota","north dakota")

make.map.data <- function(values,regions) {
  states_map <- map_data("county",region=mapstates)
  states_map$statecounty=paste(states_map$region, states_map$subregion,sep=",")
  names(values)<-as.character(regions)
  states_map$values <- NA
  states_map$values <- values[as.character(states_map$statecounty)]
  return(states_map)
}

ggmap.values <- function(values,regions,scale=NA,main=NA,palette=c("red","blue"),legend="mean") {
  states_map <- make.map.data(values,regions)

  ret <- qplot(long, lat, data = states_map, group = group, fill = values,
    geom = "polygon") + 
    #scale_fill_gradient(low=palette[1], high=palette[2]) + 
    #scale_fill_continuous(low=palette[1], high=palette[2]) +
    scale_fill_gradient2(legend,low = palette[1], high = palette[2]) +
   #   midpoint = 0, space = "rgb", na.value = "grey50", guide = "colourbar")
    coord_equal() +
    labs(title = main,xlab="Longitude",ylab="Latitude")
  return(ret)
}

standard.year.plot <- function(dat,palette=cbPalette,method="lm") {
  gg.default.theme <- theme_bw()
  #gg.default.theme$legend.position = "none"

  return(ggplot(dat, aes(Year,Value)) + scale_color_manual(values=palette) +
     geom_point(aes(color=State),size=2,alpha = 0.2) + gg.default.theme +
     geom_smooth(aes(group=State,color=State),weight=10,se = FALSE,method=method)
    )
}

standard.regression.plot <- function(dat,method="lm") {
  gg.default.theme <- theme_bw()
  #gg.default.theme$legend.position = "none"

  return(ggplot(dat, aes(Year,Value)) + scale_colour_brewer(palette="Set1") +
     geom_point(aes(color=statecounty),size=2,alpha = 0.2) + gg.default.theme +
     geom_smooth(aes(group=statecounty,color=statecounty),weight=10,se = FALSE,method=method)
    )
}

map.values <- function(values,regions,scale=NA,main=NA) {
   #are all the values strictly posiive?
   min.value <- min(values,na.rm=TRUE)
   if(min.value>0) {
      values <- values-min.value
   }
   
  if(is.na(scale)) {
    scale <- 1/max(abs(1.01*values))
  }

  norm.values <- values*scale
  pos.values <- norm.values
  neg.values <- -norm.values
  neg.values[neg.values<0] <- 0
  pos.values[pos.values<0] <- 0


  map.colors <- colorRampPalette(c('lightblue','darkblue'))(100)[floor(pos.values*100)+1]
  neg.colors <- colorRampPalette(c('pink','red'))(100)[floor(neg.values*100)+1]
  map.colors[norm.values<0] <-neg.colors[norm.values<0] 
  map("county", regions = regions, col = map.colors, fill = TRUE, lty = 1, lwd= 1)
  map("state", regions = mapstates, col = "black", fill = FALSE, lty = 1, lwd = 1, add=TRUE)
  if(!is.na(main)) {
     title(main)
  }
}

create.index <- function(usda.dat) {
   State <- tolower(as.character(usda.dat$State))
   County <- tolower(as.character(usda.dat$County))
   return(paste(State,County,sep=","))
}

extract.county.estimates <- function(fitted.model,term=1) {
  labels <- attr(fitted.model$terms, "term.labels")
  estimates <- fitted.model$coefficients[fitted.model$assign == term]
  names(estimates) <- fitted.model$xlevels[[1]]
  return(estimates)
}

early.f <- function(year) {
  return((year<1943)&(year>1923))
}
mid.f <- function(year) {
  return((year<1978)&(year>1942))
}
late.f <- function(year) {
  return((year<2015)&(year>1983))
}

