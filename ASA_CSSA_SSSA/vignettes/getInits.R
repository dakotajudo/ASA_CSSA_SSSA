getInits = function() { 

scale = 1.5
SDscale = 4

result = list()

result[["intercept"]] = sign(startingValues[["intercept" ]]) *
    runif(length(startingValues[["intercept" ]]),
       abs(startingValues[["intercept"]])/scale,
       scale * abs(startingValues[["intercept"]]))

result[["betaobservations"]] = sign(startingValues[["betaobservations" ]]) *
    runif(length(startingValues[["betaobservations" ]]),
       abs(startingValues[["betaobservations"]])/scale,
       scale * abs(startingValues[["betaobservations"]]))


result[["SDStrip"]] = sqrt(runif(1,
       startingValues$vars[["Strip"]]/scale,
       startingValues$vars[["Strip"]]*scale))

result[["RStrip"]] = rnorm(length(startingValues[["RStrip"]]),
        startingValues[["RStrip"]], startingValues$vars[["Strip"]]/SDscale)


return(result)

}