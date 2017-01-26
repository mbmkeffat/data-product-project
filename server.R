#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(rpart)
library(rpart.plot)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  require(caret)
  require(ggplot2)
  require(plotly)
  columns <- names(iris)
  data <- reactive({
      data <- iris[, c(input$feature_selection)]
      cluster_result <- kmeans(data, centers=input$k)
      iris['cluster'] <- as.factor(cluster_result$cluster)
      prediction <- table(iris[, c('Species', 'cluster')])
      clusters <- colnames(prediction)[max.col(prediction)]
      clusters <- as.integer(clusters)
      names(clusters) <- row.names(prediction)
      iris['correct_predict'] <- clusters[iris[, 'Species']] == iris[, 'cluster']
      iris
      })
  
  output$irisPlot <- renderPlotly({
    if (input$model_type == 'k-means'){
    iris_data = data()
    accuracy = sum(iris_data[, 'correct_predict'])/dim(iris_data)[1]
    ggplot(iris_data, aes_string(x = input$feature_selection[1], y = input$feature_selection[2], color = 'Species', 
                              shape = 'correct_predict', size = 'correct_predict')) + geom_point() + 
                              ggtitle(paste('Accuracy ', accuracy))
    }
    
    
  })
  
  output$tree <- renderPlot({
    if (input$model_type == 'decision tree'){
      fit <- rpart(Species ~., iris[, c('Species', input$feature_selection)])
      class.pred <- table(predict(fit, type="class"), iris$Species)
      accuracy <- sum(diag(class.pred))/sum(class.pred)
      rpart.plot(fit)
      title(paste('Accuracy ', accuracy))
    } 
  })
  
  output$model <- renderUI({
      if (is.null(input$model_type))
        return()
      switch(input$model_type, 
      "k-means" = sliderInput("k", label = "Number of cluster", min=3, max=5, step = 1, value=3),
      "decision tree" = " "
      )
    
  })
  output$variable <- renderUI({
    if (is.null(input$model_type)) {return()}
    checkboxGroupInput("feature_selection", "Feature selection", 
                       c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"), selected = c("Sepal.Length", "Sepal.Width"))
  })
  
  output$plot <- renderUI({
    if (is.null(input$model_type)) {return()}
    switch(input$model_type, 
           "k-means" = plotlyOutput("irisPlot"),
           "decision tree" = plotOutput('tree'))
  })
})
