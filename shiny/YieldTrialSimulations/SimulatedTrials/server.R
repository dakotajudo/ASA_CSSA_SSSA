#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
require(ggplot2)

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#F0E442","#CC79A7","#000000","#734f80", "#2b5a74", "#004f39", "#787221", "#003959", "#6aaf00", "#663cd3")

get.raw.yield <- function() {
  load(file="./fields/SouthwestCorn2013.Rda")
  return(trimmed.dat)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  renderPrint({ input$action })
  
  output$distPlot <- renderPlot({
    print(getwd())
    trimmed.dat <- get.raw.yield()
    ggplot(trimmed.dat, aes(LonM, LatM)) + 
      geom_point(aes(colour = YldVolDry),size=1) + 
      scale_colour_gradient(low=cbPalette[7], high=cbPalette[4]) +
      labs(colour = "Yield (bu/acre)", x="Longitude (m)", y="Latitude (m)", title = "Trimmed Yield Monitor Data")
    
  })
  
})


