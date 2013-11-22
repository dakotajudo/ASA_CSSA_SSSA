cpt.pbal <- do.call(function() {
   load("cpt.rda")
   source("../R/coincidence.matrix.R")
   source("../R/incidence.matrix.R")
   cpt.gy <- subset(cpt.dat,!is.na(cpt.dat$GY))
   cpt.gy <- subset(cpt.gy,cpt.gy$entry != "fill")

   #relevel
   cpt.gy$env <- as.factor(as.character(cpt.gy$env))
   cpt.gy$entry <- as.factor(as.character(cpt.gy$entry))
   
   cpt.inc <- coincidence.matrix(cpt.gy,a.name="entry",b.name="env")

   empty.cells <- which(cpt.inc==0,arr.ind=TRUE)

   trial.replication <- tapply(cpt.gy$GY, c(cpt.gy$env), mean)
   trial.sums <- colSums(cpt.inc)
   empty.trials <- names(which(trial.sums==0))
   nonempty.trials <- levels(cpt.gy$env)[which(trial.sums>0)]
   cpt.gy <- subset(cpt.gy, cpt.gy$env %in% nonempty.trials)
 
   cpt.inc <- coincidence.matrix(cpt.gy,a.name = "entry",b.name="env")
 
   nonempty.rows <- apply(cpt.inc,1,function(x) {!any(x==0)})
   balanced.trt <- names(nonempty.rows[nonempty.rows])
 
   cpt.gy.pbal <- subset(cpt.gy,cpt.gy$entry %in% balanced.trt)
   cpt.gy.pbal$env <- as.factor(as.character(cpt.gy.pbal$env))
   cpt.gy.pbal$entry <- as.factor(as.character(cpt.gy.pbal$entry))
   return (cpt.gy.pbal)
},as.list(c()))

cpt.bal <- do.call(function() {
 
   cpt.gy.pbal <- cpt.pbal

   cpt.inc.pbal <- coincidence.matrix(cpt.gy.pbal,a.name = "entry",b.name="env")
   maxreplicated.trials <- apply(cpt.inc.pbal,2,function(x,reps) {!any(x!=reps)},reps=max(cpt.inc.pbal))
   cpt.gy.bal <- subset(cpt.gy.pbal,cpt.gy.pbal$env %in% names(maxreplicated.trials[maxreplicated.trials]))
   
   #relevel factors
   cpt.gy.bal$env <- as.character(cpt.gy.bal$env)
   cpt.gy.bal$entry <- as.character(cpt.gy.bal$entry)
   cpt.gy.bal$env <- as.factor(cpt.gy.bal$env)
   cpt.gy.bal$entry <- as.factor(cpt.gy.bal$entry)
   
   return(cpt.gy.bal)
},as.list(c()))
