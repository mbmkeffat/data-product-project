#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Iris data modeled by k-means clustering or decision tree"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       

       selectInput("model_type", "Model type",
                   c("k-means", "decision tree")),
       uiOutput('model'),
       uiOutput('variable')
       
       ),
    
    # Show a plot of the generated distribution
    mainPanel(
       uiOutput('plot')
    )
  )
))
