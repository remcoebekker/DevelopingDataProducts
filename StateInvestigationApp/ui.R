#
# This is the user-interface definition of my Shiny web application "Investigating state data".
#

library(shiny)
library(plotly)
library(datasets)

shinyUI(fluidPage(
  ## Application title
  titlePanel("Investigating state data"),
  p("With this app you can investigate the state dataset that is part of the datasets package. In the left panel you can choose an x and y variable which are columns in the state.x77 dataset. In the right hand panel a scatterplot is created of the selected columns. Furthermore a simple regression line is created in the plot. In the left panel you can also enter a x value for which in the right hand panel a prediction value is calculated based on the simple linear regression model. In the right panel also a map of the US is shown. If you hover over a state the info that is shown is dependent on the x and y variables selected."),
  sidebarLayout(
      ## Sidebar with 2 dropdown boxes with the variables in the state.x77 dataset and 
      ## a text field where the user can enter a x value for which a prediction needs to be calculated.
      sidebarPanel(
        selectInput("xVar", "x variable", colnames(state.x77), selected = "Illiteracy"),
        selectInput("yVar", "y variable", colnames(state.x77), selected = "Income"),
        textInput("xValue", "x value for prediction", 2)),
  
      ## The main panel shows a graph, the calculated prediction value and a states map.
      mainPanel(
       plotOutput("stateVarsPlot"),
       h5("The predicted y value for the entered x value"),
       textOutput("yPredictionValue"),
       plotlyOutput("statesMap")
    )
  )
)
)