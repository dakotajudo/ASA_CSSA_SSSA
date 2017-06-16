#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Yield Simulations"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "field_source",
                  label = "Select Field",
                  choices = c("SW Corn"),
                  selected = 1),
      selectInput(inputId = "plan",
                               label = "Select Plan",
                               choices = c("none", "RCB","Lattice"),
                               selected = 1),
      selectInput(inputId = "analysis",
                               label = "Select Analysis",
                               choices = c("none", "RCB","Lattice"),
                               selected = 1),
      numericInput("treatments", label = h3("Treatments"), value = 1), hr(),
        fluidRow(column(3, verbatimTextOutput("treatments"))),
      numericInput("replicates", label = h3("Replicates"), value = 1), hr(),
        fluidRow(column(3, verbatimTextOutput("replicates"))),
      actionButton("action", label = "Action"), hr(),
        fluidRow(column(2, verbatimTextOutput("value"))),
      textInput("text", label = h3("Text input"), value = "Enter text..."),
         hr(),
         fluidRow(column(3, verbatimTextOutput("value")))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))

