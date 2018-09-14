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

source("../../../ASA_CSSA_SSSA/R/generate.rcb.plans.R")
source("../../../ASA_CSSA_SSSA/R/simulate.plan.R")
source("../../../ASA_CSSA_SSSA/R/trial.dimensions.R")
source("../../../ASA_CSSA_SSSA/R/superimpose.plan.R")

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#F0E442","#CC79A7","#000000","#734f80", "#2b5a74", "#004f39", "#787221", "#003959", "#6aaf00", "#663cd3",
               "#969696", "#E39C00", "#53B1E6", "#006E70", "#004292", "#A55B00", "#e0E439","#C073A1","#060606","#674c80", "#205a71", "#064f36", "#727221", "#003353", "#6aaf06", "#633cd0")

get.raw.yield <- function() {
  load(file="./fields/SouthwestCorn2013.Rda")
  return(trimmed.dat)
}
get.vgm.yield <- function() {
  load(file="./fields/SouthwestCorn2013.vgm.Rda")
  return(trimmed.vgm)
}

cochran.lattice <- function() {
  base.plan <-data.frame(
    trt=as.factor(c(1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10, 11, 11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14, 15, 15, 15, 16, 16, 16, 17, 17, 17, 18, 18, 18, 19, 19, 19, 20, 20, 20, 21, 21, 21, 22, 22, 22, 23, 23, 23, 24, 24, 24, 25, 25, 25)), 
    rep=as.factor(c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3)), 
    blk=as.factor(c(3, 4, 2, 1, 4, 1, 2, 4, 3, 5, 4, 4, 4, 4, 5, 1, 1, 4, 2, 1, 5, 5, 1, 2, 4, 1, 1, 3, 1, 3, 2, 2, 1, 5, 2, 3, 4, 2, 4, 3, 2, 5, 1, 2, 2, 5, 1, 5, 4, 1, 2, 3, 1, 1, 1, 1, 3, 2, 1, 4, 4, 3, 3, 3, 3, 4, 1, 3, 5, 2, 3, 2, 5, 3, 1)), 
    column=as.factor(c(3, 4, 5, 5, 2, 4, 4, 5, 2, 2, 3, 3, 1, 1, 1, 4, 4, 1, 2, 2, 5, 1, 5, 4, 3, 3, 2, 5, 1, 3, 1, 4, 3, 3, 2, 1, 5, 5, 5, 4, 3, 4, 2, 1, 2, 5, 4, 2, 4, 2, 3, 2, 5, 1, 1, 3, 5, 3, 1, 4, 2, 4, 4, 1, 2, 2, 3, 5, 3, 5, 3, 1, 4, 1, 5)), 
    row=c(3, 9, 12, 1, 9, 11, 2, 9, 13, 5, 9, 14, 4, 9, 15, 1, 10, 14, 2, 10, 15, 5, 10, 12, 4, 10, 11, 3, 10, 13, 2, 7, 11, 5, 7, 13, 4, 7, 14, 3, 7, 15, 1, 7, 12, 5, 6, 15, 4, 6, 12, 3, 6, 11, 1, 6, 13, 2, 6, 14, 4, 8, 13, 3, 8, 14, 1, 8, 15, 2, 8, 12, 5, 8, 11), 
    col=c(3, 4, 5, 5, 2, 4, 4, 5, 2, 2, 3, 3, 1, 1, 1, 4, 4, 1, 2, 2, 5, 1, 5, 4, 3, 3, 2, 5, 1, 3, 1, 4, 3, 3, 2, 1, 5, 5, 5, 4, 3, 4, 2, 1, 2, 5, 4, 2, 4, 2, 3, 2, 5, 1, 1, 3, 5, 3, 1, 4, 2, 4, 4, 1, 2, 2, 3, 5, 3, 5, 3, 1, 4, 1, 5)
   )
  class(base.plan) <- c("trial.map",class(base.plan))
  return(base.plan)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  renderPrint({ input$action })
  
  output$distPlot <- renderPlot({
    #print(getwd())
    trimmed.dat <- get.raw.yield()
    ggplot(trimmed.dat, aes(LonM, LatM)) + 
      geom_point(aes(colour = YldVolDry),size=1) + 
      scale_colour_gradient(low=cbPalette[7], high=cbPalette[4]) +
      labs(colour = "Yield (bu/acre)", x="Longitude (m)", y="Latitude (m)", title = "Trimmed Yield Monitor Data")
    
  })
  #output$caption <- renderPrint("pushed")
  #output$value <- "pushed"
  #output$table <- renderTable(iris)
  #output$table <- renderDataTable(iris)
  
  #Code to read design choice and render table

  
  # By declaring datasetInput as a reactive expression we ensure that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers (it 
  #     only executes a single time)
  #
  trialMap <- reactive({
    none="none"
    switch(input$plan,
           "none" = none,
           "RCB" = generate.rcb.plan(input$replicates,input$treatments),
           "Lattice" = cochran.lattice())
  })
  
  # The output$caption is computed based on a reactive expression that
  # returns input$caption. When the user changes the "caption" field:
  #
  #  1) This expression is automatically called to recompute the output 
  #  2) The new caption is pushed back to the browser for re-display
  # 
  # Note that because the data-oriented reactive expressions below don't 
  # depend on input$caption, those expressions are NOT called when 
  # input$caption changes.
  output$caption <- renderText({
    input$caption
  })
  
  # The output$summary depends on the datasetInput reactive expression, 
  # so will be re-executed whenever datasetInput is invalidated
  # (i.e. whenever the input$dataset changes)
  output$summary <- renderPrint({
    rcb.plan = trialMap()
    class(rcb.plan) <- "data.frame"
    trimmed.dat <- get.raw.yield()
    trimmed.vgm <- get.vgm.yield()
    res <- simulate.plan(
      plan=rcb.plan,
      field=trimmed.dat,
      plot.dim=c(4,6),
      buffer.dim=c(1,1),
      sample.vgm=trimmed.vgm
    )
    return(summary(res$aov))
    #dataset <- trialMap()
    #print(dataset)
  })
  
  # The output$view depends on both the databaseInput reactive expression
  # and input$obs, so will be re-executed whenever input$dataset or 
  # input$obs is changed. 
  output$table <- renderTable({
    rcb.plan = trialMap()
    class(rcb.plan) <- "data.frame"
    
    trimmed.dat <- get.raw.yield()
    trimmed.vgm <- get.vgm.yield()
    res <- superimpose.plan(rcb.plan,trimmed.dat,c(1,1),plot.dim=c(4,6),buffer.dim=c(0,0),sample.vgm=trimmed.vgm)
    return(res$plan)
  })
  
  # plotTrials overlays the current RCB plan on the current yield map
  output$trialsPlot <- renderPlot({
    rcb.plan = trialMap()
    if("trial.map" %in% class(rcb.plan)) {
      class(rcb.plan) <- "data.frame"
      #ggplot(rcb.plan, aes(col, row)) + 
      #  geom_point(aes(colour = trt),size = 6) + 
      #  scale_colour_manual(values=cbPalette) +
      #  labs(colour = "Treatment", x="Longitude (m)", y="Latitude (m)")
      
      trimmed.dat <- get.raw.yield()
      trimmed.vgm <- get.vgm.yield()
      res <- superimpose.plan(rcb.plan,trimmed.dat,c(1,1),plot.dim=c(4,6),buffer.dim=c(0,0),sample.vgm=trimmed.vgm)
      plots.dat <- overlay.field(plan=rcb.plan,
                                    field=trimmed.dat,
                                    plot.dim=c(6,4),
                                    buffer.dim=c(1,1),
                                    sample.vgm=trimmed.vgm)
      return(ggplot(plots.dat, aes(LonM, LatM)) + geom_point(aes(colour = trt),size=1) + scale_colour_manual(values=cbPalette) +
        labs(colour = "Treatment", x="Longitude (m)", y="Latitude (m)", title = "Trial Maps"))
      #return(ggplot(res$plan, aes(LonM, LatM)) + geom_point(aes(colour = trt),size=6) + scale_colour_manual(values=cbPalette) +
      #  labs(colour = "Treatment", x="Longitude (m)", y="Latitude (m)", title = "Trial Maps"))
      #return(ggplot(res$plan, aes(LonM, LatM)) + geom_point(aes(colour = YldVolDry),size=6) + 
      #         scale_colour_gradient(low=cbPalette[7], high=cbPalette[4]) +
      #         labs(colour = "Treatment", x="Longitude (m)", y="Latitude (m)", title = "Trial Maps"))
    } else {
      return(NULL)
    }
  })
  
})


