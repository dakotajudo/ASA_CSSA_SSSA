library(ggplot2)
library(gridExtra)
library(maps)

#from http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

gg.default.theme <- theme_bw()
gg.default.theme$legend.position = "none"

strip.underscores <- function(text) {
   return(gsub("_", " ", text))
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

mapstates <- c("texas","oklahoma","kansas","nebraska","south dakota","north dakota")