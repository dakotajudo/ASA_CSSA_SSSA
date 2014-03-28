plot.matrix <- function(x,colors=NULL, title="Matrix") {
	if(is.null(colors)) {
		col_fun<-colorRampPalette(colors=c('white','black'))
		colors<-col_fun(256)
	}
	x.r <- nrow(x)
	x.c <- ncol(x)
	z <- array(x,dim=c(x.r,x.c))
	image(1:x.r,1:x.c,z, main=title,col=colors,xlab="",ylab="")
}