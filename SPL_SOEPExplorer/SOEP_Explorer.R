#################################################

#  Interactive Percentile Plot of 
#  Monthly Net Household Income
#################################################

# Structure:
# 0. Load Packages and Data
# 1. Helper Function
# 2. User Interface
# 3. Server Function
# 4. Run the Application

##################################################

# 0. Load Packages and Data
##################################################

# load packages
if (!require("pacman")) 
  install.packages("pacman"); library("pacman") 

p_load("magrittr", 
       "dplyr", 
       "shiny",
       "plotly",
       "DT",
       "haven")

# Github Repo
setwd("C:/Users/choffmann/Desktop/R/today/SPL-Project/SPL_SOEPExplorer") 
# Data Folder
mypath <- "C:/Users/choffmann/Desktop/Data_R/" 

# read in data
data <- readRDS(paste0(mypath,"data.rds"))

# read in input choices
source("Input_Choices.R")
##################################################

# 1. Helper Function
##################################################

# FindColNumber:
# function to find column number 
# of input variable in data frame
# Arguments:
# - dataframe df
# - name of variable input
# Output:
# - column number of input variable
#   in the specified data frame
#   as numeric value

FindColNumber <- function(df,input){
  as.numeric(which(colnames(df)==input))
}

##################################################

# 2. User Interface
##################################################

UserInterfaceSOEP <- fluidPage(
  titlePanel(title = h1("SOEP Explorer", 
                        align = "center")),
  #layout with main area and side bar
  sidebarLayout( position = "left",
                 sidebarPanel(
                   h3("Specify your selection"),
                   # slide bar + animate
                   sliderInput("year", 
                               "Select a year", 
                               min = 1990, 
                               max = 2016, 
                               value = 2000, 
                               step = 1, 
                               animate = T),
                   # dropdown input selection
                   selectInput("state", 
                               "Select a federal state", 
                               choices = state.choices, 
                               selectize = T),
                   # input choices
                   selectInput("var1", 
                               "Select your x variable", 
                               choices = var.choices),
                   selectInput("var2", 
                               "Select your y variable", 
                               choices = var.choices),
                   selectInput("color", 
                               "Select your color variable", 
                               choices = color.choices),
                   selectInput("var3", 
                               "Do you want to add 
                               a third variable 
                               as a z-axis?", 
                               choices = 
                                 c("No", var.choices))), 
                 mainPanel(
                   plotlyOutput("myhist")
                 )
  )
)

##################################################

# 3. Server Function
##################################################

ServerSOEP <- function(input, output){
  # reactive variable that gives column number 
  # of the variable chosen in the UI
  # get column number of variable 
  # to be plotted on x axis
  colm1 <- reactive({
    FindColNumber(data, input$var1)
  })
  # get column number of variable 
  # to be plotted on y axis
  colm2 <- reactive({
    FindColNumber(data, input$var2)
  })
  # get column number of variable 
  # to be plotted as shape and color
  colmcolor <- reactive({
    FindColNumber(data,input$color)
  })
  # get column number of variable 
  # to be plotted on z axis
  colm3 <- reactive({
    FindColNumber(data,input$var3)
  })
  # get row number of relevant observations
  row <- reactive({
    cond <- as.numeric(!(input$state == "All"))+1
    switch( cond,
            as.numeric(which(data$syear == input$year)),
            as.numeric(which(
              data$syear == input$year 
              & data$state==input$state)))
  })
  # x axis data
  x <- reactive({
    data[row(), colm1()]
  })
  # y axis data
  y <- reactive({
    data[row(), colm2()] 
  })
  # color and shape data
  color <- reactive({
    data[row(), colmcolor()]
  })
  # z axis data
  z <-reactive({
    data[row(), colm3()]
  })
  # range of x value to be held constant over years
  range1 <- reactive({ 
    c(min(data[,colm1()], na.rm = T), 
      max(data[,colm1()], na.rm = T))
  })
  # range of y value to be held constant over years
  range2 <- reactive({ 
    c(min(data[,colm2()], na.rm = T), 
      max(data[,colm2()], na.rm = T))
  })
  # plot data
  output$myhist <- renderPlotly({
    if (input$var3 =="No"){
      plot_ly(x = x(), 
              y = y()) %>%
        add_markers( alpha = 0.5,
                     color = color(), 
                     symbol = color(),
                     symbols = c('circle',"diamond-open",
                                 "square", "triangle-up-dot",
                                 "x-dot", "triangle-down")
                     )%>%
        layout(title = 'Overview of the SOEP',
               xaxis = list(title = input$var1,
                            zeroline = TRUE,
                            range = range1()),
               yaxis = list(title = input$var2,
                            range = range2()))
    } else {
      plot_ly() %>%
        add_trace(x = x(),
                  y = y(),
                  z = z(), 
                  type = "scatter3d", 
                  mode = "markers",
                  opacity = 0.5,
                  size = 0.1,
                  color = color(), 
                  symbol = color(),
                  symbols = c('circle',"diamond-open",
                              "square", "triangle-up-dot",
                              "x-dot", "triangle-down")) %>%
        layout(title = '"3D Scatter plot of your variables"',
               scene = list(xaxis = list(title = input$var1),
                            yaxis = list(title = input$var2),
                            zaxis = list(title = input$var3),
                            camera = list(
                              eye = list(
                                x = 2, 
                                y = -2, 
                                z = 1.25), 
                              zoom = 5),
                            showlegend = TRUE,
                            legend = list(orientation = 'h'))) 
      }
  })
}

##################################################

# 3. Run the Application
##################################################

app <-  shinyApp(ui = UserInterfaceSOEP,
         server = ServerSOEP)
runApp(app)

