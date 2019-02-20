#
# This is the server logic of my Shiny web application "Investigating state data".
#

library(shiny)
library(ggplot2)
library(plotly)

shinyServer(function(input, output) {
    ## The model function creates a simple linear model of the x and y variables selected by the user.
    model <- reactive({
        if (!is.na(input$xVar) & !is.na(input$yVar) & !(input$xVar == input$yVar)) {
            formula <- formula(paste("`", input$yVar, "`~`", input$xVar, "`", sep = ""))
            lm(formula = formula, data = as.data.frame(state.x77))
        }
    })
  
    ## The prediction function uses the model function to calculate a prediction for the x value enterd
    ## by the user.
    prediction <- reactive({
        mod <- model()
        if (!is.null(mod)) {
            df <- data.frame(as.numeric(input$xValue))
            names(df) <- input$xVar
            predict(mod, newdata = df)
        }
    })
  
    ## A graph is created of the x and y variables selected by the user.
    ## When available the simple linear model line is drawn as well as a horizontal and vertical line
    ## of the x value entered by the user and the predicted y value.
    output$stateVarsPlot <- renderPlot({
      q <- qplot(state.x77[, input$xVar], state.x77[, input$yVar], xlab = input$xVar, ylab = input$yVar, color = "red")
      mod <- model()
      
      if (!is.null(mod)) {
        pred <- prediction()
        q <- q + geom_abline(intercept = mod$coefficients[1], slope = mod$coefficients[2])
        q <- q + geom_hline(yintercept = pred, colour = "blue")
        q <- q + geom_vline(xintercept = as.numeric(input$xValue), colour = "blue")
      }
      
      q
  })
 
    ## The prediction function is used to calculate the prediction for the x value entered by the user.
    output$yPredictionValue <- renderText({
      pred <- prediction()
      if (!is.null(pred)) {
          pred
      }
      else {
          return("Prediction value could not be calculated!")
      }
    })
  
    ## A map of the states is shown and depending on the x and y variable selected by the user the 
    ## hover info per state is changed to show the values for the x and y variable in the hover info.
    output$statesMap <- renderPlotly({
      ## Specify some map projection/options
      g <- list(
          scope = 'usa',
          projection = list(type = 'albers usa'),
          lakecolor = toRGB('white')
      )
    
      ## Put together the hover text based on tbe variables selected by the user.  
      hover <- paste(rownames(state.x77), "<br>", input$xVar, ":", state.x77[,input$xVar], "<br>", input$yVar, ":", state.x77[,input$yVar])
      
      ## Create the choropleth.
      plot_ly(z = state.area, text = hover, locations = state.abb, hoverinfo = "text",
              type = 'choropleth', locationmode = 'USA-states') %>%
          layout(geo = g)
    })  
 })
